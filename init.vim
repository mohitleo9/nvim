" vim: fdm=marker ts=2 sts=2 sw=2 fdl=9
" ============================================================================

call plug#begin() "{{{
" Core Plugins {{{
Plug 'tpope/vim-sensible'
Plug 'w0rp/ale'
Plug 'majutsushi/tagbar', { 'on': 'TagbarToggle' }
Plug 'editorconfig/editorconfig-vim'
Plug 't9md/vim-quickhl'
Plug 'tpope/vim-surround'
Plug 'wellle/targets.vim'
Plug 'tpope/vim-sleuth'
Plug 'tpope/vim-repeat'
Plug 'Shougo/deoplete.nvim', { 'do': ':UpdateRemotePlugins' }
Plug 'mhinz/vim-signify'
Plug 'tpope/vim-fugitive'
Plug 'tpope/vim-git'
Plug 'tpope/vim-unimpaired'
Plug 'AndrewRadev/switch.vim'
Plug 'SirVer/ultisnips'
Plug 'thinca/vim-visualstar'
Plug 'tomtom/tcomment_vim'
Plug 'terryma/vim-multiple-cursors'
Plug 'Raimondi/delimitMate'
Plug 'kana/vim-textobj-user'
Plug 'kana/vim-textobj-line'
Plug 'kana/vim-textobj-indent'
Plug 'kana/vim-textobj-entire'
Plug 'mhinz/vim-startify'
Plug 'Lokaltog/vim-easymotion'
Plug 'mhinz/vim-grepper'
Plug 'kien/ctrlp.vim'
"}}}

" Web Plugins {{{
Plug 'groenewege/vim-less'
Plug 'cakebaker/scss-syntax.vim'
Plug 'gregsexton/MatchTag', {'for': ['html','xml']}
Plug 'Valloric/MatchTagAlways'
"}}}

