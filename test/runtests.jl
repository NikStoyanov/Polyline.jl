using polyline
using Test

pointCurrent = polyline.coordinate{Float64}(38.5, -120.2)
precision = 10. ^5

@testset "Round coordinates" begin
    pointRound::polyline.coordinate = polyline.coordinate{Float64}(pointCurrent.Lat * precision, pointCurrent.Lng * precision)
    roundValue = polyline.roundCoordinate(pointRound)
    @test roundValue.Lat == 3850000 && roundValue.Lng == -12020000
end

@testset "Write polyline" begin
    @test isequal(polyline.diffCoordinate(
                  polyline.coordinate{Int64}(3850000, -12020000),
                  polyline.coordinate{Int64}(0, 0)),
                  polyline.coordinate{Int64}(3850000, -12020000))

    @test isequal(polyline.leftShiftCoordinate(
                  polyline.coordinate{Int64}(3850000, -12020000)),
                  polyline.coordinate{Int64}(7700000, -24040000))

    @test isequal(polyline.encodeToChar(7700000),
                  "_p~iF")

    @test isequal(polyline.encodeToChar(-24040000),
                  "~ps|U")

    @test isequal(polyline.convertToChar(
                  polyline.coordinate{Int64}(7700000, -24040000)),
                  polyline.coordinate{String}("_p~iF", "~ps|U"))
end
