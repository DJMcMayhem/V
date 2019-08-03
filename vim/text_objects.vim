onoremap é :exec 'norm vT'.nr2char(getchar()).'ot'.nr2char(getchar())<cr>
onoremap á :exec 'norm vF'.nr2char(getchar()).'of'.nr2char(getchar())<cr>
xnoremap é :<C-u>exec 'norm vT'.nr2char(getchar()).'ot'.nr2char(getchar())<cr>
xnoremap á :<C-u>exec 'norm vF'.nr2char(getchar()).'of'.nr2char(getchar())<cr>

onoremap É :exec 'norm vT'.nr2char(getchar()).'o,'<cr>
onoremap Á :exec 'norm vF'.nr2char(getchar()).'o,'<cr>
xnoremap É :<C-u>exec 'norm vT'.nr2char(getchar()).'o,'<cr>
xnoremap Á :<C-u>exec 'norm vF'.nr2char(getchar()).'o,'<cr>
