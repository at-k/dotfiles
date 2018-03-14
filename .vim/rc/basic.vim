"-------------------------------------------------
" Basic Settings
"-------------------------------------------------

" 0: not show, 1: show if more two tabs, 2: show anytime
set showtabline=2

" start scroll when cursor is on N line before last line.
set scrolloff=5

" disable automatic word wrapping. when textwidt=n where n is a positive integer, it is enable.
set textwidth=0

" disable saving backup
set nobackup

" reload file when it is updated
set autoread

" disable swap file
set noswapfile

" enable to open the other file even when current editing file is not saved
set hidden

" enable backspace in insert mode
set backspace=indent,eol,start

" setting for automatic formatting
set formatoptions=lmoq
"autocmd FileType * set formatoptions-=ro

" disable beep sound
set vb t_vb=

" set initial directory for browse command
set browsedir=buffer

" set diff option as vertical
set diffopt+=vertical

" disable spell check for Japanese it works only in vim 7.4.0.88+
set spelllang=en,cjk

" enable cursor wrap when below key down
"  b - [Backspace] normal and visual
"  s - [Space]     normal and visual
"  < - [<-]        normal and visual
"  > - [->]        normal and visual
"  [ - [<-]        insert and replace
"  ] - [->]        insert and replace
"  ~ - ~           normal
set whichwrap=b,s,<,>,[,],~

" show command
set showcmd

" show ruler
set ruler

" show status line at last N line
set laststatus=2

" show cmd message at last N line
set cmdheight=2

" show which mode now
set showmode

" enable mode line
set modeline

" enable mouse operation
set mouse=a

" reload update file on moving from window
augroup vimrc-checktime
  autocmd!
  autocmd WinEnter * checktime
augroup END

" -- clipboard settings : they require vim supporting +clipboard option
" load default value
set clipboard&

" save text selected on visual mode into clipboard
set clipboard+=autoselect

" [caution] this option might have an effect upon yank function
if has('unix') && !has('win32unix') && !has('mac')
	" add yank data to "+ register
	set clipboard^=unnamedplus
elseif has('win32') || has('win64') || has('win32unix')
	" share clipbpard and "* register
	set clipboard+=unnamed
elseif has('mac')
	set clipboard+=unnamed
endif

"-------------------------------------------------
" Color Settings
"-------------------------------------------------

" Color Scheme Configuration
syntax enable

"call togglebg#map("<f5>")
set t_Co=256

highlight clear SpellBad
autocmd ColorScheme * highlight SpellBad cterm=underline

" diff color featured by https://github.com/romainl/Apprentice
autocmd ColorScheme * hi DiffAdd      ctermbg=235  ctermfg=108  guibg=#262626 guifg=#87af87 cterm=reverse  gui=reverse
autocmd ColorScheme * hi DiffChange   ctermbg=235  ctermfg=103  guibg=#262626 guifg=#8787af cterm=reverse  gui=reverse
autocmd ColorScheme * hi DiffDelete   ctermbg=235  ctermfg=131  guibg=#262626 guifg=#af5f5f cterm=reverse  gui=reverse
autocmd ColorScheme * hi DiffText     ctermbg=235  ctermfg=140  guibg=#262626 guifg=#ff8700 cterm=reverse  gui=reverse

function! s:has_colorscheme(name)
  let pat = "colors/".a:name.".vim"
  return !empty(globpath(&rtp, pat))
endfunction

" load main color scheme
" colorscheme molokai
if s:has_colorscheme('wombat')
  colorscheme wombat
else
  colorscheme desert
endif


"-------------------------------------------------
" Editor Settings
"-------------------------------------------------

" show number
set number

" disable color column
set cc=

" show match blanket
set showmatch

" clean up on saving
function! s:remove_dust()
    let cursor = getpos(".")
    " remove line end space
    %s/\s\+$//ge
    " translate tab to two-space
    "%s/\t/  /ge
    call setpos(".", cursor)
    unlet cursor
endfunction
autocmd BufWritePre * call <SID>remove_dust()

augroup FtType
  autocmd!
  autocmd BufRead,BufNewFile *.toml setfiletype conf
augroup END

"-------------------------------------------------
" Indent Settings
"-------------------------------------------------

" put a same amount indent after line feed
set autoindent

" put a smart indent after line feed
set smartindent

" <Tab> size
set tabstop=4

" <Tab> size when <Tab> is input
set softtabstop=4

" auto indent size
set shiftwidth=4

" setting for tab expansion
set noexpandtab
"set expandtab

" insert <Tab> as size of 'shiftwidth' when hit <Tab> on line head
set smarttab

"-------------------------------------------------
" Search Settings
"-------------------------------------------------

" incremental search
set incsearch

" hilight search word
set hlsearch

" ignore capitalization
set ignorecase

" ignore capitalization except for mixing case
set smartcase

" rotate scan result
set wrapscan

" cxwindow auto open
au QuickfixCmdPost make,grep,grepadd,vimgrep copen

"-------------------------------------------------
" Completion Settings
"-------------------------------------------------

" file name completion like shell
set wildmenu

" wildmode options
" ""
" "full"
" "longest"
" "longest:full"
" "list"
" "list:full"
" "list:longest"
set wildmode=list:longest,full

