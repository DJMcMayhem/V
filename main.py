"""Usage:
  main.py FILE [ARGUMENTS ... ]
  main.py FILE [options] [ARGUMENTS ... ]
  main.py FILE [options] [-- ARGUMENTS ... ]

Options:
  -v --verbose  Run in verbose mode
  -h --help     Show this screen.
  -u --utf8     Read the source file in utf8 encoding. This should be considered the default, but is a flag to keep the byte count lower.
  -d --debug    Debug mode. Opens in a visible nvim window
  -x --hexdump  Print a hexdump of the source file encoded in latin1 to STDERR
  -f FILE       Open on FILE
  -w FILE       Log vim keystrokes in FILE
  -s TIME       Sleep for TIME milliseconds between commands
  --safe        Do not allow shell access
"""

from __future__ import print_function

from docopt import docopt
import neovim
import utf8
import subprocess
import threading
import time
import platform
import os
import sys
import v

def main():
    external_neovim = args['--debug']
    source_file = args['FILE']
    args["platform"] = platform.system()
    if args["platform"] == "Darwin":
        args["platform"] = "Linux"

    if args["ARGUMENTS"][:1] == ['--']:
        args["ARGUMENTS"] = args["ARGUMENTS"][1:]

    if args["-s"] != None:
        if args["-s"].isdigit():
            args["-s"] = int(args["-s"]) / 100.0
        else:
            print("Sleep time must be a positive integer!")
            return

    if args["-f"] != None:
        args["-f"] = os.path.abspath(args["-f"])

    source = utf8.enc_safe_file(source_file, args["--utf8"], args["--verbose"])

    if not source.exists:
        print("Error:\nFile: {} not found.".format(source_file), file=sys.stderr)
        return

    os.chdir(os.path.dirname(os.path.realpath(__file__)))

    v_instance = v.V(args)

    reg = 0
    for i in args["ARGUMENTS"]:
        v_instance.set_register(chr(reg + 97), i)
        reg += 1

    v_instance.nvim_instance.command(":let g:num_regs={}".format(reg))
    v_instance.set_register('z', os.path.abspath(source_file))

    for char in source.read():
        v_instance.key_stroke(char)

    v_instance.clean_up()

    if args['--hexdump']:
        sys.stderr.write("Hexdump:\n\n")
        xxd = subprocess.Popen("xxd", stdout=subprocess.PIPE, stdin=subprocess.PIPE)
        out, err = xxd.communicate(source.original_source.encode("latin1"))
        for line in out.split('\n'):
            sys.stderr.write('    ' + line + '\n')

    buf = v_instance.get_buffer()
    output = "\n".join(buf)
    print(output, end="")

    v_instance.close()

if __name__ == "__main__":
    args = docopt(__doc__, version="Alpha 0.1")
    main()
