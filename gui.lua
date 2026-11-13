-- ==========================================================
-- CLEAN GLASS UI LIBRARY  v6.1  (SWILL STABLE)
-- LocalScript → StarterPlayerScripts
-- ==========================================================
local Players           = game:GetService("Players")
local TweenService      = game:GetService("TweenService")
local UserInputService  = game:GetService("UserInputService")
local RunService        = game:GetService("RunService")

local player    = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

local THEME = {
    IMAGE_ID   = "rbxassetid://118178862991877",
    ACCENT     = Color3.fromRGB(120, 170, 255),
    ACCENT2    = Color3.fromRGB(170, 120, 255),
    BG         = Color3.fromRGB(18, 18, 24),
    BG_SOFT    = Color3.fromRGB(28, 28, 36),
    BG_ROW     = Color3.fromRGB(35, 35, 45),
    TEXT       = Color3.fromRGB(240, 240, 255),
    TEXT_DIM   = Color3.fromRGB(180, 180, 200),
    TEXT_MUTE  = Color3.fromRGB(140, 140, 160),
    OK         = Color3.fromRGB(80, 220, 120),
    ERR        = Color3.fromRGB(255, 95, 86),
    WARN       = Color3.fromRGB(255, 189, 46),
    RADIUS     = UDim.new(0, 10),
    RADIUS_LG  = UDim.new(0, 14),
    RADIUS_PILL= UDim.new(1, 0),
    LOAD_TIME  = 1.5,
    TOGGLE_KEY = Enum.KeyCode.RightShift,
    WIN_W      = 660,
    WIN_H      = 440,
}
local ACCENT   = THEME.ACCENT
local IMAGE_ID = THEME.IMAGE_ID
local LOAD_TIME= THEME.LOAD_TIME
local TOGGLE_KEY = THEME.TOGGLE_KEY

-- ==========================================================
-- ХЕЛПЕРЫ
-- ==========================================================
local function new(class, props, parent)
    local o = Instance.new(class)
    for k, v in pairs(props or {}) do
        local ok = pcall(function() o[k] = v end)
        if not ok then warn("[CleanGlassUI] bad prop", k, "on", class) end
    end
    if parent then o.Parent = parent end
    return o
end
local function corner(parent, radius)
    return new("UICorner", {CornerRadius = radius or THEME.RADIUS}, parent)
end
local function stroke(parent, color, transparency)
    -- БЕЗ ApplyStrokeMode = Border — иначе конфликт с ClipsDescendants
    return new("UIStroke", {
        Color = color or Color3.fromRGB(255,255,255),
        Transparency = transparency or 0.85,
    }, parent)
end
local function tween(obj, time, props, style, dir)
    if not obj or not obj.Parent then return nil end
    local ok, t = pcall(function()
        return TweenService:Create(obj,
            TweenInfo.new(time, style or Enum.EasingStyle.Quart, dir or Enum.EasingDirection.Out),
            props)
    end)
    if ok and t then t:Play(); return t end
    return nil
end
local function safeCall(cb, ...)
    if type(cb) ~= "function" then return end
    local ok, err = pcall(cb, ...)
    if not ok then
        warn("[CleanGlassUI] callback error:", err)
        if _G.UILibrary and _G.UILibrary.NotifyError then
            pcall(function() _G.UILibrary:NotifyError("Ошибка", tostring(err)) end)
        end
    end
end

-- ==========================================================
-- ROOT GUI
-- ==========================================================
local ScreenGui = new("ScreenGui", {
    Name = "CleanGlassUI",
    ResetOnSpawn = false,
    IgnoreGuiInset = true,
    ZIndexBehavior = Enum.ZIndexBehavior.Sibling,
    DisplayOrder = 999,
}, playerGui)

local NotifGui = new("ScreenGui", {
    Name = "CleanGlassUINotifications",
    ResetOnSpawn = false,
    IgnoreGuiInset = true,
    DisplayOrder = 1000,
}, playerGui)

local NotificationHolder = new("Frame", {
    Size = UDim2.new(0, 340, 1, -20),
    Position = UDim2.new(1, -360, 0, 20),
    BackgroundTransparency = 1,
}, NotifGui)
new("UIListLayout", {
    SortOrder = Enum.SortOrder.LayoutOrder,
    Padding = UDim.new(0, 10),
    HorizontalAlignment = Enum.HorizontalAlignment.Right,
}, NotificationHolder)

-- ==========================================================
-- УВЕДОМЛЕНИЯ
-- ==========================================================
local UILibrary = {}
_G.UILibrary = UILibrary

