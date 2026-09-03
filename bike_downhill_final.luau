local Players = game:GetService("Players")
local RS = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local VirtualUser = game:GetService("VirtualUser")
local Player = Players.LocalPlayer

local fire = RS.Remote.Event.Race.AddCoinsOrWins
local CarConfig = require(RS.Config.Car)
local GearConfig = require(RS.Config.Gear)
local TrailConfig = require(RS.Config.Trail)

local Remotes = {}
pcall(function()
    local ev, func = RS.Remote.Event, RS.Remote.Function
    Remotes.EquipBestPet = ev.Pet["[C-S]EquipBestPet"]
    Remotes.EquipCar = ev.CarShop["[C-S]EquipCar"]
    Remotes.BuyTool = func.CarShop["[C-S]BuyTool"]
    Remotes.GetUnlockedCars = func.CarShop["[C-S]GetPlrUnlockCarShop"]
    Remotes.BuyGear = func.Gear["[C-S]PlrWannaBuyGear"]
    Remotes.GetGearUnlock = func.Gear["[C-S]GetPlrUnlockGear"]
    Remotes.BuyTrail = ev.Trail["[C-S]PlrWannaBuyTrail"]
    Remotes.EquipGear = ev.Gear["[C-S]PlrWannaEquipGear"]
    Remotes.doLuck = func.Luck["[C-S]doLuck"]
    Remotes.Rebirth = ev.Rebirth["[C-S]PlrWannaRebirth"]
end)

local CoinsOn, WinsOn = true, true

local SG = Instance.new("ScreenGui")
SG.Name = "rncx_hub"
SG.ResetOnSpawn = false
SG.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
SG.DisplayOrder = 999
SG.Parent = Player:WaitForChild("PlayerGui")

local Col = {
    BG = Color3.fromRGB(10, 10, 18), Panel = Color3.fromRGB(16, 16, 28),
    PanelL = Color3.fromRGB(24, 24, 40), Accent = Color3.fromRGB(0, 190, 255),
    AccentD = Color3.fromRGB(0, 110, 170), Ok = Color3.fromRGB(0, 230, 110),
    Text = Color3.fromRGB(220, 220, 240), Dim = Color3.fromRGB(100, 100, 130),
    Err = Color3.fromRGB(255, 50, 50), Off = Color3.fromRGB(40, 40, 60),
    On = Color3.fromRGB(0, 230, 110), Border = Color3.fromRGB(40, 40, 60),
    Gold = Color3.fromRGB(255, 215, 0),
}

local function N(c, p)
    local i = Instance.new(c)
    for k, v in pairs(p) do
        if k ~= "Parent" and k ~= "Ch" then pcall(function() i[k] = v end) end
    end
    if p.Ch then for _, ch in ipairs(p.Ch) do ch.Parent = i end end
    if p.Parent then i.Parent = p.Parent end
    return i
end
local function Cr(r) return N("UICorner", {CornerRadius = UDim.new(0, r or 6)}) end
local function St(c, t) return N("UIStroke", {Color = c or Col.Border, Thickness = t or 1, Transparency = 0.2}) end
local function Pd(a, b, c, d)
    return N("UIPadding", {
        PaddingTop = UDim.new(0, a or 0), PaddingBottom = UDim.new(0, b or 0),
        PaddingLeft = UDim.new(0, c or 0), PaddingRight = UDim.new(0, d or 0)
    })
end
local function FormatNum(n)
    if n >= 1e12 then return string.format("%.1fT", n / 1e12)
    elseif n >= 1e9 then return string.format("%.1fB", n / 1e9)
    elseif n >= 1e6 then return string.format("%.1fM", n / 1e6)
    elseif n >= 1e3 then return string.format("%.1fK", n / 1e3)
    end
    return tostring(n)
end

