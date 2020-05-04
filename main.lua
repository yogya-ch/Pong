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

love.event.quit()
]]



WINDOW_WIDTH = love.graphics.getWidth()
WINDOW_HEIGHT = love.graphics.getHeight()

 
function love.load()
	love.graphics.setDefaultFilter('nearest', 'nearest')
	
    -- initialize window with virtual resolution
    love.window.setMode(WINDOW_WIDTH, WINDOW_HEIGHT, {
        fullscreen = false,
        resizable = true,
        vsync = true
    })
end

function love.draw()

    -- clear the screen with a specific color; in this case, a color similar
    -- to some versions of the original Pong
    love.graphics.clear(40/255, 45/255, 52/255, 1)

    -- draw welcome text toward the top of the screen
    love.graphics.printf('Hello Pong!', 0, 20, WINDOW_WIDTH, 'center')

    --
    -- paddles are simply rectangles we draw on the screen at certain points,
    -- as is the ball
    --

    -- render first paddle (left side)
    love.graphics.rectangle('fill', 10, 30, 5, 20)

    -- render second paddle (right side)
    love.graphics.rectangle('fill', WINDOW_WIDTH - 10, WINDOW_HEIGHT - 50, 5, 20)

    -- render ball (center)
    love.graphics.rectangle('fill', WINDOW_WIDTH / 2 - 2, WINDOW_HEIGHT / 2 - 2, 4, 4)

end

function love.keypressed(key)
    -- keys can be accessed by string name
    if key == 'escape' then
        -- function LÖVE gives us to terminate application
        love.event.quit()
    end
end