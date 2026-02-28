return {
  "lukas-reineke/indent-blankline.nvim",
  main = "ibl",
  ---@module "ibl"
  ---@type ibl.config
  opts = {
    indent = {
      char = "│",
    },
    scope = {
      enabled = true,
      highlight = "IblScopePink",
      show_start = false,
      show_end = false,
      include = {
        node_type = {
          python = {
            "class_definition",
            "function_definition",
            "if_statement",
            "for_statement",
            "while_statement",
            "with_statement",
          },

          dart = {
            "class_definition",
            "if_statement",
            "for_statement",
            "while_statement",
            "block",
          },
        },
      },
    },
  },

  config = function(_, opts)
    -- Define a pink highlight for the current scope
    vim.api.nvim_set_hl(0, "IblScopePink", {
      fg = "#ff79c6", -- soft neon pink (Dracula-like)
      -- nocombine = true,
    })

    require("ibl").setup(opts)

    -- Toggle keybinding
    vim.keymap.set("n", "<leader>ti", function()
      vim.cmd("IBLToggle")
    end, { desc = "Toggle indent guides" })
  end,
}
