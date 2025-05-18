-- Retro GUI Executor by OMEGA_LAKI

local player = game.Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

local screenGui = Instance.new("ScreenGui")
screenGui.Name = "RetroExecutorGUI"
screenGui.ResetOnSpawn = false
screenGui.Parent = playerGui

-- Кнопка ☰
local toggleButton = Instance.new("TextButton")
toggleButton.Size = UDim2.new(0, 100, 0, 40)
toggleButton.Position = UDim2.new(0, 10, 0, 10)
toggleButton.Text = "☰"
toggleButton.Font = Enum.Font.Arcade
toggleButton.TextSize = 30
toggleButton.TextColor3 = Color3.fromRGB(0, 255, 0)
toggleButton.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
toggleButton.BorderSizePixel = 2
toggleButton.Parent = screenGui

-- Главное окно
local mainFrame = Instance.new("Frame")
mainFrame.Size = UDim2.new(0, 400, 0, 300)
mainFrame.Position = UDim2.new(0, 10, 0, 60)
mainFrame.BackgroundColor3 = Color3.fromRGB(10, 10, 10)
mainFrame.BorderColor3 = Color3.fromRGB(0, 255, 0)
mainFrame.BorderSizePixel = 3
mainFrame.Visible = false
mainFrame.Parent = screenGui

-- Заголовок
local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, -20, 0, 40)
title.Position = UDim2.new(0, 10, 0, 10)
title.BackgroundTransparency = 1
title.Text = "Retro Executor"
title.Font = Enum.Font.Arcade
title.TextSize = 36
title.TextColor3 = Color3.fromRGB(0, 255, 0)
title.TextStrokeColor3 = Color3.new(0, 0.5, 0)
title.TextStrokeTransparency = 0
title.Parent = mainFrame

-- Подпись
local authorLabel = Instance.new("TextLabel")
authorLabel.Size = UDim2.new(1, -20, 0, 20)
authorLabel.Position = UDim2.new(0, 10, 0, 45)
authorLabel.BackgroundTransparency = 1
authorLabel.Text = "By OMEGA_LAKI"
authorLabel.Font = Enum.Font.Arcade
authorLabel.TextSize = 18
authorLabel.TextColor3 = Color3.fromRGB(0, 255, 0)
authorLabel.TextXAlignment = Enum.TextXAlignment.Left
authorLabel.Parent = mainFrame

-- Поле ввода
local scriptBox = Instance.new("TextBox")
scriptBox.MultiLine = true
scriptBox.ClearTextOnFocus = false
scriptBox.Size = UDim2.new(1, -20, 1, -110)
scriptBox.Position = UDim2.new(0, 10, 0, 70)
scriptBox.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
scriptBox.TextColor3 = Color3.fromRGB(0, 255, 0)
scriptBox.Font = Enum.Font.Code
scriptBox.TextSize = 18
scriptBox.TextWrapped = true
scriptBox.TextXAlignment = Enum.TextXAlignment.Left
scriptBox.TextYAlignment = Enum.TextYAlignment.Top
scriptBox.BorderColor3 = Color3.fromRGB(0, 255, 0)
scriptBox.Text = "-- Вставь скрипт или ссылку сюда"
scriptBox.Parent = mainFrame

-- Выполнение Lua-кода
local function executeScript(code)
    local func, err = loadstring(code)
    if not func then
        warn("Ошибка компиляции:", err)
        return
    end
    local success, runErr = pcall(func)
    if not success then
        warn("Ошибка выполнения:", runErr)
    end
end

-- Загрузка с URL
local function loadScriptFromUrl(url)
    local success, response = pcall(function()
        return game:HttpGet(url)
    end)
    if success and response then
        return response
    else
        warn("Ошибка загрузки:", url)
        return nil
    end
end

-- Кнопки
local buttonNames = {"Execute", "Clear", "Copy"}
local buttons = {}

for i, name in ipairs(buttonNames) do
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0, 120, 0, 40)
    btn.Position = UDim2.new(0, 10 + (i - 1) * 130, 1, -40)
    btn.BackgroundColor3 = Color3.fromRGB(10, 10, 10)
    btn.BorderColor3 = Color3.fromRGB(0, 255, 0)
    btn.BorderSizePixel = 2
    btn.Font = Enum.Font.Arcade
    btn.TextSize = 24
    btn.TextColor3 = Color3.fromRGB(0, 255, 0)
    btn.Text = name
    btn.Parent = mainFrame
    buttons[name] = btn
end

-- Execute
buttons.Execute.MouseButton1Click:Connect(function()
    local text = scriptBox.Text
    if text:match("^https?://") then
        local loaded = loadScriptFromUrl(text)
        if loaded then
            executeScript(loaded)
        end
    else
        executeScript(text)
    end
end)

-- Clear
buttons.Clear.MouseButton1Click:Connect(function()
    scriptBox.Text = ""
end)

-- Copy с заменой текста кнопки
buttons.Copy.MouseButton1Click:Connect(function()
    if setclipboard then
        setclipboard(scriptBox.Text)
        local original = buttons.Copy.Text
        buttons.Copy.Text = "Copied!"
        task.delay(2, function()
            buttons.Copy.Text = original
        end)
    else
        warn("setclipboard недоступна.")
    end
end)

-- Кнопка ☰ переключает окно
toggleButton.MouseButton1Click:Connect(function()
    mainFrame.Visible = not mainFrame.Visible
end)
