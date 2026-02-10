-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua
-- Add any additional options here

-- Conditionally disable EditorConfig for specific directories
vim.api.nvim_create_autocmd({ "BufRead", "BufNewFile" }, {
  pattern = "*",
  callback = function()
    local current_dir = vim.fn.expand("%:p:h")
    -- Disable EditorConfig for all nrwl projects
    if vim.startswith(current_dir, "/Users/nartc/code/github/nrwl") then
      vim.b.editorconfig = false
    end
  end,
})

vim.opt.signcolumn = "yes"
vim.opt.scrolloff = 50
vim.opt.colorcolumn = "80"
vim.opt.smartindent = true
vim.opt.expandtab = true
vim.opt.tabstop = 4
vim.opt.softtabstop = 4
vim.opt.shiftwidth = 4
vim.opt.formatoptions:append({ "r" })
vim.opt.winborder = "rounded"

local float = { focusable = true, style = "minimal", border = "rounded" }

vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, float)
vim.lsp.handlers["textDocument/signatureHelp"] = vim.lsp.with(vim.lsp.handlers.signature_help, float)

vim.api.nvim_set_hl(0, "FloatBorder", { fg = "#d8bd92" })

-- add mdx file extension
-- add ag/analog file extension
vim.filetype.add({ extension = { mdx = "mdx", ag = "ag", analog = "analog" } })

vim.treesitter.language.register("vue", "analog")
vim.treesitter.language.register("vue", "ag")

-- Define a custom highlight group for Angular templates
vim.api.nvim_set_hl(0, "AngularTemplate", {
  bold = true,
  bg = "none",
})

-- Link the Treesitter node to the custom highlight group
vim.api.nvim_set_hl(0, "@angular.template", { link = "AngularTemplate" })

-- Store the original LspReferenceText highlight group
local original_lsp_reference_text = vim.api.nvim_get_hl(0, { name = "LspReferenceText" })

local previous_inside_template = false

local function is_inside_angular_template()
  -- Check if the current file type is TypeScript
  if vim.bo.filetype ~= "typescript" then
    return false
  end

  local node = vim.treesitter.get_node()
  while node do
    -- Check if the node is a `template_string` and its parent is a `pair` (key-value pair)
    if node:type() == "template_string" then
      local parent = node:parent()
      if parent and parent:type() == "pair" then
        local key_node = parent:child(0) -- The first child of a `pair` is the key
        if key_node and key_node:type() == "property_identifier" then
          local key_text = vim.treesitter.get_node_text(key_node, 0)
          return key_text == "template"
        end
      end
    end
    node = node:parent()
  end
  return false
end

-- Autocmd to dynamically modify LspReferenceText
vim.api.nvim_create_autocmd({ "CursorMoved", "CursorMovedI" }, {
  pattern = "*.ts",
  callback = function()
    local current_inside_template = is_inside_angular_template()

    if current_inside_template ~= previous_inside_template then
      if current_inside_template then
        -- Disable LspReferenceText for Angular templates
        vim.api.nvim_set_hl(0, "LspReferenceText", { link = "AngularTemplate" })
      else
        -- Restore the original LspReferenceText
        vim.api.nvim_set_hl(0, "LspReferenceText", original_lsp_reference_text)
      end

      previous_inside_template = current_inside_template
    end
  end,
})
