" Modeline and notes {
" vim: set foldmarker={,} foldlevel=0 foldmethod=marker spell:
" }

set nocompatible               " Be iMproved

" Leaders {
  " We have to define the leaders before the plugins, because we want
  " to keep the plugin mappings in one place.
  let mapleader = ','
  let maplocalleader = '\\'
" Leaders }

" Bootstrap Plug {
  " Set the appropriate paths for Plug
  " PLUG_AUTOLOAD_PATH is a script variable because we only need to bootstrap
  " Plug on first run.
  " PLUG_DATA_DIR is a global because we might want to use it in .gvimrc etc
  if has('nvim')
    let s:PLUG_AUTOLOAD_PATH = stdpath('data') . '/site/autoload/plug.vim'
    let g:PLUG_DATA_DIR = stdpath('data') . '/plugged'
  else
    let s:PLUG_AUTOLOAD_PATH = $HOME . '/.vim/autoload/plug.vim'
    let g:PLUG_DATA_DIR = $HOME . '/.vim/plugged'
  endif

  " Install plug
  if !filereadable(s:PLUG_AUTOLOAD_PATH)
    silent execute '!curl -fLo ' . s:PLUG_AUTOLOAD_PATH . ' --create-dirs "https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim"'
    autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
  endif
  unlet s:PLUG_AUTOLOAD_PATH
" Bootstrap Plug }

" Plugins {
  call plug#begin(g:PLUG_DATA_DIR)

  " Various {
    Plug 'morhetz/gruvbox'                                                          " Theme
    Plug 'itchyny/lightline.vim'                                                    " Status Line
    Plug 'scrooloose/nerdcommenter'
    "Plug 'editorconfig/editorconfig-vim'
    Plug 'sgur/vim-editorconfig'
    Plug 'tpope/vim-eunuch'
    Plug 'tpope/vim-repeat'
    Plug 'tpope/vim-surround'
    Plug 'Konfekt/FastFold'
    Plug 'pedrohdz/vim-yaml-folds'

    " xml {
    Plug 'sukima/xmledit/'
    " } xml

    " pgsql {
    Plug 'lifepillar/pgsql.vim'
    let g:sql_type_default = 'pgsql'
    let g:pgsql_pl = ['python']
    " pgsql }

    Plug 'zah/nim.vim'

  " Various }

  " Polyglot {
    Plug 'sheerun/vim-polyglot'
    let g:polyglot_disabled = ['python']
  " Polyglot }

  " ctags {
    if executable("ctags")
      Plug 'majutsushi/tagbar'
      nmap <F8> :TagbarOpenAutoClose<CR>
    endif
  " ctags }

  " Undo {
    Plug 'mbbill/undotree'                                                          " Undo
    nnoremap <F5> :UndotreeToggle<cr>
  " Undo }

  " Indent guides {
    "Plug 'nathanaelkane/vim-indent-guides'
    "let g:indent_guides_enable_on_vim_startup = 1
  " Indent guides }

  " fzr {
    if executable("fzf")
      Plug 'junegunn/fzf.vim'
      nnoremap <leader>z :FZF<cr>
    endif
  " fzr }

  " LSP (Language Server Protocol) {
    if v:version >= 800
        Plug 'prabirshrestha/async.vim'"
        Plug 'prabirshrestha/asyncomplete.vim'"
        Plug 'prabirshrestha/asyncomplete-lsp.vim'
        Plug 'prabirshrestha/asyncomplete-buffer.vim'
        Plug 'prabirshrestha/vim-lsp'"
    endif
    Plug 'w0rp/ale'

  " LSP (Language Server Protocol) }

  " Go {
    Plug 'fatih/vim-go',    { 'for': 'go', 'do': ':GoInstallBinaries' }
  " Go }

  " Python {
    Plug 'tmhedberg/SimpylFold',              { 'for': 'python' }
    Plug 'jeetsukumaran/vim-pythonsense',     { 'for': 'python' }
    Plug 'lepture/vim-jinja',                 { 'for': 'python' }
  " Python }

  call plug#end()
" Plugins }

