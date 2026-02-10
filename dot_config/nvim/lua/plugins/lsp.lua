return {
  "neovim/nvim-lspconfig",
  opts = {
    inlay_hints = { enabled = false },
    setup = {
      html = function(_, opts)
        local util = require("lspconfig.util")
        local root_dir = util.root_pattern("package.json", "node_modules")(vim.fn.getcwd())

        if root_dir then
          local metadata_path = vim.fs.normalize(root_dir .. "/node_modules/angular-three/metadata.json")

          if vim.fn.filereadable(metadata_path) == 1 then
            opts.init_options = vim.tbl_deep_extend("force", opts.init_options or {}, {
              dataPaths = opts.init_options and opts.init_options.dataPaths or {},
            })

            table.insert(opts.init_options.dataPaths, metadata_path)

            opts.handlers = vim.tbl_deep_extend("force", opts.handlers or {}, {
              ["html/customDataContent"] = function(_, result)
                local function exists(name)
                  return type(name) == "string" and vim.loop.fs_stat(name) ~= nil
                end

                if result and result[1] and exists(result[1]) then
                  local ok, content = pcall(vim.fn.readfile, result[1])
                  return ok and table.concat(content, "\n") or ""
                end
                return ""
              end,
            })
          end
        end

        return false
      end,
    },
  },
}
