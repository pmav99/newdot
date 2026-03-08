return {
  "NvChad/nvim-colorizer.lua",
  event = { "BufReadPre", "BufNewFile" },
  --config = true,
  config = function()
    local colorizer = require("colorizer")
    colorizer.setup({
      filetypes = {
        "*", -- Highlight all files, but customize some others.
        python = { names = false }, -- Disable parsing "names" like Blue or Gray
      },
    })
  end,
}
