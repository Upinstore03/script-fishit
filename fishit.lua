-- Dashboard GUI + Auto Farm toggle (Client-side GUI template)
-- Letakkan script ini di: StarterGui sebagai LocalScript (atau StarterPlayerScripts untuk testing)
-- PENTING: Jangan panggil RemoteEvent/RemoteFunction yang kamu tidak paham; letakkan panggilan game-specific di function doAutoFarm()

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

-- =====================
-- Helper: create UI util
-- =====================
local function new(class, props)
    local obj = Instance.new(class)
    if props then
        for k,v in pairs(props) do
            if k == "Parent" then
                obj.Parent = v
            else
                obj[k] = v
            end
        end
    end
    return obj
end

-- Clean existing test GUI (optional)
local existing = playerGui:FindFirstChild("MyFarmDashboard")
if existing then existing:Destroy() end

-- Root
local screenGui = new("ScreenGui", {
    Name = "MyFarmDashboard",
    DisplayOrder = 100,
    ResetOnSpawn = false,
    Parent = playerGui
})

-- Main container
local main = new("Frame", {
    Name = "Main",
    Parent = screenGui,
    BackgroundColor3 = Color3.fromRGB(28, 28, 30),
    BorderSizePixel = 0,
    Size = UDim2.new(0, 840, 0, 520),
    Position = UDim2.new(0.5, -420, 0.5, -260),
    AnchorPoint = Vector2.new(0.5, 0.5),
    Visible = true,
})

-- Rounded corner (UIGradient + corner)
local uiCorner = new("UICorner", {Parent = main, CornerRadius = UDim.new(0, 10)})
local uiStroke = new("UIStroke", {Parent = main, Color = Color3.fromRGB(60,60,60), Thickness = 1})

-- Sidebar
local sidebar = new("Frame", {
    Parent = main,
    BackgroundColor3 = Color3.fromRGB(22, 22, 24),
    Size = UDim2.new(0, 220, 1, 0),
    Position = UDim2.new(0, 0, 0, 0)
})
new("UICorner", {Parent = sidebar, CornerRadius = UDim.new(0, 10)})
new("UIStroke", {Parent = sidebar, Color = Color3.fromRGB(40,40,40), Thickness = 1})

-- Header on sidebar
local header = new("TextLabel", {
    Parent = sidebar,
    BackgroundTransparency = 1,
    Size = UDim2.new(1, -20, 0, 64),
    Position = UDim2.new(0, 10, 0, 10),
    Text = "DASHBOARD",
    Font = Enum.Font.GothamBold,
    TextSize = 20,
    TextColor3 = Color3.fromRGB(220,220,220),
    TextXAlignment = Enum.TextXAlignment.Left,
})
local subtitle = new("TextLabel", {
    Parent = sidebar,
    BackgroundTransparency = 1,
    Size = UDim2.new(1, -20, 0, 20),
    Position = UDim2.new(0, 10, 0, 38),
    Text = "Farm • Tools",
    Font = Enum.Font.Gotham,
    TextSize = 12,
    TextColor3 = Color3.fromRGB(160,160,160),
    TextXAlignment = Enum.TextXAlignment.Left,
})

-- Sidebar menu area
local menuHolder = new("Frame", {
    Parent = sidebar,
    BackgroundTransparency = 1,
    Size = UDim2.new(1, 0, 1, -80),
    Position = UDim2.new(0, 0, 0, 80),
})
local menuLayout = new("UIListLayout", {Parent = menuHolder, Padding = UDim.new(0, 8), SortOrder = Enum.SortOrder.LayoutOrder})
menuLayout.Padding = UDim.new(0, 8)
menuLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
menuLayout.VerticalAlignment = Enum.VerticalAlignment.Top

-- Menu button factory
local function createMenuButton(name, order)
    local btn = new("TextButton", {
        Parent = menuHolder,
        BackgroundColor3 = Color3.fromRGB(34,34,36),
        Size = UDim2.new(1, -20, 0, 40),
        Position = UDim2.new(0, 10, 0, 0),
        Text = "  "..name,
        Font = Enum.Font.Gotham,
        TextSize = 14,
        TextColor3 = Color3.fromRGB(210,210,210),
        TextXAlignment = Enum.TextXAlignment.Left,
        AutoButtonColor = true,
        Name = name.."Btn"
    })
    new("UICorner", {Parent = btn, CornerRadius = UDim.new(0, 6)})
    return btn
end

-- Add sidebar items (only "Farm" for now)
local btnFarm = createMenuButton("Farm")
local btnSettings = createMenuButton("Settings")
local btnAbout = createMenuButton("About")

-- Main content panel
local content = new("Frame", {
    Parent = main,
    BackgroundColor3 = Color3.fromRGB(18,18,20),
    Size = UDim2.new(1, -240, 1, -20),
    Position = UDim2.new(0, 230, 0, 10),
})
new("UICorner", {Parent = content, CornerRadius = UDim.new(0, 8)})

-- Title bar inside content
local title = new("TextLabel", {
    Parent = content,
    BackgroundTransparency = 1,
    Position = UDim2.new(0, 12, 0, 10),
    Size = UDim2.new(1, -24, 0, 30),
    Text = "Farm",
    Font = Enum.Font.GothamBold,
    TextSize = 18,
    TextColor3 = Color3.fromRGB(235,235,235),
    TextXAlignment = Enum.TextXAlignment.Left,
})

