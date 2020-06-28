if exists('b:backslash_loaded')
  finish
endif
let b:backslash_loaded = 1

" Support existing mapping for <CR>
let s:cr_mappings = maparg('<CR>', 'i', 0, 1)
if empty(s:cr_mappings)
  inoremap <buffer> <Plug>(backslash-fallback-CR-i) <CR>
else
  execute printf(
      \ 'i%smap <buffer>%s%s <Plug>(backslash-fallback-CR-i) %s',
      \ s:cr_mappings.noremap ? 'nore' : '',
      \ s:cr_mappings.silent ? '<silent>' : '',
      \ s:cr_mappings.expr ? '<expr>' : '',
      \ s:cr_mappings.rhs,
      \)
endif

nnoremap <silent><buffer> <Plug>(backslash-normal-o) o
nnoremap <silent><buffer> <Plug>(backslash-smart-o)
      \ :<C-u>call backslash#smart_o()<CR>
nmap <silent><buffer><expr> <Plug>(backslash-o)
      \ backslash#is_continuous()
      \   ? "\<Plug>(backslash-smart-o)"
      \   : "\<Plug>(backslash-normal-o)"

nnoremap <silent><buffer> <Plug>(backslash-normal-O) O
nnoremap <silent><buffer> <Plug>(backslash-smart-O)
      \ :<C-u>call backslash#smart_O()<CR>
nmap <silent><buffer><expr> <Plug>(backslash-O)
      \ backslash#is_continuous()
      \   ? "\<Plug>(backslash-smart-O)"
      \   : "\<Plug>(backslash-normal-O)"

inoremap <silent><buffer> <Plug>(backslash-smart-CR-i)
      \ <Esc>:<C-u>call backslash#smart_CR_i()<CR>
imap <silent><buffer><expr> <Plug>(backslash-CR-i)
      \ backslash#is_continuous_cr()
      \   ? "\<Plug>(backslash-smart-CR-i)"
      \   : "\<Plug>(backslash-fallback-CR-i)"

if !get(g:, 'backslash_disable_default_mappings', 0)
  nmap <buffer> o    <Plug>(backslash-o)
  nmap <buffer> O    <Plug>(backslash-O)
  imap <buffer> <CR> <Plug>(backslash-CR-i)

  let undo_ftplugin = join([
        \ 'silent! nunmap <buffer> o',
        \ 'silent! nunmap <buffer> O',
        \ 'silent! nunmap <buffer> <CR>',
        \], ' | ')

  let b:undo_ftplugin =
        \ get(b:, 'undo_ftplugin', '')
        \ . '| silent! nunmap <buffer> o'
        \ . '| silent! nunmap <buffer> O'
        \ . '| silent! iunmap <buffer> <CR>'
  let b:undo_ftplugin = substitute(b:undo_ftplugin, '^| ', '', '')
endif
