local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")

local player = Players.LocalPlayer

-- إعدادات الواجهة
local minimized = false
local dragging = false
local dragInput, dragStart, startPos

-- إعدادات السكربتات
local autoAttackEnabled = {phoenix = false, flame = false}
local teleportEnabled = false
local savedPosition = nil

-- إنشاء الواجهة الرئيسية
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "ProfessionalHUB"
ScreenGui.Parent = player.PlayerGui

local MainContainer = Instance.new("Frame")
MainContainer.Size = UDim2.new(0, 350, 0, 500)
MainContainer.Position = UDim2.new(0, 10, 0, 10)
MainContainer.BackgroundColor3 = Color3.fromRGB(25, 25, 35)
MainContainer.BorderSizePixel = 0
MainContainer.ClipsDescendants = true
MainContainer.Parent = ScreenGui

-- شريط العنوان
local TitleBar = Instance.new("Frame")
TitleBar.Size = UDim2.new(1, 0, 0, 40)
TitleBar.Position = UDim2.new(0, 0, 0, 0)
TitleBar.BackgroundColor3 = Color3.fromRGB(35, 35, 45)
TitleBar.Parent = MainContainer

local TitleLabel = Instance.new("TextLabel")
TitleLabel.Size = UDim2.new(0.7, 0, 1, 0)
TitleLabel.Position = UDim2.new(0, 10, 0, 0)
TitleLabel.BackgroundTransparency = 1
TitleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
TitleLabel.Text = "Glory Hub ( Cooked With Rui )"
TitleLabel.Font = Enum.Font.GothamBold
TitleLabel.TextSize = 16
TitleLabel.Parent = TitleBar

local MinimizeButton = Instance.new("TextButton")
MinimizeButton.Size = UDim2.new(0, 30, 0, 30)
MinimizeButton.Position = UDim2.new(1, -70, 0.5, -15)
MinimizeButton.BackgroundColor3 = Color3.fromRGB(60, 60, 80)
MinimizeButton.TextColor3 = Color3.fromRGB(255, 255, 255)
MinimizeButton.Text = "_"
MinimizeButton.Font = Enum.Font.GothamBold
MinimizeButton.TextSize = 16
MinimizeButton.Parent = TitleBar

local CloseButton = Instance.new("TextButton")
CloseButton.Size = UDim2.new(0, 30, 0, 30)
CloseButton.Position = UDim2.new(1, -35, 0.5, -15)
CloseButton.BackgroundColor3 = Color3.fromRGB(200, 60, 60)
CloseButton.TextColor3 = Color3.fromRGB(255, 255, 255)
CloseButton.Text = "X"
CloseButton.Font = Enum.Font.GothamBold
CloseButton.TextSize = 14
CloseButton.Parent = TitleBar

-- المحتوى الرئيسي
local ContentFrame = Instance.new("Frame")
ContentFrame.Size = UDim2.new(1, 0, 1, -40)
ContentFrame.Position = UDim2.new(0, 0, 0, 40)
ContentFrame.BackgroundTransparency = 1
ContentFrame.Parent = MainContainer

-- قسم الأوتو أتاك
local AutoAttackSection = Instance.new("Frame")
AutoAttackSection.Size = UDim2.new(1, -20, 0, 120)
AutoAttackSection.Position = UDim2.new(0, 10, 0, 10)
AutoAttackSection.BackgroundColor3 = Color3.fromRGB(35, 35, 45)
AutoAttackSection.BorderSizePixel = 0
AutoAttackSection.Parent = ContentFrame

local SectionTitle1 = Instance.new("TextLabel")
SectionTitle1.Size = UDim2.new(1, 0, 0, 30)
SectionTitle1.Position = UDim2.new(0, 0, 0, 0)
SectionTitle1.BackgroundColor3 = Color3.fromRGB(45, 45, 55)
SectionTitle1.TextColor3 = Color3.fromRGB(255, 255, 255)
SectionTitle1.Text = "AUTO ATTACK"
SectionTitle1.Font = Enum.Font.GothamBold
SectionTitle1.TextSize = 14
SectionTitle1.Parent = AutoAttackSection

