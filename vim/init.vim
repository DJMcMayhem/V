"Set all settings to default
set all&

se nocompatible

"Change runtime path
exe 'set rtp-=' . expand('~/.config/vim')
exe 'set rtp-=' . expand('~/.config/vim/after')
exe 'set rtp+=' . expand('$V/vim')
exe 'set rtp+=' . expand('$V/vim/after')

"Load plugins
source vim/plugin/surround.vim
source vim/plugin/exchange.vim

"Source V specific source files
source vim/motions.vim
source vim/normal_keys.vim
source vim/regex.vim
source vim/math.vim
source vim/reverse.vim

"Set some settings
set noautoindent
set notimeout
set nottimeout
set nowrap
set nohlsearch

"Change 'formatoptions' to not remove comments when joining
set formatoptions-=j

"Indention settings
set expandtab
set shiftwidth=1

"Map our 'implicit ending' character.
nnoremap ÿ <esc>
inoremap ÿ <esc>
xnoremap ÿ <esc>
cnoremap ÿ <cr>
onoremap ÿ _

"Set '@' to implicitly run the unnamed register
nnoremap @ÿ @"
xnoremap @ÿ @"

"Modify 'matchpairs' so that `<` and `>` are considered matched
set matchpairs+=<:>

function! Execute_Program(source)
  let l:source_list = readfile(a:source, 'b')

  let l:line_num = 1
  for s:line in l:source_list
    for s:c in split(s:line, '\zs')
      call feedkeys(s:c, 't')
    endfor

    if l:line_num < len(l:source_list)
      call feedkeys("\<CR>", 't')
    endif

    let l:line_num += 1
  endfor

  call feedkeys('ÿÿÿ', 'tx')
endfunction

