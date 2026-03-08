return {
  "renerocksai/telekasten.nvim",
  dependencies = {
    "nvim-telescope/telescope.nvim",
    "nvim-telekasten/calendar-vim",
  },
  config = function()
    require("telekasten").setup({
      home = vim.fn.expand("~/zettelkasten"), -- Put the name of your notes directory here
    })

    local keymap = vim.keymap -- for conciseness
    -- Launch panel if nothing is typed after <leader>z
    --keymap.set("n", "<leader>zz", "<cmd>Telekasten panel<CR>", { desc = "Open Telekasten panel" })

    -- Most used functions
    keymap.set("n", "<leader>zf", "<cmd>Telekasten find_notes<CR>", { desc = "Find Telekasten notes" })
    keymap.set("n", "<leader>zg", "<cmd>Telekasten search_notes<CR>", { desc = "Search Telekasten notes" })
    keymap.set("n", "<leader>zd", "<cmd>Telekasten goto_today<CR>", { desc = "Goto Telekasten today" })
    keymap.set("n", "<leader>zz", "<cmd>Telekasten follow_link<CR>", { desc = "Follow Telekasten link" })
    keymap.set("n", "<leader>zn", "<cmd>Telekasten new_note<CR>", { desc = "Create Telekasten new note" })
    keymap.set("n", "<leader>zc", "<cmd>Telekasten show_calendar<CR>", { desc = "Show Telekasten Calendar" })
    keymap.set("n", "<leader>zb", "<cmd>Telekasten show_backlinks<CR>", { desc = "Show Telekasten backlinks" })
    keymap.set("n", "<leader>zi", "<cmd>Telekasten insert_img_link<CR>", { desc = "Insert Telekasten image link" })
    keymap.set("i", "<leader>zz", "<cmd>Telekasten insert_link<CR>", { desc = "Insert Telekasten link" })
  end,
}
