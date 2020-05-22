require "map"

local snake = {
  body = {
    {x = 30*6, y = 30*6, direction = 1, lastDirection = 1, id = "head"},
    {x = 30*5, y = 30*6, direction = 1, lastDirection = 1, id = "body"},
    {x = 30*4, y = 30*6, direction = 1, lastDirection = 1, id = "body"},
    {x = 30*3, y = 30*6, direction = 1, lastDirection = 1, id = "body"}
  },
  growthQueue = {},
  isAlive = 1,
  height = 30,
  width = 30,
  speed = 10, -- 59/60 very easy, 30 easy, 20 medium, 10 hard, 4 very hard
  hasMoved = 0,
  currentColor = "Green"
}

function snakeUpdate(dt)
  if snakeFrame == snake.speed then
    snakeFrame = 0
  end



  if snake.isAlive == 1 and snakeFrame == 0 then
    snakeMovement()
    endGameCondition()
    updateSpawnDelay()
    fruitColission()
    updateDirections()
  end

  if score == maxScore then
    won = 1
    snake.isAlive = 0
  end

  snakeFrame = snakeFrame + 1
end

function drawSnake()
  --love.graphics.setColor(0.23, 0.58, 0.32)
  changeColor(snake.color)
  for i, chunk in ipairs(snake.body) do
    love.graphics.rectangle("fill", chunk.x, chunk.y, snake.height, snake.width)
  end
end

function snakeKeys(key)
  if snake.isAlive == 1 and snake.hasMoved == 0 then

    if key == 'w' or key == 'up' then
      if snake.body[1].direction ~= 2 then
        snake.body[1].direction = 4
        snake.hasMoved = 1
      end
    end

    if key == 's' or key == 'down' then
      if snake.body[1].direction ~= 4 then
        snake.body[1].direction = 2
        snake.hasMoved = 1
      end
    end

    if key == 'a' or key == 'left' then
      if snake.body[1].direction ~= 1 then
        snake.body[1].direction = 3
        snake.hasMoved = 1
      end
    end

    if key == 'd' or key == 'right' then
      if snake.body[1].direction ~= 3 then
        snake.body[1].direction = 1
        snake.hasMoved = 1
      end
    end
  end
end

function snakeMovement()
  for i, chunk in ipairs(snake.body) do
    chunk.lastX = chunk.x
    chunk.lastY = chunk.y

    if chunk.direction == 1 then
      if chunk.x == map.wide * map.segmentSize and map.border == 0 then
        chunk.x = map.segmentSize
      else
        chunk.x = chunk.x + map.segmentSize
      end

    elseif chunk.direction == 2 then
      if chunk.y == map.tall * map.segmentSize and map.border == 0 then
        chunk.y = map.segmentSize
      else
        chunk.y = chunk.y + map.segmentSize
      end

    elseif chunk.direction == 3 then
      if chunk.x == map.segmentSize and map.border == 0 then
        chunk.x = map.wide * map.segmentSize
      else
        chunk.x = chunk.x - map.segmentSize
      end

    elseif chunk.direction == 4 then
      if chunk.y == map.segmentSize and map.border == 0 then
        chunk.y = map.tall * map.segmentSize
      else
        chunk.y = chunk.y - map.segmentSize
      end
    end
  end
  snake.hasMoved = 0
end

function growSnake(posX, posY)
  lastChunk = snake.body[#snake.body]
  chunk = {x = posX, y = posY, id = "body"}
  chunk.direction = lastChunk.lastDirection
  table.insert(snake.body, chunk)
end

function updateDirections()
  for i = #snake.body, 2, -1 do
    snake.body[i].lastDirection = snake.body[i].direction
    snake.body[i].direction = snake.body[i-1].direction
  end
end

function updateSpawnDelay()
  if #snake.growthQueue ~= 0 then
    for i, newChunk in ipairs(snake.growthQueue) do
      if newChunk.spawnDelay == 0 then
        growSnake(newChunk.x, newChunk.y)
        table.remove(snake.growthQueue, 1)
      else
        newChunk.spawnDelay = newChunk.spawnDelay - 1
      end
    end
  end
end

function fruitColission()
  fruits = getFruits()
  head = snake.body[1]
  for f, fruit in ipairs(fruits) do
    if fruit.x == head.x and fruit.y == head.y then
      newChunk = {spawnDelay = #snake.body - 1, x = head.x, y = head.y}
      table.insert(snake.growthQueue, newChunk)
      removeFruit(f)
      score = score + 1
    end
  end
end

function endGameCondition()
  head = snake.body[1]

  -- Head colission against own body
  for i, chunk in ipairs(snake.body) do
    if chunk.lastX == head.x and chunk.lastY == head.y then
      snake.isAlive = 0
      gameState = "End"
    end
  end

  -- Head colission against map edge if border == 1
  if map.border == 1 then
    if head.x > map.wide * map.segmentSize then
      snake.isAlive = 0
      gameState = "End"
    elseif head.x < map.segmentSize then
      snake.isAlive = 0
      gameState = "End"
    elseif head.y > map.tall * map.segmentSize then
      snake.isAlive = 0
      gameState = "End"
    elseif head.y < map.segmentSize then
      snake.isAlive = 0
      gameState = "End"
    end
  end

  -- Move snake to last position if dead so it draws properly
  if snake.isAlive == 0 then
    for i, chunk in ipairs(snake.body) do
      chunk.x = chunk.lastX
      chunk.y = chunk.lastY
    end
  end
end

function resetSnake()
  snake.body = {
    {x = 30*6, y = 30*6, direction = 1, lastDirection = 1, id = "head"},
    {x = 30*5, y = 30*6, direction = 1, lastDirection = 1, id = "body"},
    {x = 30*4, y = 30*6, direction = 1, lastDirection = 1, id = "body"},
    {x = 30*3, y = 30*6, direction = 1, lastDirection = 1, id = "body"}
  }
  snake.isAlive = 1
  snake.hasMoved = 0
end

function getSnakeLength()
  return #snake.body
end

function getSnakeBody()
  return snake.body
end

function setSnakeColor(color)
  snake.color = color
end
