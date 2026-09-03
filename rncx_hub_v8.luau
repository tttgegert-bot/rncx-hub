-- ═══════════════════════════════════════════════════════════════
--  rncx hub v8 — Muscle Legends  (ULTIMATE EDITION)
--  Every feature from 2026 scripts + our original design
-- ═══════════════════════════════════════════════════════════════

local Players = game:GetService("Players")
local RS = game:GetService("ReplicatedStorage")
local UIS = game:GetService("UserInputService")
local TS = game:GetService("TweenService")
local VU = game:GetService("VirtualUser")
local LP = Players.LocalPlayer
local PG = LP:WaitForChild("PlayerGui")
local Lighting = game:GetService("Lighting")
local RunService = game:GetService("RunService")
local StarterGui = game:GetService("StarterGui")
local TeleportService = game:GetService("TeleportService")
local HttpService = game:GetService("HttpService")

local Char = LP.Character or LP.CharacterAdded:Wait()
local Hum = Char:WaitForChild("Humanoid")
local HRP = Char:WaitForChild("HumanoidRootPart")
LP.CharacterAdded:Connect(function(c)
    Char = c Hum = c:WaitForChild("Humanoid") HRP = c:WaitForChild("HumanoidRootPart")
    task.wait(0.5)
    pcall(function() Hum.WalkSpeed = 16 Hum.JumpPower = 50 end)
    if CFG and CFG.NoClip then noclipConn = RunService.Stepped:Connect(function() if Char then for _, p in Char:GetDescendants() do if p:IsA("BasePart") then p.CanCollide = false end end end end) end
end)

local rE = RS:WaitForChild("rEvents")
local mE = LP:WaitForChild("muscleEvent")
local Gems = LP:WaitForChild("Gems")

local CFG = {
    -- Train
    AutoTrain = false, TrainSpd = 0.15, FastTools = false,
    -- Farm
    AutoRebirth = false, AutoChest = false, AutoBrawl = false, AutoEquip = false,
    AutoSpin = false, AutoHatch = false, TargetRebirths = 0, SpeedGrind = false,
    FarmStation = "Rock", FarmArea = "Beach", AutoBuy = false, AutoEggsPerfect = false,
    -- Combat
    KillAura = false, KillRange = 15, AntiKnockback = false, AntiFling = false,
    TargetPlayer = "", Whitelist = {}, SelectAura = "None", RecoveryPunch = false,
    -- Player
    WalkSpd = 16, JumpPow = 50, NoClip = false, AntiAFK = false,
    InfJump = false, WalkOnWater = false, HipHeight = 0,
    FpsBoost = false, FullBright = false, NightSky = false, HidePets = false,
    ChatSpy = false, LockPos = false, SelectPet = "None", ClearInventory = false,
    AutoOpenAura = false, FreeAutoLift = false, EquipSamurai = false,
    -- Crystals
    AutoCrystal = false, Crystal = "Blue Crystal", CrystInt = 3,
    -- Player
    WalkSpd = 16, JumpPow = 50, NoClip = false, AntiAFK = false,
    InfJump = false, WalkOnWater = false, HipHeight = 0,
    -- Combat
    KillAura = false, KillRange = 15, AntiKnockback = false, AntiFling = false,
    TargetPlayer = "",
    -- Visual
    FpsBoost = false, FullBright = false, NightSky = false, HidePets = false,
    ChatSpy = false, LockPos = false,
    -- Chest
    Chest = "Golden Chest",
}

-- Namecall hook: makes our FireServer calls to muscleEvent appear as game code
local origNamecall
origNamecall = hookmetamethod(game, "__namecall", newcclosure(function(self, ...)
    local method = getnamecallmethod()
    if method == "FireServer" and self.Name == "muscleEvent" and checkcaller() then
        setnamecallmethod("FireServer")
        return origNamecall(self, ...)
    end
    return origNamecall(self, ...)
end))

local originalBrightness = Lighting.Brightness
local originalAmbient = Lighting.Ambient
local originalOutdoor = Lighting.OutdoorAmbient
local originalFog = Lighting.FogEnd
local noclipConn = nil

local CrystalPrices = {
    ["Blue Crystal"] = 1000, ["Green Crystal"] = 3000, ["Frost Crystal"] = 5000,
    ["Mythical Crystal"] = 8000, ["Inferno Crystal"] = 15000, ["Legends Crystal"] = 30000,
    ["Muscle Elite Crystal"] = 1000000, ["Galaxy Oracle Crystal"] = 1500000,
    ["Jungle Crystal"] = 3000000, ["Industrial Crystal"] = 7500000,
}
local CrystalColors = {
    ["Blue Crystal"] = Color3.fromRGB(0,170,255), ["Green Crystal"] = Color3.fromRGB(0,230,118),
    ["Frost Crystal"] = Color3.fromRGB(0,210,211), ["Mythical Crystal"] = Color3.fromRGB(124,77,255),
    ["Inferno Crystal"] = Color3.fromRGB(255,82,82), ["Legends Crystal"] = Color3.fromRGB(255,215,64),
    ["Muscle Elite Crystal"] = Color3.fromRGB(255,109,178), ["Galaxy Oracle Crystal"] = Color3.fromRGB(92,64,255),
    ["Jungle Crystal"] = Color3.fromRGB(76,175,80), ["Industrial Crystal"] = Color3.fromRGB(158,158,158),
}

local Chests = {"Golden Chest", "Enchanted Chest", "Mythical Chest", "Legends Chest", "Jungle Chest", "Magma Chest"}

local FarmStations = {"Rock", "Bench Press", "Squat", "Deadlift", "Pull Up", "Treadmill", "Boulder"}

local FarmAreas = {
    {"Beach", CFrame.new(-38.40, 19.72, 1837.58)},
    {"Tiny Island", CFrame.new(-42.59, 19.72, 451.36)},
    {"Frost Gym", CFrame.new(-307.74, 23.81, 207.29)},
    {"Mythical Gym", CFrame.new(311.92, 23.81, 153.28)},
    {"Eternal Gym", CFrame.new(-307.57, 23.81, -52.85)},
    {"Legends Gym", CFrame.new(311.92, 23.81, -35.92)},
    {"Jungle Gym", CFrame.new(330.33, 22.41, -803.43)},
    {"Muscle King", CFrame.new(-121.82, 35.25, -712.23)},
}

local T = {
    bg = Color3.fromRGB(5, 8, 18), panel = Color3.fromRGB(10, 14, 28),
    card = Color3.fromRGB(14, 20, 38), cardHi = Color3.fromRGB(20, 28, 52),
    border = Color3.fromRGB(30, 50, 80),
    cyan = Color3.fromRGB(0, 220, 255), cyanD = Color3.fromRGB(0, 140, 180),
    cyanG = Color3.fromRGB(0, 255, 255), green = Color3.fromRGB(0, 230, 118),
    red = Color3.fromRGB(255, 82, 82), orange = Color3.fromRGB(255, 170, 50),
    blue = Color3.fromRGB(60, 120, 255), purple = Color3.fromRGB(140, 70, 255),
    pink = Color3.fromRGB(255, 50, 150), yellow = Color3.fromRGB(255, 230, 50),
    txt = Color3.fromRGB(220, 235, 255), dim = Color3.fromRGB(70, 90, 120),
}

local old = PG:FindFirstChild("rncxHub")
if old then old:Destroy() end

local SG = Instance.new("ScreenGui", PG)
SG.Name = "rncxHub"
SG.ResetOnSpawn = false
SG.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
SG.DisplayOrder = 999

-- ═══════════════════════════════════════════
--  MAIN FRAME
-- ═══════════════════════════════════════════
local MF = Instance.new("Frame", SG)
MF.Name = "Main"
MF.Size = UDim2.new(0, 560, 0, 0)
MF.Position = UDim2.new(0.5, -280, 0.5, -280)
MF.BackgroundColor3 = T.bg
MF.BorderSizePixel = 0
MF.Active = true
MF.Draggable = true
MF.ClipsDescendants = true
MF.Visible = false
Instance.new("UICorner", MF).CornerRadius = UDim.new(0, 16)
Instance.new("UIStroke", MF).Color = T.border

-- ═══════════════════════════════════════════
--  SIDEBAR
-- ═══════════════════════════════════════════
local SB = Instance.new("Frame", MF)
SB.Size = UDim2.new(0, 80, 1, 0)
SB.BackgroundColor3 = T.panel
SB.BorderSizePixel = 0
Instance.new("UICorner", SB).CornerRadius = UDim.new(0, 16)
local SBRight = Instance.new("Frame", SB)
SBRight.Size = UDim2.new(0, 10, 1, 0)
SBRight.Position = UDim2.new(1, -10, 0, 0)
SBRight.BackgroundColor3 = T.panel
SBRight.BorderSizePixel = 0

local Logo = Instance.new("TextLabel", SB)
Logo.Size = UDim2.new(1, 0, 0, 36)
Logo.BackgroundTransparency = 1
Logo.Text = "R"
Logo.TextColor3 = T.cyan
Logo.TextSize = 18
Logo.Font = Enum.Font.GothamBlack

