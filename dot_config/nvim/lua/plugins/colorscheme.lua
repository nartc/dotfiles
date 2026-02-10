return {
  "xiantang/darcula-dark.nvim",
  { "EdenEast/nightfox.nvim" },
  { "sainnhe/gruvbox-material" },
  { "Shatur/neovim-ayu" },
  { "Mofiqul/vscode.nvim" },
  { "rebelot/kanagawa.nvim" },
  {
    "LazyVim/LazyVim",
    opts = {
      colorscheme = "vscode",
      -- colorscheme = "terrafox",
      -- colorscheme = "gruvbox-material",
    },
  },
  {
    "f-person/auto-dark-mode.nvim",
    opts = {
      update_interval = 1000, -- ms
      set_dark_mode = function()
        vim.o.background = "dark"
        vim.cmd("colorscheme vscode")
      end,
      set_light_mode = function()
        vim.o.background = "light"
        vim.cmd("colorscheme vscode")
      end,
    },
  },
}
