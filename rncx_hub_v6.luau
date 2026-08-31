-- ═══════════════════════════════════════════════════════════════
--  rncx hub v6 — Muscle Legends: New Players
--  CYBERPUNK NEON • Sidebar Nav • Glass Cards
-- ═══════════════════════════════════════════════════════════════

local Players = game:GetService("Players")
local RS = game:GetService("ReplicatedStorage")
local UIS = game:GetService("UserInputService")
local TS = game:GetService("TweenService")
local VU = game:GetService("VirtualUser")
local LP = Players.LocalPlayer
local PG = LP:WaitForChild("PlayerGui")

local Char = LP.Character or LP.CharacterAdded:Wait()
local Hum = Char:WaitForChild("Humanoid")
local HRP = Char:WaitForChild("HumanoidRootPart")
LP.CharacterAdded:Connect(function(c)
    Char = c Hum = c:WaitForChild("Humanoid") HRP = c:WaitForChild("HumanoidRootPart")
    task.wait(0.5)
    pcall(function() Hum.WalkSpeed = 16 Hum.JumpPower = 50 end)
end)

local rE = RS:WaitForChild("rEvents")
local mE = LP:WaitForChild("muscleEvent")
local Gems = LP:WaitForChild("Gems")

local CFG = {
    AutoPunch = false, AutoRep = false, AutoChest = false, AutoCrystal = false,
    AutoRebirth = false, AutoBrawl = false, AutoGroup = false, AutoEquip = false,
    FpsBoost = false, NoClip = false, AntiAFK = false,
    PunchSpd = 0.15, RepSpd = 0.5, CrystInt = 3,
    Crystal = "Blue Crystal", Area = "Beach", ChestArea = "goldenChest",
    WalkSpd = 16, JumpPow = 50,
}

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

-- ── CYBERPUNK THEME ────────────────────────
local T = {
    bg      = Color3.fromRGB(5, 8, 18),
    panel   = Color3.fromRGB(10, 14, 28),
    card    = Color3.fromRGB(14, 20, 38),
    cardHi  = Color3.fromRGB(20, 28, 52),
    border  = Color3.fromRGB(30, 50, 80),
    cyan    = Color3.fromRGB(0, 220, 255),
    cyanD   = Color3.fromRGB(0, 140, 180),
    cyanG   = Color3.fromRGB(0, 255, 255),
    blue    = Color3.fromRGB(60, 120, 255),
    purple  = Color3.fromRGB(140, 70, 255),
    pink    = Color3.fromRGB(255, 50, 150),
    txt     = Color3.fromRGB(220, 235, 255)
}

local old = PG:FindFirstChild("rncxHub")
if old then old:Destroy() end

local SG = Instance.new("ScreenGui", PG)
SG.Name = "rncxHub"
SG.ResetOnSpawn = false
SG.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
SG.DisplayOrder = 999

-- ═══════════════════════════════════════════
--  MAIN FRAME — vertical layout with sidebar
-- ═══════════════════════════════════════════
local MF = Instance.new("Frame", SG)
MF.Name = "Main"
MF.Size = UDim2.new(0, 540, 0, 0)
MF.Position = UDim2.new(0.5, -270, 0.5, -280)
MF.BackgroundColor3 = T.bg
MF.BackgroundTransparency = 0
MF.BorderSizePixel = 0
MF.Active = true
MF.Draggable = true
MF.ClipsDescendants = true
MF.Visible = false

local mfCorner = Instance.new("UICorner", MF)
mfCorner.CornerRadius = UDim.new(0, 16)

local mfStroke = Instance.new("UIStroke", MF)
mfStroke.Color = T.border
mfStroke.Thickness = 1

-- ═══════════════════════════════════════════
--  SIDEBAR (left, 80px wide — with labels)
-- ═══════════════════════════════════════════
local SB = Instance.new("Frame", MF)
SB.Size = UDim2.new(0, 80, 1, 0)
SB.BackgroundColor3 = T.panel
SB.BorderSizePixel = 0
Instance.new("UICorner", SB).CornerRadius = UDim.new(0, 16)

-- cover right corners
local SBRight = Instance.new("Frame", SB)
SBRight.Size = UDim2.new(0, 10, 1, 0)
SBRight.Position = UDim2.new(1, -10, 0, 0)
SBRight.BackgroundColor3 = T.panel
SBRight.BorderSizePixel = 0

-- logo area
local Logo = Instance.new("TextLabel", SB)
Logo.Size = UDim2.new(1, 0, 0, 40)
Logo.BackgroundTransparency = 1
Logo.Text = "R"
Logo.TextColor3 = T.cyan
Logo.TextSize = 20
Logo.Font = Enum.Font.GothamBlack
Logo.ZIndex = 5

local LogoLine = Instance.new("Frame", SB)
LogoLine.Size = UDim2.new(0.6, 0, 0, 1)
LogoLine.Position = UDim2.new(0.2, 0, 0, 42)
LogoLine.BackgroundColor3 = T.cyan
LogoLine.BackgroundTransparency = 0.5
LogoLine.BorderSizePixel = 0
Instance.new("UICorner", LogoLine).CornerRadius = UDim.new(1, 0)

-- sidebar buttons
local SBLabels = {"Train", "Farm", "Tele", "Player", "Crystals", "Info"}
local SBBtns = {}
local Pages = {}
local Active = nil

