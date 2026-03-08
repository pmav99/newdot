return {
  "folke/tokyonight.nvim",
  lazy = false,
  priority = 1000,
  config = function()
    vim.cmd([[colorscheme tokyonight-night]])  -- load the colorscheme
  end,
  opts = { },
}
-- return { 
--   "bluz71/vim-nightfly-guicolors",
--   priority = 1000,  -- make sure to load this before any other plugin
--   config = function()
--     vim.cmd([[colorscheme nightfly]])  -- load the colorscheme
--   end,
-- }
