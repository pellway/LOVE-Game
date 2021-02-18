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
PrawnSize = {4, 8, 20}

function randBias(arraySize, influence)
	rnd = math.random() * (arraySize[2] - arraySize[1]) + arraySize[1]
	mix = math.random() * influence
	var = rnd * (1 - mix) + arraySize[3] * mix
	return math.floor(var * 100) / 100
end

function valueCalc(size, grade) -- Calculates the value of a fish based on size * grade
	gradeNum = 1
	if (grade == "S") then
		gradeNum = 5
	elseif (grade == "A") then
		gradeNum = 3
	elseif (grade == "B") then
		gradeNum = 2.5
	elseif (grade == "C") then
		gradeNum = 2
	elseif (grade == "D") then
		gradeNum = 1.5
	elseif (grade == "E") then
		gradeNum = 1
	end
	return math.floor((size * gradeNum) + 0.5)
end

-- Class Declaration for Fish
Fish = {}

Fish.new = function(name, grade)
	local self = self or {}
	self.name = name
	self.sprite = love.graphics.newImage("Assets/" .. name .. ".png")
	if (name == "Trout" or name == "Carp") then
		self.type = "Freshwater"
	elseif (name == "Salmon" or name == "Tuna" or name == "Prawn") then
		self.type = "Saltwater"
	end

	fishSize = tostring(name).."Size"
	self.size = randBias(_G[fishSize], 1)

	self.grade = grade -- for now, static grades
	self.value = valueCalc(self.size, self.grade)

    self.getDetails = function()
		io.write("name: "..self.name.."\n")
		io.write("type: "..self.type.."\n")
		io.write("size: "..self.size.."cm\n")
		io.write("grade: "..self.grade.."\n")
		io.write("value: "..self.value.." bits\n")
		io.write("\n")
	end

    return self
end