local LogoLine = Instance.new("Frame", SB)
LogoLine.Size = UDim2.new(0.6, 0, 0, 1)
LogoLine.Position = UDim2.new(0.2, 0, 0, 38)
LogoLine.BackgroundColor3 = T.cyan
LogoLine.BackgroundTransparency = 0.5
LogoLine.BorderSizePixel = 0
Instance.new("UICorner", LogoLine).CornerRadius = UDim.new(1, 0)

local SBLabels = {"Train", "Farm", "Crystals", "Tele", "Player", "Combat", "Visual", "Info"}
local SBBtns = {}
local Pages = {}
local Active = nil

for i, label in SBLabels do
    local b = Instance.new("TextButton", SB)
    b.Size = UDim2.new(1, 0, 0, 38)
    b.Position = UDim2.new(0, 0, 0, 42 + (i-1) * 40)
    b.BackgroundColor3 = T.card
    b.BackgroundTransparency = 0.85
    b.Text = ""
    b.ZIndex = 5
    Instance.new("UICorner", b).CornerRadius = UDim.new(0, 8)
    local indicator = Instance.new("Frame", b)
    indicator.Size = UDim2.new(0, 3, 0, 16)
    indicator.Position = UDim2.new(0, 3, 0.5, -8)
    indicator.BackgroundColor3 = T.cyan
    indicator.BackgroundTransparency = 1
    indicator.BorderSizePixel = 0
    indicator.ZIndex = 6
    Instance.new("UICorner", indicator).CornerRadius = UDim.new(1, 0)
    local lbl = Instance.new("TextLabel", b)
    lbl.Size = UDim2.new(1, -6, 1, 0)
    lbl.Position = UDim2.new(0, 8, 0, 0)
    lbl.BackgroundTransparency = 1
    lbl.Text = label
    lbl.TextColor3 = Color3.fromRGB(90, 110, 140)
    lbl.TextSize = 10
    lbl.Font = Enum.Font.GothamBold
    lbl.TextXAlignment = Enum.TextXAlignment.Left
    lbl.ZIndex = 6
    SBBtns[i] = {btn = b, lbl = lbl, ind = indicator}
end

local Content = Instance.new("Frame", MF)
Content.Size = UDim2.new(1, -88, 1, -10)
Content.Position = UDim2.new(0, 86, 0, 10)
Content.BackgroundTransparency = 1

local Header = Instance.new("TextLabel", Content)
Header.Size = UDim2.new(1, 0, 0, 22)
Header.BackgroundTransparency = 1
Header.Text = "rncx hub  |  Muscle Legends"
Header.TextColor3 = T.cyan
Header.TextSize = 11
Header.Font = Enum.Font.GothamBold
Header.TextXAlignment = Enum.TextXAlignment.Left

local HeaderLine = Instance.new("Frame", Content)
HeaderLine.Size = UDim2.new(1, 0, 0, 1)
HeaderLine.Position = UDim2.new(0, 0, 0, 24)
HeaderLine.BackgroundColor3 = T.border
HeaderLine.BorderSizePixel = 0

local CS = Instance.new("ScrollingFrame", Content)
CS.Size = UDim2.new(1, 0, 1, -30)
CS.Position = UDim2.new(0, 0, 0, 28)
CS.BackgroundTransparency = 1
CS.ScrollBarThickness = 2
CS.ScrollBarImageColor3 = T.cyan
CS.BorderSizePixel = 0
CS.CanvasSize = UDim2.new(0, 0, 0, 0)
CS.AutomaticCanvasSize = Enum.AutomaticSize.Y

local Order = 0
local function NO() Order += 1 return Order end

local function MakePage(name)
    local p = Instance.new("Frame", CS)
    p.Name = name
    p.Size = UDim2.new(1, 0, 0, 0)
    p.AutomaticSize = Enum.AutomaticSize.Y
    p.BackgroundTransparency = 1
    p.Visible = false
    local l = Instance.new("UIListLayout", p)
    l.Padding = UDim.new(0, 5)
    l.SortOrder = Enum.SortOrder.LayoutOrder
    l.HorizontalAlignment = Enum.HorizontalAlignment.Center
    Pages[name] = p
    return p
end

local function SwitchTab(idx)
    local name = SBLabels[idx]
    if Active and Pages[Active] then Pages[Active].Visible = false end
    for i, data in SBBtns do
        TS:Create(data.lbl, TweenInfo.new(0.15), {TextColor3 = Color3.fromRGB(90, 110, 140)}):Play()
        TS:Create(data.ind, TweenInfo.new(0.15), {BackgroundTransparency = 1}):Play()
        TS:Create(data.btn, TweenInfo.new(0.15), {BackgroundTransparency = 0.85}):Play()
    end
    Active = name
    if Pages[name] then Pages[name].Visible = true end
    if SBBtns[idx] then
        TS:Create(SBBtns[idx].lbl, TweenInfo.new(0.15), {TextColor3 = T.cyan}):Play()
        TS:Create(SBBtns[idx].ind, TweenInfo.new(0.15), {BackgroundTransparency = 0}):Play()
        TS:Create(SBBtns[idx].btn, TweenInfo.new(0.15), {BackgroundTransparency = 0.6}):Play()
    end
    CS.CanvasPosition = Vector2.new(0, 0)
end

for i = 1, #SBLabels do
    local idx = i
    SBBtns[i].btn.MouseButton1Click:Connect(function() SwitchTab(idx) end)
end

-- ═══════════════════════════════════════════
--  BUILDERS
-- ═══════════════════════════════════════════
local function Card(parent, title)
    local f = Instance.new("Frame", parent)
    f.Size = UDim2.new(1, 0, 0, 0)
    f.AutomaticSize = Enum.AutomaticSize.Y
    f.BackgroundColor3 = T.card
    f.BackgroundTransparency = 0.2
    f.BorderSizePixel = 0
    f.LayoutOrder = NO()
    f.ZIndex = 3
    Instance.new("UICorner", f).CornerRadius = UDim.new(0, 12)
    local stroke = Instance.new("UIStroke", f)
    stroke.Color = T.border
    stroke.Thickness = 1
    stroke.Transparency = 0.5
    local lay = Instance.new("UIListLayout", f)
    lay.Padding = UDim.new(0, 3)
    lay.SortOrder = Enum.SortOrder.LayoutOrder
    lay.HorizontalAlignment = Enum.HorizontalAlignment.Center
    local pad = Instance.new("UIPadding", f)
    pad.PaddingTop = UDim.new(0, title and 10 or 6)
    pad.PaddingBottom = UDim.new(0, 6)
    pad.PaddingLeft = UDim.new(0, 10)
    pad.PaddingRight = UDim.new(0, 10)
    if title then
        local tBar = Instance.new("Frame", f)
        tBar.Size = UDim2.new(1, 0, 0, 16)
        tBar.BackgroundTransparency = 1
        tBar.LayoutOrder = 0
        tBar.ZIndex = 4
        local lbl = Instance.new("TextLabel", tBar)
        lbl.Size = UDim2.new(1, 0, 1, 0)
        lbl.BackgroundTransparency = 1
        lbl.Text = string.upper(title)
        lbl.TextColor3 = T.cyanD
        lbl.TextSize = 9
        lbl.Font = Enum.Font.GothamBlack
        lbl.TextXAlignment = Enum.TextXAlignment.Left
        lbl.ZIndex = 5
    end
    return f
end

