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
local autoAttackEnabled = {
    phoenix = false, 
    flame = false,
    ice = false,
    darkblade = false,
    combat = false
}
local teleportEnabled = false
local savedPosition = nil
local autoCollectEnabled = false
local infiniteJumpEnabled = false

-- إنشاء الواجهة الرئيسية
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "GloryHUB"
ScreenGui.Parent = player.PlayerGui

local MainContainer = Instance.new("Frame")
MainContainer.Size = UDim2.new(0, 380, 0, 500)
MainContainer.Position = UDim2.new(0, 10, 0, 10)
MainContainer.BackgroundColor3 = Color3.fromRGB(15, 15, 25)
MainContainer.BorderSizePixel = 0
MainContainer.ClipsDescendants = true
MainContainer.Parent = ScreenGui

-- شريط العنوان
local TitleBar = Instance.new("Frame")
TitleBar.Size = UDim2.new(1, 0, 0, 35)
TitleBar.Position = UDim2.new(0, 0, 0, 0)
TitleBar.BackgroundColor3 = Color3.fromRGB(25, 25, 35)
TitleBar.BorderSizePixel = 0
TitleBar.Parent = MainContainer

local TitleLabel = Instance.new("TextLabel")
TitleLabel.Size = UDim2.new(0.7, 0, 1, 0)
TitleLabel.Position = UDim2.new(0, 10, 0, 0)
TitleLabel.BackgroundTransparency = 1
TitleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
TitleLabel.Text = "Glory Hub"
TitleLabel.Font = Enum.Font.GothamBold
TitleLabel.TextSize = 16
TitleLabel.TextXAlignment = Enum.TextXAlignment.Left
TitleLabel.Parent = TitleBar

local MinimizeButton = Instance.new("TextButton")
MinimizeButton.Size = UDim2.new(0, 25, 0, 25)
MinimizeButton.Position = UDim2.new(1, -60, 0.5, -12)
MinimizeButton.BackgroundColor3 = Color3.fromRGB(40, 40, 60)
MinimizeButton.TextColor3 = Color3.fromRGB(255, 255, 255)
MinimizeButton.Text = "_"
MinimizeButton.Font = Enum.Font.GothamBold
MinimizeButton.TextSize = 14
MinimizeButton.Parent = TitleBar

local CloseButton = Instance.new("TextButton")
CloseButton.Size = UDim2.new(0, 25, 0, 25)
CloseButton.Position = UDim2.new(1, -30, 0.5, -12)
CloseButton.BackgroundColor3 = Color3.fromRGB(180, 60, 60)
CloseButton.TextColor3 = Color3.fromRGB(255, 255, 255)
CloseButton.Text = "×"
CloseButton.Font = Enum.Font.GothamBold
CloseButton.TextSize = 16
CloseButton.Parent = TitleBar

-- المحتوى الرئيسي
local ContentFrame = Instance.new("Frame")
ContentFrame.Size = UDim2.new(1, 0, 1, -35)
ContentFrame.Position = UDim2.new(0, 0, 0, 35)
ContentFrame.BackgroundTransparency = 1
ContentFrame.Parent = MainContainer

-- قسم الميزات الأساسية
local BasicFeaturesSection = Instance.new("Frame")
BasicFeaturesSection.Size = UDim2.new(1, -20, 0, 120)
BasicFeaturesSection.Position = UDim2.new(0, 10, 0, 10)
BasicFeaturesSection.BackgroundColor3 = Color3.fromRGB(25, 25, 35)
BasicFeaturesSection.BorderSizePixel = 0
BasicFeaturesSection.Parent = ContentFrame

