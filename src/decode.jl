function transformPolyline(value, index)
end

decodePolyline(str::AbstractString; kwargs...) = decodePolyline(Vector{UInt8}(str); kwargs...)
function decodePolyline(polyline::Vector{UInt8}; precision=5)
	nums = Int32[0]
	count = 0
	for chunk = polyline .- 0x3f

		# accumulate bit chunks starting at LSB
		nums[end] |= eltype(nums)(chunk & 0x1f) << (precision*count)

		# the bit string continues if this bit is set, otherwise move to next
		if chunk & 0x20 == 0x20
			count += 1
		else
			nums[end] = (isodd(nums[end]) ? ~nums[end] : nums[end]) >> 1;
			count = 0
			push!(nums, 0)
		end
	end

	# rescale and accumulate the flat list of numbers
	return cumsum(reshape(nums[1:end-1]./10^precision, 2, :); dims=2)'
end
