-- GoonHub UI Library Mainframe
return function(mainfunctions, components)
    local RunService = game:GetService("RunService")
    local TweenService = game:GetService("TweenService")
    local Library = {}
    Library.TabCount = 0
    Library.Themes = mainfunctions.Themes

function Library:CreateWindow(config)
    config = config or {}
    local title = config.Title or "GoonHub"
    local versionText = config.Version or "1.0.0"
    local defaultTheme = config.Theme or "Dark"
    local logo = config.Logo or "<font color=\"rgb(248, 191, 212)\">Goon</font>Hub"
    local secondaryLogo = config.SecondaryLogo or string.format("| %s %s", title, versionText)

    mainfunctions.Themes = config.Themes or {
        Dark = { Main = Color3.fromRGB(36, 36, 36), Accent = Color3.fromRGB(248, 191, 212) }
    }
    Library.Themes = mainfunctions.Themes

    local New = mainfunctions.New
    local fonts = mainfunctions.GetFonts()
    local G2L = {}

    -- Resolve Local Player safely
    local Players = game:GetService("Players")
    local LocalPlayer = Players.LocalPlayer
    local userId = LocalPlayer and LocalPlayer.UserId or 1
    local displayName = LocalPlayer and LocalPlayer.DisplayName or "Offline Developer"
    local userName = LocalPlayer and LocalPlayer.Name or "dev"

    -- Find parent container
    local targetParent = (gethui and gethui()) or game:GetService("CoreGui") or (LocalPlayer and LocalPlayer:WaitForChild("PlayerGui"))
    if not targetParent then
        error("GoonHub: Could not locate a valid GUI parent container.")
    end

    -- Destroy old instance if exists
    if targetParent:FindFirstChild("GoonHub") then 
        targetParent["GoonHub"]:Destroy() 
    end

    G2L["1"] = New("ScreenGui", {
        IgnoreGuiInset = true,
        Name = "GoonHub",
        ResetOnSpawn = false,
        ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    }, targetParent)

    G2L["2"] = New("Frame", {
        BackgroundColor3 = mainfunctions.CurrentMain,
        AnchorPoint = Vector2.new(0.5, 0.5),
        Size = UDim2.new(0, 850, 0, 580),
        Position = UDim2.new(0.5, 0, 0.5, 0),
        Name = "Main",
        ClipsDescendants = true
    }, G2L["1"])

    New("UICorner", {CornerRadius = UDim.new(0, 18)}, G2L["2"])

    G2L["4"] = New("Frame", {
        Size = UDim2.new(1, 0, 1, 0),
        BackgroundTransparency = 1,
        Name = "panel"
    }, G2L["2"])

    G2L["5"] = New("Frame", {
        Size = UDim2.new(1, 0, 1, 0),
        BackgroundTransparency = 1,
        ZIndex = 999,
        Name = "controls"
    }, G2L["4"])

    G2L["b"] = New("ImageButton", {
        Size = UDim2.new(0, 35, 0, 35),
        Position = UDim2.new(1, -8, 1, -8),
        AnchorPoint = Vector2.new(1, 1),
        BackgroundTransparency = 1,
        ZIndex = 1005,
        Name = "resize"
    }, G2L["5"])

    New("ImageLabel", {
        Size = UDim2.new(1, 0, 1, 0),
        Image = "rbxassetid://88780680171023",
        ImageColor3 = Color3.fromRGB(91, 91, 91),
        BackgroundTransparency = 1
    }, G2L["b"])

    G2L["10"] = New("Frame", {
        Size = UDim2.new(1, 0, 1, -35),
        Position = UDim2.new(0.5, 0, 1, 0),
        AnchorPoint = Vector2.new(0.5, 1),
        BackgroundTransparency = 1,
        Name = "content"
    }, G2L["4"])

    New("UIPadding", {
        PaddingTop = UDim.new(0, 10),
        PaddingBottom = UDim.new(0, 35),
        PaddingRight = UDim.new(0, 15)
    }, G2L["10"])

    G2L["65"] = New("Frame", {
        Size = UDim2.new(1, 0, 0, 35),
        Position = UDim2.new(0, 0, 0, 0),
        BackgroundTransparency = 1,
        Name = "topbar",
        ZIndex = 1005,
        ClipsDescendants = false
    }, G2L["4"])

    New("UIListLayout", {
        FillDirection = Enum.FillDirection.Horizontal,
        VerticalAlignment = Enum.VerticalAlignment.Center,
        SortOrder = Enum.SortOrder.LayoutOrder,
        Padding = UDim.new(0, 10)
    }, G2L["65"])

    New("UIPadding", {
        PaddingLeft = UDim.new(0, 15),
        PaddingRight = UDim.new(0, 15)
    }, G2L["65"])

    G2L["6e"] = New("Frame", {
        Size = UDim2.new(0, 85, 0, 35),
        BackgroundTransparency = 1,
        Name = "actions",
        LayoutOrder = 3
    }, G2L["65"])

    local spacer = New("Frame", {
        Name = "space",
        BackgroundTransparency = 1,
        LayoutOrder = 2
    }, G2L["65"])

    New("UIFlexItem", {FlexMode = Enum.UIFlexMode.Fill}, spacer)

    G2L["6c"] = New("Frame", {
        AutomaticSize = Enum.AutomaticSize.X,
        Size = UDim2.new(0, 0, 0, 35),
        BackgroundTransparency = 1,
        Name = "logo",
        LayoutOrder = 1
    }, G2L["65"])

    New("UISizeConstraint", {MaxSize = Vector2.new(350, 35)}, G2L["6c"])

    G2L["logo_text"] = New("TextLabel", {
        Name = "logo_text",
        AutomaticSize = Enum.AutomaticSize.X,
        Size = UDim2.new(0, 0, 1, 0),
        Text = string.format("%s <font color=\"rgb(150,150,150)\">%s</font>", logo, secondaryLogo),
        RichText = true,
        FontFace = fonts.logo,
        TextSize = 24,
        TextColor3 = Color3.new(1, 1, 1),
        BackgroundTransparency = 1,
        TextXAlignment = Enum.TextXAlignment.Left,
        TextYAlignment = Enum.TextYAlignment.Center,
        TextTruncate = Enum.TextTruncate.AtEnd
    }, G2L["6c"])

    G2L["70"] = New("Frame", {
        Size = UDim2.new(1, 0, 0, 27),
        AnchorPoint = Vector2.new(1, 0),
        Position = UDim2.new(1, 3, 0, 5),
        BackgroundTransparency = 0,
        BackgroundColor3 = Color3.fromRGB(25, 25, 25)
    }, G2L["6e"])

    New("UICorner", {CornerRadius = UDim.new(1, 0)}, G2L["70"])

    New("UIListLayout", {
        FillDirection = Enum.FillDirection.Horizontal,
        HorizontalAlignment = Enum.HorizontalAlignment.Center,
        VerticalAlignment = Enum.VerticalAlignment.Center,
        Padding = UDim.new(0, 4)
    }, G2L["70"])

    New("UIPadding", {
        PaddingLeft = UDim.new(0, 4),
        PaddingRight = UDim.new(0, 4)
    }, G2L["70"])

    local function CreateTopButton(name, color, iconId, lo)
        local btn = New("ImageButton", {
            Name = name,
            Size = UDim2.new(0, 22, 0, 22),
            BackgroundTransparency = 1,
            LayoutOrder = lo
        }, G2L["70"])

        local frame = New("Frame", {
            Size = UDim2.new(1, 0, 1, 0),
            BackgroundTransparency = 1
        }, btn)

        local colorCirc = New("ImageLabel", {
            Size = UDim2.new(0, 18, 0, 18),
            Position = UDim2.new(0.5, 0, 0.5, 0),
            AnchorPoint = Vector2.new(0.5, 0.5),
            BackgroundColor3 = color,
            ImageTransparency = 1,
            BackgroundTransparency = 0
        }, frame)

        New("UICorner", {CornerRadius = UDim.new(1, 0)}, colorCirc)

        local innerSt = New("ImageLabel", {
            Size = UDim2.new(0, 14, 0, 14),
            Position = UDim2.new(0.5, 0, 0.5, 0),
            AnchorPoint = Vector2.new(0.5, 0.5),
            ImageTransparency = 0,
            BackgroundTransparency = 1,
            ZIndex = 1002
        }, frame)

        New("UIStroke", {
            Transparency = 0.9,
            Color = Color3.new(1, 1, 1)
        }, innerSt)

        New("UICorner", {CornerRadius = UDim.new(1, 0)}, innerSt)

        New("ImageLabel", {
            Size = UDim2.new(0, 8, 0, 8),
            Position = UDim2.new(0.5, 0, 0.5, 0),
            AnchorPoint = Vector2.new(0.5, 0.5),
            Image = "rbxassetid://" .. iconId,
            ImageColor3 = Color3.new(0, 0, 0),
            ImageTransparency = 0,
            ZIndex = 1003,
            BackgroundTransparency = 1
        }, frame)

        return btn
    end

    G2L["72"] = CreateTopButton("close", Color3.fromRGB(255, 51, 51), "109757326745560", 1)
    G2L["80"] = CreateTopButton("sidebar_toggle", Color3.fromRGB(226, 183, 26), "4773248567", 2)
    G2L["94"] = CreateTopButton("maximize", Color3.fromRGB(122, 214, 3), "11295291707", 3)

    G2L["11"] = New("Frame", {
        Size = UDim2.new(1, -235, 1, 0),
        Position = UDim2.new(1, 0, 1, 0),
        AnchorPoint = Vector2.new(1, 1),
        BackgroundColor3 = Color3.fromRGB(21, 21, 21),
        BackgroundTransparency = 0.7,
        ClipsDescendants = true,
        Name = "screen"
    }, G2L["10"])

    New("UICorner", {CornerRadius = UDim.new(0, 12)}, G2L["11"])

    G2L["14"] = New("UIPageLayout", {
        SortOrder = Enum.SortOrder.LayoutOrder,
        Animated = true,
        EasingStyle = Enum.EasingStyle.Quart,
        EasingDirection = Enum.EasingDirection.Out,
        TweenTime = 0.45,
        ScrollWheelInputEnabled = false,
        TouchInputEnabled = false
    }, G2L["11"])

    G2L["16"] = New("Frame", {
        Size = UDim2.new(0, 220, 1, 0),
        BackgroundTransparency = 1,
        Name = "bar",
        ClipsDescendants = true
    }, G2L["10"])

    New("UIListLayout", {
        Padding = UDim.new(0, 7),
        HorizontalAlignment = Enum.HorizontalAlignment.Center,
        SortOrder = Enum.SortOrder.LayoutOrder
    }, G2L["16"])

    G2L["4b"] = New("Frame", {
        Size = UDim2.new(1, -22, 0, 0),
        BackgroundColor3 = Color3.fromRGB(9, 9, 9),
        BackgroundTransparency = 0.7,
        LayoutOrder = 3
    }, G2L["16"])

    New("UICorner", {CornerRadius = UDim.new(0, 15)}, G2L["4b"])
    New("UIFlexItem", {FlexMode = Enum.UIFlexMode.Fill}, G2L["4b"])

    G2L["4c"] = New("ScrollingFrame", {
        Size = UDim2.new(1, 0, 1, -16),
        Position = UDim2.new(0, 0, 0, 8),
        BackgroundTransparency = 1,
        ScrollBarThickness = 0,
        AutomaticCanvasSize = Enum.AutomaticSize.Y,
        Name = "navigation"
    }, G2L["4b"])

    New("UIListLayout", {
        Padding = UDim.new(0, 5),
        HorizontalAlignment = Enum.HorizontalAlignment.Center,
        SortOrder = Enum.SortOrder.LayoutOrder
    }, G2L["4c"])

    New("UIPadding", {
        PaddingLeft = UDim.new(0, 8),
        PaddingRight = UDim.new(0, 8),
        PaddingTop = UDim.new(0, 2)
    }, G2L["4c"])

    G2L["18"] = New("Frame", {
        Size = UDim2.new(1, -22, 0, 0),
        AutomaticSize = Enum.AutomaticSize.Y,
        BackgroundTransparency = 1,
        Name = "anchored_buttons",
        LayoutOrder = 5
    }, G2L["16"])

    G2L["19"] = New("Frame", {
        BackgroundColor3 = Color3.fromRGB(9, 9, 9),
        BackgroundTransparency = 0.7,
        AutomaticSize = Enum.AutomaticSize.Y,
        Size = UDim2.new(1, 0, 0, 0),
        Name = "main"
    }, G2L["18"])

    New("UICorner", {CornerRadius = UDim.new(0, 12)}, G2L["19"])

    New("UIPadding", {
        PaddingTop = UDim.new(0, 7),
        PaddingBottom = UDim.new(0, 7),
        PaddingLeft = UDim.new(0, 6),
        PaddingRight = UDim.new(0, 6)
    }, G2L["19"])

    New("UIListLayout", {
        Padding = UDim.new(0, 5),
        HorizontalAlignment = Enum.HorizontalAlignment.Center,
        SortOrder = Enum.SortOrder.LayoutOrder
    }, G2L["19"])

    G2L["38"] = New("ImageButton", {
        Size = UDim2.new(1, -22, 0, 48),
        BackgroundColor3 = Color3.fromRGB(9, 9, 9),
        BackgroundTransparency = 0.7,
        LayoutOrder = 10,
        Name = "user",
        AutoButtonColor = false
    }, G2L["16"])

    New("UICorner", {CornerRadius = UDim.new(0, 15)}, G2L["38"])

    New("UIListLayout", {
        FillDirection = Enum.FillDirection.Horizontal,
        VerticalAlignment = Enum.VerticalAlignment.Center,
        Padding = UDim.new(0, 10),
        Wraps = false
    }, G2L["38"])

    New("UIPadding", {
        PaddingLeft = UDim.new(0, 10),
        PaddingRight = UDim.new(0, 35)
    }, G2L["38"])

    local avatarFrame = New("Frame", {
        Size = UDim2.new(0, 26, 0, 26),
        BackgroundTransparency = 1,
        Name = "profile"
    }, G2L["38"])

    G2L["avatar"] = New("ImageLabel", {
        Size = UDim2.new(0, 26, 0, 26),
        Image = "rbxthumb://type=AvatarHeadShot&id=" .. userId .. "&w=150&h=150",
        BackgroundTransparency = 1,
        BackgroundColor3 = Color3.fromRGB(36, 36, 36)
    }, avatarFrame)

    New("UICorner", {CornerRadius = UDim.new(1, 0)}, G2L["avatar"])

    local infoFrame = New("Frame", {
        Size = UDim2.new(0, 0, 1, 0),
        BackgroundTransparency = 1,
        Name = "info"
    }, G2L["38"])

    New("UIListLayout", {VerticalAlignment = Enum.VerticalAlignment.Center}, infoFrame)
    New("UIFlexItem", {FlexMode = Enum.UIFlexMode.Fill}, infoFrame)

    G2L["display_name"] = New("TextLabel", {
        Size = UDim2.new(1, 0, 0, 15),
        Text = displayName,
        FontFace = fonts.bold,
        TextSize = 15,
        TextColor3 = Color3.new(1, 1, 1),
        BackgroundTransparency = 1,
        TextXAlignment = Enum.TextXAlignment.Left,
        TextTruncate = Enum.TextTruncate.AtEnd
    }, infoFrame)

    G2L["user_name"] = New("TextLabel", {
        Size = UDim2.new(1, 0, 0, 10),
        Text = "@" .. userName,
        FontFace = fonts.reg,
        TextSize = 13,
        TextColor3 = Color3.new(0.6, 0.6, 0.6),
        BackgroundTransparency = 1,
        TextXAlignment = Enum.TextXAlignment.Left,
        TextTruncate = Enum.TextTruncate.AtEnd
    }, infoFrame)

    local timeBox = New("ImageButton", {
        Size = UDim2.new(0, 40, 0, 20),
        BackgroundColor3 = Color3.new(0, 0, 0),
        BackgroundTransparency = 0.8,
        Name = "time",
        AutoButtonColor = false,
        AutomaticSize = Enum.AutomaticSize.X
    }, G2L["38"])

    New("UICorner", {CornerRadius = UDim.new(0, 4)}, timeBox)
    New("UIPadding", {
        PaddingLeft = UDim.new(0, 8),
        PaddingRight = UDim.new(0, 8)
    }, timeBox)

    G2L["time_text"] = New("TextLabel", {
        Size = UDim2.new(1, 0, 1, 0),
        Text = "00:00 PM",
        FontFace = fonts.reg,
        TextSize = 14,
        TextColor3 = Color3.new(1, 1, 1),
        BackgroundTransparency = 1,
        TextTransparency = 0.2,
        AutomaticSize = Enum.AutomaticSize.X
    }, timeBox)

    G2L["a1"] = New("Frame", {
        Size = UDim2.new(1, 0, 0, 30),
        Position = UDim2.new(0, 0, 1, 0),
        AnchorPoint = Vector2.new(0, 1),
        BackgroundColor3 = Color3.new(0, 0, 0),
        BackgroundTransparency = 0.9,
        Name = "debug"
    }, G2L["4"])

    New("UIStroke", {Color = Color3.fromRGB(46, 46, 46)}, G2L["a1"])

    New("UIListLayout", {
        FillDirection = Enum.FillDirection.Horizontal,
        VerticalAlignment = Enum.VerticalAlignment.Center,
        Padding = UDim.new(0, 15)
    }, G2L["a1"])

    New("UIPadding", {PaddingLeft = UDim.new(0, 18)}, G2L["a1"])

    local function CreateStatLabel(labelTitle, color)
        local frame = New("Frame", {
            AutomaticSize = Enum.AutomaticSize.XY,
            BackgroundTransparency = 1
        }, G2L["a1"])

        New("UIListLayout", {
            FillDirection = Enum.FillDirection.Horizontal,
            Padding = UDim.new(0, 4)
        }, frame)

        New("TextLabel", {
            Text = labelTitle,
            TextColor3 = color or Color3.fromRGB(255, 255, 81),
            FontFace = fonts.med,
            TextSize = 14,
            BackgroundTransparency = 1,
            AutomaticSize = Enum.AutomaticSize.X
        }, frame)

        return New("TextLabel", {
            Text = "--",
            TextColor3 = Color3.new(1, 1, 1),
            FontFace = fonts.med,
            TextSize = 14,
            BackgroundTransparency = 1,
            AutomaticSize = Enum.AutomaticSize.X
        }, frame)
    end

    G2L["mem_label"] = CreateStatLabel("Memory Usage:")
    G2L["ping_label"] = CreateStatLabel("Avg. Ping:")

    G2L["fps_label"] = New("TextLabel", {
        Name = "fps",
        Text = "FPS: --",
        FontFace = fonts.med,
        TextSize = 14,
        TextColor3 = Color3.fromRGB(255, 255, 255),
        BackgroundTransparency = 1,
        AutomaticSize = Enum.AutomaticSize.XY
    }, G2L["a1"])

    -- Wire behavior / physics
    mainfunctions.InitBehavior(G2L, Library, config.OnClose)

    -- Set flex behavior on footer
    if G2L["18"] and not G2L["18"]:FindFirstChildOfClass("UIFlexItem") then
        New("UIFlexItem", {FlexMode = Enum.UIFlexMode.None}, G2L["18"])
    end

    -- Window Object API
    local Window = {
        G2L = G2L,
        TabCount = 0,
        Logo = logo,
        Stats = {
            FPS = G2L["fps_label"],
            Ping = G2L["ping_label"],
            Memory = G2L["mem_label"]
        }
    }

    -- Set initial Theme
    mainfunctions.SetTheme(G2L, defaultTheme)

    -- Track secondary tab count for 2-slot limit
    local secondaryTabCount = 0

    function Window:CreateTab(tabNameOrConfig)
        self.TabCount = self.TabCount + 1
        local tabIndex = self.TabCount
        
        local tabName = ""
        local isSecondary = false
        local iconId = "11433532654"
        local hasColumns = false
        
        if type(tabNameOrConfig) == "table" then
            tabName = tabNameOrConfig.Name or "Tab"
            iconId = tabNameOrConfig.Icon or "11433532654"
            isSecondary = tabNameOrConfig.SecondaryTab or false
            hasColumns = tabNameOrConfig.Columns or false
        else
            tabName = tostring(tabNameOrConfig)
        end

        -- Enforce max 2 secondary tabs
        if isSecondary then
            secondaryTabCount = secondaryTabCount + 1
            if secondaryTabCount > 2 then
                warn("GoonHub: Max 2 secondary tabs allowed. '" .. tabName .. "' was not created.")
                return nil
            end
        end

        -- Construct Tab Sidebar Navigation Button
        local parentFrame = isSecondary and G2L["19"] or G2L["4c"]
        
        local navBtn = New("ImageButton", {
            Name = tabName,
            Size = UDim2.new(1, 0, 0, 31),
            BackgroundTransparency = 1,
            AutoButtonColor = false,
            LayoutOrder = tabIndex,
            ClipsDescendants = false
        }, parentFrame)

        local innerItem = New("Frame", {
            Name = "item",
            Size = UDim2.new(1, 0, 1, 0),
            BackgroundTransparency = 1,
            ZIndex = 2
        }, navBtn)

        local selectorFrame = New("Frame", {
            Name = "selector",
            AnchorPoint = Vector2.new(0.5, 0.5),
            Position = UDim2.new(0.5, 0, 0.5, 0),
            Size = UDim2.new(1, 0, 1, 0),
            BackgroundColor3 = Color3.fromRGB(41, 41, 41),
            BackgroundTransparency = 1,
            ZIndex = 0
        }, navBtn)

        New("UICorner", {CornerRadius = UDim.new(0, 10)}, selectorFrame)

        local stroke = New("UIStroke", {
            Name = "SelectionStroke",
            Color = Color3.new(1, 1, 1),
            Thickness = 1.5,
            Transparency = 1,
            ApplyStrokeMode = "Border"
        }, selectorFrame)

        local gradient = New("UIGradient", {
            Transparency = NumberSequence.new({
                NumberSequenceKeypoint.new(0, 1),
                NumberSequenceKeypoint.new(0.45, 0),
                NumberSequenceKeypoint.new(0.55, 0),
                NumberSequenceKeypoint.new(1, 1)
            })
        }, stroke)

        -- Spin gradient border
        local borderSpinConn
        borderSpinConn = RunService.RenderStepped:Connect(function(dt)
            if not navBtn or not navBtn.Parent then
                borderSpinConn:Disconnect()
                return
            end
            gradient.Rotation = (gradient.Rotation + 6 * dt) % 360
        end)

        New("UIListLayout", {
            FillDirection = Enum.FillDirection.Horizontal,
            VerticalAlignment = Enum.VerticalAlignment.Center,
            Padding = UDim.new(0, 10)
        }, innerItem)

        New("UIPadding", {
            PaddingLeft = UDim.new(0, 12),
            PaddingRight = UDim.new(0, 12)
        }, innerItem)

        local iconHolder = New("ImageLabel", {
            Name = "holder",
            Size = UDim2.new(0, 20, 0, 20),
            BackgroundColor3 = Color3.new(0, 0, 0),
            BackgroundTransparency = 0.8,
            ImageTransparency = 1,
            LayoutOrder = 1,
            ZIndex = 3
        }, innerItem)

        New("UICorner", {CornerRadius = UDim.new(0, 6)}, iconHolder)

        local iconImg = New("ImageLabel", {
            Name = "icon",
            Size = UDim2.new(0, 14, 0, 14),
            Position = UDim2.new(0.5, 0, 0.5, 0),
            AnchorPoint = Vector2.new(0.5, 0.5),
            Image = "rbxassetid://" .. iconId,
            ImageTransparency = 0.5,
            ZIndex = 4,
            BackgroundTransparency = 1
        }, iconHolder)

        local textLabel = New("TextLabel", {
            Name = "label",
            Text = tabName,
            FontFace = fonts.bold,
            TextSize = 15,
            TextColor3 = Color3.new(1, 1, 1),
            TextTransparency = 0.5,
            BackgroundTransparency = 1,
            LayoutOrder = 2,
            ZIndex = 3,
            TextXAlignment = Enum.TextXAlignment.Left
        }, innerItem)

        New("UIFlexItem", {FlexMode = Enum.UIFlexMode.Fill}, textLabel)

        -- Construct Tab Content Frame
        local tabContentFrame = New("ScrollingFrame", {
            Name = tabName .. "Tab",
            Size = UDim2.new(1, 0, 1, 0),
            BackgroundTransparency = 1,
            ScrollBarThickness = 3,
            ScrollBarImageColor3 = mainfunctions.CurrentAccent,
            AutomaticCanvasSize = Enum.AutomaticSize.Y,
            CanvasSize = UDim2.new(0, 0, 0, 0),
            LayoutOrder = tabIndex
        }, G2L["11"])

        New("UIPadding", {
            PaddingLeft = UDim.new(0, 12),
            PaddingRight = UDim.new(0, 12),
            PaddingTop = UDim.new(0, 8),
            PaddingBottom = UDim.new(0, 8)
        }, tabContentFrame)

        local leftCol, rightCol
        if hasColumns then
            leftCol = New("ScrollingFrame", {
                Name = "Left",
                Size = UDim2.new(0.5, -6, 1, 0),
                Position = UDim2.new(0, 0, 0, 0),
                BackgroundTransparency = 1,
                ScrollBarThickness = 0,
                AutomaticCanvasSize = Enum.AutomaticSize.Y,
                CanvasSize = UDim2.new(0, 0, 0, 0)
            }, tabContentFrame)

            New("UIListLayout", {
                Padding = UDim.new(0, 8),
                SortOrder = Enum.SortOrder.LayoutOrder,
                HorizontalAlignment = Enum.HorizontalAlignment.Center
            }, leftCol)

            New("UIPadding", {
                PaddingTop = UDim.new(0, 4),
                PaddingBottom = UDim.new(0, 4)
            }, leftCol)

            rightCol = New("ScrollingFrame", {
                Name = "Right",
                Size = UDim2.new(0.5, -6, 1, 0),
                Position = UDim2.new(0.5, 6, 0, 0),
                BackgroundTransparency = 1,
                ScrollBarThickness = 0,
                AutomaticCanvasSize = Enum.AutomaticSize.Y,
                CanvasSize = UDim2.new(0, 0, 0, 0)
            }, tabContentFrame)

            New("UIListLayout", {
                Padding = UDim.new(0, 8),
                SortOrder = Enum.SortOrder.LayoutOrder,
                HorizontalAlignment = Enum.HorizontalAlignment.Center
            }, rightCol)

            New("UIPadding", {
                PaddingTop = UDim.new(0, 4),
                PaddingBottom = UDim.new(0, 4)
            }, rightCol)

            tabContentFrame.ScrollBarThickness = 0
        else
            New("UIListLayout", {
                Padding = UDim.new(0, 8),
                HorizontalAlignment = Enum.HorizontalAlignment.Center,
                SortOrder = Enum.SortOrder.LayoutOrder
            }, tabContentFrame)
        end

        -- Wire Selection / Navigation jump
        local TweenService = game:GetService("TweenService")
        navBtn.MouseButton1Click:Connect(function()
            G2L["14"]:JumpTo(tabContentFrame)
            
            local function updateNavStyle(button, active)
                local sel = button:FindFirstChild("selector") 
                if sel then 
                    TweenService:Create(sel, TweenInfo.new(0.35, Enum.EasingStyle.Quart), {
                        BackgroundTransparency = active and 0 or 1, 
                        Size = active and UDim2.new(1, -12, 1, -4) or UDim2.new(1, 0, 1, 0)
                    }):Play() 
                    
                    local selectStroke = sel:FindFirstChild("SelectionStroke") 
                    if selectStroke then 
                        TweenService:Create(selectStroke, TweenInfo.new(0.35), {
                            Transparency = active and 0 or 1
                        }):Play() 
                    end 
                end
                
                local lbl = button:FindFirstChild("label", true) 
                if lbl then 
                    TweenService:Create(lbl, TweenInfo.new(0.35, Enum.EasingStyle.Quart), {
                        TextTransparency = active and 0 or 0.5
                    }):Play() 
                end
                
                local hld = button:FindFirstChild("holder", true) 
                if hld then 
                    local icon = hld:FindFirstChild("icon", true) 
                    if icon then 
                        TweenService:Create(icon, TweenInfo.new(0.35, Enum.EasingStyle.Quart), {
                            ImageTransparency = active and 0 or 0.5
                        }):Play() 
                    end 
                end
            end

            -- Update states of all sidebar items
            for _, child in pairs(G2L["4c"]:GetChildren()) do 
                if child:IsA("ImageButton") then 
                    updateNavStyle(child, child == navBtn) 
                end 
            end
            for _, child in pairs(G2L["19"]:GetChildren()) do 
                if child:IsA("ImageButton") then 
                    updateNavStyle(child, child == navBtn) 
                end 
            end
        end)

        -- Initial style for active first tab
        if tabIndex == 1 then
            selectorFrame.BackgroundTransparency = 0
            selectorFrame.Size = UDim2.new(1, -12, 1, -4)
            stroke.Transparency = 0
            textLabel.TextTransparency = 0
            iconImg.ImageTransparency = 0
        end

        local function getWidgetParent(overrideParent, colName)
            if overrideParent then return overrideParent end
            if hasColumns then
                if colName == "Right" then
                    return rightCol
                else
                    return leftCol
                end
            end
            return tabContentFrame
        end

        local Tab = {
            tabFrame = tabContentFrame,
            WidgetCount = 0,
            SectionCount = 0,
            getWidgetParent = getWidgetParent
        }

        function Tab:CreateSection(sectionTitle, columnSelection)
            local title = type(sectionTitle) == "table" and sectionTitle.Title or sectionTitle
            local colName = type(sectionTitle) == "table" and sectionTitle.Column or columnSelection
            
            local parent = getWidgetParent(nil, colName)
            self.SectionCount = self.SectionCount + 1
            
            local secFrame = New("Frame", {
                Size = UDim2.new(1, 0, 0, 32),
                AutomaticSize = Enum.AutomaticSize.Y,
                BackgroundColor3 = Color3.fromRGB(30, 30, 30),
                LayoutOrder = self.SectionCount
            }, parent)

            New("UICorner", {CornerRadius = UDim.new(0, 6)}, secFrame)
            
            New("UIStroke", {
                Color = Color3.fromRGB(45, 45, 45),
                Thickness = 1,
                Transparency = 0.5
            }, secFrame)

            local sectionText = New("TextLabel", {
                Size = UDim2.new(1, -20, 0, 32),
                Position = UDim2.new(0, 10, 0, 0),
                Text = " " .. title,
                TextColor3 = mainfunctions.CurrentAccent,
                FontFace = fonts.bold,
                TextSize = 14,
                TextXAlignment = Enum.TextXAlignment.Left,
                BackgroundTransparency = 1
            }, secFrame)

            local container = New("Frame", {
                Name = "container",
                Position = UDim2.new(0, 10, 0, 35),
                Size = UDim2.new(1, -20, 0, 0),
                AutomaticSize = Enum.AutomaticSize.Y,
                BackgroundTransparency = 1
            }, secFrame)

            New("UIListLayout", {
                Padding = UDim.new(0, 6),
                SortOrder = Enum.SortOrder.LayoutOrder
            }, container)

            New("UIPadding", {
                PaddingBottom = UDim.new(0, 8),
                PaddingTop = UDim.new(0, 4)
            }, container)

            local Section = {
                WidgetCount = 0
            }
            
            function Section:CreateToggle(t, d, cb)
                self.WidgetCount = self.WidgetCount + 1
                return Tab:CreateToggle(t, d, cb, container, self.WidgetCount)
            end
            
            function Section:CreateSlider(t, min, max, d, cb)
                self.WidgetCount = self.WidgetCount + 1
                return Tab:CreateSlider(t, min, max, d, cb, container, self.WidgetCount)
            end
            
            function Section:CreateButton(t, cb)
                self.WidgetCount = self.WidgetCount + 1
                return Tab:CreateButton(t, cb, container, self.WidgetCount)
            end
            
            function Section:CreateDropdown(t, options, cb)
                self.WidgetCount = self.WidgetCount + 1
                return Tab:CreateDropdown(t, options, cb, container, self.WidgetCount)
            end
            
            function Section:CreateLabel(t, d)
                self.WidgetCount = self.WidgetCount + 1
                return Tab:CreateLabel(t, d, container, self.WidgetCount)
            end
            
            function Section:CreateParagraph(text)
                self.WidgetCount = self.WidgetCount + 1
                return Tab:CreateParagraph(text, container, self.WidgetCount)
            end

            function Section:CreateAvatar(t)
                self.WidgetCount = self.WidgetCount + 1
                return Tab:CreateAvatar(t, container, self.WidgetCount)
            end

            function Section:CreateInput(t, d, cb)
                self.WidgetCount = self.WidgetCount + 1
                return Tab:CreateInput(t, d, cb, container, self.WidgetCount)
            end

            function Section:CreateKeybind(t, d, cb)
                self.WidgetCount = self.WidgetCount + 1
                return Tab:CreateKeybind(t, d, cb, container, self.WidgetCount)
            end

            return Section
        end

        -- Delegate widget creation to external components
        function Tab:CreateToggle(configTitle, defaultState, callback, overrideParent, layoutOrder)
            return components.toggle(self, mainfunctions, configTitle, defaultState, callback, overrideParent, layoutOrder)
        end

        function Tab:CreateSlider(configTitle, minVal, maxVal, defaultState, callback, overrideParent, layoutOrder)
            return components.slider(self, mainfunctions, configTitle, minVal, maxVal, defaultState, callback, overrideParent, layoutOrder)
        end

        function Tab:CreateButton(configTitle, callback, overrideParent, layoutOrder)
            return components.button(self, mainfunctions, configTitle, callback, overrideParent, layoutOrder)
        end

        function Tab:CreateDropdown(configTitle, configOptions, callback, overrideParent, layoutOrder)
            return components.dropdown(self, mainfunctions, configTitle, configOptions, callback, overrideParent, layoutOrder)
        end

        function Tab:CreateLabel(configTitle, defaultState, overrideParent, layoutOrder)
            return components.status(self, mainfunctions, configTitle, defaultState, overrideParent, layoutOrder)
        end

        function Tab:CreateParagraph(configText, overrideParent, layoutOrder)
            return components.paragraph(self, mainfunctions, configText, overrideParent, layoutOrder)
        end

        function Tab:CreateAvatar(configTitle, overrideParent, layoutOrder)
            return components.avatar(self, mainfunctions, configTitle, overrideParent, layoutOrder)
        end

        function Tab:CreateInput(configTitle, defaultKey, callback, overrideParent, layoutOrder)
            return components.input(self, mainfunctions, configTitle, defaultKey, callback, overrideParent, layoutOrder)
        end

        function Tab:CreateKeybind(configTitle, defaultKey, callback, overrideParent, layoutOrder)
            return components.input(self, mainfunctions, configTitle, defaultKey, callback, overrideParent, layoutOrder)
        end

        return Tab
    end

    -- Apply initial theme
    mainfunctions.SetTheme(G2L, defaultTheme)

    return Window
end

    return Library
end

