-- ==========================================================
-- CLEAN GLASS UI LIBRARY  v5
-- LocalScript → StarterPlayerScripts
-- ==========================================================
local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

local IMAGE_ID = "rbxassetid://118178862991877"
local ACCENT = Color3.fromRGB(120, 170, 255)
local LOAD_TIME = 1.5
local TOGGLE_KEY = Enum.KeyCode.RightShift

-- ==========================================================
-- ROOT GUI
-- ==========================================================
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "CleanGlassUI"
ScreenGui.ResetOnSpawn = false
ScreenGui.IgnoreGuiInset = true
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
ScreenGui.DisplayOrder = 999
ScreenGui.Parent = playerGui

local NotifGui = Instance.new("ScreenGui")
NotifGui.Name = "CleanGlassUINotifications"
NotifGui.ResetOnSpawn = false
NotifGui.IgnoreGuiInset = true
NotifGui.DisplayOrder = 1000
NotifGui.Parent = playerGui

local NotificationHolder = Instance.new("Frame")
NotificationHolder.Size = UDim2.new(0, 320, 1, -20)
NotificationHolder.Position = UDim2.new(1, -340, 0, 20)
NotificationHolder.BackgroundTransparency = 1
NotificationHolder.Parent = NotifGui

local HolderLayout = Instance.new("UIListLayout")
HolderLayout.SortOrder = Enum.SortOrder.LayoutOrder
HolderLayout.Padding = UDim.new(0, 10)
HolderLayout.Parent = NotificationHolder

-- ==========================================================
-- УВЕДОМЛЕНИЯ
-- ==========================================================
local UILibrary = {}
_G.UILibrary = UILibrary

local notifCounter = 0
function UILibrary:Notify(cfg)
    cfg = cfg or {}
    local title = cfg.Title or "Уведомление"
    local text = cfg.Text or ""
    local duration = cfg.Duration or 4
    local icon = cfg.Icon or IMAGE_ID
    local accent = cfg.Color or ACCENT

    notifCounter += 1
    local N = Instance.new("Frame")
    N.Size = UDim2.new(0.85, 0, 0, 74)
    N.BackgroundColor3 = Color3.fromRGB(18,18,24)
    N.BackgroundTransparency = 1
    N.BorderSizePixel = 0
    N.LayoutOrder = notifCounter
    N.Parent = NotificationHolder
    local NC = Instance.new("UICorner"); NC.CornerRadius = UDim.new(0,10); NC.Parent = N
    local NS = Instance.new("UIStroke"); NS.Color = accent; NS.Transparency = 0.5; NS.Parent = N

    local Accent = Instance.new("Frame")
    Accent.Size = UDim2.new(0, 4, 1, -16); Accent.Position = UDim2.new(0,8,0,8)
    Accent.BackgroundColor3 = accent; Accent.BackgroundTransparency = 1
    Accent.BorderSizePixel = 0; Accent.Parent = N
    local AC = Instance.new("UICorner"); AC.CornerRadius = UDim.new(1,0); AC.Parent = Accent

    local Icon = Instance.new("ImageLabel")
    Icon.Image = icon; Icon.Size = UDim2.new(0,44,0,44); Icon.Position = UDim2.new(0,20,0.5,-22)
    Icon.BackgroundTransparency = 1; Icon.ImageTransparency = 1; Icon.Parent = N
    local IC = Instance.new("UICorner"); IC.CornerRadius = UDim.new(0,8); IC.Parent = Icon

    local T = Instance.new("TextLabel")
    T.Text = title; T.Size = UDim2.new(1,-80,0,20); T.Position = UDim2.new(0,74,0,12)
    T.BackgroundTransparency = 1; T.TextColor3 = Color3.fromRGB(240,240,255)
    T.TextSize = 14; T.Font = Enum.Font.GothamBold; T.TextXAlignment = Enum.TextXAlignment.Left
    T.TextTransparency = 1; T.Parent = N

    local X = Instance.new("TextLabel")
    X.Text = text; X.Size = UDim2.new(1,-80,0,18); X.Position = UDim2.new(0,74,0,34)
    X.BackgroundTransparency = 1; X.TextColor3 = Color3.fromRGB(180,180,200)
    X.TextSize = 12; X.Font = Enum.Font.Gotham; X.TextXAlignment = Enum.TextXAlignment.Left
    X.TextTransparency = 1; X.Parent = N

    local P = Instance.new("Frame")
    P.Size = UDim2.new(1,-16,0,2); P.Position = UDim2.new(0,8,1,-6)
    P.BackgroundColor3 = accent; P.BackgroundTransparency = 1
    P.BorderSizePixel = 0; P.Parent = N
    local PC = Instance.new("UICorner"); PC.CornerRadius = UDim.new(1,0); PC.Parent = P

    local aI = TweenInfo.new(0.35, Enum.EasingStyle.Quart, Enum.EasingDirection.Out)
    TweenService:Create(N, aI, {BackgroundTransparency = 0.15, Size = UDim2.new(1,0,0,74)}):Play()
    TweenService:Create(T, aI, {TextTransparency = 0}):Play()
    TweenService:Create(X, aI, {TextTransparency = 0}):Play()
    TweenService:Create(Accent, aI, {BackgroundTransparency = 0}):Play()
    TweenService:Create(P, aI, {BackgroundTransparency = 0}):Play()
    TweenService:Create(Icon, aI, {ImageTransparency = 0}):Play()
    TweenService:Create(P, TweenInfo.new(duration, Enum.EasingStyle.Linear), {Size = UDim2.new(0,0,0,2)}):Play()

    task.delay(duration, function()
        local oI = TweenInfo.new(0.35, Enum.EasingStyle.Quart, Enum.EasingDirection.In)
        TweenService:Create(N, oI, {BackgroundTransparency = 1, Size = UDim2.new(0,0,0,74)}):Play()
        TweenService:Create(T, oI, {TextTransparency = 1}):Play()
        TweenService:Create(X, oI, {TextTransparency = 1}):Play()
        TweenService:Create(Accent, oI, {BackgroundTransparency = 1}):Play()
        TweenService:Create(P, oI, {BackgroundTransparency = 1}):Play()
        TweenService:Create(Icon, oI, {ImageTransparency = 1}):Play()
        task.wait(0.4); N:Destroy()
    end)
