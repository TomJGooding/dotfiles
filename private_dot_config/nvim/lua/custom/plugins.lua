return function(use)
  -- Autopairs
  use({
    "windwp/nvim-autopairs",
    config = function()
      require("nvim-autopairs").setup({})
    end
  })

  -- Show context of currently visible contents
  use({
    "nvim-treesitter/nvim-treesitter-context",
    config = function()
      require("treesitter-context").setup({})
    end
  })

  -- Toggle and persist terminals
  use({
    "akinsho/toggleterm.nvim",
    tag = "*",
    config = function()
      require("toggleterm").setup({
        open_mapping = [[<c-\>]],
        size = 10,
        direction = "horizontal",
        start_in_insert = true,
        close_on_exit = true,
        hide_numbers = true,
      })
    end
  })

  -- Hook non-LSP sources for diagnostics, formatting, code actions etc.
  use({
    "jose-elias-alvarez/null-ls.nvim",
    requires = "nvim-lua/plenary.nvim",
    config = function()
      local augroup = vim.api.nvim_create_augroup("LspFormatting", {})
      require("null-ls").setup({
        -- you can reuse a shared lspconfig on_attach callback here
        on_attach = function(client, bufnr)
          if client.supports_method("textDocument/formatting") then
            vim.api.nvim_clear_autocmds({ group = augroup, buffer = bufnr })
            vim.api.nvim_create_autocmd("BufWritePre", {
              group = augroup,
              buffer = bufnr,
              callback = function()
                vim.lsp.buf.format({ bufnr = bufnr })
              end,
            })
          end
        end,
        sources = {
          -- formatting
          require("null-ls").builtins.formatting.prettierd,
          require("null-ls").builtins.formatting.isort,
          require("null-ls").builtins.formatting.black,
          require("null-ls").builtins.formatting.clang_format,
          -- diagnostics
          require("null-ls").builtins.diagnostics.trail_space,
          require("null-ls").builtins.diagnostics.eslint,
          require("null-ls").builtins.diagnostics.flake8,
          require("null-ls").builtins.diagnostics.mypy,
        },
      })
    end
  })

end