-- TOP BAR
local TopBar = N("Frame", {Size = UDim2.new(0, 340, 0, 40), Position = UDim2.new(0.5, -170, 0, 8), BackgroundColor3 = Col.BG, BorderSizePixel = 0, Parent = SG, Ch = {Cr(10), St(Col.Accent), Pd(0, 0, 10, 10)}})
local CoinIcon = N("TextLabel", {Size = UDim2.new(0.5, -8, 1, 0), Position = UDim2.new(0, 5, 0, 0), BackgroundTransparency = 1, Text = "Coins: loading...", TextColor3 = Col.Gold, TextSize = 15, Font = Enum.Font.Code, TextXAlignment = Enum.TextXAlignment.Left, Parent = TopBar})
local WinIcon = N("TextLabel", {Size = UDim2.new(0.5, -8, 1, 0), Position = UDim2.new(0.5, 2, 0, 0), BackgroundTransparency = 1, Text = "Wins: loading...", TextColor3 = Col.Ok, TextSize = 15, Font = Enum.Font.Code, TextXAlignment = Enum.TextXAlignment.Left, Parent = TopBar})

-- MAIN FRAME
local MF = N("Frame", {Size = UDim2.new(0, 480, 0, 420), Position = UDim2.new(0.5, -240, 0, 56), BackgroundColor3 = Col.BG, BorderSizePixel = 0, Active = true, Draggable = true, Parent = SG, Ch = {Cr(12), St(Col.Accent)}})
local TB = N("Frame", {Name = "TB", Size = UDim2.new(1, 0, 0, 34), BackgroundColor3 = Col.Panel, BorderSizePixel = 0, Parent = MF, Ch = {Cr(12)}})
N("Frame", {Size = UDim2.new(1, 0, 0, 10), Position = UDim2.new(0, 0, 1, -10), BackgroundColor3 = Col.Panel, BorderSizePixel = 0, Parent = TB})
N("TextLabel", {Size = UDim2.new(1, -60, 1, 0), Position = UDim2.new(0, 12, 0, 0), BackgroundTransparency = 1, Text = "rncx hub  |  Bike Downhill", TextColor3 = Col.Accent, TextSize = 13, Font = Enum.Font.Code, TextXAlignment = Enum.TextXAlignment.Left, Parent = TB})
local XB = N("TextButton", {Name = "X", Size = UDim2.new(0, 26, 0, 26), Position = UDim2.new(1, -30, 0, 4), BackgroundColor3 = Col.Err, BorderSizePixel = 0, Text = "X", TextColor3 = Color3.new(1,1,1), TextSize = 12, Font = Enum.Font.Code, Parent = TB, Ch = {Cr(4)}})
XB.MouseButton1Click:Connect(function() MF.Visible = false end)

local TabBar = N("Frame", {Size = UDim2.new(1, -16, 0, 28), Position = UDim2.new(0, 8, 0, 38), BackgroundColor3 = Col.Panel, BorderSizePixel = 0, Parent = MF, Ch = {Cr(6), N("UIListLayout", {FillDirection = Enum.FillDirection.Horizontal, Padding = UDim.new(0, 3)}), Pd(0, 0, 3)}})
local CF = N("Frame", {Size = UDim2.new(1, -16, 1, -74), Position = UDim2.new(0, 8, 0, 70), BackgroundTransparency = 1, BorderSizePixel = 0, Parent = MF})

local Tabs, TBtns = {}, {}
local function MakeTab(name)
    local t = N("ScrollingFrame", {Size = UDim2.new(1, 0, 1, 0), BackgroundTransparency = 1, ScrollBarThickness = 3, ScrollBarImageColor3 = Col.Accent, BorderSizePixel = 0, CanvasSize = UDim2.new(0, 0, 0, 0), AutomaticCanvasSize = Enum.AutomaticSize.Y, Visible = false, Parent = CF, Ch = {N("UIListLayout", {Padding = UDim.new(0, 5)}), Pd(3, 3, 3, 3)}})
    local b = N("TextButton", {Size = UDim2.new(0, 60, 1, -2), BackgroundColor3 = Col.PanelL, BorderSizePixel = 0, Text = name, TextColor3 = Col.Dim, TextSize = 10, Font = Enum.Font.Code, Parent = TabBar, Ch = {Cr(5)}})
    Tabs[name] = t
    TBtns[name] = b
    b.MouseButton1Click:Connect(function()
        for _, v in pairs(Tabs) do v.Visible = false end
        for _, v in pairs(TBtns) do v.TextColor3 = Col.Dim end
        t.Visible = true
        b.TextColor3 = Col.Accent
    end)
    return t