local SectionTitle1 = Instance.new("TextLabel")
SectionTitle1.Size = UDim2.new(1, 0, 0, 25)
SectionTitle1.Position = UDim2.new(0, 0, 0, 0)
SectionTitle1.BackgroundColor3 = Color3.fromRGB(35, 35, 50)
SectionTitle1.TextColor3 = Color3.fromRGB(255, 255, 255)
SectionTitle1.Text = "Basic Features"
SectionTitle1.Font = Enum.Font.GothamBold
SectionTitle1.TextSize = 12
SectionTitle1.Parent = BasicFeaturesSection

-- Infinite Jump
local JumpButton = Instance.new("TextButton")
JumpButton.Size = UDim2.new(0.45, 0, 0, 30)
JumpButton.Position = UDim2.new(0.025, 0, 0, 30)
JumpButton.BackgroundColor3 = Color3.fromRGB(60, 80, 120)
JumpButton.TextColor3 = Color3.fromRGB(255, 255, 255)
JumpButton.Text = "Infinite Jump: OFF"
JumpButton.Font = Enum.Font.Gotham
JumpButton.TextSize = 10
JumpButton.Parent = BasicFeaturesSection

-- Auto Collect
local CollectButton = Instance.new("TextButton")
CollectButton.Size = UDim2.new(0.45, 0, 0, 30)
CollectButton.Position = UDim2.new(0.525, 0, 0, 30)
CollectButton.BackgroundColor3 = Color3.fromRGB(60, 80, 120)
CollectButton.TextColor3 = Color3.fromRGB(255, 255, 255)
CollectButton.Text = "Auto Collect: OFF"
CollectButton.Font = Enum.Font.Gotham
CollectButton.TextSize = 10
CollectButton.Parent = BasicFeaturesSection

-- Save Location
local SaveButton = Instance.new("TextButton")
SaveButton.Size = UDim2.new(0.45, 0, 0, 30)
SaveButton.Position = UDim2.new(0.025, 0, 0, 65)
SaveButton.BackgroundColor3 = Color3.fromRGB(80, 120, 180)
SaveButton.TextColor3 = Color3.fromRGB(255, 255, 255)
SaveButton.Text = "Save Location"
SaveButton.Font = Enum.Font.Gotham
SaveButton.TextSize = 10
SaveButton.Parent = BasicFeaturesSection

-- Auto TP
local TeleportToggle = Instance.new("TextButton")
TeleportToggle.Size = UDim2.new(0.45, 0, 0, 30)
TeleportToggle.Position = UDim2.new(0.525, 0, 0, 65)
TeleportToggle.BackgroundColor3 = Color3.fromRGB(60, 80, 120)
TeleportToggle.TextColor3 = Color3.fromRGB(255, 255, 255)
TeleportToggle.Text = "Auto TP: OFF"
TeleportToggle.Font = Enum.Font.Gotham
TeleportToggle.TextSize = 10
TeleportToggle.Parent = BasicFeaturesSection

-- قسم الأوتو أتاك
local AutoAttackSection = Instance.new("Frame")
AutoAttackSection.Size = UDim2.new(1, -20, 0, 150)
AutoAttackSection.Position = UDim2.new(0, 10, 0, 140)
AutoAttackSection.BackgroundColor3 = Color3.fromRGB(25, 25, 35)
AutoAttackSection.BorderSizePixel = 0
AutoAttackSection.Parent = ContentFrame

local SectionTitle2 = Instance.new("TextLabel")
SectionTitle2.Size = UDim2.new(1, 0, 0, 25)
SectionTitle2.Position = UDim2.new(0, 0, 0, 0)
SectionTitle2.BackgroundColor3 = Color3.fromRGB(35, 35, 50)
SectionTitle2.TextColor3 = Color3.fromRGB(255, 255, 255)
SectionTitle2.Text = "Auto Attack"
SectionTitle2.Font = Enum.Font.GothamBold
SectionTitle2.TextSize = 12
SectionTitle2.Parent = AutoAttackSection

