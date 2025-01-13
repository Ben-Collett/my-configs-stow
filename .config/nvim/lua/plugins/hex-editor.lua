return{ 'RaafatTurki/hex.nvim',
    config = function()

      -- Keymap to toggle hex editor mode with <leader>he
      vim.keymap.set('n', '<leader>he', ':lua require("hex").dump()<CR>', { noremap = true, silent = true })
      vim.keymap.set('n','<leader>hu', ':lua require("hex").assemble()<CR>',{ noremap = true, silent = true })
    end
  }
