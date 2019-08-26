#!/bin/bash

function help {
    echo "Usage:
  V source [OPTIONS] [ARGUMENTS ... ]

Options:
  -V        Show warnings from vim
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
hexdump=0
keystroke_file=""

if [ "$#" == 0 ] ; then
    help
fi

source="$1"
shift 1

while getopts "Vvnhxf:s:w:" arg; do
  case $arg in
    v)
      verbose=1
      ;;
    V)
      vim_cmds+=(-V2 )
      ;;
    x)
      hexdump=true
      keystroke_file=$(mktemp v.XXXX --tmpdir)
      vim_cmds+=(-W $keystroke_file)
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
    s)
      >&2 echo "The -s flag is deprecated."
      ;;
    w)
      >&2 echo "The -w flag is deprecated."
      ;;
  esac
done

shift $(($OPTIND-1))

function vim_escape () {
  printf '"'
  for (( i=0; i<${#1}; i++ )); do
    printf '\\x%x' "'${1:$i:1}";
  done
  printf '"'
}

for (( i=1; i<$#+1; i++ )); do
  args+=(-c 'call Set_Arg('$(vim_escape "${!i}")')')
done

vim -Nnes "${vim_cmds[@]}" -u "$(dirname -- "$(readlink -e -- "$0")")/vim/init.vim" -i NONE "${args[@]}" -c "call Execute_Program('$source', '$verbose')" -c "%p" -c "q!" | head -c -1

if [ "$hexdump" = true ] ; then
  # Convert the keystroke file
  >&2 echo -e "\n\nHexdump:\n"
  >&2 vim -u NONE -Nnes $keystroke_file -c "se fenc=latin1" -c "se binary" -c 'w' -c 'normal G$xxx' -c '1,$!xxd' -c '%norm 4I ' -c "%p" -c "q!"
fi

if [ "$newline" = true ] ; then
  echo ""
fi