" LSP Config {
    " Pyls {
    if executable("pyls")
      " Registrations {
      autocmd User lsp_setup call lsp#register_server({
          \ 'name': 'pyls',
          \ 'cmd': {server_info->['pyls']},
          \ 'whitelist': ['python'],
          \ })
      " Registrations }

      " Buffers {
      call asyncomplete#register_source(asyncomplete#sources#buffer#get_source_options({
        \ 'name': 'buffer',
        \ 'whitelist': ['*'],
        \ 'blacklist': ['go'],
        \ 'completor': function('asyncomplete#sources#buffer#completor'),
        \ }))
      " Buffers }

      " Options
      let g:asyncomplete_remove_duplicates = 1
      let g:asyncomplete_smart_completion = 0
      let g:asyncomplete_auto_popup = 1
      let g:lsp_diagnostics_enabled = 1     " disable diagnostics support (we will use warp/Ale)
      let g:lsp_signs_enabled = 1           " enable signs
      let g:lsp_diagnostics_echo_cursor = 1 " enable echo under cursor when in normal mode
      let g:lsp_signs_error = {'text': '✗'}
      let g:lsp_signs_warning = {'text': '‼'}
      let g:lsp_signs_hint = {'text': 'O'}

      " Mappings
      inoremap <expr> <Tab>   pumvisible() ? "\<C-n>" : "\<Tab>"
      inoremap <expr> <S-Tab> pumvisible() ? "\<C-p>" : "\<S-Tab>"
      inoremap <expr> <cr>    pumvisible() ? "\<C-y>" : "\<cr>"
      imap <c-space> <Plug>(asyncomplete_force_refresh)
      autocmd! CompleteDone * if pumvisible() == 1 | pclose | endif

    endif
    " Pyls }
" LSP Config }

" Ale Config {
  " Only run ale on save
  let g:ale_lint_on_enter = 0
  let g:ale_lint_on_save = 1
  let g:ale_lint_on_text_changed = 'never'
  let g:ale_fix_on_save = 0
  let g:ale_virtualenv_dir_names = []
  let g:ale_python_prospector_options = '--no-external-config'
  let g:ale_fixers = {}
  let g:ale_linters = {
    \ 'javascript': ['eslint'],
    \ 'python': ['prospector'],
  \ }
  "let g:ale_fixers = {
    ""\ '*': ['remove_trailing_lines', 'trim_whitespace'],
    ""\ 'python': ['isort'],
  "\ }
" Ale Config }

" Theme {
    if v:version >= 800
        set termguicolors
    endif
    set background=dark
    colorscheme gruvbox
    let g:gruvbox_italic = 1
" Theme }

" Font {
  " Choose font for linux, mac and windows.
  if has("gui_gtk2")
      set guifont=Ubuntu\ Mono\ 12
  elseif has("gui_win32")
      set guifont=Consolas:h14
  else
      set guifont=Hack\ Nerd\ Font\ 12,
      set guifont=Ubuntu\ Mono\ 12
      set guifont=Fira\ Code\ 11
      set guifont=Iosevka\ Regular\ 12
  end
" Font }

" Backup - Undo - Swap{
  set backup                        " enable backups
  set noswapfile                    " It's 2012, Vim.
  " Paths
  " The double slash stores files using full paths so there are no name clashes
  set backupdir=~/.cache/vim/backup//
  set directory=~/.cache/vim/swap//
  set undodir=~/.cache/vim/undo//
  silent execute '!mkdir -p ' . &backupdir . ' ' . &directory . ' ' . &undodir
  " Undo
  if has('persistent_undo')
    set undofile                "so is persistent undo ...
    set undolevels=1000         "maximum number of changes that can be undone
    set undoreload=10000        "maximum number lines to save for undo on a buffer reload
  endif
" }

" general {
  filetype plugin indent on   " automatically detect file types.
  syntax on                   " syntax highlighting
  set mouse+=a                " automatically disable mouse usage
  scriptencoding utf-8
  set encoding=utf-8
  set modelines=2
  set laststatus=2            " always show a status line
  set showmode                " display the current mode
  set showcmd                 " show partial commands in status line and
  set visualbell
  set ttyfast
  set ruler                   " show the ruler
  set rulerformat=%30(%=\:b%n%y%m%r%w\ %l,%c%V\ %P%)
  set backspace=indent,eol,start  " backspace for dummies
  set history=1000            " Store a ton of history (default is 20)
  "set shell=/bin/zsh
  set fillchars=diff:⣿,vert:│
  set autowrite               " Autosave files
  set title
  set guioptions-=m              " Do not load menu
  set guioptions-=T              " Do not load toolbar
  set cmdheight=2
  set lazyredraw
  set signcolumn=yes

  " TimeOuts {
    " Time out on key codes but not mappings.
    " Basically this makes terminal Vim work sanely.
    set notimeout
    set ttimeout
    set ttimeoutlen=10
  " TimeOuts }
