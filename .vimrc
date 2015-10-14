" .vimrc
" See: http://vimdoc.sourceforge.net/htmldoc/options.html for details

" For multi-byte character support (CJK support, for example):
"set fileencodings=ucs-bom,utf-8,cp936,big5,euc-jp,euc-kr,gb18030,latin1

set tabstop=4       " Number of spaces that a <Tab> in the file counts for.

set shiftwidth=4    " Number of spaces to use for each step of (auto)indent.

set expandtab       " Use the appropriate number of spaces to insert a <Tab>.
                    " Spaces are used in indents with the '>' and '<' commands
                    " and when 'autoindent' is on. To insert a real tab when
                    " 'expandtab' is on, use CTRL-V <Tab>.

set smarttab        " When on, a <Tab> in front of a line inserts blanks
                    " according to 'shiftwidth'. 'tabstop' is used in other
                    " places. A <BS> will delete a 'shiftwidth' worth of space
                    " at the start of the line.

set showcmd         " Show (partial) command in status line.

set number          " Show line numbers.

set showmatch       " When a bracket is inserted, briefly jump to the matching
                    " one. The jump is only done if the match can be seen on the
                    " screen. The time to show the match can be set with
                    " 'matchtime'.

set hlsearch        " When there is a previous search pattern, highlight all
                    " its matches.

set incsearch       " While typing a search command, show immediately where the
                    " so far typed pattern matches.

set ignorecase      " Ignore case in search patterns.

set smartcase       " Override the 'ignorecase' option if the search pattern
                    " contains upper case characters.

set backspace=2     " Influences the working of <BS>, <Del>, CTRL-W
                    " and CTRL-U in Insert mode. This is a list of items,
                    " separated by commas. Each item allows a way to backspace
                    " over something.

set autoindent      " Copy indent from current line when starting a new line
                    " (typing <CR> in Insert mode or when using the "o" or "O"
                    " command).

set textwidth=80    " Maximum width of text that is being inserted. A longer
                    " line will be broken after white space to get this width.

set formatoptions=c,q,r,t " This is a sequence of letters which describes how
                    " automatic formatting is to be done.
                    "
                    " letter    meaning when present in 'formatoptions'
                    " ------    ---------------------------------------
                    " c         Auto-wrap comments using textwidth, inserting
                    "           the current comment leader automatically.
                    " q         Allow formatting of comments with "gq".
                    " r         Automatically insert the current comment leader
                    "           after hitting <Enter> in Insert mode.
                    " t         Auto-wrap text using textwidth (does not apply
                    "           to comments)

set ruler           " Show the line and column number of the cursor position,
                    " separated by a comma.

set background=dark " When set to "dark", Vim will try to use colors that look
                    " good on a dark background. When set to "light", Vim will
                    " try to use colors that look good on a light background.
                    " Any other value is illegal.

set mouse=a         " Enable the use of the mouse.

set autochdir		" Open file browser relative to current file

filetype plugin on "indent deleted
syntax on

" spell check
function! SpellToggle()
	if &l:spell == 0
		:setlocal spell spelllang=en_us
	else
		:setlocal nospell
	endif
endfunction
noremap <silent> <F8> :call SpellToggle()<CR>

function! VagrantPush()
    :silent !vagrant unify-push
    :redraw!
endfunction
noremap <silent> <c-i> :call VagrantPush()<CR>

" color things
set t_Co=256
colorscheme gentooish
if has("gui_running")
	colorscheme desert
endif

" tabs sizes for various file types
autocmd FileType lisp setlocal shiftwidth=2 tabstop=2
autocmd FileType html setlocal shiftwidth=2 tabstop=2
autocmd FileType htmldjango setlocal shiftwidth=2 tabstop=2
autocmd FileType asm setlocal shiftwidth=8 tabstop=8

