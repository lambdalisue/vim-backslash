let s:leading_dict_list_open_rgx = '^.*\(\[\|{\|(\)$'
let s:comment_rgx = '^\s*".*$'

function! backslash#is_continuous() abort
  let line = getline('.')
  return line !~# s:comment_rgx && (line =~# '^\s*\\\s*' || line =~# s:leading_dict_list_open_rgx)
endfunction

function! backslash#is_continuous_cr() abort
  let line = getline('.')
  let prefix = line[:col('.')-2]
  let suffix = line[col('.')-1:]
  let should_add_backslash = suffix =~# '^.*\(\]\|}\|)\).*$'
        \ || (prefix =~# s:leading_dict_list_open_rgx && suffix =~# '^\s*$')

  return line !~# s:comment_rgx && (line =~# '^\s*\\\s*' || should_add_backslash)
endfunction

function! backslash#smart_o() abort
  let lnum = line('.')
  let line = getline(lnum)
  let leading = matchstr(line, '^\s*\\\s*')
  if empty(leading) && line =~# s:leading_dict_list_open_rgx
    let indent = get(g:, 'vim_indent_cont', shiftwidth() * 3)
    let indent += len(matchstr(line, '^\s*'))
    let leading = repeat(' ', indent) . '\ '
  endif
  call append(lnum, leading)
  call setpos('.', [0, lnum+1, 0, 0])
  startinsert!
endfunction

function! backslash#smart_O() abort
  let lnum = line('.')
  let line = getline(lnum)
  let leading = matchstr(line, '^\s*\\\s*')
  call append(lnum-1, leading)
  call setpos('.', [0, lnum, 0, 0])
  startinsert!
endfunction

function! backslash#smart_CR_i() abort
  let lnum = line('.')
  let line = getline(lnum)
  if line =~# '^\s*\\\s*$'
    let indent = get(g:, 'vim_indent_cont', shiftwidth() * 3)
    let leading = matchstr(line, printf('^\s*\ze\s\{%d}\\', indent))
    call setline('.', leading)
    call setpos('.', [0, lnum, 0, 0])
    startinsert!
    return
  endif

  let leading = matchstr(line, '^\s*\\\s*')
  if empty(leading)
    let indent = get(g:, 'vim_indent_cont', shiftwidth() * 3)
    let indent += len(matchstr(line, '^\s*'))
    let leading = repeat(' ', indent) . '\ '
  endif
  let prefix = line[:col('.')-1]
  let suffix = line[col('.'):]
  call setline('.', prefix)
  call append(lnum, leading . suffix)
  call setpos('.', [0, lnum+1, len(leading)+1, 0])
  execute len(suffix) ? 'startinsert' : 'startinsert!'
  return
endfunction
