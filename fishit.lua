-- Advanced Window GUI + AutoFarm template
-- Paste as LocalScript under StarterGui (or StarterPlayerScripts) for testing
-- IMPORTANT: doAutoFarm() is intentionally left as a stub. Implement game-specific actions yourself
-- (and only test in private/dev places or with consent).

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

-- =========== Helpers ===========
local function new(class, props)
    local o = Instance.new(class)
    if props then
        for k,v in pairs(props) do
            if k == "Parent" then o.Parent = v else o[k] = v end
        end
    end
    return o
end

-- Remove existing GUI (for iterative testing)
local existing = playerGui:FindFirstChild("FarmWindowGUI")
if existing then existing:Destroy() end

-- Root ScreenGui
local screenGui = new("ScreenGui", {
    Name = "FarmWindowGUI",
    Parent = playerGui,
    ResetOnSpawn = false,
    DisplayOrder = 999
})

-- ===== Window frame (draggable + resizable) =====
local window = new("Frame", {
    Name = "Window",
    Parent = screenGui,
    Size = UDim2.new(0, 720, 0, 440),
    Position = UDim2.new(0.5, -360, 0.5, -220),
    AnchorPoint = Vector2.new(0.5, 0.5),
    BackgroundColor3 = Color3.fromRGB(30,30,34),
    BorderSizePixel = 0,
})
new("UICorner", {Parent = window, CornerRadius = UDim.new(0, 8)})
new("UIStroke", {Parent = window, Color = Color3.fromRGB(60,60,60), Thickness = 1})

-- Titlebar
local titleBar = new("Frame", {
    Parent = window,
    BackgroundTransparency = 1,
    Size = UDim2.new(1, 0, 0, 36),
    Position = UDim2.new(0, 0, 0, 0),
})
local titleLabel = new("TextLabel", {
    Parent = titleBar,
    BackgroundTransparency = 1,
    Size = UDim2.new(1, -120, 1, 0),
    Position = UDim2.new(0, 12, 0, 0),
    Text = "MyFarm - Dashboard",
    Font = Enum.Font.GothamBold,
    TextSize = 16,
    TextColor3 = Color3.fromRGB(230,230,230),
    TextXAlignment = Enum.TextXAlignment.Left,
})

-- Window control buttons
local btnClose = new("TextButton", {
    Parent = titleBar,
    Size = UDim2.new(0, 36, 0, 26),
    Position = UDim2.new(1, -44, 0, 5),
    Text = "✕",
    Font = Enum.Font.GothamBold,
    TextColor3 = Color3.fromRGB(240,240,240),
    BackgroundColor3 = Color3.fromRGB(200,60,60),
})
new("UICorner", {Parent = btnClose, CornerRadius = UDim.new(0,6)})

local btnMin = new("TextButton", {
    Parent = titleBar,
    Size = UDim2.new(0, 36, 0, 26),
    Position = UDim2.new(1, -88, 0, 5),
    Text = "—",
    Font = Enum.Font.GothamBold,
    TextColor3 = Color3.fromRGB(240,240,240),
    BackgroundColor3 = Color3.fromRGB(80,80,80),
})
new("UICorner", {Parent = btnMin, CornerRadius = UDim.new(0,6)})

local btnMax = new("TextButton", {
    Parent = titleBar,
    Size = UDim2.new(0, 36, 0, 26),
    Position = UDim2.new(1, -132, 0, 5),
    Text = "▢",
    Font = Enum.Font.GothamBold,
    TextColor3 = Color3.fromRGB(240,240,240),
    BackgroundColor3 = Color3.fromRGB(80,80,80),
})
new("UICorner", {Parent = btnMax, CornerRadius = UDim.new(0,6)})

-- Sidebar
local sidebar = new("Frame", {
    Parent = window,
    Size = UDim2.new(0, 200, 1, -36),
    Position = UDim2.new(0, 0, 0, 36),
    BackgroundColor3 = Color3.fromRGB(24,24,26),
})
new("UICorner", {Parent = sidebar, CornerRadius = UDim.new(0,8)})

local menuLayout = new("UIListLayout", {Parent = sidebar, Padding = UDim.new(0,8), SortOrder = Enum.SortOrder.LayoutOrder})
menuLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
menuLayout.VerticalAlignment = Enum.VerticalAlignment.Top

