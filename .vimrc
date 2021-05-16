if filereadable(expand('~/.vimrc.local'))
  source ~/.vimrc.local
endif

if &compatible
  set nocompatible
endif

let g:cache_home = empty($XDG_CACHE_HOME) ? expand('$HOME/.cache') : $XDG_CACHE_HOME
let g:config_home = empty($XDG_CONFIG_HOME) ? expand('$HOME/.config') : $XDG_CONFIG_HOME
let g:dein_toml_dir = expand('$HOME/.vim/rc')
let g:dein_log_path = expand('$HOME/.dein.log')
let g:toml_path = empty($XDG_CONFIG_HOME) ? expand('$HOME/.config') : $XDG_CONFIG_HOME

if has('vim_starting')
  source ~/.vim/rc/init.rc.vim
endif

source ~/.vim/rc/dein.rc.vim

augroup MyAutoCmd
  autocmd FileType,Syntax,BufNewFile,BufNew,BufRead *?
        \ call vimrc#on_filetype()
  autocmd CursorHold *.toml syntax sync minlines=300
augroup END

source ~/.vim/rc/encoding.rc.vim
source ~/.vim/rc/basic.vim
