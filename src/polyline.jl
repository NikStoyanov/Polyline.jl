#= Polyline encoder and decoder

This module performes an encoding and decoding for
gps coordinates into a polyline using the algorithm
detailed in:
https://developers.google.com/maps/documentation/utilities/polylinealgorithm

Example:
    >> encodePolyline([[50 100]; [51 101]])

Todo:
    * Add polyline decoding
=#

__precompile__()

module polyline

export decodePolyline, encodePolyline

# coodrinate is a type to represents a gps data point
struct coordinate{T}
    Lat::T
    Lng::T
end

function roundCoordinate(currValue::coordinate{Float64})::coordinate{Int64}
    #= Convert the coordinate to an integer and round.

    Args:
        currValue (coordinate{Float64}): GPS data point as a real number.
    Returs:
        roundedValue (coordinate{Int64}): GPS data point as rounded integer.
    =#

    roundedValue::coordinate = coordinate{Int64}(copysign(floor(abs(currValue.Lat)), currValue.Lat),
                                                 copysign(floor(abs(currValue.Lng)), currValue.Lng))
    return roundedValue
end

function diffCoordinate(currValue::coordinate{Int64},
                        prevValue::coordinate{Int64})::coordinate{Int64}
    #= Polyline encoding only considers the difference between GPS data points
    in order to reduce memory. diffCoordinate obtains the difference between
    consecutive coordinate points.

    Args:
        currValue (coordinate{Int64}): The current GPS data point.
        prevValue (coordinate{Int64}): The previous GPS data point. The count
                                       starts from 0.
    Returns:
        coordinate{Int64}: The difference between the GPS data points.
    =#

    return coordinate{Int64}(currValue.Lat - prevValue.Lat,
                             currValue.Lng - prevValue.Lng)
end

function leftShiftCoordinate(currValue::coordinate{Int64})::coordinate{Int64}
    #= Left bitwise shift to leave space for a sign bit as the right most bit.

    Args:
        currValue(coordinate{Int64}): The difference between the last two
                                      consecutive GPS data points.
    Returns:
        coordinate{Int64}: Left bitwise shifted values.
    =#

    return coordinate{Int64}(currValue.Lat << 1,
                             currValue.Lng << 1)
end

function convertToChar(currValue::coordinate{Int64})::coordinate{String}
    #= Convert the coordinates into ascii symbols.

    Args:
        currValue(coordinate{Int64}): Integer GPS coordinates.

    Returns:
        coordinate{String}: GPS coordinates as ASCII characters.
    =#

    Lat::Int64 = currValue.Lat
    Lng::Int64 = currValue.Lng

    return coordinate{String}(encodeToChar(Lat), encodeToChar(Lng))
end

function encodeToChar(c::Int64)::String
    #= Perform the encoding of the character from a binary number to ASCII.

    Args:
        c(Int64): GPS coordinate.

    Returns:
        String: ASCII characters of the polyline.
    =#

    LatChars = Array{Char, 1}(undef, 1)

    # Invert a negative coordinate using two's complement
    if c < 0
        c = ~c
    end

    # Add a continuation bit at the LHS for non-last chunks using OR 0x20
    # (0x20 = 100000)
    while c >= 0x20
        # Get the last 5 bits (0x1f)
        # Add 63 (in order to get "better" looking polyline characters in ASCII)
        CharMod = (0x20 | (c & 0x1f)) + 63
        append!(LatChars, Char(CharMod))

        # Shift 5 bits
        c = c >> 5
    end

    # Modify the last chunk
    append!(LatChars, Char(c + 63))

    # The return string holds a beginning character at the start
    # skip it and return the rest
    return join(LatChars[2:end])
end

function writePolyline!(output::String, currValue::coordinate{Float64},
                       prevValue::coordinate{Int64})
    #= Convert the given coordinate points in a polyline and mutate the output.

    Args:
        output(String): Holds the resultant polyline.
        currValue(coordinate{Float64}): Current GPS data point.
        prevValue(coordinate{Float64}): Previous GPS data point.

    Returns:
        output(String): Mutated output by adding the current addition to the
                        polyline.
    =#

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
