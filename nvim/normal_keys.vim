function! SingleInsert(com, count)
  let c = nr2char(getchar())
  exe "normal! ".a:com.repeat(c, a:count)."\<esc>"
endfunction

nnoremap é :<C-u>call SingleInsert('i', v:count1)<CR>
nnoremap É :<C-u>call SingleInsert('I', v:count1)<CR>
nnoremap 0é :<C-u>call SingleInsert('i', 0)<CR>
nnoremap 0É :<C-u>call SingleInsert('I', 0)<CR>
nnoremap á :<C-u>call SingleInsert('a', v:count1)<CR>
nnoremap Á :<C-u>call SingleInsert('A', v:count1)<CR>
nnoremap 0á :<C-u>call SingleInsert('a', 0)<CR>
nnoremap 0Á :<C-u>call SingleInsert('A', 0)<CR>

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

function! PasteOver(before)
  let l:com = 'R'.(a:before ? '' : "\<right>").repeat(getreg(v:register), v:count1)."\<esc>l"
  silent exe "normal! ".l:com
endfunction

nnoremap ð :<C-u>call PasteOver(0)<cr>
nnoremap Ð :<C-u>call PasteOver(1)<cr>

function! Duplicate(type, ...) range
  let l:yank_op = g:paste_num == -1 ? 'y' : 'd'

  if line("']") == line('$') && l:yank_op == 'd' && a:type == 'line'
    let l:yank_op = 'y'
    let g:paste_num = g:paste_num - 1
  endif

  if col("']") == col('$') - 1 && l:yank_op == 'd' && a:type == 'char'
    let l:yank_op = 'y'
    let g:paste_num = g:paste_num - 1
  endif

  if a:0  " Invoked from Visual mode, use gv command.
    silent exe "normal! gv".l:yank_op
  elseif a:type == 'line'
    silent exe "normal! '[V']".l:yank_op
  elseif a:type == 'block'
    silent exe "normal! `[\<C-v>`]".l:yank_op
  else
    silent exe "normal! `[v`]".l:yank_op
  endif

  if g:paste_num > 0
    silent exe "normal! ".g:paste_num."P"
  elseif g:paste_num == -1
    silent exe "normal! "."P"
  endif
endfunction

nnoremap ä :<C-u>let g:paste_num=v:count ? v:count : -1<cr>:set opfunc=Duplicate<cr>g@
nnoremap Ä :<C-u>let g:paste_num=v:count ? v:count : -1<cr>:set opfunc=Duplicate<cr>g@_
nnoremap 0Ä dd
nnoremap 0ä d

"Duplicate line after
nnoremap Ù :<C-u>exec 'norm Y'.v:count.'p'<cr>
nnoremap 0Ù dd

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
  let l:c = getchar()
  if l:c >= 175 && l:c <= 185
    return RepCharInsert((a:n * 10) + l:c - 176)
  endif

  if l:c == 22
    let l:c = nr2char(getchar())
  elseif l:c == 18
    let l:c = getreg(nr2char(getchar()))
  else
    let l:c = nr2char(l:c)
  endif

  let l:rep_count = a:n
  if a:n == 1
    let l:rep_count = 10
  endif

  return repeat(l:c, a:n)
endfunction

inoremap <expr> ° RepCharInsert(0)
inoremap <expr> ± RepCharInsert(1)
inoremap <expr> ² RepCharInsert(2)
inoremap <expr> ³ RepCharInsert(3)
inoremap <expr> ´ RepCharInsert(4)
inoremap <expr> µ RepCharInsert(5)
inoremap <expr> ¶ RepCharInsert(6)
inoremap <expr> · RepCharInsert(7)
inoremap <expr> ¸ RepCharInsert(8)
inoremap <expr> ¹ RepCharInsert(9)

function! InsertRange(mode, count)
  let l:a = getchar()
  let l:b = getchar()
  let l:stride = a < b ? 1 : -1

  if a:count
    exec "normal! gi\<C-v>".repeat(join(range(l:a, l:b, l:stride), "\<C-v>"), a:count)
  endif
  if a:mode == 'i'
    silent exe "normal! gi"
  endif
endfunction

inoremap ¬ <C-o>:call InsertRange('i', v:count1)<cr>
nnoremap ¬ :call InsertRange('n', v:count1)<cr>
nnoremap 0¬ :call InsertRange('n', 0)<cr>

nnoremap > :<C-u>exec 'set shiftwidth='.v:count1<cr>>
nnoremap < :<C-u>exec 'set shiftwidth='.v:count1<cr><
xnoremap > :<C-u>exec 'set shiftwidth='.v:count1<cr>gv>
xnoremap < :<C-u>exec 'set shiftwidth='.v:count1<cr>gv<

"Minor mappings:
"<M-h> for (h)ollow.
nnoremap è ^lv$hhr<space>
nnoremap <expr> È '^lv$hhr'.nr2char(getchar())

"<M-b> for (b)reak. Break a macro on a common conditional for macros
nnoremap â ^l

"<M-/> for slide
nnoremap ¯ ^lx>>

"<M-R>, or (R)eplace. Useful for replacing an entire line with another
"character.
nnoremap Ò Vr

"Mapping to ':norm' and ':%norm'
nnoremap î :norm<space>
nnoremap Î :%norm<space>
xnoremap î :norm<space>
xnoremap Î :%norm<space>
cnoremap î norm<space>
cnoremap Î %norm<space>

"Mapping reverse indent mode
inoremap <C-_> <C-o>:se ri!<cr>

nnoremap <expr> gó ":\<C-U>sleep ".(v:count ? v:count : 100)."ms\<CR>"
nnoremap <expr> gÓ ":\<C-U>sleep ".((v:count ? v:count : 5) * 100)."ms\<CR>"

nnoremap ï o<esc>
nnoremap Ï O<esc>
