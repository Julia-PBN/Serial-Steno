module Logic
#  https://en.wikipedia.org/wiki/Boolean_algebra_(structure), with
#  ! := ¬ (NOT)
#  * := ∧ (AND)
#  + := ∨ (OR (inclusive))

import Base.+
import Base.*
import Base.!

@enum LOGIC begin
    TRUE
    FALSE
end

struct LNode
    op::Function
    l::Union{LNode, Symbol, LOGIC}
    r::Union{LNode, Symbol}
end


+(a::LNode, b::LNode) = LNode(+, a, b)
+(a::LNode, b::LNode, c...) = LNode(+, a, +(b, c...))
*(a::LNode, b::LNode) = LNode(*, a, b)
*(a::LNode, b::LNode, c...) = LNode(*, a, *(b, c...))
!(a::LNode) = LNode(!, a, :_)

+(a::LOGIC, b::LOGIC) = a == b == FALSE ? FALSE : TRUE
*(a::LOGIC, b::LOGIC) = a == b == TRUE ? TRUE : FALSE
!(a::LOGIC) = a == TRUE ? FALSE : TRUE
!(a::LOGIC, _) = !a

(l::LOGIC)(_) = l # quick workaround to make the below code not use as much function creation

function leval(ln::LNode, v)
	op = ln.op
	op == identity && return leval(ln.l, v)
	op == IN && return IN(ln.l, v)
	ln.op(leval(ln.l, v), leval(ln.r, v))
end
leval(s::Symbol, v) = IN(s, v)
leval(l::LOGIC, v) = l
(ln::LNode)(v) = leval(ln, v)
function IN(a, v)
    a in v ? TRUE : FALSE
end


function create(e::Expr)
    if e.head != :call
        throw("You aren't supposed to create restraints like that")
    end

    if e.args[1] == :*  # can't use eval due to some Julia eval while function policies
        return *(create.(e.args[2:end])...)
    elseif e.args[1] == :+
        return +(create.(e.args[2:end])...)
    elseif e.args[1] == :!
        return !(create(e.args[2]))
    end
    throw("You can only use + and * for restraints")
end

function create(s::Symbol)
	return LNode(IN, s, :_)
end

function create(s::AbstractString) 
    create(Meta.parse(replace(s, '[' => '(', ']' => ')'))) 
end
FFALSE = LNode(identity, FALSE, :_)
FTRUE = LNode(identity, TRUE, :_)
end
