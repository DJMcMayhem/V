function! Indent(type, ...) range
  if a:0  " Invoked from Visual mode, use gv command.
    silent exe "normal! gv".g:listIndentNum.'>'
  elseif a:type == 'block'
    silent exe "normal! `[\<C-v>`]".g:listIndentNum.'>'
  else
    silent exe "normal! `[v`]".g:listIndentNum.'>'
  endif
endfunction

nnoremap > :<C-u>let g:lastIndentNum = v:count1<cr>:set opfunc=Indent<cr>g@
nmap >> >_
