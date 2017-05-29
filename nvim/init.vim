"Set all settings to default
set all&

"Change runtime path
exe 'set rtp-=' . expand('~/.config/nvim')
exe 'set rtp-=' . expand('~/.config/nvim/after')
exe 'set rtp+=' . expand('$V/nvim')
exe 'set rtp+=' . expand('$V/nvim/after')

"Load plugins
source nvim/plugin/surround.vim
source nvim/plugin/exchange.vim

"Source V specific source files
source nvim/motions.vim
source nvim/normal_keys.vim
source nvim/regex.vim
source nvim/math.vim
source nvim/reverse.vim

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

nnoremap @ÿ @"
xnoremap @ÿ @"
