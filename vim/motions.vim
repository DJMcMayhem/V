nnoremap ê :<C-u>call StraightDown('n')<cr>
nnoremap ë :<C-u>call StraightUp('n')<cr>

xnoremap ê :<C-u>call StraightDown('v')<cr>
xnoremap ë :<C-u>call StraightUp('v')<cr>

onoremap ê :<C-u>call StraightDown('o')<cr>
onoremap ë :<C-u>call StraightUp('o')<cr>

nnoremap L :<C-u>call L('n', v:count)<cr>
xnoremap L :<C-u>call L('v', v:count)<cr>
onoremap L :<C-u>call L('o', v:count)<cr>

nnoremap ã :<C-u>call cursor(0, (len(getline('.')) + 1) / 2)<cr>
xnoremap ã :<C-u>exec 'normal gv' \| call cursor(0, (len(getline('.')) + 1) / 2)<cr>
onoremap ã :<C-u>call cursor(0, (len(getline('.')) + 1) / 2)<cr>

nnoremap Ã :<C-u>call cursor((line('$') + 1) / 2, 0) \| call cursor(0, (len(getline('.')) + 1) / 2)<cr>
xnoremap Ã :<C-u>exec 'normal gv' \| call cursor((line('$') + 1) / 2, 0) \| call cursor(0, (len(getline('.')) + 1) / 2)<cr>
onoremap Ã :<C-u>call cursor((line('$') + 1) / 2, 0) \| call cursor(0, (len(getline('.')) + 1) / 2)<cr>

nnoremap <expr> M ((line('$') + 1) / 2).'G'
xnoremap <expr> M ((line('$') + 1) / 2).'G'
onoremap <expr> M ((line('$') + 1) / 2).'G'

nnoremap H gg
xnoremap H gg
onoremap H gg

"Execute a motion on the 'next' text object
onoremap an :<c-u>call <SID>NextTextObject('a')<cr>
xnoremap an :<c-u>call <SID>NextTextObject('a')<cr>
onoremap in :<c-u>call <SID>NextTextObject('i')<cr>
xnoremap in :<c-u>call <SID>NextTextObject('i')<cr>
onoremap al :<c-u>call <SID>PreviousTextObject('a')<cr>
xnoremap al :<c-u>call <SID>PreviousTextObject('a')<cr>
onoremap il :<c-u>call <SID>PreviousTextObject('i')<cr>
xnoremap il :<c-u>call <SID>PreviousTextObject('i')<cr>

function! s:NextTextObject(motion)
  let c = nr2char(getchar())
  exe "normal! "v:count1."f".c."v".a:motion.c
endfunction

function! s:PreviousTextObject(motion)
  let c = nr2char(getchar())
  exe "normal! "v:count1."F".c."v".a:motion.c
endfunction

function! StraightDown(mode)
  let line=line('.')
  let end=line('$')
  if a:mode == 'v'
    exe "normal gv"
  elseif a:mode == 'o'
    exe "normal \<C-v>"
  endif
  exe "normal ".eval(end-line)."j"
endfunction

function! StraightUp(mode)
  let line=line('.')
  if a:mode == 'v'
    exe "normal gv"
  elseif a:mode == 'o'
    exe "normal \<C-v>"
  endif
  exe "normal ".eval(line-1)."k"
endfunction

function! L(mode, count)
  if a:mode == 'v'
    exe "normal gv"
  elseif a:mode == 'o'
    exe "normal \<C-v>"
  endif
  if a:count == 0
    exe "normal! G$"
  else
    exe "normal! ".a:count."G$"
  endif
endfunction
