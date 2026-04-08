-------------------------------------------------
------------------- BOOTSTRAP -------------------
-------------------------------------------------
-- Bootstrap the package manager
local function bootstrap_paq()
  local path = vim.fn.stdpath("data") .. "/site/pack/paqs/start/paq-nvim"
  local is_installed = vim.fn.empty(vim.fn.glob(path)) == 0
  if not is_installed then
    vim.fn.system { "git", "clone", "--depth=1", "https://github.com/savq/paq-nvim.git", path }
    vim.cmd.packadd("paq-nvim")
  end
end

bootstrap_paq()
require "paq" {
  -- { "beauwilliams/statusline.lua" },
  { "akinsho/bufferline.nvim" },
  { "antosha417/nvim-lsp-file-operations" },
  { "dstein64/vim-startuptime" },
  { "folke/which-key.nvim" },
  { "hrsh7th/cmp-buffer" }, -- source for text in buffer
  { "hrsh7th/cmp-cmdline" }, -- source for file system paths
  { "hrsh7th/cmp-nvim-lsp" },
  { "hrsh7th/cmp-path" }, -- source for file system paths
  { "hrsh7th/nvim-cmp" },
  { "junegunn/fzf" },
  { "junegunn/fzf.vim" },
  { "kevinhwang91/nvim-ufo" },
  { "kevinhwang91/promise-async" },
  { "neovim/nvim-lspconfig" },
  { "numToStr/Comment.nvim" },
  { "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
  { "nvim-telescope/telescope.nvim", branch = "0.1.x" },
  { "nvim-treesitter/nvim-treesitter", build = ":TSUpdate" },
  { "nvim-tree/nvim-web-devicons" },
  { "okuuva/auto-save.nvim" },
  { "onsails/lspkind.nvim" }, -- vs-code like pictograms
  { "rebelot/kanagawa.nvim" },
  { "savq/paq-nvim" }, -- Let Paq manage itself
  { "nvim-lua/plenary.nvim" },
  { "lambdalisue/vim-suda" },
}

-----------------------------------------------
------------------- OPTIONS -------------------
-----------------------------------------------
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


-----------------------------------------------
------------------- KEYMAPS -------------------
-----------------------------------------------
-- set leader key to space
vim.g.mapleader = ","
vim.g.maplocalleader = ","

local keymap = vim.keymap -- for conciseness

--Swap ; and :
keymap.set("n", ";", ":", { desc = "Swap ; and :", noremap = true })

-- Some helpers to edit mode : http://vimcasts.org/e/14
keymap.set("c", "%%", '<C-R>=expand("%:h")."/"<cr>', { desc = "Expand directory of the current file to the command line", noremap = true })
keymap.set("c", "cwd", "lcd %:p:h",                  { desc = "Change Working Directory to that of the current file" })

-- Better window navigation
keymap.set("n", "<C-h>", "<C-w>h", { desc = "Move focus to the split right of the current one", noremap = true })
keymap.set("n", "<C-j>", "<C-w>j", { desc = "Move focus to the split left of the current one", noremap = true })
keymap.set("n", "<C-k>", "<C-w>k", { desc = "Move focus to the split above the current one", noremap = true })
keymap.set("n", "<C-l>", "<C-w>l", { desc = "Move focus to the split below the current one", noremap = true })

-- buffers
keymap.set("n", "<S-l>", ":bnext<CR>", { desc = "Switch to the next buffer", noremap = true })
keymap.set("n", "<S-h>", ":bprevious<CR>", { desc = "Switch to the previous buffer", noremap = true })
keymap.set("n", "<S-q>", "<cmd>Bdelete!<CR>", { desc = "Close buffer", noremap = true })

-- search-highlights
keymap.set("n", "<leader>/", "<cmd>nohlsearch<CR>", { desc = "Clear search highlights" })

-- Paste
keymap.set("v", "p", "P", { desc = "Paste before, not after the cursor", noremap = true })

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

-- Indenting in visual mode
keymap.set("v", "<", "<gv", { desc = "Reselect previous visual selection after indenting out", noremap = true })
keymap.set("v", ">", ">gv", { desc = "Reselect previous visual selection after indenting in", noremap = true })

-- Formatting, TextMate-style
keymap.set('n', 'Q', 'gqip', { desc = 'Format current paragraph using textwidth' })
keymap.set('v', 'Q', 'gq', { desc = 'Format visually selected text using textwidth' })

-- Keep the cursor in place while joining lines
keymap.set('n', 'J', 'mzJ`z', { desc = 'Join current line with the next while preserving cursor position' })

----------------------------------------------------
------------------- USER COMMANDS ------------------
----------------------------------------------------

----------------------------------------------------
------------------- AUTOCOMMANDS -------------------
----------------------------------------------------
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

vim.api.nvim_create_autocmd('FileType', {
  group = vim.api.nvim_create_augroup('trim_whitespaces', { clear = true }),
  desc = 'Trim trailing white spaces',
  pattern = '*',
  callback = function()
    vim.api.nvim_create_autocmd('BufWritePre', {
      pattern = '<buffer>',
      -- Trim trailing whitespaces
      callback = function()
        -- Save cursor position to restore later
        local curpos = vim.api.nvim_win_get_cursor(0)
        -- Search and replace trailing whitespaces
        vim.cmd([[keeppatterns %s/\s\+$//e]])
        vim.api.nvim_win_set_cursor(0, curpos)
      end,
    })
  end,
})

--------------------------------------------
------------------- LSPs -------------------
--------------------------------------------
-- LSP keybindings on attach
vim.api.nvim_create_autocmd('LspAttach', {
  desc = 'LSP keybindings',
  callback = function(args)
    local bufnr = args.buf
    local opts = { noremap = true, silent = true, buffer = bufnr }

    opts.desc = "Show LSP references"
    keymap.set("n", "gR", "<cmd>Telescope lsp_references<CR>", opts)

    opts.desc = "Go to declaration"
    keymap.set("n", "gD", vim.lsp.buf.declaration, opts)

    opts.desc = "Show LSP definitions"
    keymap.set("n", "gd", "<cmd>Telescope lsp_definitions<CR>", opts)

    opts.desc = "Show LSP implementations"
    keymap.set("n", "gi", "<cmd>Telescope lsp_implementations<CR>", opts)

    opts.desc = "Show LSP type definitions"
    keymap.set("n", "gt", "<cmd>Telescope lsp_type_definitions<CR>", opts)

    opts.desc = "See available code actions"
    keymap.set({ "n", "v" }, "<leader>za", vim.lsp.buf.code_action, opts)

    opts.desc = "Smart rename"
    keymap.set("n", "<leader>rn", vim.lsp.buf.rename, opts)

    opts.desc = "Show buffer diagnostics"
    keymap.set("n", "<leader>D", "<cmd>Telescope diagnostics bufnr=0<CR>", opts)

    opts.desc = "Show line diagnostics"
    keymap.set("n", "<leader>d", vim.diagnostic.open_float, opts)

    opts.desc = "Go to previous diagnostic"
    keymap.set("n", "[d", function() vim.diagnostic.jump({ count = -1 }) end, opts)

    opts.desc = "Go to next diagnostic"
    keymap.set("n", "]d", function() vim.diagnostic.jump({ count = 1 }) end, opts)

    opts.desc = "Restart LSP"
    keymap.set("n", "<leader>rs", ":LspRestart<CR>", opts)
  end,
})

-- Autocompletion capabilities
local cmp_nvim_lsp = require("cmp_nvim_lsp")
local capabilities = cmp_nvim_lsp.default_capabilities()

-- Adding folding capabilities required by nvim-ufo
capabilities.textDocument.foldingRange = {
  dynamicRegistration = false,
  lineFoldingOnly = true,
}

-- Change the Diagnostic symbols in the sign column (gutter)
vim.diagnostic.config({
  signs = {
    text = {
      [vim.diagnostic.severity.ERROR] = " ",
      [vim.diagnostic.severity.WARN] = " ",
      [vim.diagnostic.severity.HINT] = "󰠠 ",
      [vim.diagnostic.severity.INFO] = " ",
    },
  },
})

-- Configure and enable LSP servers
vim.lsp.config('*', {
  capabilities = capabilities,
  position_encoding = 'utf-8',
})

vim.lsp.enable({ 'basedpyright', 'ruff' })

--------------------------------------------------
------------------- Treesitter -------------------
--------------------------------------------------
require("nvim-treesitter.configs").setup {
  -- A list of parser names, or "all" (the listed parsers MUST always be installed)
  ensure_installed = {
    "bash",
    "cmake",
    "cpp",
    "csv",
    "cuda",
    "c",
    "diff",
    "dockerfile",
    "editorconfig",
    "fortran",
    "gitattributes",
    "gitcommit",
    "gitignore",
    "git_config",
    "git_rebase",
    "html",
    "http",
    "java",
    "jinja",
    "jinja_inline",
    "jq",
    "json5",
    "json",
    "lua",
    "make",
    "markdown",
    "markdown_inline",
    "matlab",
    "requirements",
    "psv",
    "python",
    "regex",
    "rst",
    "r",
    "sql",
    "ssh_config",
    "strace",
    "toml",
    "tsv",
    "vimdoc",
    "vim",
    "xml",
    "yaml",
  },

  -- Install parsers synchronously (only applied to `ensure_installed`)
  sync_install = false,

  -- Automatically install missing parsers when entering buffer
  -- Recommendation: set to false if you don't have `tree-sitter` CLI installed locally
  auto_install = true,

  -- List of parsers to ignore installing (or "all")
  ignore_install = { "javascript" },

  ---- If you need to change the installation directory of the parsers (see -> Advanced Setup)
  -- parser_install_dir = "/some/path/to/store/parsers", -- Remember to run vim.opt.runtimepath:append("/some/path/to/store/parsers")!

  highlight = {
    enable = true,

    -- NOTE: these are the names of the parsers and not the filetype. (for example if you want to
    -- disable highlighting for the `tex` filetype, you need to include `latex` in this list as this is
    -- the name of the parser)
    -- list of language that will be disabled
    --disable = { "c", "rust" },
    -- Or use a function for more flexibility, e.g. to disable slow treesitter highlight for large files
    disable = function(lang, buf)
        local max_filesize = 100 * 1024 -- 100 KB
        local ok, stats = pcall(vim.uv.fs_stat, vim.api.nvim_buf_get_name(buf))
        if ok and stats and stats.size > max_filesize then
            return true
        end
    end,

    -- Setting this to true will run `:h syntax` and tree-sitter at the same time.
    -- Set this to `true` if you depend on 'syntax' being enabled (like for indentation).
    -- Using this option may slow down your editor, and you may see some duplicate highlights.
    -- Instead of true it can also be a list of languages
    additional_vim_regex_highlighting = false,
  },

  indent = {
    enable = true,
  },
}

---------------------------------------------------
------------------- Colorscheme -------------------
---------------------------------------------------
local kanagawa = require("kanagawa")
kanagawa.setup({
  compile = true,
  dimInactive = true,
  colors = {
    theme = {
      all = {
        ui = {
          bg_gutter = "none"
        }
      }
    }
  },
  overrides = function(colors)
    local theme = colors.theme
    return {
      TelescopeTitle = { fg = theme.ui.special, bold = true },
      TelescopePromptNormal = { bg = theme.ui.bg_p1 },
      TelescopePromptBorder = { fg = theme.ui.bg_p1, bg = theme.ui.bg_p1 },
      TelescopeResultsNormal = { fg = theme.ui.fg_dim, bg = theme.ui.bg_m1 },
      TelescopeResultsBorder = { fg = theme.ui.bg_m1, bg = theme.ui.bg_m1 },
      TelescopePreviewNormal = { bg = theme.ui.bg_dim },
      TelescopePreviewBorder = { bg = theme.ui.bg_dim, fg = theme.ui.bg_dim },
    }
  end,
})
kanagawa.load("wave")

-- LSP semantic token overrides
-- Unlink generic LSP tokens that trample treesitter highlighting
vim.api.nvim_set_hl(0, '@lsp.type.string', {})
vim.api.nvim_set_hl(0, '@lsp.type.variable.python', {})
vim.api.nvim_set_hl(0, '@lsp.type.class.python', {})
vim.api.nvim_set_hl(0, '@string.documentation', { link = 'Comment' })

-- Use LSP tokens for things treesitter can't infer
vim.api.nvim_set_hl(0, '@lsp.type.property', { link = '@property' })
vim.api.nvim_set_hl(0, '@lsp.type.enumMember', { link = '@property' })
vim.api.nvim_set_hl(0, '@lsp.type.parameter', { link = '@variable.parameter' })
vim.api.nvim_set_hl(0, '@lsp.type.typeParameter', { link = '@variable.parameter' })
vim.api.nvim_set_hl(0, '@lsp.typemod.variable.defaultLibrary', { link = '@variable.builtin' })
vim.api.nvim_set_hl(0, '@lsp.typemod.function.defaultLibrary', { link = '@function.builtin' })
vim.api.nvim_set_hl(0, '@lsp.typemod.enumMember.static', { link = '@constant' })
vim.api.nvim_set_hl(0, '@lsp.typemod.method.static', { link = '@constant' })
vim.api.nvim_set_hl(0, '@lsp.typemod.property.static', { link = '@constant' })
vim.api.nvim_set_hl(0, '@lsp.typemod.variable.readonly.python', { link = '@constant' })

--------------------------------------------------
------------------- Bufferline -------------------
------------------- lsp-file-operations -------------------
--------------------------------------------------
require("bufferline").setup()
require("lsp-file-operations").setup()
require("auto-save").setup()

--------------------------------------------------
------------------- Telescope --------------------
--------------------------------------------------
local telescope  = require("telescope")
local telescope_actions = require("telescope.actions")
telescope.setup({
  defaults = {
    path_display = { "smart" },
    mappings = {
      i = {
        ["<C-k>"] = telescope_actions.move_selection_previous, -- move to prev result
        ["<C-j>"] = telescope_actions.move_selection_next, -- move to next result
        ["<C-q>"] = telescope_actions.send_selected_to_qflist + telescope_actions.open_qflist,
      },
    },
  },
})
telescope.load_extension("fzf")
keymap.set("n", "<leader>ff", "<cmd>Telescope find_files<cr>", { desc = "Fuzzy find files in cwd" })
keymap.set("n", "<leader>fr", "<cmd>Telescope oldfiles<cr>", { desc = "Fuzzy find recent files" })
keymap.set("n", "<leader>fs", "<cmd>Telescope live_grep<cr>", { desc = "Find string in cwd" })
keymap.set("n", "<leader>fc", "<cmd>Telescope grep_string<cr>", { desc = "Find string under cursor in cwd" })


------------------------------------------------
------------------- Comment --------------------
------------------------------------------------
require('Comment').setup({
  toggler = {
      line = '<leader>c',
  },
  opleader = {
      line = '<leader>c',
  },
})


-------------------------------------------------
------------------- nvim-cmp --------------------
-------------------------------------------------
local cmp = require("cmp")
local lspkind = require("lspkind")
cmp.setup({
  completion = {
    completeopt = "menu,menuone,preview,noselect",
  },
  mapping = cmp.mapping.preset.insert({
    ["<C-k>"] = cmp.mapping.select_prev_item(), -- previous suggestion
    ["<C-j>"] = cmp.mapping.select_next_item(), -- next suggestion
    ["<C-b>"] = cmp.mapping.scroll_docs(-4),
    ["<C-f>"] = cmp.mapping.scroll_docs(4),
    ["<C-Space>"] = cmp.mapping.complete(), -- show completion suggestions
    ["<C-e>"] = cmp.mapping.abort(), -- close completion window
    ["<CR>"] = cmp.mapping.confirm({ select = false }),
  }),
  -- sources for autocompletion
  sources = cmp.config.sources({
    { name = "nvim_lsp" },
    { name = "buffer" }, -- text within current buffer
    { name = "path" }, -- file system paths
    { name = "cmdline" }, -- file system paths
  }),
  -- configure lspkind for vs-code like pictograms in completion menu
  formatting = {
    format = lspkind.cmp_format({
      maxwidth = 60,
      ellipsis_char = "...",
    }),
  },
})

-------------------------------------------------
------------------- nvim-ufo --------------------
-------------------------------------------------
opt.fillchars = [[eob: ,fold: ,foldopen:,foldsep: ,foldclose:]]
opt.foldcolumn = "1" -- '0' is not bad
opt.foldlevel = 99 -- Using ufo provider need a large value, feel free to decrease the value
opt.foldlevelstart = 99
opt.foldenable = true
require('ufo').setup()

