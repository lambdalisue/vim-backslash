vim-backslash
===============================================================================
![Version 0.1.1](https://img.shields.io/badge/version-0.1.1-yellow.svg?style=flat-square)
![Support Vim 7.4 or above](https://img.shields.io/badge/support-Vim%207.4%20or%20above-yellowgreen.svg?style=flat-square)
[![MIT License](https://img.shields.io/badge/license-MIT-blue.svg?style=flat-square)](LICENSE.md)
[![Doc](https://img.shields.io/badge/doc-%3Ah%20vim--backslash-orange.svg?style=flat-square)](doc/vim-backslash.txt)

*vim-backslash* is a filetype plugin which support to insert a leading backslash to continue expression in Vim script.

Assume "|" indicate the cursor in the following content:

```vim
let foobar = [
      \ 'foo',|
```

The `o` in a normal mode or `<CR>` in an insert mode makes the content like:

```vim
let foobar = [
      \ 'foo',
      \ |
```

And when the line contains only white spaces and "\" like:

```vim
let foobar = line('.') ==# 'Hello'
      \ ? 'Good bye'
      \ : 'Foobar'
      \ |
```

Hitting `o` or `<CR>` remove the leading spaces and "\" like:

```vim
let foobar = line('.') ==# 'Hello'
      \ ? 'Good bye'
      \ : 'Foobar'
|
```

Note that this plugin care about `g:vim_indent_cont` which is used in
[$VIMRUNTIME/indent/vim.vim](https://github.com/vim/vim/blob/master/runtime/indent/vim.vim)
