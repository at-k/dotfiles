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
  source ~/.vim/rc/init.rc.vim
endif

if has('vim_starting') && !empty(argv())
  call vimrc#on_filetype()
endif

" if !has('vim_starting')
"   call dein#call_hook('source')
"   call dein#call_hook('post_source')
"
"   syntax enable
"   filetype plugin indent on
" endif

source ~/.vim/rc/encoding.rc.vim

source ~/.vim/rc/basic.vim

let g:plug_shallow = 0
call plug#begin('~/.vim/plugged')
Plug 'tpope/vim-sensible'
call plug#end()
