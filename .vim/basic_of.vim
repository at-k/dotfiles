"-------------------------------------------------
" 基本設定
"-------------------------------------------------
set fileencodings=iso-2022-jp,euc-jp,sjis,utf-8 " 自動識別エンコード種別追加

set showtabline=2       " タブページを常に表示(2)

set scrolloff=5         " カーソルの上または下に表示する最小限の行数

set cursorline          " 現在のカーソル行をハイライト

set cursorcolumn        " 現在のカーソル列をハイライト

set showmatch           " 対応する括弧位置を表示する

set number              " 行番号を表示

set textwidth=0         " テキストの最大幅 「0」で無効。そうでない場合は指定幅で自動改行される。

set nobackup            " バックアップの作成は行わない

set noswapfile          " スワップファイルの作成は行わない

set autoread            " Vimの外部で変更されたことが判明したとき、自動的に読み直す

set hidden              " 保存しないで他のファイルを表示することが出来るようにする

set backspace=indent,eol,start  " バックスペースでインデントや改行を削除できるようにする

set formatoptions=lmoq  " 自動整形の実行方法

set visualbell t_vb=    " ビープ音 ビジュアルベルを使用しない

set browsedir=buffer    " ファイルブラウザの初期ディレクトリ

set whichwrap=b,s,<,>,[,],~     " 特定のキーに行頭および行末の回りこみ移動を許可する設定

set showcmd             " コマンド (の一部) を画面の最下行に表示する

set ruler               " カーソルが何行目の何列目に置かれているかを表示する

set laststatus=2        " ステータス行を常に表示する

set cmdheight=2         " コマンドラインに使われる画面上の行数

set showmode            " Insertモード、ReplaceモードまたはVisualモードで最終行にメッセージを表示する

set nomodeline          " モードラインの無効化

set mouse=a             " すべてのモードでマウスが有効

augroup my_ers_end      " 保存時に行末の空白を除去する
    autocmd!
    autocmd BufWritePre * :%s/\s\+$//e
augroup END

"-------------------------------------------------
" Indent インデント設定
"-------------------------------------------------
set autoindent          " 改行時にインデントを現在行と同じ量にする

set smartindent         " 新しい行を作ったときに高度な自動インデントを行う

set tabstop=4           " <Tab> が対応する空白の数。

set softtabstop=4       " <Tab> の挿入や <BS> の使用等の編集時に、<Tab> が対応する空白の数。

set shiftwidth=4        " インデントの各段階に使われる空白の数

set expandtab           " Insertモードで <Tab> を挿入するのに、適切な数の空白を使う

set smarttab            " 行頭の余白内で Tab を打ち込むと、'shiftwidth' の数だけインデントする

"-------------------------------------------------
" Search 検索設定
"-------------------------------------------------
set incsearch           " インクリメンタルサーチ

set hlsearch            " サーチ結果ハイライト

augroup my_qfix_cmd     " *grep時に自動でcwを開く
    autocmd!
    autocmd QuickFixCmdPost *grep* cwindow
augroup END

"-------------------------------------------------
" Completion コマンドライン補完設定
"-------------------------------------------------
set wildmenu            " ファイル名のタブ補完を有効化

set wildmode=list:longest,full  " マッチ対象をリスト表示，タブで次のマッチ表示

"-------------------------------------------------
" Color カラースキーム
"-------------------------------------------------
syntax enable           " シンタックス色づけ有効化

"call togglebg#map("<f5>")
set t_Co=256
let g:solarized_termcolors=256
let g:solarized_termtrans=0
let g:solarized_degrade=0
let g:solarized_bold=1
let g:solarized_underline=1
let g:solarized_italic=1
let g:solarized_contrast="normal"
let g:solarized_visibility="normal"
set background=light
"set background=dark
"colorschem solarized

colorscheme molokai
"colorscheme mustang

"-------------------------------------------------
" Mappings キーマッピング
"-------------------------------------------------

nnoremap x "_x
nnoremap D "_D

" ----------  tab移動
nnoremap <silent> <S-k> :tabnext<CR>
nnoremap <silent> <S-j> :tabprevious<CR>

" ----------  wrap行についての上下
nnoremap j gj
nnoremap k gk

" ----------  whichwrap(行頭→前の行の行末，行末→次の行の行頭)
nnoremap h <Left>zv
nnoremap l <Right>zv

