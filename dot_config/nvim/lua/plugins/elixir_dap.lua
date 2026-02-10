return {
  {
    "mfussenegger/nvim-dap",
    opts = function()
      local dap = require("dap")

      dap.adapters.mix_task = {
        type = "executable",
        command = vim.fn.stdpath("data") .. "/mason/packages/elixir-ls/debug_adapter.sh", -- path to debugger
        args = {},
      }

      dap.configurations.elixir = {
        {
          type = "mix_task",
          name = "mix test",
          task = "test",
          taskArgs = { "--trace" },
          request = "launch",
          startApps = true, -- for Phoenix apps
          projectDir = "${workspaceRoot}",
          requireFiles = {
            "test/**/test_helper.exs",
            "test/**/*_test.exs",
          },
        },
      }
    end,
    dependencies = {
      "mason-org/mason.nvim",
    },
  },
}
