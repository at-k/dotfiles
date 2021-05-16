" dein configurations.

let g:dein#install_progress_type = 'title'
let g:dein#enable_notification = 1
let g:dein#install_max_processes = 16
let g:dein#install_message_type = 'none'
let g:dein#install_log_filename = g:dein_log_path

let s:path =  g:cache_home . '/dein'

if has('vim_starting')
  " Load dein.
  let s:dein_dir = finddir('dein.vim', '.;')
  if s:dein_dir != '' || &runtimepath !~ '/dein.vim'
    if s:dein_dir == '' && &runtimepath !~ '/dein.vim'
      let s:dein_dir = expand(s:path)
            \. '/repos/github.com/Shougo/dein.vim'
      if !isdirectory(s:dein_dir)
        execute '!git clone https://github.com/Shougo/dein.vim' s:dein_dir
      endif
    endif
    execute 'set runtimepath^=' . substitute(
          \ fnamemodify(s:dein_dir, ':p') , '/$', '', '')
  endif
endif

if !dein#load_state(s:path)
	finish
else
  call dein#begin(s:path, expand('<sfile>'))

  call dein#load_toml(g:dein_toml_dir . '/dein.toml', {'lazy': 0})
  call dein#load_toml(g:dein_toml_dir . '/deinlazy.toml', {'lazy': 1})

  if has('nvim')
    call dein#load_toml(g:dein_toml_dir . '/lsp.toml', {'lazy': 0})
  "  call dein#load_toml(g:dein_toml_dir . '/neovim.toml', {'lazy': 0})
  else
    call dein#load_toml(g:dein_toml_dir . '/dein_completion.toml', {'lazy': 0})

    call dein#add('roxma/nvim-yarp')
    call dein#add('roxma/vim-hug-neovim-rpc')
  endif

  call dein#end()
  call dein#save_state()
endif

if has('vim_starting') && dein#check_install()
	call dein#install()
endif

if has('vim_starting') && !empty(argv())
  call vimrc#on_filetype()
endif

if !has('vim_starting')
  call dein#call_hook('source')
  call dein#call_hook('post_source')

  syntax enable
  filetype plugin indent on
endif
