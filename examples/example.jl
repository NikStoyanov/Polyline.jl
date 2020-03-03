using Polyline

# Load gpx file and parse.
gpxFile = readGPX("route.gpx")
gpxRoute = parseGPX(gpxFile)

# Encode polyline
polyline = encodePolyline(gpxRoute)

# Decode polyline
route = decodePolyline(polyline)

# Plot the route in Goole maps. You would need to obtain a token from the static maps API
# which you can find here:
# https://developers.google.com/maps/documentation/maps-static/get-api-key
# Then either pass it as an argument or set it as the environment variable GOOGLE_MAPS_API
#url = mapsURL(polyline)

# Or set the API token as an argument.
url = mapsURL(polyline; token="...")

# With the custom defaults you can plot the route.
getMapImage(url; pathFig="/tmp/fig1.png")

# Full customization.
url = mapsURL(polyline; token="...",
              type = "roadmap", # https://developers.google.com/maps/documentation/maps-static/dev-guide#MapTypes
              size = 1000,
              scale = 2, # https://developers.google.com/maps/documentation/maps-static/dev-guide#scale_values
              MarkersStart = (gpxRoute[1, 1], gpxRoute[1, 2]),
              MarkersEnd = (gpxRoute[end, 1], gpxRoute[end, 2]))

getMapImage(url; pathFig="/tmp/fig2.png")