" ----------  入力モードでEmacs-like
inoremap <C-a> <Home>
inoremap <C-e> <End>
inoremap <C-b> <Left>
inoremap <C-f> <Right>
inoremap <C-n> <C-c>gja
inoremap <C-p> <C-c>gka
inoremap <C-h> <BS>
inoremap <C-d> <Del>
"inoremap <C-k> <C-o>D

" ----------  NERDTree関係
if exists('g:NERDTree')
    nmap ,ne :<C-u>NERDTree<CR> " カレントディレクトリでNERDTree開き直す
endif

"-------------------------------------------------
" カレントディレクトリ移動関数
"-------------------------------------------------
" set autochdirとすれば自動で現在のバッファをカレントにするが
" そうすると，tag移動が有効に動かなくなるケースがある。
command! -nargs=? -complete=dir -bang CD  call s:ChangeCurrentDir('<args>', '<bang>')
function! s:ChangeCurrentDir(directory, bang)
    if a:directory == ''
        lcd %:p:h
    else
        execute 'lcd' . a:directory
    endif

    if a:bang == ''
        pwd
    endif
endfunction

nnoremap <silent> <Space>cd :<C-u>CD<CR>


" ------------------------------------------------
"  その他
" ------------------------------------------------
" ----------  タブ,eolに文字割り当て
"set list
"set listchars=tab:?\ ,eol:\ ,trail:-
"set listchars=tab:>-,nbsp:%,trail:_,extends:>,precedes:<

" ----------  全角スペースを強調表示
augroup highlightIdegraphicSpace
    autocmd!
    autocmd Colorscheme * highlight IdeographicSpace term=underline ctermbg=DarkGreen guibg=DarkGreen
    autocmd VimEnter,WinEnter * match IdeographicSpace /　/
augroup END


" ----------  挿入モード時のステータスラインの色指定
" 参考：https://github.com/fuenor/vim-statusline/blob/master/insert-statusline.vim
if !exists('g:hi_insert')
  let g:hi_insert = 'highlight StatusLine guifg=White guibg=DarkCyan gui=none ctermfg=White ctermbg=DarkCyan cterm=none'
endif

if has('unix') && !has('gui_running')
  inoremap <silent> <ESC> <ESC>
  inoremap <silent> <C-[> <ESC>
endif

if has('syntax')
  augroup InsertHook
    autocmd!
    autocmd InsertEnter * call s:StatusLine('Enter')
    autocmd InsertLeave * call s:StatusLine('Leave')
  augroup END
endif

let s:slhlcmd = ''
function! s:StatusLine(mode)
  if a:mode == 'Enter'
    silent! let s:slhlcmd = 'highlight ' . s:GetHighlight('StatusLine')
    silent exec g:hi_insert
  else
    highlight clear StatusLine
    silent exec s:slhlcmd
  endif
endfunction

function! s:GetHighlight(hi)
  redir => hl
  exec 'highlight '.a:hi
  redir END
  let hl = substitute(hl, '[\r\n]', '', 'g')
  let hl = substitute(hl, 'xxx', '', '')
  return hl
endfunction

" ----------  ファイルセーブ時にディレクトリが存在しない場合は生成
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

" ----------  NERD Tree 設定
if exists('g:NERDTree')
    let NERDTreeShowHidden = 1 " NERDTreeを隠す
    " 引数なしで実行したとき、NERDTreeを実行する
    "let file_name = expand("%:p")
    "if has('vim_starting') && file_name == ""
    "    autocmd VimEnter * call ExecuteNERDTree()
    "endif
    "
    "function! ExecuteNERDTree()
    "    "b:nerdstatus = 1 : NERDTree 表示中
    "    "b:nerdstatus = 2 : NERDTree 非表示中
    "
    "    if !exists('g:nerdstatus')
    "        execute 'NERDTree ./'
    "        let g:windowWidth = winwidth(winnr())
    "        let g:nerdtreebuf = bufnr('')
    "        let g:nerdstatus = 1
    "
    "        elseif g:nerdstatus == 1
    "        execute 'wincmd t'
    "        execute 'vertical resize' 0
    "        execute 'wincmd p'
    "        let g:nerdstatus = 2
    "        elseif g:nerdstatus == 2
    "        execute 'wincmd t'
    "        execute 'vertical resize' g:windowWidth
    "        let g:nerdstatus = 1
    "
    "    endif
    "endfunction
endif