for i, label in SBLabels do
    local b = Instance.new("TextButton", SB)
    b.Size = UDim2.new(1, 0, 0, 46)
    b.Position = UDim2.new(0, 0, 0, 50 + (i-1) * 50)
    b.BackgroundColor3 = T.card
    b.BackgroundTransparency = 0.85
    b.Text = ""
    b.ZIndex = 5
    Instance.new("UICorner", b).CornerRadius = UDim.new(0, 8)

    local indicator = Instance.new("Frame", b)
    indicator.Size = UDim2.new(0, 3, 0, 20)
    indicator.Position = UDim2.new(0, 3, 0.5, -10)
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
    lbl.TextSize = 11
    lbl.Font = Enum.Font.GothamBold
    lbl.TextXAlignment = Enum.TextXAlignment.Left
    lbl.ZIndex = 6

    SBBtns[i] = {btn = b, lbl = lbl, ind = indicator}
end

-- ═══════════════════════════════════════════
--  CONTENT AREA (right of sidebar)
-- ═══════════════════════════════════════════
local Content = Instance.new("Frame", MF)
Content.Size = UDim2.new(1, -88, 1, -10)
Content.Position = UDim2.new(0, 86, 0, 10)
Content.BackgroundTransparency = 1

-- header
local Header = Instance.new("TextLabel", Content)
Header.Size = UDim2.new(1, 0, 0, 24)
Header.BackgroundTransparency = 1
Header.Text = "rncx hub  •  muscle legends"
Header.TextColor3 = T.cyan
Header.TextSize = 11
Header.Font = Enum.Font.GothamBold
Header.TextXAlignment = Enum.TextXAlignment.Left

local HeaderLine = Instance.new("Frame", Content)
HeaderLine.Size = UDim2.new(1, 0, 0, 1)
HeaderLine.Position = UDim2.new(0, 0, 0, 26)
HeaderLine.BackgroundColor3 = T.border
HeaderLine.BorderSizePixel = 0

-- scroll area
local CS = Instance.new("ScrollingFrame", Content)
CS.Size = UDim2.new(1, 0, 1, -34)
CS.Position = UDim2.new(0, 0, 0, 32)
CS.BackgroundTransparency = 1
CS.ScrollBarThickness = 2
CS.ScrollBarImageColor3 = T.cyan
CS.BorderSizePixel = 0
CS.CanvasSize = UDim2.new(0, 0, 0, 0)
CS.AutomaticCanvasSize = Enum.AutomaticSize.Y

-- ═══════════════════════════════════════════
--  BUILDERS
-- ═══════════════════════════════════════════
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
    l.Padding = UDim.new(0, 6)
    l.SortOrder = Enum.SortOrder.LayoutOrder
    l.HorizontalAlignment = Enum.HorizontalAlignment.Center
    Pages[name] = p
    return p
end

local function SwitchTab(idx)
    local name = SBLabels[idx]
    if Active and Pages[Active] then Pages[Active].Visible = false end
    -- reset all sidebar highlights
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

-- ── Glass Card ─────────────────────────────
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
    lay.Padding = UDim.new(0, 4)
    lay.SortOrder = Enum.SortOrder.LayoutOrder
    lay.HorizontalAlignment = Enum.HorizontalAlignment.Center
    local pad = Instance.new("UIPadding", f)
    pad.PaddingTop = UDim.new(0, title and 12 or 8)
    pad.PaddingBottom = UDim.new(0, 8)
    pad.PaddingLeft = UDim.new(0, 12)
    pad.PaddingRight = UDim.new(0, 12)
    if title then
        local tBar = Instance.new("Frame", f)
        tBar.Size = UDim2.new(1, 0, 0, 18)
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

-- ── NEON TOGGLE ────────────────────────────
local function Toggle(parent, text, key)
    local f = Instance.new("Frame", parent)
    f.Size = UDim2.new(1, 0, 0, 36)
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
    lbl.Size = UDim2.new(0.68, 0, 1, 0)
    lbl.Position = UDim2.new(0, 12, 0, 0)
    lbl.BackgroundTransparency = 1
    lbl.Text = text
    lbl.TextColor3 = T.txt
    lbl.TextSize = 12
    lbl.Font = Enum.Font.GothamMedium
    lbl.TextXAlignment = Enum.TextXAlignment.Left
    lbl.ZIndex = 5

    local isOn = CFG[key]

    -- checkbox container
    local box = Instance.new("Frame", f)
    box.Size = UDim2.new(0, 28, 0, 28)
    box.Position = UDim2.new(1, -40, 0.5, -14)
    box.BackgroundColor3 = isOn and T.cyan or Color3.fromRGB(20, 25, 40)
    box.BorderSizePixel = 0
    box.ZIndex = 5
    Instance.new("UICorner", box).CornerRadius = UDim.new(0, 8)

    local boxStroke = Instance.new("UIStroke", box)
    boxStroke.Color = isOn and T.cyan or Color3.fromRGB(40, 55, 80)
    boxStroke.Thickness = isOn and 2 or 1

    -- checkmark (drawn as 3 frames forming a check)
    local ck1 = Instance.new("Frame", box)
    ck1.Size = UDim2.new(0, 8, 0, 2)
    ck1.Position = UDim2.new(0, 5, 0, 13)
    ck1.BackgroundColor3 = T.bg
    ck1.BorderSizePixel = 0
    ck1.Rotation = -45
    ck1.ZIndex = 6
    ck1.BackgroundTransparency = isOn and 0 or 1
    Instance.new("UICorner", ck1).CornerRadius = UDim.new(1, 0)

    local ck2 = Instance.new("Frame", box)
    ck2.Size = UDim2.new(0, 14, 0, 2)
    ck2.Position = UDim2.new(0, 9, 0, 13)
    ck2.BackgroundColor3 = T.bg
    ck2.BorderSizePixel = 0
    ck2.Rotation = 45
    ck2.ZIndex = 6
    ck2.BackgroundTransparency = isOn and 0 or 1
    Instance.new("UICorner", ck2).CornerRadius = UDim.new(1, 0)

    -- neon glow when on
    local glow = Instance.new("Frame", box)
    glow.Size = UDim2.new(1, 8, 1, 8)
    glow.Position = UDim2.new(0, -4, 0, -4)
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
        if on then
            lbl.TextColor3 = T.cyanG
            task.delay(0.15, function()
                TS:Create(lbl, TweenInfo.new(0.3), {TextColor3 = T.txt}):Play()
            end)
        else
            lbl.TextColor3 = T.txt
        end
    end

    btn.MouseButton1Click:Connect(function() setOn(not CFG[key]) end)
    return { Set = setOn }