end
function UILibrary:NotifySuccess(t,x) self:Notify({Title=t,Text=x,Color=Color3.fromRGB(80,220,120)}) end
function UILibrary:NotifyError(t,x)   self:Notify({Title=t,Text=x,Color=Color3.fromRGB(255,95,86)}) end
function UILibrary:NotifyInfo(t,x)    self:Notify({Title=t,Text=x,Color=ACCENT}) end
function UILibrary:NotifyWarning(t,x) self:Notify({Title=t,Text=x,Color=Color3.fromRGB(255,189,46)}) end

-- ==========================================================
-- ГЛОБАЛЬНЫЙ ДИСПЕТЧЕР INPUT (фикс утечек InputChanged)
-- ==========================================================
local InputDispatcher = {
    _changed = {},   -- список коллбеков на InputChanged
    _ended = {},     -- список коллбеков на InputEnded
}
local function dispatchChanged(input) for _, cb in pairs(InputDispatcher._changed) do cb(input) end end
local function dispatchEnded(input) for _, cb in pairs(InputDispatcher._ended) do cb(input) end end
UserInputService.InputChanged:Connect(dispatchChanged)
UserInputService.InputEnded:Connect(dispatchEnded)

function InputDispatcher.OnChanged(cb) table.insert(InputDispatcher._changed, cb) end
function InputDispatcher.OnEnded(cb) table.insert(InputDispatcher._ended, cb) end

-- ==========================================================
-- ЗАГРУЗКА
-- ==========================================================
local Loading = Instance.new("Frame")
Loading.Size = UDim2.new(1,0,1,0)
Loading.BackgroundColor3 = Color3.fromRGB(10,10,14)
Loading.BackgroundTransparency = 0.1
Loading.BorderSizePixel = 0
Loading.ZIndex = 50
Loading.Parent = ScreenGui

local LImg = Instance.new("ImageLabel")
LImg.Image = IMAGE_ID
LImg.Size = UDim2.new(0,220,0,220)
LImg.Position = UDim2.new(0.5,-110,0.5,-110)
LImg.BackgroundTransparency = 1
LImg.ImageTransparency = 0.15
LImg.ZIndex = 51
LImg.Parent = Loading
local LImgC = Instance.new("UICorner"); LImgC.CornerRadius = UDim.new(0,20); LImgC.Parent = LImg

local Orbit = Instance.new("Frame")
Orbit.Size = UDim2.new(0,320,0,320)
Orbit.Position = UDim2.new(0.5,-160,0.5,-160)
Orbit.BackgroundTransparency = 1
Orbit.ZIndex = 52
Orbit.Parent = Loading

local Moon = Instance.new("ImageLabel")
Moon.Image = "rbxassetid://6031091004"
Moon.Size = UDim2.new(0,40,0,40)
Moon.BackgroundTransparency = 1
Moon.ZIndex = 53
Moon.Parent = Orbit

local moonA = 0
local moonConn = RunService.RenderStepped:Connect(function(dt)
    moonA += dt*2
    local r = 160
    Moon.Position = UDim2.new(0.5, math.cos(moonA)*r-20, 0.5, math.sin(moonA)*r-20)
end)
local pulse = TweenService:Create(LImg,
    TweenInfo.new(1.2, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut, -1, true),
    {Size = UDim2.new(0,240,0,240), Position = UDim2.new(0.5,-120,0.5,-120)})
pulse:Play()

-- ==========================================================
-- MAIN WINDOW
-- ==========================================================
local Main = Instance.new("Frame")
Main.Name = "Main"
Main.Size = UDim2.new(0,640,0,420)
Main.Position = UDim2.new(0.5,-320,0.5,-210)
Main.BackgroundColor3 = Color3.fromRGB(20,20,25)
Main.BackgroundTransparency = 1
Main.BorderSizePixel = 0
Main.ClipsDescendants = true
Main.Visible = false
Main.ZIndex = 5
Main.Parent = ScreenGui
local MC = Instance.new("UICorner"); MC.CornerRadius = UDim.new(0,14); MC.Parent = Main
local MS = Instance.new("UIStroke"); MS.Color = Color3.fromRGB(255,255,255); MS.Transparency = 0.85; MS.Parent = Main

