include("SLexer.jl")

module SParserMisc
	f(type, x, y, z...) = type(x, f(type, y, z...))
	f(type, x, y) = type(x, y)
	f(type, x) = x
end

function _sparse(lexed)::Node
    isempty(lexed) && return Str("")
    ii = outer_index(lexed)

    if !(isempty(ii))
        if any(x -> lexed[x] == "|", ii)
            iii = filter!(x -> lexed[x] == "|", ii)
            fncOR(a, b) = BinOp(OR, a, b)
            return SParserMisc.f(fncOR, _sparse.(vec_split(lexed, iii...))...)
        elseif any(x -> lexed[x] == ":", ii)
            i = ii[findfirst(x -> lexed[x] == ":", ii)]
            iii = filter!(x -> lexed[x] == ",", ii)
            funcOR(a, b) = BinOp(OR, a, b)
	        return BinOp(ASSIGN, SParserMisc.f(funcOR, _sparse.(vec_split(view(lexed, 1:i-1), iii...))...), _sparse(view(lexed, i+1:lastindex(lexed)))) #  BinOp(ASSIGN, _sparse(lexed[1:i-1]), _sparse(lexed[i+1:end]))  # TODO "f(fncOR, _sparse.(vec_split(lexed, iii...))...)", but it applying only to the "left" part, prob : "BinOp(ASSIGN, f(fncOR, _sparse.(vec_split(lexed[1:i-1], iii...))...), lexed[i+1:end])" but it's late, so will test it tomorow.
        elseif any(x -> lexed[x] == "+", ii)
            iii = filter!(x -> lexed[x] == "+", ii)
            fncADD(a, b) = BinOp(ADD, a, b)
            return SParserMisc.f(fncADD, _sparse.(vec_split(lexed, iii...))...)
        end
    end
    
    if "(" in lexed
        i = findfirst(==("("), lexed)
        c = closing("(", ")", i+1, lexed)
        if i == 1
            if c == lastindex(lexed)
		    return _sparse(view(lexed, i+1:c-1))
            else
		    return BinOp(CONCAT, _sparse(view(lexed, i+1:c-1)), _sparse(view(lexed, c+1:lastindex(lexed))))
            end
        elseif lexed[i-1] == "}"
            o = opening("{", "}", i-2, lexed)
	    restraint, provide, func, fallback = view(lexed, o+1:i-2) |>
                (x -> *(x...)) |>
                (x -> split(x, ",")) .|>
                String
            provides = split(provide, "|") .|> String

            B = Block(isempty(restraint) ? Logic.FTRUE : Logic.create(restraint),
                      provides ==  [""] ? Symbol[] : Symbol.(provides),
                      isempty(func) ? FUNC.I : "FUNC."*func |> Meta.parse |> eval,
                      isempty(fallback) ? FUNC.NULL : "FUNC."*fallback |> Meta.parse |> eval,
		      _sparse(view(lexed, i+1:c-1)))

            if o == 1
                if c == lastindex(lexed)
                    return B
                else
			return BinOp(CONCAT, B, _sparse(view(lexed, c+1:lastindex(lexed))))
                end
            else
		    return BinOp(CONCAT, _sparse(view(lexed, 1:o-1)), _sparse(view(lexed, o:lastindex(lexed))))
            end
        else
		return BinOp(CONCAT, _sparse(view(lexed, 1:i-1)), _sparse(view(lexed, i:lastindex(lexed))))
        end
    end
    
    fncCONC(a, b) = BinOp(CONCAT, a, b)

    return SParserMisc.f(fncCONC, Str.(lexed)...)
end
function sparse(lexed::Vector{String})
	t = time()
	println(stderr, "starting parsering")
	r = _sparse(lexed)
	@time _sparse(lexed)
	println(stderr, "finished parsering in $(time()-t)s")
	return r
end