-- Separator
local sep = new("Frame", {
    Parent = content,
    BackgroundColor3 = Color3.fromRGB(40,40,40),
    Size = UDim2.new(1, -24, 0, 2),
    Position = UDim2.new(0, 12, 0, 45),
})
new("UICorner", {Parent = sep, CornerRadius = UDim.new(0, 2)})

-- Body area
local body = new("Frame", {
    Parent = content,
    BackgroundTransparency = 1,
    Position = UDim2.new(0, 12, 0, 60),
    Size = UDim2.new(1, -24, 1, -72),
})

-- Label & description
local desc = new("TextLabel", {
    Parent = body,
    BackgroundTransparency = 1,
    Position = UDim2.new(0,0,0,0),
    Size = UDim2.new(1, 0, 0, 28),
    Text = "Auto Farm: otomatis memanen / memancing (implementasi game-specific di doAutoFarm()).",
    Font = Enum.Font.Gotham,
    TextSize = 14,
    TextColor3 = Color3.fromRGB(180,180,180),
    TextWrapped = true,
    TextXAlignment = Enum.TextXAlignment.Left,
})

-- Toggle container
local toggleFrame = new("Frame", {
    Parent = body,
    BackgroundTransparency = 1,
    Position = UDim2.new(0, 0, 0, 36),
    Size = UDim2.new(0, 300, 0, 48),
})
local toggleLabel = new("TextLabel", {
    Parent = toggleFrame,
    BackgroundTransparency = 1,
    Position = UDim2.new(0, 0, 0, 0),
    Size = UDim2.new(0, 200, 1, 0),
    Text = "Auto Farm",
    Font = Enum.Font.Gotham,
    TextSize = 16,
    TextColor3 = Color3.fromRGB(230,230,230),
    TextXAlignment = Enum.TextXAlignment.Left
})

local toggleBtn = new("TextButton", {
    Parent = toggleFrame,
    BackgroundColor3 = Color3.fromRGB(55, 120, 55),
    Position = UDim2.new(0, 220, 0, 6),
    Size = UDim2.new(0, 70, 0, 36),
    Text = "OFF",
    Font = Enum.Font.GothamBold,
    TextSize = 16,
    TextColor3 = Color3.fromRGB(240,240,240),
    AutoButtonColor = true
})
new("UICorner", {Parent = toggleBtn, CornerRadius = UDim.new(0, 6)})

-- Status label
local statusLabel = new("TextLabel", {
    Parent = body,
    BackgroundTransparency = 1,
    Position = UDim2.new(0, 0, 0, 96),
    Size = UDim2.new(1, 0, 0, 26),
    Text = "Status: Idle",
    Font = Enum.Font.Gotham,
    TextSize = 14,
    TextColor3 = Color3.fromRGB(165,165,165),
    TextXAlignment = Enum.TextXAlignment.Left
})

-- ================
-- Auto Farm Logic
-- ================
local autoFarmEnabled = false
local autoFarmTask = nil

-- Place your game-specific actions inside this function.
-- EXAMPLE (pseudo):
-- 1) Find object to interact with (rod, crop, etc.)
-- 2) FireRemote or simulate input
-- 3) Wait appropriate time
-- IMPORTANT: Do not paste server-exploiting code here if you don't understand it.
local function doAutoFarm()
    -- << IMPLEMENT GAME-SPECIFIC ACTIONS HERE >>
    -- Example pseudo-action (commented out):
    -- local rep = game:GetService("ReplicatedStorage")
    -- local remote = rep:WaitForChild("RemoteEventName")
    -- remote:FireServer(someArgs)
    --
    -- For demo we just print:
    print("[AutoFarm] Running auto farm action for player:", player.Name)
end

-- Background loop that runs while enabled
local function autoFarmLoop()
    while autoFarmEnabled do
        statusLabel.Text = "Status: Running"
        pcall(function()
            doAutoFarm()
        end)
        -- WAIT between actions to avoid spamming; tune per game
        task.wait(3)  -- default 3 sec; change as needed
    end
    statusLabel.Text = "Status: Idle"
end

-- Toggle button behavior
toggleBtn.MouseButton1Click:Connect(function()
    autoFarmEnabled = not autoFarmEnabled
    if autoFarmEnabled then
        toggleBtn.BackgroundColor3 = Color3.fromRGB(180, 60, 60)
        toggleBtn.Text = "ON"
        statusLabel.Text = "Status: Starting..."
        autoFarmTask = task.spawn(autoFarmLoop)
    else
        toggleBtn.BackgroundColor3 = Color3.fromRGB(55, 120, 55)
        toggleBtn.Text = "OFF"
        statusLabel.Text = "Status: Stopping..."
        -- loop will exit naturally
    end
end)

-- Sidebar button clicks -> switch content title (simple)
btnFarm.MouseButton1Click:Connect(function()
    title.Text = "Farm"
    desc.Text = "Auto Farm: otomatis memanen / memancing (implementasi game-specific di doAutoFarm())."
end)
btnSettings.MouseButton1Click:Connect(function()
    title.Text = "Settings"
    desc.Text = "Pengaturan: (tidak ada opsi saat ini)."
end)
btnAbout.MouseButton1Click:Connect(function()
    title.Text = "About"
    desc.Text = "Simple dashboard template — tambahkan fiturmu sendiri di doAutoFarm()."
end)

-- Initial state
toggleBtn.Text = "OFF"
statusLabel.Text = "Status: Idle"
