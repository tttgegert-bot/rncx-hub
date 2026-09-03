-- ═══════════════════════════════════════════════════════════════
--  rncx hub — LOADER v2.1
--  Animated • Premium Feel • Game Detection
-- ═══════════════════════════════════════════════════════════════

local Players = game:GetService("Players")
local UIS = game:GetService("UserInputService")
local TS = game:GetService("TweenService")
local LP = Players.LocalPlayer
local PG = LP:WaitForChild("PlayerGui")

-- ═══════════════════════════════════════════
--  CONFIG
-- ═══════════════════════════════════════════
local VALID_KEY = "rncx"

local GAMES = {
    [3623096087] = {
        name = "Muscle Legends",
        desc = "Train, Rebirth, Crystals, Brawl, Pets, 161 features",
        url = "https://raw.githubusercontent.com/tttgegert-bot/rncx-hub/main/rncx_hub_v8.luau",
        color = Color3.fromRGB(0, 220, 255),
    },
    [108389155265141] = {
        name = "Bike Downhill",
        desc = "Coins, Wins, Rebirth, Pets, Auto Buy",
        url = "https://raw.githubusercontent.com/tttgegert-bot/rncx-hub/main/bike_downhill_final.luau",
        color = Color3.fromRGB(0, 230, 118),
    },
}

-- ═══════════════════════════════════════════
--  THEME
-- ═══════════════════════════════════════════
local T = {
    bg      = Color3.fromRGB(3, 5, 12),
    panel   = Color3.fromRGB(8, 12, 24),
    card    = Color3.fromRGB(12, 18, 34),
    cardHi  = Color3.fromRGB(18, 26, 48),
    border  = Color3.fromRGB(25, 45, 75),
    cyan    = Color3.fromRGB(0, 220, 255),
    cyanD   = Color3.fromRGB(0, 130, 170),
    cyanG   = Color3.fromRGB(0, 255, 255),
    green   = Color3.fromRGB(0, 230, 118),
    red     = Color3.fromRGB(255, 82, 82),
    orange  = Color3.fromRGB(255, 170, 50),
    purple  = Color3.fromRGB(140, 70, 255),
    pink    = Color3.fromRGB(255, 50, 150),
    txt     = Color3.fromRGB(220, 235, 255),
    dim     = Color3.fromRGB(70, 90, 120),
}

-- ═══════════════════════════════════════════
--  CLEANUP
-- ═══════════════════════════════════════════
local old = PG:FindFirstChild("rncxLoader")
if old then old:Destroy() end

-- ═══════════════════════════════════════════
--  UI HELPERS
-- ═══════════════════════════════════════════
local function N(c, p)
    local i = Instance.new(c)
    for k, v in pairs(p) do
        if k ~= "Parent" and k ~= "Children" then
            pcall(function() i[k] = v end)
        end
    end
    if p.Children then
        for _, ch in ipairs(p.Children) do ch.Parent = i end
    end
    if p.Parent then i.Parent = p.Parent end
    return i
end

local function Cr(r) return N("UICorner", {CornerRadius = UDim.new(0, r or 8)}) end
local function St(c, t) return N("UIStroke", {Color = c or T.border, Thickness = t or 1, Transparency = 0.3}) end

-- ═══════════════════════════════════════════
--  SCREEN GUI
-- ═══════════════════════════════════════════
local SG = N("ScreenGui", {
    Name = "rncxLoader",
    ResetOnSpawn = false,
    ZIndexBehavior = Enum.ZIndexBehavior.Sibling,
    DisplayOrder = 999,
    Parent = PG,
})

-- ═══════════════════════════════════════════
--  BACKGROUND
-- ═══════════════════════════════════════════
local BG = N("Frame", {
    Size = UDim2.new(1, 0, 1, 0),
    BackgroundColor3 = T.bg,
    BackgroundTransparency = 0.4,
    BorderSizePixel = 0,
    Parent = SG,
})

