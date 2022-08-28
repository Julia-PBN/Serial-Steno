include("SLexer.jl")

function sparse(lexed::Vector{String})
    isempty(lexed) && return Str("")
    ii = outer_index(lexed)

    f(type, x, y, z...) = type(x, f(type, y, z...))
    f(type, x, y) = type(x, y)
    f(type, x) = x

    if !(isempty(ii))
        if any(x -> lexed[x] == "|", ii)
            iii = filter(x -> lexed[x] == "|", ii)
            fncOR(a, b) = BinOp(OR, a, b)
            return f(fncOR, sparse.(vec_split(lexed, iii...))...)
        elseif any(x -> lexed[x] == ":", ii)
            i = ii[findfirst(x -> lexed[x] == ":", ii)]
            iii = filter(x -> lexed[x] == ",", ii)
            funcOR(a, b) = BinOp(OR, a, b)
            return BinOp(ASSIGN, f(funcOR, sparse.(vec_split(lexed[1:i-1], iii...))...), sparse(lexed[i+1:end])) #  BinOp(ASSIGN, sparse(lexed[1:i-1]), sparse(lexed[i+1:end]))  # TODO "f(fncOR, sparse.(vec_split(lexed, iii...))...)", but it applying only to the "left" part, prob : "BinOp(ASSIGN, f(fncOR, sparse.(vec_split(lexed[1:i-1], iii...))...), lexed[i+1:end])" but it's late, so will test it tomorow.
        elseif any(x -> lexed[x] == "+", ii)
            iii = filter(x -> lexed[x] == "+", ii)
            fncADD(a, b) = BinOp(ADD, a, b)
            return f(fncADD, sparse.(vec_split(lexed, iii...))...)
        end
    end
    
    if "(" in lexed
        i = findfirst(==("("), lexed)
        c = closing("(", ")", i+1, lexed)
        if i == 1
            if c == lastindex(lexed)
                return sparse(lexed[i+1:c-1])
            else
                return BinOp(CONCAT, sparse(lexed[i+1:c-1]), sparse(lexed[c+1:end]))
            end
        elseif lexed[i-1] == "}"
            o = opening("{", "}", i-2, lexed)
            restraint, provide, func, fallback = lexed[o+1:i-2] |>
                (x -> *(x...)) |>
                (x -> split(x, ",")) .|>
                String
            provides = split(provide, "|") .|> String

            B = Block(isempty(restraint) ? Logic.FTRUE : Logic.create(restraint),
                      provides ==  [""] ? Symbol[] : Symbol.(provides),
                      isempty(func) ? FUNC.I : "FUNC."*func |> Meta.parse |> eval,
                      isempty(fallback) ? FUNC.NULL : "FUNC."*fallback |> Meta.parse |> eval,
                      sparse(lexed[i+1:c-1]))

            if o == 1
                if c == lastindex(lexed)
                    return B
                else
                    return BinOp(CONCAT, B, sparse(lexed[c+1:end]))
                end
            else
                return BinOp(CONCAT, sparse(lexed[1:o-1]), sparse(lexed[o:end]))
            end
        else
            return BinOp(CONCAT, sparse(lexed[1:i-1]), sparse(lexed[i:end]))
        end
    end
    
    fncCONC(a, b) = BinOp(CONCAT, a, b)

    return f(fncCONC, Str.(lexed)...)
end