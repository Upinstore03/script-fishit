-- AutoFarm GUI Script
-- Bisa di load dengan: loadstring(game:HttpGet("YOUR_RAW_GITHUB_URL"))()

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

-- Hapus GUI lama jika ada
if playerGui:FindFirstChild("AutoFarmGUI") then
    playerGui:FindFirstChild("AutoFarmGUI"):Destroy()
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

-- Buat ScreenGui
local screenGui = create("ScreenGui", {
    Name = "AutoFarmGUI",
    Parent = playerGui,
    ResetOnSpawn = false,
    ZIndexBehavior = Enum.ZIndexBehavior.Sibling
})

-- Main Frame (Window)
local mainFrame = create("Frame", {
    Name = "MainFrame",
    Parent = screenGui,
    Size = UDim2.new(0, 450, 0, 320),
    Position = UDim2.new(0.5, -225, 0.5, -160),
    BackgroundColor3 = Color3.fromRGB(25, 25, 35),
    BorderSizePixel = 0,
    ClipsDescendants = true
})

create("UICorner", {
    Parent = mainFrame,
    CornerRadius = UDim.new(0, 12)
})

create("UIStroke", {
    Parent = mainFrame,
    Color = Color3.fromRGB(60, 60, 80),
    Thickness = 2,
    Transparency = 0.5
})

-- Shadow effect
local shadow = create("ImageLabel", {
    Name = "Shadow",
    Parent = mainFrame,
    Size = UDim2.new(1, 30, 1, 30),
    Position = UDim2.new(0, -15, 0, -15),
    BackgroundTransparency = 1,
    Image = "rbxasset://textures/ui/GuiImagePlaceholder.png",
    ImageColor3 = Color3.fromRGB(0, 0, 0),
    ImageTransparency = 0.7,
    ScaleType = Enum.ScaleType.Slice,
    SliceCenter = Rect.new(10, 10, 118, 118),
    ZIndex = -1
})

-- Title Bar (untuk drag)
local titleBar = create("Frame", {
    Name = "TitleBar",
    Parent = mainFrame,
    Size = UDim2.new(1, 0, 0, 45),
    BackgroundColor3 = Color3.fromRGB(35, 35, 50),
    BorderSizePixel = 0
})

create("UICorner", {
    Parent = titleBar,
    CornerRadius = UDim.new(0, 12)
})

-- Title Text
local titleText = create("TextLabel", {
    Name = "Title",
    Parent = titleBar,
    Size = UDim2.new(1, -100, 1, 0),
    Position = UDim2.new(0, 15, 0, 0),
    BackgroundTransparency = 1,
    Text = "🎯 Auto Farm Pro",
    Font = Enum.Font.GothamBold,
    TextSize = 18,
    TextColor3 = Color3.fromRGB(255, 255, 255),
    TextXAlignment = Enum.TextXAlignment.Left
})

-- Close Button
local closeBtn = create("TextButton", {
    Name = "CloseBtn",
    Parent = titleBar,
    Size = UDim2.new(0, 35, 0, 35),
    Position = UDim2.new(1, -40, 0, 5),
    BackgroundColor3 = Color3.fromRGB(200, 50, 50),
    Text = "✕",
    Font = Enum.Font.GothamBold,
    TextSize = 18,
    TextColor3 = Color3.fromRGB(255, 255, 255)
})

create("UICorner", {
    Parent = closeBtn,
    CornerRadius = UDim.new(0, 8)
})

-- Minimize Button
local minimizeBtn = create("TextButton", {
    Name = "MinimizeBtn",
    Parent = titleBar,
    Size = UDim2.new(0, 35, 0, 35),
    Position = UDim2.new(1, -80, 0, 5),
    BackgroundColor3 = Color3.fromRGB(80, 80, 100),
    Text = "—",
    Font = Enum.Font.GothamBold,
    TextSize = 18,
    TextColor3 = Color3.fromRGB(255, 255, 255)
})

create("UICorner", {
    Parent = minimizeBtn,
    CornerRadius = UDim.new(0, 8)
})

-- Content Frame
local contentFrame = create("Frame", {
    Name = "Content",
    Parent = mainFrame,
    Size = UDim2.new(1, -30, 1, -75),
    Position = UDim2.new(0, 15, 0, 60),
    BackgroundTransparency = 1
})

-- Status Label
local statusLabel = create("TextLabel", {
    Name = "Status",
    Parent = contentFrame,
    Size = UDim2.new(1, 0, 0, 30),
    Position = UDim2.new(0, 0, 0, 0),
    BackgroundColor3 = Color3.fromRGB(35, 35, 50),
    Text = "🔴 Status: Idle",
    Font = Enum.Font.Gotham,
    TextSize = 14,
    TextColor3 = Color3.fromRGB(220, 220, 220),
    TextXAlignment = Enum.TextXAlignment.Center
})

create("UICorner", {
    Parent = statusLabel,
    CornerRadius = UDim.new(0, 8)
})

-- Description
local descLabel = create("TextLabel", {
    Name = "Description",
    Parent = contentFrame,
    Size = UDim2.new(1, 0, 0, 50),
    Position = UDim2.new(0, 0, 0, 45),
    BackgroundTransparency = 1,
    Text = "Toggle untuk mengaktifkan/menonaktifkan Auto Farm.\nGUI dapat di-drag dari title bar.",
    Font = Enum.Font.Gotham,
    TextSize = 12,
    TextColor3 = Color3.fromRGB(180, 180, 180),
    TextWrapped = true,
    TextXAlignment = Enum.TextXAlignment.Left,
    TextYAlignment = Enum.TextYAlignment.Top
})

