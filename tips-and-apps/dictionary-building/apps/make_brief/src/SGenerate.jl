include("SParser.jl")



mutable struct Brief
    brief::String  # what you need to type
    expand::String  # what it expands to
    req::Logic.LNode  # what are the id required to create that brief  # only useful to generate them, don't touch that
    prov::Vector{Symbol}  # what are the id provided by that brief  # only useful to generate them, don't touch that
    bl::Logic.LNode  # to deal with what to return when the Block doesn't match  # only useful to generate them, don't touch that
end
import Base.+

+(a::Brief, b::Brief) = Brief(a.brief * b.brief,
                              a.expand * b.expand,
                              a.req * b.req,
                              union(a.prov, b.prov),
                              a.bl + b.bl)

function valid(b::Brief)
		(b.req(b.prov) * !(b.bl(b.prov))) == Logic.TRUE#  issubset(b.req, b.prov) && !any(x -> issubset(x, b.prov) && !isempty(x), b.bl)
end
function Briefs(n::Str)
    [Brief("", n.val, Logic.FTRUE, Symbol[], Logic.FFALSE)]
end

function Briefs(n::BinOp)
    L = Briefs(n.left)
    R = Briefs(n.right)
    if n.op == ADD
        return [a+b for a in L, b in R] |> vec
    elseif n.op == CONCAT
        return [a+b for a in L, b in R] |> vec # I just realised that they were the same...
    elseif n.op == ASSIGN
        return [Brief(a.expand, b.expand, a.req * b.req, union(a.prov, b.prov), a.bl + b.bl) for a in L, b in R] |> vec
    elseif n.op == OR
        return append!(L, R)
    end

    throw("That should have been all...")
end

function Briefs(n::Block)
    X = Brief[]
    if n.require != Logic.FTRUE && n.fallback == FUNC.NULL
        push!(X, Brief("", "", Logic.FTRUE, Symbol[], n.require))
    end
    briefs = Briefs(n.val)
    for i in briefs
        a, b = n.func(i.brief, i.expand)
        push!(X, Brief(a,
                        b,
                        i.req * n.require,
                        union(i.prov, n.provide),
                        i.bl))
        if n.require != Logic.FTRUE && n.fallback != FUNC.NULL
            a, b = n.fallback(i.brief, i.expand)
            push!(X, Brief(a,
                            b,
                            Logic.FTRUE,
                            Symbol[],
                            n.require
                    ))
        end
    end
    X
end

function sgenerate(N::Node; f = AHK_FORMAT)  # create your own format if needed
    t = time()
    println(stderr, "starting generating")
    briefs = Briefs(N)
    S = String[]
    for i in filter(valid, briefs)
        push!(S, f(i.brief, i.expand))
    end
    S |> unique!
    println(stderr, "finished generating in $(time()-t)s")
    return S
end

function AHK_FORMAT(brief, exp)
    "::$brief::$exp"
end
