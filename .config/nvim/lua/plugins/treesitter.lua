return {
  "nvim-treesitter/nvim-treesitter",
  lazy = false,
  build = ":TSUpdate",
  opts = {
    highlight = { enable = true },
    indent = { enable = true },
    auto_install = true,
    ensure_installed = { "diff", "lua", "python", "toml", "regex", "luadoc", "nu", "vim", "dart", "comment" },
  },
}
