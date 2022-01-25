function str_list(str)
    a = split(str)
    a[1], join(a[2:end], " ")
end

function writebrief(list_brief, param = "")
    join([":$param:$(i[1])::$(i[2])" for i in list_brief], "\n")
end



# syntax

# a(val)a; b(smg)b => avala; bsmgb
# a((val)|()); b((smg)|())b => avala => bsmgb ; a => bb
function parse_brief(brief, expand)
    brief_list = _parse_side(brief)
    expand_list = _parse_side(expand)
    used = String[]
    tmp = Tuple{String, String}[]
    for i in 1:length(brief_list)
        if brief_list[i] ∉ used
            push!(used, brief_list[i])
            push!(tmp, (brief_list[i], expand_list[i]))
        end
    end
    tmp
end

function _parse_side(side)
    list = String[side]
    while any(i -> '(' in i || '|' in i, list)
        tmp = String[]
        for i in list
            if '(' in i
                s = myfindfirst('(', i)
                e = closing(i, s, '(', ')')
                append!(tmp, i[1:prevind(i, s)] .* _parse_side(i[nextind(i, s):prevind(i, e)]) .* i[nextind(i, e):end])
            elseif '|' in i
                append!(tmp, split(i, '|'))
            else
                push!(tmp, i)
            end
        end
        list = deepcopy(tmp)
    end
    return list
end

function closing(str, idx, open, close)
    enc = 0
    for i in eachindex(str)
        i <= idx && continue
        if str[i] == open
            enc += 1
        elseif str[i] == close
            if enc == 0
                return i
            end
            enc -= 1
        end
    end
    return -1
end

function myfindfirst(str, str_base)
    i = length(str)
    if i == 1
        return myfindfirst(str[1], str_base)
    else
        for j in 1:length(str_base)-i+1
            if str_base[j:j+i] == str
                return j
            end
        end
    end
    return -1
end

function myfindfirst(char::Char, str_base)
    for i in eachindex(str_base)
        str_base[i] == char && return i
    end
    -1
end

function transform(str, param="")
    writebrief(parse_brief(str_list(str)...), param)
end


# example of briefs
# example = "tkt t'inquiète"
# example2 = "(y|i|(o|è)(|y))(|e)(a(|v)|o(|r))(p|q('|(|(c|cl|cu|ce)(|à|i)))) (il y|il|(on|elle) n'(|y ))(|en )(a(|vait)|aura(|it))( pas| qu('|e(|( ce| celui| ceux| celui)(|-là|-ci))))"

# in example 2, 720 briefs written in one line ✓
  
println.(parse_brief(str_list(readline())...) |> writebrief)
