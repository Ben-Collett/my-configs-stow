return {
  "josstei/whisk.nvim",

  opts = {
    cursor = {
      duration = 150,
      easing = "ease-out",
      enabled = true,
    },
    scroll = {
      duration = 200,
      easing = "ease-in-out",
      enabled = true,
    },
    keymaps = {
      cursor = false,
      scroll = true,
    },
  },
  config = function(_, opts)
    local whisk = require("whisk")
    whisk.setup(opts)
    whisk.disable()
    vim.keymap.set("n", "<leader>sc", whisk.toggle)

    local orchestrator = require("whisk.engine.orchestrator")

    local normal_motions = {
      { key = "h", id = "basic_h" },
      { key = "j", id = "basic_j" },
      { key = "k", id = "basic_k" },
      { key = "l", id = "basic_l" },
      { key = "0", id = "basic_0" },
      { key = "$", id = "basic_$" },
      { key = "gg", id = "line_gg" },
      { key = "go", id = "line_gg" },
      { key = "G", id = "line_G" },
      { key = "|", id = "line_|" },
    }
    for _, m in ipairs(normal_motions) do
      vim.keymap.set("n", m.key, function()
        orchestrator.execute(m.id, { count = vim.v.count1, direction = m.key })
      end)
    end

    local visual_motions = {
      { key = "h", id = "basic_h" },
      { key = "j", id = "basic_j" },
      { key = "k", id = "basic_k" },
      { key = "l", id = "basic_l" },
      { key = "0", id = "basic_0" },
      { key = "$", id = "basic_$" },
    }
    for _, m in ipairs(visual_motions) do
      vim.keymap.set("v", m.key, function()
        orchestrator.execute(m.id, { count = vim.v.count1, direction = m.key })
      end)
    end
  end,
}
