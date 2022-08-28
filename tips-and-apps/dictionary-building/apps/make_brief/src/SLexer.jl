include("util.jl")

function slex(s::String)
    V = String[]
    do_write::Bool = true
    i = 1
    while i <= lastindex(s)
        c = s[i]
        if !do_write
            do_write = (c == TOK_CMT)
        else
            if isspace(c)
                nothing # don't do anything with spaces
            elseif c == TOK_DQ
                i = nextind(s, i)
                buffer_str = IOBuffer()
                while i <= lastindex(s) && s[i] != TOK_DQ
                    if s[i] == '\\'
                        i = nextind(s, i)
                        write(buffer_str, eval(Meta.parse("\"\\$(s[i])\"")))
                    else
                        write(buffer_str, s[i])
                    end
                    i = nextind(s, i)
                end
                push!(V, buffer_str |> take! |> String)
                @goto CONT
            elseif c == TOK_CMT
                do_write = false
            elseif c == TOK_DL
                next_dl = findnext(s, TOK_DL, i+1)
                append!(V, ("CONST." * s[nextind(s, i):prevind(s, next_dl)]) |> Meta.parse |> eval |> slex)
                i = next_dl
                @goto CONT
            elseif c in TOKENS
                push!(V, "$c")
            else
                word = IOBuffer()
                while i <= lastindex(s) && !(isspace(s[i]) || s[i] in TOKENS)
                    write(word, s[i])
                    i = nextind(s, i)
                end
                push!(V, word |> take! |> String)
                continue
            end
        end
        @label CONT
        i = nextind(s, i)
    end

    V
end