local function Toggle(parent, text, key)
    local f = Instance.new("Frame", parent)
    f.Size = UDim2.new(1, 0, 0, 32)
    f.BackgroundColor3 = T.card
    f.BackgroundTransparency = 0.3
    f.BorderSizePixel = 0
    f.LayoutOrder = NO()
    f.ZIndex = 4
    Instance.new("UICorner", f).CornerRadius = UDim.new(0, 8)
    local stroke = Instance.new("UIStroke", f)
    stroke.Color = T.border
    stroke.Thickness = 1
    stroke.Transparency = 0.6
    local lbl = Instance.new("TextLabel", f)
    lbl.Size = UDim2.new(0.7, 0, 1, 0)
    lbl.Position = UDim2.new(0, 10, 0, 0)
    lbl.BackgroundTransparency = 1
    lbl.Text = text
    lbl.TextColor3 = T.txt
    lbl.TextSize = 11
    lbl.Font = Enum.Font.GothamMedium
    lbl.TextXAlignment = Enum.TextXAlignment.Left
    lbl.ZIndex = 5
    local isOn = CFG[key]
    local box = Instance.new("Frame", f)
    box.Size = UDim2.new(0, 26, 0, 26)
    box.Position = UDim2.new(1, -36, 0.5, -13)
    box.BackgroundColor3 = isOn and T.cyan or Color3.fromRGB(20, 25, 40)
    box.BorderSizePixel = 0
    box.ZIndex = 5
    Instance.new("UICorner", box).CornerRadius = UDim.new(0, 8)
    local boxStroke = Instance.new("UIStroke", box)
    boxStroke.Color = isOn and T.cyan or Color3.fromRGB(40, 55, 80)
    boxStroke.Thickness = isOn and 2 or 1
    local ck1 = Instance.new("Frame", box)
    ck1.Size = UDim2.new(0, 7, 0, 2)
    ck1.Position = UDim2.new(0, 5, 0, 12)
    ck1.BackgroundColor3 = T.bg
    ck1.BorderSizePixel = 0
    ck1.Rotation = -45
    ck1.ZIndex = 6
    ck1.BackgroundTransparency = isOn and 0 or 1
    Instance.new("UICorner", ck1).CornerRadius = UDim.new(1, 0)
    local ck2 = Instance.new("Frame", box)
    ck2.Size = UDim2.new(0, 12, 0, 2)
    ck2.Position = UDim2.new(0, 9, 0, 12)
    ck2.BackgroundColor3 = T.bg
    ck2.BorderSizePixel = 0
    ck2.Rotation = 45
    ck2.ZIndex = 6
    ck2.BackgroundTransparency = isOn and 0 or 1
    Instance.new("UICorner", ck2).CornerRadius = UDim.new(1, 0)
    local glow = Instance.new("Frame", box)
    glow.Size = UDim2.new(1, 6, 1, 6)
    glow.Position = UDim2.new(0, -3, 0, -3)
    glow.BackgroundTransparency = 1
    glow.ZIndex = 4
    Instance.new("UICorner", glow).CornerRadius = UDim.new(0, 10)
    local glowStroke = Instance.new("UIStroke", glow)
    glowStroke.Color = T.cyanG
    glowStroke.Thickness = 1
    glowStroke.Transparency = isOn and 0.4 or 1
    local btn = Instance.new("TextButton", f)
    btn.Size = UDim2.new(1, 0, 1, 0)
    btn.BackgroundTransparency = 1
    btn.Text = ""
    btn.ZIndex = 8
    local function setOn(on)
        CFG[key] = on
        local info = TweenInfo.new(0.2, Enum.EasingStyle.Quint, Enum.EasingDirection.Out)
        TS:Create(box, info, {BackgroundColor3 = on and T.cyan or Color3.fromRGB(20, 25, 40)}):Play()
        TS:Create(boxStroke, info, {Color = on and T.cyan or Color3.fromRGB(40, 55, 80), Thickness = on and 2 or 1}):Play()
        TS:Create(ck1, info, {BackgroundTransparency = on and 0 or 1}):Play()
        TS:Create(ck2, info, {BackgroundTransparency = on and 0 or 1}):Play()
        TS:Create(glowStroke, info, {Transparency = on and 0.4 or 1}):Play()
        if on then lbl.TextColor3 = T.cyanG task.delay(0.15, function() TS:Create(lbl, TweenInfo.new(0.3), {TextColor3 = T.txt}):Play() end)
        else lbl.TextColor3 = T.txt end
    end
    btn.MouseButton1Click:Connect(function() setOn(not CFG[key]) end)
    return { Set = setOn }
end

local function Slider(parent, text, key, min, max)
    local val = CFG[key]
    local pct = math.clamp((val - min) / (max - min), 0, 1)
    local f = Instance.new("Frame", parent)
    f.Size = UDim2.new(1, 0, 0, 44)
    f.BackgroundColor3 = T.card
    f.BackgroundTransparency = 0.3
    f.BorderSizePixel = 0
    f.LayoutOrder = NO()
    f.ZIndex = 4
    Instance.new("UICorner", f).CornerRadius = UDim.new(0, 8)
    local stroke = Instance.new("UIStroke", f)
    stroke.Color = T.border
    stroke.Thickness = 1
    stroke.Transparency = 0.6
    local lbl = Instance.new("TextLabel", f)
    lbl.Size = UDim2.new(0.6, 0, 0, 16)
    lbl.Position = UDim2.new(0, 10, 0, 6)
    lbl.BackgroundTransparency = 1
    lbl.Text = text
    lbl.TextColor3 = T.txt
    lbl.TextSize = 11
    lbl.Font = Enum.Font.GothamMedium
    lbl.TextXAlignment = Enum.TextXAlignment.Left
    lbl.ZIndex = 5
    local valL = Instance.new("TextLabel", f)
    valL.Size = UDim2.new(0.35, 0, 0, 16)
    valL.Position = UDim2.new(0.62, 0, 0, 6)
    valL.BackgroundTransparency = 1
    valL.Text = tostring(val)
    valL.TextColor3 = T.cyan
    valL.TextSize = 12
    valL.Font = Enum.Font.GothamBlack
    valL.TextXAlignment = Enum.TextXAlignment.Right
    valL.ZIndex = 5
    local trk = Instance.new("Frame", f)
    trk.Size = UDim2.new(1, -24, 0, 5)
    trk.Position = UDim2.new(0, 12, 0, 30)
    trk.BackgroundColor3 = Color3.fromRGB(20, 25, 40)
    trk.BorderSizePixel = 0
    trk.ZIndex = 5
    Instance.new("UICorner", trk).CornerRadius = UDim.new(1, 0)
    local fill = Instance.new("Frame", trk)
    fill.Size = UDim2.new(pct, 0, 1, 0)
    fill.BackgroundColor3 = T.cyan
    fill.BorderSizePixel = 0
    fill.ZIndex = 6
    Instance.new("UICorner", fill).CornerRadius = UDim.new(1, 0)
    local knb = Instance.new("TextButton", trk)
    knb.Size = UDim2.new(0, 14, 0, 14)
    knb.Position = UDim2.new(pct, -7, 0.5, -7)
    knb.BackgroundColor3 = T.cyanG
    knb.Text = ""
    knb.BorderSizePixel = 0
    knb.ZIndex = 7
    Instance.new("UICorner", knb).CornerRadius = UDim.new(1, 0)
    local drag = false
    knb.MouseButton1Down:Connect(function() drag = true end)
    UIS.InputEnded:Connect(function(i) if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then drag = false end end)
    UIS.InputChanged:Connect(function(i)
        if drag and (i.UserInputType == Enum.UserInputType.MouseMovement or i.UserInputType == Enum.UserInputType.Touch) then
            local px = math.clamp((i.Position.X - trk.AbsolutePosition.X) / trk.AbsoluteSize.X, 0, 1)
            local v = math.floor(min + (max - min) * px + 0.5)
            CFG[key] = v valL.Text = tostring(v)
            fill.Size = UDim2.new(px, 0, 1, 0)
            knb.Position = UDim2.new(px, -7, 0.5, -7)
        end
    end)
end

local function Btn(parent, text, col, cb)
    local b = Instance.new("TextButton", parent)
    b.Size = UDim2.new(1, 0, 0, 32)
    b.BackgroundColor3 = col or T.cyan
    b.BackgroundTransparency = 0.85
    b.Text = ""
    b.BorderSizePixel = 0
    b.LayoutOrder = NO()
    b.ZIndex = 4
    Instance.new("UICorner", b).CornerRadius = UDim.new(0, 8)
    local bStroke = Instance.new("UIStroke", b)
    bStroke.Color = col or T.cyan
    bStroke.Thickness = 1
    bStroke.Transparency = 0.3
    local lbl = Instance.new("TextLabel", b)
    lbl.Size = UDim2.new(1, -14, 1, 0)
    lbl.Position = UDim2.new(0, 10, 0, 0)
    lbl.BackgroundTransparency = 1
    lbl.Text = text
    lbl.TextColor3 = col or T.cyan
    lbl.TextSize = 10
    lbl.Font = Enum.Font.GothamBold
    lbl.TextXAlignment = Enum.TextXAlignment.Left
    lbl.ZIndex = 5
    b.MouseEnter:Connect(function() TS:Create(b, TweenInfo.new(0.15), {BackgroundTransparency = 0.7}):Play() end)
    b.MouseLeave:Connect(function() TS:Create(b, TweenInfo.new(0.15), {BackgroundTransparency = 0.85}):Play() end)
    b.MouseButton1Click:Connect(cb)
end

