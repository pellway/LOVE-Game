-- Game Exploration - Top Down
-- Created in LOVE (lua)
-- Patrick Ellway

-- https://github.com/love2d-community/awesome-love2d

-- To Do:
-- Add GUI in start and pause menus (Buttons)
-- Add some enemies/trees

require("Scripts.Player")

GameState = 0
StartState = 1 
PlayState = 2
PauseState = 3

function love.load()
	io.write("Game initialised.\n")
	love.keyboard.setKeyRepeat(true)
	love.mouse.setRelativeMode(false)
	love.mouse.setCursor(love.mouse.getSystemCursor("hand"))

	bgm = love.audio.newSource("Audio/bgm.ogg", "stream")
	sfx = love.audio.newSource("Audio/sfx.wav", "static")

	player = Player.new(50, 100, 100)

	GameState = 1

end

timer = 0
counter = 0
function love.update(dt)
	
	if (GameState == StartState) then
		love.graphics.setBackgroundColor(25/255, 25/255, 25/255, 1)
		love.audio.stop(bgm)
		
		if (love.keyboard.isDown("return")) then
			GameState = PlayState
		end
	end
	
	-- Code block for Play Screen
	if (GameState == PlayState) then
		-- Console timer 
		timer = timer + dt
		if (timer >= 1) then
			counter = counter + 1
			if (counter % 5 == 0) then
				io.write(tostring(counter) .. " seconds have elapsed during play.\n")
			end
			timer = 0
		end
		
		love.graphics.setBackgroundColor(85/255, 85/255, 85/255, 1)
		love.audio.play(bgm)

		-- Function for player movement (Player.Lua)
		player:move()

		-- Activate Pause Menu
		function love.keypressed(key, scancode, isrepeat)
			if key == "return" then
				GameState = PauseState
			end
		end
	end

	if (GameState == PauseState) then
		love.audio.pause(bgm)
		love.graphics.setBackgroundColor(125/255, 125/255, 125/255, 1)
		-- Remove this temp
		
		function love.keypressed(key, scancode, isrepeat)
			if key == "return" then
				GameState = PlayState
			end
			if key == "escape" then
				GameState = StartState
			end
		end
	end

end


-- Mouse Functionality
function love.mousemoved(x, y, dx, dy)
	mouseMove = "Mouse Position: " .. x .. " | " .. y
end
function love.mousepressed(x, y, button, istouch, presses)
	if button == 1 then
		mouseButton = "Left button pressed"
		love.audio.stop(sfx)
		love.audio.play(sfx)
	end
	if button == 2 then
		mouseButton = "Right button pressed"
		love.audio.stop(sfx)
		love.audio.play(sfx)
	end
end
function love.mousereleased(x, y, button, istouch, presses)
	if button == 1 then
		if love.mouse.isDown(2) == true then
			mouseButton = "Right button pressed"
		else
			mouseButton = ""
		end
	end
	if button == 2 then
		if love.mouse.isDown(1) == true then
			mouseButton = "Left button pressed"
		else
			mouseButton = ""
		end
	end

end


function love.draw()
	
	if (GameState == StartState) then
		love.graphics.print("Start State", 10, 10)
	end

	if (GameState == PlayState) then
		-- Debug
		love.graphics.print("Play State", 10, 10)
		love.graphics.print({{0, 0, 0, 1}, "X Position: " .. player.x}, 10, 30)
		love.graphics.print({{0, 0, 0, 1}, "Y Position: " .. player.y}, 10, 50)
		love.graphics.print({{0, 0, 0, 1}, "Movement: " .. tostring(player.movement)}, 10, 70)
		love.graphics.print({{0, 0, 0, 1}, mouseMove}, 10, 90)
		love.graphics.print({{0, 0, 0, 1}, mouseButton}, 10, 110)

		-- Function for player animation (Player.Lua)
		player:draw()
	end

	if (GameState == PauseState) then
		love.graphics.print("Pause State", 10, 10)
	end

end

function love.quit()
	io.write("Game terminated.\n")
end