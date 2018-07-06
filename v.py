import neovim
import docopt

import os
import sys
import os_code
import time
import threading
from trollius import py33_exceptions

class V:
    def __init__(self, args):
        self.args = args

        try:
            if args["--debug"]:
                nvim_launcher_thread = threading.Thread(target=self.__call_nvim__) #Launch nvim in new thread so that V doesn't hang
                nvim_launcher_thread.start()
                time.sleep(1)
                socket = os_code.get_socket_path(args)

                try:
                    self.nvim_instance = neovim.attach("socket", path=socket)
                except py33_exceptions.FileNotFoundError:
                    sys.stderr.write("Couldn't connect to nvim. Did you export your NVIM_LIST_ADDRESS?\n\n")
                    sys.exit()

            else:
                args = os_code.get_embedded_nvim_args(args)
                try:
                    self.nvim_instance = neovim.attach("child", argv=args)
                except py33_exceptions.FileNotFoundError:
                    sys.stderr.write("Couldn't find the neovim executable! Is nvim in your $PATH?\n\n")
                    sys.exit()
        except IOError:
            sys.stderr.write("Couldn't find the neovim executable! Is neovim installed?\n\n")
            sys.exit()

        if self.args["--safe"]:
            self.nvim_instance.command("source nvim/safe_mode.vim")

        self.input_mappings = {'\n' : '\r', '<': "<lt>"}

    def __call_nvim__(self):
        socket = os_code.get_socket_path(self.args)

        arg = os_code.get_external_nvim_command(self.args)
        os.system(arg)

    def key_stroke(self, key):
        if key in self.input_mappings:
            key = self.input_mappings[key]
        self.nvim_instance.input(key)
        #time.sleep(0.1)

        if self.args["-s"]:
            time.sleep(self.args["-s"])

    def set_register(self, register, value):
        command = ":let @{}='{}'".format(register, value)
        try:
            self.nvim_instance.command(command)
            return True
        except:
            return False

    def get_mode(self):
        return self.nvim_instance.eval("mode(1)")

    def get_buffer(self):
        return self.nvim_instance.current.buffer

    def close(self):
        if not self.args["--debug"]:
            self.nvim_instance.quit()

    def clean_up(self):
        self.key_stroke(u'\xff'.encode(encoding = "UTF-8"))
        self.key_stroke(u'\xff'.encode(encoding = "UTF-8"))

