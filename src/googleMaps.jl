using HTTP

function envVar()
    return run(`echo $(ENV["GOOGLE_MAPS_API"])`)
end

function mapsURL(path::String; type="terrain", size=800, scale=2)
    mapURL = "https://maps.googleapis.com/maps/api/staticmap?maptype="
    mapType = type
    mapPath = "&path=enc:" & path & "&"
    mapKey = envVar()
    mapSize = "&$size" * "x$size" * "&"
    mapScale = "scale=" & scale & "&"
    mapMarkersStart = "color:yellow|label:S|53.47101,-2.26714&"
    mapMarkersEnd = "color:green|label:F|53.47058000000003,-2.2645999999999984"
end

function getImage(url::String)
    r = HTTP.request("GET", url)
    println(r.status)
    println(String(r.body))
end
