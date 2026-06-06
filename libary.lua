--// Services
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

--// Setup
local Setup = {
    Keybind = Enum.KeyCode.RightControl,
    Transparency = 0,
    ThemeMode = "Dark"
}

local Themes = {
    Dark = { Main = Color3.fromRGB(36, 36, 36), Accent = Color3.fromRGB(248, 191, 212), TopbarActions = Color3.fromRGB(25, 25, 25), Secondary = Color3.fromRGB(21, 21, 21), Component = Color3.fromRGB(40, 40, 40), Interactables = Color3.fromRGB(45, 45, 45), Tab = Color3.fromRGB(200, 200, 200), Title = Color3.fromRGB(240, 240, 240), Description = Color3.fromRGB(200, 200, 200), Shadow = Color3.fromRGB(0, 0, 0), Outline = Color3.fromRGB(40, 40, 40), Icon = Color3.fromRGB(220, 220, 220) },
    Blue = { Main = Color3.fromRGB(25, 30, 45), Accent = Color3.fromRGB(0, 160, 255), TopbarActions = Color3.fromRGB(20, 25, 35), Secondary = Color3.fromRGB(15, 20, 30) },
    Halloween = { Main = Color3.fromRGB(20, 20, 20), Accent = Color3.fromRGB(255, 120, 0), TopbarActions = Color3.fromRGB(15, 15, 15), Secondary = Color3.fromRGB(10, 10, 10) },
    Red = { Main = Color3.fromRGB(30, 10, 10), Accent = Color3.fromRGB(255, 50, 50), TopbarActions = Color3.fromRGB(20, 5, 5), Secondary = Color3.fromRGB(15, 5, 5) },
    Purple = { Main = Color3.fromRGB(25, 15, 35), Accent = Color3.fromRGB(180, 100, 255), TopbarActions = Color3.fromRGB(20, 10, 30), Secondary = Color3.fromRGB(15, 5, 25) },
    Midnight = { Main = Color3.fromRGB(12, 12, 18), Accent = Color3.fromRGB(90, 90, 255), TopbarActions = Color3.fromRGB(8, 8, 12), Secondary = Color3.fromRGB(5, 5, 10) },
    Ocean = { Main = Color3.fromRGB(10, 35, 40), Accent = Color3.fromRGB(0, 220, 220), TopbarActions = Color3.fromRGB(5, 25, 30), Secondary = Color3.fromRGB(5, 20, 25) },
    Rose = { Main = Color3.fromRGB(40, 30, 35), Accent = Color3.fromRGB(255, 140, 180), TopbarActions = Color3.fromRGB(35, 25, 30), Secondary = Color3.fromRGB(30, 20, 25) },
    Emerald = { Main = Color3.fromRGB(20, 30, 25), Accent = Color3.fromRGB(0, 255, 120), TopbarActions = Color3.fromRGB(15, 25, 20), Secondary = Color3.fromRGB(10, 20, 15) },
    Amber = { Main = Color3.fromRGB(30, 25, 20), Accent = Color3.fromRGB(255, 170, 0), TopbarActions = Color3.fromRGB(25, 20, 15), Secondary = Color3.fromRGB(20, 15, 10) },
    Sakura = { Main = Color3.fromRGB(35, 25, 30), Accent = Color3.fromRGB(255, 180, 220), TopbarActions = Color3.fromRGB(30, 20, 25), Secondary = Color3.fromRGB(25, 15, 20) },
    Cyberpunk = { Main = Color3.fromRGB(25, 10, 40), Accent = Color3.fromRGB(0, 255, 255), TopbarActions = Color3.fromRGB(15, 5, 30), Secondary = Color3.fromRGB(10, 5, 25) },
    Forest = { Main = Color3.fromRGB(15, 25, 15), Accent = Color3.fromRGB(100, 200, 100), TopbarActions = Color3.fromRGB(10, 20, 10), Secondary = Color3.fromRGB(5, 15, 5) },
    Coffee = { Main = Color3.fromRGB(45, 35, 30), Accent = Color3.fromRGB(180, 140, 100), TopbarActions = Color3.fromRGB(35, 30, 25), Secondary = Color3.fromRGB(30, 25, 20) },
    Nord = { Main = Color3.fromRGB(46, 52, 64), Accent = Color3.fromRGB(136, 192, 208), TopbarActions = Color3.fromRGB(40, 45, 55), Secondary = Color3.fromRGB(35, 40, 50) },
    Dracula = { Main = Color3.fromRGB(40, 42, 54), Accent = Color3.fromRGB(255, 121, 198), TopbarActions = Color3.fromRGB(30, 32, 44), Secondary = Color3.fromRGB(25, 25, 35) },
    Gold = { Main = Color3.fromRGB(20, 20, 0), Accent = Color3.fromRGB(255, 215, 0), TopbarActions = Color3.fromRGB(15, 15, 0), Secondary = Color3.fromRGB(10, 10, 0) },
    Sky = { Main = Color3.fromRGB(15, 30, 45), Accent = Color3.fromRGB(135, 206, 235), TopbarActions = Color3.fromRGB(10, 25, 40), Secondary = Color3.fromRGB(5, 20, 35) },
    Synthwave = { Main = Color3.fromRGB(30, 10, 50), Accent = Color3.fromRGB(255, 0, 255), TopbarActions = Color3.fromRGB(20, 5, 40), Secondary = Color3.fromRGB(15, 5, 35) }
}

local Fonts = {
    reg = Font.new("rbxassetid://12187365364"),
    bold = Font.new("rbxassetid://12187365364", Enum.FontWeight.Bold),
    med = Font.new("rbxassetid://12187365364", Enum.FontWeight.Medium),
    logo = Font.new("rbxassetid://12187365364", Enum.FontWeight.Bold)
}

--// Utilities
local function New(class, props, parent)
    local i = Instance.new(class)
    for k, v in pairs(props) do i[k] = v end
    if parent then i.Parent = parent end
    return i
end

local function SetProperty(Object, Properties)
    for k, v in pairs(Properties) do Object[k] = v end
    return Object
end

local function Tween(Object, Speed, Properties)
    return TweenService:Create(Object, TweenInfo.new(Speed, Enum.EasingStyle.Sine), Properties):Play()
end

--// Tables
local Animations = {}
local StoredInfo = { Sections = {}, Tabs = {} }
local Library = {}