local function createSideButton(text)
    local btn = new("TextButton", {
        Parent = sidebar,
        Size = UDim2.new(1, -24, 0, 40),
        Position = UDim2.new(0, 12, 0, 0),
        BackgroundColor3 = Color3.fromRGB(34,34,36),
        Text = "   "..text,
        Font = Enum.Font.Gotham,
        TextSize = 14,
        TextColor3 = Color3.fromRGB(220,220,220),
        TextXAlignment = Enum.TextXAlignment.Left,
    })
    new("UICorner", {Parent = btn, CornerRadius = UDim.new(0,6)})
    return btn
end

local btnFarm = createSideButton("Farm")
local btnSettings = createSideButton("Settings")
local btnAbout = createSideButton("About")

-- Content area
local content = new("Frame", {
    Parent = window,
    Size = UDim2.new(1, -220, 1, -56),
    Position = UDim2.new(0, 210, 0, 36),
    BackgroundColor3 = Color3.fromRGB(18,18,20),
})
new("UICorner", {Parent = content, CornerRadius = UDim.new(0,6)})
local contentTitle = new("TextLabel", {
    Parent = content,
    Position = UDim2.new(0,12,0,10),
    Size = UDim2.new(1,-24,0,28),
    BackgroundTransparency = 1,
    Text = "Farm",
    Font = Enum.Font.GothamBold,
    TextSize = 18,
    TextColor3 = Color3.fromRGB(235,235,235),
    TextXAlignment = Enum.TextXAlignment.Left,
})

-- Body area
local body = new("Frame", {
    Parent = content,
    Position = UDim2.new(0,12,0,44),
    Size = UDim2.new(1,-24,1,-56),
    BackgroundTransparency = 1,
})

local description = new("TextLabel", {
    Parent = body,
    Size = UDim2.new(1,0,0,40),
    BackgroundTransparency = 1,
    Text = "Auto Farm: toggle to enable/disable. Use Simulate to test the background loop.",
    Font = Enum.Font.Gotham,
    TextSize = 14,
    TextColor3 = Color3.fromRGB(180,180,180),
    TextWrapped = true,
    TextXAlignment = Enum.TextXAlignment.Left,
})

-- Toggle + simulate + status
local toggleBtn = new("TextButton", {
    Parent = body,
    Size = UDim2.new(0, 120, 0, 40),
    Position = UDim2.new(0, 0, 0, 48),
    Text = "Start AutoFarm",
    Font = Enum.Font.GothamBold,
    TextSize = 14,
    BackgroundColor3 = Color3.fromRGB(70,130,70),
    TextColor3 = Color3.fromRGB(240,240,240),
})
new("UICorner", {Parent = toggleBtn, CornerRadius = UDim.new(0,6)})

local simulateBtn = new("TextButton", {
    Parent = body,
    Size = UDim2.new(0, 120, 0, 40),
    Position = UDim2.new(0, 130, 0, 48),
    Text = "Simulate Action",
    Font = Enum.Font.Gotham,
    TextSize = 14,
    BackgroundColor3 = Color3.fromRGB(80,80,80),
    TextColor3 = Color3.fromRGB(240,240,240),
})
new("UICorner", {Parent = simulateBtn, CornerRadius = UDim.new(0,6)})

local statusLabel = new("TextLabel", {
    Parent = body,
    Size = UDim2.new(1, -0, 0, 26),
    Position = UDim2.new(0, 0, 0, 100),
    BackgroundTransparency = 1,
    Text = "Status: Idle",
    Font = Enum.Font.Gotham,
    TextSize = 14,
    TextColor3 = Color3.fromRGB(170,170,170),
    TextXAlignment = Enum.TextXAlignment.Left,
})

-- Resize grip
local grip = new("Frame", {
    Parent = window,
    Size = UDim2.new(0, 14, 0, 14),
    Position = UDim2.new(1, -18, 1, -18),
    BackgroundTransparency = 1,
})
local gripCorner = new("ImageLabel", {
    Parent = grip,
    Size = UDim2.new(1,0,1,0),
    BackgroundTransparency = 1,
    Image = "rbxassetid://3926305904", -- small grip asset
    ImageColor3 = Color3.fromRGB(120,120,120),
    ScaleType = Enum.ScaleType.Slice,
    SliceCenter = Rect.new(4,4,252,252),
})
-- =========== Drag & Resize Logic ===========
do
    local dragging = false
    local dragStart = Vector2.new()
    local startPos = UDim2.new()
    local startSize = UDim2.new()
    local resizing = false
    local resizeStart = Vector2.new()

    -- Drag (titleBar)
    titleBar.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
            dragStart = input.Position
            startPos = window.Position
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then dragging = false end
            end)
        end
    end)
    titleBar.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement and dragging then
            local delta = input.Position - dragStart
            window.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        end
    end)

    -- Resize (grip)
    grip.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            resizing = true
            resizeStart = input.Position
            startSize = window.Size
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then resizing = false end
            end)
        end
    end)
    grip.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement and resizing then
            local delta = input.Position - resizeStart
            local newX = math.clamp(startSize.X.Offset + delta.X, 300, 1400)
            local newY = math.clamp(startSize.Y.Offset + delta.Y, 180, 1000)
            window.Size = UDim2.new(0, newX, 0, newY)
        end
    end)
