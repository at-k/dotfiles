"---------------------------------------------------------------------------
" vimrc functions:
"
function! vimrc#ChangeCurrentDir(directory, bang) abort
    if a:directory == ''
        lcd %:p:h
    else
        execute 'lcd' . a:directory
    endif

    if a:bang == ''
        pwd
    endif
endfunction

function! vimrc#DictionaryTranslate(word) abort
    let l:gene_path = '~/.vim/dict/gene.txt'
    let l:output_option = a:word =~? '^[a-z_]\+$' ? '-A 1' : '-B 1' " eng->jap or jap->eng
    silent pedit Translate\ Result
    wincmd P
    %delete " 前の結果が残っていることがあるため
    setlocal buftype=nofile noswapfile modifiable
    silent execute 'read !grep -ihw' l:output_option a:word l:gene_path
    silent wincmd p
endfunction

function! vimrc#sticky_func() abort
  let sticky_table = {
        \',' : '<', '.' : '>', '/' : '?',
        \'1' : '!', '2' : '@', '3' : '#', '4' : '$', '5' : '%',
        \'6' : '^', '7' : '&', '8' : '*', '9' : '(', '0' : ')',
        \ '-' : '_', '=' : '+',
        \';' : ':', '[' : '{', ']' : '}', '`' : '~', "'" : "\"", '\' : '|',
        \}
  let special_table = {
        \"\<ESC>" : "\<ESC>", "\<Space>" : ';', "\<CR>" : ";\<CR>"
        \}

  let char = ''

  while 1
    let char = nr2char(getchar())

    if char =~ '\l'
      let char = toupper(char)
      break
    elseif has_key(sticky_table, char)
      let char = sticky_table[char]
      break
    elseif has_key(special_table, char)
      let char = special_table[char]
      break
    endif
  endwhile

  return char
endfunction

function! vimrc#add_numbers(num) abort
  let prev_line = getline('.')[: col('.')-1]
  let next_line = getline('.')[col('.') :]
  let prev_num = matchstr(prev_line, '\d\+$')
  if prev_num != ''
    let next_num = matchstr(next_line, '^\d\+')
    let new_line = prev_line[: -len(prev_num)-1] .
          \ printf('%0'.len(prev_num . next_num).'d',
          \    max([0, substitute(prev_num . next_num, '^0\+', '', '')
          \         + a:num])) . next_line[len(next_num):]
  else
    let new_line = prev_line . substitute(next_line, '\d\+',
          \ "\\=printf('%0'.len(submatch(0)).'d',
          \         max([0, substitute(submatch(0), '^0\+', '', '')
          \              + a:num]))", '')
  endif

  if getline('.') !=# new_line
    call setline('.', new_line)
  endif
endfunction

function! vimrc#toggle_option(option_name) abort
  execute 'setlocal' a:option_name.'!'
  execute 'setlocal' a:option_name.'?'
endfunction

function! vimrc#on_filetype() abort "{{{
  if execute('filetype') =~# 'OFF'
    " Lazy loading
    silent! filetype plugin indent on
    syntax enable
    filetype detect
  endif
endfunction "}}}