-- Phoenix Auto Attack
local PhoenixButton = Instance.new("TextButton")
PhoenixButton.Size = UDim2.new(0.45, 0, 0, 35)
PhoenixButton.Position = UDim2.new(0.025, 0, 0, 40)
PhoenixButton.BackgroundColor3 = Color3.fromRGB(200, 60, 60)
PhoenixButton.TextColor3 = Color3.fromRGB(255, 255, 255)
PhoenixButton.Text = "PHOENIX: OFF"
PhoenixButton.Font = Enum.Font.Gotham
PhoenixButton.TextSize = 12
PhoenixButton.Parent = AutoAttackSection

local PhoenixStatus = Instance.new("TextLabel")
PhoenixStatus.Size = UDim2.new(0.45, 0, 0, 20)
PhoenixStatus.Position = UDim2.new(0.025, 0, 0, 75)
PhoenixStatus.BackgroundTransparency = 1
PhoenixStatus.TextColor3 = Color3.fromRGB(255, 100, 100)
PhoenixStatus.Text = "STATUS: INACTIVE"
PhoenixStatus.Font = Enum.Font.Gotham
PhoenixStatus.TextSize = 10
PhoenixStatus.Parent = AutoAttackSection

-- Flame Auto Attack
local FlameButton = Instance.new("TextButton")
FlameButton.Size = UDim2.new(0.45, 0, 0, 35)
FlameButton.Position = UDim2.new(0.525, 0, 0, 40)
FlameButton.BackgroundColor3 = Color3.fromRGB(200, 60, 60)
FlameButton.TextColor3 = Color3.fromRGB(255, 255, 255)
FlameButton.Text = "FLAME: OFF"
FlameButton.Font = Enum.Font.Gotham
FlameButton.TextSize = 12
FlameButton.Parent = AutoAttackSection

local FlameStatus = Instance.new("TextLabel")
FlameStatus.Size = UDim2.new(0.45, 0, 0, 20)
FlameStatus.Position = UDim2.new(0.525, 0, 0, 75)
FlameStatus.BackgroundTransparency = 1
FlameStatus.TextColor3 = Color3.fromRGB(255, 100, 100)
FlameStatus.Text = "STATUS: INACTIVE"
FlameStatus.Font = Enum.Font.Gotham
FlameStatus.TextSize = 10
FlameStatus.Parent = AutoAttackSection

-- قسم التلبورت
local TeleportSection = Instance.new("Frame")
TeleportSection.Size = UDim2.new(1, -20, 0, 200)
TeleportSection.Position = UDim2.new(0, 10, 0, 140)
TeleportSection.BackgroundColor3 = Color3.fromRGB(35, 35, 45)
TeleportSection.BorderSizePixel = 0
TeleportSection.Parent = ContentFrame

local SectionTitle2 = Instance.new("TextLabel")
SectionTitle2.Size = UDim2.new(1, 0, 0, 30)
SectionTitle2.Position = UDim2.new(0, 0, 0, 0)
SectionTitle2.BackgroundColor3 = Color3.fromRGB(45, 45, 55)
SectionTitle2.TextColor3 = Color3.fromRGB(255, 255, 255)
SectionTitle2.Text = "TELEPORT TO ISLANDS"
SectionTitle2.Font = Enum.Font.GothamBold
SectionTitle2.TextSize = 14
SectionTitle2.Parent = TeleportSection

-- قائمة الجزر
local IslandsScroll = Instance.new("ScrollingFrame")
IslandsScroll.Size = UDim2.new(1, -10, 0, 140)
IslandsScroll.Position = UDim2.new(0, 5, 0, 35)
IslandsScroll.BackgroundColor3 = Color3.fromRGB(25, 25, 35)
IslandsScroll.CanvasSize = UDim2.new(0, 0, 0, 160)
IslandsScroll.ScrollBarThickness = 5
IslandsScroll.Parent = TeleportSection