local notifCounter = 0
function UILibrary:Notify(cfg)
    cfg = cfg or {}
    local title    = cfg.Title or "Уведомление"
    local text     = cfg.Text or ""
    local duration = cfg.Duration or 4
    local icon     = cfg.Icon or IMAGE_ID
    local accent   = cfg.Color or ACCENT

    notifCounter += 1
    local N = new("Frame", {
        Size = UDim2.new(0.85, 0, 0, 78),
        BackgroundColor3 = THEME.BG,
        BackgroundTransparency = 1,
        BorderSizePixel = 0,
        LayoutOrder = notifCounter,
        ClipsDescendants = true,
    }, NotificationHolder)
    corner(N, THEME.RADIUS)
    stroke(N, accent, 0.55)

    local Accent = new("Frame", {
        Size = UDim2.new(0, 4, 1, -16),
        Position = UDim2.new(0, 8, 0, 8),
        BackgroundColor3 = accent,
        BackgroundTransparency = 1,
        BorderSizePixel = 0,
    }, N)
    corner(Accent, THEME.RADIUS_PILL)

    local Icon = new("ImageLabel", {
        Image = icon,
        Size = UDim2.new(0, 44, 0, 44),
        Position = UDim2.new(0, 20, 0.5, -22),
        BackgroundTransparency = 1,
        ImageTransparency = 1,
    }, N)
    corner(Icon, UDim.new(0, 8))

    local T = new("TextLabel", {
        Text = title,
        Size = UDim2.new(1, -84, 0, 20),
        Position = UDim2.new(0, 74, 0, 14),
        BackgroundTransparency = 1,
        TextColor3 = THEME.TEXT,
        TextSize = 14, Font = Enum.Font.GothamBold,
        TextXAlignment = Enum.TextXAlignment.Left,
        TextTransparency = 1,
    }, N)
    local X = new("TextLabel", {
        Text = text,
        Size = UDim2.new(1, -84, 0, 18),
        Position = UDim2.new(0, 74, 0, 36),
        BackgroundTransparency = 1,
        TextColor3 = THEME.TEXT_DIM,
        TextSize = 12, Font = Enum.Font.Gotham,
        TextXAlignment = Enum.TextXAlignment.Left,
        TextTransparency = 1,
    }, N)

    local P = new("Frame", {
        Size = UDim2.new(1, -16, 0, 2),
        Position = UDim2.new(0, 8, 1, -6),
        BackgroundColor3 = accent,
        BackgroundTransparency = 1,
        BorderSizePixel = 0,
    }, N)
    corner(P, THEME.RADIUS_PILL)

    local aI = TweenInfo.new(0.35, Enum.EasingStyle.Quart, Enum.EasingDirection.Out)
    pcall(function()
        TweenService:Create(N, aI, {BackgroundTransparency = 0.1, Size = UDim2.new(1,0,0,78)}):Play()
        TweenService:Create(T, aI, {TextTransparency = 0}):Play()
        TweenService:Create(X, aI, {TextTransparency = 0}):Play()
        TweenService:Create(Accent, aI, {BackgroundTransparency = 0}):Play()
        TweenService:Create(P, aI, {BackgroundTransparency = 0}):Play()
        TweenService:Create(Icon, aI, {ImageTransparency = 0}):Play()
        TweenService:Create(P, TweenInfo.new(duration, Enum.EasingStyle.Linear), {Size = UDim2.new(0,0,0,2)}):Play()
    end)

    task.delay(duration, function()
        if not N or not N.Parent then return end
        pcall(function()
            local oI = TweenInfo.new(0.35, Enum.EasingStyle.Quart, Enum.EasingDirection.In)
            TweenService:Create(N, oI, {BackgroundTransparency = 1, Size = UDim2.new(0,0,0,78)}):Play()
            TweenService:Create(T, oI, {TextTransparency = 1}):Play()
            TweenService:Create(X, oI, {TextTransparency = 1}):Play()
            TweenService:Create(Accent, oI, {BackgroundTransparency = 1}):Play()
            TweenService:Create(P, oI, {BackgroundTransparency = 1}):Play()
            TweenService:Create(Icon, oI, {ImageTransparency = 1}):Play()
        end)
        task.wait(0.4)
        if N then N:Destroy() end
    end)
end
function UILibrary:NotifySuccess(t,x) self:Notify({Title=t,Text=x,Color=THEME.OK}) end
function UILibrary:NotifyError(t,x)   self:Notify({Title=t,Text=x,Color=THEME.ERR}) end
function UILibrary:NotifyInfo(t,x)    self:Notify({Title=t,Text=x,Color=ACCENT}) end
function UILibrary:NotifyWarning(t,x) self:Notify({Title=t,Text=x,Color=THEME.WARN}) end

-- ==========================================================
-- ДИСПЕТЧЕР ВВОДА С ОТПИСКОЙ
-- ==========================================================
local InputDispatcher = { _changed = {}, _ended = {}, _next = 0 }
local function dispatch(list, input)
    for _, cb in pairs(list) do pcall(cb, input) end
end
UserInputService.InputChanged:Connect(function(i) dispatch(InputDispatcher._changed, i) end)
UserInputService.InputEnded:Connect(function(i)  dispatch(InputDispatcher._ended,  i) end)

function InputDispatcher.OnChanged(cb)
    InputDispatcher._next += 1
    local id = InputDispatcher._next
    InputDispatcher._changed[id] = cb
    return id
end
function InputDispatcher.OnEnded(cb)
    InputDispatcher._next += 1
    local id = InputDispatcher._next
    InputDispatcher._ended[id] = cb
    return id
end
function InputDispatcher.Release(id)
    if id then
        InputDispatcher._changed[id] = nil
        InputDispatcher._ended[id]   = nil
    end
end

-- ==========================================================
-- ЭКРАН ЗАГРУЗКИ
-- ==========================================================
local Loading = new("Frame", {
    Size = UDim2.new(1,0,1,0),
    BackgroundColor3 = Color3.fromRGB(10,10,14),
    BackgroundTransparency = 0.05,
    BorderSizePixel = 0,
    ZIndex = 50,
}, ScreenGui)

local LImg = new("ImageLabel", {
    Image = IMAGE_ID,
    Size = UDim2.new(0,220,0,220),
    Position = UDim2.new(0.5,-110,0.5,-110),
    BackgroundTransparency = 1,
    ImageTransparency = 0.15,
    ZIndex = 51,
}, Loading)
corner(LImg, UDim.new(0,20))

