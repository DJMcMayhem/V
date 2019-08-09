vim_cmds=()
file=""

while getopts "vnxuhf:" arg; do
  case $arg in
    v)
      echo "Verbose!"
      ;;
    f)
      vim_cmds+=($OPTARG)
  esac
done

shift $(($OPTIND-1))

vim -nes "${vim_cmds[@]}" -u vim/init.vim -c "call Execute_Program('$1')" -c ":%p" -c ":q!" | head -c -1

# echo -e "\n"
