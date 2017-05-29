function! Reverse(type, ...) range
  if a:0  " Invoked from Visual mode, use gv command.
    if a:1 ==# 'v'
      normal `<æv`>
    elseif a:1 ==# 'V'
      normal '<æ'>
    endif
    "echo a:1
  elseif a:type == 'line'
    "echo "Line!"
    if line("'[") == line("']")
      let l:col_num = col('.')
      normal |æ$
    else
      exec "'[,']g/^/m".(line("'[")-1)
    endif
  "elseif a:type == 'block'
    "echo "block!"
    "silent exe "normal! `[\<C-v>`]".l:yank_op
  else
    silent exe 'normal! `[v`]y'
    silent exe 'normal! gv"_c'.join(reverse(split(getreg('"'), '\ze.')), '')
  endif
endfunction

nnoremap <expr> æ ":\<C-u>set opfunc=Reverse\<cr>".v:count1.'g@'
xnoremap <expr> æ ":call Reverse(visualmode(), '\<C-v>".mode()."')\<CR>"