" Javascript Plugins {{{
" Plug 'marijnh/tern_for_vim', {'for': ['javascript'], 'do': 'npm install'} " {{{
" Plug 'mohitleo9/vim-fidget', {'do': 'npm install --production', 'on': 'VimFidget'}
Plug 'jelera/vim-javascript-syntax', {'for': 'javascript'}
" }}}

" Python Plugins {{{
Plug 'klen/python-mode', {'for': ['python']}
" }}}

" color schemes {{{
Plug 'icymind/NeoSolarized'
"}}}

call plug#end()
"}}}

" functions {{{
function! Preserve(command) "{{{
  " preparation: save last search, and cursor position.
  let _s=@/
  let l = line(".")
  let c = col(".")
  " do the business:
  execute a:command
  " clean up: restore previous search history, and cursor position
  let @/=_s
  call cursor(l, c)
endfunction "}}}

function! StripTrailingWhitespace() "{{{
  call Preserve("%s/\\s\\+$//e")
endfunction "}}}

function! EnsureExists(path) "{{{
  if !isdirectory(expand(a:path))
    call mkdir(expand(a:path))
  endif
endfunction "}}}

function! CloseWindowOrKillBuffer() "{{{
  let number_of_windows_to_this_buffer = len(filter(range(1, winnr('$')), "winbufnr(v:val) == bufnr('%')"))

  " never bdelete a nerd tree
  if matchstr(expand("%"), 'NERD') == 'NERD'
    wincmd c
    return
  endif

  if number_of_windows_to_this_buffer > 1
    wincmd c
  else
    bdelete
  endif
endfunction "}}}

" " taken from stevelosh learnvimscriptthehardway
function! GrepOperator(type)
  let saved_unnamed_register = @@

  if a:type ==# 'v'
    normal! `<v`>y
  elseif a:type ==# 'char'
    normal! `[v`]y
  else
    return
  endif

  " set the search register for the word
  let @/ = @@

  silent execute "Ack ". shellescape(@@, 1)

  let @@ = saved_unnamed_register
endfunction

function! YankOnFocusGain() "{{{
  let @l = @*
endfunction "}}}
" backup the system copied data in l register
augroup _sync_clipboard_system "{{{
  autocmd!
  autocmd FocusGained * call YankOnFocusGain()
augroup END "}}}
"}}}

" base configuration {{{
set timeoutlen=500                                  "mapping timeout
set ttimeoutlen=50                                  "keycode timeout default set here was 50

set mouse=a                                         "enable mouse
set mousehide                                       "hide when characters are typed
set history=1000                                    "number of command lines to remember
set ttyfast                                         "assume fast terminal connection
" set viewoptions=folds,options,cursor,unix,slash     "unix/windows compatibility
set encoding=utf-8                                  "set encoding for text
set clipboard=unnamed                             "sync with OS clipboard
set hidden                                          "allow buffer switching without saving
set autoread                                        "auto reload if file saved externally
set fileformats+=mac                                "add mac to auto-detection of file format line endings
set nrformats-=octal                                "always assume decimal numbers
set showcmd
set tags=tags;/
set showfulltag
set modeline
set modelines=5
set termguicolors
set nosol                                           "this keeps the cursor in the same column when you hit G in visual block mode
set noshelltemp                                     "use pipes

" whitespace
set backspace=indent,eol,start                      "allow backspacing everything in insert mode
set autoindent                                      "automatically indent to match adjacent lines
set expandtab                                       "spaces instead of tabs
set smarttab                                        "use shiftwidth to enter tabs
set list                                            "highlight whitespace
set listchars=tab:│\ ,trail:•,extends:❯,precedes:❮
set shiftround
set linebreak
set diffopt=filler,vertical
let &showbreak='↪ '

set scrolloff=5                                     "always show content after scroll
set scrolljump=5                                    "minimum number of lines to scroll
set display+=lastline
set wildmenu                                        "show list for autocomplete
set wildmode=list:longest,full
set wildignorecase
" remove the wildignore as it is not used and it breaks fugitive
" https://github.com/tpope/vim-fugitive/issues/121
" set wildignore+=*/.git/*,*/.hg/*,*/.svn/*,*/.idea/*,*/.DS_Store

set splitbelow
set splitright

" disable sounds
set noerrorbells
set novisualbell
set t_vb=

" searching
set hlsearch                                        "highlight searches
set incsearch                                       "incremental searching
set ignorecase                                      "ignore case for searching
set smartcase                                       "do case-sensitive if there's a capital letter

" vim file/folder management {{{
" persistent undo
if exists('+undofile')
  set undofile
  set undodir=~/.config/nvim/.cache/undo
endif

" backups
set backup
set backupdir=~/.config/nvim/.cache/backup

" swap files
set directory=~/.config/nvim/.cache/swap
set noswapfile

call EnsureExists('~/.config/nvim/.cache')
call EnsureExists(&undodir)
call EnsureExists(&backupdir)
call EnsureExists(&directory)
"}}}

let mapleader = ","
let g:mapleader = ","
"}}}


" ui configuration {{{
set showmatch                                       "automatically highlight matching braces/brackets/etc.
set matchtime=2                                     "tens of a second to show matching parentheses
set number
set lazyredraw
set laststatus=2
set noshowmode
set foldenable                                      "enable folds by default
set foldmethod=syntax                               "fold via syntax of files
set foldlevelstart=99                               "open all folds by default
set cursorline
set cursorcolumn


"}}}


" mappings {{{
" grep operator (technically ack)
nnoremap g/ :set operatorfunc=GrepOperator<cr>g@
vnoremap g/ :<c-u>call GrepOperator(visualmode())<cr>

nnoremap <leader>w :w<cr>

" remap arrow keys
nnoremap <left> :bprev<CR>
nnoremap <right> :bnext<CR>
nnoremap <up> :tabnext<CR>
nnoremap <down> :tabprev<CR>

" :on
nnoremap gon :on<CR>

" sane regex {{{
nnoremap ? ?\v
vnoremap ? ?\v
nnoremap :s/ :s/\v
" }}}

" command-line window {{{
nnoremap q: q:i
nnoremap q/ q/i
nnoremap q? q?i
" }}}

" folds {{{
nnoremap zr zr:echo &foldlevel<cr>
nnoremap zm zm:echo &foldlevel<cr>
nnoremap zR zR:echo &foldlevel<cr>
nnoremap zM zM:echo &foldlevel<cr>
" }}}

" screen line scroll
nnoremap <silent> j gj
nnoremap <silent> k gk

" auto center {{{
nnoremap <silent> n nzz
nnoremap <silent> N Nzz
nnoremap <silent> * *zz
nnoremap <silent> # #zz
nnoremap <silent> g* g*zz
nnoremap <silent> g# g#zz
nnoremap <silent> <C-o> <C-o>zz
nnoremap <silent> <C-i> <C-i>zz
"}}}

" reselect visual block after indent
vnoremap < <gv
vnoremap > >gv

" reselect last paste
nnoremap <expr> gp '`[' . strpart(getregtype(), 0, 1) . '`]'

" shortcuts for windows {{{
nnoremap <leader>v <C-w>v<C-w>l
nnoremap <leader>s <C-w>s
nnoremap <leader>vsa :vert sba<cr>
nnoremap <C-h> <C-w>h
nnoremap <C-j> <C-w>j
nnoremap <C-k> <C-w>k
nnoremap <C-l> <C-w>l
"}}}

" make Y consistent with C and D. See :help Y.
nnoremap Y y$

" window killer
nnoremap <silent> Q :call CloseWindowOrKillBuffer()<cr>
" general
nnoremap <BS> :set hlsearch! hlsearch?<cr>

" helpers for profiling {{{
nnoremap <silent> <leader>dd :exe ":profile start profile.log"<cr>:exe ":profile func *"<cr>:exe ":profile file *"<cr>
nnoremap <silent> <leader>dp :exe ":profile pause"<cr>
nnoremap <silent> <leader>dc :exe ":profile continue"<cr>
nnoremap <silent> <leader>dq :exe ":profile pause"<cr>:noautocmd qall!<cr>
"}}}
"
"better yank and paste to the end of line
"easy to repeat paste
"this is genius credit http://sheerun.net/2014/03/21/how-to-boost-your-vim-productivity/
vnoremap <silent> y y`]
vnoremap <silent> p p`]
nnoremap <silent> p p`]
"}}}
" commands {{{
" command! -bang Q q<bang>
" command! -bang QA qa<bang>
" command! -bang Qa qa<bang>
"}}}

" Plugin Settings {{{

" 'w0rp/ale' "{{{
let g:ale_sign_error = '✗'
let g:ale_sign_warning = '∆'
let g:ale_linters = {
      \   'javascript': ['eslint'],
      \}
let g:ale_lint_on_text_changed = 'never'
"}}}

" " majutsushi/tagbar {{{
"     let g:tagbar_sort = 0
" " }}}

" t9md/vim-quickhl "{{{
nmap <leader>m <Plug>(quickhl-manual-this)
xmap <leader>m <Plug>(quickhl-manual-this)
nmap <leader>M <Plug>(quickhl-manual-reset)
xmap <leader>M <Plug>(quickhl-manual-reset)
"}}}


" tpope/vim-surround "{{{
nmap s <Plug>Ysurround
" }}}


" 'mhinz/vim-signify' "{{{
let g:signify_update_on_focusgained = 1
"}}}


" 'tpope/vim-fugitive' "{{{
nnoremap <silent> <leader>gs :Gstatus<CR>
nnoremap <silent> <leader>gd :Gdiff<CR>
nnoremap <silent> <leader>gc :Gcommit<CR>
nnoremap <silent> <leader>gb :Gblame<CR>
nnoremap <silent> <leader>gg :Ggrep<cword><CR>
nnoremap <silent> <leader>gl :Glog<CR>
nnoremap <silent> <leader>gp :Git push<CR>
nnoremap <silent> <leader>gw :Gwrite<CR>
nnoremap <silent> <leader>gr :Gremove<CR>

augroup _fugitive_buffer_delete
  autocmd!
  autocmd FileType gitcommit nmap <buffer> U :Git checkout -- <C-r><C-g><CR>
  autocmd BufReadPost fugitive://* set bufhidden=delete
augroup END
"}}}
"

" 'AndrewRadev/switch.vim' " {{{
nnoremap <c-c> :Switch<cr>
" }}}


" 'SirVer/ultisnips' "{{{
let g:UltiSnipsExpandTrigger = '<C-j>'
let g:UltiSnipsJumpForwardTrigger = '<C-j>'
let g:UltiSnipsJumpBackwardTrigger = '<C-k>'
"}}}


" 'Lokaltog/vim-easymotion' "{{{
let g:EasyMotion_smartcase = 1
map  / <Plug>(easymotion-sn)
omap / <Plug>(easymotion-tn)
map  n <Plug>(easymotion-next)
map  N <Plug>(easymotion-prev)
"}}}


" 'mhinz/vim-grepper' "{{{
command! -nargs=* Ack GrepperAg <args>

let g:grepper = {}
let g:grepper.highlight=1
let g:grepper.quickfix = 1
let g:grepper.open = 1
let g:grepper.stop = 1000
let g:grepper.side = 1

"}}}

" 'kien/ctrlp.vim', "{{{
let g:ctrlp_use_caching = 1
let g:ctrlp_clear_cache_on_exit=1
let g:ctrlp_max_height=40
let g:ctrlp_show_hidden=1
let g:ctrlp_follow_symlinks=1
let g:ctrlp_working_path_mode = 'ra'
let g:ctrlp_max_files=20000
let g:ctrlp_cache_dir='~/.config/nvim/.cache/ctrlp'
let g:ctrlp_reuse_window='startify'
let g:ctrlp_custom_ignore = {
      \ 'dir':  '\.git$\|\.hg$\|\.svn$',
      \ 'file': '\.exe$\|\.so$\|\.dll$\|\.pyc$' }
if executable('ag')
  let g:ctrlp_user_command = 'ag --hidden %s --nocolor -l -g ""'
endif
"}}}


" 'Valloric/MatchTagAlways' "{{{
let g:mta_use_matchparen_group=0
let g:mta_set_default_matchtag_color=0
let g:mta_filetypes = {
      \ 'javascript.jsx': 1,
      \ 'html' : 1,
      \ 'xhtml' : 1,
      \ 'xml' : 1,
      \ 'jinja' : 1
      \}
"}}}

" 'klen/python-mode' "{{{
let g:pymode_rope=0
let g:pymode_run = 0
let g:pymode_lint = 0
let g:pymode_folding = 0
"}}}


" 'Shougo/deoplete.nvim' "{{{
let g:deoplete#enable_at_startup = 1
" }}}

"}}}

" autocmd {{{
augroup variousCommands
  autocmd!
  " go back to previous position of cursor if any
  autocmd BufReadPost *
        \ if line("'\"") > 0 && line("'\"") <= line("$") |
        \  exe 'normal! g`"zvzz' |
        \ endif
  autocmd FileType javascript,scss,css,python,coffee,vim,clojure autocmd BufWritePre <buffer> call StripTrailingWhitespace()
  autocmd FileType css,scss setlocal foldmethod=marker foldmarker={,}
  autocmd FileType python setlocal foldmethod=indent
  autocmd FileType html setlocal foldmethod=manual
  autocmd FileType markdown setlocal nolist
  autocmd FileType vim setlocal fdm=indent keywordprg=:help
augroup END

" augroup fixcursorline
"   autocmd!
"   autocmd WinLeave * setlocal nocursorline
"   autocmd WinEnter * setlocal cursorline
" augroup END
"
" augroup restoreCursorline
"   autocmd!
"   autocmd WinLeave * setlocal nocursorcolumn
"   autocmd WinEnter * setlocal cursorcolumn
" augroup END
"}}}


set background=dark
colorscheme NeoSolarized