end
local function Grp(tab, name)
    return N("Frame", {Size = UDim2.new(1, 0, 0, 0), AutomaticSize = Enum.AutomaticSize.Y, BackgroundColor3 = Col.Panel, BorderSizePixel = 0, Parent = tab, Ch = {Cr(8), St(Col.Border), Pd(8, 8, 10, 10), N("UIListLayout", {Padding = UDim.new(0, 5)}), N("TextLabel", {Size = UDim2.new(1, 0, 0, 16), BackgroundTransparency = 1, Text = string.upper(name), TextColor3 = Col.Accent, TextSize = 11, Font = Enum.Font.Code, TextXAlignment = Enum.TextXAlignment.Left})}})
end
local function Tog(par, txt, def, cb)
    local f = N("Frame", {Size = UDim2.new(1, 0, 0, 30), BackgroundTransparency = 1, Parent = par})
    N("TextLabel", {Size = UDim2.new(1, -50, 1, 0), BackgroundTransparency = 1, Text = txt, TextColor3 = Col.Text, TextSize = 11, Font = Enum.Font.Code, TextXAlignment = Enum.TextXAlignment.Left, Parent = f})
    local on = def
    local tr = N("Frame", {Size = UDim2.new(0, 38, 0, 18), Position = UDim2.new(1, -42, 0.5, -9), BackgroundColor3 = def and Col.On or Col.Off, BorderSizePixel = 0, Parent = f, Ch = {Cr(9)}})
    local dt = N("Frame", {Size = UDim2.new(0, 12, 0, 12), Position = def and UDim2.new(1, -14, 0.5, -6) or UDim2.new(0, 3, 0.5, -6), BackgroundColor3 = Color3.new(1,1,1), BorderSizePixel = 0, Parent = tr, Ch = {Cr(6)}})
    N("TextButton", {Size = UDim2.new(1, 0, 1, 0), BackgroundTransparency = 1, Text = "", ZIndex = 10, Parent = f}).MouseButton1Click:Connect(function()
        on = not on; tr.BackgroundColor3 = on and Col.On or Col.Off
        dt.Position = on and UDim2.new(1, -14, 0.5, -6) or UDim2.new(0, 3, 0.5, -6)
        if cb then cb(on) end
    end)
end
local function Btn(par, txt, cb)
    local b = N("TextButton", {Size = UDim2.new(1, 0, 0, 28), BackgroundColor3 = Col.AccentD, BorderSizePixel = 0, Text = txt, TextColor3 = Color3.new(1,1,1), TextSize = 11, Font = Enum.Font.Code, Parent = par, Ch = {Cr(6)}})
    b.MouseButton1Click:Connect(function() if cb then cb() end end)
    return b
end
local function Lbl(par, txt)
    return N("TextLabel", {Size = UDim2.new(1, 0, 0, 0), AutomaticSize = Enum.AutomaticSize.Y, BackgroundTransparency = 1, Text = txt, TextColor3 = Col.Dim, TextSize = 9, Font = Enum.Font.Code, TextXAlignment = Enum.TextXAlignment.Left, TextWrapped = true, Parent = par})
end

-- ORB
local Orb = N("ImageButton", {Size = UDim2.new(0, 48, 0, 48), Position = UDim2.new(0, 8, 0.5, -24), BackgroundColor3 = Col.Accent, BorderSizePixel = 0, AutoButtonColor = false, Parent = SG, Ch = {Cr(24), N("UIStroke", {Color = Color3.fromRGB(0,255,255), Thickness = 2, Transparency = 0.3}), N("TextLabel", {Size = UDim2.new(1, 0, 1, 0), BackgroundTransparency = 1, Text = "rncx", TextColor3 = Color3.new(1,1,1), TextSize = 12, Font = Enum.Font.Code})}})
local OrbOpen = true
Orb.MouseButton1Click:Connect(function() OrbOpen = not OrbOpen; MF.Visible = OrbOpen end)
task.spawn(function() local a = 0; while SG.Parent do a = a + RunService.Heartbeat:Wait() * 2; Orb.Rotation = math.sin(a) * 5; Orb.BackgroundColor3 = Color3.fromHSV((math.sin(a*0.3)+1)/2*0.55, 0.8, 1) end end)
UserInputService.InputBegan:Connect(function(input, gpe)
    if not gpe and input.KeyCode == Enum.KeyCode.RightShift then OrbOpen = not OrbOpen; MF.Visible = OrbOpen end
end)

