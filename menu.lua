--local windowWidth
--local windowHeight
local menus = {"Main", "Game Settings", "How To Play", "Settings"}
local mainItems = {
  items = {"Play", "Highscores", "How To Play", "Settings", "Quit"},
  itemAmount = 5,
  itemSelected = 1
}
local gameSettingsItems = {
  items = {"Ready", "Map Size", "Map Border", "Difficulty", "Snake Color", "Back"},
  button1Selected = 0,
  button2Selected = 0,
  itemAmount = 6,
  itemSelected = 1,
  colors = {"Green", "Yellow", "Purple", "Red", "White"},

  snakeColorSelected = 1,
  mapBorder = 0,
  mapColorSelected = 1,
  difficultySelected = 1,

}

function drawTitle()
  local font = love.graphics.setNewFont(80)
  local fontHeight = font:getHeight()
  love.graphics.setColor(1, 1, 1)
  love.graphics.print("Snake", 10, 10)

  local font = love.graphics.setNewFont(15)
  love.graphics.print("by francis", 15, fontHeight + 5)
end

function drawMain()
  drawTitle()
  local itemAmount = mainItems.itemAmount
  local itemSelected = mainItems.itemSelected
  local font = love.graphics.setNewFont(30)
  local fontHeight = font:getHeight()

  love.graphics.setBackgroundColor(0, 0, 0, 0) --test line
  love.graphics.setColor(1, 1, 1)

  local itemStartY = (screenHeight / 3) - fontHeight
  local itemSeparation = (screenHeight - itemStartY - (fontHeight * itemAmount + fontHeight * 4)) / itemAmount

  love.graphics.rectangle("fill", (screenWidth / 2) - 20, itemStartY, 10, fontHeight * itemAmount + itemSeparation * (itemAmount - 1))

  --Print Items
  for i = 1, #mainItems.items do
    if i == mainItems.itemSelected then
      love.graphics.setColor(1, 1, 0, 20)
    else
        love.graphics.setColor(0.50, 0.25, 0.75)
    end
    love.graphics.printf(mainItems.items[i], screenWidth / 2, itemStartY + ((fontHeight + itemSeparation) * (i - 1)), screenWidth, "left")
  end
end

function drawGameSettings()
  drawTitle()
  local itemAmount = gameSettingsItems.itemAmount
  local itemSelected = gameSettingsItems.itemSelected
  local font = love.graphics.setNewFont(30)
  local fontHeight = font:getHeight()

  local itemStartY = (screenHeight / 3) - fontHeight
  local itemSeparation = (screenHeight - itemStartY - (fontHeight * itemAmount + fontHeight * 4)) / itemAmount
  local rectangleHeight = fontHeight * itemAmount + itemSeparation * (itemAmount - 1)

  love.graphics.rectangle("fill", (screenWidth / 2) - 20, itemStartY, 10, rectangleHeight)

  --Print Items
  for i = 1, #gameSettingsItems.items do
    if i == gameSettingsItems.itemSelected then
      love.graphics.setColor(1, 1, 0, 20)
    else
      love.graphics.setColor(0.50, 0.25, 0.75)
    end

    local itemY = itemStartY + ((fontHeight + itemSeparation) * (i - 1))
    love.graphics.printf(gameSettingsItems.items[i], screenWidth / 2, itemY, screenWidth, "left")

    -- Draw selection arrows
    love.graphics.setColor(0.50, 0.25, 0.75)

    if i ~= 1 and i ~= #gameSettingsItems.items then
      -- Right arrow
      if i == gameSettingsItems.itemSelected then
        buttonColorControl(gameSettingsItems, 1)
      end
      love.graphics.polygon("fill",
       (screenWidth / 2) - 40, itemY + (fontHeight / 2),
        (screenWidth / 2) - 60, itemY + 5,
        (screenWidth / 2) - 60, itemY + fontHeight - 5)

      -- Left arrow
      if i == gameSettingsItems.itemSelected then
        buttonColorControl(gameSettingsItems, 2)
      end
      love.graphics.polygon("fill",
       (screenWidth / 2) - 130, itemY + (fontHeight / 2),
        (screenWidth / 2) - 110, itemY + 5,
        (screenWidth / 2) - 110, itemY + fontHeight - 5)
    end

    --love.graphics.rectangle("fill", (screenWidth / 2) - 40, itemStartY + ((fontHeight + itemSeparation) * (i - 1)) + (fontHeight / 3), 10, 10)

  end
end

function drawHighScores()
  local font = love.graphics.setNewFont(20)
  local fontHeight = font:getHeight()
  love.graphics.setColor(1, 1, 1)
  love.graphics.printf("This is the Highscores menu", 0, (screenHeight / 2) - fontHeight, screenWidth, "center")
  love.graphics.printf("Press 'ESC' to return to the main menu", 0, (screenHeight / 2) + (fontHeight / 2), screenWidth, "center")
end

function drawHowToPlay()
  local font = love.graphics.setNewFont(20)
  local fontHeight = font:getHeight()
  love.graphics.setColor(1, 1, 1)
  love.graphics.printf("This is the How To Play menu", 0, (screenHeight / 2) - fontHeight, screenWidth, "center")
  love.graphics.printf("Press 'ESC' to return to the main menu", 0, (screenHeight / 2) + (fontHeight / 2), screenWidth, "center")
end