end

-- ===== Window controls =====
local isMinimized = false
local lastSize, lastPos = window.Size, window.Position
btnClose.MouseButton1Click:Connect(function()
    window:Destroy()
end)
btnMin.MouseButton1Click:Connect(function()
    if not isMinimized then
        lastSize, lastPos = window.Size, window.Position
        window.Size = UDim2.new(0, 320, 0, 40)
        window.Position = UDim2.new(0.5, -160, 0.1, 0)
        isMinimized = true
    else
        window.Size = lastSize
        window.Position = lastPos
        isMinimized = false
    end
end)
local maximized = false
btnMax.MouseButton1Click:Connect(function()
    if not maximized then
        lastSize, lastPos = window.Size, window.Position
        window.Size = UDim2.new(0.92, 0, 0.84, 0)
        window.Position = UDim2.new(0.5, 0, 0.5, 0)
        window.AnchorPoint = Vector2.new(0.5, 0.5)
        maximized = true
    else
        window.Size = lastSize
        window.Position = lastPos
        maximized = false
    end
end)

-- ===== Content switching =====
btnFarm.MouseButton1Click:Connect(function()
    contentTitle.Text = "Farm"
    description.Text = "Auto Farm: toggle to enable/disable. Use Simulate to test the background loop."
end)
btnSettings.MouseButton1Click:Connect(function()
    contentTitle.Text = "Settings"
    description.Text = "Settings area — add toggles / sliders / keys here."
end)
btnAbout.MouseButton1Click:Connect(function()
    contentTitle.Text = "About"
    description.Text = "This is a UI template. Implement game-specific actions inside doAutoFarm()."
end)

-- ===== AutoFarm core (safe stub + testing hook) =====
local autoFarmEnabled = false
local autoFarmThread = nil

-- DO NOT put server-exploiting code here in public. Instead, implement your game-specific calls on private testing place.
local function doAutoFarm()
    -- === PLACE YOUR GAME-SPECIFIC ACTIONS HERE ===
    -- EXAMPLES (allowed safe patterns): detect tool, animate local GUI, play sound, or call a developer-approved API.
    -- NEVER publish code that FireServer() to cheat on public servers.
    --
    -- For now we simulate action with prints so you can confirm the loop works.
    print("[doAutoFarm] simulated action at", tick())
    -- optionally update statusLabel with last action time:
    statusLabel.Text = ("Status: Running — last action @ %.1f"):format(tick())
end

local function autoFarmLoop()
    while autoFarmEnabled do
        local ok, err = pcall(function()
            doAutoFarm()
        end)
        if not ok then
            warn("[AutoFarm] error in doAutoFarm:", err)
            statusLabel.Text = "Status: Error (see Output)"
            autoFarmEnabled = false
            break
        end
        task.wait(2) -- change cadence here (seconds)
    end
    if not autoFarmEnabled then
        statusLabel.Text = "Status: Idle"
    end
end

toggleBtn.MouseButton1Click:Connect(function()
    autoFarmEnabled = not autoFarmEnabled
    if autoFarmEnabled then
        toggleBtn.Text = "Stop AutoFarm"
        toggleBtn.BackgroundColor3 = Color3.fromRGB(180,60,60)
        statusLabel.Text = "Status: Starting..."
        autoFarmThread = task.spawn(autoFarmLoop)
    else
        toggleBtn.Text = "Start AutoFarm"
        toggleBtn.BackgroundColor3 = Color3.fromRGB(70,130,70)
        statusLabel.Text = "Status: Stopping..."
    end
end)

-- Simulate action button (for testing without game-specific code)
simulateBtn.MouseButton1Click:Connect(function()
    doAutoFarm()
end)

-- ===== Debug helpers =====
-- Print to Output when GUI loads (helps confirm LocalScript placement)
print("[FarmWindowGUI] loaded for player:", player.Name)
statusLabel.Text = "Status: Idle"

