-- Game Exploration - Top Down
-- Created in LOVE 11.3 (lua)
-- Patrick Ellway

require("Scripts.Player")
require("Scripts.Fish")

GameState = 0
StartState = 1 
PlayState = 2
PauseState = 3

WindowWidth = love.graphics.getWidth()
WindowHeight = love.graphics.getHeight()

buttonWidth = 300
buttonHeight = 50
buttonX = WindowWidth/2 - (buttonWidth/2)
buttonY = WindowHeight/1.5

math.randomseed(os.time())

function love.load()
	io.write("Game initialised.\n")
	love.keyboard.setKeyRepeat(true)
	love.mouse.setRelativeMode(false)
	love.mouse.setCursor(love.mouse.getSystemCursor("hand"))

	bgm = love.audio.newSource("Audio/bgm.ogg", "stream")
	sfx = love.audio.newSource("Audio/sfx.wav", "static")
	love.audio.setVolume(0) -- To Mute

	player = Player.new(100, 120, 100, 8)

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

		function love.keypressed(key, scancode, isrepeat)
			if key == "b" then -- Adds a random fish
				if (#player.inventory < player.inventorySize) then 
					fishList = {"Trout", "Carp", "Salmon", "Tuna"}
					randomFish = Fish.new(fishList[math.random(#fishList)], "B")
					table.insert(player.inventory, randomFish)
				else 
					io.write("Inventory full!\n") -- FOR MAX INVENTORY SIZE
				end
			end
			if key == "r" then -- Remove inventory item
				table.remove(player.inventory)
			end
			if key == "p" then -- Prints inventory
				size = table.getn(player.inventory)
				io.write("Player's current inventory: \n")
				for i = 1, size do
					io.write("item "..tostring(i)..".\n")
					io.write(player.inventory[i]:getDetails())
				end
			end
			if key == "return" then -- Activate Pause Menu
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

	-- Menu Button Selection for Start Screen
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

	-- Menu Button Selection for Pause Screen
	if (GameState == PauseState) then
		if (x >= buttonX and x < buttonX + buttonWidth) then
			if (y >= buttonY and y < buttonY + buttonHeight) then
				io.write("Resume button pressed!\n")
				GameState = PlayState
				
			end
			if (y >= buttonY + 75 and y < buttonY + buttonHeight + buttonHeight/2 + buttonHeight) then
				io.write("Quit button pressed!\n")
				GameState = StartState
			end
		end
	end

end


function love.draw()

	if (GameState == StartState) then
		love.graphics.print("Start State", 10, 10)
		
		-- Menu Buttons
		startButton = love.graphics.newImage("Assets/startButton.png")
		quitButton = love.graphics.newImage("Assets/quitButton.png")
		love.graphics.draw(startButton, buttonX, buttonY)
		love.graphics.draw(quitButton, buttonX, buttonY + buttonHeight + buttonHeight/2)
	end

	if (GameState == PlayState) then
		love.graphics.print("Play State", 10, 10)

		love.graphics.print({{0, 0, 0, 1}, "X Position: " .. player.x}, 10, 30)
		love.graphics.print({{0, 0, 0, 1}, "Y Position: " .. player.y}, 10, 50)
		love.graphics.print({{0, 0, 0, 1}, "Movement: " .. tostring(player.movement)}, 10, 70)
		love.graphics.print({{0, 0, 0, 1}, mouseMove}, 10, 90)
		love.graphics.print({{0, 0, 0, 1}, mouseButton}, 10, 110)

		-- Function for player animation (Player.Lua)
		player:draw()

		-- TEST for drawing fish sprite
		if (table.getn(player.inventory) > 0) then
			for i = 1, #player.inventory do
				love.graphics.draw(player.inventory[i].sprite, WindowWidth/4+(i*64), WindowHeight-64)
				--love.graphics.print(num, WindowWidth/2+64, WindowHeight-64, 0, 2)
			end
		end
	end

	if (GameState == PauseState) then
		love.graphics.print("Pause State", 10, 10)

		-- Menu Buttons
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