local Orbit = new("Frame", {
    Size = UDim2.new(0,340,0,340),
    Position = UDim2.new(0.5,-170,0.5,-170),
    BackgroundTransparency = 1, ZIndex = 52,
}, Loading)

local Moon = new("ImageLabel", {
    Image = "rbxassetid://6031091004",
    Size = UDim2.new(0,40,0,40),
    BackgroundTransparency = 1, ZIndex = 53,
}, Orbit)
local Moon2 = new("ImageLabel", {
    Image = "rbxassetid://6031091004",
    Size = UDim2.new(0,22,0,22),
    BackgroundTransparency = 1, ZIndex = 53,
    ImageTransparency = 0.3,
}, Orbit)

local moonA, moonA2 = 0, 0
local moonConn = RunService.RenderStepped:Connect(function(dt)
    moonA  += dt * 2
    moonA2 += dt * 3
    local r = 170
    Moon.Position  = UDim2.new(0.5, math.cos(moonA)*r  - 20, 0.5, math.sin(moonA)*r  - 20)
    Moon2.Position = UDim2.new(0.5, math.cos(moonA2)*r*0.7 - 11, 0.5, math.sin(moonA2)*r*0.7 - 11)
end)
local pulse = TweenService:Create(LImg,
    TweenInfo.new(1.2, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut, -1, true),
    {Size = UDim2.new(0,240,0,240), Position = UDim2.new(0.5,-120,0.5,-120)})
pulse:Play()

-- ==========================================================
-- MAIN WINDOW
-- ==========================================================
local origSize = UDim2.new(0, THEME.WIN_W, 0, THEME.WIN_H)
local origPos  = UDim2.new(0.5, -THEME.WIN_W/2, 0.5, -THEME.WIN_H/2)

local Main = new("Frame", {
    Name = "Main",
    Size = origSize,
    Position = origPos,
    BackgroundColor3 = THEME.BG,
    BackgroundTransparency = 0.1,
    BorderSizePixel = 0,
    ClipsDescendants = true,
    Visible = false,
    ZIndex = 5,
}, ScreenGui)
corner(Main, THEME.RADIUS_LG)
stroke(Main, Color3.fromRGB(255,255,255), 0.82)

local Shadow2 = new("ImageLabel", {
    Image = "rbxassetid://1316045217",
    ImageColor3 = Color3.fromRGB(0,0,0),
    ImageTransparency = 0.55,
    ScaleType = Enum.ScaleType.Slice,
    SliceCenter = Rect.new(10,10,118,118),
    Size = UDim2.new(1,100,1,100),
    Position = UDim2.new(0,-50,0,-50),
    BackgroundTransparency = 1, ZIndex = 0,
}, Main)
local Shadow = new("ImageLabel", {
    Image = "rbxassetid://1316045217",
    ImageColor3 = Color3.fromRGB(0,0,0),
    ImageTransparency = 0.35,
    ScaleType = Enum.ScaleType.Slice,
    SliceCenter = Rect.new(10,10,118,118),
    Size = UDim2.new(1,60,1,60),
    Position = UDim2.new(0,-30,0,-30),
    BackgroundTransparency = 1, ZIndex = 0,
}, Main)

local AccentBar = new("Frame", {
    Size = UDim2.new(1, 0, 0, 2),
    Position = UDim2.new(0, 0, 0, 0),
    BackgroundColor3 = ACCENT,
    BackgroundTransparency = 0.25,
    BorderSizePixel = 0,
    ZIndex = 9,
}, Main)
corner(AccentBar, UDim.new(0, 2))
new("UIGradient", {
    Color = ColorSequence.new{
        ColorSequenceKeypoint.new(0, ACCENT),
        ColorSequenceKeypoint.new(0.5, THEME.ACCENT2),
        ColorSequenceKeypoint.new(1, ACCENT),
    },
}, AccentBar)

local TopBar = new("Frame", {
    Name = "TopBar",
    Size = UDim2.new(1,0,0,50),
    BackgroundColor3 = THEME.BG_SOFT,
    BackgroundTransparency = 0.3,
    BorderSizePixel = 0,
    ZIndex = 10,
}, Main)
corner(TopBar, THEME.RADIUS_LG)

local Title = new("TextLabel", {
    Text = "UI Library",
    Size = UDim2.new(1,-220,1,0),
    Position = UDim2.new(0,20,0,0),
    BackgroundTransparency = 1,
    TextColor3 = THEME.TEXT,
    TextSize = 14, Font = Enum.Font.GothamBold,
    TextXAlignment = Enum.TextXAlignment.Left,
    ZIndex = 11,
}, TopBar)
function UILibrary:SetTitle(t) Title.Text = tostring(t) end

local function makeDot(xOff, color)
    local D = new("TextButton", {
        Text = "", AutoButtonColor = false,
        Size = UDim2.new(0,12,0,12),
        Position = UDim2.new(1, xOff, 0.5, -6),
        BackgroundColor3 = color, BorderSizePixel = 0,
        ZIndex = 12,
    }, TopBar)
    corner(D, THEME.RADIUS_PILL)
    return D
end
local RedB    = makeDot(-44, THEME.ERR)
local YellowB = makeDot(-64, THEME.WARN)
local GreenB  = makeDot(-84, THEME.OK)

local Sidebar = new("Frame", {
    Name = "Sidebar",
    Size = UDim2.new(0,180,1,-50),
    Position = UDim2.new(0,0,0,50),
    BackgroundColor3 = Color3.fromRGB(12,12,16),
    BackgroundTransparency = 0.25,
    BorderSizePixel = 0,
    ZIndex = 6,
}, Main)
corner(Sidebar, THEME.RADIUS_LG)