-- Scanlines
task.spawn(function()
    for i = 1, 4 do
        local line = N("Frame", {
            Size = UDim2.new(1, 0, 0, 1),
            Position = UDim2.new(0, 0, (i - 1) * 0.25, 0),
            BackgroundColor3 = T.cyan,
            BackgroundTransparency = 0.92,
            BorderSizePixel = 0,
            ZIndex = 1,
            Parent = BG,
        })
        task.spawn(function()
            local y = (i - 1) * 0.25
            while SG.Parent do
                y = y + 0.002
                if y > 1.1 then y = -0.1 end
                line.Position = UDim2.new(0, 0, y, 0)
                task.wait()
            end
        end)
    end
end)

-- Glow blobs
task.spawn(function()
    local blobs = {
        {pos = UDim2.new(0, -60, 0, -60), col = T.cyan},
        {pos = UDim2.new(1, -40, 1, -40), col = T.purple},
        {pos = UDim2.new(0.7, 0, 0, -30), col = T.pink},
    }
    for _, b in blobs do
        local blob = N("Frame", {
            Size = UDim2.new(0, 200, 0, 200),
            Position = b.pos,
            BackgroundColor3 = b.col,
            BackgroundTransparency = 0.95,
            BorderSizePixel = 0,
            ZIndex = 1,
            Parent = BG,
            Children = {Cr(200)},
        })
        task.spawn(function()
            local up = true
            while SG.Parent do
                local target = up and 0.88 or 0.96
                TS:Create(blob, TweenInfo.new(3, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut), {BackgroundTransparency = target}):Play()
                up = not up
                task.wait(3)
            end
        end)
    end
end)

-- ═══════════════════════════════════════════
--  MAIN FRAME (created immediately, hidden)
-- ═══════════════════════════════════════════
local MF = N("Frame", {
    Size = UDim2.new(0, 460, 0, 400),
    Position = UDim2.new(0.5, -230, 0.5, -200),
    BackgroundColor3 = T.bg,
    BorderSizePixel = 0,
    Active = true,
    Draggable = true,
    Visible = false,
    Parent = SG,
    Children = {Cr(16), St(T.cyan)},
})

-- Title bar
local TB = N("Frame", {
    Size = UDim2.new(1, 0, 0, 48),
    BackgroundColor3 = T.panel,
    BorderSizePixel = 0,
    Parent = MF,
    Children = {Cr(16)},
})
N("Frame", {
    Size = UDim2.new(1, 0, 0, 14),
    Position = UDim2.new(0, 0, 1, -14),
    BackgroundColor3 = T.panel,
    BorderSizePixel = 0,
    Parent = TB,
})
N("TextLabel", {
    Size = UDim2.new(0, 180, 1, 0),
    Position = UDim2.new(0, 16, 0, 0),
    BackgroundTransparency = 1,
    Text = "R ncx hub",
    TextColor3 = T.cyan,
    TextSize = 16,
    Font = Enum.Font.GothamBlack,
    TextXAlignment = Enum.TextXAlignment.Left,
    Parent = TB,
})
N("Frame", {
    Size = UDim2.new(0, 36, 0, 16),
    Position = UDim2.new(0, 130, 0.5, -8),
    BackgroundColor3 = T.cyanD,
    BorderSizePixel = 0,
    Parent = TB,
    Children = {Cr(8), N("TextLabel", {
        Size = UDim2.new(1, 0, 1, 0),
        BackgroundTransparency = 1,
        Text = "v2.0",
        TextColor3 = Color3.new(1,1,1),
        TextSize = 8,
        Font = Enum.Font.GothamBold,
    })},
})

local closeBtn = N("TextButton", {
    Size = UDim2.new(0, 30, 0, 30),
    Position = UDim2.new(1, -38, 0, 9),
    BackgroundColor3 = T.red,
    BorderSizePixel = 0,
    Text = "X",
    TextColor3 = Color3.new(1,1,1),
    TextSize = 12,
    Font = Enum.Font.Code,
    Parent = TB,
    Children = {Cr(6)},
})

