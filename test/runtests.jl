using Polyline
using Test
using LightXML

pointCurrent = Polyline.coordinate{Float64}(38.5, -120.2)
precision = 10. ^5

@testset "Round coordinates" begin
    pointRound::Polyline.coordinate = Polyline.coordinate{Float64}(pointCurrent.Lat * precision, pointCurrent.Lng * precision)
    roundValue = Polyline.roundCoordinate(pointRound)
    @test roundValue.Lat == 3850000 && roundValue.Lng == -12020000
end

@testset "Write polyline" begin
    @test isequal(Polyline.diffCoordinate(
                  Polyline.coordinate{Int64}(3850000, -12020000),
                  Polyline.coordinate{Int64}(0, 0)),
                  Polyline.coordinate{Int64}(3850000, -12020000))

    @test isequal(Polyline.leftShiftCoordinate(
                  Polyline.coordinate{Int64}(3850000, -12020000)),
                  Polyline.coordinate{Int64}(7700000, -24040000))

    @test isequal(Polyline.encodeToChar(7700000),
                  collect("_p~iF"))

    @test isequal(Polyline.encodeToChar(-24040000),
                  collect("~ps|U"))

    conv = Polyline.convertToChar(Polyline.coordinate{Int64}(7700000, -24040000))
    @test isequal(conv.Lat, collect("_p~iF"))
    @test isequal(conv.Lng, collect("~ps|U"))

    gps_coord = [[38.5 -120.2]; [40.7 -120.95]; [43.252 -126.453]]
    @test isequal(encodePolyline(gps_coord),
                  "_p~iF~ps|U_ulLnnqC_mqNvxq`@")
end

@testset "Read GPX" begin
    gpxFile = """
    <?xml version="1.0" encoding="UTF-8"?>
    <gpx creator="StravaGPX" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xsi:schemaLocation="http://www.topografix.com/GPX/1/1 http://www.topografix.com/GPX/1/1/gpx.xsd http://www.garmin.com/xmlschemas/GpxExtensions/v3 http://www.garmin.com/xmlschemas/GpxExtensionsv3.xsd http://www.garmin.com/xmlschemas/TrackPointExtension/v1 http://www.garmin.com/xmlschemas/TrackPointExtensionv1.xsd" version="1.1" xmlns="http://www.topografix.com/GPX/1/1" xmlns:gpxtpx="http://www.garmin.com/xmlschemas/TrackPointExtension/v1" xmlns:gpxx="http://www.garmin.com/xmlschemas/GpxExtensions/v3">
     <metadata>
      <time>2019-05-15T07:05:06Z</time>
     </metadata>
     <trk>
      <name>Bridgewater canal - St Georges island</name>
      <type>9</type>
      <trkseg>
       <trkpt lat="53.4717570" lon="-2.2640200">
        <ele>29.2</ele>
        <time>2019-05-15T07:05:06Z</time>
        <extensions>
         <gpxtpx:TrackPointExtension>
          <gpxtpx:hr>76</gpxtpx:hr>
          <gpxtpx:cad>0</gpxtpx:cad>
         </gpxtpx:TrackPointExtension>
        </extensions>
       </trkpt>
       <trkpt lat="53.4717570" lon="-2.2640200">
        <ele>29.2</ele>
        <time>2019-05-15T07:05:07Z</time>
        <extensions>
         <gpxtpx:TrackPointExtension>
          <gpxtpx:hr>76</gpxtpx:hr>
          <gpxtpx:cad>0</gpxtpx:cad>
         </gpxtpx:TrackPointExtension>
        </extensions>
       </trkpt>
      </trkseg>
     </trk>
    </gpx>"""

    xDoc = parse_string(gpxFile)
    gpxRoute = [53.4718 -2.26402; 53.4718 -2.26402]

    @test gpxRoute ≈ parseGPX(xDoc) atol=0.0001
end
