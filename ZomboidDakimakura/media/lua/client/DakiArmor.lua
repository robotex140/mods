require "ISUI/ISToolTipInv"

local old_ISToolTipInv_render = ISToolTipInv.render

function ISToolTipInv:render()
    if self.item
    and instanceof( self.item, "Clothing")
    and self.item:getBodyLocation()
    and getPlayer():getWornItem(self.item:getBodyLocation())
    and instanceof( getPlayer():getWornItem(self.item:getBodyLocation()), "InventoryContainer")
    then
        return false 
    end
    old_ISToolTipInv_render(self)
end

local DakimakuraWeapons = require("DakimakuraList")
local OpaiZList = require("OpaiZList")

-- local chanceOfSpawn = 1 -- testing
local chanceOfSpawn = 0.1

--- LIST OF BED SCENE OBJECTS
local function getRandomScene()
    local randomItems = ArrayList.new()
    randomItems:add({type = "Base.Tissue", x=-0.5, y=0.4})
    randomItems:add({type = "Base.Tissue", x=-0.3, y=-0.1})
    randomItems:add({type = "Base." .. OpaiZList:get(ZombRand(OpaiZList:size())), x=0.4, y=0.2})
    randomItems:add({type = "Base.ToiletPaper", x=-0.4, y=0.2})
    return randomItems
end

--- SPAWN A PILLOW
local function spawnRandomPillowOnSquare(square, offsetX, offsetY, height, rotation)
    if not instanceof(square, "IsoGridSquare") then return; end
    if not offsetX then offsetX = 0 end
    if not offsetY then offsetY = 0 end
    if not height then height = 0 end
    if not rotation then rotation = 0 end
    local rand = ZombRand(DakimakuraWeapons:size())
    local item = square:AddWorldInventoryItem("Base." .. DakimakuraWeapons:get(rand), offsetX + 0.00001, offsetY + 0.00001, height)
    if rotation ~= 0 then item:setWorldZRotation(rotation) end
    return item
end

--- SPAWN BED SCENE OBJECTS
local function spawnRandomItemsOnSquare(square, offsetX, offsetY, height)
    local randomItems = getRandomScene()
    if not instanceof(square, "IsoGridSquare") then return; end
    if not offsetX then offsetX = 0 end
    if not offsetY then offsetY = 0 end
    if not height then height = 0 end
    for i=0, randomItems:size()-1 do
        local item = randomItems:get(i)
        square:AddWorldInventoryItem(item.type, item.x + offsetX + 0.00001, item.y + offsetY + 0.00001, height)
    end
end

local function isSquareBed(square)
    if not instanceof(square, "IsoGridSquare") then return; end
    local squareProps = square:getProperties()
    return squareProps:Is(IsoFlagType.bed)
end

local function isObjectGoodBed(object)
    if not instanceof(object, "IsoObject") then return; end
    local objectProps = object:getProperties()
    local bedType = objectProps:Val("BedType")
    return bedType == "goodBed"
end

local function shouldSpawn()
    local chance = ZombRandFloat(0, 1)
    -- print("Chance of scene spawn ", chance .. "/" .. chanceOfSpawn)
    return chance <= chanceOfSpawn 
end

local function distributePillowsOnBeds(room)
    if not room then return; end

    local bedSquares = ArrayList.new()

    local squares = room:getSquares();
    for s=0, squares:size()-1 do
        local square = squares:get(s);
        if isSquareBed(square) then
            local objects = square:getObjects();
            for o=0, objects:size()-1 do
                local object = objects:get(o);
                if isObjectGoodBed(object) then
                    bedSquares:add({square=square, object=object})
                end
            end
        end
    end

    -- Got a double bed
    if bedSquares and bedSquares:size() == 4 then
        local targetSquare = nil
        for b=0, bedSquares:size()-1 do
            local bed = bedSquares:get(b)
            if bed and shouldSpawn() then
                local sprite = bed.object:getSprite()
                local spriteGrid = sprite:getSpriteGrid()
                if spriteGrid and spriteGrid:getSpriteGridPosX(sprite) == 1 and spriteGrid:getSpriteGridPosY(sprite) == 1 then
                    spawnRandomPillowOnSquare(bed.square, 0, 0, 0.33, 115)
                    spawnRandomItemsOnSquare(bed.square, 0, 0, 0.33)
                    print("Dakimakura bed scene spawned!")
                end
            end
        end
    end
end
Events.OnSeeNewRoom.Add(distributePillowsOnBeds);

--- ODD TESTER
local testCount = 0
for i=0, 1000 do
    if shouldSpawn() then testCount = testCount + 1 end
end
print("Dakimakura spawn odd test [" .. testCount .. "/1000 beds]!")

--- DEBUG
-- local function onFillWorldObjectContextMenu(player, context, worldobjects, test)
--     if test then return true end

--     spawnRandomPillowOnSquare(clickedSquare, 0, 0, 0.33, 115)
--     spawnRandomItemsOnSquare(clickedSquare, 0, 0, 0.33)
-- end
-- Events.OnFillWorldObjectContextMenu.Add(onFillWorldObjectContextMenu)
