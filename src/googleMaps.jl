function mapsURL(path::String; type="terrain", token::String=ENV["GOOGLE_MAPS_API"],
                 size=800, scale=2, MarkersStart=(0.0, 0.0), MarkersEnd=(0.0, 0.0))
    mapURL = "https://maps.googleapis.com/maps/api/staticmap?maptype="
    mapType = type
    mapPath = "&path=enc:" * path * "&"
    mapKey = "key=$token" * "&"
    mapSize = "size=$size" * "x$size" * "&"
    mapScale = "scale=$scale"

    mapMarkersStart = ""
    if MarkersStart != (0.0, 0.0)
        mapMarkersStart = "&markers=color:yellow|label:S|$(MarkersStart[1]),$(MarkersStart[2])"
    end

    mapMarkersEnd = ""
    if MarkersEnd != (0.0, 0.0)
        mapMarkersEnd = "&markers=color:green|label:F|$(MarkersEnd[1]),$(MarkersEnd[2])"
    end

    return mapURL * mapType * mapPath * mapKey * mapSize * mapScale *
           mapMarkersStart * mapMarkersEnd
end

function getMapImage(URL::String; pathFig="/tmp/polyline.png")
    download(URL, pathFig)
end