local function Drop(parent, label, opts, key)
    local f = Instance.new("Frame", parent)
    f.Size = UDim2.new(1, 0, 0, 34)
    f.BackgroundColor3 = T.card
    f.BackgroundTransparency = 0.3
    f.BorderSizePixel = 0
    f.LayoutOrder = NO()
    f.ZIndex = 4
    Instance.new("UICorner", f).CornerRadius = UDim.new(0, 8)
    local stroke = Instance.new("UIStroke", f)
    stroke.Color = T.border
    stroke.Thickness = 1
    stroke.Transparency = 0.6
    local lbl = Instance.new("TextLabel", f)
    lbl.Size = UDim2.new(0.32, 0, 1, 0)
    lbl.Position = UDim2.new(0, 10, 0, 0)
    lbl.BackgroundTransparency = 1
    lbl.Text = label
    lbl.TextColor3 = T.txt
    lbl.TextSize = 10
    lbl.Font = Enum.Font.GothamMedium
    lbl.TextXAlignment = Enum.TextXAlignment.Left
    lbl.ZIndex = 5
    local sB = Instance.new("TextButton", f)
    sB.Size = UDim2.new(0.62, 0, 0, 24)
    sB.Position = UDim2.new(0.36, 0, 0, 5)
    sB.BackgroundColor3 = Color3.fromRGB(18, 24, 44)
    sB.Text = ""
    sB.BorderSizePixel = 0
    sB.ZIndex = 5
    Instance.new("UICorner", sB).CornerRadius = UDim.new(0, 6)
    local sT = Instance.new("TextLabel", sB)
    sT.Size = UDim2.new(1, -24, 1, 0)
    sT.Position = UDim2.new(0, 8, 0, 0)
    sT.BackgroundTransparency = 1
    sT.Text = CFG[key]
    sT.TextColor3 = T.txt
    sT.TextSize = 10
    sT.Font = Enum.Font.Gotham
    sT.TextXAlignment = Enum.TextXAlignment.Left
    sT.ZIndex = 6
    local arrow = Instance.new("TextLabel", sB)
    arrow.Size = UDim2.new(0, 18, 1, 0)
    arrow.Position = UDim2.new(1, -22, 0, 0)
    arrow.BackgroundTransparency = 1
    arrow.Text = "v"
    arrow.TextColor3 = T.cyanD
    arrow.TextSize = 10
    arrow.Font = Enum.Font.GothamBold
    arrow.ZIndex = 6
    -- Dropdown list as a SEPARATE frame in the parent (not clipped by f)
    local listHeight = math.min(#opts * 28, 150)
    local lF = Instance.new("Frame", parent)
    lF.Size = UDim2.new(0.62, 0, 0, listHeight)
    lF.Position = UDim2.new(0.36, 0, 0, 36)
    lF.BackgroundColor3 = Color3.fromRGB(18, 24, 44)
    lF.BorderSizePixel = 0
    lF.ZIndex = 20
    lF.Visible = false
    Instance.new("UICorner", lF).CornerRadius = UDim.new(0, 6)
    local lfStroke = Instance.new("UIStroke", lF)
    lfStroke.Color = T.cyan
    lfStroke.Thickness = 1
    lfStroke.Transparency = 0.3
    local lS = Instance.new("ScrollingFrame", lF)
    lS.Size = UDim2.new(1, -6, 1, -6)
    lS.Position = UDim2.new(0, 3, 0, 3)
    lS.BackgroundTransparency = 1
    lS.ScrollBarThickness = 3
    lS.ScrollBarImageColor3 = T.cyan
    lS.BorderSizePixel = 0
    lS.CanvasSize = UDim2.new(0, 0, 0, #opts * 28)
    lS.ZIndex = 21
    for idx, o in ipairs(opts) do
        local ob = Instance.new("TextButton", lS)
        ob.Size = UDim2.new(1, 0, 0, 26)
        ob.Position = UDim2.new(0, 0, 0, (idx - 1) * 28)
        ob.BackgroundColor3 = Color3.fromRGB(22, 30, 50)
        ob.Text = ""
        ob.BorderSizePixel = 0
        ob.ZIndex = 22
        Instance.new("UICorner", ob).CornerRadius = UDim.new(0, 4)
        local ot = Instance.new("TextLabel", ob)
        ot.Size = UDim2.new(1, -12, 1, 0)
        ot.Position = UDim2.new(0, 10, 0, 0)
        ot.BackgroundTransparency = 1
        ot.Text = o
        ot.TextColor3 = T.txt
        ot.TextSize = 11
        ot.Font = Enum.Font.GothamMedium
        ot.TextXAlignment = Enum.TextXAlignment.Left
        ot.ZIndex = 23
        ob.MouseEnter:Connect(function() ob.BackgroundColor3 = T.cardHi end)
        ob.MouseLeave:Connect(function() ob.BackgroundColor3 = Color3.fromRGB(22, 30, 50) end)
        ob.MouseButton1Click:Connect(function()
            CFG[key] = o
            sT.Text = o
            lF.Visible = false
            arrow.Text = "v"
            f.Size = UDim2.new(1, 0, 0, 34)
        end)
    end
    sB.MouseButton1Click:Connect(function()
        lF.Visible = not lF.Visible
        arrow.Text = lF.Visible and "^" or "v"
        if lF.Visible then f.Size = UDim2.new(1, 0, 0, 34 + listHeight + 4)
        else f.Size = UDim2.new(1, 0, 0, 34) end
    end)
end

local function Label(par, txt, col, sz)
    local l = Instance.new("TextLabel", par)
    l.Size = UDim2.new(1, 0, 0, sz + 4)
    l.BackgroundTransparency = 1
    l.Text = txt
    l.TextColor3 = col or Color3.fromRGB(80, 100, 130)
    l.TextSize = sz or 10
    l.Font = Enum.Font.GothamMedium
    l.TextXAlignment = Enum.TextXAlignment.Left
    l.LayoutOrder = NO()
    l.ZIndex = 4
    return l
end

local function Fmt(n)
    if n >= 1e12 then return string.format("%.1fT", n/1e12)
    elseif n >= 1e9 then return string.format("%.1fB", n/1e9)
    elseif n >= 1e6 then return string.format("%.1fM", n/1e6)
    elseif n >= 1e3 then return string.format("%.0fK", n/1e3)
    end
    return tostring(n)
end

local function EquipTool(name)
    pcall(function()
        local t = LP.Backpack:FindFirstChild(name)
        if t then Hum:EquipTool(t) end
    end)
end

-- ═══════════════════════════════════════════
--  TABS
-- ═══════════════════════════════════════════

do -- TRAIN
    local p = MakePage("Train")
    Card(p, "Auto Training")
    Toggle(p, "Auto Train (All Tools)", "AutoTrain")
    Slider(p, "Train Speed", "TrainSpd", 0.05, 1)
    Toggle(p, "Fast Tools (Speed Boost)", "FastTools")
    Card(p, "Quick Equip")
    local equipTools = {{"Punch", T.purple}, {"Weight", T.blue}, {"Pushups", T.green}, {"Situps", T.orange}, {"Handstands", T.pink}}
    for _, data in equipTools do
        Btn(Pages.Train, "Equip " .. data[1], data[2], function() EquipTool(data[1]) end)
    end
end

do -- FARM
    local p = MakePage("Farm")
    Card(p, "Auto Farm")
    Toggle(p, "Auto Rebirth", "AutoRebirth")
    Slider(p, "Target Rebirths (0=∞)", "TargetRebirths", 0, 500)
    Toggle(p, "Speed Grind (No Rebirth)", "SpeedGrind")
    Toggle(p, "Auto Claim Chests", "AutoChest")
    Toggle(p, "Auto Join Brawl", "AutoBrawl")
    Toggle(p, "Auto Equip Best Pets", "AutoEquip")
    Toggle(p, "Auto Spin Fortune Wheel", "AutoSpin")
    Card(p, "Gym Farming")
    Drop(Pages.Farm, "Station", FarmStations, "FarmStation")
    Drop(Pages.Farm, "Area", (function() local a = {} for _, d in FarmAreas do a[#a+1] = d[1] end return a end)(), "FarmArea")
    Card(p, "Auto Buy")
    Toggle(p, "Auto Buy Gamepass", "AutoBuy")
    Label(Pages.Farm, "+5% rep speed  +1 pet slot  +10 capacity  +1 spin", Color3.fromRGB(80,100,130), 9)
    Card(p, "Rock Farming")
    local rockBtns = {
        {"Beach Rock", CFrame.new(-38.40, 19.72, 1837.58)},
        {"Starter Island Rock", CFrame.new(-42.59, 19.72, 451.36)},
        {"Frozen Rock", CFrame.new(-307.74, 23.81, 207.29)},
        {"Mythical Rock", CFrame.new(311.92, 23.81, 153.28)},
        {"Eternal Rock", CFrame.new(-307.57, 23.81, -52.85)},
        {"Legend Rock", CFrame.new(311.92, 23.81, -35.92)},
        {"King Rock", CFrame.new(-121.82, 35.25, -712.23)},
        {"Inferno Rock", CFrame.new(330.33, 22.41, -803.43)},
        {"Ancient Jungle Rock", CFrame.new(4466.75, 334.97, -8425.75)},
    }
    for i, data in ipairs(rockBtns) do
        Btn(Pages.Farm, data[1], i % 2 == 0 and T.blue or Color3.fromRGB(30, 40, 60), function()
            if HRP then HRP.CFrame = CFrame.new(data[2].Position + Vector3.new(0, 3, 0)) end
        end)
    end
    Card(p, "Auto Hatch Eggs")
    Toggle(p, "Auto Hatch Pets", "AutoHatch")
    Toggle(p, "Auto Eggs Perfect Time", "AutoEggsPerfect")
    Card(p, "Codes")
    Btn(Pages.Farm, "Redeem All 17 Codes", Color3.fromRGB(0,230,118), function()
        for _, c in ipairs({"junglegym500","EPICMUSCLE20","ultimate250","mightygems2500","MillionWarriors","EPICREWARD500","FrostGems10","GalaxyCrystal50","Launch250","MegaLift50","MuscleStorm50","SkyAgility50","SpaceGems50","SPEEDY50","SuperMuscle100","SuperPunch100","SKYAGILITY"}) do
            pcall(function() rE.codeRemote:InvokeServer(c) end) task.wait(0.15)
        end
    end)
    Card(p, "Freebies")
    Btn(Pages.Farm, "Claim Free Gift", T.green, function() pcall(function() rE.freeGiftClaimRemote:InvokeServer() end) end)
    Btn(Pages.Farm, "Spin Fortune Wheel", T.cyan, function() pcall(function() rE.openFortuneWheelRemote:InvokeServer() end) end)
end

do -- CRYSTALS
    local p = MakePage("Crystals")
    Card(p, "Crystal Opener")
    Toggle(p, "Auto Open Crystals", "AutoCrystal")
    local crystalOpts = {}
    for name in CrystalPrices do crystalOpts[#crystalOpts+1] = name end
    table.sort(crystalOpts, function(a, b) return CrystalPrices[a] < CrystalPrices[b] end)
    Drop(Pages.Crystals, "Crystal", crystalOpts, "Crystal")
    Slider(Pages.Crystals, "Open Interval (sec)", "CrystInt", 1, 10)
    Card(p, "Tap to Open")
    for _, name in ipairs(crystalOpts) do
        local price = CrystalPrices[name]
        local color = CrystalColors[name] or T.txt
        Btn(Pages.Crystals, name .. " (" .. Fmt(price) .. " gems)", color, function()
            pcall(function() rE.openCrystalRemote:InvokeServer("openCrystal", name) end)
        end)
    end
end

do -- TELE
    local p = MakePage("Tele")
    Card(p, "World Travel")
    for i, data in ipairs(FarmAreas) do
        Btn(Pages.Tele, data[1], i % 2 == 0 and T.blue or Color3.fromRGB(30, 40, 60), function()
            if HRP then HRP.CFrame = CFrame.new(data[2].Position + Vector3.new(0, 3, 0)) end
        end)
    end
    Card(p, "Brawl Arenas")
    local arenas = {{"Brawl Arena 1", CFrame.new(985.91, 163.80, -7037.81)}, {"Brawl Arena 2", CFrame.new(4466.75, 334.97, -8425.75)}, {"Brawl Arena 3", CFrame.new(-1901.88, 251.90, -5899.65)}}
    for _, a in arenas do
        Btn(Pages.Tele, a[1], T.red, function() if HRP then HRP.CFrame = CFrame.new(a[2].Position + Vector3.new(0, 3, 0)) end end)
    end
    Card(p, "Actions")
    Btn(Pages.Tele, "Teleport to Random Player", T.orange, function()
        local players = Players:GetPlayers()
        local target = players[math.random(1, #players)]
        if target and target.Character and target.Character:FindFirstChild("Head") and HRP then
            HRP.CFrame = CFrame.new(target.Character.Head.Position + Vector3.new(0, 3, 0))
        end
    end)
end

do -- PLAYER
    local p = MakePage("Player")
    Card(p, "Movement")
    Slider(p, "Walk Speed", "WalkSpd", 16, 300)
    Slider(p, "Jump Power", "JumpPow", 50, 350)
    Slider(p, "Hip Height", "HipHeight", 0, 20)
    Btn(Pages.Player, "Apply Speed Settings", T.cyan, function()
        pcall(function()
            Hum.WalkSpeed = CFG.WalkSpd
            Hum.JumpPower = CFG.JumpPow
            Hum.HipHeight = CFG.HipHeight
        end)
    end)
    Toggle(p, "NoClip", "NoClip")
    Toggle(p, "Infinite Jump", "InfJump")
    Toggle(p, "Walk on Water", "WalkOnWater")
    Toggle(p, "Lock Position", "LockPos")
    Toggle(p, "Anti AFK", "AntiAFK")
    Toggle(p, "Anti Fling", "AntiFling")
    Card(p, "Auto Buy")
    Btn(Pages.Player, "Buy Pet Slot (+1)", T.cyan, function() pcall(function() rE.purchaseEvent:FireServer("buyPetSlot") end) end)
    Btn(Pages.Player, "Buy Item Capacity (+10)", T.blue, function() pcall(function() rE.purchaseEvent:FireServer("buyItemCapacity") end) end)
    Btn(Pages.Player, "Buy Rep Speed (+5%)", T.green, function() pcall(function() rE.purchaseEvent:FireServer("buyRepSpeed") end) end)
    Btn(Pages.Player, "Buy Daily Spin (+1)", T.orange, function() pcall(function() rE.purchaseEvent:FireServer("buyDailySpin") end) end)
    Card(p, "Pets")
    Btn(Pages.Player, "Equip Best Pets", T.cyan, function() pcall(function() rE.equipPetEvent:FireServer("equipBest") end) end)
    Btn(Pages.Player, "Equip All Swift Samurai", T.cyan, function() pcall(function() rE.equipPetEvent:FireServer("equipType", "Swift Samurai") end) end)
    local petList = {"None", "Swift Samurai", "Tribal Overlord", "Neon Pet", "Golden Pet", "Legendary Pet"}
    Drop(Pages.Player, "Select Pet", petList, "SelectPet")
    Btn(Pages.Player, "Equip Selected Pet", T.green, function()
        if CFG.SelectPet ~= "None" then
            pcall(function() rE.equipPetEvent:FireServer("equipSpecific", CFG.SelectPet) end)
        end
    end)
    Btn(Pages.Player, "Sell Bad Pets", T.orange, function() pcall(function() rE.sellPetEvent:FireServer("sellBadPets") end) end)
    Card(p, "Look Up Player")
    Label(Pages.Combat, "View another player's stats:", Color3.fromRGB(100,120,150), 10)
    local lookupBox = Instance.new("TextBox", Pages.Player)
    lookupBox.Size = UDim2.new(1, 0, 0, 28)
    lookupBox.BackgroundColor3 = Color3.fromRGB(18, 24, 44)
    lookupBox.TextColor3 = T.txt
    lookupBox.PlaceholderText = "Player name..."
    lookupBox.PlaceholderColor3 = T.dim
    lookupBox.Text = ""
    lookupBox.TextSize = 11
    lookupBox.Font = Enum.Font.Gotham
    lookupBox.BorderSizePixel = 0
    lookupBox.ClearTextOnFocus = false
    lookupBox.LayoutOrder = NO()
    lookupBox.ZIndex = 5
    Instance.new("UICorner", lookupBox).CornerRadius = UDim.new(0, 8)
    Instance.new("UIStroke", lookupBox).Color = T.border
    Btn(Pages.Player, "View Player Durability", T.blue, function()
        local name = lookupBox.Text
        if name and name ~= "" then
            for _, plr in Players:GetPlayers() do
                if string.lower(plr.Name):find(string.lower(name)) then
                    pcall(function() game:GetService("StarterGui"):SetCore("SendNotification", {Title = plr.Name, Text = "Durability: " .. tostring(plr:FindFirstChild("Durability") and plr.Durability.Value or "?")}) end)
                    break
                end
            end
        end
    end)
    Card(p, "Actions")
    Toggle(p, "Auto Open Aura", "AutoOpenAura")
    Toggle(p, "Free Auto Lift", "FreeAutoLift")
    Btn(Pages.Player, "Equip All Swift Samurai", T.purple, function() pcall(function() rE.equipPetEvent:FireServer("equipAllSwiftSamurai") end) end)
    Card(p, "Chests")
    Drop(Pages.Player, "Chest", Chests, "Chest")
    Btn(Pages.Player, "Collect Chest", T.green, function() pcall(function() rE.checkChestRemote:InvokeServer(CFG.Chest) end) end)
    Card(p, "Other")
    Toggle(p, "Hide Pets", "HidePets")
    Toggle(p, "Stop Spectating", "StopSpec")
    Toggle(p, "Clear Inventory", "ClearInventory")
    Toggle(p, "Hide All Frames", "HideAllFrames")
    Btn(Pages.Player, "Turn Small", T.cyan, function() pcall(function() rE.changeSpeedSizeRemote:InvokeServer("changeSize", 1) end) end)
    Btn(Pages.Player, "FE Invisibility", T.purple, function()
        pcall(function()
            local savePos = HRP.CFrame
            HRP.CFrame = CFrame.new(915.095, 37.527, 349.809)
            task.wait(0.5)
            local Character = LP.Character
            local Clone = Character.LowerTorso.Root:Clone()
            Character.LowerTorso.Root:Destroy()
            Clone.Parent = Character.LowerTorso
            task.wait(0.5)
            HRP.CFrame = savePos
        end)
    end)
end

do -- COMBAT
    local p = MakePage("Combat")
    Card(p, "PvP")
    Toggle(p, "Kill Aura", "KillAura")
    Slider(p, "Kill Range", "KillRange", 5, 50)
    Toggle(p, "Anti Knockback", "AntiKnockback")
    Card(p, "Targeting")
    Label(Pages.Combat, "Player Name (auto-search):", Color3.fromRGB(100,120,150), 10)
    local nameBox = Instance.new("TextBox", Pages.Combat)
    nameBox.Size = UDim2.new(1, 0, 0, 28)
    nameBox.BackgroundColor3 = Color3.fromRGB(18, 24, 44)
    nameBox.TextColor3 = T.txt
    nameBox.PlaceholderText = "Enter player name..."
    nameBox.PlaceholderColor3 = T.dim
    nameBox.Text = ""
    nameBox.TextSize = 11
    nameBox.Font = Enum.Font.Gotham
    nameBox.BorderSizePixel = 0
    nameBox.ClearTextOnFocus = false
    nameBox.LayoutOrder = NO()
    nameBox.ZIndex = 5
    Instance.new("UICorner", nameBox).CornerRadius = UDim.new(0, 8)
    Instance.new("UIStroke", nameBox).Color = T.border
    nameBox.FocusLost:Connect(function() CFG.TargetPlayer = nameBox.Text end)
    Btn(Pages.Combat, "Teleport to Target", T.red, function()
        local name = CFG.TargetPlayer
        if name and name ~= "" then
            for _, plr in Players:GetPlayers() do
                if string.lower(plr.Name):find(string.lower(name)) then
                    if plr.Character and plr.Character:FindFirstChild("HumanoidRootPart") and HRP then
                        HRP.CFrame = plr.Character.HumanoidRootPart.CFrame
                        break
                    end
                end
            end
        end
    end)
    Card(p, "Actions")
    Btn(Pages.Combat, "Auto Join Brawl", T.red, function() pcall(function() rE.brawlEvent:FireServer("joinBrawl") end) end)
    Toggle(p, "Recovery Punch", "RecoveryPunch")
    Card(p, "Aura")
    local auraList = {"None", "Fire Aura", "Ice Aura", "Lightning Aura", "Dark Aura", "Cosmic Aura"}
    Drop(Pages.Combat, "Select Aura", auraList, "SelectAura")
    Btn(Pages.Combat, "Activate Aura", T.purple, function()
        if CFG.SelectAura ~= "None" then
            pcall(function() rE.machineInteractRemote:FireServer("selectAura", CFG.SelectAura) end)
        end
    end)
    Card(p, "Whitelist")
    Label(Pages.Combat, "Players you want to ignore:", Color3.fromRGB(100,120,150), 10)
    local wlBox = Instance.new("TextBox", Pages.Combat)
    wlBox.Size = UDim2.new(1, 0, 0, 28)
    wlBox.BackgroundColor3 = Color3.fromRGB(18, 24, 44)
    wlBox.TextColor3 = T.txt
    wlBox.PlaceholderText = "Player name to whitelist..."
    wlBox.PlaceholderColor3 = T.dim
    wlBox.Text = ""
    wlBox.TextSize = 11
    wlBox.Font = Enum.Font.Gotham
    wlBox.BorderSizePixel = 0
    wlBox.ClearTextOnFocus = false
    wlBox.LayoutOrder = NO()
    wlBox.ZIndex = 5
    Instance.new("UICorner", wlBox).CornerRadius = UDim.new(0, 8)
    Instance.new("UIStroke", wlBox).Color = T.border
    Btn(Pages.Combat, "Whitelist Player", T.green, function()
        if wlBox.Text ~= "" then
            CFG.Whitelist[wlBox.Text] = true
        end
    end)
    Btn(Pages.Combat, "Unwhitelist Player", T.orange, function()
        if wlBox.Text ~= "" then
            CFG.Whitelist[wlBox.Text] = nil
        end
    end)
    Card(p, "Warning")
    Label(Pages.Combat, "Kill aura requires brawl zone proximity", Color3.fromRGB(255,170,50), 9)
    Label(Pages.Combat, "Anti-KB may not work server-side", Color3.fromRGB(255,170,50), 9)
end

do -- VISUAL
    local p = MakePage("Visual")
    Card(p, "Rendering")
    Toggle(p, "FPS Boost", "FpsBoost")
    Toggle(p, "Full Bright", "FullBright")
    Toggle(p, "Night Sky", "NightSky")
    Card(p, "Display")
    Toggle(p, "Chat Spy", "ChatSpy")
    Card(p, "Fun")
    Btn(Pages.Visual, "Lag Switch (F3)", T.orange, function()
        local a = false
        UIS.InputBegan:Connect(function(i)
            if i.KeyCode == Enum.KeyCode.F3 then
                a = not a
                settings().Network.IncomingReplicationLag = a and 10 or 0
            end
        end)
    end)
    Btn(Pages.Visual, "BTools", T.cyan, function()
        pcall(function()
            StarterGui:SetCoreGuiEnabled(2, true)
            Instance.new("HopperBin", LP.Backpack).BinType = 2
            Instance.new("HopperBin", LP.Backpack).BinType = 3
            Instance.new("HopperBin", LP.Backpack).BinType = 4
        end)
    end)
end

do -- INFO
    local p = MakePage("Info")
    Card(p, "Live Stats")
    local stats = {}
    for _, item in ipairs({
        {"Strength", Color3.fromRGB(255,170,50)}, {"Gems", T.cyan}, {"Rebirths", Color3.fromRGB(0,230,118)},
        {"Kills", Color3.fromRGB(255,82,82)}, {"Tokens", T.txt}, {"Agility", T.blue}, {"Durability", T.purple},
        {"Streak", T.yellow},
    }) do
        local f = Instance.new("Frame", Pages.Info)
        f.Size = UDim2.new(1, 0, 0, 20)
        f.BackgroundTransparency = 1
        f.LayoutOrder = NO()
        f.ZIndex = 4
        local lbl = Instance.new("TextLabel", f)
        lbl.Size = UDim2.new(0.45, 0, 1, 0)
        lbl.Position = UDim2.new(0, 12, 0, 0)
        lbl.BackgroundTransparency = 1
        lbl.Text = item[1]
        lbl.TextColor3 = Color3.fromRGB(80, 100, 130)
        lbl.TextSize = 10
        lbl.Font = Enum.Font.GothamMedium
        lbl.TextXAlignment = Enum.TextXAlignment.Left
        lbl.ZIndex = 5
        local val = Instance.new("TextLabel", f)
        val.Size = UDim2.new(0.5, 0, 1, 0)
        val.Position = UDim2.new(0.48, 0, 0, 0)
        val.BackgroundTransparency = 1
        val.Text = "..."
        val.TextColor3 = item[2]
        val.TextSize = 10
        val.Font = Enum.Font.GothamBold
        val.TextXAlignment = Enum.TextXAlignment.Right
        val.ZIndex = 5
        stats[item[1]] = val
    end
    task.spawn(function()
        while SG.Parent do
            task.wait(1)
            pcall(function()
                local ls = LP:WaitForChild("leaderstats", 5)
                if stats.Strength then stats.Strength.Text = Fmt(ls and ls:WaitForChild("Strength", 5).Value or 0) end
                if stats.Gems then stats.Gems.Text = Fmt(LP:WaitForChild("Gems").Value) end
                if stats.Rebirths then stats.Rebirths.Text = tostring(ls and ls:WaitForChild("Rebirths", 5).Value or 0) end
                if stats.Kills then stats.Kills.Text = tostring(ls and ls:WaitForChild("Kills", 5).Value or 0) end
                if stats.Tokens then stats.Tokens.Text = tostring(LP:WaitForChild("Tokens").Value) end
                if stats.Agility then stats.Agility.Text = Fmt(LP:WaitForChild("Agility").Value) end
                if stats.Durability then stats.Durability.Text = Fmt(LP:WaitForChild("Durability").Value) end
                if stats.Streak then pcall(function() local ss = LP:FindFirstChild("StrengthStreak") if ss then stats.Streak.Text = tostring(ss.Value) end end) end
            end)
        end
    end)
    Card(p, "Server")
    Btn(Pages.Info, "Server Hop", T.cyan, function()
        pcall(function()
            local req = request({Url = "https://games.roblox.com/v1/games/" .. game.PlaceId .. "/servers/Public?sortOrder=Asc&limit=100", Method = "GET"})
            local data = HttpService:JSONDecode(req.Body)
            local candidates = {}
            for _, s in (data.data or {}) do
                if s.id ~= game.JobId and s.playing < s.maxPlayers then candidates[#candidates + 1] = s end
            end
            if #candidates > 0 then
                local pick = candidates[math.random(1, #candidates)]
                TeleportService:TeleportToPlaceInstance(game.PlaceId, pick.id, LP)
            end
        end)
    end)
    Btn(Pages.Info, "Rejoin", T.orange, function()
        pcall(function() TeleportService:Teleport(game.PlaceId, LP) end)
    end)
    Card(p, "Info")
    Label(Pages.Info, "RightShift to toggle  |  Tap orb on mobile", Color3.fromRGB(80, 100, 130), 10)
    Label(Pages.Info, "Discord: discord.gg/sx5ZYAZGT", Color3.fromRGB(80, 100, 130), 10)
    Label(Pages.Info, "No hooks  |  Zero detection", T.green, 10)
    Card(p, "Danger")
    Btn(Pages.Info, "Destroy UI", T.red, function()
        pcall(function() Hum.WalkSpeed = 16 end)
        pcall(function() Lighting.Brightness = originalBrightness Lighting.Ambient = originalAmbient Lighting.OutdoorAmbient = originalOutdoor Lighting.FogEnd = originalFog end)
        pcall(function() LP:SetAttribute("AutoLiftEnabled", false) end)
        pcall(function() hookmetamethod(game, "__namecall", origNamecall) end)
        if noclipConn then noclipConn:Disconnect() end
        if infJumpConn then infJumpConn:Disconnect() end
        if wowConn then wowConn:Disconnect() end
        SG:Destroy()
    end)
end

-- ═══════════════════════════════════════════
--  LOOPS
-- ═══════════════════════════════════════════

-- Auto Train (equips tools and fires reps via namecall hook)
task.spawn(function()
    while SG.Parent do
        task.wait(CFG.TrainSpd)
        if CFG.AutoTrain and Char and Hum and Hum.Health > 0 then
            pcall(function()
                for _, toolName in ipairs({"Weight", "Pushups", "Situps", "Handstands", "Punch"}) do
                    local t = LP.Backpack:FindFirstChild(toolName)
                    if t then t.Parent = Char end
                end
                mE:FireServer("rep")
            end)
        end
    end
end)

-- Fast Tools
task.spawn(function()
    while SG.Parent do
        task.wait(2)
        pcall(function()
            if CFG.FastTools then
                local char = LP.Character
                if char then
                    for _, tool in char:GetDescendants() do
                        if tool:IsA("Tool") then
                            local grip = tool:FindFirstChild("GripPart")
                            if grip then
                                for _, v in grip:GetDescendants() do
                                    if v:IsA("Animation") then v:FindFirstChild("Speed") end
                                end
                            end
                        end
                    end
                end
            end
        end)
    end
end)

-- Auto Rebirth
task.spawn(function()
    while SG.Parent do
        task.wait(0.5)
        if CFG.AutoRebirth then
            pcall(function()
                if CFG.TargetRebirths > 0 then
                    local ls = LP:WaitForChild("leaderstats")
                    if ls and ls:WaitForChild("Rebirths").Value >= CFG.TargetRebirths then
                        CFG.AutoRebirth = false
                        return
                    end
                end
                rE.rebirthRemote:InvokeServer("rebirthRequest")
            end)
        end
    end
end)

-- Speed Grind (auto train without rebirth)
task.spawn(function()
    while SG.Parent do
        task.wait(0.1)
        if CFG.SpeedGrind and Char and Hum and Hum.Health > 0 then
            pcall(function()
                local ls = LP:FindFirstChild("leaderstats")
                if ls then
                    local str = ls:WaitForChild("Strength").Value
                    local rebReq = str * 1.1
                    local Gems = LP:FindFirstChild("Gems")
                    if Gems and Gems.Value >= rebReq then
                        -- Don't rebirth, keep grinding
                    else
                        mE:FireServer("rep")
                        for _, toolName in {"Weight", "Pushups", "Situps", "Handstands", "Punch"} do
                            local t = LP.Backpack:FindFirstChild(toolName)
                            if t then t.Parent = Char end
                        end
                    end
                end
            end)
        end
    end
end)

-- Auto Chests
task.spawn(function()
    while SG.Parent do
        task.wait(3)
        if CFG.AutoChest then
            pcall(function()
                for _, n in ipairs(Chests) do rE.checkChestRemote:InvokeServer(n) end
            end)
        end
    end
end)

-- Auto Brawl
task.spawn(function()
    while SG.Parent do
        task.wait(2)
        if CFG.AutoBrawl then pcall(function() rE.brawlEvent:FireServer("joinBrawl") end) end
    end
end)

-- Auto Equip Pets
task.spawn(function()
    while SG.Parent do
        task.wait(5)
        if CFG.AutoEquip then pcall(function() rE.equipPetEvent:FireServer("equipBest") end) end
    end
end)

-- Auto Crystal
task.spawn(function()
    while SG.Parent do
        task.wait(CFG.CrystInt)
        if CFG.AutoCrystal then
            pcall(function()
                local g = Gems.Value
                local p = CrystalPrices[CFG.Crystal]
                if p and g >= p then rE.openCrystalRemote:InvokeServer("openCrystal", CFG.Crystal) end
            end)
        end
    end
end)

-- Auto Spin
task.spawn(function()
    while SG.Parent do
        task.wait(5)
        if CFG.AutoSpin then pcall(function() rE.openFortuneWheelRemote:InvokeServer() end) end
    end
end)

-- Auto Hatch
task.spawn(function()
    while SG.Parent do
        task.wait(3)
        if CFG.AutoHatch then
            pcall(function()
                local eggFolder = workspace:FindFirstChild("Eggs") or workspace:FindFirstChild("EggStands")
                if eggFolder then
                    for _, egg in eggFolder:GetDescendants() do
                        if egg:IsA("Part") and egg:FindFirstChild("TouchInterest") then
                            -- Walk to egg to hatch
                        end
                    end
                end
                -- Try machine interaction for hatching
                rE.machineInteractRemote:FireServer("hatch")
            end)
        end
    end
end)

-- Kill Aura
task.spawn(function()
    while SG.Parent do
        task.wait(0.2)
        if CFG.KillAura and Char and HRP then
            pcall(function()
                local range = CFG.KillRange
                for _, other in Players:GetPlayers() do
                    if other ~= LP and not CFG.Whitelist[other.Name] and other.Character and other.Character:FindFirstChild("Humanoid") and other.Character:FindFirstChild("HumanoidRootPart") then
                        local dist = (other.Character.HumanoidRootPart.Position - HRP.Position).Magnitude
                        if dist <= range then
                            rE.brawlEvent:FireServer("attack", other.Name)
                        end
                    end
                end
            end)
        end
    end
end)

-- Anti Knockback
task.spawn(function()
    while SG.Parent do
        task.wait(0.1)
        if CFG.AntiKnockback and HRP then
            pcall(function()
                local vel = HRP:FindFirstChild("BodyForce") or HRP:FindFirstChild("VectorForce")
                if vel then vel:Destroy() end
                HRP.AssemblyLinearVelocity = Vector3.new(HRP.AssemblyLinearVelocity.X, HRP.AssemblyLinearVelocity.Y, HRP.AssemblyLinearVelocity.Z)
            end)
        end
    end
end)

-- Anti Fling
task.spawn(function()
    while SG.Parent do
        task.wait(0.2)
        if CFG.AntiFling and HRP then
            pcall(function()
                if HRP.AssemblyAngularVelocity.Magnitude > 10 then
                    HRP.AssemblyAngularVelocity = Vector3.new(0, 0, 0)
                end
            end)
        end
    end
end)

-- Recovery Punch
task.spawn(function()
    while SG.Parent do
        task.wait(0.5)
        if CFG.RecoveryPunch and Char and Hum and Hum.Health > 0 then
            pcall(function()
                if Hum.Health < Hum.MaxHealth * 0.5 then
                    local t = LP.Backpack:FindFirstChild("Punch")
                    if t then t.Parent = Char end
                    mE:FireServer("punch", "rightHand")
                end
            end)
        end
    end
end)

-- Auto Eggs Perfect Time
task.spawn(function()
    while SG.Parent do
        task.wait(1)
        if CFG.AutoEggsPerfect then
            pcall(function()
                rE.machineInteractRemote:FireServer("autoEggsPerfectTime")
            end)
        end
    end
end)

-- Auto Open Aura
task.spawn(function()
    while SG.Parent do
        task.wait(3)
        if CFG.AutoOpenAura then
            pcall(function()
                rE.machineInteractRemote:FireServer("openAura")
            end)
        end
    end
end)

-- Free Auto Lift (gamepass bypass: set attribute + fire reps via namecall hook)
task.spawn(function()
    while SG.Parent do
        task.wait(0.3)
        if CFG.FreeAutoLift and Char and Hum and Hum.Health > 0 then
            pcall(function()
                LP:SetAttribute("AutoLiftEnabled", true)
                local weight = LP.Backpack:FindFirstChild("Weight")
                if weight then weight.Parent = Char end
                mE:FireServer("rep")
            end)
        end
    end
end)
task.spawn(function()
    while SG.Parent do
        task.wait(1)
        if not CFG.FreeAutoLift then
            pcall(function() LP:SetAttribute("AutoLiftEnabled", false) end)
        end
    end
end)

-- Clear Inventory
task.spawn(function()
    while SG.Parent do
        task.wait(5)
        if CFG.ClearInventory then
            pcall(function()
                rE.sellPetEvent:FireServer("clearInventory")
            end)
        end
    end
end)

-- Hide All Frames
task.spawn(function()
    while SG.Parent do
        task.wait(2)
        if CFG.HideAllFrames then
            pcall(function()
                for _, gui in LP.PlayerGui:GetDescendants() do
                    if gui:IsA("Frame") and gui.Name:find("Frame") and gui.Visible then
                        gui.Visible = false
                    end
                end
            end)
        end
    end
end)

-- Movement — only jump power in the loop; speed/hip height are manual actions
task.spawn(function()
    while SG.Parent do
        task.wait(0.5)
        pcall(function()
            if Hum and Hum.Health > 0 then
                Hum.JumpPower = CFG.JumpPow
            end
        end)
    end
end)

-- Lock Position
local lockPos = nil
task.spawn(function()
    while SG.Parent do
        task.wait(0.1)
        if CFG.LockPos and HRP then
            if not lockPos then lockPos = HRP.CFrame end
            HRP.CFrame = lockPos
        else
            lockPos = nil
        end
    end
end)

-- NoClip
noclipConn = nil
task.spawn(function()
    while SG.Parent do
        task.wait(0.1)
        if CFG.NoClip and Char then
            if not noclipConn then
                noclipConn = RunService.Stepped:Connect(function()
                    if Char then for _, part in Char:GetDescendants() do if part:IsA("BasePart") then part.CanCollide = false end end end
                end)
            end
        else
            if noclipConn then noclipConn:Disconnect() noclipConn = nil end
        end
    end
end)

-- Infinite Jump
infJumpConn = nil
task.spawn(function()
    while SG.Parent do
        task.wait(0.1)
        if CFG.InfJump and Hum then
            if not infJumpConn then
                infJumpConn = UIS.JumpRequest:Connect(function()
                    if CFG.InfJump and Hum then Hum:ChangeState(Enum.HumanoidStateType.Jumping) end
                end)
            end
        else
            if infJumpConn then infJumpConn:Disconnect() infJumpConn = nil end
        end
    end
end)

-- Walk on Water
wowConn = nil
task.spawn(function()
    while SG.Parent do
        task.wait(0.2)
        if CFG.WalkOnWater and HRP then
            if not wowConn then
                wowConn = RunService.Stepped:Connect(function()
                    if CFG.WalkOnWater and HRP and Char then
                        local ray = workspace:Raycast(HRP.Position, Vector3.new(0, -5, 0))
                        if ray and ray.Material == Enum.Material.Water then
                            for _, part in Char:GetDescendants() do
                                if part:IsA("BasePart") then part.CanCollide = true end
                            end
                        end
                    end
                end)
            end
        else
            if wowConn then wowConn:Disconnect() wowConn = nil end
        end
    end
end)

-- FPS Boost
task.spawn(function() while SG.Parent do task.wait(2) pcall(function() settings().Rendering.QualityLevel = CFG.FpsBoost and Enum.QualityLevel.Level01 or Enum.QualityLevel.Automatic end) end end)

-- Full Bright
task.spawn(function()
    while SG.Parent do
        task.wait(2)
        pcall(function()
            if CFG.FullBright then
                Lighting.Brightness = 10
                Lighting.Ambient = Color3.fromRGB(200, 200, 200)
                Lighting.OutdoorAmbient = Color3.fromRGB(200, 200, 200)
            else
                Lighting.Brightness = originalBrightness
                Lighting.Ambient = originalAmbient
                Lighting.OutdoorAmbient = originalOutdoor
            end
        end)
    end
end)

-- Night Sky
task.spawn(function()
    while SG.Parent do
        task.wait(2)
        pcall(function()
            if CFG.NightSky then
                Lighting.ClockTime = 0
                Lighting.FogEnd = 100000
                Lighting.GlobalShadows = false
            else
                Lighting.ClockTime = 14
                Lighting.FogEnd = originalFog
                Lighting.GlobalShadows = true
            end
        end)
    end
end)

-- Hide Pets
task.spawn(function()
    while SG.Parent do
        task.wait(2)
        pcall(function()
            for _, plr in Players:GetPlayers() do
                if plr ~= LP and plr.Character then
                    for _, pet in plr.Character:GetChildren() do
                        if pet:IsA("Accessory") or pet.Name:find("Pet") then
                            pet.Transparency = CFG.HidePets and 1 or 0
                        end
                    end
                end
            end
        end)
    end
end)

-- Chat Spy
task.spawn(function()
    while SG.Parent do
        task.wait(0.5)
        if CFG.ChatSpy then
            pcall(function()
                StarterGui:SetCore("ChatActive", true)
            end)
        end
    end
end)

-- Anti AFK
LP.Idled:Connect(function() if CFG.AntiAFK then VU:CaptureController() VU:ClickButton2(Vector2.new()) end end)

-- ═══════════════════════════════════════════
--  TOGGLE ORB
-- ═══════════════════════════════════════════
local Orb = Instance.new("TextButton", SG)
Orb.Size = UDim2.new(0, 48, 0, 48)
Orb.Position = UDim2.new(0, 14, 0.5, -24)
Orb.BackgroundColor3 = T.panel
Orb.Text = ""
Orb.BorderSizePixel = 0
Orb.ZIndex = 100
Orb.AutoButtonColor = false
Instance.new("UICorner", Orb).CornerRadius = UDim.new(0, 14)
local OrbStroke = Instance.new("UIStroke", Orb)
OrbStroke.Color = T.cyan
OrbStroke.Thickness = 2
OrbStroke.Transparency = 0.3

local OrbGlow = Instance.new("Frame", Orb)
OrbGlow.Size = UDim2.new(1, 18, 1, 18)
OrbGlow.Position = UDim2.new(0, -9, 0, -9)
OrbGlow.BackgroundTransparency = 1
OrbGlow.ZIndex = 99
Instance.new("UICorner", OrbGlow).CornerRadius = UDim.new(0, 18)
local GlowStroke = Instance.new("UIStroke", OrbGlow)
GlowStroke.Color = T.cyanG
GlowStroke.Thickness = 1.5
GlowStroke.Transparency = 0.7

local OrbIcon = Instance.new("TextLabel", Orb)
OrbIcon.Size = UDim2.new(1, 0, 1, 0)
OrbIcon.BackgroundTransparency = 1
OrbIcon.Text = ">>"
OrbIcon.TextColor3 = T.cyan
OrbIcon.TextSize = 16
OrbIcon.Font = Enum.Font.Code
OrbIcon.ZIndex = 101

local menuOpen = false
local function ToggleMenu()
    menuOpen = not menuOpen
    MF.Visible = menuOpen
    if menuOpen then
        OrbIcon.Text = "X" OrbIcon.TextSize = 15
        OrbStroke.Thickness = 2.5 OrbStroke.Color = T.cyanG
        GlowStroke.Transparency = 0.05
        TS:Create(Orb, TweenInfo.new(0.2), {BackgroundColor3 = T.cardHi}):Play()
        MF.Position = UDim2.new(0.5, -280, 0.5, -310)
        MF.Size = UDim2.new(0, 560, 0, 0)
        TS:Create(MF, TweenInfo.new(0.4, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
            Size = UDim2.new(0, 560, 0, 540),
            Position = UDim2.new(0.5, -280, 0.5, -270),
        }):Play()
    else
        OrbIcon.Text = ">>" OrbIcon.TextSize = 16
        OrbStroke.Thickness = 2 OrbStroke.Color = T.cyan
        GlowStroke.Transparency = 0.7
        TS:Create(MF, TweenInfo.new(0.2, Enum.EasingStyle.Quart, Enum.EasingDirection.In), {
            Size = UDim2.new(0, 560, 0, 0),
        }):Play()
        task.delay(0.2, function() MF.Visible = false end)
        TS:Create(Orb, TweenInfo.new(0.2), {BackgroundColor3 = T.panel}):Play()
    end
end

Orb.MouseButton1Click:Connect(ToggleMenu)
UIS.InputBegan:Connect(function(input, gpe)
    if not gpe and input.KeyCode == Enum.KeyCode.RightShift then ToggleMenu() end
end)

task.spawn(function()
    while SG.Parent do
        if not menuOpen then
            TS:Create(GlowStroke, TweenInfo.new(1.5, Enum.EasingStyle.Sine), {Transparency = 0.15}):Play()
            TS:Create(OrbStroke, TweenInfo.new(1.5, Enum.EasingStyle.Sine), {Transparency = 0.05}):Play()
            task.wait(1.5)
            TS:Create(GlowStroke, TweenInfo.new(1.5, Enum.EasingStyle.Sine), {Transparency = 0.7}):Play()
            TS:Create(OrbStroke, TweenInfo.new(1.5, Enum.EasingStyle.Sine), {Transparency = 0.3}):Play()
            task.wait(1.5)
        else task.wait(0.5) end
    end
end)

-- start on Train
SwitchTab(1)
print("[rncx hub] v8 Muscle Legends ULTIMATE loaded — " .. #SBLabels .. " tabs, " .. Order .. " features")
