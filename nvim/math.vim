function! Dec()
  let l:count = v:count - 1
  call feedkeys(l:count)
endfunction

function! Inc()
  let l:count = v:count + 1
  call feedkeys(l:count)
endfunction

nnoremap « :<C-u>call Inc()<cr>
xnoremap « :<C-u>call Inc()<cr>
nnoremap ­ :<C-u>call Dec()<cr>
xnoremap ­ :<C-u>call Dec()<cr>

"<M-[>, current line
nnoremap <expr> Û line('.')
xnoremap <expr> Û line('.')
inoremap <expr> Û line('.')
cnoremap <expr> Û line('.')
"<M-]>, current column
nnoremap <expr> Ý getcurpos('.')[2]
xnoremap <expr> Ý getcurpos('.')[2]
inoremap <expr> Ý getcurpos('.')[2]
cnoremap <expr> Ý getcurpos('.')[2]
"<M-{>, number of lines (in the buffer)
nnoremap <expr> û line('$')
xnoremap <expr> û line('$')
inoremap <expr> û line('$')
cnoremap <expr> û line('$')
"<M-}>, number of columns (in the current line)
nnoremap <expr> ý getcurpos('$')[2]
xnoremap <expr> ý getcurpos('$')[2]
inoremap <expr> ý getcurpos('$')[2]
cnoremap <expr> ý getcurpos('$')[2]