-- شبكة أزرار الهجوم
local attackButtons = {
    {name = "PHOENIX", key = "phoenix", color = Color3.fromRGB(180, 60, 60), pos = UDim2.new(0.025, 0, 0, 30)},
    {name = "FLAME", key = "flame", color = Color3.fromRGB(200, 80, 40), pos = UDim2.new(0.525, 0, 0, 30)},
    {name = "ICE", key = "ice", color = Color3.fromRGB(70, 160, 200), pos = UDim2.new(0.025, 0, 0, 65)},
    {name = "DARK BLADE", key = "darkblade", color = Color3.fromRGB(110, 40, 140), pos = UDim2.new(0.525, 0, 0, 65)},
    {name = "COMBAT", key = "combat", color = Color3.fromRGB(50, 140, 70), pos = UDim2.new(0.275, 0, 0, 100)}
}

local attackStatusLabels = {}

for i, attack in ipairs(attackButtons) do
    local AttackButton = Instance.new("TextButton")
    AttackButton.Size = UDim2.new(0.45, 0, 0, 30)
    AttackButton.Position = attack.pos
    AttackButton.BackgroundColor3 = attack.color
    AttackButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    AttackButton.Text = attack.name .. ": OFF"
    AttackButton.Font = Enum.Font.Gotham
    AttackButton.TextSize = 9
    AttackButton.Parent = AutoAttackSection
    
    attackButtons[i].button = AttackButton
end

-- قسم التلبورت
local TeleportSection = Instance.new("Frame")
TeleportSection.Size = UDim2.new(1, -20, 0, 180)
TeleportSection.Position = UDim2.new(0, 10, 0, 300)
TeleportSection.BackgroundColor3 = Color3.fromRGB(25, 25, 35)
TeleportSection.BorderSizePixel = 0
TeleportSection.Parent = ContentFrame

local SectionTitle3 = Instance.new("TextLabel")
SectionTitle3.Size = UDim2.new(1, 0, 0, 25)
SectionTitle3.Position = UDim2.new(0, 0, 0, 0)
SectionTitle3.BackgroundColor3 = Color3.fromRGB(35, 35, 50)
SectionTitle3.TextColor3 = Color3.fromRGB(255, 255, 255)
SectionTitle3.Text = "Teleport to Islands"
SectionTitle3.Font = Enum.Font.GothamBold
SectionTitle3.TextSize = 12
SectionTitle3.Parent = TeleportSection

-- قائمة الجزر
local IslandsScroll = Instance.new("ScrollingFrame")
IslandsScroll.Size = UDim2.new(1, -10, 0, 145)
IslandsScroll.Position = UDim2.new(0, 5, 0, 30)
IslandsScroll.BackgroundColor3 = Color3.fromRGB(20, 20, 30)
IslandsScroll.CanvasSize = UDim2.new(0, 0, 0, 0)
IslandsScroll.ScrollBarThickness = 4
IslandsScroll.Parent = TeleportSection

-- أزرار الجزر
local islands = {
    {name = "Windmill", coords = CFrame.new(-277.27, 20.55, 471.69)},
    {name = "Emerald Town", coords = CFrame.new(-2083.18, 54.50, 1968.69)},
    {name = "Sand Town", coords = CFrame.new(1181.43, 24.55, 2818.59)},
    {name = "Autman Island", coords = CFrame.new(-1981.79, 18.75, -4125.25)},
    {name = "Sky Sanctuary", coords = CFrame.new(-2747.15, 3237.55, -567.84)},
    {name = "Wild Savannah", coords = CFrame.new(-5764.85, 19.05, 5048.55)},
    {name = "Soggy Swamp", coords = CFrame.new(4832.36, 37.45, -730.19)},
    {name = "Marine Base", coords = CFrame.new(-6302.85, 11.55, -4121.51)},
    {name = "Glacier Square", coords = CFrame.new(-5919.62, 43.55, 177.82)},
    {name = "Cloud Freighter", coords = CFrame.new(2753.04, 3240.12, -5924.56)}
}

