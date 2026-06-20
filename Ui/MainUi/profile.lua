local CollectionService = game:GetService("CollectionService")

return function(mainfunctions)
    local New = mainfunctions.New
    local fonts = mainfunctions.GetFonts()
    local Players = game:GetService("Players")
    local LocalPlayer = Players.LocalPlayer
    local targetParent = (gethui and gethui()) or game:GetService("CoreGui") or (LocalPlayer and LocalPlayer:WaitForChild("PlayerGui"))

    if not targetParent then
        error("Orbit UI: Could not locate a valid GUI parent container.")
    end

    local userId = LocalPlayer and LocalPlayer.UserId or 0
    local displayName = LocalPlayer and LocalPlayer.DisplayName or "Offline Developer"
    local userName = LocalPlayer and LocalPlayer.Name or "dev"

    local screenGui = New("ScreenGui", {
        Name = "OrbitProfile",
        IgnoreGuiInset = true,
        ResetOnSpawn = false,
        ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    }, targetParent)

    local profileFrame = New("Frame", {
        Name = "Profile",
        AnchorPoint = Vector2.new(0.5, 0.5),
        Position = UDim2.new(0.5, 0, 0.5, 0),
        Size = UDim2.new(0.35, 350, 0.7, 0),
        BackgroundColor3 = Color3.fromRGB(35, 35, 35),
        BorderSizePixel = 0,
        BorderColor3 = Color3.fromRGB(0, 0, 0)
    }, screenGui)

    New("UICorner", {CornerRadius = UDim.new(0, 28)}, profileFrame)
    New("UIScale", {}, profileFrame)
    New("UIPadding", {
        PaddingTop = UDim.new(0, 20),
        PaddingBottom = UDim.new(0, 20),
        PaddingLeft = UDim.new(0, 24),
        PaddingRight = UDim.new(0, 24)
    }, profileFrame)

    -- Top section
    local topSection = New("Frame", {
        Name = "Top",
        BackgroundTransparency = 1,
        BorderSizePixel = 0,
        Size = UDim2.new(1, 0, 0, 80)
    }, profileFrame)

    New("UIListLayout", {
        FillDirection = Enum.FillDirection.Horizontal,
        VerticalAlignment = Enum.VerticalAlignment.Center,
        Padding = UDim.new(0, 18)
    }, topSection)

    local avatar = New("ImageLabel", {
        Name = "Avatar",
        Size = UDim2.new(0, 55, 0, 55),
        BackgroundColor3 = Color3.fromRGB(27, 27, 27),
        BorderSizePixel = 0,
        BackgroundTransparency = 1,
        Image = "https://www.roblox.com/headshot-thumbnail/image?userId=" .. tostring(userId) .. "&width=420&height=420&format=png"
    }, topSection)
    New("UICorner", {CornerRadius = UDim.new(0, 16)}, avatar)

    local infoGroup = New("Frame", {
        Name = "Information",
        BackgroundTransparency = 1,
        BorderSizePixel = 0,
        AutomaticSize = Enum.AutomaticSize.XY
    }, topSection)

    New("UIListLayout", {
        FillDirection = Enum.FillDirection.Horizontal,
        VerticalAlignment = Enum.VerticalAlignment.Center,
        Padding = UDim.new(0, 14)
    }, infoGroup)

    local infoText = New("Frame", {
        Name = "Info",
        BackgroundTransparency = 1,
        BorderSizePixel = 0,
        AutomaticSize = Enum.AutomaticSize.XY
    }, infoGroup)

    New("UIListLayout", {
        Padding = UDim.new(0, 8),
        FillDirection = Enum.FillDirection.Vertical,
        VerticalAlignment = Enum.VerticalAlignment.Center,
        SortOrder = Enum.SortOrder.LayoutOrder
    }, infoText)

    New("TextLabel", {
        Name = "Display",
        Text = displayName,
        FontFace = fonts.med,
        TextSize = 18,
        TextColor3 = Color3.new(1, 1, 1),
        BackgroundTransparency = 1,
        TextXAlignment = Enum.TextXAlignment.Left,
        AutomaticSize = Enum.AutomaticSize.X,
        BorderSizePixel = 0
    }, infoText)

    New("TextLabel", {
        Name = "Username",
        Text = "@" .. userName,
        FontFace = fonts.reg,
        TextSize = 12,
        TextColor3 = Color3.new(1, 1, 1),
        TextTransparency = 0.5,
        BackgroundTransparency = 1,
        TextXAlignment = Enum.TextXAlignment.Left,
        AutomaticSize = Enum.AutomaticSize.X,
        BorderSizePixel = 0
    }, infoText)

    local badges = New("Frame", {
        Name = "Badges",
        BackgroundColor3 = Color3.fromRGB(25, 25, 25),
        BackgroundTransparency = 0.25,
        BorderSizePixel = 0,
        AutomaticSize = Enum.AutomaticSize.XY,
        LayoutOrder = 2
    }, infoGroup)

    New("UIListLayout", {
        FillDirection = Enum.FillDirection.Horizontal,
        HorizontalAlignment = Enum.HorizontalAlignment.Center,
        VerticalAlignment = Enum.VerticalAlignment.Center,
        Wraps = true,
        Padding = UDim.new(0, 6)
    }, badges)

    New("UIPadding", {
        PaddingTop = UDim.new(0, 6),
        PaddingBottom = UDim.new(0, 6),
        PaddingLeft = UDim.new(0, 8),
        PaddingRight = UDim.new(0, 8)
    }, badges)

    New("ImageLabel", {
        Name = "Verified",
        Size = UDim2.new(0, 18, 0, 18),
        BackgroundTransparency = 1,
        BorderSizePixel = 0,
        Image = "rbxasset://textures/ui/VerifiedBadgeNameIcon.png"
    }, badges)

    New("ImageLabel", {
        Name = "Premium",
        Size = UDim2.new(0, 16, 0, 16),
        BackgroundTransparency = 1,
        BorderSizePixel = 0,
        Image = "rbxasset://textures/ui/PlayerList/PremiumIcon.png"
    }, badges)

    -- Scroll container
    local scrollHolder = New("Frame", {
        Name = "Container",
        BackgroundTransparency = 1,
        BorderSizePixel = 0,
        Size = UDim2.new(1, 0, 1, -100)
    }, profileFrame)

    local scroll = New("ScrollingFrame", {
        Name = "Scroll",
        Active = true,
        BackgroundTransparency = 1,
        BorderSizePixel = 0,
        Size = UDim2.new(1, 0, 1, 0),
        AutomaticCanvasSize = Enum.AutomaticSize.Y,
        ScrollBarThickness = 0,
        CanvasSize = UDim2.new(0, 0, 0, 0)
    }, scrollHolder)

    New("UIListLayout", {
        HorizontalAlignment = Enum.HorizontalAlignment.Center,
        Padding = UDim.new(0, 14),
        SortOrder = Enum.SortOrder.LayoutOrder,
        FillDirection = Enum.FillDirection.Horizontal
    }, scroll)

    New("UIPadding", {
        PaddingLeft = UDim.new(0, 28),
        PaddingRight = UDim.new(0, 28),
        PaddingBottom = UDim.new(0, 28)
    }, scroll)

    local function createCategory(name, order)
        local category = New("Frame", {
            Name = name,
            BackgroundTransparency = 1,
            BorderSizePixel = 0,
            AutomaticSize = Enum.AutomaticSize.Y,
            Size = UDim2.new(1, 0, 0, 0),
            LayoutOrder = order
        }, scroll)

        CollectionService:AddTag(category, "OrbitProfileCategory")

        New("UIListLayout", {
            HorizontalAlignment = Enum.HorizontalAlignment.Center,
            Wraps = true,
            Padding = UDim.new(0, 6),
            SortOrder = Enum.SortOrder.LayoutOrder,
            FillDirection = Enum.FillDirection.Horizontal
        }, category)

        New("UIPadding", {
            PaddingTop = UDim.new(0, 12),
            PaddingBottom = UDim.new(0, 3)
        }, category)

        local header = New("Frame", {
            Name = "header",
            BackgroundTransparency = 1,
            BorderSizePixel = 0,
            AutomaticSize = Enum.AutomaticSize.Y,
            Size = UDim2.new(1, -40, 0, 1),
            AnchorPoint = Vector2.new(0.5, 0),
            Position = UDim2.new(0.5, 0, 0, -11),
            LayoutOrder = -999999
        }, category)

        New("UIListLayout", {
            Padding = UDim.new(0, 12),
            FillDirection = Enum.FillDirection.Horizontal,
            VerticalAlignment = Enum.VerticalAlignment.Center,
            SortOrder = Enum.SortOrder.LayoutOrder
        }, header)

        local title = New("TextLabel", {
            Name = "header",
            Text = name,
            TextSize = 16,
            TextTransparency = 0.8,
            FontFace = fonts.med,
            TextColor3 = Color3.new(1, 1, 1),
            BackgroundTransparency = 1,
            AutomaticSize = Enum.AutomaticSize.XY,
            BorderSizePixel = 0
        }, header)

        CollectionService:AddTag(title, "OrbitTranslation")

        New("TextLabel", {
            Name = "subtitle",
            Text = "Quick actions",
            TextSize = 14,
            FontFace = fonts.reg,
            TextColor3 = Color3.new(1, 1, 1),
            BackgroundTransparency = 1,
            AutomaticSize = Enum.AutomaticSize.XY,
            BorderSizePixel = 0,
            TextXAlignment = Enum.TextXAlignment.Left
        }, category)

        return category
    end

    createCategory("Humanoid", 1)
    createCategory("Character", 2)
    createCategory("Advanced", 3)

    -- Action buttons
    local actions = New("Frame", {
        Name = "actions",
        ZIndex = 5,
        AnchorPoint = Vector2.new(1, 0),
        Position = UDim2.new(1, 0, 0, 0),
        AutomaticSize = Enum.AutomaticSize.XY,
        BorderSizePixel = 0,
        BackgroundTransparency = 1
    }, profileFrame)

    New("UIPadding", {
        PaddingTop = UDim.new(0, 14),
        PaddingRight = UDim.new(0, 20),
        PaddingLeft = UDim.new(0, 20),
        PaddingBottom = UDim.new(0, 14)
    }, actions)

    New("UIListLayout", {
        FillDirection = Enum.FillDirection.Horizontal,
        VerticalAlignment = Enum.VerticalAlignment.Center,
        HorizontalAlignment = Enum.HorizontalAlignment.Center,
        Padding = UDim.new(0, 2),
        SortOrder = Enum.SortOrder.LayoutOrder
    }, actions)

    local closeButton = New("ImageButton", {
        Name = "close",
        BorderSizePixel = 0,
        Size = UDim2.new(0, 22, 0, 22),
        BackgroundTransparency = 0.8,
        BackgroundColor3 = Color3.fromRGB(13, 13, 13)
    }, actions)

    CollectionService:AddTag(closeButton, "OrbitModalCloseAction")

    New("ImageLabel", {
        Name = "icon",
        AnchorPoint = Vector2.new(0.5, 0.5),
        Position = UDim2.new(0.5, 0, 0.5, 0),
        Size = UDim2.new(0, 16, 0, 16),
        BackgroundTransparency = 1,
        BorderSizePixel = 0,
        Image = "rbxassetid://11293981586"
    }, closeButton)

    New("UICorner", {CornerRadius = UDim.new(0, 5)}, closeButton)
    New("UIScale", {}, closeButton)

    New("UISizeConstraint", {MinSize = Vector2.new(0, 300)}, profileFrame)

    return screenGui
end