-- ═══════════════════════════════════════════
--  KEY PAGE (inside MF)
-- ═══════════════════════════════════════════
local KeyPage = N("Frame", {
    Size = UDim2.new(1, -24, 1, -60),
    Position = UDim2.new(0, 12, 0, 54),
    BackgroundTransparency = 1,
    Parent = MF,
})

N("TextLabel", {
    Size = UDim2.new(1, 0, 0, 40),
    BackgroundTransparency = 1,
    Text = "\xF0\x9F\x94\x91",
    TextSize = 32,
    Parent = KeyPage,
})

N("TextLabel", {
    Size = UDim2.new(1, 0, 0, 22),
    Position = UDim2.new(0, 0, 0, 42),
    BackgroundTransparency = 1,
    Text = "ENTER YOUR KEY",
    TextColor3 = T.cyan,
    TextSize = 16,
    Font = Enum.Font.GothamBlack,
    TextXAlignment = Enum.TextXAlignment.Center,
    Parent = KeyPage,
})

N("TextLabel", {
    Size = UDim2.new(1, 0, 0, 14),
    Position = UDim2.new(0, 0, 0, 66),
    BackgroundTransparency = 1,
    Text = "Get your key from Discord",
    TextColor3 = T.dim,
    TextSize = 11,
    Font = Enum.Font.Gotham,
    TextXAlignment = Enum.TextXAlignment.Center,
    Parent = KeyPage,
})

local DiscordBtn = N("TextButton", {
    Size = UDim2.new(0, 200, 0, 24),
    Position = UDim2.new(0.5, -100, 0, 82),
    BackgroundColor3 = Color3.fromRGB(88, 101, 242),
    BorderSizePixel = 0,
    Text = "discord.gg/sx5ZYAZGT",
    TextColor3 = Color3.new(1,1,1),
    TextSize = 10,
    Font = Enum.Font.GothamBold,
    Parent = KeyPage,
    Children = {Cr(6)},
})

local KeyBoxStroke = St(T.border)
local KeyBox = N("TextBox", {
    Size = UDim2.new(1, 0, 0, 42),
    Position = UDim2.new(0, 0, 0, 116),
    BackgroundColor3 = T.card,
    BorderSizePixel = 0,
    Text = "",
    PlaceholderText = "paste key here...",
    PlaceholderColor3 = T.dim,
    TextColor3 = T.txt,
    TextSize = 14,
    Font = Enum.Font.Code,
    ClearTextOnFocus = false,
    Parent = KeyPage,
    Children = {Cr(10), KeyBoxStroke},
})

local KeyStatus = N("TextLabel", {
    Size = UDim2.new(1, 0, 0, 14),
    Position = UDim2.new(0, 0, 0, 162),
    BackgroundTransparency = 1,
    Text = "",
    TextColor3 = T.dim,
    TextSize = 10,
    Font = Enum.Font.Gotham,
    TextXAlignment = Enum.TextXAlignment.Center,
    Parent = KeyPage,
})

local SubmitBtn = N("TextButton", {
    Size = UDim2.new(1, 0, 0, 40),
    Position = UDim2.new(0, 0, 0, 182),
    BackgroundColor3 = T.cyanD,
    BorderSizePixel = 0,
    Text = "VERIFY & CONTINUE",
    TextColor3 = Color3.new(1,1,1),
    TextSize = 13,
    Font = Enum.Font.GothamBold,
    Parent = KeyPage,
    Children = {Cr(10)},
})

-- ═══════════════════════════════════════════
--  GAME PAGE (inside MF, hidden)
-- ═══════════════════════════════════════════
local GamePage = N("Frame", {
    Size = UDim2.new(1, -24, 1, -60),
    Position = UDim2.new(0, 12, 0, 54),
    BackgroundTransparency = 1,
    Visible = false,
    Parent = MF,
})

N("TextLabel", {
    Size = UDim2.new(1, 0, 0, 22),
    BackgroundTransparency = 1,
    Text = "SELECT YOUR GAME",
    TextColor3 = T.cyan,
    TextSize = 14,
    Font = Enum.Font.GothamBlack,
    TextXAlignment = Enum.TextXAlignment.Left,
    Parent = GamePage,
})

