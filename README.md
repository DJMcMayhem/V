<h1>V</h1>

An esoteric language inspired by vim and designed for code-golfing. Get started at the [wiki](https://github.com/DJMcMayhem/V/wiki), or you can try it in the online interpreter [here.](http://v.tryitonline.net/) (Online interpreter provided by [Dennis Mitchell](http://codegolf.stackexchange.com/users/12012/dennis))

V is really just a fancy way to call vim like it's a scripting language, with a bunch of settings and mappings preloaded. The main reason this language was invented was to fix my biggest complaints with using vim as a golfing language, rather than a text editor:

 - Input and output is obnoxious. In vim golf, you must enter the text into a file, open with file in vim with no loaded settings, and then *manually* type each keystroke to execute it. Output is to the buffer, not to STDIO

 - Settings that I come up with to save keystrokes do not count, since they only exist on my `.vimrc`

 - Certain idioms in vim golf take more keystrokes then they really need to. For example, global search and replace, recursive macros, turning settings on and off, etc.

 - And perhaps the biggest one of all, vim doesn't support mathematical operations very well.

V seeks to fix all of these problems.

If you would like to talk about V, whether it's to seek golfing advice in V, to become a contributor, or even just to learn about the language, feel free to either bring it up in the V [chat room](http://chat.stackexchange.com/rooms/40448/v) on PPCG, or to ping me in [The Nineteenth Byte](http://chat.stackexchange.com/rooms/240/the-nineteenth-byte).

V is released under the same license as [The Vim License](https://github.com/vim/vim/blob/0b9e4d1224522791c0dbbd45742cbd688be823f3/runtime/doc/uganda.txt).
