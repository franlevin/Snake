require "menu"
require "snake"
require "map"


function love.load(arg)

  map = getCurrentMap()

  colors = {"Green", "Yellow", "Purple", "Red", "White"}
  colorSelected = 1

  difficulty = { --NOT YET IMPLEMENTED
    {60, 1000}, --difficulty[1] VERY EASY
    {30, 500}, --difficulty[2] EASY
    {20, 350}, --difficulty[3] MEDIUM
    {10, 175}, --difficulty[4] HARD
    {4, 75} --difficulty[5] VERY HARD
  } -- First index of subtable is snake speed, second index is fruit spawn speed

  config = {mapSize, mapBorder, difficulty, snakeColor}

  WINDOW_WIDTH = 1280
  WINDOW_HEIGHT = 720

  love.window.setMode(WINDOW_WIDTH, WINDOW_HEIGHT, {
    fullscreen = true,
    vsync = true,
    resizable = false
  })

  love.graphics.setDefaultFilter("nearest", "nearest")

  myFont = love.graphics.setNewFont(20)
  snakeFrame = 0
  won = 0
  score = 0
  maxScore = map.tall * map.wide - getSnakeLength()
  --screenWidth = love.graphics.getWidth()
  --screenHeight = love.graphics.getHeight()
  screenWidth, screenHeight = love.graphics.getDimensions()
  currentScreen = "Menu"
  gameState = "Play"
  currentMenu = "Main"

end


function love.update(dt)
  if currentScreen == "Game" then
    snakeUpdate(dt)
    fruitUpdate(dt, getSnakeBody())
  end
end


function love.draw()
  if currentScreen == "Game" then
    -- Draw Score
    --love.graphics.printf("SCORE", 100, 0, screenWidth, "center")
    love.graphics.print("SCORE: ", 100, 0)
    love.graphics.print(score, 230, 0)

    -- Draw Fruits
    love.graphics.setColor(0.99, 0, 0)
    for i, fruit in ipairs(fruits) do
      love.graphics.circle("fill", fruit.x + map.segmentSize / 2, fruit.y + map.segmentSize / 2, map.segmentSize / 2 , 64)
    end

    -- Draw Snake
    drawSnake()

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

    if gameState == "End" and won == 0 then
      --myFont = love.graphics.newFont(300)
      love.graphics.print("YOU LOST", 450, 300)
      love.graphics.print("Press R to restart", 450, 350)
    end

    if won == 1 then
      love.graphics.print("YOU FUCKING WON THE GAME", 550, 300)
      love.graphics.print("Press R to restart", 550, 350)
    end
  end

  if currentScreen == "Menu" then
    if currentMenu == "Main" then drawMain()
    elseif currentMenu == "Game Settings" then drawGameSettings()
    elseif currentMenu == "Highscores" then drawHighScores()
    elseif currentMenu == "How To Play" then drawHowToPlay()
    elseif currentMenu == "Settings" then drawSettings()
    end
  end
end

function love.keypressed(key, scancode, isrepeat)


  if currentScreen == "Menu" then
    if currentMenu == "Main" then
      mainKeys(key)
    elseif currentMenu == "Game Settings" then
      gameSettingsKeys(key)
    elseif currentMenu == "Highscores" then
      highScoreKeys(key)
    elseif currentMenu == "How To Play" then
      howToPlayKeys(key)
    elseif currentMenu == "Settings" then
      settingsKeys(key)
    end
  end


  if gameState == "Play" then

    snakeKeys(key)

    if key == 'r' then
      resetGame()
      --resetGame()
    end

    if key == 'escape' then
      currentScreen = "Menu"
      --funcion de restarteo
    end
  end
end

function resetGame()
  resetSnake()
  resetFruits()
  won = 0
  score = 0
  playerState = "Alive"
end

function applyGameConfig(mapBorder, snakeColor)
  setBorder(mapBorder)
  setSnakeColor(snakeColor)
end

function changeColor(color)
  if color == "Green" then love.graphics.setColor(0.23, 0.58, 0.32)
  elseif color == "Yellow" then love.graphics.setColor(1, 1, 0, 20)
  elseif color == "Purple" then love.graphics.setColor(0.50, 0.25, 0.75)
  elseif color == "Red" then love.graphics.setColor(0.99, 0, 0)
  else love.graphics.setColor(1, 1, 1)
  end
end
