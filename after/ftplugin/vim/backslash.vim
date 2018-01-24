if exists('b:backslash_loaded')
  finish
endif
let b:backslash_loaded = 1

function! s:is_continuous() abort
  return getline('.') =~# '^\s*\\\s*'
endfunction

function! s:smart_o() abort
  let lnum = line('.')
  let line = getline(lnum)
  let leading = matchstr(line, '^\s*\\\s*')
  call append(lnum, leading)
  call setpos('.', [0, lnum+1, 0, 0])
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
  else
    let leading = matchstr(line, '^\s*\\\s*')
    let prefix = line[:col('.')-1]
    let suffix = line[col('.'):]
    call setline('.', prefix)
    call append(lnum, leading . suffix)
    call setpos('.', [0, lnum+1, len(leading)+1, 0])
    execute len(suffix) ? 'startinsert' : 'startinsert!'
    return
  endif
endfunction

nnoremap <silent><buffer><expr> <Plug>(backslash-o) <SID>is_continuous()
      \ ? ":\<C-u>call \<SID>smart_o()\<CR>"
      \ : 'o'

inoremap <silent><buffer><expr> <Plug>(backslash-CR-i) <SID>is_continuous()
      \ ? "\<Esc>:\<C-u>call \<SID>smart_CR_i()\<CR>"
      \ : "\<CR>"

nmap <buffer> o    <Plug>(backslash-o)
imap <buffer> <CR> <Plug>(backslash-CR-i)

let b:undo_ftplugin =
      \ get(b:, 'undo_ftplugin', '')
      \ . '| nunmap <buffer> o'
      \ . '| iunmap <buffer> <CR>'
let b:undo_ftplugin = substitute(b:undo_ftplugin, '^| ', '', '')
