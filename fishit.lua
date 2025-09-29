-- Auto Fishing & Auto Sell Script untuk game "Fisch"
-- Load dengan: loadstring(game:HttpGet("YOUR_RAW_GITHUB_URL"))()

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local VirtualInputManager = game:GetService("VirtualInputManager")

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")
local character = player.Character or player.CharacterAdded:Wait()
local humanoidRootPart = character:WaitForChild("HumanoidRootPart")

-- Hapus GUI lama
if playerGui:FindFirstChild("FischAutoFarmGUI") then
    playerGui:FindFirstChild("FischAutoFarmGUI"):Destroy()
end

-- Helper function
local function create(className, properties)
    local instance = Instance.new(className)
    for property, value in pairs(properties) do
        if property ~= "Parent" then
            instance[property] = value
        end
    end
    if properties.Parent then
        instance.Parent = properties.Parent
    end
    return instance
end

-- ScreenGui
local screenGui = create("ScreenGui", {
    Name = "FischAutoFarmGUI",
    Parent = playerGui,
    ResetOnSpawn = false,
    ZIndexBehavior = Enum.ZIndexBehavior.Sibling
})

-- Main Frame
local mainFrame = create("Frame", {
    Name = "MainFrame",
    Parent = screenGui,
    Size = UDim2.new(0, 480, 0, 420),
    Position = UDim2.new(0.5, -240, 0.5, -210),
    BackgroundColor3 = Color3.fromRGB(20, 25, 35),
    BorderSizePixel = 0,
    ClipsDescendants = true
})

create("UICorner", {Parent = mainFrame, CornerRadius = UDim.new(0, 12)})
create("UIStroke", {Parent = mainFrame, Color = Color3.fromRGB(50, 70, 100), Thickness = 2})

-- Title Bar
local titleBar = create("Frame", {
    Name = "TitleBar",
    Parent = mainFrame,
    Size = UDim2.new(1, 0, 0, 50),
    BackgroundColor3 = Color3.fromRGB(30, 40, 60),
    BorderSizePixel = 0
})

create("UICorner", {Parent = titleBar, CornerRadius = UDim.new(0, 12)})

local titleText = create("TextLabel", {
    Parent = titleBar,
    Size = UDim2.new(1, -100, 1, 0),
    Position = UDim2.new(0, 15, 0, 0),
    BackgroundTransparency = 1,
    Text = "🎣 Fisch Auto Farm",
    Font = Enum.Font.GothamBold,
    TextSize = 20,
    TextColor3 = Color3.fromRGB(100, 200, 255),
    TextXAlignment = Enum.TextXAlignment.Left
})

-- Close Button
local closeBtn = create("TextButton", {
    Parent = titleBar,
    Size = UDim2.new(0, 40, 0, 40),
    Position = UDim2.new(1, -45, 0, 5),
    BackgroundColor3 = Color3.fromRGB(220, 60, 60),
    Text = "✕",
    Font = Enum.Font.GothamBold,
    TextSize = 20,
    TextColor3 = Color3.fromRGB(255, 255, 255)
})

create("UICorner", {Parent = closeBtn, CornerRadius = UDim.new(0, 8)})

-- Minimize Button
local minimizeBtn = create("TextButton", {
    Parent = titleBar,
    Size = UDim2.new(0, 40, 0, 40),
    Position = UDim2.new(1, -90, 0, 5),
    BackgroundColor3 = Color3.fromRGB(80, 90, 110),
    Text = "—",
    Font = Enum.Font.GothamBold,
    TextSize = 20,
    TextColor3 = Color3.fromRGB(255, 255, 255)
})

create("UICorner", {Parent = minimizeBtn, CornerRadius = UDim.new(0, 8)})

-- Content Frame
local contentFrame = create("ScrollingFrame", {
    Name = "Content",
    Parent = mainFrame,
    Size = UDim2.new(1, -30, 1, -80),
    Position = UDim2.new(0, 15, 0, 65),
    BackgroundTransparency = 1,
    BorderSizePixel = 0,
    ScrollBarThickness = 6,
    CanvasSize = UDim2.new(0, 0, 0, 600)
})

-- Status Container
local statusContainer = create("Frame", {
    Parent = contentFrame,
    Size = UDim2.new(1, 0, 0, 80),
    Position = UDim2.new(0, 0, 0, 0),
    BackgroundColor3 = Color3.fromRGB(30, 35, 50),
})

create("UICorner", {Parent = statusContainer, CornerRadius = UDim.new(0, 10)})

