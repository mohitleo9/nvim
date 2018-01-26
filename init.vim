" vim: fdm=marker ts=2 sts=2 sw=2 fdl=9
" ============================================================================

call plug#begin() "{{{

" Core Plugins {{{
Plug 'tpope/vim-sensible'
Plug 'ton/vim-bufsurf'
Plug '/usr/local/opt/fzf'
Plug 'junegunn/fzf.vim'
Plug 'junegunn/vim-peekaboo'
Plug 'w0rp/ale'
Plug 'rhysd/vim-grammarous'
Plug 'itchyny/lightline.vim'
Plug 'majutsushi/tagbar', { 'on': 'TagbarToggle' }
Plug 'editorconfig/editorconfig-vim'
Plug 't9md/vim-quickhl'
Plug 'tpope/vim-surround'
Plug 'wellle/targets.vim'
Plug 'tpope/vim-sleuth'
Plug 'tpope/vim-repeat'

Plug 'godlygeek/tabular', { 'on' : 'Tabularize' }
" completion
" Plug 'Shougo/deoplete.nvim', { 'do': ':UpdateRemotePlugins' }
" Plug 'carlitux/deoplete-ternjs', { 'do': 'npm install -g tern' }
" Plug 'Shougo/echodoc.vim'
Plug 'roxma/nvim-completion-manager'
Plug 'roxma/nvim-cm-tern',  {'do': 'npm install', 'for' : 'javascript'}

Plug 'mhinz/vim-signify'
Plug 'tpope/vim-fugitive'
Plug 'tpope/vim-rhubarb'
Plug 'tpope/vim-git'
Plug 'tpope/vim-unimpaired'
Plug 'AndrewRadev/switch.vim'
Plug 'AndrewRadev/sideways.vim'
Plug 'SirVer/ultisnips'
Plug 'honza/vim-snippets'
Plug 'thinca/vim-visualstar'
Plug 'tomtom/tcomment_vim'
Plug 'terryma/vim-multiple-cursors'
Plug 'Raimondi/delimitMate'
Plug 'kana/vim-textobj-user'
Plug 'kana/vim-textobj-line'
Plug 'kana/vim-textobj-indent'
" Plug 'kana/vim-textobj-entire' " slow
Plug 'mhinz/vim-startify'
Plug 'easymotion/vim-easymotion'
" Plug 'haya14busa/vim-signjk-motion' " slow
Plug 'mhinz/vim-grepper'
" Plug 'kien/ctrlp.vim'
"}}}

" Web Plugins {{{
Plug 'groenewege/vim-less'
Plug 'cakebaker/scss-syntax.vim'
Plug 'gregsexton/MatchTag', {'for': ['html','xml']}
Plug 'Valloric/MatchTagAlways'
"}}}

" Javascript Plugins {{{
" Plug 'ternjs/tern_for_vim', {'do': 'npm install'}
Plug 'jelera/vim-javascript-syntax', {'for': 'javascript'}
" }}}

" Python Plugins {{{
Plug 'klen/python-mode', {'for': ['python']}
" }}}

" color schemes {{{
" Plug 'icymind/NeoSolarized'
Plug 'lifepillar/vim-solarized8'
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

  silent execute 'Ack '. shellescape(@@, 1)

  let @@ = saved_unnamed_register
endfunction

function! YankOnFocusGain() "{{{
  let @l = @*
endfunction "}}}

" https://stackoverflow.com/questions/13194428/is-better-way-to-zoom-windows-in-vim-than-zoomwin
" Zoom / Restore window.
function! s:ZoomToggle() abort
    if exists('t:zoomed') && t:zoomed
        execute t:zoom_winrestcmd
        let t:zoomed = 0
    else
        let t:zoom_winrestcmd = winrestcmd()
        resize
        vertical resize
        let t:zoomed = 1
    endif
endfunction
command! ZoomToggle call s:ZoomToggle()

" backup the system copied data in l register
augroup random_autocommands "{{{
  autocmd!
  autocmd FocusGained * call YankOnFocusGain()
  " fixes the autoread. (calls autoread on changed files)
  autocmd FocusGained * :checktime
augroup END "}}}


