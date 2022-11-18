# where you put your constant code-wise :)
# use raw" your code "
# prefix all your constants with 'C' to avoid clash with other variables/functions etc. necessary to make the program work
# Put "(" and ")" at the end of your constants to avoid them leaking out of their scope (I'm letting it leak for ppls who know what they're doing and thus, would need this functionality)


# English (prefixed with E_)

E_personal_pronouns = raw"""
(
    {,pp|I,,}(i: I)|
    {,pp|you,,}(u: you)|
    {,pp|he,,}(he: he)|
    {,pp|she,,}(she: she)|
    {,pp|they,,}(çé: they)
 )
"""

E_th = raw"""
(
    ça: that|
    çi: this|
    çs: those|
    ç: the
)"""

E_verb = raw"""
(
    {,have,,}(({he+she,has,,}(hs : has) | ) ({![he+she],,,}(hv : have) | (b : {has,,,}(" ")been|)))
)
"""

E_DEMON_PRONOUN = raw"""

(
	ta: that|
	ti: this|
	to: those|
	te: these
)
"""


# French (prefixed with F_)
