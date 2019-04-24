# https://github.com/hicsail/polyline/blob/master/polyline/codec.py
# 1.Take the initial signed value:
#  -179.9832104
# 2.Take the decimal value and multiply it by 1e5, rounding the result:
#  -17998321
# 3.Convert the decimal value to binary. Note that a negative value must be
# calculated using its two's complement by inverting the binary value and
# adding one to the result:
#  00000001 00010010 10100001 11110001
#  11111110 11101101 01011110 00001110
#  11111110 11101101 01011110 00001111
# 4.Left-shift the binary value one bit:
#  11111101 11011010 10111100 00011110
# 5.If the original decimal value is negative, invert this encoding:
#  00000010 00100101 01000011 11100001
# 6.Break the binary value out into 5-bit chunks (starting from the right hand side):
#  00001 00010 01010 10000 11111 00001
# 7. Place the 5-bit chunks into reverse order:
#  00001 11111 10000 01010 00010 00001
# 8.OR each value with 0x20 if another bit chunk follows:
#  100001 111111 110000 101010 100010 000001
# 9.Convert each value to decimal:
#  33 63 48 42 34 1
# 10.Add 63 to each value:
#  96 126 111 105 97 64
# 11.Convert each value to its ASCII equivalent:
#  `~oia@

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

function signCheckCoordinate(currValue::coordinate{Int64})::coordinate{Int64}

    return currValue
end

# Convert the coordinates into ascii symbols
function convertToChar(currValue::coordinate{Int64})::coordinate{String}

    Lat::Int64 = currValue.Lat
    Lng::Int64 = currValue.Lng

    return coordinate{String}(encodeToChar(Lat), encodeToChar(Lng))
end

function encodeToChar(c::Int64)::String
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
    signCurrValue::coordinate{Int64} = signCheckCoordinate(leftShift)
    charCoordinate::coordinate{String} = convertToChar(signCurrValue)
end

function transformPolyline(value, index)
end

function decodePolyline(expr; precision=5)
end

function encodePolyline(coord, precision=5)
    factor::Int64 = 10^precision
end

end # module
