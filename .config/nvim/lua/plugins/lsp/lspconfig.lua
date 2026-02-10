return {
  "neovim/nvim-lspconfig",
  event = { "BufReadPre", "BufNewFile" },
  dependencies = {
    "hrsh7th/cmp-nvim-lsp",
    { "antosha417/nvim-lsp-file-operations", config = true },
    { "folke/neodev.nvim", opts = {} },
    { "williambonman/mason-lspconfig.nvim" },
  },
  config = function()
    local lspconfig = require("lspconfig")
    -- local default_cap = require("cmp_nvim_lsp").default_capabilities()
    vim.lsp.config("nu", { cmd = { "nu", "--lsp" }, single_file_support = true, filetypes = { "nu" } })
    vim.lsp.enable("nu")
    vim.lsp.config("dartls", {
      flags = {
        allow_incremental_sync = false,
      },
    })
    vim.lsp.enable("dartls")
    -- lspconfig.dartls.setup({
    --   capabilities = default_cap,
    --   flags = { allow_incremental_sync = false },
    --   cmd = { "dart", "language-server", "--protocol=lsp" },
    -- })

    vim.lsp.config("rust_analyzer", {
      cmd = { "rust-analyzer" },
      filetypes = { "rust" },

      -- Automatically detect project roots
      root_dir = vim.fs.dirname(vim.fs.find({ "Cargo.toml", ".git" }, { upward = true })[1]),

      -- Capabilities let the LSP support completion, snippets, etc.
      capabilities = vim.lsp.protocol.make_client_capabilities(),

      settings = {
        ["rust-analyzer"] = {
          cargo = {
            allFeatures = true, -- pick up optional features too
            loadOutDirsFromCheck = true,
          },
          procMacro = {
            enable = true, -- expand procedural macros
          },
          checkOnSave = true,
          inlayHints = {
            enable = true,
            typeHints = true,
            parameterHints = true,
            chainingHints = true,
            closingBraceHints = true,
          },
        },
      },

      -- You can define custom on_attach if you want LSP keymaps or behavior
      on_attach = function(client, bufnr)
        -- Example: enable inlay hints if available
        if client.server_capabilities.inlayHintProvider then
          vim.lsp.inlay_hint.enable(true, { bufnr = bufnr })
        end
      end,
    })
    vim.lsp.enable("rust_analyzer")

    -- import cmp-nvim-lsp plugin
    local cmp_nvim_lsp = require("cmp_nvim_lsp")

    local keymap = vim.keymap

    vim.api.nvim_create_autocmd("LspAttach", {
      group = vim.api.nvim_create_augroup("UserLspConfig", {}),
      callback = function(ev)
        -- Buffer local mappings.
        -- See `:help vim.lsp.*` for documentation on any of the below functions
        local opts = { buffer = ev.buf, silent = true }

        -- set keybinds
        opts.desc = "Show LSP references"
        keymap.set("n", "gr", "<cmd>Telescope lsp_references<CR>", opts) -- show definition, references

        opts.desc = "Go to declaration"
        keymap.set("n", "gD", vim.lsp.buf.declaration, opts) -- go to declaration

        opts.desc = "Show LSP definitions"
        keymap.set("n", "gd", "<cmd>Telescope lsp_definitions<CR>", opts) -- show lsp definitions

        opts.desc = "Show LSP implementations"
        keymap.set("n", "gi", "<cmd>Telescope lsp_implementations<CR>", opts) -- show lsp implementations

        opts.desc = "Show LSP type definitions"
        keymap.set("n", "gt", "<cmd>Telescope lsp_type_definitions<CR>", opts) -- show lsp type definitions

        opts.desc = "See available code actions"
        keymap.set({ "n", "v" }, "<leader>ca", vim.lsp.buf.code_action, opts) -- see available code actions, in visual mode will apply to selection

        opts.desc = "Smart rename"
        keymap.set("n", "<leader>rn", vim.lsp.buf.rename, opts) -- smart rename

        opts.desc = "Show buffer diagnostics"
        keymap.set("n", "<leader>D", "<cmd>Telescope diagnostics bufnr=0<CR>", opts) -- show  diagnostics for file

        opts.desc = "Show line diagnostics"
        keymap.set("n", "<leader>d", vim.diagnostic.open_float, opts) -- show diagnostics for line

        opts.desc = "Go to previous diagnostic"
        keymap.set("n", "[d", vim.diagnostic.goto_prev, opts) -- jump to previous diagnostic in buffer

        opts.desc = "Go to next diagnostic"
        keymap.set("n", "]d", vim.diagnostic.goto_next, opts) -- jump to next diagnostic in buffer

        opts.desc = "Show documentation for what is under cursor"
        keymap.set("n", "K", vim.lsp.buf.hover, opts) -- show documentation for what is under cursor

        opts.desc = "Restart LSP"
        keymap.set("n", "<leader>rs", ":LspRestart<CR>", opts) -- mapping to restart lsp if necessary
      end,
    })

    -- used to enable autocompletion (assign to every lsp server config)
    local capabilities = cmp_nvim_lsp.default_capabilities()
    vim.lsp.config("lua_ls", {
      settings = {
        Lua = {
          runtime = {
            version = "LuaJIT",
          },

          diagnostics = {
            globals = { "vim" },
          },

          workspace = {
            library = {
              vim.env.VIMRUNTIME,
              -- or this if you want *everything*
              -- unpack(vim.api.nvim_get_runtime_file("", true)),
            },
            checkThirdParty = false,
          },

          telemetry = {
            enable = false,
          },
        },
      },
    })
    --
    -- Change the Diagnostic symbols in the sign column (gutter)
    local signs = { Error = " ", Warn = " ", Hint = "󰠠 ", Info = " " }
    for type, icon in pairs(signs) do
      local hl = "DiagnosticSign" .. type
      vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = "" })
    end
  end,
}
