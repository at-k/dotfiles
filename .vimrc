"-- vimrc

" for vi compatibility
set nocompatible
filetype off

" Package management
if has('vim_starting')
    set runtimepath+=~/.vim/bundle/neobundle.vim/
endif

call neobundle#begin(expand('~/.vim/bundle/'))
    NeoBundleFetch 'Shougo/neobundle.vim'

    NeoBundle 'Shougo/neobundle.vim'
    NeoBundle 'scrooloose/nerdtree'
    "NeoBundle 'Townk/vim-autoclose'
    NeoBundle 'mrtazz/simplenote.vim'

    " requires python extention
    NeoBundle 'Shougo/unite.vim'

    NeoBundle 'ujihisa/unite-colorscheme'
    "NeoBundle 'nathanaelkane/vim-indent-guides'
    "NeoBundle 'Shougo/unite-outline'

	"if has('lua')
	" requires lua extention
	NeoBundle 'Shougo/neocomplete.vim'
	"endif

    " requires clang ... clang include path problem must be solved in default settings
    NeoBundle 'justmao945/vim-clang'
    "NeoBundle 'Shougo/neocomplcache-clang_complete'
    "NeoBundle 'Rip-Rip/clang_complete'

    NeoBundle 'Shougo/vimproc.vim', {
                \ 'build' : {
                \ 'windows' : 'make -f make_mingw32.mak',
                \ 'cygwin' : 'make -f make_cygwin.mak',
                \ 'mac' : 'make -f make_mac.mak',
                \ 'unix' : 'make -f make_unix.mak',
                \ },
                \ }
    NeoBundle 'Shougo/neoinclude.vim'

    "-- binary mode
    NeoBundle 'Shougo/vinarise'

    "-- Mark function
    "NeoBundle 'vim-scripts/ShowMarks'
    NeoBundle 'tacroe/unite-mark'
    "NeoBundle 'visualmark.vim'

    " input method(fcitx)
    "NeoBundle 'vim-scripts/fcitx.vim'

    "-- Markdown
    NeoBundle 'plasticboy/vim-markdown'
    NeoBundle 'kannokanno/previm'
    NeoBundle 'tyru/open-browser.vim'

    "-- coding
    NeoBundle 'majutsushi/tagbar'
    NeoBundle 'airblade/vim-rooter'
	NeoBundle 'kana/vim-operator-user'
	NeoBundle 'rhysd/vim-operator-surround'
    NeoBundle 'tpope/vim-fugitive'

    "-- color scheme, visual
    NeoBundle 'miyakogi/seiya.vim'
    NeoBundle 'altercation/vim-colors-solarized'
    NeoBundle 'tomasr/molokai'
    "NeoBundle 'sjl/badwolf'
    NeoBundle 'croaker/mustang-vim'
    NeoBundle 'nanotech/jellybeans.vim'

	"-- status line
    NeoBundle 'itchyny/lightline.vim'

	"-- english completion
	NeoBundle 'ujihisa/neco-look'

	"-- fold function expansion
	NeoBundle 'Konfekt/FastFold'

	"-- python
	NeoBundle 'davidhalter/jedi-vim'
	NeoBundle 'andviro/flake8-vim'
	NeoBundle 'hynek/vim-python-pep8-indent'
	NeoBundle 'tell-k/vim-autopep8'

	"-- migemo
	NeoBundle 'haya14busa/vim-migemo'

call neobundle#end()

"-- basic settings
filetype plugin on
filetype indent on


"-- encodings
set encoding=utf-8
set fileencodings=iso-2022-jp,euc-jp,sjis,utf-8

"-- path setting
set runtimepath+=~/.vim/
runtime! userautoload/*.vim
runtime! plugin_enable/*.vim

"-- for Seiya
let g:seiya_auto_enable=1

"-- for indent-guides
"augroup indent_guides
"    autocmd!
"    autocmd VimEnter,Colorscheme * :hi IndentGuidesOdd   ctermbg=8
"    autocmd VimEnter,Colorscheme * :hi IndentGuidesEven  ctermbg=247
"augroup END
"let g:indent_guides_auto_colors=0
"let g:indent_guides_enable_on_vim_startup=1
"let g:indent_guides_guide_size=1


" --- settings for linux
if has("unix")
    " --- input method settings (fcitx)
    function! Fcitx2en()
        let s:input_status = system("fcitx-remote")
        if s:input_status == 2
            let l:a = system("fcitx-remote -c")
        endif
    endfunction

    set ttimeoutlen=150
    augroup fcitx_control
        autocmd!
        "
        autocmd InsertLeave * call Fcitx2en()
        "
        "autocmd InsertEnter * call Fcitx2zh()
    augroup END

    " --- qfixhowm
    set runtimepath+=~/.vim/qfixapp
    "
    let QFixHowm_Key = 'g'
    " howm_dir
    let howm_dir             = '~/Dropbox/howm'
    let howm_filename        = '%Y/%m/%Y-%m-%d-%H%M%S.txt'
    let howm_fileencoding    = 'cp932'
    let howm_fileformat      = 'dos'

    " file type
    let QFixHowm_FileType = 'markdown'
    " html converter
    let HowmHtml_ConvertFunc = '<SID>MarkdownStr2HTML'
    "let HowmHtml_ConvertCmd = 'C:/Apps/qfixapp/Markdown_1.0.1/markdown.pl'
"    let HowmHtml_ConvertCmd = '"C:/Users/at/AppData/Local/Pandoc/pandoc" -f markdown'
    "
    let QFixHowm_OpenURIcmd = '!start firefox %s'

endif
