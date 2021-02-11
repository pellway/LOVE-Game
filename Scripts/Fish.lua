-- Fish Attributes:
-- name 	 	= 	Name of species of fish (Trout, Carp, Salmon, Tuna)
-- sprite 	 	= 	Image associated with specific fish
-- type 	 	= 	Can be either "Freshwater" or "Saltwater"
-- size 	 	= 	Float value, length of a fish in cm (based on a predefined distribution)
-- grade 	 	= 	Quality of fish, ranges from S to E (based on player's skill)
-- value 	 	= 	Integer value of fish in currency (dependent on size and grade)

-- Sizes of fish, format is {min, max, mean}
TroutSize = {5, 65, 32}
CarpSize = {25, 80, 54}
SalmonSize = {68, 160, 122}
TunaSize = {160, 300, 225}

function randBias(arraySize, influence)
	rnd = math.random() * (arraySize[2] - arraySize[1]) + arraySize[1]
	mix = math.random() * influence
	var = rnd * (1 - mix) + arraySize[3] * mix
	return math.floor(var * 100) / 100
end

-- Class Declaration for Fish
Fish = {}

Fish.new = function(name, grade)
	local self = self or {}
	self.name = name
	self.sprite = love.graphics.newImage("Assets/" .. name .. ".png")
	if (name == "Trout" or name == "Carp") then
		self.type = "Freshwater"
	elseif (name == "Salmon" or name == "Tuna") then
		self.type = "Saltwater"
	end

	fishSize = tostring(name).."Size"
	self.size = randBias(_G[fishSize], 1)

	self.grade = grade -- for now, static grades
	self.value = math.floor(size) * 10 -- Not yet including grade

    

    return self
end