local statusLabel = create("TextLabel", {
    Parent = statusContainer,
    Size = UDim2.new(1, -20, 0, 25),
    Position = UDim2.new(0, 10, 0, 10),
    BackgroundTransparency = 1,
    Text = "🔴 Status: Idle",
    Font = Enum.Font.GothamBold,
    TextSize = 15,
    TextColor3 = Color3.fromRGB(255, 100, 100),
    TextXAlignment = Enum.TextXAlignment.Left
})

local statsLabel = create("TextLabel", {
    Parent = statusContainer,
    Size = UDim2.new(1, -20, 0, 40),
    Position = UDim2.new(0, 10, 0, 35),
    BackgroundTransparency = 1,
    Text = "Fish Caught: 0 | Sold: 0\nTotal Value: $0",
    Font = Enum.Font.Gotham,
    TextSize = 13,
    TextColor3 = Color3.fromRGB(180, 180, 180),
    TextXAlignment = Enum.TextXAlignment.Left,
    TextYAlignment = Enum.TextYAlignment.Top
})

-- Auto Fishing Toggle
local fishingToggle = create("Frame", {
    Parent = contentFrame,
    Size = UDim2.new(1, 0, 0, 60),
    Position = UDim2.new(0, 0, 0, 95),
    BackgroundColor3 = Color3.fromRGB(30, 35, 50),
})

create("UICorner", {Parent = fishingToggle, CornerRadius = UDim.new(0, 10)})

local fishingLabel = create("TextLabel", {
    Parent = fishingToggle,
    Size = UDim2.new(0.6, 0, 1, 0),
    Position = UDim2.new(0, 15, 0, 0),
    BackgroundTransparency = 1,
    Text = "🎣 Auto Fishing",
    Font = Enum.Font.GothamBold,
    TextSize = 16,
    TextColor3 = Color3.fromRGB(220, 220, 220),
    TextXAlignment = Enum.TextXAlignment.Left
})

local fishingBtn = create("TextButton", {
    Parent = fishingToggle,
    Size = UDim2.new(0, 100, 0, 40),
    Position = UDim2.new(1, -110, 0, 10),
    BackgroundColor3 = Color3.fromRGB(60, 140, 60),
    Text = "START",
    Font = Enum.Font.GothamBold,
    TextSize = 14,
    TextColor3 = Color3.fromRGB(255, 255, 255)
})

create("UICorner", {Parent = fishingBtn, CornerRadius = UDim.new(0, 8)})

-- Auto Sell Toggle
local sellToggle = create("Frame", {
    Parent = contentFrame,
    Size = UDim2.new(1, 0, 0, 60),
    Position = UDim2.new(0, 0, 0, 170),
    BackgroundColor3 = Color3.fromRGB(30, 35, 50),
})

create("UICorner", {Parent = sellToggle, CornerRadius = UDim.new(0, 10)})

local sellLabel = create("TextLabel", {
    Parent = sellToggle,
    Size = UDim2.new(0.6, 0, 1, 0),
    Position = UDim2.new(0, 15, 0, 0),
    BackgroundTransparency = 1,
    Text = "💰 Auto Sell",
    Font = Enum.Font.GothamBold,
    TextSize = 16,
    TextColor3 = Color3.fromRGB(220, 220, 220),
    TextXAlignment = Enum.TextXAlignment.Left
})

local sellBtn = create("TextButton", {
    Parent = sellToggle,
    Size = UDim2.new(0, 100, 0, 40),
    Position = UDim2.new(1, -110, 0, 10),
    BackgroundColor3 = Color3.fromRGB(60, 140, 60),
    Text = "START",
    Font = Enum.Font.GothamBold,
    TextSize = 14,
    TextColor3 = Color3.fromRGB(255, 255, 255)
})

create("UICorner", {Parent = sellBtn, CornerRadius = UDim.new(0, 8)})

-- Settings Section
local settingsFrame = create("Frame", {
    Parent = contentFrame,
    Size = UDim2.new(1, 0, 0, 100),
    Position = UDim2.new(0, 0, 0, 245),
    BackgroundColor3 = Color3.fromRGB(30, 35, 50),
})

create("UICorner", {Parent = settingsFrame, CornerRadius = UDim.new(0, 10)})

local settingsTitle = create("TextLabel", {
    Parent = settingsFrame,
    Size = UDim2.new(1, -20, 0, 25),
    Position = UDim2.new(0, 10, 0, 8),
    BackgroundTransparency = 1,
    Text = "⚙️ Settings",
    Font = Enum.Font.GothamBold,
    TextSize = 15,
    TextColor3 = Color3.fromRGB(220, 220, 220),
    TextXAlignment = Enum.TextXAlignment.Left
})