end

-- ── Slider ─────────────────────────────────
local function Slider(parent, text, key, min, max)
    local val = CFG[key]
    local pct = math.clamp((val - min) / (max - min), 0, 1)
    local f = Instance.new("Frame", parent)
    f.Size = UDim2.new(1, 0, 0, 50)
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
    lbl.Size = UDim2.new(0.6, 0, 0, 18)
    lbl.Position = UDim2.new(0, 12, 0, 8)
    lbl.BackgroundTransparency = 1
    lbl.Text = text
    lbl.TextColor3 = T.txt
    lbl.TextSize = 12
    lbl.Font = Enum.Font.GothamMedium
    lbl.TextXAlignment = Enum.TextXAlignment.Left
    lbl.ZIndex = 5

    local valL = Instance.new("TextLabel", f)
    valL.Size = UDim2.new(0.32, 0, 0, 18)
    valL.Position = UDim2.new(0.65, 0, 0, 8)
    valL.BackgroundTransparency = 1
    valL.Text = tostring(val)
    valL.TextColor3 = T.cyan
    valL.TextSize = 13
    valL.Font = Enum.Font.GothamBlack
    valL.TextXAlignment = Enum.TextXAlignment.Right
    valL.ZIndex = 5

    local trk = Instance.new("Frame", f)
    trk.Size = UDim2.new(1, -28, 0, 6)
    trk.Position = UDim2.new(0, 14, 0, 36)
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
    knb.Size = UDim2.new(0, 16, 0, 16)
    knb.Position = UDim2.new(pct, -8, 0.5, -8)
    knb.BackgroundColor3 = T.cyanG
    knb.Text = ""
    knb.BorderSizePixel = 0
    knb.ZIndex = 7
    Instance.new("UICorner", knb).CornerRadius = UDim.new(1, 0)

    local knbStroke = Instance.new("UIStroke", knb)
    knbStroke.Color = T.cyan
    knbStroke.Thickness = 2

    local drag = false
    knb.MouseButton1Down:Connect(function() drag = true end)
    UIS.InputEnded:Connect(function(i) if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then drag = false end end)
    UIS.InputChanged:Connect(function(i)
        if drag and (i.UserInputType == Enum.UserInputType.MouseMovement or i.UserInputType == Enum.UserInputType.Touch) then
            local px = math.clamp((i.Position.X - trk.AbsolutePosition.X) / trk.AbsoluteSize.X, 0, 1)
            local v = math.floor(min + (max - min) * px + 0.5)
            CFG[key] = v valL.Text = tostring(v)
            fill.Size = UDim2.new(px, 0, 1, 0)
            knb.Position = UDim2.new(px, -8, 0.5, -8)
        end
    end)
end

-- ── Button ─────────────────────────────────
local function Btn(parent, text, col, cb)
    local b = Instance.new("TextButton", parent)
    b.Size = UDim2.new(1, 0, 0, 36)
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
    lbl.Size = UDim2.new(1, -16, 1, 0)
    lbl.Position = UDim2.new(0, 12, 0, 0)
    lbl.BackgroundTransparency = 1
    lbl.Text = text
    lbl.TextColor3 = col or T.cyan
    lbl.TextSize = 11
    lbl.Font = Enum.Font.GothamBold
    lbl.TextXAlignment = Enum.TextXAlignment.Left
    lbl.ZIndex = 5
    b.MouseEnter:Connect(function()
        TS:Create(b, TweenInfo.new(0.15), {BackgroundTransparency = 0.7}):Play()
    end)
    b.MouseLeave:Connect(function()
        TS:Create(b, TweenInfo.new(0.15), {BackgroundTransparency = 0.85}):Play()
    end)
    b.MouseButton1Click:Connect(cb)
end

