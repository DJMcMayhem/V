import codecs
import os
import sys
import re

verbose_mappings = { u"<lb>": '<', u"<rb>": '>', u"<esc>": chr(27), u"<bs>": chr(8), u"<del>": chr(127) }
ctrl_mappings = { u'[': chr(27), u'\\': chr(28), u']': chr(29), u"^": chr(30), u"_": chr(31), u"?": chr(127)}

class enc_safe_file():
    def __init__(self, file_name, utf8, verbose):
        self.enc = "utf-8" if utf8 else "latin1"
        self.verbose = verbose

        if verbose:
            self.regex = "<esc>|<M-.>|<C-.>|<rb>|<lb>|<bs>|<del>|."
        else:
            self.regex = "."

        if os.path.exists(file_name):
            self.exists = True
            self.original_source = codecs.open(file_name, 'r', self.enc).read()
        else:
            self.exists = False

    def read(self):
        if self.verbose:
            sys.stderr.write("Non-Verbose program:\n")
        if not self.exists:
            yield []
        for com in re.findall(self.regex, self.original_source, re.DOTALL):
            if com == '\n':
                com = '\r'

            if self.verbose:
                sys.stderr.write((get_encoded_command(com)))


            yield get_encoded_command(com, self.verbose)

        if self.verbose:
            sys.stderr.write("\n\n")

def get_encoded_command(com, verbose = False):
    if len(com) == 1:
        new_com = com.encode("utf-8")

    elif com.lower() in verbose_mappings:
        new_com = verbose_mappings[com.lower()].encode("utf-8")

    elif re.match("<C-.>", com):
        if com[3].isalpha():
            letter = com[3].lower()
            new_com = chr(ord(letter) - ord('a') + 1).encode("utf-8")

        else:
            new_com = ctrl_mappings[com[3]].encode("utf-8")

    elif re.match("<M-.>", com):
        new_com = unichr(ord(com[3]) + 128).encode("utf-8")

    return new_com