local sellIntervalLabel = create("TextLabel", {
    Parent = settingsFrame,
    Size = UDim2.new(0.7, 0, 0, 25),
    Position = UDim2.new(0, 10, 0, 40),
    BackgroundTransparency = 1,
    Text = "Sell Interval: 30s",
    Font = Enum.Font.Gotham,
    TextSize = 13,
    TextColor3 = Color3.fromRGB(180, 180, 180),
    TextXAlignment = Enum.TextXAlignment.Left
})

local castDelayLabel = create("TextLabel", {
    Parent = settingsFrame,
    Size = UDim2.new(0.7, 0, 0, 25),
    Position = UDim2.new(0, 10, 0, 68),
    BackgroundTransparency = 1,
    Text = "Cast Delay: 2s",
    Font = Enum.Font.Gotham,
    TextSize = 13,
    TextColor3 = Color3.fromRGB(180, 180, 180),
    TextXAlignment = Enum.TextXAlignment.Left
})

-- Info Label
local infoLabel = create("TextLabel", {
    Parent = contentFrame,
    Size = UDim2.new(1, 0, 0, 60),
    Position = UDim2.new(0, 0, 0, 360),
    BackgroundColor3 = Color3.fromRGB(40, 60, 80),
    Text = "ℹ️ Drag title bar untuk memindahkan GUI\nScript akan auto fishing dan auto sell fish",
    Font = Enum.Font.Gotham,
    TextSize = 12,
    TextColor3 = Color3.fromRGB(150, 170, 200),
    TextWrapped = true,
    TextXAlignment = Enum.TextXAlignment.Center
})

create("UICorner", {Parent = infoLabel, CornerRadius = UDim.new(0, 10)})

-- ========== DRAG FUNCTIONALITY ==========
local dragging, dragInput, dragStart, startPos

local function updateDrag(input)
    local delta = input.Position - dragStart
    TweenService:Create(mainFrame, TweenInfo.new(0.1, Enum.EasingStyle.Quad), {
        Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
    }):Play()
end

titleBar.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragging = true
        dragStart = input.Position
        startPos = mainFrame.Position
        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then
                dragging = false
            end
        end)
    end
end)

titleBar.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
        dragInput = input
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if dragging and input == dragInput then
        updateDrag(input)
    end
end)

-- ========== FISCH GAME FUNCTIONS ==========
local autoFishingEnabled = false
local autoSellEnabled = false
local fishCaught = 0
local fishSold = 0
local totalValue = 0

-- Get player data
local function getPlayerData()
    local PlayerData = ReplicatedStorage:FindFirstChild("playerstats")
    if PlayerData then
        return PlayerData:FindFirstChild(player.Name)
    end
    return nil
end

-- Cast fishing rod
local function castRod()
    local success, err = pcall(function()
        local tool = character:FindFirstChildOfClass("Tool")
        if tool and tool:FindFirstChild("events") then
            local castEvent = tool.events:FindFirstChild("cast")
            if castEvent then
                castEvent:FireServer(100, 1) -- Max power cast
                return true
            end
        end
    end)
    return success
end

-- Reel in fish
local function reelFish()
    local success, err = pcall(function()
        local tool = character:FindFirstChildOfClass("Tool")
        if tool and tool:FindFirstChild("events") then
            local reelEvent = tool.events:FindFirstChild("reel")
            if reelEvent then
                reelEvent:FireServer(100, true) -- Reel with max power
                return true
            end
        end
    end)
    return success
end

-- Check if fish is hooked
local function isFishHooked()
    local playerGui = player:FindFirstChild("PlayerGui")
    if playerGui then
        local fishingUI = playerGui:FindFirstChild("hud")
        if fishingUI then
            local safezone = fishingUI:FindFirstChild("safezone", true)
            return safezone and safezone.Visible
        end
    end
    return false
end

-- Sell fish
local function sellFish()
    local success, err = pcall(function()
        -- Find NPC Merchant
        local merchant = workspace:FindFirstChild("world") and workspace.world:FindFirstChild("npcs") and workspace.world.npcs:FindFirstChild("Marc Merchant")
        
        if merchant and merchant:FindFirstChild("merchant") then
            local originalPos = humanoidRootPart.CFrame
            
            -- Teleport to merchant
            humanoidRootPart.CFrame = merchant.merchant.CFrame + Vector3.new(0, 3, 0)
            task.wait(0.5)
            
            -- Trigger sell
            local sellRemote = ReplicatedStorage:FindFirstChild("events") and ReplicatedStorage.events:FindFirstChild("sell")
            if sellRemote then
                sellRemote:InvokeServer()
                fishSold = fishSold + 1
                totalValue = totalValue + math.random(50, 500) -- Estimate
            end
            
            task.wait(0.5)
            -- Return to original position
            humanoidRootPart.CFrame = originalPos
        end
    end)
    return success
