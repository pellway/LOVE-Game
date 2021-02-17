-- Player Attributes:
-- sprite 	 = 	current image to be displayed for the player
-- x 		 = 	Horizontal axis, from the top left corner of the sprite
-- y 		 = 	Vertical axis, from the top left corner of the sprite
-- movement  = 	Boolean value determining whether player is moving
-- speed 	 = 	Integer modifer for how fast the player moves


-- TODO: Make Inventory system

Player = {}

Player.new = function(x, y, speed, inventorySize)
    local self = self or {}
	self.spriteFront = love.graphics.newImage("Assets/PlayerFront.png")
	self.spriteBack = love.graphics.newImage("Assets/PlayerBack.png")
	self.spriteLeft = love.graphics.newImage("Assets/PlayerLeft.png")
	self.spriteRight = love.graphics.newImage("Assets/PlayerRight.png")
	self.sprite = self.spriteFront
    self.x = x
    self.y = y
    self.movement = false
    self.speed = speed
	self.inventory = {}
	self.inventorySize = 8

    -- Class Functions
    self.draw = function()
        love.graphics.draw(self.sprite, self.x, self.y)
	end
	
	self.default = function()
        self.x = 100
		self.y = 120
		self.sprite = self.spriteFront
    end

	-- Player Movement
	self.move = function()
		dt = love.timer.getDelta()
		local isDown = love.keyboard.isDown

		if (isDown("a")) then
			self.x = self.x - self.speed * dt
			self.sprite = self.spriteLeft
			self.movement = true
		end
		if (isDown("d")) then
			self.x = self.x + self.speed * dt
			self.sprite = self.spriteRight
			self.movement = true
		end
		if (isDown("w")) then
			self.y = self.y - self.speed * dt
			self.sprite = self.spriteBack
			self.movement = true
		end
		if (isDown("s")) then
			self.y = self.y + self.speed * dt
			self.sprite = self.spriteFront
			self.movement = true
		end

		-- Tracks whether player is stopped
		if (isDown("a") == true and isDown("d") == true) then
			self.movement = false
			if (isDown("w") == true and isDown("s") == false) then
				self.sprite = self.spriteBack
				self.movement = true
			elseif (isDown("w") == false and isDown("s") == true) then
				self.sprite = self.spriteFront                                                        
				self.movement = true
			else
				self.movement = false
			end
		end
		if (isDown("w") == true and isDown("s") == true) then
			self.sprite = self.spriteFront
			if (isDown("a") == true and isDown("d") == false) then
				self.sprite = self.spriteLeft
				self.movement = true
			elseif (isDown("a") == false and isDown("d") == true) then
				self.sprite = self.spriteRight
				self.movement = true
			else
				self.movement = false
			end
		end

		if (isDown("a", "d", "w", "s") == false) then
			self.movement = false
		end

		-- Boundary collision
		if (self.x >= love.graphics.getWidth()-64) then
			self.x = love.graphics.getWidth()-64
		end
		if (self.x <= 0) then
			self.x = 0
		end
		if (self.y >= love.graphics.getHeight()-64) then
			self.y = love.graphics.getHeight()-64
		end
		if (self.y <= 0) then
			self.y = 0
		end

		-- If not moving, round to nearest integer
		if (self.movement == false) then
			self.x = math.floor(self.x + 0.5)
			self.y = math.floor(self.y + 0.5)
		end
	end

    return self
end