-- Toggle Button
local toggleBtn = create("TextButton", {
    Name = "ToggleBtn",
    Parent = contentFrame,
    Size = UDim2.new(0, 180, 0, 45),
    Position = UDim2.new(0.5, -90, 0, 110),
    BackgroundColor3 = Color3.fromRGB(60, 140, 60),
    Text = "▶ Start Auto Farm",
    Font = Enum.Font.GothamBold,
    TextSize = 15,
    TextColor3 = Color3.fromRGB(255, 255, 255)
})

create("UICorner", {
    Parent = toggleBtn,
    CornerRadius = UDim.new(0, 10)
})

-- Info Label
local infoLabel = create("TextLabel", {
    Name = "Info",
    Parent = contentFrame,
    Size = UDim2.new(1, 0, 0, 40),
    Position = UDim2.new(0, 0, 1, -45),
    BackgroundTransparency = 1,
    Text = "Actions: 0 | Runtime: 0s",
    Font = Enum.Font.Gotham,
    TextSize = 12,
    TextColor3 = Color3.fromRGB(150, 150, 150),
    TextXAlignment = Enum.TextXAlignment.Center
})

-- ========== DRAG FUNCTIONALITY (SMOOTH) ==========
local dragging = false
local dragInput, dragStart, startPos

local function updateDrag(input)
    local delta = input.Position - dragStart
    local targetPos = UDim2.new(
        startPos.X.Scale,
        startPos.X.Offset + delta.X,
        startPos.Y.Scale,
        startPos.Y.Offset + delta.Y
    )
    
    -- Smooth tween untuk pergerakan
    TweenService:Create(mainFrame, TweenInfo.new(0.1, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
        Position = targetPos
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

-- ========== AUTO FARM LOGIC ==========
local autoFarmRunning = false
local actionCount = 0
local startTime = 0

local function doAutoFarm()
    -- GANTI INI DENGAN LOGIC GAME ANDA
    -- Contoh: collect coins, kill enemies, farm resources, dll
    
    -- Contoh implementasi sederhana:
    print("[AutoFarm] Action executed at", os.date("%X"))
    actionCount = actionCount + 1
    
    -- Update info
    local runtime = math.floor(os.clock() - startTime)
    infoLabel.Text = string.format("Actions: %d | Runtime: %ds", actionCount, runtime)
    
    -- === TAMBAHKAN GAME-SPECIFIC CODE DI SINI ===
    -- Contoh untuk game tertentu:
    -- local coin = workspace:FindFirstChild("Coin")
    -- if coin then
    --     player.Character.HumanoidRootPart.CFrame = coin.CFrame
    -- end
    
    task.wait(0.5) -- Delay antar action
end

local function autoFarmLoop()
    while autoFarmRunning do
        local success, err = pcall(doAutoFarm)
        if not success then
            warn("[AutoFarm Error]:", err)
            statusLabel.Text = "⚠️ Status: Error!"
        end
        task.wait(2) -- Interval antar loop (2 detik)
    end
end

-- ========== BUTTON FUNCTIONS ==========
toggleBtn.MouseButton1Click:Connect(function()
    autoFarmRunning = not autoFarmRunning
    
    if autoFarmRunning then
        toggleBtn.Text = "⏸ Stop Auto Farm"
        toggleBtn.BackgroundColor3 = Color3.fromRGB(180, 50, 50)
        statusLabel.Text = "🟢 Status: Running..."
        startTime = os.clock()
        actionCount = 0
        
        task.spawn(autoFarmLoop)
    else
        toggleBtn.Text = "▶ Start Auto Farm"
        toggleBtn.BackgroundColor3 = Color3.fromRGB(60, 140, 60)
        statusLabel.Text = "🔴 Status: Stopped"
    end
end)

closeBtn.MouseButton1Click:Connect(function()
    autoFarmRunning = false
    screenGui:Destroy()
    print("[AutoFarm] GUI Closed")
end)

-- Minimize functionality
local minimized = false
local originalSize = mainFrame.Size

minimizeBtn.MouseButton1Click:Connect(function()
    minimized = not minimized
    
    if minimized then
        TweenService:Create(mainFrame, TweenInfo.new(0.3, Enum.EasingStyle.Quad), {
            Size = UDim2.new(0, 450, 0, 45)
        }):Play()
        minimizeBtn.Text = "+"
    else
        TweenService:Create(mainFrame, TweenInfo.new(0.3, Enum.EasingStyle.Quad), {
            Size = originalSize
        }):Play()
        minimizeBtn.Text = "—"
    end
end)

-- Hover effects
local function addHoverEffect(button, normalColor, hoverColor)
    button.MouseEnter:Connect(function()
        TweenService:Create(button, TweenInfo.new(0.2), {
            BackgroundColor3 = hoverColor
        }):Play()
    end)
    
    button.MouseLeave:Connect(function()
        TweenService:Create(button, TweenInfo.new(0.2), {
            BackgroundColor3 = normalColor
        }):Play()
    end)
end

addHoverEffect(closeBtn, Color3.fromRGB(200, 50, 50), Color3.fromRGB(220, 70, 70))
addHoverEffect(minimizeBtn, Color3.fromRGB(80, 80, 100), Color3.fromRGB(100, 100, 120))

print("[AutoFarm GUI] Loaded successfully for", player.Name)
print("[AutoFarm GUI] Drag window dari title bar untuk memindahkan")
