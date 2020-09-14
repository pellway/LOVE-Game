-- Game Exploration - Top Down
-- Created in LOVE (lua)
-- Patrick Ellway

-- https://github.com/love2d-community/awesome-love2d

-- To Do:
-- Add some enemies/trees
-- Add finite state functionality (Start Menu -> Game <-> Pause -> Start Menu)
-- Add buttons (clickable or keyboard) to switch states

require("Scripts.Player")

function love.load()
	io.write("Game initialised.\n")
	love.keyboard.setKeyRepeat(true)
	love.mouse.setRelativeMode(false)
	love.mouse.setCursor(love.mouse.getSystemCursor("hand"))

	bgm = love.audio.newSource("Audio/bgm.ogg", "stream")
	sfx = love.audio.newSource("Audio/sfx.wav", "static")
	love.audio.play(bgm)

	love.graphics.setBackgroundColor(85/255, 85/255, 85/255, 1)

	player = Player.new(50, 100, 100)

end

timer = 0
counter = 0
function love.update(dt)
	
	-- Console timer 
	timer = timer + dt
	if (timer >= 1) then
		counter = counter + 1
		if (counter % 5 == 0) then
			io.write(tostring(counter) .. " seconds have elapsed.\n")
		end
		timer = 0
	end

	-- Function for player movement (Player.Lua)
	player:move()
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
	-- Debug
	love.graphics.print({{0, 0, 0, 1}, "X Position: " .. player.x}, 10, 10)
	love.graphics.print({{0, 0, 0, 1}, "Y Position: " .. player.y}, 10, 30)
	love.graphics.print({{0, 0, 0, 1}, "Movement: " .. tostring(player.movement)}, 10, 50)
	love.graphics.print({{0, 0, 0, 1}, mouseMove}, 10, 70)
	love.graphics.print({{0, 0, 0, 1}, mouseButton}, 10, 90)

	-- Function for player animation (Player.Lua)
	player:draw()


end

function love.quit()
	io.write("Game terminated.\n")
end