--// Animations
function Animations:Open(Window, Transparency)
    SetProperty(Window, { 
        GroupTransparency = 1, 
        Visible = true 
    })
    Tween(Window, 0.25, { 
        GroupTransparency = Transparency or 0 
    })
end

function Animations:Close(Window)
    Tween(Window, 0.25, { 
        GroupTransparency = 1 
    })
    task.wait(0.25)
    Window.Visible = false
end

function Animations:Component(Component)
    Component.InputBegan:Connect(function()
        Tween(Component, 0.2, { 
            BackgroundColor3 = Color3.fromRGB(50, 50, 50) 
        })
    end)
    Component.InputEnded:Connect(function()
        Tween(Component, 0.2, { 
            BackgroundColor3 = Themes.Dark.Component 
        })
    end)
end

--// Core Library
function Library:CreateWindow(Settings)
    local Title = Settings.Title or "Goon Hub"
    local WindowSize = Settings.Size or UDim2.new(0, 880, 0, 600)
    local Transparency = Settings.Transparency or 0
    local CurrentTheme = Themes[Settings.Theme] or Themes.Dark
    Setup.Keybind = Settings.MinimizeKeybind or Enum.KeyCode.RightControl
    
    -- Target UI Root
    local target = (gethui and gethui()) or game:GetService("CoreGui") or LocalPlayer:WaitForChild("PlayerGui")
    if target:FindFirstChild("GoonHub") then target["GoonHub"]:Destroy() end

    -- Build Main UI
    local Screen = New("ScreenGui", { 
        Name = "GoonHub", 
        IgnoreGuiInset = true, 
        ResetOnSpawn = false,
        ZIndexBehavior = Enum.ZIndexBehavior.Global
    }, target)

    local Main = New("CanvasGroup", {
        Name = "Main",
        BackgroundColor3 = CurrentTheme.Main,
        AnchorPoint = Vector2.new(0.5, 0.5),
        Size = WindowSize,
        Position = UDim2.new(0.5, 0, 0.5, 0),
        ClipsDescendants = true
    }, Screen)

    New("UICorner", { CornerRadius = UDim.new(0, 18) }, Main)

    New("UIStroke", { 
        Transparency = 0.75, 
        Thickness = 2, 
        Color = Color3.new(1, 1, 1) 
    }, Main)

    local ControlsFrame = New("Frame", {
        Size = UDim2.new(1, 0, 1, 0),
        BackgroundTransparency = 1,
        ZIndex = 999,
        Name = "controls"
    }, Main)

    -- Panel Content
    local Content = New("Frame", { 
        Name = "Content", 
        Size = UDim2.new(1, 0, 1, -35), 
        Position = UDim2.new(0.5, 0, 1, 0), 
        AnchorPoint = Vector2.new(0.5, 1), 
        BackgroundTransparency = 1 
    }, Main)

    New("UIPadding", { 
        PaddingTop = UDim.new(0, 10), 
        PaddingBottom = UDim.new(0, 35), 
        PaddingRight = UDim.new(0, 15) 
    }, Content)

    local Sidebar = New("Frame", { 
        Name = "Sidebar", 
        Size = UDim2.new(0, 220, 1, 0), 
        BackgroundTransparency = 1 
    }, Content)

    New("UIListLayout", {
        SortOrder = Enum.SortOrder.LayoutOrder,
        Padding = UDim.new(0, 7), 
        HorizontalAlignment = Enum.HorizontalAlignment.Center 
    }, Sidebar)

    local NavHolder = New("Frame", { 
        Name = "NavHolder", 
        Size = UDim2.new(1, -22, 0, 0), 
        BackgroundColor3 = Color3.fromRGB(9, 9, 9), 
        BackgroundTransparency = 0.7 
    }, Sidebar)

    New("UICorner", { CornerRadius = UDim.new(0, 15) }, NavHolder)
    New("UIFlexItem", { FlexMode = Enum.UIFlexMode.Fill }, NavHolder)

    local NavScroll = New("ScrollingFrame", { 
        Name = "Navigation", 
        Size = UDim2.new(1, 0, 1, -16), 
        Position = UDim2.new(0, 0, 0, 8), 
        BackgroundTransparency = 1, 
        ScrollBarThickness = 0, 
        AutomaticCanvasSize = Enum.AutomaticSize.Y 
    }, NavHolder)

    New("UIListLayout", { 
        SortOrder = Enum.SortOrder.LayoutOrder,
        Padding = UDim.new(0, 5), 
        HorizontalAlignment = Enum.HorizontalAlignment.Center 
    }, NavScroll)

    New("UIPadding", {
        PaddingLeft = UDim.new(0, 8),
        PaddingRight = UDim.new(0, 8),
        PaddingTop = UDim.new(0, 2)
    }, NavScroll)

    local AnchoredButtons = New("Frame", {
        Name = "AnchoredButtons",
        Size = UDim2.new(1, -22, 0, 0),
        AutomaticSize = Enum.AutomaticSize.Y,
        BackgroundTransparency = 1,
        LayoutOrder = 5
    }, Sidebar)

    local AnchoredMain = New("Frame", {
        Name = "Main",
        BackgroundColor3 = Color3.fromRGB(9, 9, 9),
        BackgroundTransparency = 0,
        AutomaticSize = Enum.AutomaticSize.Y,
        Size = UDim2.new(1, 0, 0, 0),
        Parent = AnchoredButtons
    })

    New("UICorner", { CornerRadius = UDim.new(0, 12) }, AnchoredMain)

    New("UIListLayout", {
        Padding = UDim.new(0, 5),
        HorizontalAlignment = Enum.HorizontalAlignment.Center,
        SortOrder = Enum.SortOrder.LayoutOrder
    }, AnchoredMain)

    New("UIPadding", { PaddingTop = UDim.new(0, 7), PaddingBottom = UDim.new(0, 7), PaddingLeft = UDim.new(0, 6), PaddingRight = UDim.new(0, 6) }, AnchoredMain)

    -- Sidebar Profile (User Section)
    local UserPanel = New("ImageButton", {
        Name = "UserPanel",
        Parent = Sidebar,
        Size = UDim2.new(1, -22, 0, 48),
        BackgroundColor3 = Color3.fromRGB(9, 9, 9),
        BackgroundTransparency = 0,
        LayoutOrder = 10,
        AutoButtonColor = false
    })
    New("UICorner", { CornerRadius = UDim.new(0, 15) }, UserPanel)
    New("UIListLayout", {
        FillDirection = Enum.FillDirection.Horizontal,
        VerticalAlignment = Enum.VerticalAlignment.Center,
        Padding = UDim.new(0, 10)
    }, UserPanel)
    New("UIPadding", { PaddingLeft = UDim.new(0, 10), PaddingRight = UDim.new(0, 35) }, UserPanel)

    local AvatarFrame = New("Frame", {
        Parent = UserPanel,
        Size = UDim2.new(0, 26, 0, 26),
        BackgroundTransparency = 1
    })
    local Avatar = New("ImageLabel", {
        Parent = AvatarFrame,
        Size = UDim2.new(1, 0, 1, 0),
        Image = "rbxthumb://type=AvatarHeadShot&id=" .. LocalPlayer.UserId .. "&w=150&h=150",
        BackgroundTransparency = 1
    })
    New("UICorner", { CornerRadius = UDim.new(1, 0) }, Avatar)

    local UserInfo = New("Frame", {
        Parent = UserPanel,
        Size = UDim2.new(1, 0, 1, 0),
        BackgroundTransparency = 1
    })
    New("UIListLayout", { VerticalAlignment = Enum.VerticalAlignment.Center }, UserInfo)
    New("UIFlexItem", { FlexMode = Enum.UIFlexMode.Fill }, UserInfo)

    New("TextLabel", {
        Parent = UserInfo,
        Size = UDim2.new(1, 0, 0, 15),
        Text = LocalPlayer.DisplayName,
        FontFace = Fonts.bold,
        TextSize = 15,
        TextColor3 = Color3.new(1, 1, 1),
        BackgroundTransparency = 1,
        TextXAlignment = Enum.TextXAlignment.Left,
        TextTruncate = Enum.TextTruncate.AtEnd
    })
    New("TextLabel", {
        Parent = UserInfo,
        Size = UDim2.new(1, 0, 0, 10),
        Text = "@" .. LocalPlayer.Name,
        FontFace = Fonts.reg,
        TextSize = 13,
        TextColor3 = Color3.new(0.6, 0.6, 0.6),
        BackgroundTransparency = 1,
        TextXAlignment = Enum.TextXAlignment.Left,
        TextTruncate = Enum.TextTruncate.AtEnd
    })

    -- Time Box in User Panel
    local TimeBox = New("Frame", {
        Parent = UserPanel,
        Size = UDim2.new(0, 75, 0, 22),
        BackgroundColor3 = Color3.new(0, 0, 0),
        BackgroundTransparency = 0.8,
        LayoutOrder = 1
    })
    New("UICorner", { CornerRadius = UDim.new(0, 6) }, TimeBox)
    New("UIPadding", { PaddingLeft = UDim.new(0, 5), PaddingRight = UDim.new(0, 5) }, TimeBox)

    local TimeLabel = New("TextLabel", {
        Parent = TimeBox,
        Size = UDim2.new(1, 0, 1, 0),
        Text = "00:00 PM",
        FontFace = Fonts.reg,
        TextSize = 13,
        TextColor3 = Color3.new(1, 1, 1),
        BackgroundTransparency = 1,
        TextTransparency = 0.2,
        TextYAlignment = Enum.TextYAlignment.Center
    })

    -- Debug Bar (Bottom Info)
    local DebugBar = New("Frame", {
        Name = "DebugBar",
        Parent = Main,
        Size = UDim2.new(1, 0, 0, 30),
        Position = UDim2.new(0, 0, 1, 0),
        AnchorPoint = Vector2.new(0, 1),
        BackgroundColor3 = Color3.new(0, 0, 0),
        BackgroundTransparency = 0
    })
    New("UIStroke", { Color = Color3.fromRGB(46, 46, 46) }, DebugBar)
    New("UIListLayout", {
        FillDirection = Enum.FillDirection.Horizontal,
        VerticalAlignment = Enum.VerticalAlignment.Center,
        Padding = UDim.new(0, 15)
    }, DebugBar)
    New("UIPadding", { PaddingLeft = UDim.new(0, 18) }, DebugBar)

    local function CreateStatLabel(text, color)
        local f = New("Frame", { Parent = DebugBar, AutomaticSize = Enum.AutomaticSize.XY, BackgroundTransparency = 1 })
        New("UIListLayout", { FillDirection = Enum.FillDirection.Horizontal, Padding = UDim.new(0, 4) }, f)
        New("TextLabel", { Parent = f, Text = text, TextColor3 = color, FontFace = Fonts.med, TextSize = 14, BackgroundTransparency = 1, AutomaticSize = Enum.AutomaticSize.X })
        return New("TextLabel", { Parent = f, Text = "--", TextColor3 = Color3.new(1, 1, 1), FontFace = Fonts.med, TextSize = 14, BackgroundTransparency = 1, AutomaticSize = Enum.AutomaticSize.X })
    end

    local MemoryLabel = CreateStatLabel("Memory Usage:", Color3.fromRGB(255, 255, 81))
    local PingLabel = CreateStatLabel("Avg. Ping:", Color3.fromRGB(255, 255, 81))
    local FPSLabel = New("TextLabel", { Parent = DebugBar, Text = "FPS: --", FontFace = Fonts.med, TextSize = 14, TextColor3 = Color3.new(1, 1, 1), BackgroundTransparency = 1, AutomaticSize = Enum.AutomaticSize.XY })

    -- Page Container
    local PageHolder = New("Frame", { 
        Name = "PageHolder", 
        Size = UDim2.new(1, -235, 1, 0), 
        Position = UDim2.new(1, 0, 1, 0), 
        AnchorPoint = Vector2.new(1, 1), 
        BackgroundColor3 = CurrentTheme.Secondary, 
        BackgroundTransparency = 0 
    }, Content)

    New("UICorner", { CornerRadius = UDim.new(0, 12) }, PageHolder)
    local Pages = New("UIPageLayout", { 
        Animated = true, 
        EasingStyle = Enum.EasingStyle.Quart, 
        TweenTime = 0.45 
    }, PageHolder)

    -- Topbar Structure
    local Topbar = New("Frame", { 
        Name = "Topbar",
        Size = UDim2.new(1, 0, 0, 35),
        BackgroundTransparency = 1
    }, Main)

    New("UIListLayout", {
        FillDirection = Enum.FillDirection.Horizontal,
        VerticalAlignment = Enum.VerticalAlignment.Center,
        Padding = UDim.new(0, 10)
    }, Topbar)
    New("UIPadding", { PaddingLeft = UDim.new(0, 15), PaddingRight = UDim.new(0, 15) }, Topbar)

    local LogoFrame = New("Frame", {
        Name = "LogoFrame",
        Parent = Topbar,
        AutomaticSize = Enum.AutomaticSize.X,
        Size = UDim2.new(0, 0, 1, 0),
        BackgroundTransparency = 1,
        LayoutOrder = 1
    })

    New("TextLabel", {
        Parent = LogoFrame,
        AutomaticSize = Enum.AutomaticSize.X,
        Size = UDim2.new(0, 0, 1, 0),
        Text = string.format("<font color=\"rgb(248, 191, 212)\">Goon</font>Hub<font color=\"rgb(150,150,150)\">| %s</font>", Title),
        RichText = true, 
        FontFace = Fonts.logo, 
        TextSize = 24, 
        TextColor3 = Color3.new(1, 1, 1), 
        BackgroundTransparency = 1, 
        TextXAlignment = Enum.TextXAlignment.Left
    })

    local Spacer = New("Frame", { Parent = Topbar, BackgroundTransparency = 1, LayoutOrder = 2 })
    New("UIFlexItem", { FlexMode = Enum.UIFlexMode.Fill }, Spacer)

    -- Topbar Actions Frame
    local ActionsFrame = New("Frame", {
        Parent = Topbar,
        Name = "Actions",
        Size = UDim2.new(0, 80, 1, 0),
        BackgroundTransparency = 1,
        LayoutOrder = 3
    })

    local ActionBackground = New("Frame", {
        Parent = ActionsFrame,
        Size = UDim2.new(1, 0, 0, 27),
        AnchorPoint = Vector2.new(0.5, 0.5),
        Position = UDim2.new(0.5, 0, 0.5, 0),
        BackgroundColor3 = CurrentTheme.TopbarActions
    })
    New("UICorner", { CornerRadius = UDim.new(1, 0) }, ActionBackground)
    New("UIListLayout", { FillDirection = Enum.FillDirection.Horizontal, HorizontalAlignment = Enum.HorizontalAlignment.Center, VerticalAlignment = Enum.VerticalAlignment.Center, Padding = UDim.new(0, 4) }, ActionBackground)

    local function CreateTopButton(name, color, iconId)
        local btn = New("ImageButton", { Name = name, Size = UDim2.new(0, 22, 0, 22), BackgroundTransparency = 1, Parent = ActionBackground })
        local f = New("Frame", { Size = UDim2.new(1, 0, 1, 0), BackgroundTransparency = 1, Parent = btn })
        local circle = New("ImageLabel", { Size = UDim2.new(0, 18, 0, 18), Position = UDim2.new(0.5, 0, 0.5, 0), AnchorPoint = Vector2.new(0.5, 0.5), BackgroundColor3 = color, ImageTransparency = 1, Parent = f })
        New("UICorner", { CornerRadius = UDim.new(1, 0) }, circle)
        local i = New("ImageLabel", { Size = UDim2.new(0, 14, 0, 14), Position = UDim2.new(0.5, 0, 0.5, 0), AnchorPoint = Vector2.new(0.5, 0.5), ImageTransparency = 0, BackgroundTransparency = 1, ZIndex = 1002, Parent = f })
        New("UIStroke", { Transparency = 0.9, Color = Color3.new(1, 1, 1) }, i)
        New("UICorner", { CornerRadius = UDim.new(1, 0) }, i)
        New("ImageLabel", { Size = UDim2.new(0, 8, 0, 8), Position = UDim2.new(0.5, 0, 0.5, 0), AnchorPoint = Vector2.new(0.5, 0.5), Image = "rbxassetid://" .. iconId, ImageColor3 = Color3.new(0,0,0), BackgroundTransparency = 1, Parent = f, ZIndex = 1003 })
        return btn
    end

    local CloseBtn = CreateTopButton("close", Color3.fromRGB(255, 51, 51), "109757326745560")
    local SidebarBtn = CreateTopButton("sidebar_toggle", Color3.fromRGB(226, 183, 26), "4773248567")
    local MaximizeBtn = CreateTopButton("maximize", Color3.fromRGB(122, 214, 3), "11295291707")

    -- Weather Icon (Far Right)
    local WeatherIcon = New("ImageLabel", {
        Parent = Topbar,
        Size = UDim2.new(0, 21, 0, 21),
        Image = "rbxassetid://13056160366",
        BackgroundTransparency = 1,
        LayoutOrder = 4
    })

    local function closeUI()
        local closeTween = TweenService:Create(Main, TweenInfo.new(0.35, Enum.EasingStyle.Back, Enum.EasingDirection.In), { Size = UDim2.new(0, 0, 0, 0) })
        closeTween:Play()
        closeTween.Completed:Connect(function() Screen:Destroy() end)
    end

    CloseBtn.MouseButton1Click:Connect(closeUI)

    local sidebarVisible = true
    SidebarBtn.MouseButton1Click:Connect(function()
        sidebarVisible = not sidebarVisible
        Tween(Sidebar, 0.3, { Size = sidebarVisible and UDim2.new(0, 220, 1, 0) or UDim2.new(0, 0, 1, 0) })
        Tween(PageHolder, 0.3, { Size = sidebarVisible and UDim2.new(1, -235, 1, 0) or UDim2.new(1, 0, 1, 0) })
    end)

    local isMinimized = false
    local miniButtons = nil
    local miniLogo = nil
    MaximizeBtn.MouseButton1Click:Connect(function()
        isMinimized = not isMinimized
        local targetSize = isMinimized and UDim2.new(0, 260, 0, 35) or WindowSize
        Tween(Main, 0.5, { Size = targetSize })
        
        if isMinimized then
            Content.Visible = false
            Topbar.Visible = false
            DebugBar.Visible = false
            ResizeHandle.Visible = false
            
            miniButtons = ActionBackground:Clone()
            miniButtons.Name = "MiniButtons"
            miniButtons.Parent = ControlsFrame
            miniButtons.Size = UDim2.new(0, 85, 0, 27)
            miniButtons.AnchorPoint = Vector2.new(1, 0.5) 
            miniButtons.Position = UDim2.new(1, -15, 0, 17.5)
            miniButtons.ZIndex = 2000
            miniButtons.Visible = true
            
            for _, child in pairs(miniButtons:GetDescendants()) do
                if child:IsA("GuiObject") then
                    child.ZIndex = miniButtons.ZIndex + 5
                    child.Visible = true
                end
            end

            miniLogo = LogoFrame:Clone()
            miniLogo.Name = "MiniLogo"
            miniLogo.Parent = ControlsFrame
            miniLogo.AnchorPoint = Vector2.new(0, 0.5)
            miniLogo.Position = UDim2.new(0, 15, 0, 17.5)
            miniLogo.ZIndex = 2000
            miniLogo.Visible = true

            local clonedLogoText = miniLogo:FindFirstChildWhichIsA("TextLabel")
            if clonedLogoText then
                clonedLogoText.Text = '<font color="rgb(248, 191, 212)">Goon</font>Hub'
            end

            if miniButtons:FindFirstChild("close") then miniButtons.close.MouseButton1Click:Connect(closeUI) end
            if miniButtons:FindFirstChild("maximize") then miniButtons.maximize.MouseButton1Click:Connect(function() MaximizeBtn:Activate() end) end
        else
            if miniButtons then miniButtons:Destroy() end
            if miniLogo then miniLogo:Destroy() end
            Content.Visible = true
            Topbar.Visible = true
            DebugBar.Visible = true
            ResizeHandle.Visible = true
        end
    end)

    -- Resize Handle
    local ResizeHandle = New("ImageButton", {
        Name = "Resize",
        Parent = ControlsFrame,
        Size = UDim2.new(0, 35, 0, 35),
        Position = UDim2.new(1, -8, 1, -8),
        AnchorPoint = Vector2.new(1, 1),
        BackgroundTransparency = 1,
        ZIndex = 1005
    })
    New("ImageLabel", {
        Parent = ResizeHandle,
        Size = UDim2.new(1, 0, 1, 0),
        Image = "rbxassetid://88780680171023",
        ImageColor3 = Color3.fromRGB(91, 91, 91),
        BackgroundTransparency = 1
    })

    local resizing, resizeStartPos, resizeStartSize, resizeConn
    ResizeHandle.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            resizing, resizeStartPos, resizeStartSize = true, input.Position, Main.AbsoluteSize
            resizeConn = UserInputService.InputChanged:Connect(function(move)
                if move.UserInputType == Enum.UserInputType.MouseMovement then
                    local delta = move.Position - resizeStartPos
                    Main.Size = UDim2.new(0, math.clamp(resizeStartSize.X + delta.X, 500, 1200), 0, math.clamp(resizeStartSize.Y + delta.Y, 350, 800))
                    if not isMinimized then WindowSize = Main.Size end
                end
            end)
        end
    end)
    UserInputService.InputEnded:Connect(function(input) if input.UserInputType == Enum.UserInputType.MouseButton1 and resizing then resizing = false if resizeConn then resizeConn:Disconnect() end end end)

    -- Floating Toggle Button
    local toggleBtn = New("ImageButton", {
        Name = "GoonToggle",
        Parent = Screen,
        BackgroundColor3 = Color3.fromRGB(36, 36, 36),
        BorderSizePixel = 0,
        Size = UDim2.new(0, 50, 0, 50),
        Position = UDim2.new(0, 20, 0.5, -25),
        Image = "rbxassetid://135630585467568",
        ZIndex = 10000,
        AutoButtonColor = false
    })
    New("UICorner", { CornerRadius = UDim.new(0, 10) }, toggleBtn)
    
    local btnStroke = New("UIStroke", { Thickness = 1.5, Transparency = 0.5, ApplyStrokeMode = Enum.ApplyStrokeMode.Border, Color = Color3.new(1, 1, 1), Parent = toggleBtn })
    local btnGradient = New("UIGradient", { Transparency = NumberSequence.new({ NumberSequenceKeypoint.new(0, 1), NumberSequenceKeypoint.new(0.45, 0), NumberSequenceKeypoint.new(0.55, 0), NumberSequenceKeypoint.new(1, 1) }), Parent = btnStroke })

    task.spawn(function()
        while task.wait() and toggleBtn.Parent do
            btnGradient.Rotation = (btnGradient.Rotation + 0.5) % 360
        end
    end)

    local isToggling = false
    local function animateToggle()
        if isToggling then return end
        isToggling = true
        if Main.Visible then
            local closeT = TweenService:Create(Main, TweenInfo.new(0.3, Enum.EasingStyle.Back, Enum.EasingDirection.In), { Size = UDim2.new(0, 0, 0, 0) })
            closeT:Play()
            closeT.Completed:Connect(function() Main.Visible = false isToggling = false end)
        else
            Main.Size = UDim2.new(0, 0, 0, 0)
            Main.Visible = true
            local openT = TweenService:Create(Main, TweenInfo.new(0.4, Enum.EasingStyle.Back, Enum.EasingDirection.Out), { Size = isMinimized and UDim2.new(0, 260, 0, 35) or WindowSize })
            openT:Play()
            openT.Completed:Connect(function() isToggling = false end)
        end
    end

    local btnDrag, btnDragStart, btnStartPos, btnTargetPos = false, nil, nil, UDim2.new(0, 20, 0.5, -25)
    toggleBtn.InputBegan:Connect(function(i) if i.UserInputType == Enum.UserInputType.MouseButton1 then btnDrag, btnDragStart, btnStartPos = true, i.Position, toggleBtn.Position end end)
    UserInputService.InputChanged:Connect(function(i) if btnDrag and i.UserInputType == Enum.UserInputType.MouseMovement then local d = i.Position - btnDragStart btnTargetPos = UDim2.new(btnStartPos.X.Scale, btnStartPos.X.Offset + d.X, btnStartPos.Y.Scale, btnStartPos.Y.Offset + d.Y) end end)
    UserInputService.InputEnded:Connect(function(i) if i.UserInputType == Enum.UserInputType.MouseButton1 then if btnDrag then if (i.Position - btnDragStart).Magnitude < 5 then animateToggle() end end btnDrag = false end end)
    RunService.RenderStepped:Connect(function() toggleBtn.Position = toggleBtn.Position:Lerp(btnTargetPos, 0.08) end)

    -- Stats Loop (FPS/Ping/Mem)
    task.spawn(function()
        while task.wait(1) and Screen.Parent do
            local fps = math.floor(1 / RunService.RenderStepped:Wait())
            FPSLabel.Text = "FPS: " .. fps .. "/s"
            PingLabel.Text = math.floor(game:GetService("Stats").PerformanceStats.Ping:GetValue()) .. " ms"
            MemoryLabel.Text = string.format("%.1f MB", game:GetService("Stats"):GetTotalMemoryUsageMb())
            TimeLabel.Text = os.date("%I:%M %p")
        end
    end)

    -- Dragging Logic
    local dragging, dragStart, startPos, windowTargetPos = false, nil, nil, Main.Position
    Topbar.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 and not resizing then
            dragging, dragStart, startPos = true, input.Position, Main.Position
        end
    end)
    UserInputService.InputChanged:Connect(function(input)
        if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
            local delta = input.Position - dragStart
            windowTargetPos = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        end
    end)
    UserInputService.InputEnded:Connect(function(input) if input.UserInputType == Enum.UserInputType.MouseButton1 then dragging = false end end)
    RunService.RenderStepped:Connect(function() if dragging and windowTargetPos then Main.Position = Main.Position:Lerp(windowTargetPos, 0.08) end end)

    -- Return Options (API)
    local Options = { LastSection = {} }

    function Options:AddTabSection(data)
        StoredInfo.Sections[data.Name] = data.Order or 0

        New("TextLabel", {
            Parent = NavScroll,
            Size = UDim2.new(1, 0, 0, 20),
            Text = data.Name:upper(),
            FontFace = Fonts.bold,
            TextSize = 12,
            TextColor3 = Color3.fromRGB(
                120, 
                120, 
                120
            ),
            BackgroundTransparency = 1,
            LayoutOrder = data.Order or 0
        })
    end


    function Options:AddTab(data)
        local ParentContainer = data.Fixed and AnchoredMain or NavScroll
        local TabTitle = data.Title or "Tab"

        local tabBtn = New("TextButton", {
            Parent = ParentContainer,
            Size = UDim2.new(
                1, 
                data.Fixed and 0 or -10, 
                0, 
                35
            ),
            BackgroundColor3 = CurrentTheme.Interactables,
            BackgroundTransparency = 1,
            Text = "  " .. TabTitle,
            FontFace = Fonts.med,
            TextSize = 14,
            TextColor3 = CurrentTheme.Tab,
            LayoutOrder = StoredInfo.Sections[data.Section] or 0,
            TextXAlignment = Enum.TextXAlignment.Left
        })
        New("UICorner", { CornerRadius = UDim.new(0, 8) }, tabBtn)

        local page = New("ScrollingFrame", {
            Parent = PageHolder,
            Size = UDim2.new(1, 0, 1, 0),
            BackgroundTransparency = 1,
            ScrollBarThickness = 0,
            AutomaticCanvasSize = Enum.AutomaticSize.Y
        })

        New("UIListLayout", {
            Padding = UDim.new(0, 10),
            HorizontalAlignment = Enum.HorizontalAlignment.Center
        }, page)

        New("UIPadding", {
            PaddingTop = UDim.new(
                0, 
                10
            ),
            PaddingBottom = UDim.new(
                0, 
                10
            )
        }, page)

        tabBtn.MouseButton1Click:Connect(function()
            -- Reset all buttons in both containers
            local function ResetButtons(folder)
                for _, btn in pairs(folder:GetChildren()) do
                    if btn:IsA("TextButton") then
                        Tween(btn, 0.2, { BackgroundTransparency = 1 })
                    end
                end
            end

            ResetButtons(NavScroll)
            ResetButtons(AnchoredMain)

            -- Activate current
            Pages:JumpTo(page)
            Tween(tabBtn, 0.2, { BackgroundTransparency = 0.8 })
        end)

        local TabObj = { Page = page }
        Options.LastSection[TabObj] = Options:AddSection({ Name = "General", Tab = TabObj })
        return TabObj
    end

    function Options:AddSection(data)
        local sec = New("Frame", {
            Parent = data.Tab.Page,
            Size = UDim2.new(1, -20, 0, 0),
            AutomaticSize = Enum.AutomaticSize.Y,
            BackgroundColor3 = CurrentTheme.Secondary,
            BackgroundTransparency = 0.5
        })
        New("UICorner", { CornerRadius = UDim.new(0, 10) }, sec)

        New("UIListLayout", { 
            Padding = UDim.new(0, 5), 
            HorizontalAlignment = Enum.HorizontalAlignment.Center 
        }, sec)

        New("UIPadding", { 
            PaddingTop = UDim.new(0, 10), 
            PaddingBottom = UDim.new(0, 10) 
        }, sec)
        
        New("TextLabel", {
            Parent = sec,
            Size = UDim2.new(1, -20, 0, 20),
            Text = data.Name,
            FontFace = Fonts.bold,
            TextSize = 14,
            TextColor3 = CurrentTheme.Accent,
            BackgroundTransparency = 1,
            TextXAlignment = Enum.TextXAlignment.Left
        })

        Options.LastSection[data.Tab] = sec
        return sec
    end

    function Options:AddButton(data)
        local target = Options.LastSection[data.Tab]
        local btn = New("TextButton", {
            Parent = target,
            Size = UDim2.new(1, -20, 0, 35),
            BackgroundColor3 = CurrentTheme.Component,
            Text = data.Title,
            TextColor3 = CurrentTheme.Title,
            FontFace = Fonts.reg,
            TextSize = 14
        })
        New("UICorner", { CornerRadius = UDim.new(0, 6) }, btn)
        
        if data.Description then
            btn.ToolTip = data.Description -- Falls Tooltips existieren
        end

        Animations:Component(btn)

        btn.MouseButton1Click:Connect(function()
            if data.Callback then data.Callback() end
        end)
    end

    function Options:AddToggle(data)
        local target = Options.LastSection[data.Tab]
        local state = data.Default or false
        
        local frame = New("TextButton", {
            Parent = target,
            Size = UDim2.new(1, -20, 0, 35),
            BackgroundColor3 = CurrentTheme.Component,
            Text = "  " .. data.Title,
            TextColor3 = CurrentTheme.Title,
            FontFace = Fonts.reg,
            TextSize = 14,
            TextXAlignment = Enum.TextXAlignment.Left
        })

        New("UICorner", { CornerRadius = UDim.new(0, 6) }, frame)

        local indicator = New("Frame", {
            Parent = frame,
            Size = UDim2.new(0, 40, 0, 20),
            Position = UDim2.new(1, -50, 0.5, -10),
            BackgroundColor3 = state and CurrentTheme.Accent or Color3.fromRGB(60, 60, 60)
        }, frame)
        New("UICorner", { CornerRadius = UDim.new(1, 0) }, indicator)

        frame.MouseButton1Click:Connect(function()
            state = not state
            
            local targetColor = state and Theme.Accent or Color3.fromRGB(60, 60, 60)
            Tween(indicator, 0.3, { 
                BackgroundColor3 = targetColor 
            })

            if data.Callback then data.Callback(state) end
        end)
    end

    function Options:AddSlider(data)
        local target = Options.LastSection[data.Tab]
        local min, max = data.MinValue or 0, data.MaxValue or 100
        local f = New("Frame", { 
            Parent = target, 
            Size = UDim2.new(1, -20, 0, 50), 
            BackgroundColor3 = CurrentTheme.Component 
        })
        
        New("UICorner", { CornerRadius = UDim.new(0, 6) }, f)

        New("TextLabel", { 
            Parent = f, 
            Size = UDim2.new(
                1, 
                -20, 
                0, 
                20
            ), 
            Position = UDim2.new(0, 10, 0, 5), 
            Text = data.Title, 
            FontFace = Fonts.reg, 
            TextSize = 14, 
            TextColor3 = CurrentTheme.Title, 
            BackgroundTransparency = 1, 
            TextXAlignment = Enum.TextXAlignment.Left 
        })
        
        local bg = New("Frame", { 
            Parent = f, 
            Size = UDim2.new(1, -20, 0, 6), 
            Position = UDim2.new(0, 10, 0, 35), 
            BackgroundColor3 = Color3.fromRGB(60, 60, 60) 
        })

        local fill = New("Frame", { 
            Parent = bg, 
            Size = UDim2.new(0, 0, 1, 0), 
            BackgroundColor3 = CurrentTheme.Accent 
        })
        
        local valLabel = New("TextBox", {
            Parent = f,
            Size = UDim2.new(0, 40, 0, 20),
            Position = UDim2.new(1, -50, 0, 5),
            BackgroundTransparency = 1,
            Text = tostring(data.Default or min),
            TextColor3 = CurrentTheme.Title,
            FontFace = Fonts.reg,
            TextSize = 14,
            TextXAlignment = Enum.TextXAlignment.Right
        })

        local function UpdateSlider(p)
            local raw = min + (max - min) * p
            local value = data.AllowDecimals and (math.floor(raw * 100) / 100) or math.floor(raw)
            
            fill.Size = UDim2.new(p, 0, 1, 0)
            valLabel.Text = tostring(value)
            if data.Callback then data.Callback(value) end
        end

        bg.InputBegan:Connect(function(i)
            if i.UserInputType == Enum.UserInputType.MouseButton1 then
                local conn
                conn = UserInputService.InputChanged:Connect(function(m)
                    if m.UserInputType == Enum.UserInputType.MouseMovement then
                        local p = math.clamp((m.Position.X - bg.AbsolutePosition.X) / bg.AbsoluteSize.X, 0, 1)
                        UpdateSlider(p)
                    end
                end)

                UserInputService.InputEnded:Connect(function(u) 
                    if u.UserInputType == Enum.UserInputType.MouseButton1 then 
                        conn:Disconnect() 
                    end 
                end)
            end
        end)
    end

    function Options:AddInput(data)
        local target = Options.LastSection[data.Tab]
        local f = New("Frame", { 
            Parent = target, 
            Size = UDim2.new(1, -20, 0, 35), 
            BackgroundColor3 = CurrentTheme.Component 
        })

        New("UICorner", { CornerRadius = UDim.new(0, 6) }, f)
        local i = New("TextBox", { 
            Parent = f, Size = UDim2.new(1, -20, 1, 0), Position = UDim2.new(0, 10, 0, 0), 
            BackgroundTransparency = 1, Text = "", PlaceholderText = data.Title .. "...", 
            TextColor3 = CurrentTheme.Title, FontFace = Fonts.reg, TextSize = 14, TextXAlignment = Enum.TextXAlignment.Left 
        })

        i.FocusLost:Connect(function() if data.Callback then data.Callback(i.Text) end end)
    end

    function Options:AddDropdown(data)
        local target = Options.LastSection[data.Tab]
        local f = New("TextButton", { Parent = target, Size = UDim2.new(1, -20, 0, 35), BackgroundColor3 = CurrentTheme.Component, Text = "  " .. data.Title, TextColor3 = CurrentTheme.Title, FontFace = Fonts.reg, TextSize = 14, TextXAlignment = Enum.TextXAlignment.Left })
        New("UICorner", { CornerRadius = UDim.new(0, 6) }, f)

        f.MouseButton1Click:Connect(function() 
            if data.Callback then 
                data.Callback(next(data.Options)) 
            end 
        end)
    end

    function Options:AddKeybind(data)
        local target = Options.LastSection[data.Tab]
        local key = data.Default or Enum.KeyCode.F
        
        local f = New("TextButton", { 
            Parent = target, 
            Size = UDim2.new(1, -20, 0, 35), 
            BackgroundColor3 = CurrentTheme.Component, 
            Text = "  " .. data.Title, 
            TextColor3 = CurrentTheme.Title, 
            FontFace = Fonts.reg, 
            TextSize = 14, 
            TextXAlignment = Enum.TextXAlignment.Left 
        })

        New("UICorner", { CornerRadius = UDim.new(0, 6) }, f)
        
        local l = New("TextLabel", { 
            Parent = f, 
            Size = UDim2.new(0, 60, 0, 20), 
            Position = UDim2.new(1, -70, 0.5, -10), 
            Text = key.Name, 
            BackgroundColor3 = Color3.fromRGB(60, 60, 60), 
            TextColor3 = CurrentTheme.Title 
        })

        f.MouseButton1Click:Connect(function()
            l.Text = "..."
            local c
            c = UserInputService.InputBegan:Connect(function(i)
                if i.UserInputType == Enum.UserInputType.Keyboard then
                    key = i.KeyCode
                    l.Text = key.Name
                    if data.Callback then data.Callback(key) end
                    c:Disconnect()
                end
            end)
        end)
    end

    function Options:AddParagraph(data)
        local target = Options.LastSection[data.Tab]
        local f = New("Frame", { 
            Parent = target, 
            Size = UDim2.new(1, -20, 0, 0), 
            AutomaticSize = Enum.AutomaticSize.Y, 
            BackgroundColor3 = CurrentTheme.Secondary 
        })

        New("UICorner", { CornerRadius = UDim.new(0, 6) }, f)

        New("UIPadding", { 
            PaddingTop = UDim.new(0, 8), 
            PaddingBottom = UDim.new(0, 8), 
            PaddingLeft = UDim.new(0, 10), 
            PaddingRight = UDim.new(0, 10) 
        }, f)

        New("UIListLayout", { Padding = UDim.new(0, 2) }, f)

        New("TextLabel", { 
            Parent = f, 
            Size = UDim2.new(1, 0, 0, 18), 
            Text = data.Title, 
            FontFace = Fonts.bold, 
            TextSize = 14, 
            TextColor3 = CurrentTheme.Title, 
            BackgroundTransparency = 1, 
            TextXAlignment = Enum.TextXAlignment.Left 
        })

        New("TextLabel", { 
            Parent = f, 
            Size = UDim2.new(1, 0, 0, 0), 
            AutomaticSize = Enum.AutomaticSize.Y, 
            Text = data.Description, 
            FontFace = Fonts.reg, 
            TextSize = 13, 
            TextColor3 = CurrentTheme.Description, 
            BackgroundTransparency = 1, 
            TextXAlignment = Enum.TextXAlignment.Left, 
            TextWrapped = true 
        })
    end

    function Options:Notify(data)
        local h = Screen:FindFirstChild("Notifs") or New("Frame", { 
            Name = "Notifs", 
            Position = UDim2.new(1, -330, 0, 20), 
            Size = UDim2.new(0, 310, 1, -40), 
            BackgroundTransparency = 1 
        }, Screen)

        if not h:FindFirstChild("Layout") then 
            New("UIListLayout", { 
                Name = "Layout", 
                Padding = UDim.new(0, 10), 
                VerticalAlignment = Enum.VerticalAlignment.Top 
            }, h) 
        end
        
        local b = New("CanvasGroup", { 
            Size = UDim2.new(1, 0, 0, 60), 
            BackgroundColor3 = CurrentTheme.Secondary, 
            GroupTransparency = 1 
        }, h)

        New("UICorner", { CornerRadius = UDim.new(0, 10) }, b)

        New("TextLabel", { 
            Parent = b, 
            Size = UDim2.new(1, -20, 1, 0), 
            Position = UDim2.new(0, 10, 0, 0), 
            Text = data.Description, 
            TextColor3 = CurrentTheme.Title, 
            BackgroundTransparency = 1, 
            TextWrapped = true, 
            FontFace = Fonts.reg, 
            TextSize = 14 
        })
        
        Tween(b, 0.4, { 
            GroupTransparency = 0 
        })

        task.delay(data.Duration or 5, function()
            Tween(b, 0.4, { 
                GroupTransparency = 1 
            })
            task.wait(0.4)
            b:Destroy()
        end)
    end

    function Options:SetSetting(k, v)
        if k == "Transparency" then Main.BackgroundTransparency = v end
        if k == "Keybind" then Setup.Keybind = v end
        if k == "Blur" then Setup.Blur = v end
    end

    function Options:SetTheme(themeData)
        CurrentTheme = themeData
        Main.BackgroundColor3 = CurrentTheme.Main or CurrentTheme.Primary
        
        -- Recursive Update for existing elements
        for _, obj in pairs(Screen:GetDescendants()) do
            if obj:IsA("TextLabel") or obj:IsA("TextBox") then
                if obj.TextColor3 ~= Color3.new(1, 1, 1) and obj.TextColor3 ~= Color3.new(0.6, 0.6, 0.6) then
                    obj.TextColor3 = CurrentTheme.Accent
                end
            elseif obj:IsA("Frame") and obj.Name == "selector" then
                obj.BackgroundColor3 = Color3.fromRGB(41, 41, 41)
            elseif obj:IsA("ScrollingFrame") and obj.Name == "Navigation" then
                -- Specific logic for nav
            end
        end

        Options:Notify({
            Title = "Theme Applied",
            Description = "The UI colors have been updated.",
            Duration = 3
        })
    end

    function Options:SetSetting(k, v)
        if k == "Transparency" then 
            Main.BackgroundTransparency = v 
        end
        if k == "Keybind" then Setup.Keybind = v end
        if k == "Blur" then Setup.Blur = v end
    end

    UserInputService.InputBegan:Connect(function(input, gpe)
        if not gpe and input.KeyCode == Setup.Keybind then
            Main.Visible = not Main.Visible
        end
    end)

    -- Initialization
    task.defer(function()
        -- Settings Tab
        local SettingsTab = Options:AddTab({ Title = "Settings", Fixed = true })
        Options:AddSection({ Name = "UI Configuration", Tab = SettingsTab })
        
        local ThemeList = {}
        for Name, _ in next, Themes do table.insert(ThemeList, Name) end

        Options:AddDropdown({
            Title = "Theme Selector",
            Tab = SettingsTab,
            Options = ThemeList,
            Callback = function(ThemeName)
                if Themes[ThemeName] then
                    Options:SetTheme(Themes[ThemeName])
                end
            end
        })

        -- About Tab
        local AboutTab = Options:AddTab({ Title = "About", Fixed = true })
        Options:AddSection({ Name = "Information", Tab = AboutTab })
        
        Options:AddParagraph({
            Title = "GoonHub Standalone",
            Description = "Version 1.0.0\nDeveloped for high performance and clarity.",
            Tab = AboutTab
        })
    end)

    SetProperty(Main, { Size = WindowSize, Visible = true })
    Animations:Open(Main, Transparency)

    return Options
end

return Library