function drawSettings()
  local font = love.graphics.setNewFont(20)
  local fontHeight = font:getHeight()
  love.graphics.setColor(1, 1, 1)
  love.graphics.printf("This is the Settings menu", 0, (screenHeight / 2) - fontHeight, screenWidth, "center")
  love.graphics.printf("Press 'ESC' to return to the main menu", 0, (screenHeight / 2) + (fontHeight / 2), screenWidth, "center")

end



function mainKeys(key)
  items = mainItems.items
  itemSelected = mainItems.itemSelected

  --ESCAPE
  if key == 'escape' then
    love.event.quit(exitstatus)
  end

  --UP OR W
  if key == 'up' or key == 'w' then
    if itemSelected == 1 then
      mainItems.itemSelected = mainItems.itemAmount
    else
      mainItems.itemSelected = itemSelected - 1
    end
  end

  --DOWN OR S
  if key == 'down' or key == 's' then
    if itemSelected == mainItems.itemAmount then
      mainItems.itemSelected = 1
    else
      mainItems.itemSelected = itemSelected + 1
    end
  end

  --ENTER/RETURN
  if key == 'return' then
    if items[itemSelected] == "Play" then
      currentMenu = "Game Settings"
      gameSettingsItems.itemSelected = 1
    elseif items[itemSelected] == "Highscores" then
      currentMenu = "Highscores"
      --highScoreItems.itemSelected = 1
    elseif items[itemSelected] == "How To Play" then
      currentMenu = "How To Play"
      --howToPlayItems.itemSelected = 1
    elseif items[itemSelected] == "Settings" then
      currentMenu = "Settings"
      --settingsItems.itemSelected = 1
    elseif items[itemSelected] == "Quit" then
      love.event.quit(exitstatus)
    end
  end
end

function gameSettingsKeys(key)
  items = gameSettingsItems.items
  itemSelected = gameSettingsItems.itemSelected

  --ESCAPE
  if key == 'escape' then
    currentMenu = "Main"
  end

  --UP OR W
  if key == 'up' or key == 'w' then
    if itemSelected == 1 then
      gameSettingsItems.itemSelected = gameSettingsItems.itemAmount
    else
      gameSettingsItems.itemSelected = itemSelected - 1
    end
  end

  --DOWN OR S
  if key == 'down' or key == 's' then
    if itemSelected == gameSettingsItems.itemAmount then
      gameSettingsItems.itemSelected = 1
    else
      gameSettingsItems.itemSelected = itemSelected + 1
    end
  end

  if key == 'left' or key == 'a' then
    gameSettingsItems.button2Selected = 1

  end

  if key == 'right' or key == 'd' then
    gameSettingsItems.button1Selected = 1
  end

  --ENTER/RETURN
  if key == 'return' then
    if items[itemSelected] == "Ready" then
      --applyGameConfig()
      currentScreen = "Game"
      gameSettingsItems.itemSelected = 1
    elseif items[itemSelected] == "Map Size" then
      --map size
    elseif items[itemSelected] == "Map Border" then
      --map border
    elseif items[itemSelected] == "Difficulty" then
      --difficulty
    elseif items[itemSelected] == "Snake Color" then
      --snake color
    elseif items[itemSelected] == "Back" then
      currentMenu = "Main"
    end
  end
end

function highScoreKeys(key)
  --ESCAPE
  if key == 'escape' then
    currentMenu = "Main"
  end
end

function howToPlayKeys(key)
  --ESCAPE
  if key == 'escape' then
    currentMenu = "Main"
  end
end

function settingsKeys(key)
  --ESCAPE
  if key == 'escape' then
    currentMenu = "Main"
  end
end

function buttonColorControl(table, button)
  if button == 1 then
    if table.button1Selected > 0 then
      love.graphics.setColor(1, 1, 0, 20)
      table.button1Selected = table.button1Selected - 1
    else love.graphics.setColor(0.50, 0.25, 0.75) end

  elseif button == 2 then
    if table.button2Selected > 0 then
      love.graphics.setColor(1, 1, 0, 20)
      table.button2Selected = table.button2Selected - 1
    else love.graphics.setColor(0.50, 0.25, 0.75) end
  end
end

function changeGameSettings(direction)
  --if gameSettingsItems.items[gameSettingsItems.itemSelected] == "Map Size" then

  if gameSettingsItems.items[gameSettingsItems.itemSelected] == "Map Border" then
    if gameSettingsItems.mapBorder == 1 then gameSettingsItems.mapBorder = 0
    else gameSettingsItems.mapBorder = 1 end


  --elseif gameSettingsItems.items[gameSettingsItems.itemSelected] == "Difficulty" then

  elseif gameSettingsItems.items[gameSettingsItems.itemSelected] == "Snake Color" then
    if direction == "left" then
      if gameSettingsItems.snakeColorSelected == 1 then
        gameSettingsItems.snakeColorSelected = #gameSettingsItems.colors
      else
        gameSettingsItems.snakeColorSelected = gameSettingsItems.snakeColorSelected - 1
      end
    else -- Direction == "Right"
      if gameSettingsItems.snakeColorSelected == #gameSettingsItems.colors then
        gameSettingsItems.snakeColorSelected = 1
      else
        gameSettingsItems.snakeColorSelected = gameSettingsItems.snakeColorSelected + 1
      end
    end
  end
end
