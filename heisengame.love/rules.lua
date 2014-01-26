local utils = require("utils")

-- Special map tiles
local objectLayerData = {
    {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0},
    {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0},
    {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0},
    {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0},
    {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0},
    {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0},
    {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0},
    {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0},
    {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0},
    {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0},
    {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0},
    {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0},
    {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0},
    {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0},
    {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0}
}


local rules = {}

-- Some constants that outside code might need.
rules.minAngle = (-math.pi/6.0)
rules.maxAngle = (math.pi/6.0)
rules.sightDistance = 300

-- Private functions
local function canSee(char1, char2)
    -- Return true if char1 can see char2
    local xTowards = char2.x - char1.x
    local yTowards = char2.y - char1.y
    local dist = utils.length(xTowards, yTowards)
    local angle = math.atan2(utils.normalize(yTowards, xTowards))
    local angleDiff = utils.clampAngle(math.abs(angle-char1.facing))

    return (dist <= rules.sightDistance and angleDiff <= rules.maxAngle
            and angleDiff >= rules.minAngle)
end

-- The Ruler class
rules.Ruler = {}
rules.Ruler.__index = rules.Ruler

setmetatable(rules.Ruler, {
    __call = function (cls, ...) return cls.new(...) end
})

function rules.Ruler.new(tab)
    local self = setmetatable({}, rules.Ruler)
    self.characters = tab.characters
    self.map = tab.map
    self.gameWon = false

    self.map:addCustomLayer("Specials", 3)
    self.map.layers["Specials"].data = objectLayerData

    return self
end

function rules.Ruler:update(dt)
    local specials = self.map.layers["Specials"]
    local goals = 0
    for i, chr in pairs(self.characters) do
        local tx, ty = utils.screenToTileCoordinate(chr.x, chr.y)
        if ty > 0 and ty < utils.tilesHeight and tx > 0 and tx < utils.tilesWidth then
            if specials.data[ty][tx] ~= nil and specials.data[ty][tx] == 1 then
                goals = goals + 1
            end
        end
    end

    if goals == #self.characters then
        self.gameWon = true
    end
end

return rules
