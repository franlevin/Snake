map1 = {
  {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0},
  {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0},
  {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0},
  {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0},
  {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0},
  {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0},
  {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0},
  {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0},
  {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0},
  {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0},
  {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0},
  {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0},
  segmentSize = 30,
  tall = 12,
  wide = 12,
  border = 1 -- 0 or 1 for wall
}

local fruits = {}
local fruitSpeed = 350
local fruitFrame = 0
local currentMap = map1
local mapColor = "Green"

function fruitUpdate(dt, snakeBody)
  if fruitFrame == fruitSpeed then
    fruitFrame = 0
  end

  if gameState == "Play" and fruitFrame == 0 then
    spawnFruit(snakeBody)
  end

  fruitFrame = fruitFrame + 1
end

function spawnFruit(snakeBody)
  taken = 1
  randX = 0
  randY = 0

  while taken == 1 do
    randX = math.random(map.wide) * map.segmentSize
    randY = math.random(map.tall) * map.segmentSize
    for i, chunk in ipairs(snakeBody) do
      if randX ~= chunk.x or randY ~= chunk.y then
        taken = 0
      end
    end
  end

  table.insert(fruits, {x = randX, y = randY})
end

function getCurrentMap()
  return currentMap
end

function getFruits()
  return fruits
end

function setBorder(x)
  map1.border = x
end


function removeFruit(fruit)
  table.remove(fruits, fruit)
end

function resetFruits()
  fruitFrame = 0
  for i = #fruits, 1, -1 do
    table.remove(fruits, i)
  end
end