end

-- Auto Fishing Loop
local function autoFishingLoop()
    while autoFishingEnabled do
        local success, err = pcall(function()
            -- Check if rod is equipped
            local tool = character:FindFirstChildOfClass("Tool")
            if not tool or not tool:FindFirstChild("events") then
                statusLabel.Text = "⚠️ Equip Fishing Rod!"
                statusLabel.TextColor3 = Color3.fromRGB(255, 200, 100)
                task.wait(2)
                return
            end
            
            -- Cast rod
            statusLabel.Text = "🎣 Casting rod..."
            statusLabel.TextColor3 = Color3.fromRGB(100, 200, 255)
            castRod()
            task.wait(2)
            
            -- Wait for fish
            statusLabel.Text = "⏳ Waiting for fish..."
            local waitTime = 0
            while not isFishHooked() and waitTime < 30 and autoFishingEnabled do
                task.wait(0.5)
                waitTime = waitTime + 0.5
            end
            
            if isFishHooked() then
                statusLabel.Text = "🐟 Fish hooked! Reeling..."
                statusLabel.TextColor3 = Color3.fromRGB(100, 255, 100)
                task.wait(0.5)
                reelFish()
                task.wait(2)
                fishCaught = fishCaught + 1
                
                -- Update stats
                statsLabel.Text = string.format("Fish Caught: %d | Sold: %d\nTotal Value: $%d", fishCaught, fishSold, totalValue)
            end
            
            task.wait(2) -- Cast delay
        end)
        
        if not success then
            warn("[Auto Fishing Error]:", err)
        end
    end
    statusLabel.Text = "🔴 Status: Idle"
    statusLabel.TextColor3 = Color3.fromRGB(255, 100, 100)
end

-- Auto Sell Loop
local function autoSellLoop()
    while autoSellEnabled do
        local success, err = pcall(function()
            statusLabel.Text = "💰 Selling fish..."
            statusLabel.TextColor3 = Color3.fromRGB(255, 215, 0)
            sellFish()
            statsLabel.Text = string.format("Fish Caught: %d | Sold: %d\nTotal Value: $%d", fishCaught, fishSold, totalValue)
        end)
        
        if not success then
            warn("[Auto Sell Error]:", err)
        end
        
        task.wait(30) -- Sell every 30 seconds
    end
end

-- ========== BUTTON FUNCTIONS ==========
fishingBtn.MouseButton1Click:Connect(function()
    autoFishingEnabled = not autoFishingEnabled
    
    if autoFishingEnabled then
        fishingBtn.Text = "STOP"
        fishingBtn.BackgroundColor3 = Color3.fromRGB(180, 60, 60)
        task.spawn(autoFishingLoop)
    else
        fishingBtn.Text = "START"
        fishingBtn.BackgroundColor3 = Color3.fromRGB(60, 140, 60)
    end
end)

sellBtn.MouseButton1Click:Connect(function()
    autoSellEnabled = not autoSellEnabled
    
    if autoSellEnabled then
        sellBtn.Text = "STOP"
        sellBtn.BackgroundColor3 = Color3.fromRGB(180, 60, 60)
        task.spawn(autoSellLoop)
    else
        sellBtn.Text = "START"
        sellBtn.BackgroundColor3 = Color3.fromRGB(60, 140, 60)
    end
end)

closeBtn.MouseButton1Click:Connect(function()
    autoFishingEnabled = false
    autoSellEnabled = false
    screenGui:Destroy()
end)

-- Minimize
local minimized = false
minimizeBtn.MouseButton1Click:Connect(function()
    minimized = not minimized
    TweenService:Create(mainFrame, TweenInfo.new(0.3, Enum.EasingStyle.Quad), {
        Size = minimized and UDim2.new(0, 480, 0, 50) or UDim2.new(0, 480, 0, 420)
    }):Play()
    minimizeBtn.Text = minimized and "+" or "—"
end)

-- Hover effects
local function addHover(btn, normal, hover)
    btn.MouseEnter:Connect(function()
        TweenService:Create(btn, TweenInfo.new(0.2), {BackgroundColor3 = hover}):Play()
    end)
    btn.MouseLeave:Connect(function()
        TweenService:Create(btn, TweenInfo.new(0.2), {BackgroundColor3 = normal}):Play()
    end)
end

addHover(closeBtn, Color3.fromRGB(220, 60, 60), Color3.fromRGB(240, 80, 80))
addHover(minimizeBtn, Color3.fromRGB(80, 90, 110), Color3.fromRGB(100, 110, 130))

print("[Fisch Auto Farm] Loaded successfully!")
print("[Fisch Auto Farm] Equip fishing rod and press START")
