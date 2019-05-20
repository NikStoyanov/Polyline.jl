using HTTP

function mapsURL(path::String; type="terrain", token::String=ENV["GOOGLE_MAPS_API"],
                 size=800, scale=2, mapMarkersStart="", mapMarkersEnd="")
    mapURL = "https://maps.googleapis.com/maps/api/staticmap?maptype="
    mapType = type
    mapPath = "&path=enc:" * path * "&"
    mapKey = "key=$token" * "&"
    mapSize = "size=$size" * "x$size" * "&"
    mapScale = "scale=$scale" * "&"

    return mapURL * mapType * mapPath * mapKey * mapSize * mapScale *
           mapMarkersStart * mapMarkersEnd
end

function getMapImage(URL::String; pathFig="/tmp/polyline.png")
    download(mapsURL(URL), pathFig)
end
