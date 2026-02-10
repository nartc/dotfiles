return {
  {
    "vuki656/package-info.nvim",
    ft = "json",
    dependencies = { "MunifTanjim/nui.nvim" },
    config = function()
      require("package-info").setup({
        autostart = false,
        hide_up_to_date = true,
        package_manager = "pnpm",
      })
    end,
    keys = {
      { "<leader>cps", "<cmd>lua require('package-info').show({ force = true })<cr>", desc = "Show package info" },
      { "<leader>cpt", "<cmd>lua require('package-info').toggle()<cr>", desc = "Toggle package info" },
      { "<leader>cpu", "<cmd>lua require('package-info').update()<cr>", desc = "Update package" },
      { "<leader>cpc", "<cmd>lua require('package-info').change_version()<cr>", desc = "Change version" },
    },
  },
}

-- -- Show dependency versions
-- vim.keymap.set({ "n" }, "<LEADER>ns", require("package-info").show, { silent = true, noremap = true })
--
-- -- Hide dependency versions
-- vim.keymap.set({ "n" }, "<LEADER>nc", require("package-info").hide, { silent = true, noremap = true })
--
-- -- Toggle dependency versions
-- vim.keymap.set({ "n" }, "<LEADER>nt", require("package-info").toggle, { silent = true, noremap = true })
--
-- -- Update dependency on the line
-- vim.keymap.set({ "n" }, "<LEADER>nu", require("package-info").update, { silent = true, noremap = true })
--
-- -- Delete dependency on the line
-- vim.keymap.set({ "n" }, "<LEADER>nd", require("package-info").delete, { silent = true, noremap = true })
--
-- -- Install a new dependency
-- vim.keymap.set({ "n" }, "<LEADER>ni", require("package-info").install, { silent = true, noremap = true })
--
-- -- Install a different dependency version
-- vim.keymap.set({ "n" }, "<LEADER>np", require("package-info").change_version, { silent = true, noremap = true })