-- NOTI
local NotiFrame = N("Frame", {Size = UDim2.new(0, 280, 0, 0), AutomaticSize = Enum.AutomaticSize.Y, Position = UDim2.new(1, -290, 0, 56), BackgroundTransparency = 1, BorderSizePixel = 0, Parent = SG, Ch = {N("UIListLayout", {Padding = UDim.new(0, 4)})}})
local function Notify(txt, color, dur)
    color = color or Col.Accent; dur = dur or 3
    local n = N("Frame", {Size = UDim2.new(1, 0, 0, 30), BackgroundColor3 = Col.Panel, BorderSizePixel = 0, Parent = NotiFrame, Ch = {Cr(6), St(color), N("TextLabel", {Size = UDim2.new(1, -12, 1, 0), Position = UDim2.new(0, 10, 0, 0), BackgroundTransparency = 1, Text = txt, TextColor3 = color, TextSize = 10, Font = Enum.Font.Code, TextXAlignment = Enum.TextXAlignment.Left})}})
    task.delay(dur, function() if n and n.Parent then n:Destroy() end end)
end

local function PRoot() local c = Player.Character; return c and c:FindFirstChild("HumanoidRootPart") end
local function PHum() local c = Player.Character; return c and c:FindFirstChild("Humanoid") end

local function ForceGameDisplay()
    pcall(function()
        local ls = Player:FindFirstChild("leaderstats")
        if not ls then return end
        local c = ls:FindFirstChild("Coins") and ls.Coins.Value or 0
        local topGui = Player.PlayerGui:FindFirstChild("TopGui")
        if topGui then
            local f = topGui:FindFirstChild("Frame")
            if f then f = f:FindFirstChild("Assets") end
            if f then f = f:FindFirstChild("Coin") end
            if f then f = f:FindFirstChild("Frame") end
            if f then f = f:FindFirstChild("TextLabel") end
            if f then f.Text = FormatNum(c) end
        end
    end)
end

-- TABS
local T1 = MakeTab("Farm")
local T2 = MakeTab("Shop")
local T3 = MakeTab("Pets")
local T4 = MakeTab("Player")

-- FARM TAB
local G1 = Grp(T1, "COINS (auto farming)")
Tog(G1, "Coins ON/OFF", true, function(v) CoinsOn = v end)
Btn(G1, "Burst +200M Coins", function()
    task.spawn(function()
        for i = 1, 40 do task.spawn(function() fire:FireServer(999999, "Coins") end); task.wait(0.05) end
        Notify("+200M Coins sent!", Col.Ok)
    end)
end)

local G1b = Grp(T1, "WINS (auto farming)")
Tog(G1b, "Wins ON/OFF", true, function(v) WinsOn = v end)
Btn(G1b, "Burst +10M Wins", function()
    task.spawn(function()
        for i = 1, 40 do task.spawn(function() fire:FireServer(999999, "Wins") end); task.wait(0.05) end
        Notify("+10M Wins sent!", Col.Ok)
    end)
end)

local G1c = Grp(T1, "NOTE")
Lbl(G1c, "Server caps each fire. Coins are REAL and can buy items. Spaced fires earn more than bursts.")

-- SHOP TAB
local G2 = Grp(T2, "AUTO BUY")
Tog(G2, "Auto Buy All Bikes", false, function(v)
    if not v then return end
    task.spawn(function()
        while v and SG.Parent do
            task.wait(1)
            pcall(function()
                local u = Remotes.GetUnlockedCars:InvokeServer()
                for name, data in pairs(CarConfig.WorldCar) do
                    if data.Type == "Buy" and data.price then
                        if not u or not u[name] then
                            Remotes.BuyTool:InvokeServer(name)
                        end
                    end
                end
            end)
        end
    end)
end)
Tog(G2, "Auto Buy All Gears", false, function(v)
    if not v then return end
    task.spawn(function()
        while v and SG.Parent do
            task.wait(1)
            pcall(function()
                for name, data in pairs(GearConfig) do
                    if type(data) == "table" and data.Price then
                        Remotes.BuyGear:InvokeServer(name)
                    end
                end
            end)
        end
    end)
end)
Tog(G2, "Auto Buy All Trails", false, function(v)
    if not v then return end
    task.spawn(function()
        while v and SG.Parent do
            task.wait(1)
            pcall(function()
                for name, data in pairs(TrailConfig) do
                    if type(data) == "table" and data.price then
                        Remotes.BuyTrail:FireServer(name)
                    end
                end
            end)
        end
    end)
end)

