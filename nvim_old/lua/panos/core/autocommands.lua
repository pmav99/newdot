-- local opt = vim.opt -- for conciseness

vim.api.nvim_create_autocmd({ 'BufWinEnter' }, {
  -- group = 'userconfig',
  desc = 'Return cursor to where it was last time the file was closed',
  pattern = '*',
  command = 'silent! normal! g`"zv',
})

vim.api.nvim_create_autocmd({ "FileType" }, {
  desc = "Set wrap and spell in markdown and gitcommit",
  pattern = { "gitcommit", "markdown" },
  callback = function()
    vim.opt_local.wrap = true
    vim.opt_local.spell = true
  end,
})

--
-- -- Overwrite indent settings for python and markdown
-- vim.api.nvim_create_autocmd('FileType', {
--   pattern = {
--     'python',
--     'markdown',
--   },
--   callback = function()
--     opt.tabstop = 4       -- 2 spaces for tabs (prettier default)
--     opt.softtabstop = 4   -- The number of spaces that a tab counts for.
--     opt.shiftwidth = 4    -- 2 spaces for indent width
--     opt.expandtab = true  -- expand tab to spaces
--     opt.autoindent = true -- copy indent from current line when starting new one
--   end,
--   desc = 'Set code indents',
-- })
