if exists('b:backslash_loaded')
  finish
endif
let b:backslash_loaded = 1

let s:leading_dict_list_open_rgx = '^.*\(\[\|{\|(\)$'

function! s:is_continuous() abort
  return getline('.') =~# '^\s*\\\s*' || getline('.') =~# s:leading_dict_list_open_rgx
endfunction

function! s:is_continuous_cr() abort
  let line = getline('.')
  let prefix = line[:col('.')-2]
  let suffix = line[col('.')-1:]
  let should_add_backslash = suffix =~# '^.*\(\]\|}\|)\)$'
        \ || (prefix =~# '^.*\(\[\|{\|(\)$' && suffix =~# '^\s*$')

  return line =~# '^\s*\\\s*' || should_add_backslash
endfunction

function! s:smart_o() abort
  let lnum = line('.')
  let line = getline(lnum)
  let leading = matchstr(line, '^\s*\\\s*')
  if empty(leading) && line =~# s:leading_dict_list_open_rgx
    let indent = get(g:, 'vim_indent_cont', shiftwidth() * 3)
    let leading = repeat(' ', indent) . '\ '
  endif
  call append(lnum, leading)
  call setpos('.', [0, lnum+1, 0, 0])
  startinsert!
endfunction

function! s:smart_O() abort
  let lnum = line('.')
  let line = getline(lnum)
  let leading = matchstr(line, '^\s*\\\s*')
  call append(lnum-1, leading)
  call setpos('.', [0, lnum, 0, 0])
  startinsert!
endfunction

function! s:smart_CR_i() abort
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

nnoremap <silent><buffer><expr> <Plug>(backslash-o) <SID>is_continuous()
      \ ? ":\<C-u>call \<SID>smart_o()\<CR>"
      \ : 'o'

nnoremap <silent><buffer><expr> <Plug>(backslash-O) <SID>is_continuous()
      \ ? ":\<C-u>call \<SID>smart_O()\<CR>"
      \ : 'O'

inoremap <silent><buffer><expr> <Plug>(backslash-CR-i) <SID>is_continuous_cr()
      \ ? "\<Esc>:\<C-u>call \<SID>smart_CR_i()\<CR>"
      \ : "\<CR>"

nmap <buffer> o    <Plug>(backslash-o)
nmap <buffer> O    <Plug>(backslash-O)
imap <buffer> <CR> <Plug>(backslash-CR-i)

let b:undo_ftplugin =
      \ get(b:, 'undo_ftplugin', '')
      \ . '| silent! nunmap <buffer> o'
      \ . '| silent! nunmap <buffer> O'
      \ . '| silent! iunmap <buffer> <CR>'
let b:undo_ftplugin = substitute(b:undo_ftplugin, '^| ', '', '')
