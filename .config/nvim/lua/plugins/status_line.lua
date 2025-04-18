return {
  "nvim-lualine/lualine.nvim",
  dependencies = { "nvim-tree/nvim-web-devicons" },
  config = function()
    local palenight = require("lualine.themes.palenight")
    palenight.replace.a.bg = "#C02525"
    palenight.replace.b.fg = "#C02525"
    require("lualine").setup({
      options = {
        icons_enabled = true,
        theme = palenight,
        component_separators = { left = "", right = "" },
        section_separators = { left = "", right = "" },
        disabled_filetypes = {
          statusline = {},
          winbar = {},
        },
        ignore_focus = {},
        always_divide_middle = true,
        always_show_tabline = true,
        globalstatus = false,
        refresh = {
          statusline = 100,
          tabline = 100,
          winbar = 100,
        },
      },
      sections = {
        lualine_a = {
          "mode",
        },
        lualine_b = {
          function()
            if vim.fn.reg_recording() ~= "" then
              return "Recording: " .. vim.fn.reg_recording()
            end
            return ""
          end,
          "branch",
          "diff",
          "diagnostics",
        },
        lualine_c = { "filename" },
        lualine_x = { "encoding", "fileformat", "filetype" },
        lualine_y = { "progress" },
        lualine_z = { "location" },
      },
      inactive_sections = {
        lualine_a = {},
        lualine_b = {},
        lualine_c = { "filename" },
        lualine_x = { "location" },
        lualine_y = {},
        lualine_z = {},
      },
      tabline = {},
      winbar = {},
      inactive_winbar = {},
      extensions = {},
    })
  end,
}