local Shadow = Instance.new("ImageLabel")
Shadow.Image = "rbxassetid://1316045217"
Shadow.ImageColor3 = Color3.fromRGB(0,0,0)
Shadow.ImageTransparency = 0.35
Shadow.ScaleType = Enum.ScaleType.Slice
Shadow.SliceCenter = Rect.new(10,10,118,118)
Shadow.Size = UDim2.new(1,60,1,60)
Shadow.Position = UDim2.new(0,-30,0,-30)
Shadow.BackgroundTransparency = 1
Shadow.ZIndex = 0
Shadow.Parent = Main

-- TOPBAR
local TopBar = Instance.new("Frame")
TopBar.Name = "TopBar"
TopBar.Size = UDim2.new(1,0,0,48)
TopBar.BackgroundColor3 = Color3.fromRGB(30,30,38)
TopBar.BackgroundTransparency = 0.4
TopBar.BorderSizePixel = 0
TopBar.ZIndex = 10
TopBar.Parent = Main
local TBC = Instance.new("UICorner"); TBC.CornerRadius = UDim.new(0,14); TBC.Parent = TopBar

local Title = Instance.new("TextLabel")
Title.Text = "UI Library"
Title.Size = UDim2.new(1,-200,1,0)
Title.Position = UDim2.new(0,20,0,0)
Title.BackgroundTransparency = 1
Title.TextColor3 = Color3.fromRGB(240,240,255)
Title.TextSize = 14
Title.Font = Enum.Font.GothamBold
Title.TextXAlignment = Enum.TextXAlignment.Left
Title.ZIndex = 11
Title.Parent = TopBar

function UILibrary:SetTitle(t) Title.Text = tostring(t) end

local function makeDot(x, color)
    local D = Instance.new("TextButton")
    D.Text=""; D.AutoButtonColor=false
    D.Size = UDim2.new(0,12,0,12)
    D.Position = UDim2.new(1,x,0.5,-6)
    D.BackgroundColor3 = color
    D.BorderSizePixel = 0
    D.ZIndex = 12
    D.Parent = TopBar
    local C = Instance.new("UICorner"); C.CornerRadius = UDim.new(1,0); C.Parent = D
    return D
end
local RedB    = makeDot(-44, Color3.fromRGB(255,95,86))
local YellowB = makeDot(-64, Color3.fromRGB(255,189,46))
local GreenB  = makeDot(-84, Color3.fromRGB(39,201,63))

-- SIDEBAR
local Sidebar = Instance.new("Frame")
Sidebar.Name = "Sidebar"
Sidebar.Size = UDim2.new(0,170,1,-48)
Sidebar.Position = UDim2.new(0,0,0,48)
Sidebar.BackgroundColor3 = Color3.fromRGB(12,12,16)
Sidebar.BackgroundTransparency = 0.35
Sidebar.BorderSizePixel = 0
Sidebar.ZIndex = 6
Sidebar.Parent = Main
local SC = Instance.new("UICorner"); SC.CornerRadius = UDim.new(0,14); SC.Parent = Sidebar

local Logo = Instance.new("ImageLabel")
Logo.Image = IMAGE_ID
Logo.Size = UDim2.new(0,36,0,36)
Logo.Position = UDim2.new(0,18,0,18)
Logo.BackgroundTransparency = 1
Logo.ZIndex = 7
Logo.Parent = Sidebar
local LC = Instance.new("UICorner"); LC.CornerRadius = UDim.new(0,8); LC.Parent = Logo

local TabScroll = Instance.new("ScrollingFrame")
TabScroll.Size = UDim2.new(1,-12,1,-80)
TabScroll.Position = UDim2.new(0,12,0,72)
TabScroll.BackgroundTransparency = 1
TabScroll.BorderSizePixel = 0
TabScroll.ScrollBarThickness = 2
TabScroll.ScrollBarImageColor3 = ACCENT
TabScroll.CanvasSize = UDim2.new(0,0,0,0)
TabScroll.ZIndex = 7
TabScroll.Parent = Sidebar
local TabLayout = Instance.new("UIListLayout")
TabLayout.SortOrder = Enum.SortOrder.LayoutOrder
TabLayout.Padding = UDim.new(0,4)
TabLayout.Parent = TabScroll

-- CONTENT
local Content = Instance.new("Frame")
Content.Name = "Content"
Content.Size = UDim2.new(1,-170,1,-48)
Content.Position = UDim2.new(0,170,0,48)
Content.BackgroundTransparency = 1
Content.ZIndex = 6
Content.Parent = Main

-- ==========================================================
-- ПЕРЕТАСКИВАНИЕ (единый InputChanged)
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
    curPos = curPos:Lerp(tgtPos, math.min(dt*(dragging and 20 or 12),1))
    Main.Position = curPos
end)

-- ==========================================================
-- СВЁРНУТЬ / РАЗВЕРНУТЬ
-- ==========================================================
local minimized = false
local origSize = UDim2.new(0,640,0,420)
local minSize = UDim2.new(0,640,0,48)

