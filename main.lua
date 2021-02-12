-- Game Exploration - Top Down
-- Created in LOVE 11.3 (lua)
-- Patrick Ellway

require("Scripts.Player")
require("Scripts.Fish")

GameState = 0
StartState = 1 
PlayState = 2
PauseState = 3

buttonSelect = 1
buttonWidth = 300
buttonHeight = 50
buttonX = love.graphics.getWidth()/2 - (buttonWidth/2)
buttonY = love.graphics.getHeight()/1.5

math.randomseed(os.time())

function love.load()
	io.write("Game initialised.\n")
	love.keyboard.setKeyRepeat(true)
	love.mouse.setRelativeMode(false)
	love.mouse.setCursor(love.mouse.getSystemCursor("hand"))

	bgm = love.audio.newSource("Audio/bgm.ogg", "stream")
	sfx = love.audio.newSource("Audio/sfx.wav", "static")

	player = Player.new(100, 120, 100)

	GameState = 1

end

timer = 0
counter = 0
function love.update(dt)
	
	if (GameState == StartState) then
		love.graphics.setBackgroundColor(25/255, 25/255, 25/255, 1)
		love.audio.stop(bgm)
		player:default()
		
		function love.keypressed(key, scancode, isrepeat)
			if key == "return" then
				GameState = PlayState
			end
			if key == "escape" then
				love.quit()
			end

			if (buttonSelect == 1) then


			end


		end
	end
	
	-- Code block for Play Screen
	if (GameState == PlayState) then
		-- Console timer 
		timer = timer + dt
		if (timer >= 1) then
			counter = counter + 1
			if (counter % 10 == 0) then
				io.write(tostring(counter) .. " seconds have elapsed during play state.\n")
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
				
				love.window.setMode(512*2, 288*2)
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

	-- Menu Button Selection
	if (GameState == StartState) then
		if (x >= buttonX and x < buttonX + buttonWidth) then
			if (y >= buttonY and y < buttonY + buttonHeight) then
				io.write("Start button pressed!\n")
				GameState = PlayState
				
			end
			if (y >= buttonY + 75 and y < buttonY + buttonHeight + buttonHeight/2 + buttonHeight) then
				io.write("Quit button pressed!\n")
				love.event.quit()
			end
		end
	end

end


function love.draw()
	
	love.graphics.setCanvas(canvas)

	if (GameState == StartState) then
		love.graphics.print("Start State", 10, 10)
		
		-- Menu Buttons
		startButton = love.graphics.newImage("Assets/startButton.png")
		quitButton = love.graphics.newImage("Assets/quitButton.png")
		love.graphics.draw(startButton, buttonX, buttonY)
		love.graphics.draw(quitButton, buttonX, buttonY + buttonHeight + buttonHeight/2)
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

		resumeButton = love.graphics.newImage("Assets/resumeButton.png")
		quitButton = love.graphics.newImage("Assets/quitButton.png")
		love.graphics.draw(resumeButton, buttonX, buttonY)
		love.graphics.draw(quitButton, buttonX, buttonY + 75)
	end

end

function love.quit()
	io.write("Game terminated.\n")
	love.event.quit()
end