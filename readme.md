This is to explain what Serial-Steno is. (and maybe later to host the softwares I may create for my serial-steno usage)

# What is serial-steno?

Serial-steno come from serial, and steno. Steno is any way of writting which is faster than the conventional way. Usually, it's done by pressing chords on your keyboard,
which get translated into words. But it is only a part of steno, chorded-steno. See Plover from the OpenSteno project.
Serial-steno is also on computer, but instead of chording, you press each letter one by one. The speed is gained from briefs (and various shortening methods) which reduce
the number of keypresses.

# How to use serial-steno?

What you need is a software which allow you to transform the letters that you're typing.
It can be closed-scope (in the software only, generally text-editors), or can act globally (on the computer, generally by text-expander).

The softwares can vary from os to os.
The advantage of text-editors is that it acts on things it have greater control, thus, generally they are faster/more reliable.
The advantage of text-expander is that you can use it in your daily life to type.

Text-editor: (which I know can support the creation of a serial-steno system)
- Words (limit of 30 000 briefs)
- LibreOffice

Text-expander:
- AutoHotKey (programming language, works only on Windows, due to its programming language nature, it offer great flexibility)
- Espanso (works on every major os, can't say much more as I haven't used it myself. It have some bugs)
- FastFox (don't particularly recommand it because of the ending character deletion)

This is a small list, and you con find more if you search for text-editor/text-expander.

# How does it works?

You'll build (or use a pre-existing) a dictionary. Which is a translation between briefs and their meaning.
It may be full word, or just suffixs, or prefixs. As long as it serves to write faster (by reducing keypresses) and you can express the behavior to the text-expander/text-editor,
it can be used.

some examples using AutoHotKey syntax:
```ahk
::tb::to be
::ts::it is
:?:tn::tion
:?:tns::tions
:*:cp::comp
```
Which bind some briefs, then if I type `ts tb sure there's a cpletn`, it will automatically translate to `it is to be sure there's a completion`.


It's recommanded to follow some logic to make your briefs, so that you can recall them fast. There's no use of having briefs if you don't use them, or if you think longer on
how to write those than you'd need to write it in full.

# Notable open-source serial-steno project
- Qwertigraphy, by codepoke: https://github.com/codepoke-kk/qwertigraphy

---

Special thanks to codepoke and Quaverly for their tips :)
