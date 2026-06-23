-- Moon UI Mainframe (based on Moon Admin UI design, preserves Orbit API)
return function(mainfunctions, components)
    local RunService = game:GetService("RunService")
    local TweenService = game:GetService("TweenService")
    local CollectionService = game:GetService("CollectionService")
    local Library = {}
    Library.TabCount = 0
    Library.Themes = mainfunctions.Themes

    local NotificationSystem = components.notification(mainfunctions)
    function Library:Notify(config)
        return NotificationSystem:Notify(config)
    end

function Library:CreateWindow(config)
    config = config or {}
    local title = config.Title or "Ui"
    local versionText = config.Version or "1.0.0"
    local defaultTheme = config.Theme or "Dark"
    local logo = config.Logo or "<font color=\"rgb(248, 191, 212)\">U</font>i"
    local secondaryLogo = config.SecondaryLogo or string.format("| %s %s", title, versionText)

    mainfunctions.Themes = config.Themes or {
        Dark = { Main = Color3.fromRGB(27, 27, 27), Accent = Color3.fromRGB(248, 191, 212) }
    }
    Library.Themes = mainfunctions.Themes

    local New = mainfunctions.New
    local fonts = mainfunctions.GetFonts()
    local G2L = {}

    local Players = game:GetService("Players")
    local LocalPlayer = Players.LocalPlayer
    local userId = LocalPlayer and LocalPlayer.UserId or 1
    local displayName = LocalPlayer and LocalPlayer.DisplayName or "Offline Developer"
    local userName = LocalPlayer and LocalPlayer.Name or "dev"

    local targetParent = (gethui and gethui()) or game:GetService("CoreGui") or (LocalPlayer and LocalPlayer:WaitForChild("PlayerGui"))
    if not targetParent then
        error("UiLibary: Could not locate a valid GUI parent container.")
    end

    if targetParent:FindFirstChild("UiLibary") then
        targetParent["UiLibary"]:Destroy()
    end

    G2L["1"] = New("ScreenGui", {
        IgnoreGuiInset = true,
        Name = "UiLibary",
        ResetOnSpawn = false,
        ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    }, targetParent)

    -- Main Frame (Moon-style 9-slice ImageButton)
    G2L["2"] = New("ImageButton", {
        AnchorPoint = Vector2.new(0.5, 0.5),
        Size = UDim2.new(0, 900, 0, 500),
        Position = UDim2.new(0.5, 0, 0.5, 0),
        Name = "Main",
        ClipsDescendants = true,
        BackgroundTransparency = 1,
        Image = "rbxassetid://125088425775676",
        ImageColor3 = Color3.fromRGB(27, 27, 27),
        ImageTransparency = 0.05,
        ScaleType = Enum.ScaleType.Slice,
        SliceCenter = Rect.new(512, 512, 512, 512),
        AutoButtonColor = false,
        Visible = true
    }, G2L["1"])

    G2L["scale"] = New("UIScale", {Scale = 1}, G2L["2"])

    -- Loading overlay (hidden by default)
    G2L["loading"] = New("Frame", {
        Size = UDim2.new(1, 0, 1, 0),
        Position = UDim2.new(0.5, 0, 0.5, 0),
        AnchorPoint = Vector2.new(0.5, 0.5),
        BackgroundTransparency = 1,
        Visible = false,
        ZIndex = 9999,
        Name = "loading"
    }, G2L["2"])

    New("ImageLabel", {
        Size = UDim2.new(0, 140, 0, 40),
        Position = UDim2.new(0.5, 0, 0.5, -15),
        AnchorPoint = Vector2.new(0.5, 0.5),
        Image = "rbxassetid://107452377367726",
        BackgroundTransparency = 1
    }, G2L["loading"])

    -- Empty frame (Moon has this)
    G2L["empty"] = New("Frame", {
        Size = UDim2.new(1, 0, 1, 0),
        Position = UDim2.new(0.5, 0, 0.5, 0),
        AnchorPoint = Vector2.new(0.5, 0.5),
        BackgroundTransparency = 1,
        Name = "empty"
    }, G2L["2"])

    -- Content container
    G2L["content"] = New("Frame", {
        Size = UDim2.new(1, 0, 1, 0),
        Position = UDim2.new(0.5, 0, 0.5, 0),
        AnchorPoint = Vector2.new(0.5, 0.5),
        BackgroundTransparency = 1,
        Name = "content"
    }, G2L["2"])

    New("UICorner", {CornerRadius = UDim.new(0, 18)}, G2L["content"])

    -- Navigation Sidebar (Moon-style)
    G2L["navigation"] = New("ImageButton", {
        Size = UDim2.new(0, 220, 1, 0),
        Position = UDim2.new(0, 0, 0, 0),
        BackgroundTransparency = 1,
        ClipsDescendants = true,
        Name = "navigation",
        AutoButtonColor = false,
        ZIndex = 99
    }, G2L["content"])

    -- Navigation padding
    local navUIList = New("UIListLayout", {
        FillDirection = Enum.FillDirection.Vertical,
        SortOrder = Enum.SortOrder.LayoutOrder,
        Padding = UDim.new(0, 0)
    }, G2L["navigation"])

    -- User Section (Moon-style user card)
    G2L["user"] = New("Frame", {
        Size = UDim2.new(1, 0, 0, 104),
        BackgroundTransparency = 1,
        Name = "user",
        LayoutOrder = 1
    }, G2L["navigation"])

    New("UIPadding", {
        PaddingLeft = UDim.new(0, 8),
        PaddingRight = UDim.new(0, 8),
        PaddingTop = UDim.new(0, 50)
    }, G2L["user"])

    G2L["user_frame"] = New("ImageButton", {
        Size = UDim2.new(1, 0, 1, 0),
        BackgroundTransparency = 1,
        Name = "frame",
        AutoButtonColor = false,
        Image = "rbxassetid://125088425775676",
        ImageColor3 = Color3.fromRGB(34, 34, 34),
        ScaleType = Enum.ScaleType.Slice,
        SliceCenter = Rect.new(512, 512, 512, 512)
    }, G2L["user"])

    local userInnerList = New("UIListLayout", {
        FillDirection = Enum.FillDirection.Horizontal,
        VerticalAlignment = Enum.VerticalAlignment.Center,
        Padding = UDim.new(0, 10)
    }, G2L["user_frame"])

    New("UIPadding", {
        PaddingLeft = UDim.new(0, 15),
        PaddingRight = UDim.new(0, 15)
    }, G2L["user_frame"])

    G2L["avatar"] = New("ImageLabel", {
        Size = UDim2.new(0, 26, 0, 26),
        Image = "rbxthumb://type=AvatarHeadShot&id=" .. userId .. "&w=150&h=150",
        BackgroundTransparency = 1,
        BackgroundColor3 = Color3.fromRGB(36, 36, 36)
    }, G2L["user_frame"])

    New("UICorner", {CornerRadius = UDim.new(1, 0)}, G2L["avatar"])

    local userInfoFrame = New("Frame", {
        Size = UDim2.new(0, 0, 1, 0),
        BackgroundTransparency = 1
    }, G2L["user_frame"])

    New("UIListLayout", {VerticalAlignment = Enum.VerticalAlignment.Center}, userInfoFrame)
    New("UIFlexItem", {FlexMode = Enum.UIFlexMode.Fill}, userInfoFrame)

    G2L["display_name"] = New("TextLabel", {
        Size = UDim2.new(1, 0, 0, 15),
        Text = displayName,
        FontFace = fonts.bold,
        TextSize = 13,
        TextColor3 = Color3.new(1, 1, 1),
        BackgroundTransparency = 1,
        TextXAlignment = Enum.TextXAlignment.Left,
        TextTruncate = Enum.TextTruncate.AtEnd
    }, userInfoFrame)

    G2L["user_role"] = New("TextLabel", {
        Size = UDim2.new(0, 0, 0, 20),
        Text = "  User  ",
        FontFace = fonts.reg,
        TextSize = 11,
        TextColor3 = Color3.new(1, 1, 1),
        BackgroundColor3 = Color3.fromRGB(72, 72, 72),
        BackgroundTransparency = 0,
        TextXAlignment = Enum.TextXAlignment.Left,
        AutomaticSize = Enum.AutomaticSize.X
    }, userInfoFrame)
    New("UICorner", {CornerRadius = UDim.new(0, 20)}, G2L["user_role"])

    -- Fixed buttons (system, exe_flow) - Moon-style
    G2L["fixed_buttons"] = New("Frame", {
        Size = UDim2.new(1, 0, 0, 0),
        AutomaticSize = Enum.AutomaticSize.Y,
        BackgroundTransparency = 1,
        Name = "fixed_buttons",
        LayoutOrder = 2,
        AnchorPoint = Vector2.new(0, 1),
        Position = UDim2.new(0, 0, 1, 0),
        ZIndex = 2
    }, G2L["navigation"])

    New("UIListLayout", {
        FillDirection = Enum.FillDirection.Vertical,
        SortOrder = Enum.SortOrder.LayoutOrder,
        Padding = UDim.new(0, 4)
    }, G2L["fixed_buttons"])

    New("UIPadding", {
        PaddingLeft = UDim.new(0, 8),
        PaddingRight = UDim.new(0, 8),
        PaddingBottom = UDim.new(0, 4)
    }, G2L["fixed_buttons"])

    local function CreateFixedButton(name, iconId, labelText, isFullWidth)
        local btn = New("ImageButton", {
            Name = name,
            Size = isFullWidth and UDim2.new(1, 0, 0, 36) or UDim2.new(0, 0, 0, 36),
            BackgroundTransparency = 1,
            LayoutOrder = 1,
            AutoButtonColor = false,
            Visible = true
        }, G2L["fixed_buttons"])

        local bg = New("ImageLabel", {
            Size = UDim2.new(1, 0, 1, 0),
            BackgroundColor3 = Color3.fromRGB(34, 34, 34),
            BackgroundTransparency = 0,
            Name = "bg"
        }, btn)

        New("UICorner", {CornerRadius = UDim.new(1, 0)}, bg)
        New("UIStroke", {Color = Color3.new(1, 1, 1), Transparency = 1, Thickness = 1}, bg)

        New("UIListLayout", {
            FillDirection = Enum.FillDirection.Horizontal,
            VerticalAlignment = Enum.VerticalAlignment.Center,
            Padding = UDim.new(0, 8)
        }, btn)

        New("UIPadding", {PaddingLeft = UDim.new(0, 10), PaddingRight = UDim.new(0, 10)}, btn)

        local icon = New("ImageLabel", {
            Size = UDim2.new(0, 16, 0, 16),
            Image = "rbxassetid://" .. iconId,
            BackgroundTransparency = 1
        }, btn)

        local lbl = New("TextLabel", {
            Text = labelText,
            FontFace = fonts.med,
            TextSize = 14,
            TextColor3 = Color3.new(1, 1, 1),
            BackgroundTransparency = 1,
            TextXAlignment = Enum.TextXAlignment.Left
        }, btn)

        New("UIFlexItem", {FlexMode = Enum.UIFlexMode.Fill}, lbl)

        return btn
    end

    G2L["fixed_system"] = CreateFixedButton("system", "11433532654", "System", true)
    G2L["fixed_exe"] = CreateFixedButton("exe_flow", "11433532654", "Exe. Flow", false)
    G2L["fixed_exe"].Visible = false

    -- Navigation Directory (ScrollingFrame for tab buttons)
    G2L["directory"] = New("ScrollingFrame", {
        Size = UDim2.new(1, -20, 1, -120),
        Position = UDim2.new(0.5, 0, 1, -10),
        AnchorPoint = Vector2.new(0.5, 1),
        BackgroundTransparency = 1,
        ScrollBarThickness = 0,
        AutomaticCanvasSize = Enum.AutomaticSize.Y,
        Name = "directory",
        LayoutOrder = 4
    }, G2L["navigation"])

    -- primary Frame: actual tab button container (matches Moon G2L structure)
    G2L["primary"] = New("Frame", {
        Size = UDim2.new(1, 0, 0, 0),
        AutomaticSize = Enum.AutomaticSize.Y,
        BackgroundTransparency = 1,
        Name = "primary"
    }, G2L["directory"])

    New("UIListLayout", {
        Padding = UDim.new(0, 2),
        SortOrder = Enum.SortOrder.LayoutOrder
    }, G2L["primary"])

    New("UIPadding", {
        PaddingLeft = UDim.new(0, 8),
        PaddingRight = UDim.new(0, 8),
        PaddingTop = UDim.new(0, 6),
        PaddingBottom = UDim.new(0, 6)
    }, G2L["primary"])

    -- util Folder for badges (Moon has this in primary)
    G2L["util"] = New("Folder", {Name = "util"}, G2L["primary"])

    -- Divider between primary and rest
    New("Frame", {
        Size = UDim2.new(1, -22, 0, 1),
        BackgroundColor3 = Color3.fromRGB(255, 255, 255),
        BackgroundTransparency = 0.9,
        Name = "divider",
        LayoutOrder = 999
    }, G2L["primary"])

    -- Flex fill for directory (fills remaining space in navigation layout)
    New("UIFlexItem", {FlexMode = Enum.UIFlexMode.Fill}, G2L["directory"])

    -- Screen (CanvasGroup - main content area)
    G2L["screen"] = New("CanvasGroup", {
        Size = UDim2.new(1, -225, 1, -10),
        Position = UDim2.new(1, -5, 1, -5),
        AnchorPoint = Vector2.new(1, 1),
        BackgroundTransparency = 0,
        BackgroundColor3 = Color3.fromRGB(35, 35, 35),
        GroupTransparency = 0,
        ClipsDescendants = true,
        Name = "screen"
    }, G2L["content"])

    New("UICorner", {CornerRadius = UDim.new(0, 20)}, G2L["screen"])

    -- UIPageLayout for tabs (in the screen)
    G2L["pagelayout"] = New("UIPageLayout", {
        SortOrder = Enum.SortOrder.LayoutOrder,
        Animated = true,
        EasingStyle = Enum.EasingStyle.Quart,
        EasingDirection = Enum.EasingDirection.Out,
        TweenTime = 0.45,
        ScrollWheelInputEnabled = false,
        TouchInputEnabled = false
    }, G2L["screen"])

    -- LeafletControls (window control overlay - Moon-style)
    G2L["leaflet"] = New("Frame", {
        Size = UDim2.new(1, 0, 1, 0),
        Position = UDim2.new(0.5, 0, 0.5, 0),
        AnchorPoint = Vector2.new(0.5, 0.5),
        BackgroundTransparency = 1,
        Name = "LeafletControls",
        ZIndex = 100
    }, G2L["content"])

    New("UICorner", {CornerRadius = UDim.new(0, 0)}, G2L["leaflet"])

    -- Leaflet Top (actions + clock)
    G2L["leaflet_top"] = New("Frame", {
        Size = UDim2.new(1, 0, 0, 50),
        Position = UDim2.new(0, 0, 0, 0),
        BackgroundTransparency = 1,
        Name = "Top"
    }, G2L["leaflet"])

    New("UIListLayout", {
        FillDirection = Enum.FillDirection.Horizontal,
        VerticalAlignment = Enum.VerticalAlignment.Center,
        Padding = UDim.new(0, 10)
    }, G2L["leaflet_top"])

    New("UIPadding", {
        PaddingTop = UDim.new(0, 10),
        PaddingRight = UDim.new(0, 15),
        PaddingLeft = UDim.new(0, 10),
        PaddingBottom = UDim.new(0, 10)
    }, G2L["leaflet_top"])

    -- Tracking icon (like Moon's tracking indicator)
    G2L["tracking_icon"] = New("ImageLabel", {
        Size = UDim2.new(0, 20, 0, 20),
        Image = "rbxassetid://72548733587158",
        BackgroundTransparency = 1,
        LayoutOrder = 1
    }, G2L["leaflet_top"])

    -- Clock
    G2L["clock"] = New("ImageLabel", {
        Size = UDim2.new(0, 0, 0, 24),
        BackgroundTransparency = 1,
        AutomaticSize = Enum.AutomaticSize.X,
        Name = "Clock",
        LayoutOrder = 2
    }, G2L["leaflet_top"])

    G2L["time_text"] = New("TextLabel", {
        Size = UDim2.new(0, 0, 1, 0),
        Text = os.date("%I:%M %p"),
        FontFace = fonts.med,
        TextSize = 14,
        TextColor3 = Color3.new(1, 1, 1),
        BackgroundTransparency = 1,
        AutomaticSize = Enum.AutomaticSize.X
    }, G2L["clock"])

    -- Spacer
    local leafletSpacer = New("Frame", {
        BackgroundTransparency = 1,
        LayoutOrder = 3
    }, G2L["leaflet_top"])
    New("UIFlexItem", {FlexMode = Enum.UIFlexMode.Fill}, leafletSpacer)

    -- Action buttons (Moon-style: 30x30 ImageButton → 24x24 ImageLabel container)
    G2L["actions_frame"] = New("ImageButton", {
        Size = UDim2.new(0, 0, 0, 0),
        AutomaticSize = Enum.AutomaticSize.X,
        BackgroundTransparency = 1,
        Name = "Actions",
        LayoutOrder = 4,
        AutoButtonColor = false,
        ZIndex = 3
    }, G2L["leaflet_top"])

    G2L["actions_container"] = New("Frame", {
        Size = UDim2.new(0, 0, 0, 32),
        AutomaticSize = Enum.AutomaticSize.X,
        BackgroundColor3 = Color3.fromRGB(35, 35, 35),
        BackgroundTransparency = 0,
        Name = "Container"
    }, G2L["actions_frame"])

    New("UICorner", {CornerRadius = UDim.new(1, 0)}, G2L["actions_container"])
    local containerStroke = New("UIStroke", {
        Color = Color3.new(1, 1, 1),
        Thickness = 1,
        Transparency = 0.85
    }, G2L["actions_container"])
    local containerGradient = New("UIGradient", {
        Transparency = NumberSequence.new({
            NumberSequenceKeypoint.new(0, 1),
            NumberSequenceKeypoint.new(0.45, 0),
            NumberSequenceKeypoint.new(0.55, 0),
            NumberSequenceKeypoint.new(1, 1)
        })
    }, containerStroke)
    mainfunctions.RegisterGradient(containerGradient, 6)

    New("UIListLayout", {
        FillDirection = Enum.FillDirection.Horizontal,
        VerticalAlignment = Enum.VerticalAlignment.Center,
        Padding = UDim.new(0, 0)
    }, G2L["actions_container"])
    New("UIPadding", {PaddingLeft = UDim.new(0, 6), PaddingRight = UDim.new(0, 6)}, G2L["actions_container"])

    local function CreateActionButton(name, iconId)
        local btn = New("ImageButton", {
            Name = name,
            Size = UDim2.new(0, 30, 0, 30),
            BackgroundTransparency = 1,
            AutoButtonColor = false
        }, G2L["actions_container"])

        local container = New("ImageLabel", {
            Size = UDim2.new(0, 24, 0, 24),
            Position = UDim2.new(0.5, 0, 0.5, 0),
            AnchorPoint = Vector2.new(0.5, 0.5),
            BackgroundTransparency = 1,
            ImageTransparency = 0,
            ImageColor3 = Color3.fromRGB(44, 44, 44),
            Name = "container"
        }, btn)

        New("UICorner", {CornerRadius = UDim.new(1, 0)}, container)

        local iconStroke = New("UIStroke", {
            Color = Color3.new(1, 1, 1),
            Thickness = 1,
            Transparency = 0.9
        }, container)
        local iconGradient = New("UIGradient", {
            Transparency = NumberSequence.new({
                NumberSequenceKeypoint.new(0, 1),
                NumberSequenceKeypoint.new(0.45, 0),
                NumberSequenceKeypoint.new(0.55, 0),
                NumberSequenceKeypoint.new(1, 1)
            })
        }, iconStroke)
        mainfunctions.RegisterGradient(iconGradient, 6)

        local icon = New("ImageLabel", {
            Size = UDim2.new(0, 14, 0, 14),
            Position = UDim2.new(0.5, 0, 0.5, 0),
            AnchorPoint = Vector2.new(0.5, 0.5),
            Image = "rbxassetid://" .. iconId,
            BackgroundTransparency = 1,
            Name = "icon"
        }, container)

        btn.MouseEnter:Connect(function()
            TweenService:Create(container, TweenInfo.new(0.3, Enum.EasingStyle.Exponential), {ImageColor3 = Color3.fromRGB(34, 34, 34)}):Play()
        end)
        btn.MouseButton1Down:Connect(function()
            TweenService:Create(container, TweenInfo.new(0.3, Enum.EasingStyle.Exponential), {ImageColor3 = Color3.fromRGB(20, 20, 20)}):Play()
        end)
        btn.InputEnded:Connect(function()
            TweenService:Create(container, TweenInfo.new(0.3, Enum.EasingStyle.Exponential), {ImageColor3 = Color3.fromRGB(44, 44, 44)}):Play()
        end)

        return btn
    end

    G2L["close_btn"] = CreateActionButton("close", "72895544872618")
    G2L["fullscreen_btn"] = CreateActionButton("fullscreen", "11295287158")
    G2L["menu_btn"] = CreateActionButton("menu", "11295285432")
    G2L["restore_btn"] = CreateActionButton("restore", "11963366999")
    G2L["restore_btn"].Visible = false

    -- Leaflet Space (clickable area to dismiss controls)
    G2L["leaflet_space"] = New("Frame", {
        Size = UDim2.new(1, 0, 1, -50),
        Position = UDim2.new(0, 0, 0, 50),
        BackgroundTransparency = 1,
        Name = "Space"
    }, G2L["leaflet"])

    -- Leaflet Bottom (with Resize handle)
    G2L["leaflet_bottom"] = New("Frame", {
        Size = UDim2.new(0, 50, 0, 50),
        Position = UDim2.new(1, 0, 1, 0),
        AnchorPoint = Vector2.new(1, 1),
        BackgroundTransparency = 1,
        Name = "Bottom"
    }, G2L["leaflet"])


    G2L["b"] = New("ImageButton", {
        Size = UDim2.new(0, 0, 0, 0),
        AutomaticSize = Enum.AutomaticSize.X,
        Position = UDim2.new(1, 0, 1, 0),
        AnchorPoint = Vector2.new(1, 1),
        BackgroundTransparency = 1,
        Name = "resize"
    }, G2L["leaflet_bottom"])
    CollectionService:AddTag(G2L["b"], "Exe6ResizeHandle")

    New("UIPadding", {
        PaddingRight = UDim.new(0, 8),
        PaddingBottom = UDim.new(0, 8)
    }, G2L["b"])

    New("ImageLabel", {
        Size = UDim2.new(0, 18, 0, 18),
        Image = "rbxassetid://86527207319523",
        BackgroundTransparency = 1,
        Name = "icon",
        ScaleType = Enum.ScaleType.Slice,
        SliceScale = 0.5
    }, G2L["b"])

    -- Stats overlay (inside leaflet, outside leaflet_top layout)
    G2L["stats_frame"] = New("Frame", {
        Size = UDim2.new(0, 0, 0, 0),
        Position = UDim2.new(1, -10, 0, 58),
        AnchorPoint = Vector2.new(1, 0),
        BackgroundTransparency = 1,
        AutomaticSize = Enum.AutomaticSize.X,
        Name = "stats",
        ZIndex = 100
    }, G2L["leaflet"])

    local statsList = New("UIListLayout", {
        FillDirection = Enum.FillDirection.Horizontal,
        VerticalAlignment = Enum.VerticalAlignment.Center,
        Padding = UDim.new(0, 12)
    }, G2L["stats_frame"])

    G2L["fps_label"] = New("TextLabel", {
        Text = "FPS: 0",
        FontFace = fonts.med,
        TextSize = 12,
        TextColor3 = Color3.fromRGB(200, 200, 200),
        BackgroundTransparency = 1,
        AutomaticSize = Enum.AutomaticSize.X
    }, G2L["stats_frame"])

    G2L["ping_label"] = New("TextLabel", {
        Text = "0 ms",
        FontFace = fonts.med,
        TextSize = 12,
        TextColor3 = Color3.fromRGB(200, 200, 200),
        BackgroundTransparency = 1,
        AutomaticSize = Enum.AutomaticSize.X
    }, G2L["stats_frame"])

    G2L["mem_label"] = New("TextLabel", {
        Text = "0 MB",
        FontFace = fonts.med,
        TextSize = 12,
        TextColor3 = Color3.fromRGB(200, 200, 200),
        BackgroundTransparency = 1,
        AutomaticSize = Enum.AutomaticSize.X
    }, G2L["stats_frame"])

    -- Drag, Resize, Toggle, Behavior
    local Window = mainfunctions.BuildWindow(G2L, config, components)
    Window._G2L = G2L

    Window.Notify = function(self, cfg)
        return NotificationSystem:Notify(cfg)
    end
    Window.SetTheme = function(self, themeName)
        mainfunctions.SetTheme(G2L, themeName)
    end
    mainfunctions.SetTheme(G2L, defaultTheme)
    mainfunctions.InitBehavior(G2L, Window, config.OnClose)
    return Window
end

    return Library
end
