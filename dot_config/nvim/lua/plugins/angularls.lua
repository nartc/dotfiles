local util = require("lspconfig.util")

return {
  {
    "nvim-treesitter",
    opts = function(_, opts)
      if type(opts.ensure_installed) == "table" then
        vim.list_extend(opts.ensure_installed, { "angular", "scss" })
      end
      vim.api.nvim_create_autocmd({ "BufReadPost", "BufNewFile" }, {
        pattern = { "*.component.html", "*.container.html", "*.ng.html" },
        callback = function()
          vim.treesitter.start(nil, "angular")
        end,
      })
    end,
  },

  -- angularls depends on typescript
  { import = "lazyvim.plugins.extras.lang.typescript" },

  -- LSP Servers
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        angularls = {
          root_dir = util.root_pattern("angular.json", "nx.json"),
        },
      },
      setup = {
        angularls = function(_, opts)
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

          LazyVim.lsp.on_attach(function(client)
            --HACK: disable angular renaming capability due to duplicate rename popping up
            client.server_capabilities.renameProvider = false
          end, "angularls")
        end,
      },
    },
  },

  -- Configure tsserver plugin
  {
    "neovim/nvim-lspconfig",
    opts = function(_, opts)
      LazyVim.extend(opts.servers.vtsls, "settings.vtsls.tsserver.globalPlugins", {
        {
          name = "@angular/language-server",
          location = LazyVim.get_pkg_path("angular-language-server", "node_modules/@angular/language-server"),
          enableForWorkspaceTypeScriptVersions = false,
        },
      })
    end,
  },

  -- formatting
  {
    "conform.nvim",
    opts = function(_, opts)
      if LazyVim.has_extra("formatting.prettier") then
        opts.formatters_by_ft = opts.formatters_by_ft or {}
        opts.formatters_by_ft.htmlangular = { "prettier" }
      end
    end,
  },
}
