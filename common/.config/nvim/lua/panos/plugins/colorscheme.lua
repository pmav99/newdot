return { 
  "bluz71/vim-nightfly-guicolors",
  priority = 1000,  -- make sure to load this before any other plugin
  config = function()
    vim.cmd([[colorscheme nightfly]])  -- load the colorscheme
  end,
}
