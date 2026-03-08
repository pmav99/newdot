-- https://github.com/chrisgrieser/.config/blob/a5ea494c4809d0446cfb49c042ca5ed7dd8628dd/nvim/lua/plugins/bulk-processing.lua
return { -- refactoring utilities
  "ThePrimeagen/refactoring.nvim",
  dependencies = { "nvim-lua/plenary.nvim", "nvim-treesitter/nvim-treesitter" },
  opts = true,
  keys = {
    -- stylua: ignore start
    -- { "<leader>fi", function() require("refactoring").refactor("Inline Variable") end, mode = { "n", "x" }, desc = "󱗘 Inline Var" },
    -- { "<leader>fe", function() require("refactoring").refactor("Extract Variable") end, mode = "x", desc = "󱗘 Extract Var" },
    -- { "<leader>fu", function() require("refactoring").refactor("Extract Function") end, mode = "x", desc = "󱗘 Extract Func" },
    { "<leader>fe", function() require("refactoring").refactor("Extract Function") end, mode = "x", desc = "󱗘 Extract Func" },
    -- stylua: ignore end
  },
}
