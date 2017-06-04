function! SetReverse()
  set opfunc=Reverse
  return 'g@'
endfunction

function! Reverse(type, ...)
  if a:0  " Invoked from Visual mode, use gv command.
    if visualmode() ==# 'v'
      normal `<æv`>
    elseif visualmode() ==# 'V'
      normal '<æ'>
    else
      let l:start_col = col("'<")
      let l:end_col = col("'>")
      exec "'<,'>normal ".l:start_col.'|æv'.l:end_col.'|'
    endif
  elseif a:type == 'line'
    if line("'[") == line("']")
      let l:col_num = col('.')
      normal |æ$
    else
      exec "'[,']g/^/m".(line("'[")-1)
    endif
  elseif a:type == 'block'
    exe "normal! `[\<C-v>`]"
    normal æ
  else
    silent exe 'normal! `[v`]y'
    silent exe 'normal! gv"_c'.join(reverse(split(getreg('"'), '\ze.')), '')
  endif
endfunction

nnoremap <expr> æ SetReverse()
xnoremap æ :<C-u>call Reverse(visualmode(), 1)<cr>
