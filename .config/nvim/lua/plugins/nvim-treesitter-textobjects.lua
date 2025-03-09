return {
  "nvim-treesitter/nvim-treesitter-textobjects",
  config = function()
    require("nvim-treesitter.configs").setup({
      textobjects = {
        select = {
          enable = true,
          lookahead = true,
          keymaps = {
            ["sf"] = "@function.outer",
            ["if"] = "@function.inner",
            -- You can add more text objects here
          },
        },
      },
    })
  end,
}
