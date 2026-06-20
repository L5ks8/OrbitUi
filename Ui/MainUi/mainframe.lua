-- GoonHub UI Library Mainframe
return function(mainfunctions, components)
    local RunService = game:GetService("RunService")
    local TweenService = game:GetService("TweenService")
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
        error("UiLibary: Could not locate a valid GUI parent container.")
    end

    -- Destroy old instance if exists
    if targetParent:FindFirstChild("UiLibary") then 
        targetParent["UiLibary"]:Destroy() 
    end

    G2L["1"] = New("ScreenGui", {
        IgnoreGuiInset = true,
        Name = "UiLibary",
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

    G2L["avatar"] = New("ImageButton", {
        Size = UDim2.new(0, 26, 0, 26),
        Image = "rbxthumb://type=AvatarHeadShot&id=" .. userId .. "&w=150&h=150",
        BackgroundTransparency = 1,
        BackgroundColor3 = Color3.fromRGB(36, 36, 36),
        AutoButtonColor = false
    }, avatarFrame)

    New("UICorner", {CornerRadius = UDim.new(1, 0)}, G2L["avatar"])

    local profileInstance = nil
    G2L["avatar"].MouseButton1Click:Connect(function()
        if profileInstance and profileInstance.Parent then
            profileInstance:Destroy()
            profileInstance = nil
        else
            profileInstance = components.profile(mainfunctions)
        end
    end)

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
        BorderSizePixel = 0,
        BackgroundColor3 = Color3.fromRGB(0, 0, 0),
        AnchorPoint = Vector2.new(0, 1),
        ClipsDescendants = true,
        Size = UDim2.new(1, 0, 0, 30),
        Position = UDim2.new(0, 0, 1, 0),
        BorderColor3 = Color3.fromRGB(0, 0, 0),
        Name = "debug",
        LayoutOrder = 4,
        BackgroundTransparency = 0.9
    }, G2L["4"])

    New("UIListLayout", {
        Padding = UDim.new(0, 6),
        VerticalAlignment = Enum.VerticalAlignment.Center,
        SortOrder = Enum.SortOrder.LayoutOrder,
        Name = "list",
        FillDirection = Enum.FillDirection.Horizontal
    }, G2L["a1"])

    New("UIStroke", {
        Thickness = 1.5,
        Color = Color3.fromRGB(46, 46, 46),
        Name = "divider"
    }, G2L["a1"])

    New("UIPadding", {
        PaddingTop = UDim.new(0.225, 0),
        PaddingRight = UDim.new(0.03, 20),
        Name = "padding",
        PaddingLeft = UDim.new(0.03, 0),
        PaddingBottom = UDim.new(0.3, 0)
    }, G2L["a1"])

    -- Errors
    local debugErrors = New("Frame", {
        BorderSizePixel = 0,
        BackgroundColor3 = Color3.fromRGB(255, 255, 255),
        Size = UDim2.new(0.06, 0, 1, 0),
        BorderColor3 = Color3.fromRGB(0, 0, 0),
        Name = "errors",
        LayoutOrder = 1,
        BackgroundTransparency = 1
    }, G2L["a1"])

    New("UIListLayout", {
        HorizontalAlignment = Enum.HorizontalAlignment.Center,
        Padding = UDim.new(0, 8),
        VerticalAlignment = Enum.VerticalAlignment.Center,
        SortOrder = Enum.SortOrder.LayoutOrder,
        Name = "list",
        FillDirection = Enum.FillDirection.Horizontal
    }, debugErrors)

    local errIcon = New("ImageLabel", {
        BorderSizePixel = 0,
        BackgroundColor3 = Color3.fromRGB(255, 255, 255),
        ImageColor3 = Color3.fromRGB(255, 81, 81),
        Image = "rbxassetid://14563958666",
        Size = UDim2.new(1, 0, 1, 0),
        BorderColor3 = Color3.fromRGB(0, 0, 0),
        BackgroundTransparency = 1,
        LayoutOrder = 1,
        Name = "icon"
    }, debugErrors)

    New("UIAspectRatioConstraint", {Name = "aspect"}, errIcon)

    local errValue = New("TextLabel", {
        TextWrapped = true,
        TextTruncate = Enum.TextTruncate.AtEnd,
        BorderSizePixel = 0,
        TextSize = 16,
        TextXAlignment = Enum.TextXAlignment.Left,
        TextScaled = true,
        BackgroundColor3 = Color3.fromRGB(255, 255, 255),
        FontFace = Font.new("rbxassetid://12187365364", Enum.FontWeight.Regular, Enum.FontStyle.Normal),
        TextColor3 = Color3.fromRGB(255, 81, 81),
        BackgroundTransparency = 1,
        Size = UDim2.new(0, 0, 1, 0),
        BorderColor3 = Color3.fromRGB(0, 0, 0),
        Text = "0",
        LayoutOrder = 2,
        Name = "value"
    }, debugErrors)

    New("UIFlexItem", {Name = "flex", FlexMode = Enum.UIFlexMode.Fill}, errValue)
    New("UITextSizeConstraint", {Name = "size", MaxTextSize = 13}, errValue)

    -- Warnings
    local debugWarnings = New("Frame", {
        BorderSizePixel = 0,
        BackgroundColor3 = Color3.fromRGB(255, 255, 255),
        Size = UDim2.new(0.06, 0, 1, 0),
        BorderColor3 = Color3.fromRGB(0, 0, 0),
        Name = "warnings",
        LayoutOrder = 2,
        BackgroundTransparency = 1
    }, G2L["a1"])

    New("UIListLayout", {
        HorizontalAlignment = Enum.HorizontalAlignment.Center,
        Padding = UDim.new(0, 8),
        VerticalAlignment = Enum.VerticalAlignment.Center,
        SortOrder = Enum.SortOrder.LayoutOrder,
        Name = "list",
        FillDirection = Enum.FillDirection.Horizontal
    }, debugWarnings)

    local warnIcon = New("ImageLabel", {
        BorderSizePixel = 0,
        BackgroundColor3 = Color3.fromRGB(255, 255, 255),
        ImageColor3 = Color3.fromRGB(255, 255, 81),
        Image = "rbxassetid://71503984286896",
        Size = UDim2.new(1, 0, 1, 0),
        BorderColor3 = Color3.fromRGB(0, 0, 0),
        BackgroundTransparency = 1,
        LayoutOrder = 1,
        Name = "icon"
    }, debugWarnings)

    New("UIAspectRatioConstraint", {Name = "aspect"}, warnIcon)

    local warnValue = New("TextLabel", {
        TextWrapped = true,
        TextTruncate = Enum.TextTruncate.AtEnd,
        BorderSizePixel = 0,
        TextSize = 16,
        TextXAlignment = Enum.TextXAlignment.Left,
        TextScaled = true,
        BackgroundColor3 = Color3.fromRGB(255, 255, 255),
        FontFace = Font.new("rbxassetid://12187365364", Enum.FontWeight.Regular, Enum.FontStyle.Normal),
        TextColor3 = Color3.fromRGB(255, 255, 81),
        BackgroundTransparency = 1,
        Size = UDim2.new(0, 0, 1, 0),
        BorderColor3 = Color3.fromRGB(0, 0, 0),
        Text = "0",
        LayoutOrder = 2,
        Name = "value"
    }, debugWarnings)

    New("UIFlexItem", {Name = "flex", FlexMode = Enum.UIFlexMode.Fill}, warnValue)
    New("UITextSizeConstraint", {Name = "size", MaxTextSize = 13}, warnValue)

    -- Memory
    local debugMemory = New("Frame", {
        BorderSizePixel = 0,
        BackgroundColor3 = Color3.fromRGB(255, 255, 255),
        AutomaticSize = Enum.AutomaticSize.X,
        Size = UDim2.new(0.2, 0, 1, 0),
        BorderColor3 = Color3.fromRGB(0, 0, 0),
        Name = "memory",
        LayoutOrder = 3,
        BackgroundTransparency = 1
    }, G2L["a1"])

    New("UIListLayout", {
        HorizontalAlignment = Enum.HorizontalAlignment.Center,
        Padding = UDim.new(0.05, 0),
        VerticalAlignment = Enum.VerticalAlignment.Center,
        SortOrder = Enum.SortOrder.LayoutOrder,
        Name = "list",
        FillDirection = Enum.FillDirection.Horizontal
    }, debugMemory)

    G2L["mem_text"] = New("TextLabel", {
        TextWrapped = true,
        TextTruncate = Enum.TextTruncate.AtEnd,
        BorderSizePixel = 0,
        TextSize = 14,
        TextXAlignment = Enum.TextXAlignment.Left,
        TextScaled = true,
        BackgroundColor3 = Color3.fromRGB(255, 255, 255),
        FontFace = fonts.med,
        TextColor3 = Color3.fromRGB(255, 255, 81),
        BackgroundTransparency = 1,
        Size = UDim2.new(0, 0, 1, 0),
        BorderColor3 = Color3.fromRGB(0, 0, 0),
        Text = "Memory Usage:",
        LayoutOrder = 1,
        AutomaticSize = Enum.AutomaticSize.X,
        Name = "label"
    }, debugMemory)

    New("UITextSizeConstraint", {Name = "size", MaxTextSize = 14}, G2L["mem_text"])

    G2L["mem_label"] = New("TextLabel", {
        TextWrapped = true,
        TextTruncate = Enum.TextTruncate.AtEnd,
        BorderSizePixel = 0,
        TextSize = 14,
        TextXAlignment = Enum.TextXAlignment.Left,
        TextScaled = true,
        BackgroundColor3 = Color3.fromRGB(255, 255, 255),
        FontFace = fonts.med,
        TextColor3 = Color3.fromRGB(255, 255, 255),
        BackgroundTransparency = 1,
        Size = UDim2.new(0, 0, 1, 0),
        BorderColor3 = Color3.fromRGB(0, 0, 0),
        Text = "0 MB",
        LayoutOrder = 2,
        AutomaticSize = Enum.AutomaticSize.X,
        Name = "value"
    }, debugMemory)

    New("UITextSizeConstraint", {Name = "size", MaxTextSize = 14}, G2L["mem_label"])

    -- Ping
    local debugPing = New("Frame", {
        BorderSizePixel = 0,
        BackgroundColor3 = Color3.fromRGB(255, 255, 255),
        Size = UDim2.new(0.2, 0, 1, 0),
        BorderColor3 = Color3.fromRGB(0, 0, 0),
        Name = "ping",
        LayoutOrder = 4,
        BackgroundTransparency = 1
    }, G2L["a1"])

    New("UIListLayout", {
        HorizontalAlignment = Enum.HorizontalAlignment.Center,
        Padding = UDim.new(0.05, 0),
        VerticalAlignment = Enum.VerticalAlignment.Center,
        SortOrder = Enum.SortOrder.LayoutOrder,
        Name = "list",
        FillDirection = Enum.FillDirection.Horizontal
    }, debugPing)

    G2L["ping_text"] = New("TextLabel", {
        TextWrapped = true,
        TextTruncate = Enum.TextTruncate.AtEnd,
        BorderSizePixel = 0,
        TextSize = 14,
        TextXAlignment = Enum.TextXAlignment.Left,
        TextScaled = true,
        BackgroundColor3 = Color3.fromRGB(255, 255, 255),
        FontFace = fonts.med,
        TextColor3 = Color3.fromRGB(255, 255, 81),
        BackgroundTransparency = 1,
        Size = UDim2.new(0, 0, 1, 0),
        BorderColor3 = Color3.fromRGB(0, 0, 0),
        Text = "Avg. Ping:",
        LayoutOrder = 1,
        AutomaticSize = Enum.AutomaticSize.X,
        Name = "label"
    }, debugPing)

    New("UITextSizeConstraint", {Name = "size", MaxTextSize = 14}, G2L["ping_text"])

    G2L["ping_label"] = New("TextLabel", {
        TextWrapped = true,
        TextTruncate = Enum.TextTruncate.AtEnd,
        BorderSizePixel = 0,
        TextSize = 14,
        TextXAlignment = Enum.TextXAlignment.Left,
        TextScaled = true,
        BackgroundColor3 = Color3.fromRGB(255, 255, 255),
        FontFace = fonts.med,
        TextColor3 = Color3.fromRGB(255, 255, 255),
        BackgroundTransparency = 1,
        Size = UDim2.new(0, 0, 1, 0),
        BorderColor3 = Color3.fromRGB(0, 0, 0),
        Text = "0 ms",
        LayoutOrder = 2,
        AutomaticSize = Enum.AutomaticSize.X,
        Name = "value"
    }, debugPing)

    New("UITextSizeConstraint", {Name = "size", MaxTextSize = 14}, G2L["ping_label"])

    -- Space (flex fill)
    local debugSpace = New("Frame", {
        BorderSizePixel = 0,
        BackgroundColor3 = Color3.fromRGB(255, 255, 255),
        Size = UDim2.new(0, 0, 1, 0),
        BorderColor3 = Color3.fromRGB(0, 0, 0),
        Name = "space",
        LayoutOrder = 5,
        BackgroundTransparency = 1
    }, G2L["a1"])

    New("UIFlexItem", {Name = "flex", FlexMode = Enum.UIFlexMode.Fill}, debugSpace)

    -- FPS
    G2L["fps_label"] = New("TextLabel", {
        BorderSizePixel = 0,
        TextSize = 14,
        BackgroundColor3 = Color3.fromRGB(255, 255, 255),
        FontFace = fonts.med,
        TextColor3 = Color3.fromRGB(255, 255, 255),
        BackgroundTransparency = 1,
        Size = UDim2.new(0, 0, 1, 0),
        BorderColor3 = Color3.fromRGB(0, 0, 0),
        Text = "FPS: 0.0/s",
        LayoutOrder = 6,
        AutomaticSize = Enum.AutomaticSize.X,
        Name = "fps"
    }, G2L["a1"])

    -- Region
    G2L["debug_region"] = New("TextLabel", {
        BorderSizePixel = 0,
        TextSize = 14,
        BackgroundColor3 = Color3.fromRGB(255, 255, 255),
        FontFace = fonts.med,
        TextColor3 = Color3.fromRGB(255, 255, 255),
        BackgroundTransparency = 1,
        Size = UDim2.new(0, 0, 1, 0),
        BorderColor3 = Color3.fromRGB(0, 0, 0),
        Text = "Region: N/A",
        LayoutOrder = 7,
        AutomaticSize = Enum.AutomaticSize.X,
        Name = "region"
    }, G2L["a1"])

    -- Set flex behavior on footer
    if G2L["18"] and not G2L["18"]:FindFirstChildOfClass("UIFlexItem") then
        New("UIFlexItem", {FlexMode = Enum.UIFlexMode.None}, G2L["18"])
    end

    local Window = mainfunctions.BuildWindow(G2L, config, components)
    Window.Notify = function(self, cfg)
        return NotificationSystem:Notify(cfg)
    end
    mainfunctions.SetTheme(G2L, defaultTheme)
    mainfunctions.InitBehavior(G2L, Window, config.OnClose)
    return Window
end

    return Library
end

