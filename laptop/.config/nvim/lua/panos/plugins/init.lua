return {
  "nvim-lua/plenary.nvim", -- lua functions that many plugins use
  "carlsmedstad/vim-bicep",
-- Lua
  {
    "folke/zen-mode.nvim",
    opts = {
      window = {
        width = 160,
      },
      -- your configuration comes here
      -- or leave it empty to use the default settings
      -- refer to the configuration section below
    },
  },
  -- { 
  --   "folke/twilight.nvim",
  --   opts = {
  --     context = 20,
  --     expand = { -- for treesitter, we we always try to expand to the top-most ancestor with these types
  --       "function",
  --       "method",
  --       "table",
  --       -- "if_statement",
  --     },
  --   },
  -- },
}
