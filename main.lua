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
love.timer.getFPS()
love.event.quit()
]]


Class = require 'class'
require 'Paddle'
require 'Ball'

WINDOW_WIDTH = love.graphics.getWidth()
WINDOW_HEIGHT = love.graphics.getHeight()

-- speed at which we will move our paddle; multiplied by dt in update
PADDLE_SPEED = 200
 
function love.load()
	-- set the title of our application window
    love.window.setTitle('Pong')
    
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
    
    -- initialize our player paddles; make them global so that they can be
    -- detected by other functions and modules
    player1 = Paddle(10, 30, 5, 20)
    player2 = Paddle(WINDOW_WIDTH - 10, WINDOW_HEIGHT - 30, 5, 20)

    -- place a ball in the middle of the screen
    ball = Ball(WINDOW_WIDTH / 2 - 2, WINDOW_HEIGHT / 2 - 2, 4, 4)

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
            gameState = 'serve'
        elseif gameState == 'serve' then
            gameState = 'play'
        end
    end
end

--[[
    Runs every frame, with "dt" passed in, our delta in seconds 
    since the last frame, which LÖVE2D supplies us.
]]

function love.update(dt)
    if gameState == 'serve' then
        -- before switching to play, initialize ball's velocity based
        -- on player who last scored
        ball.dy = math.random(-50, 50)
        if servingPlayer == 1 then
            ball.dx = math.random(140, 200)
        else
            ball.dx = -math.random(140, 200)
        end
    elseif gameState == 'play' then
        -- detect ball collision with paddles, reversing dx if true and
        -- slightly increasing it, then altering the dy based on the position of collision
        if ball:collides(player1) then
            ball.dx = -ball.dx * 1.03
            ball.x = player1.x + 5

            -- keep velocity going in the same direction, but randomize it
            if ball.dy < 0 then
                ball.dy = -math.random(10, 150)
            else
                ball.dy = math.random(10, 150)
            end
        end
        if ball:collides(player2) then
            ball.dx = -ball.dx * 1.03
            ball.x = player2.x - 4

            -- keep velocity going in the same direction, but randomize it
            if ball.dy < 0 then
                ball.dy = -math.random(10, 150)
            else
                ball.dy = math.random(10, 150)
            end
        end

        -- detect upper and lower screen boundary collision and reverse if collided
        if ball.y <= 0 then
            ball.y = 0
            ball.dy = -ball.dy
        end

        -- -4 to account for the ball's size
        if ball.y >= WINDOW_HEIGHT - 4 then
            ball.y = WINDOW_HEIGHT - 4
            ball.dy = -ball.dy
        end
    end

    -- if we reach the left or right edge of the screen, 
    -- go back to start and update the score
    if ball.x < 0 then
        servingPlayer = 1
        player2Score = player2Score + 1
        ball:reset()
        gameState = 'serve'
    end

    if ball.x > WINDOW_WIDTH then
        servingPlayer = 2
        player1Score = player1Score + 1
        ball:reset()
        gameState = 'serve'
    end

    -- player 1 movement
    if love.keyboard.isDown('w') then
        player1.dy = -PADDLE_SPEED
    elseif love.keyboard.isDown('s') then
        player1.dy = PADDLE_SPEED
    else
        player1.dy = 0
    end

    -- player 2 movement
    if love.keyboard.isDown('up') then
        player2.dy = -PADDLE_SPEED
    elseif love.keyboard.isDown('down') then
        player2.dy = PADDLE_SPEED
    else
        player2.dy = 0
    end

    -- update our ball based on its DX and DY only if we're in play state;
    -- scale the velocity by dt so movement is framerate-independent
    if gameState == 'play' then
        ball:update(dt)
    end

    player1:update(dt)
    player2:update(dt)
end


function love.draw()

    -- clear the screen with a specific color; in this case, a color similar
    -- to some versions of the original Pong
    love.graphics.clear(40/255, 45/255, 52/255, 1)
	
	love.graphics.setColor(1, 1, 1, 1)
	
 	if gameState == 'start' then
        love.graphics.printf('Welcome to Pong!', 0, 10, WINDOW_WIDTH, 'center')
        love.graphics.printf('Press Enter to begin!', 0, 20, WINDOW_WIDTH, 'center')
    elseif gameState == 'serve' then
        love.graphics.printf('Player ' .. tostring(servingPlayer) .. "'s serve!", 
            0, 10, WINDOW_WIDTH, 'center')
        love.graphics.printf('Press Enter to serve!', 0, 20, WINDOW_WIDTH, 'center')
    elseif gameState == 'play' then
    end
    -- render paddles, now using their class's render method
    player1:render()
    player2:render()

    -- render ball using its class's render method
    ball:render()
    
   
    displayFPS()
    displayScore()
    
end

function displayFPS()
    -- simple FPS display across all states
    -- .. is string concatenation
    love.graphics.setColor(0, 1, 0, 1)
    love.graphics.print('FPS: ' .. tostring(love.timer.getFPS()), 10, 10)
end

function displayScore()
    -- draw score on the left and right center of the screen
    -- need to switch font to draw before actually printing
    love.graphics.print(tostring(player1Score), WINDOW_WIDTH / 2 - 50, 
        WINDOW_HEIGHT / 3)
    love.graphics.print(tostring(player2Score), WINDOW_WIDTH / 2 + 30,
        WINDOW_HEIGHT / 3)
end