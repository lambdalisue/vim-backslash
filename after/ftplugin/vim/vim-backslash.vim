if exists('b:vim_backslash_loaded')
  finish
endif
let b:vim_backslash_loaded = 1

function! s:define_fallback(mode, expr) abort
  let m = maparg(a:expr, a:mode, 0, 1)
  if empty(m) || !has_key(m, 'rhs')
    execute printf(
          \ '%snoremap <buffer> <Plug>(vim-backslash-fallback-%s-%s) %s',
          \ a:mode,
          \ substitute(a:expr, '\W', '', 'g'),
          \ a:mode,
          \ a:expr,
          \)
  else
    execute printf(
          \ '%s%smap <buffer>%s%s <Plug>(vim-backslash-fallback-%s-%s) %s',
          \ a:mode,
          \ m.noremap ? 'nore' : '',
          \ m.silent ? '<silent>' : '',
          \ m.expr ? '<expr>' : '',
          \ substitute(a:expr, '\W', '', 'g'),
          \ a:mode,
          \ m.rhs,
          \)
  endif
endfunction
call s:define_fallback('n', 'o')
call s:define_fallback('n', 'O')
call s:define_fallback('i', '<CR>')

nnoremap <silent><buffer> <Plug>(vim-backslash-smart-o-n)
      \ :<C-u>call vim_backslash#smart_o()<CR>
nnoremap <silent><buffer> <Plug>(vim-backslash-smart-O-n)
      \ :<C-u>call vim_backslash#smart_O()<CR>
inoremap <silent><buffer> <Plug>(vim-backslash-smart-CR-i)
      \ <Esc>:<C-u>call vim_backslash#smart_CR_i()<CR>

nmap <silent><buffer><expr> <Plug>(vim-backslash-o)
      \ vim_backslash#is_continuous()
      \   ? "\<Plug>(vim-backslash-smart-o-n)"
      \   : "\<Plug>(vim-backslash-fallback-o-n)"
nmap <silent><buffer><expr> <Plug>(vim-backslash-O)
      \ vim_backslash#is_continuous()
      \   ? "\<Plug>(vim-backslash-smart-O-n)"
      \   : "\<Plug>(vim-backslash-fallback-O-n)"
imap <silent><buffer><expr> <Plug>(vim-backslash-CR)
      \ vim_backslash#is_continuous_cr()
      \   ? "\<Plug>(vim-backslash-smart-CR-i)"
      \   : "\<Plug>(vim-backslash-fallback-CR-i)"

if !get(g:, 'vim_backslash_disable_default_mappings', 0)
  nmap <buffer> o    <Plug>(vim-backslash-o)
  nmap <buffer> O    <Plug>(vim-backslash-O)
  imap <buffer> <CR> <Plug>(vim-backslash-CR)

  let b:undo_ftplugin =
        \ get(b:, 'undo_ftplugin', '')
        \ . '| silent! nunmap <buffer> o'
        \ . '| silent! nunmap <buffer> O'
        \ . '| silent! iunmap <buffer> <CR>'
  let b:undo_ftplugin = substitute(b:undo_ftplugin, '^| ', '', '')
endif
