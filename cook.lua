local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")

local player = Players.LocalPlayer

-- إعدادات الواجهة
local minimized = false
local dragging = false
local dragInput, dragStart, startPos
local currentTab = "Basic"

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
local autoFarmEnabled = false
local autoQuestEnabled = false
local phoenixSpamEnabled = false

-- بيانات الجزر
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
    {name = "Cloud Freighter", coords = CFrame.new(2753.04, 3240.12, -5924.56)},
    {name = "Kraken", coords = CFrame.new(1968.95, 65.50, -1088.39)},
    {name = "Kraken 2", coords = CFrame.new(-8499.34, 46.39, -2131.29)},
    {name = "Kraken 3", coords = CFrame.new(218.69, 1.59, -5963.01)}
}

-- أنواع الأعداء للأوتو فارم
local enemyTypes = {
    "Thieves",
    "EliteThieves",
    "ForestElves",
    "Bandits", 
    "EliteBandits",
    "CorruptGuards",
    "CorruptSoldiers",
    "Wildling",
    "EliteWildling",
    "Alligators",
    "Frogs",
    "MarineRecruits",
    "MarineOfficers",
    "Zebra",
    "Rhinos",
    "Tigers",
    "SkyPirates",
    "EliteSkyPirates",
    "Pirates",
    "DarkWizards", -- تم التصحيح من Wizards إلى DarkWizards
    "Witches"
}

-- أنواع الكويستات
local questTypes = {
    "Thieves",
    "EliteThieves", 
    "Bandits",
    "EliteBandits",
    "CorruptGuards",
    "CorruptSoldiers",
    "DarkWizards", -- تم التصحيح من Wizards إلى DarkWizards
    "Witches",
    "Wizards",
    "Zebras",
    "Rhinos",
    "Tigers",
    "MarineRecruits",
    "MarineOfficers",
    "SkyPirates",
    "Pirates",
    "EliteSkyPirates",
    "Wildling",
    "EliteWildling",
    "ForestElves",
    "Alligators"
}