-- أزرار الجزر
local islands = {
    {name = "Windmill", coords = CFrame.new(-277.27, 20.55, 471.69)},
    {name = "Emerald Town", coords = CFrame.new(-2083.18, 54.50, 1968.69)},
    {name = "Sand Town", coords = CFrame.new(1181.43, 24.55, 2818.59)},
    {name = "Autman Island", coords = CFrame.new(-1981.79, 18.75, -4125.25)}
}

for i, island in pairs(islands) do
    local IslandButton = Instance.new("TextButton")
    IslandButton.Size = UDim2.new(1, -10, 0, 35)
    IslandButton.Position = UDim2.new(0, 5, 0, (i-1)*40)
    IslandButton.BackgroundColor3 = Color3.fromRGB(60, 60, 80)
    IslandButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    IslandButton.Text = island.name
    IslandButton.Font = Enum.Font.Gotham
    IslandButton.TextSize = 12
    IslandButton.Parent = IslandsScroll
    
    IslandButton.MouseButton1Click:Connect(function()
        local character = player.Character
        if character and character:FindFirstChild("HumanoidRootPart") then
            character.HumanoidRootPart.CFrame = island.coords
            print("Teleported to: " .. island.name)
        end
    end)
end

-- قسم حفظ الموقع
local SaveSection = Instance.new("Frame")
SaveSection.Size = UDim2.new(1, -20, 0, 100)
SaveSection.Position = UDim2.new(0, 10, 0, 350)
SaveSection.BackgroundColor3 = Color3.fromRGB(35, 35, 45)
SaveSection.BorderSizePixel = 0
SaveSection.Parent = ContentFrame

local SectionTitle3 = Instance.new("TextLabel")
SectionTitle3.Size = UDim2.new(1, 0, 0, 30)
SectionTitle3.Position = UDim2.new(0, 0, 0, 0)
SectionTitle3.BackgroundColor3 = Color3.fromRGB(45, 45, 55)
SectionTitle3.TextColor3 = Color3.fromRGB(255, 255, 255)
SectionTitle3.Text = "POSITION SAVER"
SectionTitle3.Font = Enum.Font.GothamBold
SectionTitle3.TextSize = 14
SectionTitle3.Parent = SaveSection

local SaveButton = Instance.new("TextButton")
SaveButton.Size = UDim2.new(0.45, 0, 0, 35)
SaveButton.Position = UDim2.new(0.025, 0, 0, 40)
SaveButton.BackgroundColor3 = Color3.fromRGB(60, 120, 200)
SaveButton.TextColor3 = Color3.fromRGB(255, 255, 255)
SaveButton.Text = "SAVE LOCATION"
SaveButton.Font = Enum.Font.Gotham
SaveButton.TextSize = 12
SaveButton.Parent = SaveSection

local TeleportToggle = Instance.new("TextButton")
TeleportToggle.Size = UDim2.new(0.45, 0, 0, 35)
TeleportToggle.Position = UDim2.new(0.525, 0, 0, 40)
TeleportToggle.BackgroundColor3 = Color3.fromRGB(200, 60, 60)
TeleportToggle.TextColor3 = Color3.fromRGB(255, 255, 255)
TeleportToggle.Text = "AUTO TP: OFF"
TeleportToggle.Font = Enum.Font.Gotham
TeleportToggle.TextSize = 12
TeleportToggle.Parent = SaveSection

-- وظائف الأوتو أتاك
local function startPhoenixAttack()
    local args = {
        [1] = "PhoenixFruit",
        [2] = "PhoenixFruitSlash"
    }
    local remote = game:GetService("ReplicatedStorage"):WaitForChild("Source"):WaitForChild("Combat"):WaitForChild("Remotes"):WaitForChild("Activate")
    
    while autoAttackEnabled.phoenix do
        remote:InvokeServer(unpack(args))
        RunService.Heartbeat:Wait()
    end
end

