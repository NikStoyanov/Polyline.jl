__precompile__()

module polyline

export decodePolyline, encodePolyline

struct coordinate{T}
    Lat::T
    Lng::T
end

# Convert the coordinate to decimal and round
function roundCoordinate(currValue::coordinate{Float64})::coordinate{Int64}
    roundedValue::coordinate = coordinate{Int64}(copysign(floor(abs(currValue.Lat)), currValue.Lat),
                                                 copysign(floor(abs(currValue.Lng)), currValue.Lng))
    return roundedValue
end

# Obtain the difference between consecutive coordinate points
function diffCoordinate(currValue::coordinate{Int64},
                        prevValue::coordinate{Int64})::coordinate{Int64}
    return coordinate{Int64}(currValue.Lat - prevValue.Lat,
                             currValue.Lng - prevValue.Lng)
end

# Left bitwise shift
function leftShiftCoordinate(currValue::coordinate{Int64})::coordinate{Int64}
    return coordinate{Int64}(currValue.Lat << 1,
                             currValue.Lng << 1)
end

# Convert the coordinates into ascii symbols
function convertToChar(currValue::coordinate{Int64})::coordinate{String}

    Lat::Int64 = currValue.Lat
    Lng::Int64 = currValue.Lng

    return coordinate{String}(encodeToChar(Lat), encodeToChar(Lng))
end

function encodeToChar(c::Int64)::String
    # invert negative value using two's complement
    if c < 0
        c = ~c
    end

    LatChars = Array{Char, 1}(undef, 1)

    while c >= 0x20
        CharMod = (0x20 | (c & 0x1f)) + 63
        append!(LatChars, Char(CharMod))
        c = c >> 5
    end

    append!(LatChars, Char(c + 63))

    return join(LatChars[2:end])
end

#
function writePolyline(output::String, currValue::coordinate{Float64},
                       prevValue::coordinate{Int64})

    roundCurrValue::coordinate{Int64} = roundCoordinate(currValue)
    diffCurrValue::coordinate{Int64} = diffCoordinate(roundCurrValue, prevValue)
    leftShift::coordinate{Int64} = leftShiftCoordinate(diffCurrValue)
    charCoordinate::coordinate{String} = convertToChar(leftShift)
end

function transformPolyline(value, index)
end

function decodePolyline(expr; precision=5)
end

function encodePolyline(coord, precision=5)
    factor::Int64 = 10^precision
end

end # module