N("TextLabel", {
    Size = UDim2.new(1, 0, 0, 14),
    Position = UDim2.new(0, 0, 0, 22),
    BackgroundTransparency = 1,
    Text = "Detected: " .. game.PlaceId,
    TextColor3 = T.dim,
    TextSize = 9,
    Font = Enum.Font.Code,
    TextXAlignment = Enum.TextXAlignment.Left,
    Parent = GamePage,
})

local GameScroll = N("ScrollingFrame", {
    Size = UDim2.new(1, 0, 1, -42),
    Position = UDim2.new(0, 0, 0, 40),
    BackgroundTransparency = 1,
    ScrollBarThickness = 2,
    ScrollBarImageColor3 = T.cyan,
    BorderSizePixel = 0,
    CanvasSize = UDim2.new(0, 0, 0, 0),
    AutomaticCanvasSize = Enum.AutomaticSize.Y,
    Parent = GamePage,
    Children = {
        N("UIListLayout", {Padding = UDim.new(0, 8), SortOrder = Enum.SortOrder.LayoutOrder}),
        N("UIPadding", {PaddingTop = UDim.new(0, 4)}),
    },
})

-- ═══════════════════════════════════════════
--  POPULATE GAME LIST
-- ═══════════════════════════════════════════
local currentPlaceId = game.PlaceId
local order = 0

