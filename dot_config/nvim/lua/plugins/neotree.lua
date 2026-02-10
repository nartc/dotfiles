local preview_state = { win = nil, buf = nil, augroup = nil, image = nil }

local image_extensions = {
  png = true, jpg = true, jpeg = true, gif = true, bmp = true, webp = true, ico = true,
}

local function is_image(filepath)
  local ext = filepath:match("%.([^%.]+)$")
  return ext and image_extensions[ext:lower()]
end

local function close_preview()
  local ps = preview_state
  if ps.augroup then
    pcall(vim.api.nvim_del_augroup_by_id, ps.augroup)
    ps.augroup = nil
  end
  if ps.image then
    pcall(function() ps.image:hide() end)
    ps.image = nil
  end
  if ps.win and vim.api.nvim_win_is_valid(ps.win) then
    vim.api.nvim_win_close(ps.win, true)
  end
  if ps.buf and vim.api.nvim_buf_is_valid(ps.buf) then
    pcall(vim.api.nvim_buf_delete, ps.buf, { force = true })
  end
  ps.win = nil
  ps.buf = nil
end

local function update_preview(node)
  local ps = preview_state
  if not ps.win or not vim.api.nvim_win_is_valid(ps.win) then return end
  if not node or node.type ~= "file" then return end

  local filepath = node:get_id()

  -- Close existing image if switching files
  if ps.image then
    pcall(function() ps.image:hide() end)
    ps.image = nil
  end

  if is_image(filepath) then
    -- Clear buffer and show image
    vim.bo[ps.buf].modifiable = true
    vim.api.nvim_buf_set_lines(ps.buf, 0, -1, false, {})
    vim.bo[ps.buf].modifiable = false
    vim.api.nvim_win_set_config(ps.win, { title = " " .. node.name .. " ", title_pos = "center" })

    -- Render image using snacks
    vim.schedule(function()
      local ok, Image = pcall(require, "snacks.image")
      if ok and Image and Image.placement then
        ps.image = Image.placement.new(ps.buf, filepath, {})
        if ps.image then ps.image:show() end
      end
    end)
  else
    local ok, lines = pcall(vim.fn.readfile, filepath)
    if not ok then return end

    vim.bo[ps.buf].modifiable = true
    vim.api.nvim_buf_set_lines(ps.buf, 0, -1, false, lines)
    vim.bo[ps.buf].modifiable = false

    local ft = vim.filetype.match({ filename = filepath })
    vim.bo[ps.buf].filetype = ft or ""

    vim.api.nvim_win_set_config(ps.win, { title = " " .. node.name .. " ", title_pos = "center" })
  end
end

