return { -- highlighted undo/redos
  "tzachar/highlight-undo.nvim",
  keys = { "u", "U" },
  opts = {
    duration = 400,
    undo = {
      lhs = "u",
      map = "silent undo",
      opts = { desc = "󰕌 Undo" },
    },
    redo = {
      lhs = "U",
      map = "silent redo",
      opts = { desc = "󰑎 Redo" },
    },
  },
}