for placeId, data in pairs(GAMES) do
    order += 1
    local isCurrent = (placeId == currentPlaceId)

    local card = N("Frame", {
        Size = UDim2.new(1, 0, 0, 72),
        BackgroundColor3 = T.card,
        BackgroundTransparency = 0.4,
        BorderSizePixel = 0,
        LayoutOrder = order,
        Parent = GameScroll,
        Children = {Cr(12), St(isCurrent and data.color or T.border)},
    })

    N("Frame", {
        Size = UDim2.new(0, 4, 0.6, 0),
        Position = UDim2.new(0, 12, 0.2, 0),
        BackgroundColor3 = data.color,
        BorderSizePixel = 0,
        Parent = card,
        Children = {Cr(2)},
    })

    N("TextLabel", {
        Size = UDim2.new(0.55, 0, 0, 20),
        Position = UDim2.new(0, 24, 0, 10),
        BackgroundTransparency = 1,
        Text = data.name,
        TextColor3 = T.txt,
        TextSize = 14,
        Font = Enum.Font.GothamBold,
        TextXAlignment = Enum.TextXAlignment.Left,
        Parent = card,
    })

    N("TextLabel", {
        Size = UDim2.new(0.55, 0, 0, 14),
        Position = UDim2.new(0, 24, 0, 32),
        BackgroundTransparency = 1,
        Text = data.desc,
        TextColor3 = T.dim,
        TextSize = 10,
        Font = Enum.Font.Gotham,
        TextXAlignment = Enum.TextXAlignment.Left,
        Parent = card,
    })

    N("Frame", {
        Size = UDim2.new(0, 72, 0, 18),
        Position = UDim2.new(0, 24, 0, 50),
        BackgroundColor3 = isCurrent and T.green or T.dim,
        BackgroundTransparency = 0.85,
        BorderSizePixel = 0,
        Parent = card,
        Children = {Cr(4), N("TextLabel", {
            Size = UDim2.new(1, 0, 1, 0),
            BackgroundTransparency = 1,
            Text = isCurrent and "DETECTED" or "OTHER GAME",
            TextColor3 = isCurrent and T.green or T.dim,
            TextSize = 8,
            Font = Enum.Font.GothamBold,
        })},
    })

    local actBtn = N("TextButton", {
        Size = UDim2.new(0, 100, 0, 34),
        Position = UDim2.new(1, -116, 0.5, -17),
        BackgroundColor3 = isCurrent and data.color or T.card,
        BackgroundTransparency = isCurrent and 0.8 or 0.5,
        BorderSizePixel = 0,
        Text = isCurrent and "EXECUTE" or "COPY URL",
        TextColor3 = isCurrent and data.color or T.dim,
        TextSize = 10,
        Font = Enum.Font.GothamBold,
        Parent = card,
        Children = {Cr(8), St(isCurrent and data.color or T.border)},
    })

    if isCurrent then
        actBtn.MouseEnter:Connect(function()
            TS:Create(actBtn, TweenInfo.new(0.15), {BackgroundTransparency = 0.6}):Play()
        end)
        actBtn.MouseLeave:Connect(function()
            TS:Create(actBtn, TweenInfo.new(0.15), {BackgroundTransparency = 0.8}):Play()
        end)
        actBtn.MouseButton1Click:Connect(function()
            actBtn.Text = "LOADING..."
            TS:Create(actBtn, TweenInfo.new(0.2), {BackgroundColor3 = T.green, BackgroundTransparency = 0.6}):Play()
            local ok, src = pcall(function()
                local res = request({Url = data.url, Method = "GET"})
                if res.Success then return res.Body end
                error("HTTP " .. tostring(res.StatusCode))
            end)
            if ok and src then
                actBtn.Text = "SUCCESS"
                task.wait(0.3)
                TS:Create(MF, TweenInfo.new(0.4), {BackgroundTransparency = 1}):Play()
                TS:Create(BG, TweenInfo.new(0.4), {BackgroundTransparency = 1}):Play()
                task.wait(0.4)
                SG:Destroy()
                loadstring(src)()
            else
                actBtn.Text = "FAILED"
                TS:Create(actBtn, TweenInfo.new(0.2), {BackgroundColor3 = T.red}):Play()
                task.wait(1.5)
                actBtn.Text = "EXECUTE"
                TS:Create(actBtn, TweenInfo.new(0.2), {BackgroundColor3 = data.color, BackgroundTransparency = 0.8}):Play()
            end
        end)
    else
        actBtn.MouseButton1Click:Connect(function()
            pcall(function() setclipboard(data.url) end)
            actBtn.Text = "COPIED!"
            TS:Create(actBtn, TweenInfo.new(0.15), {BackgroundColor3 = T.green, BackgroundTransparency = 0.6}):Play()
            task.wait(1.2)
            actBtn.Text = "COPY URL"
            TS:Create(actBtn, TweenInfo.new(0.15), {BackgroundColor3 = T.card, BackgroundTransparency = 0.5}):Play()
        end)
    end

    -- Stagger entry
    task.spawn(function()
        card.BackgroundTransparency = 1
        for _, child in card:GetDescendants() do
            if child:IsA("TextLabel") then child.TextTransparency = 1 end
            if child:IsA("UIStroke") then child.Transparency = 1 end
        end
        task.wait(order * 0.12)
        TS:Create(card, TweenInfo.new(0.3, Enum.EasingStyle.Quint), {BackgroundTransparency = 0.4}):Play()
        for _, child in card:GetDescendants() do
            if child:IsA("TextLabel") then TS:Create(child, TweenInfo.new(0.3), {TextTransparency = 0}):Play() end
            if child:IsA("UIStroke") then TS:Create(child, TweenInfo.new(0.3), {Transparency = 0.3}):Play() end
        end
    end)
end

-- Unknown game message
if not GAMES[currentPlaceId] then
    order += 1
    N("Frame", {
        Size = UDim2.new(1, 0, 0, 80),
        BackgroundColor3 = T.card,
        BackgroundTransparency = 0.5,
        BorderSizePixel = 0,
        LayoutOrder = order,
        Parent = GameScroll,
        Children = {Cr(12), St(T.orange), N("TextLabel", {
            Size = UDim2.new(1, -24, 0, 20),
            Position = UDim2.new(0, 12, 0, 14),
            BackgroundTransparency = 1,
            Text = "Game not supported yet",
            TextColor3 = T.orange,
            TextSize = 12,
            Font = Enum.Font.GothamBold,
            TextXAlignment = Enum.TextXAlignment.Left,
        }), N("TextLabel", {
            Size = UDim2.new(1, -24, 0, 30),
            Position = UDim2.new(0, 12, 0, 36),
            BackgroundTransparency = 1,
            Text = "Join our Discord to request support!",
            TextColor3 = T.dim,
            TextSize = 10,
            Font = Enum.Font.Gotham,
            TextWrapped = true,
            TextXAlignment = Enum.TextXAlignment.Left,
        })},
    })
