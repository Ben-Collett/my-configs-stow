return {
  "sindrets/diffview.nvim",
  ependencies = { "lewis6991/gitsigns.nvim" },
  keys = {
    {
      "<leader>gd",
      "<cmd>DiffviewOpen<cr>",
      desc = "Diff since last commit",
    },
    {
      "<leader>gl",
      function()
        local gs = require("gitsigns")
        local blame = gs.get_blame_info()

        if not blame or not blame.commit then
          print("No commit found for this line")
          return
        end

        local commit = blame.commit
        vim.cmd("DiffviewOpen " .. commit .. "..HEAD")
      end,
      desc = "Diff from line's introducing commit to HEAD",
    },
  },
}
