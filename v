#!/bin/bash

function help {
    echo "Usage:
  V [options] source [ARGUMENTS ... ]

Options:
  -v        Run in verbose mode
  -h        Show this screen.
  -x        Print a hexdump of the source file encoded in latin1 to STDERR
  -n        Add a trailing newline to the output
  -f FILE   Open with FILE for input
"

  exit
}

vim_cmds=()
args=()
file=""
newline=false
verbose=0

while getopts "vnhxf:" arg; do
  case $arg in
    v)
      verbose=1
      ;;
    f)
      vim_cmds+=($OPTARG)
      ;;
    n)
      newline=true
      ;;
    h)
      help
      ;;
  esac
done

shift $(($OPTIND-1))

if [ "$#" == 0 ] ; then
    help
fi

function vim_escape () {
  printf '"'
  for (( i=0; i<${#1}; i++ )); do
    printf '\\x%x' "'${1:$i:1}";
  done
  printf '"'
}

for (( i=2; i<$#+1; i++ )); do
  args+=(-c 'call Set_Arg('$(vim_escape "${!i}")')')
done

vim -nes "${vim_cmds[@]}" -u vim/init.vim "${args[@]}" -c "call Execute_Program('$1', '$verbose')" -c ":%p" -c ":q!" | head -c -1

if [ "$newline" = true ] ; then
  echo ""
fi