local function startFlameAttack()
    local args = {
        [1] = "FlameFruit",
        [2] = "FlamePunch"
    }
    local remote = game:GetService("ReplicatedStorage"):WaitForChild("Source"):WaitForChild("Combat"):WaitForChild("Remotes"):WaitForChild("Activate")
    
    while autoAttackEnabled.flame do
        remote:InvokeServer(unpack(args))
        RunService.Heartbeat:Wait()
    end
end

-- وظائف حفظ الموقع
local function saveCurrentLocation()
    local character = player.Character
    if character and character:FindFirstChild("HumanoidRootPart") then
        savedPosition = character.HumanoidRootPart.CFrame
        print("Location saved!")
    end
end

local function autoTeleportLoop()
    while teleportEnabled do
        if savedPosition then
            local character = player.Character
            if character and character:FindFirstChild("HumanoidRootPart") then
                character.HumanoidRootPart.CFrame = savedPosition
            end
        end
        wait(5)
    end
end

-- الأحداث
PhoenixButton.MouseButton1Click:Connect(function()
    autoAttackEnabled.phoenix = not autoAttackEnabled.phoenix
    if autoAttackEnabled.phoenix then
        PhoenixButton.BackgroundColor3 = Color3.fromRGB(60, 200, 60)
        PhoenixButton.Text = "PHOENIX: ON"
        PhoenixStatus.Text = "STATUS: ACTIVE"
        PhoenixStatus.TextColor3 = Color3.fromRGB(100, 255, 100)
        coroutine.wrap(startPhoenixAttack)()
    else
        PhoenixButton.BackgroundColor3 = Color3.fromRGB(200, 60, 60)
        PhoenixButton.Text = "PHOENIX: OFF"
        PhoenixStatus.Text = "STATUS: INACTIVE"
        PhoenixStatus.TextColor3 = Color3.fromRGB(255, 100, 100)
    end
end)

FlameButton.MouseButton1Click:Connect(function()
    autoAttackEnabled.flame = not autoAttackEnabled.flame
    if autoAttackEnabled.flame then
        FlameButton.BackgroundColor3 = Color3.fromRGB(60, 200, 60)
        FlameButton.Text = "FLAME: ON"
        FlameStatus.Text = "STATUS: ACTIVE"
        FlameStatus.TextColor3 = Color3.fromRGB(100, 255, 100)
        coroutine.wrap(startFlameAttack)()
    else
        FlameButton.BackgroundColor3 = Color3.fromRGB(200, 60, 60)
        FlameButton.Text = "FLAME: OFF"
        FlameStatus.Text = "STATUS: INACTIVE"
        FlameStatus.TextColor3 = Color3.fromRGB(255, 100, 100)
    end
end)

SaveButton.MouseButton1Click:Connect(saveCurrentLocation)

TeleportToggle.MouseButton1Click:Connect(function()
    teleportEnabled = not teleportEnabled
    if teleportEnabled then
        TeleportToggle.BackgroundColor3 = Color3.fromRGB(60, 200, 60)
        TeleportToggle.Text = "AUTO TP: ON"
        coroutine.wrap(autoTeleportLoop)()
    else
        TeleportToggle.BackgroundColor3 = Color3.fromRGB(200, 60, 60)
        TeleportToggle.Text = "AUTO TP: OFF"
    end
end)

MinimizeButton.MouseButton1Click:Connect(function()
    minimized = not minimized
    if minimized then
        MainContainer.Size = UDim2.new(0, 350, 0, 40)
        MinimizeButton.Text = "+"
    else
        MainContainer.Size = UDim2.new(0, 350, 0, 500)
        MinimizeButton.Text = "_"
    end
end)

CloseButton.MouseButton1Click:Connect(function()
    ScreenGui:Destroy()
end)

-- جعل الواجهة قابلة للسحب
TitleBar.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = true
        dragStart = input.Position
        startPos = MainContainer.Position
        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then
                dragging = false
            end
        end)
    end
end)

TitleBar.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement then
        dragInput = input
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if dragging and input == dragInput then
        local delta = input.Position - dragStart
        MainContainer.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
    end
end)

print("Glory Loaded Successfully!")
