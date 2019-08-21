let g:RegexShortcuts = {129: '.*', 130: '.+', 131: '.\{-}', 132: '[^', 133: '\ze', 135: '\{-}', 147: '\zs'}

"A reusable function for getting compressed regexes since many different V
"commands use compressed regex. (Substitute, global, search, and eventually
"sort)
function! GetCompressedRegex()
  let c = getchar()
  let command = ""
  "     Newline    Slash      Terminator
  while c != 13 && c != 47 && c != 255
    if has_key(g:RegexShortcuts, c)
      let command .= g:RegexShortcuts[c]
    elseif c > 128
      let command .= "\\".nr2char(c - 128)
    elseif c == 18
      let reg = nr2char(getchar())
      let command .= getreg(reg)
    else
      let command .= nr2char(c)
    endif
    let c = getchar()
  endwhile
  return command
endfunction

function! Search(com)

  let command = GetCompressedRegex()
  call feedkeys(a:com.command."\<CR>", "in")
endfunction

nnoremap / :<C-u>call Search("/")<CR>
nnoremap ? :<C-u>call Search("?")<CR>

function! Substitute(com, global)
  let c = getchar()
  let command = ""
  let slashes_seen = 0

  while c != 13 && c != 255
    if nr2char(c) == "/"
      let slashes_seen += 1
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

  while slashes_seen < 2
    let command .= "/"
    let slashes_seen += 1
  endwhile

  if a:global
    let command .= "g"
  endif

  call feedkeys(a:com.command."\<CR>", "in")
endfunction

nnoremap ó :<C-u>call Substitute(":s/", 0)<CR>
nnoremap Ó :<C-u>call Substitute(":s/", 1)<CR>
nnoremap í :<C-u>call Substitute(":%s/", 0)<CR>
nnoremap Í :<C-u>call Substitute(":%s/", 1)<CR>

function! Global(com)
  let c = getchar()
  let command = ""

  while c != char2nr('/')
    if nr2char(c) == "\\"
      let command .= "\\".nr2char(getchar())
    elseif has_key(g:RegexShortcuts, c)
      let command .= g:RegexShortcuts[c]
    elseif c == 255
      "If we get here, there's no point trying to parse the rest of the
      "command. Bail right now!
      return 0
    elseif c > 128
      let command .= "\\".nr2char(c - 128)
    else
      let command .= nr2char(c)
    endif
    let c = getchar()
  endwhile

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
