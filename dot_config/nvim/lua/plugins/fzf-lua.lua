return {
  "ibhagwan/fzf-lua",
  opts = {
    winopts = {
      preview = {
        hidden = "true",
      },
    },
    keymap = {
      builtin = {
        ["<C-a>"] = "toggle-preview",
      },
      fzf = {
        ["ctrl-a"] = "toggle-preview",
      },
    },
  },
}
