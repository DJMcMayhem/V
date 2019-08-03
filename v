# vim - is for STDIN input
# tail removes the first two lines (which are a warning about STDIN input)
# head removes the last byte which happens to be a newline

# vim - -nes -u vim/init.vim -c ":normal $value" -c ":%p" -c ":q!" | tail -n +2 | head -c -1

vim -nes -u vim/init.vim -c "call Execute_Program('$1')" -c ":%p" -c ":q!" | head -c -1


# echo -e "\n"
