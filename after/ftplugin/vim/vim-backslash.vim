if exists('b:vim_backslash_loaded')
  finish
endif
let b:vim_backslash_loaded = 1

" Support existing mapping for <CR>
let s:cr_mappings = maparg('<CR>', 'i', 0, 1)
if empty(s:cr_mappings)
  inoremap <buffer> <Plug>(vim-backslash-fallback-CR-i) <CR>
else
  execute printf(
      \ 'i%smap <buffer>%s%s <Plug>(vim-backslash-fallback-CR-i) %s',
      \ s:cr_mappings.noremap ? 'nore' : '',
      \ s:cr_mappings.silent ? '<silent>' : '',
      \ s:cr_mappings.expr ? '<expr>' : '',
      \ s:cr_mappings.rhs,
      \)
endif

nnoremap <silent><buffer> <Plug>(vim-backslash-normal-o) o
nnoremap <silent><buffer> <Plug>(vim-backslash-smart-o)
      \ :<C-u>call vim_backslash#smart_o()<CR>
nmap <silent><buffer><expr> <Plug>(vim-backslash-o)
      \ vim_backslash#is_continuous()
      \   ? "\<Plug>(vim-backslash-smart-o)"
      \   : "\<Plug>(vim-backslash-normal-o)"

nnoremap <silent><buffer> <Plug>(vim-backslash-normal-O) O
nnoremap <silent><buffer> <Plug>(vim-backslash-smart-O)
      \ :<C-u>call vim_backslash#smart_O()<CR>
nmap <silent><buffer><expr> <Plug>(vim-backslash-O)
      \ vim_backslash#is_continuous()
      \   ? "\<Plug>(vim-backslash-smart-O)"
      \   : "\<Plug>(vim-backslash-normal-O)"

inoremap <silent><buffer> <Plug>(vim-backslash-smart-CR-i)
      \ <Esc>:<C-u>call vim_backslash#smart_CR_i()<CR>
imap <silent><buffer><expr> <Plug>(vim-backslash-CR-i)
      \ vim_backslash#is_continuous_cr()
      \   ? "\<Plug>(vim-backslash-smart-CR-i)"
      \   : "\<Plug>(vim-backslash-fallback-CR-i)"

if !get(g:, 'vim_backslash_disable_default_mappings', 0)
  nmap <buffer> o    <Plug>(vim-backslash-o)
  nmap <buffer> O    <Plug>(vim-backslash-O)
  imap <buffer> <CR> <Plug>(vim-backslash-CR-i)

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