-- إنشاء الواجهة الرئيسية مع إصلاح مشكلة الموت
local function CreateMainUI()
    local ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Name = "GloryHUB"
    ScreenGui.ResetOnSpawn = false
    ScreenGui.Parent = player.PlayerGui

    local MainContainer = Instance.new("Frame")
    MainContainer.Size = UDim2.new(0, 450, 0, 500)
    MainContainer.Position = UDim2.new(0, 10, 0, 10)
    MainContainer.BackgroundColor3 = Color3.fromRGB(15, 15, 25)
    MainContainer.BorderSizePixel = 1
    MainContainer.BorderColor3 = Color3.fromRGB(50, 50, 70)
    MainContainer.ClipsDescendants = true
    MainContainer.Parent = ScreenGui

    -- شريط العنوان
    local TitleBar = Instance.new("Frame")
    TitleBar.Size = UDim2.new(1, 0, 0, 35)
    TitleBar.Position = UDim2.new(0, 0, 0, 0)
    TitleBar.BackgroundColor3 = Color3.fromRGB(25, 25, 40)
    TitleBar.BorderSizePixel = 0
    TitleBar.Parent = MainContainer

    local TitleLabel = Instance.new("TextLabel")
    TitleLabel.Size = UDim2.new(0.7, 0, 1, 0)
    TitleLabel.Position = UDim2.new(0, 10, 0, 0)
    TitleLabel.BackgroundTransparency = 1
    TitleLabel.TextColor3 = Color3.fromRGB(220, 220, 255)
    TitleLabel.Text = "🌟 GLORY HUB"
    TitleLabel.Font = Enum.Font.GothamBold
    TitleLabel.TextSize = 16
    TitleLabel.TextXAlignment = Enum.TextXAlignment.Left
    TitleLabel.Parent = TitleBar

    local MinimizeButton = Instance.new("TextButton")
    MinimizeButton.Size = UDim2.new(0, 25, 0, 25)
    MinimizeButton.Position = UDim2.new(1, -60, 0.5, -12)
    MinimizeButton.BackgroundColor3 = Color3.fromRGB(40, 40, 60)
    MinimizeButton.TextColor3 = Color3.fromRGB(200, 200, 255)
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

    -- شريط التبويبات
    local TabBar = Instance.new("Frame")
    TabBar.Size = UDim2.new(1, 0, 0, 40)
    TabBar.Position = UDim2.new(0, 0, 0, 35)
    TabBar.BackgroundColor3 = Color3.fromRGB(20, 20, 30)
    TabBar.BorderSizePixel = 0
    TabBar.Parent = MainContainer

    -- أزرار التبويبات
    local tabs = {
        {name = "🛠️ Basic", key = "Basic"},
        {name = "⚔️ Attack", key = "Attack"},
        {name = "🌴 Teleport", key = "Teleport"},
        {name = "🎯 Auto Farm", key = "Farm"},
        {name = "📋 Auto Quest", key = "Quest"},
        {name = "🔥 Phoenix", key = "Phoenix"}
    }

    local tabButtons = {}
    for i, tab in ipairs(tabs) do
        local TabButton = Instance.new("TextButton")
        TabButton.Size = UDim2.new(1/#tabs, 0, 1, 0)
        TabButton.Position = UDim2.new((i-1)/#tabs, 0, 0, 0)
        TabButton.BackgroundColor3 = Color3.fromRGB(30, 30, 45)
        TabButton.TextColor3 = Color3.fromRGB(150, 150, 200)
        TabButton.Text = tab.name
        TabButton.Font = Enum.Font.Gotham
        TabButton.TextSize = 11
        TabButton.Parent = TabBar
        tabButtons[tab.key] = TabButton
    end

    -- المحتوى الرئيسي
    local ContentFrame = Instance.new("Frame")
    ContentFrame.Size = UDim2.new(1, 0, 1, -75)
    ContentFrame.Position = UDim2.new(0, 0, 0, 75)
    ContentFrame.BackgroundTransparency = 1
    ContentFrame.Parent = MainContainer

    -- إنشاء جميع التبويبات
    local tabFrames = {}

    -- تبويب Basic
    local BasicTab = Instance.new("Frame")
    BasicTab.Size = UDim2.new(1, 0, 1, 0)
    BasicTab.BackgroundTransparency = 1
    BasicTab.Visible = true
    BasicTab.Parent = ContentFrame
    tabFrames["Basic"] = BasicTab

    -- الميزات الأساسية
    local BasicSection = Instance.new("Frame")
    BasicSection.Size = UDim2.new(1, -10, 0, 160)
    BasicSection.Position = UDim2.new(0, 5, 0, 5)
    BasicSection.BackgroundColor3 = Color3.fromRGB(20, 20, 30)
    BasicSection.BorderSizePixel = 1
    BasicSection.BorderColor3 = Color3.fromRGB(40, 40, 60)
    BasicSection.Parent = BasicTab

    local SectionTitle1 = Instance.new("TextLabel")
    SectionTitle1.Size = UDim2.new(1, 0, 0, 25)
    SectionTitle1.Position = UDim2.new(0, 0, 0, 0)
    SectionTitle1.BackgroundColor3 = Color3.fromRGB(30, 30, 45)
    SectionTitle1.TextColor3 = Color3.fromRGB(200, 200, 255)
    SectionTitle1.Text = "🛠️ BASIC FEATURES"
    SectionTitle1.Font = Enum.Font.GothamBold
    SectionTitle1.TextSize = 12
    SectionTitle1.Parent = BasicSection

    -- Infinite Jump
    local JumpButton = Instance.new("TextButton")
    JumpButton.Size = UDim2.new(0.48, 0, 0, 30)
    JumpButton.Position = UDim2.new(0.01, 0, 0, 30)
    JumpButton.BackgroundColor3 = Color3.fromRGB(40, 40, 60)
    JumpButton.TextColor3 = Color3.fromRGB(200, 200, 255)
    JumpButton.Text = "INFINITE JUMP: OFF"
    JumpButton.Font = Enum.Font.Gotham
    JumpButton.TextSize = 10
    JumpButton.Parent = BasicSection

    -- Auto Collect
    local CollectButton = Instance.new("TextButton")
    CollectButton.Size = UDim2.new(0.48, 0, 0, 30)
    CollectButton.Position = UDim2.new(0.51, 0, 0, 30)
    CollectButton.BackgroundColor3 = Color3.fromRGB(40, 40, 60)
    CollectButton.TextColor3 = Color3.fromRGB(200, 200, 255)
    CollectButton.Text = "AUTO COLLECT: OFF"
    CollectButton.Font = Enum.Font.Gotham
    CollectButton.TextSize = 10
    CollectButton.Parent = BasicSection

    -- Save Location
    local SaveButton = Instance.new("TextButton")
    SaveButton.Size = UDim2.new(0.48, 0, 0, 30)
    SaveButton.Position = UDim2.new(0.01, 0, 0, 65)
    SaveButton.BackgroundColor3 = Color3.fromRGB(50, 80, 120)
    SaveButton.TextColor3 = Color3.fromRGB(200, 200, 255)
    SaveButton.Text = "💾 SAVE LOCATION"
    SaveButton.Font = Enum.Font.Gotham
    SaveButton.TextSize = 10
    SaveButton.Parent = BasicSection

    -- Auto TP
    local TeleportToggle = Instance.new("TextButton")
    TeleportToggle.Size = UDim2.new(0.48, 0, 0, 30)
    TeleportToggle.Position = UDim2.new(0.51, 0, 0, 65)
    TeleportToggle.BackgroundColor3 = Color3.fromRGB(40, 40, 60)
    TeleportToggle.TextColor3 = Color3.fromRGB(200, 200, 255)
    TeleportToggle.Text = "🔄 AUTO TP: OFF"
    TeleportToggle.Font = Enum.Font.Gotham
    TeleportToggle.TextSize = 10
    TeleportToggle.Parent = BasicSection

    -- Status Display
    local StatusLabel = Instance.new("TextLabel")
    StatusLabel.Size = UDim2.new(0.98, 0, 0, 40)
    StatusLabel.Position = UDim2.new(0.01, 0, 0, 100)
    StatusLabel.BackgroundTransparency = 1
    StatusLabel.TextColor3 = Color3.fromRGB(150, 150, 200)
    StatusLabel.Text = "Status: All systems ready"
    StatusLabel.Font = Enum.Font.Gotham
    StatusLabel.TextSize = 10
    StatusLabel.TextXAlignment = Enum.TextXAlignment.Left
    StatusLabel.TextYAlignment = Enum.TextYAlignment.Top
    StatusLabel.Parent = BasicSection

    -- تبويب Attack
    local AttackTab = Instance.new("Frame")
    AttackTab.Size = UDim2.new(1, 0, 1, 0)
    AttackTab.BackgroundTransparency = 1
    AttackTab.Visible = false
    AttackTab.Parent = ContentFrame
    tabFrames["Attack"] = AttackTab

    local AttackSection = Instance.new("Frame")
    AttackSection.Size = UDim2.new(1, -10, 1, -10)
    AttackSection.Position = UDim2.new(0, 5, 0, 5)
    AttackSection.BackgroundColor3 = Color3.fromRGB(20, 20, 30)
    AttackSection.BorderSizePixel = 1
    AttackSection.BorderColor3 = Color3.fromRGB(40, 40, 60)
    AttackSection.Parent = AttackTab

    local SectionTitle2 = Instance.new("TextLabel")
    SectionTitle2.Size = UDim2.new(1, 0, 0, 25)
    SectionTitle2.Position = UDim2.new(0, 0, 0, 0)
    SectionTitle2.BackgroundColor3 = Color3.fromRGB(30, 30, 45)
    SectionTitle2.TextColor3 = Color3.fromRGB(200, 200, 255)
    SectionTitle2.Text = "⚔️ AUTO ATTACK"
    SectionTitle2.Font = Enum.Font.GothamBold
    SectionTitle2.TextSize = 12
    SectionTitle2.Parent = AttackSection

    -- أزرار الهجوم
    local attackButtons = {
        {name = "PHOENIX", key = "phoenix", pos = UDim2.new(0.01, 0, 0, 30)},
        {name = "FLAME", key = "flame", pos = UDim2.new(0.51, 0, 0, 30)},
        {name = "ICE", key = "ice", pos = UDim2.new(0.01, 0, 0, 65)},
        {name = "DARK BLADE", key = "darkblade", pos = UDim2.new(0.51, 0, 0, 65)},
        {name = "COMBAT", key = "combat", pos = UDim2.new(0.26, 0, 0, 100)}
    }

    for i, attack in ipairs(attackButtons) do
        local AttackButton = Instance.new("TextButton")
        AttackButton.Size = UDim2.new(0.48, 0, 0, 30)
        AttackButton.Position = attack.pos
        AttackButton.BackgroundColor3 = Color3.fromRGB(40, 40, 60)
        AttackButton.TextColor3 = Color3.fromRGB(200, 200, 255)
        AttackButton.Text = attack.name .. ": OFF"
        AttackButton.Font = Enum.Font.Gotham
        AttackButton.TextSize = 9
        AttackButton.Parent = AttackSection
        attackButtons[i].button = AttackButton
    end

    -- تبويب Teleport
    local TeleportTab = Instance.new("Frame")
    TeleportTab.Size = UDim2.new(1, 0, 1, 0)
    TeleportTab.BackgroundTransparency = 1
    TeleportTab.Visible = false
    TeleportTab.Parent = ContentFrame
    tabFrames["Teleport"] = TeleportTab

    local TeleportSection = Instance.new("Frame")
    TeleportSection.Size = UDim2.new(1, -10, 1, -10)
    TeleportSection.Position = UDim2.new(0, 5, 0, 5)
    TeleportSection.BackgroundColor3 = Color3.fromRGB(20, 20, 30)
    TeleportSection.BorderSizePixel = 1
    TeleportSection.BorderColor3 = Color3.fromRGB(40, 40, 60)
    TeleportSection.Parent = TeleportTab

    local SectionTitle3 = Instance.new("TextLabel")
    SectionTitle3.Size = UDim2.new(1, 0, 0, 25)
    SectionTitle3.Position = UDim2.new(0, 0, 0, 0)
    SectionTitle3.BackgroundColor3 = Color3.fromRGB(30, 30, 45)
    SectionTitle3.TextColor3 = Color3.fromRGB(200, 200, 255)
    SectionTitle3.Text = "🌴 TELEPORT TO ISLANDS"
    SectionTitle3.Font = Enum.Font.GothamBold
    SectionTitle3.TextSize = 12
    SectionTitle3.Parent = TeleportSection

    -- قائمة الجزر مع Scroll محسنة
    local IslandsScroll = Instance.new("ScrollingFrame")
    IslandsScroll.Size = UDim2.new(1, -10, 1, -40)
    IslandsScroll.Position = UDim2.new(0, 5, 0, 30)
    IslandsScroll.BackgroundColor3 = Color3.fromRGB(15, 15, 25)
    IslandsScroll.CanvasSize = UDim2.new(0, 0, 0, #islands * 35)
    IslandsScroll.ScrollBarThickness = 8
    IslandsScroll.ScrollBarImageColor3 = Color3.fromRGB(80, 80, 100)
    IslandsScroll.VerticalScrollBarInset = Enum.ScrollBarInset.Always
    IslandsScroll.Parent = TeleportSection

    for i, island in pairs(islands) do
        local IslandButton = Instance.new("TextButton")
        IslandButton.Size = UDim2.new(1, -10, 0, 30)
        IslandButton.Position = UDim2.new(0, 5, 0, (i-1)*35)
        IslandButton.BackgroundColor3 = Color3.fromRGB(40, 50, 70)
        IslandButton.TextColor3 = Color3.fromRGB(200, 200, 255)
        IslandButton.Text = island.name
        IslandButton.Font = Enum.Font.Gotham
        IslandButton.TextSize = 11
        IslandButton.Parent = IslandsScroll
        
        IslandButton.MouseButton1Click:Connect(function()
            local character = player.Character
            if character and character:FindFirstChild("HumanoidRootPart") then
                character.HumanoidRootPart.CFrame = island.coords
                StatusLabel.Text = "Teleported to: " .. island.name
            end
        end)
    end

    -- تبويب Farm
    local FarmTab = Instance.new("Frame")
    FarmTab.Size = UDim2.new(1, 0, 1, 0)
    FarmTab.BackgroundTransparency = 1
    FarmTab.Visible = false
    FarmTab.Parent = ContentFrame
    tabFrames["Farm"] = FarmTab

    local FarmSection = Instance.new("Frame")
    FarmSection.Size = UDim2.new(1, -10, 1, -10)
    FarmSection.Position = UDim2.new(0, 5, 0, 5)
    FarmSection.BackgroundColor3 = Color3.fromRGB(20, 20, 30)
    FarmSection.BorderSizePixel = 1
    FarmSection.BorderColor3 = Color3.fromRGB(40, 40, 60)
    FarmSection.Parent = FarmTab

    local SectionTitle4 = Instance.new("TextLabel")
    SectionTitle4.Size = UDim2.new(1, 0, 0, 25)
    SectionTitle4.Position = UDim2.new(0, 0, 0, 0)
    SectionTitle4.BackgroundColor3 = Color3.fromRGB(30, 30, 45)
    SectionTitle4.TextColor3 = Color3.fromRGB(200, 200, 255)
    SectionTitle4.Text = "🎯 AUTO FARM"
    SectionTitle4.Font = Enum.Font.GothamBold
    SectionTitle4.TextSize = 12
    SectionTitle4.Parent = FarmSection

    local FarmToggle = Instance.new("TextButton")
    FarmToggle.Size = UDim2.new(0.98, 0, 0, 30)
    FarmToggle.Position = UDim2.new(0.01, 0, 0, 30)
    FarmToggle.BackgroundColor3 = Color3.fromRGB(40, 40, 60)
    FarmToggle.TextColor3 = Color3.fromRGB(200, 200, 255)
    FarmToggle.Text = "AUTO FARM: OFF"
    FarmToggle.Font = Enum.Font.Gotham
    FarmToggle.TextSize = 11
    FarmToggle.Parent = FarmSection

    -- Dropdown لأنواع الأعداء مع Scroll محسن
    local EnemyDropdownFrame = Instance.new("Frame")
    EnemyDropdownFrame.Size = UDim2.new(0.98, 0, 0, 150)
    EnemyDropdownFrame.Position = UDim2.new(0.01, 0, 0, 65)
    EnemyDropdownFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 35)
    EnemyDropdownFrame.BorderSizePixel = 1
    EnemyDropdownFrame.BorderColor3 = Color3.fromRGB(50, 50, 70)
    EnemyDropdownFrame.Visible = false
    EnemyDropdownFrame.Parent = FarmSection

    local EnemyScroll = Instance.new("ScrollingFrame")
    EnemyScroll.Size = UDim2.new(1, 0, 1, 0)
    EnemyScroll.Position = UDim2.new(0, 0, 0, 0)
    EnemyScroll.BackgroundColor3 = Color3.fromRGB(25, 25, 35)
    EnemyScroll.CanvasSize = UDim2.new(0, 0, 0, #enemyTypes * 30)
    EnemyScroll.ScrollBarThickness = 6
    EnemyScroll.ScrollBarImageColor3 = Color3.fromRGB(80, 80, 100)
    EnemyScroll.Parent = EnemyDropdownFrame

    local EnemyDropdown = Instance.new("TextButton")
    EnemyDropdown.Size = UDim2.new(0.98, 0, 0, 30)
    EnemyDropdown.Position = UDim2.new(0.01, 0, 0, 65)
    EnemyDropdown.BackgroundColor3 = Color3.fromRGB(50, 50, 70)
    EnemyDropdown.TextColor3 = Color3.fromRGB(200, 200, 255)
    EnemyDropdown.Text = "Select Enemy Type: Thieves"
    EnemyDropdown.Font = Enum.Font.Gotham
    EnemyDropdown.TextSize = 10
    EnemyDropdown.Parent = FarmSection

    -- تحكم المسافة للأوتو فارم
    local DistanceLabel = Instance.new("TextLabel")
    DistanceLabel.Size = UDim2.new(0.98, 0, 0, 20)
    DistanceLabel.Position = UDim2.new(0.01, 0, 0, 100)
    DistanceLabel.BackgroundTransparency = 1
    DistanceLabel.TextColor3 = Color3.fromRGB(150, 150, 200)
    DistanceLabel.Text = "Distance: 7"
    DistanceLabel.Font = Enum.Font.Gotham
    DistanceLabel.TextSize = 10
    DistanceLabel.TextXAlignment = Enum.TextXAlignment.Left
    DistanceLabel.Parent = FarmSection

    local DistanceSlider = Instance.new("Frame")
    DistanceSlider.Size = UDim2.new(0.98, 0, 0, 20)
    DistanceSlider.Position = UDim2.new(0.01, 0, 0, 120)
    DistanceSlider.BackgroundColor3 = Color3.fromRGB(50, 50, 70)
    DistanceSlider.BorderSizePixel = 0
    DistanceSlider.Parent = FarmSection

    local DistanceFill = Instance.new("Frame")
    DistanceFill.Size = UDim2.new(0.7, 0, 1, 0) -- 7/10 = 0.7
    DistanceFill.BackgroundColor3 = Color3.fromRGB(70, 130, 200)
    DistanceFill.BorderSizePixel = 0
    DistanceFill.Parent = DistanceSlider

    local DistanceButton = Instance.new("TextButton")
    DistanceButton.Size = UDim2.new(1, 0, 1, 0)
    DistanceButton.BackgroundTransparency = 1
    DistanceButton.Text = ""
    DistanceButton.Parent = DistanceSlider

    local FarmStatus = Instance.new("TextLabel")
    FarmStatus.Size = UDim2.new(0.98, 0, 0, 60)
    FarmStatus.Position = UDim2.new(0.01, 0, 0, 145)
    FarmStatus.BackgroundTransparency = 1
    FarmStatus.TextColor3 = Color3.fromRGB(150, 150, 200)
    FarmStatus.Text = "Status: Inactive\nEnemies Found: 0\nDistance: 7 units"
    FarmStatus.Font = Enum.Font.Gotham
    FarmStatus.TextSize = 10
    FarmStatus.TextXAlignment = Enum.TextXAlignment.Left
    FarmStatus.TextYAlignment = Enum.TextYAlignment.Top
    FarmStatus.Parent = FarmSection

    -- تبويب Quest
    local QuestTab = Instance.new("Frame")
    QuestTab.Size = UDim2.new(1, 0, 1, 0)
    QuestTab.BackgroundTransparency = 1
    QuestTab.Visible = false
    QuestTab.Parent = ContentFrame
    tabFrames["Quest"] = QuestTab

    local QuestSection = Instance.new("Frame")
    QuestSection.Size = UDim2.new(1, -10, 1, -10)
    QuestSection.Position = UDim2.new(0, 5, 0, 5)
    QuestSection.BackgroundColor3 = Color3.fromRGB(20, 20, 30)
    QuestSection.BorderSizePixel = 1
    QuestSection.BorderColor3 = Color3.fromRGB(40, 40, 60)
    QuestSection.Parent = QuestTab

    local SectionTitle5 = Instance.new("TextLabel")
    SectionTitle5.Size = UDim2.new(1, 0, 0, 25)
    SectionTitle5.Position = UDim2.new(0, 0, 0, 0)
    SectionTitle5.BackgroundColor3 = Color3.fromRGB(30, 30, 45)
    SectionTitle5.TextColor3 = Color3.fromRGB(200, 200, 255)
    SectionTitle5.Text = "📋 AUTO QUEST"
    SectionTitle5.Font = Enum.Font.GothamBold
    SectionTitle5.TextSize = 12
    SectionTitle5.Parent = QuestSection

    local QuestToggle = Instance.new("TextButton")
    QuestToggle.Size = UDim2.new(0.98, 0, 0, 30)
    QuestToggle.Position = UDim2.new(0.01, 0, 0, 30)
    QuestToggle.BackgroundColor3 = Color3.fromRGB(40, 40, 60)
    QuestToggle.TextColor3 = Color3.fromRGB(200, 200, 255)
    QuestToggle.Text = "AUTO QUEST: OFF"
    QuestToggle.Font = Enum.Font.Gotham
    QuestToggle.TextSize = 11
    QuestToggle.Parent = QuestSection

    -- Dropdown لأنواع الكويستات مع Scroll محسن
    local QuestDropdownFrame = Instance.new("Frame")
    QuestDropdownFrame.Size = UDim2.new(0.98, 0, 0, 150)
    QuestDropdownFrame.Position = UDim2.new(0.01, 0, 0, 65)
    QuestDropdownFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 35)
    QuestDropdownFrame.BorderSizePixel = 1
    QuestDropdownFrame.BorderColor3 = Color3.fromRGB(50, 50, 70)
    QuestDropdownFrame.Visible = false
    QuestDropdownFrame.Parent = QuestSection

    local QuestScroll = Instance.new("ScrollingFrame")
    QuestScroll.Size = UDim2.new(1, 0, 1, 0)
    QuestScroll.Position = UDim2.new(0, 0, 0, 0)
    QuestScroll.BackgroundColor3 = Color3.fromRGB(25, 25, 35)
    QuestScroll.CanvasSize = UDim2.new(0, 0, 0, #questTypes * 30)
    QuestScroll.ScrollBarThickness = 6
    QuestScroll.ScrollBarImageColor3 = Color3.fromRGB(80, 80, 100)
    QuestScroll.Parent = QuestDropdownFrame

    local QuestDropdown = Instance.new("TextButton")
    QuestDropdown.Size = UDim2.new(0.98, 0, 0, 30)
    QuestDropdown.Position = UDim2.new(0.01, 0, 0, 65)
    QuestDropdown.BackgroundColor3 = Color3.fromRGB(50, 50, 70)
    QuestDropdown.TextColor3 = Color3.fromRGB(200, 200, 255)
    QuestDropdown.Text = "Select Quest Type: Thieves"
    QuestDropdown.Font = Enum.Font.Gotham
    QuestDropdown.TextSize = 10
    QuestDropdown.Parent = QuestSection

    local QuestStatus = Instance.new("TextLabel")
    QuestStatus.Size = UDim2.new(0.98, 0, 0, 40)
    QuestStatus.Position = UDim2.new(0.01, 0, 0, 100)
    QuestStatus.BackgroundTransparency = 1
    QuestStatus.TextColor3 = Color3.fromRGB(150, 150, 200)
    QuestStatus.Text = "Status: Inactive\nLast Accepted: None"
    QuestStatus.Font = Enum.Font.Gotham
    QuestStatus.TextSize = 10
    QuestStatus.TextXAlignment = Enum.TextXAlignment.Left
    QuestStatus.TextYAlignment = Enum.TextYAlignment.Top
    QuestStatus.Parent = QuestSection

    -- تبويب Phoenix
    local PhoenixTab = Instance.new("Frame")
    PhoenixTab.Size = UDim2.new(1, 0, 1, 0)
    PhoenixTab.BackgroundTransparency = 1
    PhoenixTab.Visible = false
    PhoenixTab.Parent = ContentFrame
    tabFrames["Phoenix"] = PhoenixTab

    local PhoenixSection = Instance.new("Frame")
    PhoenixSection.Size = UDim2.new(1, -10, 1, -10)
    PhoenixSection.Position = UDim2.new(0, 5, 0, 5)
    PhoenixSection.BackgroundColor3 = Color3.fromRGB(20, 20, 30)
    PhoenixSection.BorderSizePixel = 1
    PhoenixSection.BorderColor3 = Color3.fromRGB(40, 40, 60)
    PhoenixSection.Parent = PhoenixTab

    local SectionTitle6 = Instance.new("TextLabel")
    SectionTitle6.Size = UDim2.new(1, 0, 0, 25)
    SectionTitle6.Position = UDim2.new(0, 0, 0, 0)
    SectionTitle6.BackgroundColor3 = Color3.fromRGB(30, 30, 45)
    SectionTitle6.TextColor3 = Color3.fromRGB(200, 200, 255)
    SectionTitle6.Text = "🔥 PHOENIX SPAM"
    SectionTitle6.Font = Enum.Font.GothamBold
    SectionTitle6.TextSize = 12
    SectionTitle6.Parent = PhoenixSection

    local PhoenixSpamToggle = Instance.new("TextButton")
    PhoenixSpamToggle.Size = UDim2.new(0.98, 0, 0, 30)
    PhoenixSpamToggle.Position = UDim2.new(0.01, 0, 0, 30)
    PhoenixSpamToggle.BackgroundColor3 = Color3.fromRGB(40, 40, 60)
    PhoenixSpamToggle.TextColor3 = Color3.fromRGB(200, 200, 255)
    PhoenixSpamToggle.Text = "PHOENIX SPAM: OFF"
    PhoenixSpamToggle.Font = Enum.Font.Gotham
    PhoenixSpamToggle.TextSize = 11
    PhoenixSpamToggle.Parent = PhoenixSection

    local PhoenixStatus = Instance.new("TextLabel")
    PhoenixStatus.Size = UDim2.new(0.98, 0, 0, 80)
    PhoenixStatus.Position = UDim2.new(0.01, 0, 0, 65)
    PhoenixStatus.BackgroundTransparency = 1
    PhoenixStatus.TextColor3 = Color3.fromRGB(150, 150, 200)
    PhoenixStatus.Text = "Spams Phoenix abilities automatically\n• Beaming Sun\n• Phoenix Slash\n• All Phoenix moves"
    PhoenixStatus.Font = Enum.Font.Gotham
    PhoenixStatus.TextSize = 10
    PhoenixStatus.TextXAlignment = Enum.TextXAlignment.Left
    PhoenixStatus.TextYAlignment = Enum.TextYAlignment.Top
    PhoenixStatus.Parent = PhoenixSection

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
            StatusLabel.Text = "Location saved successfully!"
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

    -- وظيفة الأوتو فارم مع تحكم المسافة
    local farmConnection
    local currentEnemyType = "Thieves"
    local farmDistance = 7 -- المسافة الافتراضية 7 وحدات

    local function startAutoFarm()
        local enemies = {}
        local currentEnemyIndex = 1

        local function IsEnemyAlive(enemy)
            if not enemy or not enemy.Parent then return false end
            local humanoid = enemy:FindFirstChildOfClass("Humanoid")
            if humanoid and humanoid.Health <= 0 then return false end
            return true
        end

        local function UpdateEnemiesList()
            enemies = {}
            for _, enemy in pairs(workspace:GetDescendants()) do
                if enemy.Name == currentEnemyType and enemy:IsA("Model") then
                    if IsEnemyAlive(enemy) then
                        table.insert(enemies, enemy)
                    end
                end
            end
            FarmStatus.Text = "Status: Active\nEnemies Found: " .. #enemies .. "\nDistance: " .. farmDistance .. " units"
        end

        if farmConnection then
            farmConnection:Disconnect()
        end

        farmConnection = RunService.Heartbeat:Connect(function()
            if not autoFarmEnabled then return end
            
            UpdateEnemiesList()
            
            if #enemies > 0 then
                if currentEnemyIndex > #enemies then
                    currentEnemyIndex = 1
                end
                
                local targetEnemy = enemies[currentEnemyIndex]
                if targetEnemy and targetEnemy:FindFirstChild("HumanoidRootPart") then
                    local character = player.Character
                    if character and character:FindFirstChild("HumanoidRootPart") then
                        -- استخدام المسافة المحددة بدلاً من الارتفاع الثابت
                        local enemyPos = targetEnemy.HumanoidRootPart.Position
                        local offset = Vector3.new(0, farmDistance, 0)
                        character.HumanoidRootPart.CFrame = CFrame.new(enemyPos + offset)
                    end
                end
                
                currentEnemyIndex = currentEnemyIndex + 1
            else
                FarmStatus.Text = "Status: Active\nEnemies Found: 0\nDistance: " .. farmDistance .. " units"
            end
        end)
    end

    -- وظيفة الأوتو كويست مع التصحيح
    local questConnection
    local currentQuestType = "Thieves"
    local function startAutoQuest()
        local function AcceptQuest()
            local args = {[1] = currentQuestType}
            
            -- التصحيح: استخدام المسار الصحيح لل DarkWizards
            local remotePath = "Source.Quests.Remotes.AddQuest"
            if currentQuestType == "DarkWizards" then
                -- استخدام المسار الصحيح لل DarkWizards
                remotePath = "Source.Quests.Remotes.AddQuest"
            end
            
            local success = pcall(function()
                local remote = game:GetService("ReplicatedStorage"):WaitForChild("Source"):WaitForChild("Quests"):WaitForChild("Remotes"):WaitForChild("AddQuest")
                remote:InvokeServer(unpack(args))
            end)
            
            QuestStatus.Text = "Status: Active\nLast Accepted: " .. currentQuestType
            return success
        end

        if questConnection then
            questConnection:Disconnect()
        end

        -- قبول الكويست الأول فوراً
        AcceptQuest()
        
        questConnection = RunService.Heartbeat:Connect(function()
            if not autoQuestEnabled then return end
            wait(5) -- كل 5 ثواني
            if autoQuestEnabled then
                AcceptQuest()
            end
        end)
    end

    -- وظيفة فينيكس سبام
    local phoenixConnection
    local function startPhoenixSpam()
        local function activateSkill()
            local args = {[1] = "PhoenixFruit", [2] = "BeamingSun"}
            local success = pcall(function()
                game:GetService("ReplicatedStorage"):WaitForChild("Source"):WaitForChild("Combat"):WaitForChild("Remotes"):WaitForChild("Activate"):InvokeServer(unpack(args))
            end)
            return success
        end

        if phoenixConnection then
            phoenixConnection:Disconnect()
        end

        phoenixConnection = RunService.Heartbeat:Connect(function()
            if not phoenixSpamEnabled then return end
            activateSkill()
            wait(0.1)
        end)
    end

    -- أحداث التبويبات
    local function switchTab(tabKey)
        currentTab = tabKey
        for key, frame in pairs(tabFrames) do
            frame.Visible = (key == tabKey)
        end
        for key, button in pairs(tabButtons) do
            if key == tabKey then
                button.BackgroundColor3 = Color3.fromRGB(60, 80, 120)
                button.TextColor3 = Color3.fromRGB(255, 255, 255)
            else
                button.BackgroundColor3 = Color3.fromRGB(30, 30, 45)
                button.TextColor3 = Color3.fromRGB(150, 150, 200)
            end
        end
        -- إغلاق جميع القوائم المنسدلة عند تغيير التبويب
        EnemyDropdownFrame.Visible = false
        QuestDropdownFrame.Visible = false
    end

    for key, button in pairs(tabButtons) do
        button.MouseButton1Click:Connect(function()
            switchTab(key)
        end)
    end

    -- إعداد Dropdown للأعداء
    for i, enemyType in ipairs(enemyTypes) do
        local EnemyOption = Instance.new("TextButton")
        EnemyOption.Size = UDim2.new(1, -10, 0, 25)
        EnemyOption.Position = UDim2.new(0, 5, 0, (i-1)*30)
        EnemyOption.BackgroundColor3 = Color3.fromRGB(60, 60, 80)
        EnemyOption.TextColor3 = Color3.fromRGB(200, 200, 255)
        EnemyOption.Text = enemyType
        EnemyOption.Font = Enum.Font.Gotham
        EnemyOption.TextSize = 10
        EnemyOption.Parent = EnemyScroll
        
        EnemyOption.MouseButton1Click:Connect(function()
            currentEnemyType = enemyType
            EnemyDropdown.Text = "Select Enemy Type: " .. enemyType
            EnemyDropdownFrame.Visible = false
            FarmStatus.Text = "Enemy type changed to: " .. enemyType .. "\nDistance: " .. farmDistance .. " units"
        end)
    end

    -- إعداد Dropdown للكويستات
    for i, questType in ipairs(questTypes) do
        local QuestOption = Instance.new("TextButton")
        QuestOption.Size = UDim2.new(1, -10, 0, 25)
        QuestOption.Position = UDim2.new(0, 5, 0, (i-1)*30)
        QuestOption.BackgroundColor3 = Color3.fromRGB(60, 60, 80)
        QuestOption.TextColor3 = Color3.fromRGB(200, 200, 255)
        QuestOption.Text = questType
        QuestOption.Font = Enum.Font.Gotham
        QuestOption.TextSize = 10
        QuestOption.Parent = QuestScroll
        
        QuestOption.MouseButton1Click:Connect(function()
            currentQuestType = questType
            QuestDropdown.Text = "Select Quest Type: " .. questType
            QuestDropdownFrame.Visible = false
            QuestStatus.Text = "Quest type changed to: " .. questType
        end)
    end

    -- أحداث Dropdown للأعداء
    EnemyDropdown.MouseButton1Click:Connect(function()
        EnemyDropdownFrame.Visible = not EnemyDropdownFrame.Visible
        QuestDropdownFrame.Visible = false
    end)

    -- أحداث Dropdown للكويستات
    QuestDropdown.MouseButton1Click:Connect(function()
        QuestDropdownFrame.Visible = not QuestDropdownFrame.Visible
        EnemyDropdownFrame.Visible = false
    end)

    -- إغلاق القوائم المنسدلة عند النقر خارجها
    UserInputService.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            local mousePos = input.Position
            local enemyDropdownAbsPos = EnemyDropdownFrame.AbsolutePosition
            local enemyDropdownSize = EnemyDropdownFrame.AbsoluteSize
            local questDropdownAbsPos = QuestDropdownFrame.AbsolutePosition
            local questDropdownSize = QuestDropdownFrame.AbsoluteSize
            
            if EnemyDropdownFrame.Visible and 
               not (mousePos.X >= enemyDropdownAbsPos.X and mousePos.X <= enemyDropdownAbsPos.X + enemyDropdownSize.X and
                    mousePos.Y >= enemyDropdownAbsPos.Y and mousePos.Y <= enemyDropdownAbsPos.Y + enemyDropdownSize.Y) then
                EnemyDropdownFrame.Visible = false
            end
            
            if QuestDropdownFrame.Visible and 
               not (mousePos.X >= questDropdownAbsPos.X and mousePos.X <= questDropdownAbsPos.X + questDropdownSize.X and
                    mousePos.Y >= questDropdownAbsPos.Y and mousePos.Y <= questDropdownAbsPos.Y + questDropdownSize.Y) then
                QuestDropdownFrame.Visible = false
            end
        end
    end)

    -- تحديث شريط المسافة
    local function UpdateDistanceSlider()
        local fillWidth = farmDistance / 10 -- من 1 إلى 10
        DistanceFill.Size = UDim2.new(fillWidth, 0, 1, 0)
        DistanceLabel.Text = "Distance: " .. farmDistance
        FarmStatus.Text = FarmStatus.Text:gsub("Distance: %d+", "Distance: " .. farmDistance)
    end

    -- أحداث شريط المسافة
    local isSliding = false
    DistanceButton.MouseButton1Down:Connect(function()
        isSliding = true
    end)

    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            isSliding = false
        end
    end)

    UserInputService.InputChanged:Connect(function(input)
        if isSliding and input.UserInputType == Enum.UserInputType.MouseMovement then
            local mousePos = UserInputService:GetMouseLocation()
            local sliderAbsPos = DistanceSlider.AbsolutePosition
            local sliderSize = DistanceSlider.AbsoluteSize
            
            local relativeX = math.clamp((mousePos.X - sliderAbsPos.X) / sliderSize.X, 0, 1)
            farmDistance = math.floor(1 + relativeX * 9) -- من 1 إلى 10
            
            UpdateDistanceSlider()
            
            -- إعادة تشغيل الأوتو فارم إذا كان نشطاً
            if autoFarmEnabled then
                startAutoFarm()
            end
        end
    end)

    -- التهيئة الأولية لشريط المسافة
    UpdateDistanceSlider()

    -- أحداث الأزرار
    for _, attack in ipairs(attackButtons) do
        attack.button.MouseButton1Click:Connect(function()
            autoAttackEnabled[attack.key] = not autoAttackEnabled[attack.key]
            if autoAttackEnabled[attack.key] then
                attack.button.BackgroundColor3 = Color3.fromRGB(60, 150, 60)
                attack.button.Text = attack.name .. ": ON"
                coroutine.wrap(attackFunctions[attack.key])()
            else
                attack.button.BackgroundColor3 = Color3.fromRGB(40, 40, 60)
                attack.button.Text = attack.name .. ": OFF"
            end
        end)
    end

    JumpButton.MouseButton1Click:Connect(function()
        infiniteJumpEnabled = not infiniteJumpEnabled
        if infiniteJumpEnabled then
            JumpButton.BackgroundColor3 = Color3.fromRGB(60, 150, 60)
            JumpButton.Text = "INFINITE JUMP: ON"
        else
            JumpButton.BackgroundColor3 = Color3.fromRGB(40, 40, 60)
            JumpButton.Text = "INFINITE JUMP: OFF"
        end
    end)

    CollectButton.MouseButton1Click:Connect(function()
        autoCollectEnabled = not autoCollectEnabled
        if autoCollectEnabled then
            CollectButton.BackgroundColor3 = Color3.fromRGB(60, 150, 60)
            CollectButton.Text = "AUTO COLLECT: ON"
            coroutine.wrap(startAutoCollect)()
        else
            CollectButton.BackgroundColor3 = Color3.fromRGB(40, 40, 60)
            CollectButton.Text = "AUTO COLLECT: OFF"
        end
    end)

    SaveButton.MouseButton1Click:Connect(saveCurrentLocation)

    TeleportToggle.MouseButton1Click:Connect(function()
        teleportEnabled = not teleportEnabled
        if teleportEnabled then
            TeleportToggle.BackgroundColor3 = Color3.fromRGB(60, 150, 60)
            TeleportToggle.Text = "🔄 AUTO TP: ON"
            coroutine.wrap(autoTeleportLoop)()
        else
            TeleportToggle.BackgroundColor3 = Color3.fromRGB(40, 40, 60)
            TeleportToggle.Text = "🔄 AUTO TP: OFF"
        end
    end)

    FarmToggle.MouseButton1Click:Connect(function()
        autoFarmEnabled = not autoFarmEnabled
        if autoFarmEnabled then
            FarmToggle.BackgroundColor3 = Color3.fromRGB(60, 150, 60)
            FarmToggle.Text = "AUTO FARM: ON"
            FarmStatus.Text = "Status: Starting...\nEnemies Found: 0\nDistance: " .. farmDistance .. " units"
            coroutine.wrap(startAutoFarm)()
        else
            FarmToggle.BackgroundColor3 = Color3.fromRGB(40, 40, 60)
            FarmToggle.Text = "AUTO FARM: OFF"
            FarmStatus.Text = "Status: Inactive\nEnemies Found: 0\nDistance: " .. farmDistance .. " units"
            if farmConnection then
                farmConnection:Disconnect()
            end
        end
    end)

    QuestToggle.MouseButton1Click:Connect(function()
        autoQuestEnabled = not autoQuestEnabled
        if autoQuestEnabled then
            QuestToggle.BackgroundColor3 = Color3.fromRGB(60, 150, 60)
            QuestToggle.Text = "AUTO QUEST: ON"
            QuestStatus.Text = "Status: Active\nLast Accepted: " .. currentQuestType
            coroutine.wrap(startAutoQuest)()
        else
            QuestToggle.BackgroundColor3 = Color3.fromRGB(40, 40, 60)
            QuestToggle.Text = "AUTO QUEST: OFF"
            QuestStatus.Text = "Status: Inactive\nLast Accepted: None"
            if questConnection then
                questConnection:Disconnect()
            end
        end
    end)

    PhoenixSpamToggle.MouseButton1Click:Connect(function()
        phoenixSpamEnabled = not phoenixSpamEnabled
        if phoenixSpamEnabled then
            PhoenixSpamToggle.BackgroundColor3 = Color3.fromRGB(60, 150, 60)
            PhoenixSpamToggle.Text = "PHOENIX SPAM: ON"
            coroutine.wrap(startPhoenixSpam)()
        else
            PhoenixSpamToggle.BackgroundColor3 = Color3.fromRGB(40, 40, 60)
            PhoenixSpamToggle.Text = "PHOENIX SPAM: OFF"
            if phoenixConnection then
                phoenixConnection:Disconnect()
            end
        end
    end)

    MinimizeButton.MouseButton1Click:Connect(function()
        minimized = not minimized
        if minimized then
            MainContainer.Size = UDim2.new(0, 450, 0, 35)
            MinimizeButton.Text = "+"
        else
            MainContainer.Size = UDim2.new(0, 450, 0, 500)
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

    return ScreenGui
end

-- إنشاء الواجهة الرئيسية
local mainUI = CreateMainUI()

-- إعادة إنشاء الواجهة عند موت اللاعب
player.CharacterAdded:Connect(function()
    wait(1)
    if not mainUI or not mainUI.Parent then
        mainUI = CreateMainUI()
    end
end)

print("🌟 GLORY HUB LOADED SUCCESSFULLY!")
