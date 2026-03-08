local opt = vim.opt -- for conciseness

opt.fileencoding = "utf-8" -- the encoding written to a file

-- Turn of backups swaps etc
opt.swapfile = false -- create a swap file
opt.backup = false -- create a backup file
opt.writebackup = true -- Create a backup file while saving and remove it afterwards

-- line numbers
opt.relativenumber = true -- show relative line numbers
opt.number = true -- shows absolute line number on cursor line (when relative number is on)

-- line wrapping
opt.wrap = false -- disable line wrapping
opt.whichwrap:append("<,>,[,],h,l") -- keys allowed to move to the previous/next line when the beginning/end of line is reached
opt.scrolljump = 5 -- lines to scroll when cursor leaves screen
opt.scrolloff = 5 -- lines to keep above and below the cursor
opt.sidescroll = 9 -- Number of columns to scroll horizontally
opt.sidescrolloff = 9 -- Number off columns to keep to the left/right of the cursor

-- tabs & indentation
opt.tabstop = 2 -- 2 spaces for tabs (prettier default)
opt.softtabstop = 2 -- The number of spaces that a tab counts for.
opt.shiftwidth = 2 -- 2 spaces for indent width
opt.expandtab = true -- expand tab to spaces
opt.autoindent = true -- copy indent from current line when starting new one

-- search settings
opt.hlsearch = true -- highlight all matches on previous search pattern
opt.ignorecase = true -- ignore case when searching
opt.smartcase = true -- if you include mixed case in your search, assumes you want case-sensitive

-- cursor line
opt.cursorline = true -- highlight the current cursor line

-- appearance
opt.title = true -- Show the name of the file in the buffer
opt.termguicolors = true -- turn on termguicolors for nightfly colorscheme to work
opt.background = "dark" -- colorschemes that can be light or dark will be made dark
opt.signcolumn = "yes" -- show sign column so that text doesn't shift
opt.cmdheight = 2 -- more space in the neovim command line for displaying messages
opt.showmode = false -- we don't need to see things like -- INSERT -- anymore

-- backspace
opt.backspace = "indent,eol,start" -- allow backspace on indent, end of line or insert mode start position

-- clipboard
opt.clipboard:append("unnamedplus") -- use system clipboard as default register

-- split windows
opt.splitright = true -- split vertical window to the right
opt.splitbelow = true -- split horizontal window to the bottom

opt.showtabline = 2 -- Always show tabline

-- Undo
opt.undofile = true -- Persist undos

--vim.opt.clipboard = "unnamedplus"               -- allows neovim to access the system clipboard
--
-- Timeouts
opt.timeout = true
opt.timeoutlen = 500 -- How long to wait for a mapped sequence to complete
