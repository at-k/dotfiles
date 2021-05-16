if filereadable(expand('~/.vimrc.local'))
  source ~/.vimrc.local
endif

if &compatible
  set nocompatible
endif

augroup MyAutoCmd
  autocmd!
  autocmd FileType,Syntax,BufNewFile,BufNew,BufRead *?
        \ call vimrc#on_filetype()
  autocmd CursorHold *.toml syntax sync minlines=300
augroup END

if has('vim_starting')
  let $CACHE = expand('~/.cache')
  let $DEINLOG_PATH= '~/.dein.log'

  source ~/.vim/rc/init.rc.vim

  " Load dein.
  let s:dein_dir = finddir('dein.vim', '.;')
  if s:dein_dir != '' || &runtimepath !~ '/dein.vim'
    if s:dein_dir == '' && &runtimepath !~ '/dein.vim'
      let s:dein_dir = expand('$CACHE/dein')
            \. '/repos/github.com/Shougo/dein.vim'
      if !isdirectory(s:dein_dir)
        execute '!git clone https://github.com/Shougo/dein.vim' s:dein_dir
      endif
    endif
    execute 'set runtimepath^=' . substitute(
          \ fnamemodify(s:dein_dir, ':p') , '/$', '', '')
  endif
endif

source ~/.vim/rc/dein.rc.vim

if has('vim_starting') && !empty(argv())
  call vimrc#on_filetype()
endif

if !has('vim_starting')
  call dein#call_hook('source')
  call dein#call_hook('post_source')

  syntax enable
  filetype plugin indent on
endif

source ~/.vim/rc/encoding.rc.vim

source ~/.vim/rc/basic.vim
