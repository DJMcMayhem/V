function! SingleInsert()
  let c = nr2char(getchar())
  exe "normal! ".v:count1."i".c."\<esc>"
endfunction

function! SingleAppend()
  let c = nr2char(getchar())
  exe "normal! ".v:count1."a".c."\<esc>"
endfunction

nnoremap é :<C-u>call SingleInsert()<CR>
nnoremap á :<C-u>call SingleAppend()<CR>

function! RecordQ(count)
  let c = nr2char(getchar())
  let text = ""
  while c != "ñ" && c != nr2char(255)
    let text .= c
    let c = nr2char(getchar())
  endwhile
  let @q=text.nr2char(255)
  if a:count
    call feedkeys(a:count."@q")
  endif
endfunction

nnoremap ñ :<C-u>call RecordQ(v:count1)<cr>
nnoremap 0ñ :<C-u>call RecordQ(0)<cr>

function! RecursiveQ(count)
  let c = nr2char(getchar())
  let text = ""
  while c != "ò" && c != nr2char(255)
    let text .= c
    let c = nr2char(getchar())
  endwhile
  let @q=text.nr2char(255)."@q"
  if a:count
    call feedkeys("@q")
  endif
endfunction

nnoremap ò :<C-u>call RecursiveQ(v:count1)<cr>
nnoremap 0ò :<C-u>call RecursiveQ(0)<cr>

"<M-R>, or (R)eplace. Useful for replacing an entire line with another
"character.
nnoremap Ò Vr

function! Duplicate()
  let motion = nr2char(getchar())
  if v:count1 == 1
    call feedkeys("y")
  else
    call feedkeys("d")
  endif
  call feedkeys(motion)
  while mode(1) != 'n'
    let motion = nr2char(getchar())
    call feedkeys(motion)
  endwhile

  call feedkeys(v:count1."P")
endfunction

nnoremap ä :<C-u>call Duplicate()<cr>
nnoremap Ä :<C-u>call Duplicate()<cr>_

let g:active_reg = 0
let g:num_regs = 1
function! NextActiveRegister(BaseCommand)
  echo a:BaseCommand
  let active_reg = nr2char(g:active_reg + 97)
  let g:active_reg += 1
  if g:active_reg >= g:num_regs
    let g:active_reg = 0
  endif
  call feedkeys(a:BaseCommand.active_reg, 'i')
endfunction

nnoremap À :<C-u>call NextActiveRegister("@")<CR>
nnoremap ¢ :<C-u>call NextActiveRegister("'")<CR>
inoremap ò <C-o>:<C-u>call NextActiveRegister('<C-v><C-r>')<CR>

function! RepCharInsert(n)
  let c = nr2char(getchar())
  call feedkeys(repeat(c, a:n), 'i')
endfunction

inoremap ± <C-o>:<C-u>call RepCharInsert(10)<cr>
inoremap ² <C-o>:<C-u>call RepCharInsert(20)<cr>
inoremap ³ <C-o>:<C-u>call RepCharInsert(3)<cr>
inoremap ´ <C-o>:<C-u>call RepCharInsert(4)<cr>
inoremap µ <C-o>:<C-u>call RepCharInsert(5)<cr>
inoremap ¶ <C-o>:<C-u>call RepCharInsert(6)<cr>
inoremap · <C-o>:<C-u>call RepCharInsert(7)<cr>
inoremap ¸ <C-o>:<C-u>call RepCharInsert(8)<cr>
inoremap ¹ <C-o>:<C-u>call RepCharInsert(9)<cr>