"}}}

" base configuration {{{
set timeoutlen=500                                 " mapping timeout
set ttimeoutlen=50                                 " keycode timeout default set here was 50

set mouse=a                                        " enable mouse
set mousehide                                      " hide when characters are typed
set history=1000                                   " number of command lines to remember
set ttyfast                                        " assume fast terminal connection
set encoding=utf-8                                 " set encoding for text
set clipboard=unnamed                              " sync with OS clipboard
set hidden                                         " allow buffer switching without saving
set autoread                                       " auto reload if file saved externally
set fileformats+=mac                               " add mac to auto-detection of file format line endings
set nrformats-=octal                               " always assume decimal numbers
set shortmess+=c                                   " hides'-- XXX completion (YYY)', 'match 1 of 2', 'The only match'
set showcmd
set tags=tags;/
set showfulltag
set modeline
set modelines=5
set termguicolors
set 'nostartofline'                                          " this keeps the cursor in the same column when you hit G in visual block mode
set noshelltemp                                    " use pipes
set backspace=indent,eol,start                     " allow backspacing everything in insert mode
set autoindent                                     " automatically indent to match adjacent lines
set expandtab                                      " spaces instead of tabs
set smarttab                                       " use shiftwidth to enter tabs

let &tabstop=4                                     " number of spaces per tab for display
let &softtabstop=4                                 " number of spaces per tab in insert mode
let &shiftwidth=4                                  " number of spaces when indenting

set list                                           " highlight whitespace
set listchars=tab:│\ ,trail:•,extends:❯,precedes:❮
set shiftround
set nowrap
set diffopt=filler,vertical

set scrolloff=5                                    " always show content after scroll
set scrolljump=5                                   " minimum number of lines to scroll
set display+=lastline
set wildmenu                                       " show list for autocomplete
set wildmode=list:longest,full
set wildignorecase
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

let g:mapleader = ','
"}}}


" ui configuration {{{
set showmatch                                       "automatically highlight matching braces/brackets/etc.
set matchtime=2                                     "tens of a second to show matching parentheses
set number
" set lazyredraw
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

nnoremap ,jd :exe 'Grepper -noswitch -noopen -jump -tool ag  -query "' . expand('<cword>') . '\s+:"'<CR>

