return {
  { "marilari88/twoslash-queries.nvim" },
  {
    "neovim/nvim-lspconfig",
    opts = {
      setup = {
        vtsls = function(_, opts)
          opts.on_attach = function(client, bufnr)
            require("twoslash-queries").attach(client, bufnr)
          end
        end,
      },
    },
  },
}