" general }

" Scrolling and Folding {
  set scrolljump=5                " lines to scroll when cursor leaves screen
  set scrolloff=5                 " minimum lines to keep above and below cursor
  set foldenable                  " auto fold code
  set foldlevelstart=1
  set foldmethod=syntax

  """ Code folding options
  nnoremap <leader>f0 :set foldlevel=0<CR>
  nnoremap <leader>f1 :set foldlevel=1<CR>
  nnoremap <leader>f2 :set foldlevel=2<CR>
  nnoremap <leader>f3 :set foldlevel=3<CR>
  nnoremap <leader>f4 :set foldlevel=4<CR>
  nnoremap <leader>f5 :set foldlevel=5<CR>
  nnoremap <leader>f6 :set foldlevel=6<CR>
  nnoremap <leader>f7 :set foldlevel=7<CR>
  nnoremap <leader>f8 :set foldlevel=8<CR>
  nnoremap <leader>f9 :set foldlevel=99<CR>

  " Let folds work with greek layout too
  nnoremap <leader>φ0 :set foldlevel=0<CR>
  nnoremap <leader>φ1 :set foldlevel=1<CR>
  nnoremap <leader>φ2 :set foldlevel=2<CR>
  nnoremap <leader>φ3 :set foldlevel=3<CR>
  nnoremap <leader>φ4 :set foldlevel=4<CR>
  nnoremap <leader>φ5 :set foldlevel=5<CR>
  nnoremap <leader>φ6 :set foldlevel=6<CR>
  nnoremap <leader>φ7 :set foldlevel=7<CR>
  nnoremap <leader>φ8 :set foldlevel=8<CR>
  nnoremap <leader>φ9 :set foldlevel=99<CR>
" Scrolling and Folding }

" Tabs, spaces {
  set tabstop=8                   " an indentation every eight columns
  set shiftwidth=2                " use indents of 2 spaces
  set shiftround                  " Always round to multiple of 'shiftwidth'
  set softtabstop=2               " let backspace delete indent
  set expandtab                   " tabs are spaces, not tabs
  set formatoptions=qrn1
  set colorcolumn=109
  set autoindent                  " indent at the same level of the previous line
" Tabs, spaces }

" Wrap {
  set nowrap                      " Wrap long lines (or not!)
  set whichwrap=b,s,h,l,<,>,[,]   " backspace and cursor keys wrap to
  set textwidth=100
" Wrap }

" Line Numbers {
  set number                  " Line numbers on
  set relativenumber          " Relative line numbers on

  augroup my_vim_numbers
    autocmd!
    " Use relative numbers only focus is on the vim window.
    autocmd FocusLost * :set number
    autocmd FocusGained * :set relativenumber
    " Use relative numbers only when in normal mode
    autocmd InsertEnter * :set number
    autocmd InsertLeave * :set relativenumber
  augroup END
" }

" Custom Autocmds {

  " XML {
  augroup xml_config
      autocmd!
      let g:xml_syntax_folding=1
      autocmd FileType xml setlocal foldmethod=syntax foldlevelstart=999 foldminlines=0
  augroup END
  " XML }

  " gopass {
  augroup my_gopass
    autocmd!
    autocmd BufNewFile,BufRead /dev/shm/gopass.* setlocal noswapfile nobackup noundofile
  augroup END
  " } gopass

  " Line return {
    " Make sure Vim returns to the same line when you reopen a file.
    augroup my_line_return
      autocmd!
      autocmd BufReadPost *
          \ if line("'\"") > 0 && line("'\"") <= line("$") |
          \     execute 'normal! g`"zvzz' |
          \ endif
    augroup END
  " Line return }
" Custom Autocmds }

" Windows and Buffers {
  set hidden                  " allow buffer switching without saving
  set winminheight=0          " windows can be 2 line high
  set splitbelow              " When splitting put new window below of the current one
  set splitright              " When splitting put new window to the right of the current one
  "
  augroup my_resize
    autocmd!
    autocmd VimResized * :wincmd =      " Resize splits when the windows is resized.
    autocmd FocusLost * : silent! wall  " Save when losing focus
  augroup END
  "
  augroup my_various
    autocmd!
    " Make new buffers to default to txt (useful for opening huge files)
    autocmd BufEnter * if &filetype == "" | setlocal ft=txt | endif
    " Reset the filetype when you saveas
    autocmd BufFilePre * set filetype&
    " When vimrc is edited, reload it
    autocmd! bufwritepost vimrc source $MYVIMRC
  augroup END
" Windows and Buffers }

" Whitespace {
  " Highlight problematic whitespace with the following symbols,
  " but only show trailing whitespace when not in insert mode.
  set list
  set listchars=tab:▸\
  set listchars+=extends:❯
  set listchars+=precedes:❮
  "set listchars+=eol:¬
  augroup my_trailing_whitespace
    autocmd!
    " Show trailing whitespace when editing
    autocmd InsertEnter * :set listchars-=trail:⌴
    autocmd InsertLeave * :set listchars+=trail:⌴
    " Remove trailing whitespaces when saving
    autocmd BufWritePre * :%s/\s\+$//e
  augroup END
" Whitespace }

" Languages & Spellchecking {
  " Greek {
    :set langmap=ΑA,ΒB,ΨC,ΔD,ΕE,ΦF,ΓG,ΗH,ΙI,ΞJ,ΚK,ΛL,ΜM,ΝN,ΟO,ΠP,QQ,ΡR,ΣS,ΤT,ΘU,ΩV,WW,ΧX,ΥY,ΖZ,αa,βb,ψc,δd,εe,φf,γg,ηh,ιi,ξj,κk,λl,μm,νn,οo,πp,qq,ρr,σs,τt,θu,ωv,ςw,χx,υy,ζz
  " Greek }
  set spell spelllang=en
" Languages & Spellchecking }

" highlight and searching {
  set incsearch                   " incremental search
  set hlsearch                    " highlight search terms
  set ignorecase                  " case insensitive search
  set smartcase                   " case sensitive when uc present
  " use sane regexes.
  "nnoremap / /\v
  "vnoremap / /\v
  "
  " matching pairs
  set showmatch                   " show matching symbols (parens etc)
  set matchtime=3                 " time to show matching paren
  set matchpairs+=(:)
  set matchpairs+=[:]
  set matchpairs+={:}
  set matchpairs+=<:>

  " clear highlighted search
  nnoremap <silent> <leader>/ :nohlsearch<cr>

  " keep search matches in the middle of the window.
  nnoremap n nzzzv
  nnoremap n nzzzv
" }

" Mappings {
  " Moving around {
    " Easier moving in tabs and windows
    nnoremap <C-J> <C-W>j<C-W>_
    nnoremap <C-K> <C-W>k<C-W>_
    nnoremap <C-L> <C-W>l<C-W>_
    nnoremap <C-H> <C-W>h<C-W>_
    " When moving stay in the middle of the window.
    nnoremap g; g;zz
    nnoremap g, g,zz
    nnoremap <c-o> <c-o>zz
    " It's 2012.
    noremap j gj
    noremap k gk
    noremap gj j
    noremap gk k
  " Moving around }

  " Insert empty line above or below while staying in normal mode
  nnoremap <leader>o :set paste<CR>m`o<Esc>``:set nopaste<CR>
  nnoremap <leader>O :set paste<CR>m`O<Esc>``:set nopaste<CR>

  " Formatting, TextMate-style
  nnoremap Q gqip
  vnoremap Q gq

  " Keep the cursor in place while joining lines
  nnoremap J mzJ`z

  "Split line (sister of [J]oin lines)
  " The normal use of S is covered by cc, so don't worry about shadowing
  nnoremap S i<cr><esc>^mwgk:silent! s/\v +$//<cr>:noh<cr>`w

  " Clipboard {
    noremap <leader>y "*y
    noremap <leader>p :set paste<CR>"*p<CR>:set nopaste<CR>
    noremap <leader>P :set paste<CR>"*P<CR>:set nopaste<CR>
    vnoremap <leader>y "*ygv
    " Yank from the cursor to the end of the line, to be consistent with C and D.
    nnoremap Y y$
  " Clipboard }

  " visual shifting (does not exit Visual mode)
  vnoremap < <gv
  vnoremap > >gv

  " For when you forget to sudo.. Really Write the file.
  cmap w!! w !sudo tee % >/dev/null

  " Change Working Directory to that of the current file
  cmap cwd lcd %:p:h

  " Some helpers to edit mode : http://vimcasts.org/e/14
  " %% : Expands directory of the current file to the command line
  cnoremap %% <C-R>=expand('%:h').'/'<cr>

  " Swap ; and :  Convenient.
  " Saves typing and eliminates :W style typos due to lazy holding shift.
  nnoremap ; :

  " Save file (works in greek layout too!)
  inoremap <leader>w <c-o>:w<CR>
  inoremap <leader>ς <c-o>:w<CR>
  nnoremap <leader>w :w
  nnoremap <leader>ς :w
  vnoremap <leader>w <esc>:w<CR>gv
  vnoremap <leader>ς <esc>:w<CR>gv

  " map F1 (help) to esc
  inoremap <F1> <ESC>
  nnoremap <F1> <ESC>
  vnoremap <F1> <ESC>

  nnoremap <leader>u :syntax sync fromstart<cr>:redraw!<cr>         " Redraw screen

  nnoremap <Leader>= <C-w>=        " Adjust viewports to the same size
" Mappings }

" WildMenu Completion {
  "set wildmenu                    " show list instead of just completing
  "set wildmode=list:longest,full  " command <Tab> completion, list matches, then longest common part, then all.
  "set wildignore+=.hg,.git,.svn                    " Version control
  "set wildignore+=*.aux,*.out,*.toc                " LaTeX intermediate files
  "set wildignore+=*.jpg,*.bmp,*.gif,*.png,*.jpeg   " binary images
  "set wildignore+=*.o,*.obj,*.exe,*.dll,*.manifest " compiled object files
  "set wildignore+=*.spl                            " compiled spelling word lists
  "set wildignore+=*.sw?                            " Vim swap files
  "set wildignore+=*.pyc,*.pyo                      " Python byte code
  "set wildignore+=*.orig                           " Merge resolution files
" WildMenu Completion }

" Filetype customizations {

  " Makefile {
    augroup my_makefile
      autocmd!
      " Do not expand tabs for makefiles
      autocmd FileType make :setlocal noexpandtab
    augroup END
  " Makefile }

  " Go {
    augroup my_go
      autocmd!
      " Use tabs instead of spaces
      autocmd FileType go :setlocal noet ci pi sts=0 sw=4 ts=4
    augroup END
  " Go }

  " Python {
    augroup my_python
      autocmd!
      " Use 4 spaces python
      autocmd FileType python :setlocal sw=4 ts=4 sts=4
    augroup END
  " Python }

  " Javascript {
    " Generic {
      augroup my_javascript
        autocmd!
        autocmd FileType javascript setlocal foldmethod=syntax
      augroup END
      "
      let javaScript_fold=1         " JavaScript
    " Generic }
    "
    " Plugins {
      Plug 'pangloss/vim-javascript',     { 'for': 'javascript' }
      let g:javascript_plugin_ngdoc = 1
      let g:javascript_plugin_jsdoc = 1
      let g:javascript_plugin_flow = 1
    " Plugins }
  " Javascript }

  " html {
    augroup my_html
      autocmd!
      autocmd FileType html setlocal foldmethod=indent
    augroup END
  " html }

" Filetype customizations }

  " Multiple cursors {
    " Custom mappings
    let g:multi_cursor_use_default_mapping=1
    "let g:multi_cursor_start_word_key      = '<leader>n'
    "let g:multi_cursor_select_all_word_key = '<leader>a'
    "let g:multi_cursor_start_key           = 'g<C-n>'
    "let g:multi_cursor_select_all_key      = 'g<A-n>'
    "let g:multi_cursor_next_key            = '<leader>n'
    "let g:multi_cursor_prev_key            = '<leader>p'
    "let g:multi_cursor_skip_key            = '<leader>x>'
    "let g:multi_cursor_quit_key            = '<Esc>'
  " Multiple cursors }
" Plugin Setup }

" Extra functionality {
  let s:VIM_CONFIG_EXTRA = $HOME . '/.vim.extra'
  if filereadable(s:VIM_CONFIG_EXTRA)
    source s:VIM_CONFIG_EXTRA
  endif
  unlet s:VIM_CONFIG_EXTRA
" Extra functionality }
