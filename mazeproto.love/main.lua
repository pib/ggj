character_lib = require('character')
Character = character_lib.Character

function love.load()
    characters = {Character({color = {255, 0, 0, 255},
                             keys = {'w', 's', 'a', 'd'}}),
                  Character({color = {0, 0, 255, 255},
                             keys = {'up', 'down', 'left', 'right'}})}
end

function love.update(dt)
    for k,v in pairs(characters) do
        v:update()
    end
end

function love.draw()
    local width, height = love.window.getDimensions()

    love.graphics.push()
    love.graphics.translate(width/2.0, height/2.0)
    for k,v in pairs(characters) do
        v:draw()
    end
    love.graphics.pop()
end
