if exists('b:did_ftplugin_backslash')
  finish
endif
let b:did_ftplugin_backslash = 1

function! s:remove_slash(lnum) abort
  let line = getline(a:lnum)
  let indent = get(g:, 'vim_indent_cont', shiftwidth() * 3)
  let leading = matchstr(line, printf('^\s*\ze\s\{%d}\\', indent))
  call setline('.', leading)
  call setpos('.', [0, a:lnum, strlen(leading), !empty(leading)])
endfunction

function! s:smart_o() abort
  let lnum = line('.')
  let line = getline(lnum)
  if line =~# '^\s*\\\s*$'
    call s:remove_slash(lnum)
  else
    let v:lnum = lnum + 1
    sandbox let leading = line =~# '^\s*\\\s*'
          \ ? matchstr(line, '^\s*\\\s*')
          \ : repeat(' ', eval(&indentexpr))
    call append(lnum, leading)
    call setpos('.', [0, lnum+1, len(leading), !empty(leading)])
  endif
  startinsert!
endfunction

function! s:smart_CR_i() abort
  let lnum = line('.')
  let line = getline(lnum)
  if line =~# '^\s*\\\s*$'
    call s:remove_slash(lnum)
  else
    let v:lnum = lnum + 1
    sandbox let leading = line =~# '^\s*\\\s*'
          \ ? matchstr(line, '^\s*\\\s*')
          \ : repeat(' ', eval(&indentexpr))
    let prefix = line[:col('.')-1]
    let suffix = line[col('.'):]
    call setline('.', prefix)
    call append(lnum, leading . suffix)
    call setpos('.', [0, lnum+1, len(leading), !empty(leading)])
  endif
  startinsert
endfunction

nnoremap <silent><buffer> <Plug>(backslash-o)
      \ :<C-u>call <SID>smart_o()<CR>
inoremap <silent><buffer> <Plug>(backslash-CR)
      \ <Esc>:<C-u>call <SID>smart_CR_i()<CR>

nmap <buffer> o    <Plug>(backslash-o)
imap <buffer> <CR> <Plug>(backslash-CR)

let b:undo_ftplugin = join([
      \ 'nunmap <buffer> o',
      \ 'iunmap <buffer> <CR>',
      \], '|')
