return {
  "nvim-treesitter/nvim-treesitter-textobjects",
  -- Load when treesitter loads (no need for lazy = true)
  lazy = true,
  config = function()
    -- Only modify the textobjects section, don't call full setup
    require("nvim-treesitter.configs").setup({
      textobjects = {
        select = {
          enable = true,
          lookahead = true,
          keymaps = {
            ["<leader>sf"] = { query = "@function.outer" },
          },
        },
      },
    })
  end,
}