local Logo = new("ImageLabel", {
    Image = IMAGE_ID,
    Size = UDim2.new(0,36,0,36),
    Position = UDim2.new(0,18,0,14),
    BackgroundTransparency = 1, ZIndex = 7,
}, Sidebar)
corner(Logo, UDim.new(0,8))

-- ВАЖНО: БЕЗ AutomaticCanvasSize — ручной пересчёт
local TabScroll = new("ScrollingFrame", {
    Size = UDim2.new(1,-12,1,-72),
    Position = UDim2.new(0,12,0,64),
    BackgroundTransparency = 1,
    BorderSizePixel = 0,
    ScrollBarThickness = 2,
    ScrollBarImageColor3 = ACCENT,
    CanvasSize = UDim2.new(0,0,0,0),
    ZIndex = 7,
}, Sidebar)
local TabLayout = new("UIListLayout", {
    SortOrder = Enum.SortOrder.LayoutOrder,
    Padding = UDim.new(0,4),
}, TabScroll)
TabLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
    TabScroll.CanvasSize = UDim2.new(0,0,0, TabLayout.AbsoluteContentSize.Y + 8)
end)

local Content = new("Frame", {
    Name = "Content",
    Size = UDim2.new(1,-180,1,-50),
    Position = UDim2.new(0,180,0,50),
    BackgroundTransparency = 1,
    ZIndex = 6,
}, Main)

-- ==========================================================
-- ПЕРЕТАСКИВАНИЕ
-- ==========================================================
local dragging, dragStart, startPos = false, nil, nil
local curPos, tgtPos = Main.Position, Main.Position

InputDispatcher.OnChanged(function(i)
    if dragging and (i.UserInputType == Enum.UserInputType.MouseMovement or i.UserInputType == Enum.UserInputType.Touch) then
        local d = i.Position - dragStart
        tgtPos = UDim2.new(startPos.X.Scale, startPos.X.Offset + d.X, startPos.Y.Scale, startPos.Y.Offset + d.Y)
    end
end)
InputDispatcher.OnEnded(function(i)
    if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then
        dragging = false
    end
end)
RunService.RenderStepped:Connect(function(dt)
    if not Main.Visible then return end
    curPos = curPos:Lerp(tgtPos, math.min(dt*(dragging and 22 or 12),1))
    Main.Position = curPos
end)

TopBar.InputBegan:Connect(function(i)
    if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then
        if minimized then restore(); return end
        dragging  = true
        dragStart = i.Position
        startPos  = Main.Position
        tgtPos    = Main.Position
    end
end)

-- ==========================================================
-- СВЕРНУТЬ / РАЗВЕРНУТЬ / СКРЫТЬ
-- ==========================================================
local minimized = false
local minSize = UDim2.new(0, THEME.WIN_W, 0, 50)

local function minimize()
    if minimized then return end
    minimized = true
    Sidebar.Visible = false
    Content.Visible = false
    tween(Main, 0.35, {Size = minSize})
end
local function restore()
    if not minimized then return end
    minimized = false
    tween(Main, 0.35, {Size = origSize})
    task.wait(0.15)
    Sidebar.Visible = true
    Content.Visible = true
end

YellowB.MouseButton1Click:Connect(function() if minimized then restore() else minimize() end end)

local hiddenIcon = new("TextButton", {
    Name = "HiddenIcon",
    Text = "", AutoButtonColor = false,
    Size = UDim2.new(0,44,0,44),
    Position = UDim2.new(1,-60,0,20),
    BackgroundColor3 = Color3.fromRGB(25,25,32),
    BackgroundTransparency = 0.1,
    Visible = false, ZIndex = 500,
}, ScreenGui)
corner(hiddenIcon, THEME.RADIUS_PILL)
stroke(hiddenIcon, ACCENT, 0.4)
local HIcon = new("ImageLabel", {
    Image = IMAGE_ID,
    Size = UDim2.new(0,30,0,30),
    Position = UDim2.new(0.5,-15,0.5,-15),
    BackgroundTransparency = 1, ZIndex = 501,
}, hiddenIcon)

local windowHidden = false
local function hideWindow()
    if windowHidden then return end
    windowHidden = true
    local t = tween(Main, 0.25,
        {Size = UDim2.new(0,0,0,0), BackgroundTransparency = 1},
        Enum.EasingStyle.Quart, Enum.EasingDirection.In)
    if t then
        t.Completed:Connect(function()
            Main.Visible = false
            hiddenIcon.Visible = true
        end)
    else
        Main.Visible = false
        hiddenIcon.Visible = true
    end
end
local function showWindow()
    if not windowHidden then return end
    windowHidden = false
    hiddenIcon.Visible = false
    Main.Visible = true
    minimized = false
    Sidebar.Visible = true
    Content.Visible = true
    Main.Size = UDim2.new(0,0,0,THEME.WIN_H)
    Main.Position = UDim2.new(0.5,0,0.5,-THEME.WIN_H/2)
    curPos, tgtPos = Main.Position, origPos
    tween(Main, 0.35, {Size = origSize, Position = origPos, BackgroundTransparency = 0.1},
        Enum.EasingStyle.Back, Enum.EasingDirection.Out)
end
RedB.MouseButton1Click:Connect(hideWindow)
hiddenIcon.MouseButton1Click:Connect(showWindow)