end

-- ═══════════════════════════════════════════
--  KEY VERIFY LOGIC
-- ═══════════════════════════════════════════
DiscordBtn.MouseButton1Click:Connect(function()
    pcall(function() setclipboard("discord.gg/sx5ZYAZGT") end)
    DiscordBtn.Text = "COPIED!"
    task.wait(1)
    DiscordBtn.Text = "discord.gg/sx5ZYAZGT"
end)

KeyBox.Focused:Connect(function()
    TS:Create(KeyBoxStroke, TweenInfo.new(0.2), {Color = T.cyan, Transparency = 0}):Play()
end)
KeyBox.FocusLost:Connect(function()
    TS:Create(KeyBoxStroke, TweenInfo.new(0.2), {Color = T.border, Transparency = 0.3}):Play()
end)

local function DoVerify()
    local key = string.gsub(KeyBox.Text, "%s+", "")
    if key == VALID_KEY then
        KeyStatus.Text = "Key verified!"
        KeyStatus.TextColor3 = T.green
        TS:Create(SubmitBtn, TweenInfo.new(0.2), {BackgroundColor3 = T.green}):Play()
        task.wait(0.6)
        KeyPage.Visible = false
        GamePage.Visible = true
    else
        KeyStatus.Text = "Invalid key - join Discord"
        KeyStatus.TextColor3 = T.red
        TS:Create(SubmitBtn, TweenInfo.new(0.1), {BackgroundColor3 = T.red}):Play()
        TS:Create(KeyBoxStroke, TweenInfo.new(0.1), {Color = T.red, Transparency = 0}):Play()
        task.wait(0.4)
        TS:Create(SubmitBtn, TweenInfo.new(0.2), {BackgroundColor3 = T.cyanD}):Play()
        TS:Create(KeyBoxStroke, TweenInfo.new(0.2), {Color = T.border, Transparency = 0.3}):Play()
    end
end

SubmitBtn.MouseButton1Click:Connect(DoVerify)
KeyBox.FocusLost:Connect(function(enter) if enter then DoVerify() end end)

closeBtn.MouseButton1Click:Connect(function()
    MF.Visible = false
    Orb.Visible = true
end)

-- Submit button pulse
task.spawn(function()
    while SG.Parent and SubmitBtn.Parent do
        TS:Create(SubmitBtn, TweenInfo.new(1.5, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut), {BackgroundColor3 = T.cyan}):Play()
        task.wait(1.5)
        TS:Create(SubmitBtn, TweenInfo.new(1.5, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut), {BackgroundColor3 = T.cyanD}):Play()
        task.wait(1.5)
    end
end)

-- ═══════════════════════════════════════════
--  ORB
-- ═══════════════════════════════════════════
local OrbStroke = St(T.cyan)
local Orb = N("TextButton", {
    Size = UDim2.new(0, 50, 0, 50),
    Position = UDim2.new(0, 14, 0.5, -25),
    BackgroundColor3 = T.panel,
    BorderSizePixel = 0,
    Text = "",
    AutoButtonColor = false,
    Visible = false,
    Parent = SG,
    Children = {Cr(14), OrbStroke, N("TextLabel", {
        Size = UDim2.new(1, 0, 1, 0),
        BackgroundTransparency = 1,
        Text = "R",
        TextColor3 = T.cyan,
        TextSize = 18,
        Font = Enum.Font.GothamBlack,
    })},
})

Orb.MouseButton1Click:Connect(function()
    Orb.Visible = false
    MF.Visible = true
end)

task.spawn(function()
    local a = 0
    while SG.Parent do
        a += task.wait() * 2
        local v = (math.sin(a * 1.5) + 1) / 2
        OrbStroke.Transparency = 0.1 + v * 0.4
    end
end)

