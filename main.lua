--[[
love.load() - initialising game state at the beginning of program 
love.update(dt) - dt(deltaTime) will be the elapsed time in seconds sinse the last frame
love.draw() - called after update for drawing things on the screen after they are changed
love.graphics.printf(text, x, y, [width], [align])
love.window.setMode(width, height, params) - window's dimension; parms like vertical sync/ resizable etc
love.graphics.setDefaultFilter(min, mag) - Sets the texture scaling filter when minimizing and magnifying textures and fonts.(not too pixel-ish)
love.keypressed(key) -  callback function that executes whenever we press a key
love.graphics.newFont(path, size) - path to font file
love.graphics.setFont(font)
love.graphics.newFont
love.graphics.clear(r, g, b, a) - Wipes the entire screen with a color defined 
love.graphics.rectangle(mode, x, y, width, height)
love.graphics.setColor
love.keyboard.isDown(key) - Returns true or false depending on whether the specified key is currently held down
love.event.quit()
]]



WINDOW_WIDTH = love.graphics.getWidth()
WINDOW_HEIGHT = love.graphics.getHeight()

-- speed at which we will move our paddle; multiplied by dt in update
PADDLE_SPEED = 200
 
function love.load()
	love.graphics.setDefaultFilter('nearest', 'nearest')
	
	-- "seed" the RNG so that calls to random are always random
    -- use the current time, since that will vary on startup every time
    math.randomseed(os.time())
    
    -- initialize window with virtual resolution
    love.window.setMode(WINDOW_WIDTH, WINDOW_HEIGHT, {
        fullscreen = false,
        resizable = true,
        vsync = true
    })
    
    -- initialize score variables, used for rendering on the screen and keeping
    -- track of the winner
    player1Score = 0
    player2Score = 0
    
     -- paddle positions on the Y axis (they can only move up or down)
    player1Y = 30
    player2Y = WINDOW_HEIGHT
    
    -- position variables for our ball when play starts
    ballX = WINDOW_WIDTH / 2 - 2
    ballY = WINDOW_HEIGHT / 2 - 2

    -- math.random returns a random value between the left and right number
    -- velocity variables for our ball when play starts
    ballDX = math.random(2) == 1 and 100 or -100
    ballDY = math.random(-50, 50)

    -- game state variable used to transition between different parts of the game
    -- (used for beginning, menus, main game, high score list, etc.)
    -- we will use this to determine behavior during render and update
    gameState = 'start'
end


function love.keypressed(key)
    -- keys can be accessed by string name
    if key == 'escape' then
        -- function LÖVE gives us to terminate application
        love.event.quit()
    elseif key == 'enter' or key == 'return' then
        if gameState == 'start' then
            gameState = 'play'
        else
            gameState = 'start'
            
            -- start ball's position in the middle of the screen
            ballX = WINDOW_WIDTH / 2 - 2
            ballY = WINDOW_HEIGHT / 2 - 2

            -- given ball's x and y velocity a random starting value
            -- the and/or pattern here is Lua's way of accomplishing a ternary operation
            -- in other programming languages like C
            ballDX = math.random(2) == 1 and 100 or -100
            ballDY = math.random(-50, 50) * 1.5
        end
    end
end

--[[
    Runs every frame, with "dt" passed in, our delta in seconds 
    since the last frame, which LÖVE2D supplies us.
]]
function love.update(dt)
    -- player 1 movement
    if love.keyboard.isDown('w') then
        -- add negative paddle speed to current Y scaled by deltaTime
        -- now, we clamp our position between the bounds of the screen
        player1Y = math.max(0, player1Y + -PADDLE_SPEED * dt)
    elseif love.keyboard.isDown('s') then
        -- add positive paddle speed to current Y scaled by deltaTime
        player1Y = math.min(WINDOW_HEIGHT - 20, player1Y + PADDLE_SPEED * dt)
    end

    -- player 2 movement
    if love.keyboard.isDown('up') then
        -- add negative paddle speed to current Y scaled by deltaTime
        player2Y = math.max(50, player2Y + -PADDLE_SPEED * dt)
    elseif love.keyboard.isDown('down') then
        -- add positive paddle speed to current Y scaled by deltaTime
        player2Y = math.min(WINDOW_HEIGHT - 20, player2Y + PADDLE_SPEED * dt)
    end
    
    -- update our ball based on its DX and DY only if we're in play state;
    -- scale the velocity by dt so movement is framerate-independent
    if gameState == 'play' then
        ballX = ballX + ballDX * dt
        ballY = ballY + ballDY * dt
    end
end


function love.draw()

    -- clear the screen with a specific color; in this case, a color similar
    -- to some versions of the original Pong
    love.graphics.clear(40/255, 45/255, 52/255, 1)

 	if gameState == 'start' then
        love.graphics.printf('Hello Start State!', 0, 20, WINDOW_WIDTH, 'center')
    else
        love.graphics.printf('Hello Play State!', 0, 20, WINDOW_WIDTH, 'center')
    end


    --
    -- paddles are simply rectangles we draw on the screen at certain points,
    -- as is the ball
    --

    -- render first paddle (left side)
    love.graphics.rectangle('fill', 10, player1Y, 5, 20)

    -- render second paddle (right side)
    love.graphics.rectangle('fill', WINDOW_WIDTH - 10, player2Y - 50, 5, 20)

    -- render ball (center initially)
    love.graphics.rectangle('fill', ballX, ballY, 4, 4)
    
    -- draw score on the left and right center of the screen
    love.graphics.print(tostring(player1Score), WINDOW_WIDTH / 2 - 50, WINDOW_HEIGHT / 3)
    love.graphics.print(tostring(player2Score), WINDOW_WIDTH / 2 + 30, WINDOW_HEIGHT / 3)
    
end
