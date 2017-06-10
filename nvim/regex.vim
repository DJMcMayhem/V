let g:RegexShortcuts = {129: '.*', 130: '.\+', 131: '.\{-}', 132: '[^', 133: '\ze', 135: '\{-}', 136: '\(.\)', 147: '\zs'}

function! GetRegex(slashCount)
  let c = getchar()
  let command = ""
  let slashes_seen = 0

  while c != 13 && c != 255
    if nr2char(c) == "/"
      let slashes_seen += 1
      if slashes_seen == a:slashCount
        break
      endif
    endif

    if nr2char(c) == "\\"
      let command .= "\\".nr2char(getchar())
    elseif has_key(g:RegexShortcuts, c)
      let command .= g:RegexShortcuts[c]
    elseif c > 128
      let command .= "\\".nr2char(c - 128)
    else
      let command .= nr2char(c)
    endif
    let c = getchar()
  endwhile

  return [command, slashes_seen]
endfunction

function! Search(com, count, mode)
  let search = GetRegex(0)[0]
  let visual = a:mode == 'x' ? 'gv' : ''

  if a:count
    call feedkeys(l:visual.a:count.a:com.l:search."\<CR>", "in")
  endif
endfunction

nnoremap / :<C-u>call Search("/", v:count1, "n")<CR>
nnoremap ? :<C-u>call Search("?", v:count1, "n")<CR>
nnoremap 0/ :<C-u>call Search("/", 0, "n")<CR>
nnoremap 0? :<C-u>call Search("?", 0, "n")<CR>
xnoremap / :<C-u>call Search("/", v:count1, "x")<CR>
xnoremap ? :<C-u>call Search("?", v:count1, "x")<CR>
xnoremap 0/ :<C-u>call Search("/", 0, "x")<CR>
xnoremap 0? :<C-u>call Search("?", 0, "x")<CR>

function! Substitute(com, global, mode)
  let info = GetRegex(3)
  let command = info[0]
  let slashes = info[1]
  
  while slashes < 2
    let command .= '/'
    let slashes += 1
  endwhile

  if a:global
    let command .= 'g'
  endif

  call feedkeys(":".a:com.command."\<CR>", "in")
endfunction

nnoremap ó :<C-u>call Substitute("s/", 0, 'n')<CR>
nnoremap Ó :<C-u>call Substitute("s/", 1, 'n')<CR>
nnoremap í :<C-u>call Substitute("%s/", 0, 'n')<CR>
nnoremap Í :<C-u>call Substitute("%s/", 1, 'n')<CR>
xnoremap ó :<C-u>call Substitute("'<,'>s/\%V", 0, 'x')<CR>
xnoremap Ó :<C-u>call Substitute("'<,'>s/\%V", 1, 'x')<CR>
xnoremap í :<C-u>call Substitute("'<,'>s/", 0, 'x')<CR>
xnoremap Í :<C-u>call Substitute("'<,'>s/", 1, 'x')<CR>

function! Global(com)
  let info = GetRegex(1)
  let command = info[0]
  let slashes = info[1]

  let command .= "/norm "

  let c = getchar()
  while c != 13 && c != 255
    let command .= nr2char(c)
    let c = getchar()
  endwhile

  let command .= nr2char(255)

  call feedkeys(a:com.command."\<CR>", "in")
endfunction

nnoremap ç :<C-u>call Global(":g/")<CR>
nnoremap Ç :<C-u>call Global(":g!/")<CR>
xnoremap ç :<C-u>call Global(":'<,'>g/")<CR>
xnoremap Ç :<C-u>call Global(":'<,'>g!/")<CR>

function! Sort(mode)
  let c = getchar()
  let command = (a:mode == 'x' ? ":'<,'>" : ':').'sort'

  if c != char2nr('!')
    let command .= ' '
  endif

  while c != 13 && c != 47 && c != 255
    let command .= nr2char(c).' '
    let c = getchar()
  endwhile

  "'/', add a regex
  if c == 47
    let command .= ' /'.GetRegex(0)[0].'/'
  endif

  call feedkeys(command."\<CR>", "in")
endfunction

nnoremap ú :<C-u>call Sort('n')<cr>
nnoremap Ú :<C-u>call Sort('n')<cr><cr>
xnoremap ú :<C-u>call Sort('x')<cr>
xnoremap Ú :<C-u>call Sort('x')<cr><cr>

nnoremap úú :call setline('.', join(sort(split(getline('.'), '\ze.')), ''))<cr>
xnoremap úú :call setline('.', join(sort(split(getline('.'), '\ze.')), ''))<cr>

function! Count(global, count)
  let l:info = GetRegex(1)
  let l:command = info[0]

  if a:global
    let l:text = join(getline(1, '$'), "\n")
  else
    let l:text = join(getline(line('.'), line('.') + a:count - 1), "\n")
  endif

  let l:nmatches = len(split(l:text, l:command, 1)) - 1
  if a:global
    silent exe "normal! ggVG"
  else
    silent exe "normal! V".a:count."_"
  endif

  silent exe "normal! c".l:nmatches
endfunction

nnoremap ø :<C-u>call Count(0, v:count1)<CR>
nnoremap Ø :<C-u>call Count(1, v:count1)<CR>