-- ═══════════════════════════════════════════
--  SPLASH SCREEN (runs last, on top)
-- ═══════════════════════════════════════════
local Splash = N("Frame", {
    Size = UDim2.new(0, 500, 0, 360),
    Position = UDim2.new(0.5, -250, 0.5, -180),
    BackgroundTransparency = 1,
    BorderSizePixel = 0,
    Parent = SG,
    ZIndex = 50,
})

local LogoText = N("TextLabel", {
    Size = UDim2.new(1, 0, 0, 60),
    Position = UDim2.new(0, 0, 0.3, -50),
    BackgroundTransparency = 1,
    Text = "rncx",
    TextColor3 = T.cyan,
    TextSize = 60,
    Font = Enum.Font.GothamBlack,
    TextTransparency = 1,
    Parent = Splash,
    ZIndex = 51,
})

local SubText = N("TextLabel", {
    Size = UDim2.new(1, 0, 0, 24),
    Position = UDim2.new(0, 0, 0.3, 20),
    BackgroundTransparency = 1,
    Text = "H U B",
    TextColor3 = T.txt,
    TextSize = 20,
    Font = Enum.Font.GothamBold,
    TextTransparency = 1,
    Parent = Splash,
    ZIndex = 51,
})

local LoadBarBG = N("Frame", {
    Size = UDim2.new(0, 300, 0, 4),
    Position = UDim2.new(0.5, -150, 0.3, 40),
    BackgroundColor3 = T.border,
    BorderSizePixel = 0,
    BackgroundTransparency = 1,
    Parent = Splash,
    ZIndex = 51,
    Children = {Cr(2)},
})
local LoadBarFill = N("Frame", {
    Size = UDim2.new(0, 0, 1, 0),
    BackgroundColor3 = T.cyan,
    BorderSizePixel = 0,
    BackgroundTransparency = 0.1,
    Parent = LoadBarBG,
    ZIndex = 52,
    Children = {Cr(2)},
})

local LoadStatus = N("TextLabel", {
    Size = UDim2.new(1, 0, 0, 16),
    Position = UDim2.new(0, 0, 0.3, 54),
    BackgroundTransparency = 1,
    Text = "",
    TextColor3 = T.dim,
    TextSize = 10,
    Font = Enum.Font.Code,
    TextTransparency = 1,
    Parent = Splash,
    ZIndex = 51,
})

-- Splash animation
task.spawn(function()
    TS:Create(LogoText, TweenInfo.new(0.8, Enum.EasingStyle.Quint), {TextTransparency = 0}):Play()
    task.wait(0.3)
    TS:Create(SubText, TweenInfo.new(0.6, Enum.EasingStyle.Quint), {TextTransparency = 0}):Play()
    task.wait(0.5)

    TS:Create(LoadBarBG, TweenInfo.new(0.3), {BackgroundTransparency = 0}):Play()
    TS:Create(LoadStatus, TweenInfo.new(0.3), {TextTransparency = 0}):Play()

    local steps = {
        {t = 0.4, txt = "initializing..."},
        {t = 0.6, txt = "loading modules..."},
        {t = 0.8, txt = "detecting game..."},
        {t = 1.0, txt = "ready"},
    }
    for _, s in steps do
        LoadStatus.Text = s.txt
        LoadStatus.TextColor3 = T.cyan
        TS:Create(LoadBarFill, TweenInfo.new(0.3, Enum.EasingStyle.Quint), {Size = UDim2.new(s.t, 0, 1, 0)}):Play()
        task.wait(0.4)
    end

    LoadStatus.TextColor3 = T.green
    task.wait(0.4)

    TS:Create(LogoText, TweenInfo.new(0.3), {TextTransparency = 1}):Play()
    TS:Create(SubText, TweenInfo.new(0.3), {TextTransparency = 1}):Play()
    TS:Create(LoadBarBG, TweenInfo.new(0.3), {BackgroundTransparency = 1}):Play()
    TS:Create(LoadStatus, TweenInfo.new(0.3), {TextTransparency = 1}):Play()
    task.wait(0.4)
    Splash:Destroy()

    MF.Visible = true
end)

print("[rncx hub] loader v2.1 loaded")