UserInputService.InputBegan:Connect(function(input, processed)
    if processed then return end
    if input.KeyCode == TOGGLE_KEY then
        if windowHidden then showWindow() else hideWindow() end
    end
end)
GreenB.MouseButton1Click:Connect(function() UILibrary:NotifySuccess("OK","") end)

-- ==========================================================
-- ВКЛАДКИ
-- ==========================================================
local Tabs = {}
local activeTab = nil
local tabOrder = 0
local DROPDOWN_CLOSERS = {}

local function closeAllDropdowns()
    for i = #DROPDOWN_CLOSERS, 1, -1 do
        local f = DROPDOWN_CLOSERS[i]
        if f then pcall(f) end
    end
end
UserInputService.InputBegan:Connect(function(i, processed)
    if processed then return end
    if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then
        closeAllDropdowns()
    end
end)

function UILibrary:Tab(name)
    tabOrder += 1
    local Tab = {Name = name, Order = tabOrder, Buttons = {}, _order = 0}

    local Btn = new("TextButton", {
        Text = "", AutoButtonColor = false,
        Size = UDim2.new(1,0,0,36),
        BackgroundColor3 = Color3.fromRGB(255,255,255),
        BackgroundTransparency = 1, BorderSizePixel = 0,
        LayoutOrder = tabOrder, ZIndex = 8,
    }, TabScroll)
    corner(Btn, UDim.new(0, 7))

    local Icon = new("Frame", {
        Size = UDim2.new(0,16,0,16),
        Position = UDim2.new(0,10,0.5,-8),
        BackgroundColor3 = Color3.fromRGB(255,255,255),
        BackgroundTransparency = 0.55, BorderSizePixel = 0, ZIndex = 9,
    }, Btn)
    corner(Icon, UDim.new(0,4))

    local Lbl = new("TextLabel", {
        Text = name,
        Size = UDim2.new(1,-36,1,0),
        Position = UDim2.new(0,36,0,0),
        BackgroundTransparency = 1,
        TextColor3 = THEME.TEXT_DIM,
        TextSize = 12, Font = Enum.Font.GothamMedium,
        TextXAlignment = Enum.TextXAlignment.Left, ZIndex = 9,
    }, Btn)

    local Page = new("ScrollingFrame", {
        Name = "Page_" .. name,
        Size = UDim2.new(1,-24,1,-24),
        Position = UDim2.new(0,12,0,12),
        BackgroundTransparency = 1, BorderSizePixel = 0,
        ScrollBarThickness = 3,
        ScrollBarImageColor3 = ACCENT,
        CanvasSize = UDim2.new(0,0,0,0),
        Visible = false, ZIndex = 7,
    }, Content)
    local PL = new("UIListLayout", {
        SortOrder = Enum.SortOrder.LayoutOrder,
        Padding = UDim.new(0,8),
    }, Page)
    new("UIPadding", {PaddingRight = UDim.new(0,8)}, Page)

    -- Ручной пересчёт canvas (без AutomaticCanvasSize)
    local function refreshCanvas()
        if not Page or not Page.Parent then return end
        Page.CanvasSize = UDim2.new(0,0,0, PL.AbsoluteContentSize.Y + 20)
    end
    PL:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(refreshCanvas)
    task.defer(refreshCanvas)

    Tab.Page = Page
    Tab.Btn  = Btn
    Tab.Refresh = refreshCanvas

    local function push(el)
        Tab._order += 1
        el.LayoutOrder = Tab._order
        table.insert(Tab.Buttons, el)
        task.defer(refreshCanvas)
        return el
    end

    local function activate()
        if activeTab == Tab then return end
        closeAllDropdowns()
        if activeTab then
            activeTab.Page.Visible = false
            tween(activeTab.Btn, 0.15, {BackgroundTransparency = 1})
        end
        activeTab = Tab
        Tab.Page.Visible = true
        tween(Btn, 0.15, {BackgroundTransparency = 0.85})
        task.defer(refreshCanvas)
    end
    Tab.Activate = activate

    Btn.MouseEnter:Connect(function()
        if activeTab ~= Tab then tween(Btn, 0.15, {BackgroundTransparency = 0.92}) end
    end)
    Btn.MouseLeave:Connect(function()
        if activeTab ~= Tab then tween(Btn, 0.15, {BackgroundTransparency = 1}) end
    end)
    Btn.MouseButton1Click:Connect(activate)

    Tabs[name] = Tab
    if tabOrder == 1 then activate() end

    function Tab:Section(text)
        local S = new("TextLabel", {
            Text = text, Size = UDim2.new(1,0,0,24),
            BackgroundTransparency = 1,
            TextColor3 = THEME.TEXT_MUTE,
            TextSize = 11, Font = Enum.Font.GothamBold,
            TextXAlignment = Enum.TextXAlignment.Left,
        }, Page)
        push(S); return S
    end
    function Tab:Label(text)
        local L = new("TextLabel", {
            Text = text, Size = UDim2.new(1,0,0,20),
            BackgroundTransparency = 1,
            TextColor3 = THEME.TEXT,
            TextSize = 12, Font = Enum.Font.Gotham,
            TextXAlignment = Enum.TextXAlignment.Left,
        }, Page)
        push(L); return L
    end
    function Tab:Button(cfg)
        cfg = cfg or {}
        local B = new("TextButton", {
            Text = "", AutoButtonColor = false,
            Size = UDim2.new(1,0,0,38),
            BackgroundColor3 = THEME.BG_ROW,
            BackgroundTransparency = 0.2,
            BorderSizePixel = 0, ClipsDescendants = true,
        }, Page)
        corner(B, UDim.new(0,7))
        local BS = stroke(B, Color3.fromRGB(255,255,255), 0.85)
        new("TextLabel", {
            Text = cfg.Text or "Кнопка",
            Size = UDim2.new(1,-20,1,0), Position = UDim2.new(0,12,0,0),
            BackgroundTransparency = 1, TextColor3 = THEME.TEXT,
            TextSize = 13, Font = Enum.Font.GothamMedium,
            TextXAlignment = Enum.TextXAlignment.Left,
        }, B)

        -- ripple с ограничением (не более 3 одновременно)
        local ripples = 0
        local function ripple()
            if ripples >= 3 then return end
            ripples += 1
            local R = new("Frame", {
                Size = UDim2.new(0,0,0,0),
                Position = UDim2.new(0.5,0,0.5,0),
                AnchorPoint = Vector2.new(0.5,0.5),
                BackgroundColor3 = ACCENT, BackgroundTransparency = 0.4,
                BorderSizePixel = 0, ZIndex = 2,
            }, B)
            corner(R, THEME.RADIUS_PILL)
            local maxD = math.max(B.AbsoluteSize.X, B.AbsoluteSize.Y) * 1.5
            local t = tween(R, 0.45, {
                Size = UDim2.new(0,maxD,0,maxD),
                BackgroundTransparency = 1,
            })
            if t then
                t.Completed:Connect(function()
                    ripples -= 1
                    if R then R:Destroy() end
                end)
            else
                ripples -= 1
                R:Destroy()
            end
        end
        B.MouseEnter:Connect(function()
            tween(B, 0.15, {BackgroundTransparency = 0.05})
            tween(BS, 0.15, {Transparency = 0.55, Color = ACCENT})
        end)
        B.MouseLeave:Connect(function()
            tween(B, 0.15, {BackgroundTransparency = 0.2})
            tween(BS, 0.15, {Transparency = 0.85, Color = Color3.fromRGB(255,255,255)})
        end)
        B.MouseButton1Click:Connect(function()
            ripple()
            safeCall(cfg.Callback)
        end)
        push(B); return B
    end
    function Tab:Toggle(cfg)
        cfg = cfg or {}
        local state = cfg.Default or false
        local Row = new("Frame", {
            Size = UDim2.new(1,0,0,38),
            BackgroundColor3 = THEME.BG_ROW,
            BackgroundTransparency = 0.2,
            BorderSizePixel = 0,
        }, Page)
        corner(Row, UDim.new(0,7))
        stroke(Row, Color3.fromRGB(255,255,255), 0.85)
        new("TextLabel", {
            Text = cfg.Text or "Тоггл",
            Size = UDim2.new(1,-70,1,0), Position = UDim2.new(0,12,0,0),
            BackgroundTransparency = 1, TextColor3 = THEME.TEXT,
            TextSize = 13, Font = Enum.Font.GothamMedium,
            TextXAlignment = Enum.TextXAlignment.Left,
        }, Row)
        local Switch = new("TextButton", {
            Text = "", AutoButtonColor = false,
            Size = UDim2.new(0,44,0,22),
            Position = UDim2.new(1,-56,0.5,-11),
            BackgroundColor3 = state and ACCENT or Color3.fromRGB(60,60,75),
            BorderSizePixel = 0,
        }, Row)
        corner(Switch, THEME.RADIUS_PILL)
        local Knob = new("Frame", {
            Size = UDim2.new(0,16,0,16),
            Position = state and UDim2.new(1,-20,0.5,-8) or UDim2.new(0,4,0.5,-8),
            BackgroundColor3 = Color3.fromRGB(255,255,255),
            BorderSizePixel = 0,
        }, Switch)
        corner(Knob, THEME.RADIUS_PILL)

        local function setState(v)
            state = v
            tween(Switch, 0.22, {BackgroundColor3 = state and ACCENT or Color3.fromRGB(60,60,75)})
            tween(Knob, 0.28,
                {Position = state and UDim2.new(1,-20,0.5,-8) or UDim2.new(0,4,0.5,-8)},
                Enum.EasingStyle.Back, Enum.EasingDirection.Out)
            safeCall(cfg.Callback, state)
        end
        Switch.MouseButton1Click:Connect(function() setState(not state) end)
        push(Row)
        return {Set = setState, Get = function() return state end, Instance = Row}
    end
    function Tab:Slider(cfg)
        cfg = cfg or {}
        local min, max = cfg.Min or 0, cfg.Max or 100
        local value = math.clamp(cfg.Default or min, min, max)
        local suffix = cfg.Suffix or ""
        local Row = new("Frame", {
            Size = UDim2.new(1,0,0,54),
            BackgroundColor3 = THEME.BG_ROW,
            BackgroundTransparency = 0.2,
            BorderSizePixel = 0,
        }, Page)
        corner(Row, UDim.new(0,7))
        stroke(Row, Color3.fromRGB(255,255,255), 0.85)
        new("TextLabel", {
            Text = cfg.Text or "Слайдер",
            Size = UDim2.new(1,-70,0,20), Position = UDim2.new(0,12,0,6),
            BackgroundTransparency = 1, TextColor3 = THEME.TEXT,
            TextSize = 12, Font = Enum.Font.GothamMedium,
            TextXAlignment = Enum.TextXAlignment.Left,
        }, Row)
        local V = new("TextLabel", {
            Text = tostring(value)..suffix,
            Size = UDim2.new(0,70,0,20), Position = UDim2.new(1,-82,0,6),
            BackgroundTransparency = 1, TextColor3 = ACCENT,
            TextSize = 12, Font = Enum.Font.GothamBold,
            TextXAlignment = Enum.TextXAlignment.Right,
        }, Row)
        local Bar = new("Frame", {
            Size = UDim2.new(1,-24,0,6), Position = UDim2.new(0,12,0,34),
            BackgroundColor3 = Color3.fromRGB(60,60,75),
            BorderSizePixel = 0,
        }, Row)
        corner(Bar, THEME.RADIUS_PILL)
        local Fill = new("Frame", {
            Size = UDim2.new((value-min)/(max-min),0,1,0),
            BackgroundColor3 = ACCENT, BorderSizePixel = 0,
        }, Bar)
        corner(Fill, THEME.RADIUS_PILL)

        local sliderDragging = false
        local function setFromX(x)
            local rel = math.clamp((x - Bar.AbsolutePosition.X) / Bar.AbsoluteSize.X, 0, 1)
            value = math.floor(min + (max-min)*rel + 0.5)
            V.Text = tostring(value)..suffix
            tween(Fill, 0.08, {Size = UDim2.new((value-min)/(max-min),0,1,0)})
            safeCall(cfg.Callback, value)
        end
        Bar.InputBegan:Connect(function(i)
            if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then
                sliderDragging = true
                setFromX(i.Position.X)
            end
        end)
        local id1 = InputDispatcher.OnChanged(function(i)
            if sliderDragging and (i.UserInputType == Enum.UserInputType.MouseMovement or i.UserInputType == Enum.UserInputType.Touch) then
                setFromX(i.Position.X)
            end
        end)
        local id2 = InputDispatcher.OnEnded(function(i)
            if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then
                sliderDragging = false
            end
        end)
        Row.Destroying:Connect(function()
            InputDispatcher.Release(id1)
            InputDispatcher.Release(id2)
        end)
        push(Row)
        return {
            Set = function(v)
                v = math.clamp(v,min,max)
                value = v
                V.Text = tostring(v)..suffix
                tween(Fill, 0.1, {Size = UDim2.new((v-min)/(max-min),0,1,0)})
            end,
            Get = function() return value end,
            Instance = Row,
        }
    end
    function Tab:Textbox(cfg)
        cfg = cfg or {}
        local Row = new("Frame", {
            Size = UDim2.new(1,0,0,38),
            BackgroundColor3 = THEME.BG_ROW,
            BackgroundTransparency = 0.2,
            BorderSizePixel = 0,
        }, Page)
        corner(Row, UDim.new(0,7))
        local RS = stroke(Row, Color3.fromRGB(255,255,255), 0.85)
        local TB = new("TextBox", {
            Text = cfg.Default or "",
            PlaceholderText = cfg.Placeholder or "",
            Size = UDim2.new(1,-24,1,0), Position = UDim2.new(0,12,0,0),
            BackgroundTransparency = 1, TextColor3 = THEME.TEXT,
            PlaceholderColor3 = THEME.TEXT_MUTE,
            TextSize = 13, Font = Enum.Font.GothamMedium,
            TextXAlignment = Enum.TextXAlignment.Left,
            ClearTextOnFocus = false,
        }, Row)
        TB.Focused:Connect(function()  tween(RS, 0.15, {Transparency = 0.4, Color = ACCENT}) end)
        TB.FocusLost:Connect(function()
            tween(RS, 0.15, {Transparency = 0.85, Color = Color3.fromRGB(255,255,255)})
            safeCall(cfg.Callback, TB.Text)
        end)
        push(Row)
        return {Get = function() return TB.Text end, Set = function(v) TB.Text = v end, Instance = Row}
    end
    function Tab:Dropdown(cfg)
        cfg = cfg or {}
        local options = cfg.Options or {}
        local selected = cfg.Default or (options[1] or "")
        local baseH = 38

        local Row = new("Frame", {
            Size = UDim2.new(1,0,0,baseH),
            BackgroundColor3 = THEME.BG_ROW,
            BackgroundTransparency = 0.2,
            BorderSizePixel = 0,
            ClipsDescendants = true,
            ZIndex = 10,
        }, Page)
        corner(Row, UDim.new(0,7))
        stroke(Row, Color3.fromRGB(255,255,255), 0.85)

        local Head = new("TextButton", {
            Text = "", AutoButtonColor = false,
            Size = UDim2.new(1,0,0,baseH),
            BackgroundTransparency = 1, ZIndex = 11,
        }, Row)

        new("TextLabel", {
            Text = cfg.Text or "",
            Size = UDim2.new(0.5,-12,1,0), Position = UDim2.new(0,12,0,0),
            BackgroundTransparency = 1, TextColor3 = THEME.TEXT,
            TextSize = 13, Font = Enum.Font.GothamMedium,
            TextXAlignment = Enum.TextXAlignment.Left, ZIndex = 12,
        }, Head)

        local ValLbl = new("TextLabel", {
            Text = selected,
            Size = UDim2.new(0.5,-28,1,0), Position = UDim2.new(0.5,0,0,0),
            BackgroundTransparency = 1, TextColor3 = ACCENT,
            TextSize = 13, Font = Enum.Font.GothamBold,
            TextXAlignment = Enum.TextXAlignment.Right, ZIndex = 12,
        }, Head)

        new("TextLabel", {
            Text = "▾",
            Size = UDim2.new(0,20,0,baseH), Position = UDim2.new(1,-24,0,0),
            BackgroundTransparency = 1, TextColor3 = THEME.TEXT_DIM,
            TextSize = 12, ZIndex = 12,
        }, Head)

        local opened = false
        local optionButtons = {}

        local function destroyOptions()
            for _, b in pairs(optionButtons) do
                if b then b:Destroy() end
            end
            optionButtons = {}
        end

        local function rebuild()
            destroyOptions()
            for i, opt in ipairs(options) do
                local OB = new("TextButton", {
                    Text = "", AutoButtonColor = false,
                    Size = UDim2.new(1,0,0,28),
                    Position = UDim2.new(0,0,0,baseH + (i-1)*28),
                    BackgroundColor3 = Color3.fromRGB(45,45,58),
                    BackgroundTransparency = 0.3, BorderSizePixel = 0,
                    ZIndex = 11,
                }, Row)
                new("TextLabel", {
                    Text = opt,
                    Size = UDim2.new(1,-24,1,0), Position = UDim2.new(0,12,0,0),
                    BackgroundTransparency = 1,
                    TextColor3 = (opt == selected) and ACCENT or THEME.TEXT_DIM,
                    TextSize = 12, Font = Enum.Font.Gotham,
                    TextXAlignment = Enum.TextXAlignment.Left, ZIndex = 12,
                }, OB)
                OB.MouseEnter:Connect(function() tween(OB, 0.12, {BackgroundTransparency = 0.05}) end)
                OB.MouseLeave:Connect(function() tween(OB, 0.12, {BackgroundTransparency = 0.3}) end)
                OB.MouseButton1Click:Connect(function()
                    selected = opt
                    ValLbl.Text = opt
                    safeCall(cfg.Callback, opt)
                    opened = false
                    destroyOptions()
                    tween(Row, 0.2, {Size = UDim2.new(1,0,0,baseH)})
                end)
                table.insert(optionButtons, OB)
            end
        end

        local function close()
            if not opened then return end
            opened = false
            destroyOptions()
            tween(Row, 0.2, {Size = UDim2.new(1,0,0,baseH)})
        end
        table.insert(DROPDOWN_CLOSERS, close)

        Head.MouseButton1Click:Connect(function()
            if opened then close(); return end
            closeAllDropdowns()
            opened = true
            rebuild()
            local h = baseH + #options * 28
            tween(Row, 0.2, {Size = UDim2.new(1,0,0,h)}, Enum.EasingStyle.Quart)
        end)

        push(Row)
        return {
            Get = function() return selected end,
            Set = function(v)
                selected = v
                ValLbl.Text = tostring(v)
            end,
            Instance = Row,
        }
    end

    return Tab
