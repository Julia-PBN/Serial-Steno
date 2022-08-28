module THINGY  # I'm fed up with namespace, so... yeah...
    include("src/SGenerate.jl")
end

const PATH = raw"the/file/you/write/your/doc/in" # put the path of your file there
const TO = raw"where/you/want/the/file/to/be/written/into"  # put where you want it to be written
const REPLACE = false # if `true`, it will replace the file "TO" value instead of appending to it DANGEROUS!!! I'm not keeping any responsability of wrecked dictionary (though, I'll share your sadness)

transform(x) = x |> THINGY.slex |> THINGY.sparse |> THINGY.sgenerate

open(TO, REPLACE ? "w" : "a") do io
    write(io, "\r\n")
    for i in transform(read(PATH) |> String)
        write(io, "\r\n")
        write(io, i)
    end
end