"------------------------------------------------
" Emphasis
"------------------------------------------------
" emphasize some special text
"set list
"set listchars=tab:▸\ ,eol:\ ,trail:-
"set listchars=eol:\ ,trail:-

function! ZenkakuSpace()
  highlight ZenkakuSpace cterm=reverse ctermfg=DarkMagenta gui=reverse guifg=DarkMagenta
endfunction

if has('syntax')
  augroup ZenkakuSpace
    autocmd!
    autocmd ColorScheme       * call ZenkakuSpace()
    autocmd VimEnter,WinEnter * match ZenkakuSpace /　/
  augroup END
  call ZenkakuSpace()
endif

" enable cursorline
augroup cch
  autocmd! cch
"  autocmd WinLeave * set nocursorline
"  autocmd WinLeave * set nocursorcolumn
  autocmd WinEnter,BufRead * set cursorline
"  autocmd WinEnter,BufRead * set cursorcolumn
augroup END

" Create directory automatically
augroup vimrc-auto-mkdir
  autocmd!
  autocmd BufWritePre * call s:auto_mkdir(expand('<afile>:p:h'), v:cmdbang)
  function! s:auto_mkdir(dir, force)
    if !isdirectory(a:dir) && (a:force ||
          \ input(printf('"%s" does not exist. Create? [y/N]', a:dir)) =~? '^y\%[es]$')
      call mkdir(iconv(a:dir, &encoding, &termencoding), 'p')
    endif
  endfunction
augroup END

" print date with C language
function! PrintCtime(format)
	let language =  v:lc_time
	execute ":silent! language time " . "C"
	let ctime = strftime(a:format)
	execute ":silent! language time " . language
	return ctime
endfunction


"-------------------------------------------------
" Key Map
"-------------------------------------------------
cnoremap <C-a> <Home>
cnoremap <C-b> <Left>
cnoremap <C-f> <Right>
" set cedit=<C-i>

" disable yank on deleting
nnoremap x "_x
""nnoremap d "_d
nnoremap D "_D

" escape
if has('unix') && !has('gui_running')
  inoremap <silent> <ESC> <ESC>
  inoremap <silent> <C-[> <ESC>
endif

" tab
nnoremap <C-Tab> gt
nnoremap <S-Tab> gT
nnoremap <Tab><Tab> gT
for i in range(1,9)
    execute 'noremap <Tab>' . i . ' ' . i . 'gt'
endfor

nnoremap <silent> <S-k> :tabnext<CR>
nnoremap <silent> <S-j> :tabprevious<CR>

" wrap
nnoremap j gj
nnoremap k gk

" whichwrap
nnoremap h <Left>zv
nnoremap l <Right>zv

"--- insert mode
" emacs like
"inoremap <C-e> <END>
"inoremap <C-a> <HOME>
"inoremap <C-p> <Up>
"inoremap <C-n> <Down>
"inoremap <C-f> <Right>
"inoremap <C-b> <Left>
inoremap <C-h> <BackSpace>
"inoremap <C-k> <C-d>D
"inoremap <C-u> <C-o>d0
"inoremap <C-y> <C-o>P

"--- qfix
nnoremap ]q :cnext<CR>
nnoremap [q :cprevious<CR>

"--- fold


"--- prefix settings
" reserve prefix
nnoremap <Space>	<Nop>
nnoremap ,			<Nop>
nnoremap s			<Nop>

" prefix
nnoremap [plugin]   <Nop>
nnoremap [orgfunc]	<Nop>
nnoremap [unite]    <Nop>
nnoremap [winr]     <Nop>
"nnoremap [mark]		<Nop>
nnoremap [templ]	<Nop>
nmap     <Space>p	[plugin]
nmap     <Space>o	[orgfunc]
nmap     <Space>u	[unite]
nmap     <Space>w [winr]
"nmap	 <Space>m	[mark]
nmap	 <Space>t	[templ]

"--- plugin
" invoke NERDTree
nnoremap [plugin]n :<C-u>NERDTree<CR>
" invoke tag bar
nnoremap [plugin]t :TagbarToggle<CR>
" for unite
nnoremap <silent> [unite]c   :<C-u>UniteWithCurrentDir -buffer-name=files buffer file_mru bookmark file<CR>
nnoremap <silent> [unite]b   :<C-u>Unite buffer<CR>
nnoremap <silent> [unite]m	 :Unite mark<CR>
nnoremap <silent> [unite]i	 :Unite colorscheme -auto-preview<CR>
nnoremap <silent> [winr]     :WinResizerStartResize<CR>

" for mark
"nnoremap <silent> [mark]	`

" <F6>  inserting date
nnoremap ,tl <ESC>i<C-R>=strftime("%Y/%m/%d (%a) %H:%M")<CR>
nnoremap ,ts <ESC>i<C-R>=strftime("%y%m%d")<CR>

"-------------------------------------------------
" Original commmand
"-------------------------------------------------
command! -nargs=1 -complete=command DictionaryTranslate call vimrc#DictionaryTranslate(<f-args>)

" Change Dir
command! -nargs=? -complete=dir -bang CD  call vimrc#ChangeCurrentDir('<args>', '<bang>')
nnoremap <silent> <Space>cd :<C-u>CD<CR>