for i, island in pairs(islands) do
    local IslandButton = Instance.new("TextButton")
    IslandButton.Size = UDim2.new(1, -10, 0, 30)
    IslandButton.Position = UDim2.new(0, 5, 0, (i-1)*33)
    IslandButton.BackgroundColor3 = Color3.fromRGB(40, 50, 70)
    IslandButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    IslandButton.Text = island.name
    IslandButton.Font = Enum.Font.Gotham
    IslandButton.TextSize = 10
    IslandButton.Parent = IslandsScroll
    
    IslandButton.MouseButton1Click:Connect(function()
        local character = player.Character
        if character and character:FindFirstChild("HumanoidRootPart") then
            character.HumanoidRootPart.CFrame = island.coords
            print("🌴 Teleported to: " .. island.name)
        end
    end)
end

IslandsScroll.CanvasSize = UDim2.new(0, 0, 0, #islands * 33)

-- وظائف الأوتو أتاك
local attackFunctions = {
    phoenix = function()
        local args = {[1] = "PhoenixFruit", [2] = "PhoenixFruitSlash"}
        local remote = game:GetService("ReplicatedStorage"):WaitForChild("Source"):WaitForChild("Combat"):WaitForChild("Remotes"):WaitForChild("Activate")
        while autoAttackEnabled.phoenix do
            remote:InvokeServer(unpack(args))
            RunService.Heartbeat:Wait()
        end
    end,
    
    flame = function()
        local args = {[1] = "FlameFruit", [2] = "FlamePunch"}
        local remote = game:GetService("ReplicatedStorage"):WaitForChild("Source"):WaitForChild("Combat"):WaitForChild("Remotes"):WaitForChild("Activate")
        while autoAttackEnabled.flame do
            remote:InvokeServer(unpack(args))
            RunService.Heartbeat:Wait()
        end
    end,
    
    ice = function()
        local args = {[1] = "IceFruit", [2] = "IceFruitSlash"}
        local remote = game:GetService("ReplicatedStorage"):WaitForChild("Source"):WaitForChild("Combat"):WaitForChild("Remotes"):WaitForChild("Activate")
        while autoAttackEnabled.ice do
            remote:InvokeServer(unpack(args))
            RunService.Heartbeat:Wait()
        end
    end,
    
    darkblade = function()
        local args = {[1] = "DarkBlade", [2] = "DarkBladeSwing"}
        local remote = game:GetService("ReplicatedStorage"):WaitForChild("Source"):WaitForChild("Combat"):WaitForChild("Remotes"):WaitForChild("Activate")
        while autoAttackEnabled.darkblade do
            remote:InvokeServer(unpack(args))
            RunService.Heartbeat:Wait()
        end
    end,
    
    combat = function()
        local args = {[1] = "Combat", [2] = "Punch"}
        local remote = game:GetService("ReplicatedStorage"):WaitForChild("Source"):WaitForChild("Combat"):WaitForChild("Remotes"):WaitForChild("Activate")
        while autoAttackEnabled.combat do
            remote:InvokeServer(unpack(args))
            RunService.Heartbeat:Wait()
        end
    end
}

-- وظيفة الإنفنت جمب
local function setupInfiniteJump()
    UserInputService.JumpRequest:connect(function()
        if infiniteJumpEnabled and player.Character and player.Character:FindFirstChildOfClass("Humanoid") then
            player.Character:FindFirstChildOfClass("Humanoid"):ChangeState("Jumping")
        end
    end)
end

-- وظيفة الأوتو كولكت
local function startAutoCollect()
    local function getFolderFromPath(path)
        local current = game
        for _, name in ipairs(string.split(path, ".")) do
            current = current:FindFirstChild(name)
            if not current then return nil end
        end
        return current
    end

    local function findTargetPart()
        for _, obj in ipairs(workspace:GetDescendants()) do
            if obj.Name == "Keyhole" and obj:IsA("BasePart") then
                return obj
            end
        end
        return nil
    end

    local function teleportToPart(targetPart)
        if player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
            local humanoidRootPart = player.Character.HumanoidRootPart
            humanoidRootPart.CFrame = targetPart.CFrame + Vector3.new(0, 3, 0)
        end
    end

    local function checkChests()
        if not autoCollectEnabled then return end
        
        local chestsFolder = getFolderFromPath("Workspace.Chests")
        local targetPart = findTargetPart()
        
        if not chestsFolder or not targetPart then return end
        
        for _, chest in ipairs(chestsFolder:GetChildren()) do
            if chest:IsA("BasePart") or chest:IsA("Model") then
                teleportToPart(targetPart)
                break
            end
        end
    end

    local lastCheck = 0
    while autoCollectEnabled do
        lastCheck = lastCheck + RunService.Heartbeat:Wait()
        if lastCheck >= 1 then
            checkChests()
            lastCheck = 0
        end
    end
end

-- وظائف حفظ الموقع
local function saveCurrentLocation()
    local character = player.Character
    if character and character:FindFirstChild("HumanoidRootPart") then
        savedPosition = character.HumanoidRootPart.CFrame
        print("💾 Location saved!")
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

-- أحداث الأزرار
for _, attack in ipairs(attackButtons) do
    attack.button.MouseButton1Click:Connect(function()
        autoAttackEnabled[attack.key] = not autoAttackEnabled[attack.key]
        if autoAttackEnabled[attack.key] then
            attack.button.BackgroundColor3 = Color3.fromRGB(60, 180, 60)
            attack.button.Text = attack.name .. ": ON"
            coroutine.wrap(attackFunctions[attack.key])()
        else
            attack.button.BackgroundColor3 = attack.color
            attack.button.Text = attack.name .. ": OFF"
        end
    end)
end

JumpButton.MouseButton1Click:Connect(function()
    infiniteJumpEnabled = not infiniteJumpEnabled
    if infiniteJumpEnabled then
        JumpButton.BackgroundColor3 = Color3.fromRGB(60, 180, 60)
        JumpButton.Text = "Infinite Jump: ON"
    else
        JumpButton.BackgroundColor3 = Color3.fromRGB(60, 80, 120)
        JumpButton.Text = "Infinite Jump: OFF"
    end
end)

CollectButton.MouseButton1Click:Connect(function()
    autoCollectEnabled = not autoCollectEnabled
    if autoCollectEnabled then
        CollectButton.BackgroundColor3 = Color3.fromRGB(60, 180, 60)
        CollectButton.Text = "Auto Collect: ON"
        coroutine.wrap(startAutoCollect)()
    else
        CollectButton.BackgroundColor3 = Color3.fromRGB(60, 80, 120)
        CollectButton.Text = "Auto Collect: OFF"
    end
end)

SaveButton.MouseButton1Click:Connect(saveCurrentLocation)

TeleportToggle.MouseButton1Click:Connect(function()
    teleportEnabled = not teleportEnabled
    if teleportEnabled then
        TeleportToggle.BackgroundColor3 = Color3.fromRGB(60, 180, 60)
        TeleportToggle.Text = "Auto TP: ON"
        coroutine.wrap(autoTeleportLoop)()
    else
        TeleportToggle.BackgroundColor3 = Color3.fromRGB(60, 80, 120)
        TeleportToggle.Text = "Auto TP: OFF"
    end
end)

MinimizeButton.MouseButton1Click:Connect(function()
    minimized = not minimized
    if minimized then
        MainContainer.Size = UDim2.new(0, 380, 0, 35)
        MinimizeButton.Text = "+"
    else
        MainContainer.Size = UDim2.new(0, 380, 0, 500)
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

-- إعداد الإنفنت جمب
setupInfiniteJump()

print("🌟 Glory Hub Loaded Successfully!")
