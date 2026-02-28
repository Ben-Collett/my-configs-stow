return {
  "nvim-treesitter/nvim-treesitter",
  lazy = false,
  build = ":TSUpdate",
  dependencies = { "nvim-treesitter/nvim-treesitter-textobjects" },
  opts = {
    highlight = { enable = true },
    indent = { enable = true },
    auto_install = true,
    ensure_installed = { "diff", "lua", "python", "toml", "regex", "luadoc", "nu", "vim", "dart", "comment" },
    config = function()
      require("nvim-treesitter.configs").setup({
        incremental_selection = {
          enable = true,
          keymaps = {
            init_selection = "gnn", -- set to `false` to disable one of the mappings
            node_incremental = "grn",
            scope_incremental = "grc",
            node_decremental = "grm",
          },
        },
      })
    end,
  },
}
