#= Polyline encoder and decoder

This module performes an encoding and decoding for
gps coordinates into a polyline using the algorithm
detailed in:
https://developers.google.com/maps/documentation/utilities/polylinealgorithm

Example:
    julia> enc = encodePolyline([[38.5 -120.2]; [40.7 -120.95]; [43.252 -126.453]])
    "_p~iF~ps|U_ulLnnqC_mqNvxq`@"

Todo:
    * Add polyline decoding
=#

__precompile__()

module Polyline

export decodePolyline, encodePolyline

# coodrinate is a type to represents a gps data point
struct coordinate{T}
    Lat::T
    Lng::T
end

include("encode.jl")
include("decode.jl")

end # module
