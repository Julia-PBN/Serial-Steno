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
    l::Union{LNode, Symbol}
    r::Union{LNode, Symbol}
end


+(a::LOGIC, b::LOGIC) = a == b == FALSE ? FALSE : TRUE
*(a::LOGIC, b::LOGIC) = a == b == TRUE ? TRUE : FALSE
!(a::LOGIC) = a == TRUE ? FALSE : TRUE
function IN(a, v)
    a in v ? TRUE : FALSE
end


function create(e::Expr)
    if e.head != :call
        throw("You aren't supposed to create restraints like that")
    end

    if e.args[1] == :*  # can't use eval due to some Julia eval while function policies
        return x -> *([f(x) for f in create.(e.args[2:end])]...)
    elseif e.args[1] == :+
        return x -> +([f(x) for f in create.(e.args[2:end])]...)
    elseif e.args[1] == :!
        return x -> !(create(e.args[2])(x))
    end
    throw("You can only use + and * for restraints")
end
function create(s::Symbol)
    return v -> IN(s, v)
end
function create(s::AbstractString) 
    create(Meta.parse(replace(s, '[' => '(', ']' => ')'))) 
end

FTRUE(x) = TRUE
FFALSE(x) = FALSE
end