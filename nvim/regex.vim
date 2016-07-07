function! Search(com)
  let c = getchar()
  let command = ""
  while c != 13
    if c > 128
      let command .= "\\".nr2char(c - 128)
    else
      let command .= nr2char(c)
    endif
    let c = getchar()
  endwhile
  exe "silent! ".a:com.command
endfunction

nnoremap / :<C-u>call Search("/")<CR>
nnoremap ? :<C-u>call Search("?")<CR>

function! Substitute(com, global)
  let c = getchar()
  let command = ""
  let slashes_seen = 0

  while c != 13
    if nr2char(c) == "/"
      let slashes_seen += 1
    endif

    if nr2char(c) == "\\"
      let command .= "\\".nr2char(getchar())
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

  exe "silent! ".a:com.command
endfunction

nnoremap ó :<C-u>call Substitute("s/", 0)<CR>
nnoremap Ó :<C-u>call Substitute("s/", 1)<CR>
nnoremap í :<C-u>call Substitute("%s/", 0)<CR>
nnoremap Í :<C-u>call Substitute("%s/", 1)<CR>