return {
  {
    "nvim-neo-tree/neo-tree.nvim",
    opts = {
      commands = {
        float_preview = function(state)
          local ps = preview_state

          -- Toggle off if preview exists
          if ps.win and vim.api.nvim_win_is_valid(ps.win) then
            close_preview()
            return
          end

          local node = state.tree:get_node()
          if node.type ~= "file" then return end

          local filepath = node:get_id()
          local buf = vim.api.nvim_create_buf(false, true)

          if not is_image(filepath) then
            local ok, lines = pcall(vim.fn.readfile, filepath)
            if ok then
              vim.api.nvim_buf_set_lines(buf, 0, -1, false, lines)
              local ft = vim.filetype.match({ filename = filepath })
              if ft then vim.bo[buf].filetype = ft end
            end
          end
          vim.bo[buf].modifiable = false

          local padding = 2
          local width = math.floor(vim.o.columns * 0.7)
          local height = vim.o.lines - 4
          local win = vim.api.nvim_open_win(buf, false, {
            relative = "editor",
            width = width,
            height = height,
            col = vim.o.columns - width - padding,
            row = 1,
            style = "minimal",
            border = "rounded",
            title = " " .. node.name .. " ",
            title_pos = "center",
          })

          ps.win = win
          ps.buf = buf

          -- Render image if first file is an image
          if is_image(filepath) then
            vim.schedule(function()
              local ok, Image = pcall(require, "snacks.image")
              if ok and Image and Image.placement then
                ps.image = Image.placement.new(ps.buf, filepath, {})
                if ps.image then ps.image:show() end
              end
            end)
          end

          -- Auto-update on cursor move in neo-tree buffer
          local neotree_buf = vim.api.nvim_get_current_buf()
          ps.augroup = vim.api.nvim_create_augroup("NeoTreeFloatPreview", { clear = true })
          vim.api.nvim_create_autocmd("CursorMoved", {
            group = ps.augroup,
            buffer = neotree_buf,
            callback = function()
              local current_node = state.tree:get_node()
              update_preview(current_node)
            end,
          })

          -- Close preview when neo-tree buffer is closed
          vim.api.nvim_create_autocmd("BufWipeout", {
            group = ps.augroup,
            buffer = neotree_buf,
            callback = close_preview,
          })
        end,
        copy_selector = function(state)
          local node = state.tree:get_node()
          local filepath = node:get_id()
          local filename = node.name
          local modify = vim.fn.fnamemodify

          local vals = {
            ["BASENAME"] = modify(filename, ":r"),
            ["EXTENSION"] = modify(filename, ":e"),
            ["FILENAME"] = filename,
            ["PATH (CWD)"] = modify(filepath, ":."),
            ["PATH (HOME)"] = modify(filepath, ":~"),
            ["PATH"] = filepath,
            ["URI"] = vim.uri_from_fname(filepath),
          }

          local options = vim.tbl_filter(function(val)
            return vals[val] ~= ""
          end, vim.tbl_keys(vals))
          if vim.tbl_isempty(options) then
            vim.notify("No values to copy", vim.log.levels.WARN)
            return
          end
          table.sort(options)
          vim.ui.select(options, {
            prompt = "Choose to copy to clipboard:",
            format_item = function(item)
              return ("%s: %s"):format(item, vals[item])
            end,
          }, function(choice)
            local result = vals[choice]
            if result then
              vim.notify(("Copied: `%s`"):format(result))
              vim.fn.setreg("+", result)
            end
          end)
        end,
      },
      event_handlers = {
        {
          event = "file_opened",
          handler = function()
            close_preview()
            require("neo-tree.command").execute({ action = "close" })
          end,
        },
      },
      filesystem = {
        hijack_netrw_behavior = "open_current",
        follow_current_file = {
          enabled = true,
          leave_dirs_open = false,
        },
      },
      window = {
        position = "current",
        mappings = {
          ["P"] = "float_preview",
          -- Copy absolute path to system clipboard
          ["gy"] = function(state)
            local node = state.tree:get_node()
            local filepath = node:get_id()
            vim.fn.setreg("+", filepath)
            vim.notify("Copied path: " .. filepath)
          end,
          -- Custom paste function (basic example)
          ["gp"] = function(state)
            local clipboard_content = vim.fn.getreg("+")
            local node = state.tree:get_node()
            local target_path = node:get_id()

            if node.type == "file" then
              target_path = vim.fn.fnamemodify(target_path, ":h")
            end

            -- Use system cp command to copy
            local cmd = "cp -r " .. vim.fn.shellescape(clipboard_content) .. " " .. vim.fn.shellescape(target_path)
            vim.fn.system(cmd)
            vim.notify("Pasted: " .. clipboard_content .. " to " .. target_path)

            -- Refresh neo-tree
            require("neo-tree.sources.manager").refresh("filesystem")
          end,
          ["Y"] = "copy_selector",
        },
      },
    },
    keys = function()
      return {
        {
          "<leader>e",
          function()
            require("neo-tree.command").execute({ toggle = true, reveal = true, dir = vim.loop.cwd() })
          end,
          desc = "Explorer NeoTree",
        },
        {
          "<leader>ge",
          function()
            require("neo-tree.command").execute({ source = "git_status", toggle = true })
          end,
          desc = "Explorer Git in NeoTree",
        },
      }
    end,
  },
}
