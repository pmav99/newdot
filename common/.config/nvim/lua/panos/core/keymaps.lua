-- set leader key to space
vim.g.mapleader = ","
vim.g.maplocalleader = ","

local keymap = vim.keymap -- for conciseness

---------------------
-- General Keymaps -------------------

--Swap ; and :
keymap.set("n", ";", ":", { desc = "Swap ; and :", noremap = true })

-- use jk to exit insert mode
keymap.set("i", "jk", "<ESC>", { desc = "Exit insert mode with jk" })

-- Some helpers to edit mode : http://vimcasts.org/e/14
keymap.set(
  "c",
  "%%",
  '<C-R>=expand("%:h")."/"<cr>',
  { desc = "Expand directory of the current file to the command line", noremap = true }
)

keymap.set("c", "cwd", "lcd %:p:h", { desc = "Change Working Directory to that of the current file" })

-- Better window navigation
keymap.set("n", "<C-h>", "<C-w>h", { desc = "Move focus to the split right of the current one", noremap = true })
keymap.set("n", "<C-j>", "<C-w>j", { desc = "Move focus to the split left of the current one", noremap = true })
keymap.set("n", "<C-k>", "<C-w>k", { desc = "Move focus to the split above the current one", noremap = true })
keymap.set("n", "<C-l>", "<C-w>l", { desc = "Move focus to the split below the current one", noremap = true })

-- Resize splits with Ctrl + arrows
keymap.set("n", "<C-Up>", ":resize -2<CR>", { desc = "Decrease split size horizontally", noremap = true })
keymap.set("n", "<C-Down>", ":resize +2<CR>", { desc = "Increase split size vertically", noremap = true })
keymap.set("n", "<C-Left>", ":vertical resize -2<CR>", { desc = "Decrease split size horizontally ", noremap = true })
keymap.set("n", "<C-Right>", ":vertical resize +2<CR>", { desc = "Increase split size horizontally", noremap = true })

keymap.set("n", "<leader>sv", "<C-w>v", { desc = "Split window vertically" }) -- split window vertically
keymap.set("n", "<leader>sh", "<C-w>s", { desc = "Split window horizontally" }) -- split window horizontally
keymap.set("n", "<leader>se", "<C-w>=", { desc = "Make splits equal size" }) -- make split windows equal width & height
keymap.set("n", "<leader>sx", "<cmd>close<CR>", { desc = "Close current split" }) -- close current split window

-- buffers
keymap.set("n", "<S-l>", ":bnext<CR>", { desc = "Switch to the next buffer", noremap = true })
keymap.set("n", "<S-h>", ":bprevious<CR>", { desc = "Switch to the previous buffer", noremap = true })
keymap.set("n", "<S-q>", "<cmd>Bdelete!<CR>", { desc = "Close buffer", noremap = true })

-- search-highlights
keymap.set("n", "<leader>/", "<cmd>nohlsearch<CR>", { desc = "Clear search highlights" })

-- Paste
keymap.set("v", "p", "P", { desc = "Paste before, not after the cursor", noremap = true })

-- Comment
keymap.set(
  "n",
  "<leader>c",
  "<cmd>lua require('Comment.api').toggle.linewise.current()<CR>",
  { desc = "Comment current line", noremap = true }
)
keymap.set(
  "x",
  "<leader>c",
  "<esc><cmd>lua require('Comment.api').toggle.linewise(vim.fn.visualmode())<CR>",
  { desc = "Comment selected lines", noremap = true }
)

-- Code folding
keymap.set("n", "<leader>f0", ":set foldlevel=0<CR>", { desc = "Set foldlevel to 0", noremap = true })
keymap.set("n", "<leader>f1", ":set foldlevel=1<CR>", { desc = "Set foldlevel to 1", noremap = true })
keymap.set("n", "<leader>f2", ":set foldlevel=2<CR>", { desc = "Set foldlevel to 2", noremap = true })
keymap.set("n", "<leader>f3", ":set foldlevel=3<CR>", { desc = "Set foldlevel to 3", noremap = true })
keymap.set("n", "<leader>f4", ":set foldlevel=4<CR>", { desc = "Set foldlevel to 4", noremap = true })
keymap.set("n", "<leader>f5", ":set foldlevel=5<CR>", { desc = "Set foldlevel to 5", noremap = true })
keymap.set("n", "<leader>f6", ":set foldlevel=6<CR>", { desc = "Set foldlevel to 6", noremap = true })
keymap.set("n", "<leader>f7", ":set foldlevel=7<CR>", { desc = "Set foldlevel to 7", noremap = true })
keymap.set("n", "<leader>f8", ":set foldlevel=8<CR>", { desc = "Set foldlevel to 8", noremap = true })
keymap.set("n", "<leader>f9", ":set foldlevel=99<CR>", { desc = "Set foldlevel to 99", noremap = true })
keymap.set("n", "<leader>φ0", ":set foldlevel=0<CR>", { desc = "Set foldlevel to 0", noremap = true })
keymap.set("n", "<leader>φ1", ":set foldlevel=1<CR>", { desc = "Set foldlevel to 1", noremap = true })
keymap.set("n", "<leader>φ2", ":set foldlevel=2<CR>", { desc = "Set foldlevel to 2", noremap = true })
keymap.set("n", "<leader>φ3", ":set foldlevel=3<CR>", { desc = "Set foldlevel to 3", noremap = true })
keymap.set("n", "<leader>φ4", ":set foldlevel=4<CR>", { desc = "Set foldlevel to 4", noremap = true })
keymap.set("n", "<leader>φ5", ":set foldlevel=5<CR>", { desc = "Set foldlevel to 5", noremap = true })
keymap.set("n", "<leader>φ6", ":set foldlevel=6<CR>", { desc = "Set foldlevel to 6", noremap = true })
keymap.set("n", "<leader>φ7", ":set foldlevel=7<CR>", { desc = "Set foldlevel to 7", noremap = true })
keymap.set("n", "<leader>φ8", ":set foldlevel=8<CR>", { desc = "Set foldlevel to 8", noremap = true })
keymap.set("n", "<leader>φ9", ":set foldlevel=99<CR>", { desc = "Set foldlevel to 99", noremap = true })
