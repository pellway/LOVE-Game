-- PLayer Attributes:
-- sprite 	 = 	current image to be displayed for the player
-- x 		 = 	Horizontal axis, from the top left corner of the sprite
-- y 		 = 	Vertical axis, from the top left corner of the sprite
-- movement  = 	Boolean value determining whether player is moving
-- speed 	 = 	Integer modifer for how fast the player moves

Player = {}

Player.new = function(x, y, speed)
    local self = self or {}
	self.sprite = love.graphics.newImage("Assets/playerFront.png")
	self.spriteFront = love.graphics.newImage("Assets/playerFront.png")
	self.spriteBack = love.graphics.newImage("Assets/playerBack.png")
	self.spriteLeft = love.graphics.newImage("Assets/playerLeft.png")
	self.spriteRight = love.graphics.newImage("Assets/playerRight.png")
    self.x = x
    self.y = y
    self.movement = false
    self.speed = speed

    -- Class Functions
    self.draw = function()
        love.graphics.draw(self.sprite, self.x, self.y)
    end

	-- Player Movement
	self.move = function()
		dt = love.timer.getDelta()
		if (love.keyboard.isDown("a")) then
			self.x = self.x - self.speed * dt
			self.sprite = self.spriteLeft
			self.movement = true
		end
		if (love.keyboard.isDown("d")) then
			self.x = self.x + self.speed * dt
			self.sprite = self.spriteRight
			self.movement = true
		end
		if (love.keyboard.isDown("w")) then
			self.y = self.y - self.speed * dt
			self.sprite = self.spriteBack
			self.movement = true
		end
		if (love.keyboard.isDown("s")) then
			self.y = self.y + self.speed * dt
			self.sprite = self.spriteFront
			self.movement = true
		end

		-- Tracks whether player is stopped
		if (love.keyboard.isDown("a") == true and love.keyboard.isDown("d") == true) then
			self.sprite = self.spriteFront
			if (love.keyboard.isDown("w") == true and love.keyboard.isDown("s") == false) then
				self.sprite = self.spriteBack
				self.movement = true
			elseif (love.keyboard.isDown("w") == false and love.keyboard.isDown("s") == true) then
				self.sprite = self.spriteFront                                                        
				self.movement = true
			else
				self.movement = false
			end
		end
		if (love.keyboard.isDown("w") == true and love.keyboard.isDown("s") == true) then
			self.sprite = self.spriteFront
			if (love.keyboard.isDown("a") == true and love.keyboard.isDown("d") == false) then
				self.sprite = self.spriteLeft
				self.movement = true
			elseif (love.keyboard.isDown("a") == false and love.keyboard.isDown("d") == true) then
				self.sprite = self.spriteRight
				self.movement = true
			else
				self.movement = false
			end
		end
		if (love.keyboard.isDown("a", "d", "w", "s") == false) then
			self.movement = false
		end

		-- Boundary collision
		if (self.x >= 1230) then
			self.x = 1230
		end
		if (self.x <= 0) then
			self.x = 0
		end

		-- If not moving, round to nearest integer
		if (self.movement == false) then
			self.x = math.floor(self.x + 0.5)
			self.y = math.floor(self.y + 0.5)
		end
	end

    return self
end