-- ── Dropdown ───────────────────────────────
local function Drop(parent, label, opts, key)
    local f = Instance.new("Frame", parent)
    f.Size = UDim2.new(1, 0, 0, 38)
    f.BackgroundColor3 = T.card
    f.BackgroundTransparency = 0.3
    f.BorderSizePixel = 0
    f.LayoutOrder = NO()
    f.ClipsDescendants = true
    f.ZIndex = 4
    Instance.new("UICorner", f).CornerRadius = UDim.new(0, 8)
    local stroke = Instance.new("UIStroke", f)
    stroke.Color = T.border
    stroke.Thickness = 1
    stroke.Transparency = 0.6

    local lbl = Instance.new("TextLabel", f)
    lbl.Size = UDim2.new(0.32, 0, 1, 0)
    lbl.Position = UDim2.new(0, 12, 0, 0)
    lbl.BackgroundTransparency = 1
    lbl.Text = label
    lbl.TextColor3 = T.txt
    lbl.TextSize = 11
    lbl.Font = Enum.Font.GothamMedium
    lbl.TextXAlignment = Enum.TextXAlignment.Left
    lbl.ZIndex = 5

    local sB = Instance.new("TextButton", f)
    sB.Size = UDim2.new(0.62, 0, 0, 28)
    sB.Position = UDim2.new(0.36, 0, 0, 5)
    sB.BackgroundColor3 = Color3.fromRGB(18, 24, 44)
    sB.Text = ""
    sB.BorderSizePixel = 0
    sB.ZIndex = 5
    Instance.new("UICorner", sB).CornerRadius = UDim.new(0, 6)

    local sT = Instance.new("TextLabel", sB)
    sT.Size = UDim2.new(1, -28, 1, 0)
    sT.Position = UDim2.new(0, 10, 0, 0)
    sT.BackgroundTransparency = 1
    sT.Text = CFG[key]
    sT.TextColor3 = T.txt
    sT.TextSize = 10
    sT.Font = Enum.Font.Gotham
    sT.TextXAlignment = Enum.TextXAlignment.Left
    sT.ZIndex = 6

    local arrow = Instance.new("TextLabel", sB)
    arrow.Size = UDim2.new(0, 20, 1, 0)
    arrow.Position = UDim2.new(1, -24, 0, 0)
    arrow.BackgroundTransparency = 1
    arrow.Text = "v"
    arrow.TextColor3 = T.cyanD
    arrow.TextSize = 10
    arrow.Font = Enum.Font.GothamBold
    arrow.ZIndex = 6

    local lF = Instance.new("Frame", f)
    lF.Size = UDim2.new(0.62, 0, 0, math.min(#opts * 30, 150))
    lF.Position = UDim2.new(0.36, 0, 0, 38)
    lF.BackgroundColor3 = Color3.fromRGB(18, 24, 44)
    lF.BorderSizePixel = 0
    lF.ZIndex = 8
    lF.Visible = false
    Instance.new("UICorner", lF).CornerRadius = UDim.new(0, 6)
    local lfStroke = Instance.new("UIStroke", lF)
    lfStroke.Color = T.border
    lfStroke.Thickness = 1
    lfStroke.Transparency = 0.4

    local lS = Instance.new("ScrollingFrame", lF)
    lS.Size = UDim2.new(1, -4, 1, -4)
    lS.Position = UDim2.new(0, 2, 0, 2)
    lS.BackgroundTransparency = 1
    lS.ScrollBarThickness = 2
    lS.ScrollBarImageColor3 = T.cyan
    lS.BorderSizePixel = 0
    lS.CanvasSize = UDim2.new(0, 0, 0, #opts * 30)

    for _, o in ipairs(opts) do
        local ob = Instance.new("TextButton", lS)
        ob.Size = UDim2.new(1, 0, 0, 30)
        ob.BackgroundColor3 = Color3.fromRGB(18, 24, 44)
        ob.Text = ""
        ob.BorderSizePixel = 0
        ob.ZIndex = 9
        local ot = Instance.new("TextLabel", ob)
        ot.Size = UDim2.new(1, -12, 1, 0)
        ot.Position = UDim2.new(0, 10, 0, 0)
        ot.BackgroundTransparency = 1
        ot.Text = o
        ot.TextColor3 = T.txt
        ot.TextSize = 10
        ot.Font = Enum.Font.Gotham
        ot.TextXAlignment = Enum.TextXAlignment.Left
        ot.ZIndex = 10
        ob.MouseEnter:Connect(function() ob.BackgroundColor3 = T.cardHi end)
        ob.MouseLeave:Connect(function() ob.BackgroundColor3 = Color3.fromRGB(18, 24, 44) end)
        ob.MouseButton1Click:Connect(function()
            CFG[key] = o sT.Text = o lF.Visible = false arrow.Text = "v"
            f.Size = UDim2.new(1, 0, 0, 38)
        end)
    end

    sB.MouseButton1Click:Connect(function()
        lF.Visible = not lF.Visible
        arrow.Text = lF.Visible and "^" or "v"
        if lF.Visible then f.Size = UDim2.new(1, 0, 0, 38 + lF.Size.Y.Offset + 4)
        else f.Size = UDim2.new(1, 0, 0, 38) end
    end)
end

-- ── Label ──────────────────────────────────
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

-- ── Helpers ────────────────────────────────
local function Fmt(n)
    if n >= 1e6 then return string.format("%.1fM", n/1e6) end
    if n >= 1e3 then return string.format("%.0fK", n/1e3) end
    return tostring(n)
end

local function CrystalStatus()
    local g = Gems.Value
    local p = CrystalPrices[CFG.Crystal]
    if not p then return "Select a crystal" end
    local n = math.floor(g / p)
    if n <= 0 then return "Need " .. Fmt(p) .. " (have " .. Fmt(g) .. ")" end
    return "Can open " .. n .. "x  •  " .. Fmt(p) .. " each"
end

local AreaCF = {}
local function CacheAreas()
    local circles = workspace:FindFirstChild("areaCircles")
    if not circles then return end
    for _, c in circles:GetChildren() do
        if c:IsA("Model") and c.Name == "areaCircle" then
            local an = c:FindFirstChild("areaName")
            if an and not AreaCF[an.Value] then AreaCF[an.Value] = c:GetPivot() end
        end
    end
end
task.spawn(function() task.wait(2) CacheAreas() end)

local function Teleport(area)
    CacheAreas()
    local cf = AreaCF[area]
    if cf and HRP then
        HRP.CFrame = CFrame.new(cf.Position + Vector3.new(0, 3, 0), cf.Position + Vector3.new(cf.LookVector.X, 0, cf.LookVector.Z))
        HRP.AssemblyLinearVelocity = Vector3.zero
        HRP.AssemblyAngularVelocity = Vector3.zero
    end
end

-- ═══════════════════════════════════════════
--  TABS
-- ═══════════════════════════════════════════

do -- TRAIN
    local p = MakePage("Train")
    Card(p, "Auto Training")
    Toggle(p, "Auto Punch (Strength)", "AutoPunch")
    Slider(p, "Punch Speed", "PunchSpd", 0.05, 1)
    Toggle(p, "Auto Rep (Weight)", "AutoRep")
    Slider(p, "Rep Speed", "RepSpd", 0.2, 2)
    Card(p, "Manual Tools")
    Btn(Pages.Train, "Equip Punch", T.purple, function()
        pcall(function() local t = LP.Backpack:FindFirstChild("Punch") if t then Hum:EquipTool(t) end end)
    end)
    Btn(Pages.Train, "Equip Weight", T.blue, function()
        pcall(function() local t = LP.Backpack:FindFirstChild("Weight") if t then Hum:EquipTool(t) end end)
    end)
end

do -- FARM
    local p = MakePage("Farm")
    Card(p, "Auto Farm")
    Toggle(p, "Auto Claim Chests", "AutoChest")
    Toggle(p, "Auto Rebirth", "AutoRebirth")
    Toggle(p, "Auto Brawl", "AutoBrawl")
    Toggle(p, "Auto Group Rewards", "AutoGroup")
    Card(p, "Codes")
    Btn(Pages.Farm, "Redeem All 17 Codes", Color3.fromRGB(0,230,118), function()
        for _, c in ipairs({"junglegym500","EPICMUSCLE20","ultimate250","mightygems2500","MillionWarriors","EPICREWARD500","FrostGems10","GalaxyCrystal50","Launch250","MegaLift50","MuscleStorm50","SkyAgility50","SpaceGems50","SPEEDY50","SuperMuscle100","SuperPunch100","SKYAGILITY"}) do
            pcall(function() rE.codeRemote:InvokeServer(c) end) task.wait(0.15)
        end
    end)
    Card(p, "Freebies")
    Btn(Pages.Farm, "Claim Free Gift", Color3.fromRGB(0,230,118), function() pcall(function() rE.freeGiftClaimRemote:InvokeServer() end) end)
    Btn(Pages.Farm, "Spin Fortune Wheel", T.cyan, function() pcall(function() rE.openFortuneWheelRemote:InvokeServer() end) end)
end

do -- TELE
    local p = MakePage("Tele")
    Card(p, "World Travel")
    local areas = {"Beach","Tiny Island","Frost Gym","Mythical Gym","Eternal Gym","Legends Gym","Muscle King","Jungle Gym","Industrial Gym"}
    Drop(Pages.Tele, "Area", areas, "Area")
    Btn(Pages.Tele, "Teleport", T.cyan, function() Teleport(CFG.Area) end)
    Card(p, "Quick TP")
    for i, area in areas do
        Btn(Pages.Tele, area, i % 2 == 0 and T.blue or Color3.fromRGB(30, 40, 60), function() Teleport(area) end)
    end
end

do -- PLAYER
    local p = MakePage("Player")
    Card(p, "Movement")
    Slider(p, "Walk Speed", "WalkSpd", 16, 300)
    Slider(p, "Jump Power", "JumpPow", 50, 350)
    Toggle(p, "NoClip", "NoClip")
    Toggle(p, "Anti AFK", "AntiAFK")
    Card(p, "Pets")
    Btn(Pages.Player, "Equip Best Pets", T.cyan, function() pcall(function() rE.equipPetEvent:FireServer("equipBest") end) end)
    Btn(Pages.Player, "Sell Bad Pets", Color3.fromRGB(255,170,50), function() pcall(function() rE.sellPetEvent:FireServer("sellBadPets") end) end)
    Card(p, "Chests")
    local chests = {"goldenChest","enchantedChest","mythicalChest","legendsChest","jungleChest","magmaChest"}
    Drop(Pages.Player, "Chest", chests, "ChestArea")
    Btn(Pages.Player, "TP to Chest", T.cyan, function()
        local chest = workspace:FindFirstChild(CFG.ChestArea)
        if chest and chest.PrimaryPart and HRP then
            HRP.CFrame = chest.PrimaryPart.CFrame + Vector3.new(0, 5, 0)
            HRP.AssemblyLinearVelocity = Vector3.zero
        end
    end)
    Btn(Pages.Player, "Collect Chest", Color3.fromRGB(0,230,118), function() pcall(function() rE.checkChestRemote:InvokeServer(CFG.ChestArea) end) end)
    Card(p, "More")
    Toggle(p, "Auto Equip Best Pets", "AutoEquip")
    Toggle(p, "FPS Boost", "FpsBoost")
end

do -- CRYSTALS
    local p = MakePage("Crystals")
    Card(p, "Crystal Opener")
    Toggle(p, "Auto Open Crystals", "AutoCrystal")
    local crystalOpts = {}
    for name in CrystalPrices do crystalOpts[#crystalOpts+1] = name end
    table.sort(crystalOpts, function(a, b) return CrystalPrices[a] < CrystalPrices[b] end)
    Drop(Pages.Crystals, "Crystal", crystalOpts, "Crystal")

    local infoLbl = Instance.new("TextLabel", Pages.Crystals)
    infoLbl.Size = UDim2.new(1, 0, 0, 18)
    infoLbl.BackgroundTransparency = 1
    infoLbl.TextColor3 = Color3.fromRGB(255,170,50)
    infoLbl.TextSize = 11
    infoLbl.Font = Enum.Font.GothamMedium
    infoLbl.TextXAlignment = Enum.TextXAlignment.Left
    infoLbl.Text = CrystalStatus()
    infoLbl.LayoutOrder = NO()
    infoLbl.ZIndex = 4

    Card(p, "Tap to Open")
    local eggRows = {}
    for i, name in ipairs(crystalOpts) do
        local price = CrystalPrices[name]
        local color = CrystalColors[name] or T.txt
        local afford = Gems.Value >= price

        local row = Instance.new("Frame", Pages.Crystals)
        row.Size = UDim2.new(1, 0, 0, 36)
        row.BackgroundColor3 = T.card
        row.BackgroundTransparency = afford and 0.3 or 0.7
        row.BorderSizePixel = 0
        row.LayoutOrder = NO()
        row.ZIndex = 4
        Instance.new("UICorner", row).CornerRadius = UDim.new(0, 8)
        local rs = Instance.new("UIStroke", row)
        rs.Color = afford and color or T.border
        rs.Thickness = afford and 1.5 or 1
        rs.Transparency = afford and 0.5 or 0.7

        local bar = Instance.new("Frame", row)
        bar.Size = UDim2.new(0, 3, 0.5, 0)
        bar.Position = UDim2.new(0, 8, 0.25, 0)
        bar.BackgroundColor3 = color
        bar.BackgroundTransparency = afford and 0.2 or 0.6
        bar.BorderSizePixel = 0
        bar.ZIndex = 5
        Instance.new("UICorner", bar).CornerRadius = UDim.new(1, 0)

        local n = Instance.new("TextLabel", row)
        n.Size = UDim2.new(0.4, 0, 1, 0)
        n.Position = UDim2.new(0, 18, 0, 0)
        n.BackgroundTransparency = 1
        n.Text = name
        n.TextColor3 = afford and T.txt or Color3.fromRGB(80, 100, 130)
        n.TextSize = 11
        n.Font = Enum.Font.GothamMedium
        n.TextXAlignment = Enum.TextXAlignment.Left
        n.ZIndex = 5

        local pLbl = Instance.new("TextLabel", row)
        pLbl.Size = UDim2.new(0.25, 0, 1, 0)
        pLbl.Position = UDim2.new(0.48, 0, 0, 0)
        pLbl.BackgroundTransparency = 1
        pLbl.Text = Fmt(price)
        pLbl.TextColor3 = color
        pLbl.TextSize = 13
        pLbl.Font = Enum.Font.GothamBlack
        pLbl.TextXAlignment = Enum.TextXAlignment.Right
        pLbl.ZIndex = 5

        local sLbl = Instance.new("TextLabel", row)
        sLbl.Size = UDim2.new(0.22, 0, 1, 0)
        sLbl.Position = UDim2.new(0.74, 0, 0, 0)
        sLbl.BackgroundTransparency = 1
        sLbl.Font = Enum.Font.GothamBold
        sLbl.TextSize = 9
        sLbl.TextXAlignment = Enum.TextXAlignment.Right
        sLbl.ZIndex = 5

        local function Update()
            local g2 = Gems.Value
            local a = g2 >= price
            row.BackgroundTransparency = a and 0.3 or 0.7
            rs.Color = a and color or T.border
            n.TextColor3 = a and T.txt or Color3.fromRGB(80, 100, 130)
            if a then sLbl.Text = math.floor(g2 / price) .. "x" sLbl.TextColor3 = Color3.fromRGB(0,230,118)
            else sLbl.Text = Fmt(price - g2) .. " away" sLbl.TextColor3 = Color3.fromRGB(255,82,82) end
            return a
        end
        Update()

        if afford then
            local btn = Instance.new("TextButton", row)
            btn.Size = UDim2.new(1, 0, 1, 0)
            btn.BackgroundTransparency = 1
            btn.Text = ""
            btn.ZIndex = 6
            btn.MouseButton1Click:Connect(function()
                TS:Create(row, TweenInfo.new(0.08), {BackgroundTransparency = 0}):Play()
                task.delay(0.08, function() TS:Create(row, TweenInfo.new(0.2), {BackgroundTransparency = 0.3}):Play() end)
                pcall(function() rE.openCrystalRemote:InvokeServer("openCrystal", name) end)
                task.delay(1.5, function() pcall(Update) end)
            end)
        end
        eggRows[#eggRows + 1] = {Update = Update}
    end

    Btn(Pages.Crystals, "Refresh All", T.cyan, function()
        for _, data in ipairs(eggRows) do pcall(data.Update) end
        pcall(function() infoLbl.Text = CrystalStatus() end)
    end)

    task.spawn(function()
        while SG.Parent do
            task.wait(2)
            pcall(function()
                infoLbl.Text = CrystalStatus()
                for _, data in ipairs(eggRows) do data.Update() end
            end)
        end
    end)
end

do -- INFO
    local p = MakePage("Info")
    Card(p, "Live Stats")
    local stats = {}
    for _, item in ipairs({
        {"Strength", Color3.fromRGB(255,170,50)}, {"Gems", T.cyan}, {"Rebirths", Color3.fromRGB(0,230,118)},
        {"Kills", Color3.fromRGB(255,82,82)}, {"Tokens", T.txt}, {"Agility", T.blue}, {"Durability", T.purple}
    }) do
        local f = Instance.new("Frame", Pages.Info)
        f.Size = UDim2.new(1, 0, 0, 22)
        f.BackgroundTransparency = 1
        f.LayoutOrder = NO()
        f.ZIndex = 4
        local lbl = Instance.new("TextLabel", f)
        lbl.Size = UDim2.new(0.45, 0, 1, 0)
        lbl.Position = UDim2.new(0, 14, 0, 0)
        lbl.BackgroundTransparency = 1
        lbl.Text = item[1]
        lbl.TextColor3 = Color3.fromRGB(80, 100, 130)
        lbl.TextSize = 11
        lbl.Font = Enum.Font.GothamMedium
        lbl.TextXAlignment = Enum.TextXAlignment.Left
        lbl.ZIndex = 5
        local val = Instance.new("TextLabel", f)
        val.Size = UDim2.new(0.5, 0, 1, 0)
        val.Position = UDim2.new(0.48, 0, 0, 0)
        val.BackgroundTransparency = 1
        val.Text = "..."
        val.TextColor3 = item[2]
        val.TextSize = 11
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
                stats.Strength.Text = Fmt(ls and ls:WaitForChild("Strength", 5).Value or 0)
                stats.Gems.Text = Fmt(LP:WaitForChild("Gems").Value)
                stats.Rebirths.Text = tostring(ls and ls:WaitForChild("Rebirths", 5).Value or 0)
                stats.Kills.Text = tostring(ls and ls:WaitForChild("Kills", 5).Value or 0)
                stats.Tokens.Text = tostring(LP:WaitForChild("Tokens").Value)
                stats.Agility.Text = Fmt(LP:WaitForChild("Agility").Value)
                stats.Durability.Text = Fmt(LP:WaitForChild("Durability").Value)
            end)
        end
    end)

    Card(p, "Server")
    Btn(Pages.Info, "Server Hop", T.cyan, function()
        pcall(function()
            local ok, servers = pcall(function() return game:GetService("TeleportService"):GetServers(game.PlaceId) end)
            if ok and servers then
                local candidates = {}
                for _, s in servers do
                    if s.JobId ~= game.JobId and s.Playing < s.MaxPlayers then candidates[#candidates + 1] = s end
                end
                if #candidates > 0 then
                    local pick = candidates[math.random(1, #candidates)]
                    game:GetService("TeleportService"):TeleportToPlaceInstance(game.PlaceId, pick.JobId, LP)
                end
            end
        end)
    end)
    Btn(Pages.Info, "Rejoin", Color3.fromRGB(255,170,50), function()
        pcall(function() game:GetService("TeleportService"):Teleport(game.PlaceId, LP) end)
    end)

    Card(p, "Info")
    Label(Pages.Info, "RightShift to toggle  •  Tap orb on mobile", Color3.fromRGB(80, 100, 130), 10)
    Label(Pages.Info, "Discord: discord.gg/sx5ZYAZGT", Color3.fromRGB(80, 100, 130), 10)
    Label(Pages.Info, "No hooks  •  Zero detection", Color3.fromRGB(0,230,118), 10)

    Card(p, "Danger")
    Btn(Pages.Info, "Destroy UI", Color3.fromRGB(255,82,82), function()
        if speedBV then speedBV:Destroy() end
        SG:Destroy()
    end)
end

-- ═══════════════════════════════════════════
--  LOOPS
-- ═══════════════════════════════════════════

task.spawn(function()
    while SG.Parent do
        task.wait(CFG.PunchSpd)
        if CFG.AutoPunch and Char and Hum and Hum.Health > 0 then
            pcall(function()
                if not Char:FindFirstChild("Weight") then local wt = LP.Backpack:FindFirstChild("Weight") if wt then Hum:EquipTool(wt) end end
                mE:FireServer("rep")
            end)
        end
    end
end)

task.spawn(function()
    while SG.Parent do
        task.wait(CFG.RepSpd)
        if CFG.AutoRep and Char and Hum and Hum.Health > 0 then
            pcall(function()
                if not Char:FindFirstChild("Weight") then local wt = LP.Backpack:FindFirstChild("Weight") if wt then Hum:EquipTool(wt) end end
                mE:FireServer("rep")
            end)
        end
    end
end)

task.spawn(function() while SG.Parent do task.wait(5) if CFG.AutoChest then pcall(function() for _, n in ipairs({"goldenChest","enchantedChest","mythicalChest","legendsChest","jungleChest","magmaChest"}) do rE.checkChestRemote:InvokeServer(n) end end) end end end)
task.spawn(function() while SG.Parent do task.wait(CFG.CrystInt) if CFG.AutoCrystal then pcall(function() local g = Gems.Value local p = CrystalPrices[CFG.Crystal] if p and g >= p then rE.openCrystalRemote:InvokeServer("openCrystal", CFG.Crystal) end end) end end end)
task.spawn(function() while SG.Parent do task.wait(5) if CFG.AutoRebirth then pcall(function() rE.rebirthRemote:InvokeServer("rebirthRequest") end) end end end)
task.spawn(function() while SG.Parent do task.wait(2) if CFG.AutoBrawl then pcall(function() rE.brawlEvent:FireServer("acceptBrawl") end) end end end)
task.spawn(function() while SG.Parent do task.wait(60) if CFG.AutoGroup then pcall(function() rE.groupRemote:InvokeServer("claimGroupRewards") end) end end end)
task.spawn(function() while SG.Parent do task.wait(10) if CFG.AutoEquip then pcall(function() rE.equipPetEvent:FireServer("equipBest") end) end end end)

speedBV = nil
task.spawn(function()
    while SG.Parent do
        task.wait(0.05)
        pcall(function()
            if Hum and HRP then
                Hum.JumpPower = CFG.JumpPow
                if CFG.WalkSpd > 16 and Hum.MoveDirection.Magnitude > 0 then
                    local moveDir = Hum.MoveDirection.Unit
                    local speed = CFG.WalkSpd * 0.85
                    if not speedBV then speedBV = Instance.new("BodyVelocity") speedBV.MaxForce = Vector3.new(1e5, 0, 1e5) speedBV.P = 1e4 speedBV.Parent = HRP end
                    speedBV.Velocity = moveDir * speed + Vector3.new(0, HRP.AssemblyLinearVelocity.Y, 0)
                elseif speedBV then speedBV:Destroy() speedBV = nil end
            end
        end)
    end
end)
task.spawn(function() while SG.Parent do task.wait(1) if CFG.WalkSpd <= 16 and speedBV then speedBV:Destroy() speedBV = nil end end end)
task.spawn(function() while SG.Parent do task.wait(0.1) if CFG.NoClip and Char then pcall(function() for _, part in Char:GetDescendants() do if part:IsA("BasePart") then part.CanCollide = false end end end) end end end)
task.spawn(function() while SG.Parent do task.wait(2) pcall(function() settings().Rendering.QualityLevel = CFG.FpsBoost and Enum.QualityLevel.Level01 or Enum.QualityLevel.Automatic end) end end)
LP.Idled:Connect(function() if CFG.AntiAFK then VU:CaptureController() VU:ClickButton2(Vector2.new()) end end)

-- ═══════════════════════════════════════════
--  TOGGLE ORB — neon cyberpunk style
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

local menuOpen = false

local function ToggleMenu()
    menuOpen = not menuOpen
    MF.Visible = menuOpen
    if menuOpen then
        OrbIcon.Text = "X" OrbIcon.TextSize = 15
        OrbStroke.Thickness = 2.5 OrbStroke.Color = T.cyanG
        GlowStroke.Transparency = 0.05
        TS:Create(Orb, TweenInfo.new(0.2), {BackgroundColor3 = T.cardHi}):Play()
        MF.Position = UDim2.new(0.5, -270, 0.5, -310)
        MF.Size = UDim2.new(0, 540, 0, 0)
        TS:Create(MF, TweenInfo.new(0.4, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
            Size = UDim2.new(0, 540, 0, 560),
            Position = UDim2.new(0.5, -270, 0.5, -280),
        }):Play()
    else
        OrbIcon.Text = ">>" OrbIcon.TextSize = 16
        OrbStroke.Thickness = 2 OrbStroke.Color = T.cyan
        GlowStroke.Transparency = 0.7
        TS:Create(MF, TweenInfo.new(0.2, Enum.EasingStyle.Quart, Enum.EasingDirection.In), {
            Size = UDim2.new(0, 540, 0, 0),
        }):Play()
        task.delay(0.2, function() MF.Visible = false end)
        TS:Create(Orb, TweenInfo.new(0.2), {BackgroundColor3 = T.panel}):Play()
    end
end

Orb.MouseButton1Click:Connect(ToggleMenu)
UIS.InputBegan:Connect(function(input, gpe)
    if not gpe and input.KeyCode == Enum.KeyCode.RightShift then ToggleMenu() end
end)

-- start on Train
SwitchTab(1)
print("[rncx hub] v6 loaded")
