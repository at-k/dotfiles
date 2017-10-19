"-- vimrc

" VI compatibility
set nocompatible
filetype off

if filereadable(expand('~/.vimrc.local'))
	source ~/.vimrc.local
endif

" for debug
" set verbose=1

" Proxy, if necessary
if $http_proxy == ""
	"    let $HTTP_PROXY  =
	"    let $HTTPS_PROXY = $HTTP_PROXY
endif

" Simple note (load from other file)
"let g:SimplenoteUsername =
"let g:SimplenotePassword =
"let g:SimplenoteFiletype = 'markdown'

" Package management
if has('vim_starting')
	set runtimepath+=~/.vim/bundle/neobundle.vim/
endif

" Passing the proxy
let g:neobundle_default_git_protocol='https'

call neobundle#begin(expand('~/.vim/bundle/'))
	NeoBundleFetch 'Shougo/neobundle.vim'

	NeoBundleLazy 'scrooloose/nerdtree', {
				\	'autoload' : { 'commands' : [ "NERDTree" ] } }

	NeoBundleLazy 'mrtazz/simplenote.vim', {
				\	'autoload' : { 'commands' : [ "SimplenoteList" ] } }

	" unite
	NeoBundleLazy 'Shougo/unite.vim', {
				\	'autoload' : { 'commands' : [ "Unite" ] } }

	NeoBundle 'Shougo/neomru.vim', {
				\ 'depends' : 'Shougo/unite.vim' }
	NeoBundle 'ujihisa/unite-colorscheme', {
				\ 'depends' : 'Shougo/unite.vim' }
	NeoBundle 'tacroe/unite-mark', {
				\ 'depends' : 'Shougo/unite.vim' }
	"NeoBundle 'nathanaelkane/vim-indent-guides'
	"NeoBundle 'Shougo/unite-outline'

	if has('lua')
		NeoBundle 'Shougo/neocomplete.vim'
	endif

	" requires clang ... clang include path problem must be solved in default settings
	NeoBundleLazy 'justmao945/vim-clang', {
				\	'autoload' : { 'filetypes' : [ "cpp", "c" ] } }

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
	"NeoBundle 'visualmark.vim'
	"NeoBundle 'vim-scripts/Visual-Mark'
	NeoBundle 'kshenoy/vim-signature'

	" input method(fcitx)
	"NeoBundle 'vim-scripts/fcitx.vim'

	"-- Markdown
	NeoBundle 'plasticboy/vim-markdown'
	NeoBundleLazy 'kannokanno/previm', {
				\	'autoload' : { 'commands' : [ "PrevimOpen" ] } }
	"NeoBundleLazy 'tyru/open-browser.vim', {
	"			\	'autoload' : { 'filetypes' : [ "markdown" ] } }

	"-- coding
	NeoBundle 'majutsushi/tagbar'
	" NeoBundle 'airblade/vim-rooter'
	NeoBundle 'kana/vim-operator-user'
	NeoBundle 'rhysd/vim-operator-surround'
	NeoBundle 'tpope/vim-fugitive'
	NeoBundle 'stephpy/vim-yaml'
	"NeoBundle 'Townk/vim-autoclose'

	NeoBundle 'mhinz/vim-signify'
	" NeoBundle 'airblade/vim-gitgutter'
	" NeoBundle 'wesleyche/SrcExpl'

	"-- color scheme, visual
	" NeoBundle 'miyakogi/seiya.vim'
	" NeoBundle 'altercation/vim-colors-solarized'
	" NeoBundle 'tomasr/molokai'
	" NeoBundle 'sjl/badwolf'
	" NeoBundle 'croaker/mustang-vim'
	" NeoBundle 'nanotech/jellybeans.vim'
	NeoBundle 'sheerun/vim-wombat-scheme'

	"-- status line
	NeoBundle 'itchyny/lightline.vim'
	NeoBundle 'itchyny/vim-gitbranch'

	"-- english completion (neocomplete required)
	NeoBundle 'ujihisa/neco-look'

	"-- fold function expansion
	NeoBundle 'Konfekt/FastFold'

	"-- python
	NeoBundleLazy 'davidhalter/jedi-vim', {
				\	'autoload' : { 'filetypes' : [ "python", "python3", "djangohtml" ] } }
	NeoBundleLazy 'andviro/flake8-vim', {
				\	'autoload' : { 'filetypes' : [ "python" ] } }
	NeoBundleLazy 'hynek/vim-python-pep8-indent', {
				\	'autoload' : { 'filetypes' : [ "python" ] } }
	NeoBundleLazy 'tell-k/vim-autopep8', {
				\	'autoload' : { 'filetypes' : [ "python" ] } }

	"-- ruby
	" code completion
	NeoBundleLazy "osyo-manga/vim-monster", {
				\	'autoload' : { 'filetypes' : [ "ruby" ] } }
	"NeoBundle 'marcus/rsense'
	"NeoBundle 'supermomonga/neocomplete-rsense.vim'

	"-- go
	NeoBundleLazy 'fatih/vim-go', {
				\ 'autoload' : { 'filetypes' : 'go'  }
				\ }

	" static analysis
	NeoBundle 'vim-syntastic/syntastic'

	" referring document
	NeoBundle 'thinca/vim-ref'
	NeoBundle 'yuku-t/vim-ref-ri'

	"-- migemo
	NeoBundle 'haya14busa/vim-migemo'

call neobundle#end()

"-- basic settings
filetype plugin indent on

"-- encodings
set encoding=utf-8
set fileencodings=iso-2022-jp,euc-jp,sjis,utf-8

"-- path setting
set runtimepath+=~/.vim/
runtime! userautoload/*.vim
runtime! plugin_enable/*.vim


"-- for Seiya
"let g:seiya_auto_enable=1

"-- for indent-guides
"augroup indent_guides
"    autocmd!
"    autocmd VimEnter,Colorscheme * :hi IndentGuidesOdd   ctermbg=8
"    autocmd VimEnter,Colorscheme * :hi IndentGuidesEven  ctermbg=247
"augroup END
"let g:indent_guides_auto_colors=0
"let g:indent_guides_enable_on_vim_startup=1
"let g:indent_guides_guide_size=1

" --- setting for teraterm
" ime control over teraterm [caution] it doesnt work though tmux/screen [caution2] this settings prevent multi-key-stroke key map!!
"let &t_SI .= "\e[<r"
"let &t_EI .= "\e[<s\e[<0t"
"let &t_te .= "\e[<0t\e[<s"
"set timeoutlen=100

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
    let QFixHowm_OpenURIcmd = '!start firefox %s'

endif

"---- settings for windows
if has('win32') || has('win64')
    " qfixhowm
    set runtimepath+=c:/apps/qfixapp
    " keymap reader
    let QFixHowm_Key = 'g'

    " howm_dir is a directory to save log
    let howm_dir             = 'c:/work/howm'
    let howm_filename        = '%Y/%m/%Y-%m-%d-%H%M%S.txt'
    let howm_fileencoding    = 'cp932'
    let howm_fileformat      = 'dos'

    " file type
    let QFixHowm_FileType = 'markdown'
    " html converter
    let HowmHtml_ConvertFunc = '<SID>MarkdownStr2HTML'
    "let HowmHtml_ConvertCmd = 'C:/Apps/qfixapp/Markdown_1.0.1/markdown.pl'
    let HowmHtml_ConvertCmd = '"C:/Users/at/AppData/Local/Pandoc/pandoc" -f markdown'
    " outer browser setting
    let QFixHowm_OpenURIcmd = '!start "C:\Program Files (x86)\Mozilla Firefox\firefox.exe" %s'
endif