local G2b = Grp(T2, "EQUIP BEST")
Btn(G2b, "Equip Best Pet", function()
    pcall(function() Remotes.EquipBestPet:FireServer() end)
    Notify("Done!", Col.Ok)
end)
Btn(G2b, "Equip Best Bike", function()
    task.spawn(function()
        local best, bestP = nil, -1
        pcall(function()
            local u = Remotes.GetUnlockedCars:InvokeServer()
            if u then
                for n, _ in pairs(u) do
                    local d = CarConfig.WorldCar[n]
                    if d and d.price and d.price > bestP then
                        bestP = d.price
                        best = n
                    end
                end
            end
        end)
        if best then
            pcall(function() Remotes.EquipCar:FireServer(best) end)
            Notify("Equipped " .. best, Col.Ok)
        end
    end)
end)
Btn(G2b, "Equip Best Gear", function()
    task.spawn(function()
        local best, bestP = nil, -1
        pcall(function()
            local u = Remotes.GetGearUnlock:InvokeServer()
            if u then
                for n, _ in pairs(u) do
                    local d = GearConfig[n]
                    if d and d.Price and d.Price > bestP then
                        bestP = d.Price
                        best = n
                    end
                end
            end
        end)
        if best then
            pcall(function() Remotes.EquipGear:FireServer(best) end)
            Notify("Equipped " .. best, Col.Ok)
        end
    end)
end)

-- PETS TAB
local hatchCount = 0
local hatchLabel = nil

local G4a = Grp(T3, "HATCH EGGS")
hatchLabel = Lbl(G4a, "Hatched: 0")

local eggList = {
    {name = "Egg2_3", label = "Best Egg (6B)"},
    {name = "Egg2_2", label = "Egg2_2 (500M)"},
    {name = "Egg2_1", label = "Egg2_1 (10M)"},
    {name = "Egg1_3", label = "Egg1_3 (500K)"},
    {name = "Egg1_2", label = "Egg1_2 (20K)"},
    {name = "Egg1_1", label = "Egg1_1 (100)"},
}

for _, egg in ipairs(eggList) do
    Btn(G4a, "Hatch 1x " .. egg.label, function()
        task.spawn(function()
            local ok, res = pcall(function()
                return Remotes.doLuck:InvokeServer(egg.name, {}, 1)
            end)
            if ok and type(res) == "table" and res[1] then
                hatchCount = hatchCount + 1
                hatchLabel.Text = "Hatched: " .. hatchCount .. " | Last: " .. tostring(res[1])
                Notify("Hatched: " .. tostring(res[1]), Col.Gold)
            else
                Notify("Hatch failed!", Col.Err)
            end
        end)
    end)
end

local G4b = Grp(T3, "AUTO HATCH")
Tog(G4b, "Auto Hatch Best Egg (1/sec)", false, function(v)
    if not v then return end
    task.spawn(function()
        while v and SG.Parent do
            local ok, res = pcall(function()
                return Remotes.doLuck:InvokeServer("Egg2_3", {}, 1)
            end)
            if ok and type(res) == "table" and res[1] then
                hatchCount = hatchCount + 1
                hatchLabel.Text = "Hatched: " .. hatchCount .. " | Last: " .. tostring(res[1])
            end
            task.wait(1)
        end
    end)
end)

local G4c = Grp(T3, "PET ACTIONS")
Btn(G4c, "Equip Best Pet", function()
    pcall(function() Remotes.EquipBestPet:FireServer() end)
    Notify("Best pet equipped!", Col.Ok)
end)

-- PLAYER TAB
local RebirthConfig = require(RS.Config.Rebirth)
local rebirthConditions = {}
for i, data in pairs(RebirthConfig) do
    if type(data) == "table" and data.condition then
        rebirthConditions[tonumber(i)] = tonumber(data.condition)
    end
