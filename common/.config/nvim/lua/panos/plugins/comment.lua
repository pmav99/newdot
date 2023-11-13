return {
  "numToStr/Comment.nvim",
  event = { "BufReadPre", "BufNewFile" },
  dependencies = {
    -- "JoosepAlviste/nvim-ts-context-commentstring",
  },
  keys = {
    { "q", mode = { "n", "x" }, desc = " Comment Operator" },
    { "Q", desc = " Append Comment at EoL" },
    { "qo", desc = " Comment below" },
    { "qO", desc = " Comment above" },
  },
  opts = {
    opleader = { line = "q", block = "<Nop>" },
    toggler = { line = "qq", block = "<Nop>" },
    extra = { eol = "Q", above = "qO", below = "qo" },
  },
}


-- keymap.set(
--   "n",
--   "<leader>c",
--   "<cmd>lua require('Comment.api').toggle.linewise.current()<CR>",
--   { desc = "Comment current line", noremap = true }
-- )
-- keymap.set(
--   "x",
--   "<leader>c",
--   "<esc><cmd>lua require('Comment.api').toggle.linewise(vim.fn.visualmode())<CR>",
--   { desc = "Comment selected lines", noremap = true }
-- )
--
