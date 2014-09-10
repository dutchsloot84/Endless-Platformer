--Endless Platformer--------------------------------------------------------------------
--SourceTree Commit Test

-- Hide the status bar 
display.setStatusBar( display.HiddenStatusBar ) 
--Variables for the devices viewable Width and Height
_W = display.viewableContentWidth
_H = display.viewableContentHeight

--CREATE PLAYER SPRITE -----------------------------------------------------------------
local spriteSheet = graphics.newImageSheet("assets/sprites/player.png", {width = 32, height = 32, numFrames = 12})
local sequenceData = {
    {name = "right", sheet = spriteSheet, frames= { 8,9,8,7 }, time = 800, loopCount = 0, loopDirection = "bounce" },
    {name = "left", sheet = spriteSheet, frames= { 5,6,5,4 }, time = 800, loopCount = 0, loopDirection = "bounce" }
}
local player = display.newSprite(spriteSheet, sequenceData)
player:setSequence("right")
player.x = _W/2 ; player.y = _H - 48

--CREATE TILES -----------------------------------------------------------------
--Create a new group to hold all of the blocks
local blocks = display.newGroup()

--setup some variables that we will use to position the ground
local groundMin = _H - 16
--local groundMax = 340
local groundLevel = groundMin
--Loopcount for initial tile creation is based off the width of the device divided
--by the width of each block (34). We add an additional 7 blocks on the right
--to allow the player to move back a maximum of 4 blocks.
local loopCount = math.round((_W/34) + 7)

--This for loop will generate all of the ground pieces based off the width of the screen.
for a = 1, loopCount, 1 do
    isDone = false
    
    --get a random number between 1 and 3, this is what we will use to decide which
    --texture to use for our ground sprites. Doing this will give us random ground
    --pieces so it seems like the ground goes on forever. You can have as many different
    --textures as you want. The more you have the more random it will be, just remember to
    --up the number in math.random(x) to however many textures you have.
    numGen = math.random(3)
    local newBlock
    print (numGen)
    if(numGen == 1 and isDone == false) then
        newBlock = display.newImage("assets/tiles/brick1.png")
        isDone = true
    end
    
    if(numGen == 2 and isDone == false) then
        newBlock = display.newImage("assets/tiles/brick2.png")
        isDone = true
    end
    
    if(numGen == 3 and isDone == false) then
        newBlock = display.newImage("assets/tiles/brick3.png")
        isDone = true
    end
    
    --now that we have the right image for the block we are going
    --to give it some member variables that will help us keep track
    --of each block as well as position them where we want them.
    newBlock.name = ("block" .. a)
    newBlock.id = a
    print(a)
    
    --because a is a variable that is being changed each run we can assign
    --values to the block based on a. In this case we want the x position to
    --be positioned the width of a block apart.
    --Start placing blocks the tile widths off screen
    newBlock.x = (a * 34) - 119
    newBlock.y = groundLevel
    blocks:insert(newBlock)
end

local speed = 1.5
local leftFlag = 0
local moveForward = false
local moveBackward = false
--Update blocks as the player moves left
local function updateLeft()
    for a = 1, blocks.numChildren, 1 do
        moveLeft = true
        if(a < loopCount and moveLeft) then
            newX = (blocks[a + 1]).x - 33
        elseif (a == loopCount and moveLeft) then
            newX = (blocks[1]).x - 33 + speed
        end
        --Update blocks on the left once 4 tile widths have left the screen on the right
        --Stop after replacing 4 tiles because the player can only move back as far
        --as 4 tiles
        if((blocks[a]).x > _W + 102) then
            (blocks[a]).x, (blocks[a]).y = newX, (blocks[a]).y
            leftFlag = leftFlag + 1
            print("Block # " .. leftFlag)
            if(leftFlag > 4) then
                moveBackward = false
            end
        else
            (blocks[a]):translate(speed * 1, 0)
        end
    end
end
--Update blocks as the player moves right
local function updateRight()
    for a = 1, blocks.numChildren, 1 do
        if(a > 1) then
            newX = (blocks[a - 1]).x + 34
        else
            newX = (blocks[loopCount]).x + 34 - speed
        end
        --Update blocks on the right once 3 tile widths have left the screen
        if((blocks[a]).x < -102) then
            (blocks[a]).x, (blocks[a]).y = newX, (blocks[a]).y
            if(leftFlag > 0) then
                leftFlag = leftFlag - 1
                print("Block # " .. leftFlag)  
            end
        else
            (blocks[a]):translate(speed * -1, 0)
        end       
    end
end

--Create Left and Right buttons (left and right side of screen are buttons)
--Left Button
local leftControl = display.newRect( 0, 0, _W/2, _H*2 )
leftControl:setFillColor( 1, 0, 0 )
leftControl.alpha = .25
--Right button
local rightControl = display.newRect( _W, _H, _W/2, _H*-2 )
rightControl:setFillColor( 1, 0, 0 )
rightControl.alpha = .25

local function handleLeftButton( event )
    if ( event.phase == "began" ) then
        -- Move character left and update blocks
        player:setSequence("left")
        player:play()
        moveBackward = true
    elseif ( event.phase == "ended" and moveBackward == false ) then
        -- Stop character and stop updating blocks
        player:pause()
        --moveBackward = false
    end
    return true
end
leftControl:addEventListener( "touch", handleLeftButton )

local function handleEnterFrame( event )
    if ( moveForward == true ) then
        updateRight()
    end
    
    if ( moveBackward == true ) then
        updateLeft()
    end
end
Runtime:addEventListener( "enterFrame", handleEnterFrame )

local function handleRightButton( event )
    if ( event.phase == "began" ) then
        -- Move character right and update blocks
        player:setSequence("right")
        player:play()
        moveForward = true
    elseif ( event.phase == "ended" and moveForward == true ) then
        -- Stop character and stop updating blocks
        player:pause()
        moveForward = false
    end
    return true
end
rightControl:addEventListener( "touch", handleRightButton )


local function gameLoop(event)
    --player:play()
    --updateBlocks() 
end
Runtime:addEventListener("enterFrame", gameLoop)




