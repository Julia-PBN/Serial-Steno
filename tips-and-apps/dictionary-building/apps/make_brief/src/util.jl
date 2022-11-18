include("logic.jl")

module FUNC
    include("funcs.jl")
end

module CONST
    include("const.jl")
end

function closing(open, close, first_index, vector)  # assume it's for a vector and not a String
    d = 0
    
    for i in first_index:lastindex(vector)
        if vector[i] == open
            d += 1
        elseif vector[i] == close
            if d == 0
                return i
            else
                d -= 1
            end
        end
    end
    throw("missing $(closing) to $(open) at index $(first_index) of $(vector)")
end

function opening(open, close, last_index, vector)
    d = 0
    for i in last_index:-1:1
        if vector[i] == close
            d += 1
        elseif vector[i] == open
            if d == 0
                return i
            else
                d -= 1
            end
        end
    end
    throw("missing $(open) to $(close) at index $(last_index)")
end

function findnext(iterable, char, firstind)
    for (i, v) in pairs(iterable)
        i < firstind && continue
        v == char && return i
    end
    throw("missing $(char) after $(firstind) in $(iterable)")
end
const TOK_LP = '('
const TOK_RP = ')'
const TOK_LB = '['
const TOK_RB = ']'
const TOK_RC = '{'
const TOK_LC = '}'
const TOK_OR = '|'
const TOK_SEP = ','
const TOK_ASSIGN = ':'
const TOK_PLUS = '+'
const TOK_CMT = '#'
const TOK_DQ = '"'
const TOK_DL = '$'

TOKENS = [TOK_LP, TOK_RP, TOK_LB, TOK_RB, TOK_RC, TOK_LC, TOK_OR, TOK_SEP, TOK_ASSIGN, TOK_PLUS, TOK_CMT, TOK_DQ, TOK_DL]

@enum OP begin
    ADD
    OR
    CONCAT
    ASSIGN
end

function outer_index(V)
    pd = 0
    cd = 0
    v = Int[]
    for (i, s) in pairs(V)
        if s == "("
            pd += 1
        elseif s == ")"
            pd -= 1
        elseif s == "{"
            cd += 1
        elseif s == "}" 
            cd -= 1
        else
            if pd == 0 && cd == 0
                push!(v, i)
            end
        end
    end
    v
end

vec_split(vec) = [vec]
vec_split(vec, indices...) = append!([vec[1:indices[1]-1]], vec_split(vec[indices[1]+1:end], (indices[2:end] .- indices[1])...))

abstract type Node end

struct BinOp <: Node
    op::OP
    left::Node
    right::Node
end

struct Block <: Node
    require::Logic.LNode
    provide::Vector{Symbol}
    func::Function
    fallback::Function
    val::Node
end

struct Str <: Node
    val::String
end

prettier_print(n) = prettier_print(n, 0)
prettier_print(n, t) = println("  "^t, n)
function prettier_print(n::Node, t)
    for nm in fieldnames(n |> typeof)
        println("  "^t, nm, ':')
        prettier_print(getfield(n, nm), t+1)
    end
end

# TODO: use this for lexer, to be able to use '{' or whatever as single character string and not just token
# struct LexAtom
#    is_token::Bool
#    val::String
# end