local function minimize()
    if minimized then return end
    minimized = true
    Sidebar.Visible = false
    Content.Visible = false
    TweenService:Create(Main, TweenInfo.new(0.35, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {Size = minSize}):Play()
end
local function restore()
    if not minimized then return end
    minimized = false
    TweenService:Create(Main, TweenInfo.new(0.35, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {Size = origSize}):Play()
    task.wait(0.15)
    Sidebar.Visible = true
    Content.Visible = true
end

-- Общий обработчик TopBar
TopBar.InputBegan:Connect(function(i)
    if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then
        if minimized then
            restore()
            return
        end
        dragging = true
        dragStart = i.Position
        startPos = Main.Position
    end
end)

-- Кнопки
YellowB.MouseButton1Click:Connect(function()
    if minimized then restore() else minimize() end
end)

-- Красная = свернуть в «иконку» (не уничтожает)
local hiddenIcon = Instance.new("TextButton")
hiddenIcon.Name = "HiddenIcon"
hiddenIcon.Text = ""
hiddenIcon.AutoButtonColor = false
hiddenIcon.Size = UDim2.new(0,44,0,44)
hiddenIcon.Position = UDim2.new(1,-60,0,20)
hiddenIcon.BackgroundColor3 = Color3.fromRGB(25,25,32)
hiddenIcon.BackgroundTransparency = 0.15
hiddenIcon.Visible = false
hiddenIcon.ZIndex = 500
hiddenIcon.Parent = ScreenGui
local HIC = Instance.new("UICorner"); HIC.CornerRadius = UDim.new(1,0); HIC.Parent = hiddenIcon
local HIS = Instance.new("UIStroke"); HIS.Color = ACCENT; HIS.Transparency = 0.5; HIS.Parent = hiddenIcon

local HIcon = Instance.new("ImageLabel")
HIcon.Image = IMAGE_ID
HIcon.Size = UDim2.new(0,30,0,30)
HIcon.Position = UDim2.new(0.5,-15,0.5,-15)
HIcon.BackgroundTransparency = 1
HIcon.ZIndex = 501
HIcon.Parent = hiddenIcon

-- Меню полностью закрыто, но есть иконка и клавиша
local windowHidden = false
local function hideWindow()
    if windowHidden then return end
    windowHidden = true
    local t = TweenService:Create(Main, TweenInfo.new(0.25, Enum.EasingStyle.Quart, Enum.EasingDirection.In), {
        Size = UDim2.new(0,0,0,0), BackgroundTransparency = 1
    })
    t:Play()
    t.Completed:Connect(function()
        Main.Visible = false
        hiddenIcon.Visible = true
    end)
end
local function showWindow()
    if not windowHidden then return end
    windowHidden = false
    hiddenIcon.Visible = false
    Main.Visible = true
    minimized = false
    Sidebar.Visible = true
    Content.Visible = true
    Main.Size = UDim2.new(0,0,0,420)
    Main.Position = UDim2.new(0.5,0,0.5,-210)
    TweenService:Create(Main, TweenInfo.new(0.35, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
        Size = origSize, Position = UDim2.new(0.5,-320,0.5,-210), BackgroundTransparency = 0.25
    }):Play()
end

RedB.MouseButton1Click:Connect(hideWindow)
hiddenIcon.MouseButton1Click:Connect(showWindow)

-- RightShift toggle
UserInputService.InputBegan:Connect(function(input, processed)
    if processed then return end
    if input.KeyCode == TOGGLE_KEY then
        if windowHidden then showWindow() else hideWindow() end
    end
end)

GreenB.MouseButton1Click:Connect(function() UILibrary:NotifySuccess("OK","") end)

-- ==========================================================
-- API: ВКЛАДКИ
-- ==========================================================
local Tabs = {}
local activeTab = nil
local tabOrder = 0

function UILibrary:Tab(name)
    tabOrder += 1
    local Tab = {Name = name, Order = tabOrder}

    local Btn = Instance.new("TextButton")
    Btn.Text = ""; Btn.AutoButtonColor = false
    Btn.Size = UDim2.new(1,0,0,34)
    Btn.BackgroundColor3 = Color3.fromRGB(255,255,255)
    Btn.BackgroundTransparency = 1
    Btn.BorderSizePixel = 0
    Btn.LayoutOrder = tabOrder
    Btn.ZIndex = 8
    Btn.Parent = TabScroll
    local BC = Instance.new("UICorner"); BC.CornerRadius = UDim.new(0,6); BC.Parent = Btn

    local Icon = Instance.new("Frame")
    Icon.Size = UDim2.new(0,16,0,16)
    Icon.Position = UDim2.new(0,10,0.5,-8)
    Icon.BackgroundColor3 = Color3.fromRGB(255,255,255)
    Icon.BackgroundTransparency = 0.55
    Icon.BorderSizePixel = 0
    Icon.ZIndex = 9
    Icon.Parent = Btn
    local ICN = Instance.new("UICorner"); ICN.CornerRadius = UDim.new(0,4); ICN.Parent = Icon

    local Lbl = Instance.new("TextLabel")
    Lbl.Text = name
    Lbl.Size = UDim2.new(1,-36,1,0)
    Lbl.Position = UDim2.new(0,36,0,0)
    Lbl.BackgroundTransparency = 1
    Lbl.TextColor3 = Color3.fromRGB(200,200,215)
    Lbl.TextSize = 12
    Lbl.Font = Enum.Font.GothamMedium
    Lbl.TextXAlignment = Enum.TextXAlignment.Left
    Lbl.ZIndex = 9
    Lbl.Parent = Btn

    local Page = Instance.new("ScrollingFrame")
    Page.Name = "Page_" .. name
    Page.Size = UDim2.new(1,-24,1,-24)
    Page.Position = UDim2.new(0,12,0,12)
    Page.BackgroundTransparency = 1
    Page.BorderSizePixel = 0
    Page.ScrollBarThickness = 3
    Page.ScrollBarImageColor3 = ACCENT
    Page.CanvasSize = UDim2.new(0,0,0,0)
    Page.Visible = false
    Page.ZIndex = 7
    Page.Parent = Content
    local PL = Instance.new("UIListLayout")
    PL.SortOrder = Enum.SortOrder.LayoutOrder
    PL.Padding = UDim.new(0,8)
    PL.Parent = Page
    local PP = Instance.new("UIPadding")
    PP.PaddingRight = UDim.new(0,8)
    PP.Parent = Page

    local function refreshCanvas()
        Page.CanvasSize = UDim2.new(0,0,0, PL.AbsoluteContentSize.Y + 20)
    end
    PL:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(refreshCanvas)
    refreshCanvas()

    Tab.Page = Page
    Tab.Btn = Btn
    Tab.Refresh = refreshCanvas

    local function activate()
        if activeTab == Tab then return end
        if activeTab then
            activeTab.Page.Visible = false
            TweenService:Create(activeTab.Btn, TweenInfo.new(0.15), {BackgroundTransparency = 1}):Play()
        end
        activeTab = Tab
        Tab.Page.Visible = true
        TweenService:Create(Btn, TweenInfo.new(0.15), {BackgroundTransparency = 0.85}):Play()
        refreshCanvas()
    end

    Btn.MouseEnter:Connect(function()
        if activeTab ~= Tab then TweenService:Create(Btn, TweenInfo.new(0.15), {BackgroundTransparency = 0.92}):Play() end
    end)
    Btn.MouseLeave:Connect(function()
        if activeTab ~= Tab then TweenService:Create(Btn, TweenInfo.new(0.15), {BackgroundTransparency = 1}):Play() end
    end)
    Btn.MouseButton1Click:Connect(activate)

    Tab.Activate = activate
    Tabs[name] = Tab
    if tabOrder == 1 then activate() end

    -- Методы
    local function nextOrder() return #Tab.Buttons + 1 end
    Tab.Buttons = {}
    local function push(el) table.insert(Tab.Buttons, el); el.LayoutOrder = nextOrder() end

    function Tab:Section(text)
        local S = Instance.new("TextLabel")
        S.Text = text; S.Size = UDim2.new(1,0,0,24)
        S.BackgroundTransparency = 1; S.TextColor3 = Color3.fromRGB(150,150,170)
        S.TextSize = 11; S.Font = Enum.Font.GothamBold
        S.TextXAlignment = Enum.TextXAlignment.Left
        S.Parent = Page; push(S); return S
    end
    function Tab:Label(text)
        local L = Instance.new("TextLabel")
        L.Text = text; L.Size = UDim2.new(1,0,0,20)
        L.BackgroundTransparency = 1; L.TextColor3 = Color3.fromRGB(220,220,235)
        L.TextSize = 12; L.Font = Enum.Font.Gotham
        L.TextXAlignment = Enum.TextXAlignment.Left
        L.Parent = Page; push(L); return L
    end
    function Tab:Button(cfg)
        cfg = cfg or {}
        local B = Instance.new("TextButton")
        B.Text=""; B.AutoButtonColor=false
        B.Size = UDim2.new(1,0,0,36)
        B.BackgroundColor3 = Color3.fromRGB(35,35,45)
        B.BackgroundTransparency = 0.2
        B.BorderSizePixel = 0
        B.Parent = Page
        local BCr = Instance.new("UICorner"); BCr.CornerRadius = UDim.new(0,6); BCr.Parent = B
        local BS = Instance.new("UIStroke"); BS.Color = Color3.fromRGB(255,255,255); BS.Transparency = 0.85; BS.Parent = B
        local LT = Instance.new("TextLabel")
        LT.Text = cfg.Text or "Кнопка"
        LT.Size = UDim2.new(1,-20,1,0); LT.Position = UDim2.new(0,12,0,0)
        LT.BackgroundTransparency = 1; LT.TextColor3 = Color3.fromRGB(230,230,245)
        LT.TextSize = 13; LT.Font = Enum.Font.GothamMedium
        LT.TextXAlignment = Enum.TextXAlignment.Left; LT.Parent = B
        B.MouseEnter:Connect(function() TweenService:Create(B, TweenInfo.new(0.15), {BackgroundTransparency = 0.05}):Play() end)
        B.MouseLeave:Connect(function() TweenService:Create(B, TweenInfo.new(0.15), {BackgroundTransparency = 0.2}):Play() end)
        B.MouseButton1Click:Connect(function()
            if cfg.Callback then
                local ok, err = pcall(cfg.Callback)
                if not ok then UILibrary:NotifyError("Ошибка", tostring(err)) end
            end
        end)
        push(B); return B
    end
    function Tab:Toggle(cfg)
        cfg = cfg or {}
        local state = cfg.Default or false
        local Row = Instance.new("Frame")
        Row.Size = UDim2.new(1,0,0,36)
        Row.BackgroundColor3 = Color3.fromRGB(35,35,45)
        Row.BackgroundTransparency = 0.2
        Row.BorderSizePixel = 0
        Row.Parent = Page
        local RC = Instance.new("UICorner"); RC.CornerRadius = UDim.new(0,6); RC.Parent = Row
        local RS = Instance.new("UIStroke"); RS.Color = Color3.fromRGB(255,255,255); RS.Transparency = 0.85; RS.Parent = Row
        local LT = Instance.new("TextLabel")
        LT.Text = cfg.Text or "Тоггл"
        LT.Size = UDim2.new(1,-70,1,0); LT.Position = UDim2.new(0,12,0,0)
        LT.BackgroundTransparency = 1; LT.TextColor3 = Color3.fromRGB(230,230,245)
        LT.TextSize = 13; LT.Font = Enum.Font.GothamMedium
        LT.TextXAlignment = Enum.TextXAlignment.Left; LT.Parent = Row
        local Switch = Instance.new("TextButton")
        Switch.Text=""; Switch.AutoButtonColor=false
        Switch.Size = UDim2.new(0,44,0,22)
        Switch.Position = UDim2.new(1,-56,0.5,-11)
        Switch.BackgroundColor3 = state and ACCENT or Color3.fromRGB(60,60,75)
        Switch.BorderSizePixel = 0; Switch.Parent = Row
        local SwC = Instance.new("UICorner"); SwC.CornerRadius = UDim.new(1,0); SwC.Parent = Switch
        local Knob = Instance.new("Frame")
        Knob.Size = UDim2.new(0,16,0,16)
        Knob.Position = state and UDim2.new(1,-20,0.5,-8) or UDim2.new(0,4,0.5,-8)
        Knob.BackgroundColor3 = Color3.fromRGB(255,255,255)
        Knob.BorderSizePixel = 0; Knob.Parent = Switch
        local KC = Instance.new("UICorner"); KC.CornerRadius = UDim.new(1,0); KC.Parent = Knob
        local function setState(v)
            state = v
            TweenService:Create(Switch, TweenInfo.new(0.2), {BackgroundColor3 = state and ACCENT or Color3.fromRGB(60,60,75)}):Play()
            TweenService:Create(Knob, TweenInfo.new(0.2), {Position = state and UDim2.new(1,-20,0.5,-8) or UDim2.new(0,4,0.5,-8)}):Play()
            if cfg.Callback then pcall(cfg.Callback, state) end
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
        local Row = Instance.new("Frame")
        Row.Size = UDim2.new(1,0,0,50)
        Row.BackgroundColor3 = Color3.fromRGB(35,35,45)
        Row.BackgroundTransparency = 0.2
        Row.BorderSizePixel = 0; Row.Parent = Page
        local RC = Instance.new("UICorner"); RC.CornerRadius = UDim.new(0,6); RC.Parent = Row
        local RS = Instance.new("UIStroke"); RS.Color = Color3.fromRGB(255,255,255); RS.Transparency = 0.85; RS.Parent = Row
        local LT = Instance.new("TextLabel")
        LT.Text = cfg.Text or "Слайдер"
        LT.Size = UDim2.new(1,-70,0,20); LT.Position = UDim2.new(0,12,0,6)
        LT.BackgroundTransparency = 1; LT.TextColor3 = Color3.fromRGB(230,230,245)
        LT.TextSize = 12; LT.Font = Enum.Font.GothamMedium
        LT.TextXAlignment = Enum.TextXAlignment.Left; LT.Parent = Row
        local V = Instance.new("TextLabel")
        V.Text = tostring(value)..suffix
        V.Size = UDim2.new(0,60,0,20); V.Position = UDim2.new(1,-72,0,6)
        V.BackgroundTransparency = 1; V.TextColor3 = ACCENT
        V.TextSize = 12; V.Font = Enum.Font.GothamBold
        V.TextXAlignment = Enum.TextXAlignment.Right; V.Parent = Row
        local Bar = Instance.new("Frame")
        Bar.Size = UDim2.new(1,-24,0,6); Bar.Position = UDim2.new(0,12,0,32)
        Bar.BackgroundColor3 = Color3.fromRGB(60,60,75)
        Bar.BorderSizePixel = 0; Bar.Parent = Row
        local BC2 = Instance.new("UICorner"); BC2.CornerRadius = UDim.new(1,0); BC2.Parent = Bar
        local Fill = Instance.new("Frame")
        Fill.Size = UDim2.new((value-min)/(max-min),0,1,0)
        Fill.BackgroundColor3 = ACCENT
        Fill.BorderSizePixel = 0; Fill.Parent = Bar
        local FC = Instance.new("UICorner"); FC.CornerRadius = UDim.new(1,0); FC.Parent = Fill

        local sliderDragging = false
        local function setFromX(x)
            local rel = math.clamp((x - Bar.AbsolutePosition.X) / Bar.AbsoluteSize.X, 0, 1)
            value = math.floor(min + (max-min)*rel + 0.5)
            V.Text = tostring(value)..suffix
            Fill.Size = UDim2.new((value-min)/(max-min),0,1,0)
            if cfg.Callback then pcall(cfg.Callback, value) end
        end

        Bar.InputBegan:Connect(function(i)
            if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then
                sliderDragging = true
                setFromX(i.Position.X)
            end
        end)
        -- Единый диспетчер
        InputDispatcher.OnChanged(function(i)
            if sliderDragging and (i.UserInputType == Enum.UserInputType.MouseMovement or i.UserInputType == Enum.UserInputType.Touch) then
                setFromX(i.Position.X)
            end
        end)
        InputDispatcher.OnEnded(function(i)
            if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then
                sliderDragging = false
            end
        end)

        push(Row)
        return {Set = function(v) v=math.clamp(v,min,max); value=v; V.Text=tostring(v)..suffix; Fill.Size=UDim2.new((v-min)/(max-min),0,1,0) end,
                Get = function() return value end, Instance = Row}
    end
    function Tab:Textbox(cfg)
        cfg = cfg or {}
        local Row = Instance.new("Frame")
        Row.Size = UDim2.new(1,0,0,36)
        Row.BackgroundColor3 = Color3.fromRGB(35,35,45)
        Row.BackgroundTransparency = 0.2
        Row.BorderSizePixel = 0; Row.Parent = Page
        local RC = Instance.new("UICorner"); RC.CornerRadius = UDim.new(0,6); RC.Parent = Row
        local RS = Instance.new("UIStroke"); RS.Color = Color3.fromRGB(255,255,255); RS.Transparency = 0.85; RS.Parent = Row
        local TB = Instance.new("TextBox")
        TB.Text = cfg.Default or ""                         -- ФИКС 2
        TB.PlaceholderText = cfg.Placeholder or ""
        TB.Size = UDim2.new(1,-24,1,0); TB.Position = UDim2.new(0,12,0,0)
        TB.BackgroundTransparency = 1; TB.TextColor3 = Color3.fromRGB(230,230,245)
        TB.PlaceholderColor3 = Color3.fromRGB(140,140,160)
        TB.TextSize = 13; TB.Font = Enum.Font.GothamMedium
        TB.TextXAlignment = Enum.TextXAlignment.Left
        TB.ClearTextOnFocus = false
        TB.Parent = Row
        TB.FocusLost:Connect(function()
            if cfg.Callback then
                local ok, err = pcall(cfg.Callback, TB.Text)
                if not ok then UILibrary:NotifyError("Ошибка", tostring(err)) end
            end
        end)
        push(Row)
        return {Get = function() return TB.Text end, Set = function(v) TB.Text = v end, Instance = Row}
    end
    function Tab:Dropdown(cfg)
        cfg = cfg or {}
        local options = cfg.Options or {}
        local selected = cfg.Default or (options[1] or "")
        local baseH = 36

        local Row = Instance.new("Frame")
        Row.Size = UDim2.new(1,0,0,baseH)
        Row.BackgroundColor3 = Color3.fromRGB(35,35,45)
        Row.BackgroundTransparency = 0.2
        Row.BorderSizePixel = 0
        Row.ClipsDescendants = true
        Row.ZIndex = 10                                -- ФИКС 1
        Row.Parent = Page
        local RC = Instance.new("UICorner"); RC.CornerRadius = UDim.new(0,6); RC.Parent = Row
        local RS = Instance.new("UIStroke"); RS.Color = Color3.fromRGB(255,255,255); RS.Transparency = 0.85; RS.Parent = Row

        local Head = Instance.new("TextButton")
        Head.Text=""; Head.AutoButtonColor=false
        Head.Size = UDim2.new(1,0,0,baseH)
        Head.BackgroundTransparency = 1
        Head.ZIndex = 11
        Head.Parent = Row

        -- ФИКС 3: заголовок дропдауна слева
        local NameLbl = Instance.new("TextLabel")
        NameLbl.Text = cfg.Text or ""
        NameLbl.Size = UDim2.new(0.5,-12,1,0)
        NameLbl.Position = UDim2.new(0,12,0,0)
        NameLbl.BackgroundTransparency = 1
        NameLbl.TextColor3 = Color3.fromRGB(230,230,245)
        NameLbl.TextSize = 13
        NameLbl.Font = Enum.Font.GothamMedium
        NameLbl.TextXAlignment = Enum.TextXAlignment.Left
        NameLbl.ZIndex = 12
        NameLbl.Parent = Head

        local ValLbl = Instance.new("TextLabel")
        ValLbl.Text = selected
        ValLbl.Size = UDim2.new(0.5,-28,1,0)
        ValLbl.Position = UDim2.new(0.5,0,0,0)
        ValLbl.BackgroundTransparency = 1
        ValLbl.TextColor3 = ACCENT
        ValLbl.TextSize = 13
        ValLbl.Font = Enum.Font.GothamBold
        ValLbl.TextXAlignment = Enum.TextXAlignment.Right
        ValLbl.ZIndex = 12
        ValLbl.Parent = Head

        local Arrow = Instance.new("TextLabel")
        Arrow.Text = "▾"
        Arrow.Size = UDim2.new(0,20,0,baseH)
        Arrow.Position = UDim2.new(1,-24,0,0)
        Arrow.BackgroundTransparency = 1
        Arrow.TextColor3 = Color3.fromRGB(180,180,200)
        Arrow.TextSize = 12
        Arrow.ZIndex = 12
        Arrow.Parent = Head

        local opened = false
        local optionButtons = {}

        local function destroyOptions()
            for _, b in pairs(optionButtons) do b:Destroy() end
            optionButtons = {}
        end

        local function rebuild()
            destroyOptions()
            for i, opt in pairs(options) do
                local OB = Instance.new("TextButton")
                OB.Text=""; OB.AutoButtonColor=false
                OB.Size = UDim2.new(1,0,0,28)
                OB.Position = UDim2.new(0,0,0,baseH + (i-1)*28)
                OB.BackgroundColor3 = Color3.fromRGB(45,45,58)
                OB.BackgroundTransparency = 0.3
                OB.BorderSizePixel = 0
                OB.ZIndex = 11
                OB.Parent = Row
                local OBT = Instance.new("TextLabel")
                OBT.Text = opt
                OBT.Size = UDim2.new(1,-24,1,0); OBT.Position = UDim2.new(0,12,0,0)
                OBT.BackgroundTransparency = 1; OBT.TextColor3 = Color3.fromRGB(220,220,235)
                OBT.TextSize = 12; OBT.Font = Enum.Font.Gotham
                OBT.TextXAlignment = Enum.TextXAlignment.Left; OBT.ZIndex = 12
                OBT.Parent = OB
                OB.MouseButton1Click:Connect(function()
                    selected = opt
                    ValLbl.Text = opt
                    if cfg.Callback then
                        local ok, err = pcall(cfg.Callback, opt)
                        if not ok then UILibrary:NotifyError("Ошибка", tostring(err)) end
                    end
                    opened = false
                    destroyOptions()                    -- ФИКС 9
                    local t = TweenService:Create(Row, TweenInfo.new(0.2), {Size = UDim2.new(1,0,0,baseH)})
                    t:Play()
                    t.Completed:Connect(refreshCanvas)
                end)
                table.insert(optionButtons, OB)
            end
        end

        Head.MouseButton1Click:Connect(function()
            opened = not opened
            if opened then
                rebuild()
                local h = baseH + #options * 28
                local t = TweenService:Create(Row, TweenInfo.new(0.2, Enum.EasingStyle.Quart), {Size = UDim2.new(1,0,0,h)})
                t:Play()
                t.Completed:Connect(refreshCanvas)      -- ФИКС 1
            else
                destroyOptions()
                local t = TweenService:Create(Row, TweenInfo.new(0.2), {Size = UDim2.new(1,0,0,baseH)})
                t:Play()
                t.Completed:Connect(refreshCanvas)
            end
        end)

        push(Row)
        return {Get = function() return selected end, Instance = Row}
    end

    return Tab
end

function UILibrary:GetTab(name) return Tabs[name] end
function UILibrary:SelectTab(name) if Tabs[name] then Tabs[name].Activate() end end

-- ==========================================================
-- ПОЯВЛЕНИЕ + ДЕМО
-- ==========================================================
task.spawn(function()
    task.wait(LOAD_TIME)
    if moonConn then moonConn:Disconnect() end
    pulse:Cancel()
    TweenService:Create(Loading, TweenInfo.new(0.6), {BackgroundTransparency = 1}):Play()
    TweenService:Create(LImg, TweenInfo.new(0.6), {ImageTransparency=1, Size=UDim2.new(0,0,0,0), Position=UDim2.new(0.5,0,0.5,0)}):Play()
    TweenService:Create(Moon, TweenInfo.new(0.6), {ImageTransparency=1, Size=UDim2.new(0,0,0,0)}):Play()
    task.wait(0.7)
    Loading:Destroy()

    Main.Visible = true
    Main.Size = UDim2.new(0,0,0,420)
    Main.Position = UDim2.new(0.5,0,0.5,-210)
    TweenService:Create(Main, TweenInfo.new(0.5, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
        Size = origSize, Position = UDim2.new(0.5,-320,0.5,-210), BackgroundTransparency = 0.25
    }):Play()
    TweenService:Create(Sidebar, TweenInfo.new(0.5), {BackgroundTransparency = 0.35}):Play()
    TweenService:Create(TopBar, TweenInfo.new(0.5), {BackgroundTransparency = 0.4}):Play()

    task.wait(0.6)
    UILibrary:NotifySuccess("UI Library", "Правая Shift — скрыть/показать")

    -- ДЕМО
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
