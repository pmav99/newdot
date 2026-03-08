-- https://github.com/chrisgrieser/.config/blob/a5ea494c4809d0446cfb49c042ca5ed7dd8628dd/nvim/lua/plugins/appearance.lua#L6-L23
return { -- indentation guides
  "lukas-reineke/indent-blankline.nvim",
  event = "UIEnter",
  main = "ibl",
  opts = {
    scope = {
      highlight = { "Comment" },
      show_start = false,
      show_end = false,
    },
    indent = {
      char = "│", -- spaces
      tab_char = "│", -- tabs
    },
    exclude = { filetypes = { "undotree" } },
  },
}