end

local G3 = Grp(T4, "REBIRTH")
local rebirthLabel = Lbl(G3, "Rebirth: 0 | Power: 0")
Tog(G3, "Auto Rebirth", false, function(v)
    if not v then return end
    task.spawn(function()
        while v and SG.Parent do
            task.wait(1)
            pcall(function()
                local ls = Player:FindFirstChild("leaderstats")
                local rf = Player:FindFirstChild("Rebirth")
                local rt = rf and rf:FindFirstChild("RebirthTime")
                if ls and rt then
                    local power = ls.Power.Value
                    local current = rt.Value
                    local nextReq = rebirthConditions[current + 1]
                    rebirthLabel.Text = "Rebirth: " .. current .. " | Power: " .. FormatNum(power) .. (nextReq and (" | Next: " .. FormatNum(nextReq)) or " | MAX")
                    if nextReq and power >= nextReq then
                        Remotes.Rebirth:FireServer()
                        Notify("Rebirth! Level " .. (current + 1), Col.Ok)
                    end
                end
            end)
        end
    end)
end)

local G3m = Grp(T4, "MOVEMENT")
Tog(G3m, "Speed 100", false, function(v) local h = PHum(); if h then h.WalkSpeed = v and 100 or 16 end end)
Tog(G3m, "Noclip", false, function(v)
    task.spawn(function() while v and SG.Parent do task.wait(0.1); pcall(function() local hrp = PRoot(); if hrp then hrp.CanCollide = false end end) end end)
end)
Tog(G3m, "Infinite Jump", false, function(v)
    if v then
        _G._rncx_ij = UserInputService.JumpRequest:Connect(function()
            pcall(function() local h = PHum(); if h then h:ChangeState(Enum.HumanoidStateType.Jumping) end end)
        end)
    else
        if _G._rncx_ij then _G._rncx_ij:Disconnect(); _G._rncx_ij = nil end
    end
end)
Tog(G3m, "Auto Pet Equip", false, function(v)
    task.spawn(function() while v and SG.Parent do task.wait(3); pcall(function() Remotes.EquipBestPet:FireServer() end) end end)
end)

-- FARM LOOPS
for i = 1, 12 do
    task.spawn(function()
        while SG.Parent do
            if CoinsOn then pcall(function() fire:FireServer(999999, "Coins") end) end
            task.wait(0.08 + (i * 0.005))
        end
    end)
end
for i = 1, 6 do
    task.spawn(function()
        while SG.Parent do
            if WinsOn then pcall(function() fire:FireServer(999999, "Wins") end) end
            task.wait(0.08 + (i * 0.005))
        end
    end)
end

-- ANTI-AFK
task.spawn(function() while SG.Parent do task.wait(30); pcall(function() VirtualUser:CaptureController(); VirtualUser:ClickButton2(Vector2.new()) end) end end)

-- TRACK EARNED
local startCoins, startWins = 0, 0
pcall(function() startCoins = Player.leaderstats.Coins.Value end)
pcall(function() startWins = Player.leaderstats.Wins.Value end)

-- UPDATE DISPLAYS
task.spawn(function()
    while SG.Parent do
        task.wait(0.5)
        pcall(function()
            local ls = Player:FindFirstChild("leaderstats")
            if ls then
                local c = ls:FindFirstChild("Coins") and ls.Coins.Value or 0
                local w = ls:FindFirstChild("Wins") and ls.Wins.Value or 0
                CoinIcon.Text = "Coins: " .. FormatNum(c) .. " (+" .. FormatNum(c - startCoins) .. ")"
                WinIcon.Text = "Wins: " .. FormatNum(w) .. " (+" .. FormatNum(w - startWins) .. ")"
                ForceGameDisplay()
            end
        end)
    end
end)

-- INIT
Tabs["Farm"].Visible = true; TBtns["Farm"].TextColor3 = Col.Accent
task.spawn(function() task.wait(1)
    Notify("Coins + Wins auto farming ON", Col.Ok, 4)
    Notify("Pets + Rebirth tabs added!", Col.Gold, 5)
end)
print("rncx hub ULTRA v5 loaded!")
