# What is it for?
It's to create a lot of briefs with a similar pattern in a single line, thus making patterns easier to make.

# How to use FastBriefCreator

First of all, you'll have to install the Julia programming language (nothing to do with my name) as it's the language I write it in. //TODO write it in a more popular language
To install it: https://julialang.org/

Then, install the .jl file on your computer.

Do `julia <the path of your .jl file> > new_text_file_that_you_dont_care_if_you_lose.txt`, and type your line.
The briefs will be located into your .txt file.

It's currently to do with ahk syntax, change the .jl file to accomodate your text-editor/expander syntax. (feel free to make a issue if you're unsure on how)

**Be careful!** your .txt file previous information will be deleted! (and I assume 0 responsability if it does...)
If you have special character, don't do it from Powershell, it doesn't support special character well.
Wezterm is a great alternative for terminal.

Then copy paste what's in your .txt file to your text-expander/text-editor.

# What *the line* must be?

The line must have a particular syntax to work.
The syntax is partially derived from regular expressions, but it's not exactly that.

The line is divided into two part, which are seperated by the first space.
`<brief><space><translation>`

Because it is on the first space, `brief` CAN'T contain a space. (`translation` can though)

`brief` and `translation` need to have a similar structure.

## structure

`|` is to separate two possibilites. so `a|b c|d` =>
```ahk
::a::c
::b::d
```
(thus, you can't use `|` in your translations/briefs)

Because you may not want to rewrite every possibilities (as... it would make the program useless), you can enclose the scope with `()`
So: `(a|b)c o(aa|bb)` =>
```ahk
::ac::oaa
::bc::obb
```
And so, you can combine them to make more complex expression
`(i|y)d(|n)(|c|t(|s)) (I|you) do(|n't)(| care| think(| so))` =>
```ahk
::id::I do
::idc::I do care
::idt::I do think
::idts::I do think so
::idn::I don't
::idnc::I don't care
::idnt::I don't think
::idnts::I don't think so
::yd::you do
::ydc::you do care
::ydt::you do think
::ydts::you do think so
::ydn::you don't
::ydnc::you don't care
::ydnt::you don't think
::ydnts::you don't think so
```

A lot of brief made in one line!
