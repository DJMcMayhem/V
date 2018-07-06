def get_embedded_nvim_args(args):
    if args["platform"] == "Windows":
        nvim_args = ["nvim.exe", "-n", "-i", "NONE", "-u", "nvim/init.vim"]
    elif args["platform"] == "Linux":
        nvim_args = ["nvim", "-n", "-i", "NONE", "-u", "nvim/init.vim"]

    nvim_args += ["--embed"]

    if args["-w"]:
        nvim_args += ['-W', args["-w"]]
    if args["-f"]:
        nvim_args += [args["-f"]]
    if args["--safe"]:
        nvim_args += ["-Z"]

    return nvim_args

def get_socket_path(args):
    if args["platform"] == "Windows":
        return "\\\\.\\pipe\\nvim"
    elif args["platform"] == "Linux":
        return "/tmp/nvim"

def get_external_nvim_command(args):
    if args["platform"] == "Windows":
        command = "START nvim-qt.exe \\n \\i NONE \\u nvim\\init.vim "
    elif args["platform"] == "Linux":
        command = "xterm -e 'nvim -n -i NONE -u nvim/init.vim "

    if args["-w"]:
        command += ' -W {} '.format(args["-w"])
    if args["-f"]:
        command += " -f {} ".format(args["-f"])
    if args["--safe"]:
        command += " -Z "

    command += "'"
    return command
