using LightXML

export parseGPX, readGPX

# Converts a file to XML Document.
function readGPX(filename::String)
    return parse_file(filename)
end

#= Converts a XMLDocument to array of longitude and latitude.

Args:
    gpxDoc(XMLDocument): XML document in GPX format.
Returns
    Array{Float64, 2}: GPS coordinates with longitude and latitude.
=#
function parseGPX(gpxDoc::XMLDocument)

    gpxPath = Array{Float64, 2}
    gpxLng = zeros(0)
    gpxLon = zeros(0)

    xroot = root(gpxDoc)
    trk = get_elements_by_tagname(xroot, "trk")[1]
    trkseg = get_elements_by_tagname(trk, "trkseg")[1]
    trkpt = get_elements_by_tagname(trkseg, "trkpt")

    for c in child_nodes(trkseg)
        if is_elementnode(c)
            ad = attributes_dict(XMLElement(c))

            append!(gpxLng, parse(Float64, (ad["lat"])))
            append!(gpxLon, parse(Float64, (ad["lon"])))
        end
    end

    return cat(dims=2, gpxLng, gpxLon)
end