end

function UILibrary:GetTab(name) return Tabs[name] end
function UILibrary:SelectTab(name) if Tabs[name] then Tabs[name].Activate() end end

-- ==========================================================
-- ПОЯВЛЕНИЕ + ДЕМО (защищено pcall)
-- ==========================================================
task.spawn(function()
    local ok, err = pcall(function()
        task.wait(LOAD_TIME)
        if moonConn then moonConn:Disconnect(); moonConn = nil end
        pulse:Cancel()
        tween(Loading, 0.6, {BackgroundTransparency = 1})
        tween(LImg, 0.6, {ImageTransparency = 1, Size = UDim2.new(0,0,0,0), Position = UDim2.new(0.5,0,0.5,0)})
        tween(Moon, 0.6, {ImageTransparency = 1, Size = UDim2.new(0,0,0,0)})
        tween(Moon2, 0.6, {ImageTransparency = 1, Size = UDim2.new(0,0,0,0)})
        task.wait(0.7)
        if Loading then Loading:Destroy() end

        Main.Visible = true
        Main.Size = UDim2.new(0,0,0,THEME.WIN_H)
        Main.Position = UDim2.new(0.5,0,0.5,-THEME.WIN_H/2)
        curPos, tgtPos = Main.Position, origPos
        tween(Main, 0.5, {Size = origSize, Position = origPos, BackgroundTransparency = 0.1},
            Enum.EasingStyle.Back, Enum.EasingDirection.Out)

        task.wait(0.6)
        UILibrary:NotifySuccess("UI Library v6.1", "RightShift — скрыть/показать")

        local main = UILibrary:Tab("Главная")
        main:Section("Примеры элементов")
        main:Button({Text = "Кнопка", Callback = function() UILibrary:NotifySuccess("Кнопка", "Нажата") end})
        main:Toggle({Text = "Тоггл", Default = true, Callback = function(v) print("Toggle →", v) end})
        main:Slider({Text = "Громкость", Min = 0, Max = 100, Default = 50, Suffix = "%", Callback = function(v) print("Slider →", v) end})
        main:Textbox({Placeholder = "Введите текст...", Callback = function(t) print("Textbox →", t) end})
        main:Dropdown({Text = "Выбор", Options = {"Опция 1", "Опция 2", "Опция 3"}, Default = "Опция 1", Callback = function(v) print("Dropdown →", v) end})
        main:Dropdown({Text = "Второй", Options = {"A", "B", "C"}, Default = "A"})

        local settings = UILibrary:Tab("Настройки")
        settings:Section("Прочее")
        settings:Toggle({Text = "Уведомления", Default = true})
        settings:Slider({Text = "Прозрачность", Min = 0, Max = 100, Default = 75})
        settings:Button({Text = "Сбросить", Callback = function() UILibrary:NotifyWarning("Сброс", "Настройки сброшены") end})
    end)
    if not ok then
        warn("[CleanGlassUI] CRASH PREVENTED:", err)
        if UILibrary and UILibrary.NotifyError then
            pcall(function() UILibrary:NotifyError("Ошибка загрузки", tostring(err)) end)
        end
    end
end)