nnoremap <leader>w :w<cr>
nnoremap <silent> <c-a>z :ZoomToggle<CR>

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
" 'ton/vim-bufsurf' "{{{
nnoremap <left>  :BufSurfBack<CR>
nnoremap <right> :BufSurfForward<CR>
"}}}

" 'w0rp/ale' "{{{
let g:ale_sign_error = '✗'
let g:ale_sign_warning = '∆'
let g:ale_linters = {
      \   'javascript': ['eslint'],
      \}

let g:ale_fixers = {}
let g:ale_fixers.javascript = ['eslint']
let g:ale_lint_on_text_changed = 'never'
"}}}
"
"
" godlygeek/tabular "{{{
nmap ga= :Tabularize /=.*/<CR>
vmap ga= :Tabularize /=.*/<CR>
nmap ga: :Tabularize /:.*/<CR>
vmap ga: :Tabularize /:.*/<CR>
" }}}

" 'junegunn/fzf.vim' "{{{
let g:fzf_history_dir = '~/.local/share/fzf-history'
let g:fzf_buffers_jump = 1


" command! -bang -nargs=* Files call fzf#run({'source': 'git ls-files', 'sink': 'e', 'right': '40%'})
"
" " override fzf files command
command! -nargs=* Files call fzf#run({
      \ 'source' : 'ag --hidden --nocolor -l -g ""',
      \ 'sink'   : 'e',
      \ 'down'   : '~40%' })

nnoremap <c-p> :Files<cr>
" command! -bang -nargs=* Ag
"   \ call fzf#vim#ag(<q-args>,
"   \                 <bang>0 ? fzf#vim#with_preview('up:60%')
"   \                         : fzf#vim#with_preview('right:50%:hidden', '?'),
"   \                 <bang>0)

nmap <space> [fzf]
nnoremap [fzf] <nop>
nnoremap [fzf]b :Buffers<cr>
nnoremap [fzf]m :Maps<cr>
nnoremap [fzf]c :Commands<cr>
" }}}

" 'itchyny/lightline.vim' "{{{
" XXX hack https://github.com/itchyny/lightline.vim/issues/55
" it was either this or :h lightline-problem-12
function! GetFilepath()
  return '%f'
endfunction

" this acts as a way to update modified color.
function! MyMode()
  if &modified != get(s:, 'modified')
    let g:lightline.component_type.filepathcustom = &modified ? 'error' : 'warning'
    let s:modified = &modified
    call lightline#init()
    call lightline#update()
  endif
  return lightline#mode()
endfunction

let g:lightline = {
      \ 'colorscheme': 'wombat',
      \ 'active': {
      \   'left': [ [ 'mode', 'paste' ],
      \             [ 'readonly', 'filepathcustom', 'fakeModified' ] ],
      \   'right': [ [ 'filetype' ] ]
      \ },
      \ 'component_function': {
      \    'mode': 'MyMode',
      \ },
      \ 'component_expand': {
      \  'filepathcustom': 'GetFilepath',
      \ },
      \ 'component_type': {
      \   'filepathcustom': 'warning',
      \  },
      \ }
" }}}


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
let g:signify_vcs_list = [ 'git' ]
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

" AndrewRadev/sideways.vim " {{{
nnoremap H :SidewaysLeft<cr>
nnoremap L :SidewaysRight<cr>
" }}}

" 'SirVer/ultisnips' "{{{
let g:UltiSnipsSnippetsDir = '~/.config/nvim/UltiSnips'
let g:UltiSnipsExpandTrigger = '<C-j>'
let g:UltiSnipsJumpForwardTrigger = '<C-j>'
let g:UltiSnipsJumpBackwardTrigger = '<C-k>'
"}}}

" 'mhinz/vim-startify' "{{{
let g:startify_change_to_dir = 0
let g:startify_change_to_vcs_root = 1
" }}}

" 'haya14busa/vim-signjk-motion "{{{
map <leader>j <Plug>(signjk-j)
map <leader>k <Plug>(signjk-k)
"}}}

" 'easymotion/vim-easymotion' "{{{
" let g:EasyMotion_smartcase = 1
map  / <Plug>(easymotion-sn)
" map / <Plug>(incsearch-easymotion-stay)
" omap / <Plug>(easymotion-tn)
" map  n <Plug>(easymotion-next)
" map  N <Plug>(easymotion-prev)
"}}}


" 'mhinz/vie-grepper' "{{{
command! -nargs=* Ack GrepperAg <args>

let g:grepper = {}
" let g:grepper.highlight=1
let g:grepper.quickfix = 1
let g:grepper.stop = 1000
" let g:grepper.side = 1
let g:grepper.open = 0

augroup openquickfix
  autocmd!
  autocmd User Grepper copen
augroup END

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
" let g:mta_use_matchparen_group=0
" let g:mta_set_default_matchtag_color=0
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
" let g:deoplete#enable_at_startup = 1
" let g:deoplete#enable_smart_case = 1
" silent! call deoplete#custom#set('ultisnips', 'rank', 9999)

" function! s:check_back_space() abort "{{{
"   let col = col('.') - 1
"   return !col || getline('.')[col - 1]  =~ '\s'
" endfunction"}}}

" inoremap <silent><expr> <TAB> pumvisible() ? "\<C-n>" : <SID>check_back_space() ? "\<TAB>" : deoplete#mappings#manual_complete()

" }}}
"
" carlitux/deoplete-ternjs "{{{
" let g:deoplete#sources#ternjs#docs = 1
" }}}

" roxma/nvim-completion-manager "{{{
let g:cm_matcher = {'module': 'cm_matchers.fuzzy_matcher', 'case': 'smartcase'}
let g:cm_refresh_default_min_word_len = 2
inoremap <expr> <Tab> pumvisible() ? "\<C-n>" : "\<Tab>"
inoremap <expr> <S-Tab> pumvisible() ? "\<C-p>" : "\<S-Tab>"
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


" ColorScheme {{{
" prevents errors.
silent! colorscheme solarized8_dark
" }}}
