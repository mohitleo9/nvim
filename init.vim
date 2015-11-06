" vim: fdm=marker ts=2 sts=2 sw=2 fdl=9
" ============================================================================

call plug#begin()
" functions {{{
  function! Source(begin, end) "{{{
    let lines = getline(a:begin, a:end)
    for line in lines
      execute line
    endfor
  endfunction "}}}
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

  " taken from stevelosh learnvimscriptthehardway
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
  set viewoptions=folds,options,cursor,unix,slash     "unix/windows compatibility
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

  set scrolloff=1                                     "always show content after scroll
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
      set undodir=~/.vim/.cache/undo
    endif

    " backups
    set backup
    set backupdir=~/.vim/.cache/backup

    " swap files
    set directory=~/.vim/.cache/swap
    set noswapfile

    call EnsureExists('~/.vim/.cache')
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
  augroup fixcursorline
    autocmd!
    autocmd WinLeave * setlocal nocursorline
    autocmd WinEnter * setlocal cursorline
  augroup END
    set cursorcolumn
    augroup restoreCursorline
        autocmd!
        autocmd WinLeave * setlocal nocursorcolumn
        autocmd WinEnter * setlocal cursorcolumn
    augroup END

  if has('conceal')
    set conceallevel=1
    set listchars+=conceal:Δ
  endif

"}}}

" Core Plugins {{{
    Plug 'tpope/vim-sensible'
    Plug 'AndrewRadev/splitjoin.vim'
    Plug 'majutsushi/tagbar' "{{{
        let g:tagbar_sort = 0
    " }}}
    Plug 'editorconfig/editorconfig-vim'
    Plug 'chrisbra/NrrwRgn'
    Plug 't9md/vim-quickhl' "{{{
        nmap <leader>m <Plug>(quickhl-manual-this)
        xmap <leader>m <Plug>(quickhl-manual-this)
        nmap <leader>M <Plug>(quickhl-manual-reset)
        xmap <leader>M <Plug>(quickhl-manual-reset)
    "}}}
    Plug 'ton/vim-bufsurf'
    Plug 'epeli/slimux'
    Plug 'matchit.zip'
    Plug 'bling/vim-airline' "{{{
        let g:airline#extensions#tabline#enabled = 1
        let g:airline_powerline_fonts = 1
        let g:airline_theme="luna"
    "}}}
    Plug 'tpope/vim-surround' "{{{
    " trial
        nmap s <Plug>Ysurround
    " }}}
    " this plugin overrides the default text objects in vim and first make them multiline and also provides
    " some new operators such as , _ etc
    Plug 'wellle/targets.vim'
    Plug 'tpope/vim-sleuth'
    Plug 'tpope/vim-repeat'
    Plug 'Peeja/vim-cdo'
    Plug 'tpope/vim-eunuch'
    Plug 'tpope/vim-unimpaired' "{{{
        nmap <c-up> [e
        nmap <c-down> ]e
        vmap <c-up> [egv
        vmap <c-down> ]egv
    "}}}
    "this plugin can toggle between true and false and a whole lot more
    Plug 'AndrewRadev/switch.vim' " {{{
        nnoremap <c-c> :Switch<cr>
    " }}}
"}}}

" Web Plugins {{{
  Plug 'groenewege/vim-less'
  Plug 'cakebaker/scss-syntax.vim'
  Plug 'gregsexton/MatchTag', {'for': ['html','xml']}
  Plug 'mattn/emmet-vim'
"}}}

" Javascript Plugins {{{
  Plug 'marijnh/tern_for_vim', {'for': ['javascript'], 'do': 'npm install'} " {{{
      " tern config
      let g:tern_map_keys=1
      autocmd FileType javascript nmap <buffer> <leader>jd :TernDef<cr>
      let g:tern_show_argument_hits='on_hold'
  " }}}
  Plug 'mohitleo9/vim-fidget', {'do': 'npm install --production', 'on': 'VimFidget'}
  Plug 'jelera/vim-javascript-syntax', {'for': 'javascript'}
  Plug 'mxw/vim-jsx'
  Plug 'kchmck/vim-coffee-script'
  Plug 'elzr/vim-json', {'for': ['javascript','json']}
  " breaks some coffe shit.
  Plug 'othree/javascript-libraries-syntax.vim', {'for': ['javascript','typescript']}
" }}}
call plug#end()
