function love.load(arg)

  map = {
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
    border = 0 -- 0 or 1 for wall
  }

  difficulty = { --NOT YET IMPLEMENTED
    {60, 1000}, --difficulty[1] VERY EASY
    {30, 500}, --difficulty[2] EASY
    {20, 350}, --difficulty[3] MEDIUM
    {10, 175}, --difficulty[4] HARD
    {4, 75} --difficulty[5] VERY HARD
  } -- First index of subtable is snake speed, second index is fruit spawn speed

  fruits = {}
  fruitSpeed = 350

  snake = {
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
    hasMoved = 0
  }

  --[[growSnake()
  growSnake()
  growSnake()
  growSnake()]]

  myFont = love.graphics.setNewFont(30)
  snakeFrame = 0
  fruitFrame = 0
  won = 0
  score = 0
  maxScore = map.tall * map.wide - #snake.body
  screenWidth = love.graphics.getWidth()
  screenHeight = love.graphics.getHeight()

end


function love.update(dt)

  if snakeFrame == snake.speed then
    snakeFrame = 0
  end

  if fruitFrame == fruitSpeed then
    fruitFrame = 0
  end

  if snake.isAlive == 1 and fruitFrame == 0 then
    spawnFruit()
  end

  if snake.isAlive == 1 and snakeFrame == 0 then
    snakeMovement()
    endGameCondition()
    fruitColission()
    updateDirections()
  end

  if score == maxScore then
    won = 1
    snake.isAlive = 0
  end

  snakeFrame = snakeFrame + 1
  fruitFrame = fruitFrame + 1

end


function love.draw()

  -- Draw Score
  love.graphics.printf("SCORE", 100, 0, screenWidth, "center")
  --love.graphics.print("SCORE: ", 100, 0)
  love.graphics.print(score, 150, 0)

  -- Draw Fruits
  love.graphics.setColor(0.99, 0, 0)
  for i, fruit in ipairs(fruits) do
    love.graphics.circle("fill", fruit.x + map.segmentSize / 2, fruit.y + map.segmentSize / 2, map.segmentSize / 2 , 64)
  end

  -- Draw Snake
  love.graphics.setColor(0.23, 0.58, 0.32)
  for i, chunk in ipairs(snake.body) do
    love.graphics.rectangle("fill", chunk.x, chunk.y, snake.height, snake.width)
  end

  -- Draw Map
  for y = 1, #map do
    for x = 1, #map[y] do
      if map[y][x] == 1 then
        love.graphics.rectangle('fill', x * map.segmentSize, y * map.segmentSize, map.segmentSize, map.segmentSize)
      else
        love.graphics.rectangle('line', x * map.segmentSize, y * map.segmentSize, map.segmentSize, map.segmentSize)
      end
    end
  end

  if snake.isAlive == 0 and won == 0 then
    --myFont = love.graphics.newFont(300)
    love.graphics.print("YOU LOST", 550, 300)
    love.graphics.print("Press R to restart", 550, 350)
  end

  if won == 1 then
    love.graphics.print("YOU FUCKING WON THE GAME", 550, 300)
    love.graphics.print("Press R to restart", 550, 350)
  end

end

function love.keypressed(key, scancode, isrepeat)

  if key == 'escape' then
    love.event.quit(exitstatus)
  end

  if key == 'r' then
    love.load()
    --resetGame()
  end

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

--[[function resetGame()
  snake.x = 200
  snake.y = 300
  snake.direction = 1
  snake.isAlive = 1
end]] --ARREGLAAAAAAAAAAAAAR

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

--[[function snakeMovement()
  for i, chunk in ipairs(snake.body) do
    chunk.lastX = chunk.x
    chunk.lastY = chunk.y
    if chunk.direction == 1 then chunk.x = chunk.x + map.segmentSize
    elseif chunk.direction == 2 then chunk.y = chunk.y + map.segmentSize
    elseif chunk.direction == 3 then chunk.x = chunk.x - map.segmentSize
    elseif chunk.direction == 4 then chunk.y = chunk.y - map.segmentSize
    end
  end
  snake.hasMoved = 0
end ]]

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

function spawnFruit()
  taken = 1
  randX = 0
  randY = 0

  while taken == 1 do
    randX = math.random(map.wide) * map.segmentSize
    randY = math.random(map.tall) * map.segmentSize
    for i, chunk in ipairs(snake.body) do
      if randX ~= chunk.x or randY ~= chunk.y then
        taken = 0
      end
    end
  end

  table.insert(fruits, {x = randX, y = randY})
end

function fruitColission()
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

  head = snake.body[1]
  for f, fruit in ipairs(fruits) do
    if fruit.x == head.x and fruit.y == head.y then
      newChunk = {spawnDelay = #snake.body - 1, x = head.x, y = head.y}
      table.insert(snake.growthQueue, newChunk)
      table.remove(fruits, f)
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
    end
  end

  -- Head colission against map edge if border == 1
  if map.border == 1 then
    if head.x > map.wide * map.segmentSize then
      snake.isAlive = 0
    elseif head.x < map.segmentSize then
      snake.isAlive = 0
    elseif head.y > map.tall * map.segmentSize then
      snake.isAlive = 0
    elseif head.y < map.segmentSize then
      snake.isAlive = 0
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