" for closing brackets automatically
function! AutoBracket()
	inoremap {      {}<Left>
	inoremap {<CR>  {<CR>}<Esc>O
	inoremap {{     {
	inoremap {}     {}
endfunction

" but don't do this for html files
function! ResetBracket()
	inoremap {		{
	inoremap {<CR>  {
	inoremap {{     {{
	inoremap {}     {}
endfunction
autocmd Filetype * call AutoBracket()
autocmd Filetype xml,html,xhtml call ResetBracket()

autocmd Filetype twig setlocal filetype=htmldjango

" Django specific
nnoremap gL :setfiletype htmldjango<CR>

" for comments -- I don't actually remember what this does
"au FileType c,cpp setlocal comments-=:// comments+=f://

" fix leader key
" let mapleader = ","

" let ; map to : for commands
" hit ;; twice for normal use (repeat f or t)
map ; :
nnoremap ;; ;

set nocp
filetype plugin on

" utf=8
if	has("multi_byte")
	set	encoding=utf-8
endif

" Vundle
set nocompatible
filetype off
"filetype plugin indent on "indent deleted

set rtp+=~/.vim/bundle/Vundle.vim
"call vundle#rc()
call vundle#begin()

" let Vundle manage Vundle
" required!
Plugin 'gmarik/Vundle.vim'

" My Bundles here:

" original repos on github
Plugin 'tpope/vim-fugitive'
Plugin 'tpope/vim-dispatch.git'
Plugin 'tpope/vim-surround'
Plugin 'tpope/vim-repeat'
Plugin 'tpope/vim-commentary'
Plugin 'tpope/vim-ragtag'
Plugin 'tpope/vim-obsession'

Plugin 'Lokaltog/vim-easymotion'
let g:EasyMotion_leader_key = ','

" YCM
Plugin 'Valloric/YouCompleteMe'
let g:ycm_global_ycm_extra_conf = '~/.vim/.ycm_global_conf.py'
let g:ycm_autoclose_preview_window_after_completion = 1
let g:ycm_collect_identifiers_from_tags_files = 1

" TAGS omg
Plugin 'xolox/vim-misc'
Plugin 'xolox/vim-easytags'
let g:easytags_async = 1
let g:easytags_dynamic_files = 1
let g:easytags_auto_highlight = 0
Plugin 'majutsushi/tagbar'
nmap <silent>gv :TagbarToggle<CR>

" Syntastic
Plugin 'scrooloose/syntastic'
let g:syntastic_python_checkers=['pyflakes']

function! SyntasticPythonToggle()
	if g:syntastic_python_checkers == ['pyflakes']
		let g:syntastic_python_checkers=['pylint']
    else
		let g:syntastic_python_checkers=['pyflakes']
	endif
endfunction
command SyntasticPythonToggle call SyntasticPythonToggle()

" for auto complete () and {}, etc
Plugin 'Raimondi/delimitMate'

" Multi-cursors
Plugin 'terryma/vim-multiple-cursors'

" NerdTree
Plugin 'scrooloose/nerdtree'
autocmd bufenter * if (winnr("$") == 1 && exists("b:NERDTreeType") && b:NERDTreeType == "primary") | q | endif
nmap <silent>gf :NERDTreeToggle .<CR>
"let NERDTreeChDirMode=2

" Rust syntax highlighting
Plugin 'wting/rust.vim'

" php stuff ugh
" this doesn't even work right
" Plugin 'Shougo/unite.vim'
" Plugin 'Shougo/vimproc'
" Plugin 'm2mdas/phpcomplete-extended'
" Plugin 'm2mdas/phpcomplete-extended-symfony'
Plugin 'joonty/vdebug.git'
let g:vdebug_options = {}
let g:vdebug_options["port"] = 9000
let g:vdebug_options["path_maps"] = {
\    "/vagrant": "/Users/mikeattwood/sites/CyberSponse"
\}

" searching stuff
Plugin 'rking/ag.vim'
let g:ag_working_path_mode="r"
let g:ag_highlight=1
cnoreabbrev ag Ag

Plugin 'kien/ctrlp.vim'
if executable('ag')
  " Use ag in CtrlP for listing files.
  let g:ctrlp_user_command = 'ag %s --files-with-matches -g "" --ignore-case --skip-vcs-ignores'
endif

" ctrlp stuff
let g:ctrlp_custom_ignore = '\v[\/]\.(git|hg|svn)$'
let g:ctrlp_working_path_mode = 'ra'
let g:ctrlp_map = '<c-p>'
let g:ctrlp_cmd = 'CtrlP'

" go
Plugin 'fatih/vim-go'

" status line
Plugin 'bling/vim-airline'
set laststatus=2

" end vundle
call vundle#end()
filetype plugin indent on

" other remaps
nnoremap gt :tabnew <CR>
nnoremap gn :tabnext <CR>
nnoremap gp :tabpre <CR>
nnoremap j gj
nnoremap k gk

" clear search
nnoremap <silent> ,a :let @/ = "" <CR>

set wildmenu
set wildmode=longest:full,full
set noswapfile
