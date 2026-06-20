return function(mainfunctions)
    local TweenService = game:GetService("TweenService")
    local CollectionService = game:GetService("CollectionService")
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
        Name = "Profile",
        ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    }, targetParent)

    local profile = New("CanvasGroup", {
        ZIndex = 2,
        BorderSizePixel = 0,
        BackgroundColor3 = Color3.fromRGB(35, 35, 35),
        AnchorPoint = Vector2.new(0.5, 0.5),
        Size = UDim2.new(0.35, 350, 0.7, 0),
        Position = UDim2.new(0.5, 0, 0.5, 0),
        BorderColor3 = Color3.fromRGB(0, 0, 0),
        Name = "Profile"
    }, screenGui)
    profile:SetAttribute("UserId", false)
    profile:SetAttribute("Position", -1)
    profile:SetAttribute("Key", "Profile")
    profile:SetAttribute("Active", false)
    CollectionService:AddTag(profile, "OrbitModalFrame")

    New("UICorner", {Name = "Corner", CornerRadius = UDim.new(0, 28)}, profile)

    local scale = New("UIScale", {Name = "Scale"}, profile)
    CollectionService:AddTag(scale, "OrbitModalFrameScale")

    New("UIPadding", {Name = "Padding"}, profile)

    local loading = New("TextLabel", {
        BorderSizePixel = 0,
        AutoLocalize = false,
        TextSize = 15,
        TextTransparency = 0.8,
        BackgroundColor3 = Color3.fromRGB(255, 255, 255),
        FontFace = fonts.med,
        TextColor3 = Color3.fromRGB(255, 255, 255),
        BackgroundTransparency = 1,
        AnchorPoint = Vector2.new(0.5, 0.5),
        Size = UDim2.new(1, 0, 0, 20),
        BorderColor3 = Color3.fromRGB(0, 0, 0),
        Text = "Loading",
        Name = "Proccess",
        Position = UDim2.new(0.5, 0, 0.5, 0)
    }, profile)

    local main = New("CanvasGroup", {
        ZIndex = 2,
        BorderSizePixel = 0,
        BackgroundColor3 = Color3.fromRGB(35, 35, 35),
        AnchorPoint = Vector2.new(0.5, 0.5),
        Size = UDim2.new(1, 0, 1, 0),
        Position = UDim2.new(0.5, 0, 0.5, 0),
        BorderColor3 = Color3.fromRGB(0, 0, 0),
        Name = "Main"
    }, profile)

    New("UIListLayout", {SortOrder = Enum.SortOrder.LayoutOrder, Name = "List"}, main)

    -- Top section
    local top = New("Frame", {
        ZIndex = 50,
        BorderSizePixel = 0,
        BackgroundColor3 = Color3.fromRGB(255, 255, 255),
        AutomaticSize = Enum.AutomaticSize.Y,
        Size = UDim2.new(1, 0, 0, 0),
        BorderColor3 = Color3.fromRGB(0, 0, 0),
        Name = "Top",
        BackgroundTransparency = 1
    }, main)

    New("UIListLayout", {
        Padding = UDim.new(0, 18),
        VerticalAlignment = Enum.VerticalAlignment.Center,
        SortOrder = Enum.SortOrder.LayoutOrder,
        Name = "List",
        FillDirection = Enum.FillDirection.Horizontal
    }, top)

    New("UIPadding", {
        PaddingTop = UDim.new(0, 20),
        PaddingRight = UDim.new(0, 24),
        Name = "Padding",
        PaddingLeft = UDim.new(0, 24),
        PaddingBottom = UDim.new(0, 20)
    }, top)

    local topAvatar = New("ImageLabel", {
        BorderSizePixel = 0,
        BackgroundColor3 = Color3.fromRGB(27, 27, 27),
        Image = "https://www.roblox.com/headshot-thumbnail/image?userId=" .. tostring(userId) .. "&width=420&height=420&format=png",
        Size = UDim2.new(0, 55, 0, 55),
        BorderColor3 = Color3.fromRGB(0, 0, 0),
        Name = "Profile"
    }, top)

    New("UICorner", {Name = "Corner", CornerRadius = UDim.new(0, 16)}, topAvatar)

    -- Information
    local info = New("Frame", {
        BorderSizePixel = 0,
        BackgroundColor3 = Color3.fromRGB(255, 255, 255),
        AutomaticSize = Enum.AutomaticSize.XY,
        BorderColor3 = Color3.fromRGB(0, 0, 0),
        Name = "Information",
        BackgroundTransparency = 1
    }, top)

    New("UIListLayout", {
        Padding = UDim.new(0, 14),
        VerticalAlignment = Enum.VerticalAlignment.Center,
        SortOrder = Enum.SortOrder.LayoutOrder,
        Name = "list",
        FillDirection = Enum.FillDirection.Horizontal
    }, info)

    local infoFrame = New("Frame", {
        BorderSizePixel = 0,
        BackgroundColor3 = Color3.fromRGB(255, 255, 255),
        AutomaticSize = Enum.AutomaticSize.XY,
        BorderColor3 = Color3.fromRGB(0, 0, 0),
        Name = "Info",
        BackgroundTransparency = 1
    }, info)

    New("UIListLayout", {
        Padding = UDim.new(0, 8),
        VerticalAlignment = Enum.VerticalAlignment.Center,
        SortOrder = Enum.SortOrder.LayoutOrder,
        Name = "list"
    }, infoFrame)

    New("TextLabel", {
        TextTruncate = Enum.TextTruncate.SplitWord,
        BorderSizePixel = 0,
        AutoLocalize = false,
        TextSize = 18,
        TextXAlignment = Enum.TextXAlignment.Left,
        BackgroundColor3 = Color3.fromRGB(0, 0, 0),
        FontFace = fonts.med,
        TextColor3 = Color3.fromRGB(255, 255, 255),
        BackgroundTransparency = 1,
        AnchorPoint = Vector2.new(0.5, 0),
        Size = UDim2.new(0, 0, 0, 10),
        BorderColor3 = Color3.fromRGB(0, 0, 0),
        Text = displayName,
        LayoutOrder = 1,
        AutomaticSize = Enum.AutomaticSize.X,
        Name = "Display",
        Position = UDim2.new(0.5, 0, 0, 0)
    }, infoFrame)

    New("TextLabel", {
        TextTruncate = Enum.TextTruncate.SplitWord,
        BorderSizePixel = 0,
        AutoLocalize = false,
        TextSize = 12,
        TextXAlignment = Enum.TextXAlignment.Left,
        TextTransparency = 0.5,
        BackgroundColor3 = Color3.fromRGB(0, 0, 0),
        FontFace = fonts.reg,
        TextColor3 = Color3.fromRGB(255, 255, 255),
        BackgroundTransparency = 1,
        AnchorPoint = Vector2.new(0.5, 0.5),
        Size = UDim2.new(0, 0, 0, 10),
        BorderColor3 = Color3.fromRGB(0, 0, 0),
        Text = "@" .. userName,
        LayoutOrder = 5,
        AutomaticSize = Enum.AutomaticSize.X,
        Name = "Username",
        Position = UDim2.new(0.5, 0, 0.5, 0)
    }, infoFrame)

    -- Badges
    local badges = New("Frame", {
        BorderSizePixel = 0,
        BackgroundColor3 = Color3.fromRGB(25, 25, 25),
        AutomaticSize = Enum.AutomaticSize.XY,
        BorderColor3 = Color3.fromRGB(0, 0, 0),
        Name = "Badges",
        LayoutOrder = 2,
        BackgroundTransparency = 0.25
    }, info)

    New("UIListLayout", {
        HorizontalAlignment = Enum.HorizontalAlignment.Center,
        Wraps = true,
        Padding = UDim.new(0, 6),
        VerticalAlignment = Enum.VerticalAlignment.Center,
        SortOrder = Enum.SortOrder.LayoutOrder,
        Name = "list",
        FillDirection = Enum.FillDirection.Horizontal
    }, badges)

    New("UIPadding", {
        PaddingTop = UDim.new(0, 6),
        PaddingRight = UDim.new(0, 8),
        Name = "Padding",
        PaddingLeft = UDim.new(0, 8),
        PaddingBottom = UDim.new(0, 6)
    }, badges)

    New("ImageLabel", {
        BorderSizePixel = 0,
        BackgroundColor3 = Color3.fromRGB(255, 255, 255),
        Image = "rbxasset://textures/ui/VerifiedBadgeNameIcon.png",
        Size = UDim2.new(0, 18, 0, 18),
        BorderColor3 = Color3.fromRGB(0, 0, 0),
        BackgroundTransparency = 1,
        LayoutOrder = 2,
        Name = "Verified"
    }, badges)

    New("ImageLabel", {
        BorderSizePixel = 0,
        BackgroundColor3 = Color3.fromRGB(255, 255, 255),
        Image = "rbxasset://textures/ui/PlayerList/PremiumIcon.png",
        Size = UDim2.new(0, 16, 0, 16),
        BorderColor3 = Color3.fromRGB(0, 0, 0),
        BackgroundTransparency = 1,
        LayoutOrder = 1,
        Name = "Premium"
    }, badges)

    New("UICorner", {}, badges)

    -- Extra/Fade
    local extra = New("Folder", {Name = "Extra"}, main)

    local fade = New("Frame", {
        ZIndex = 10,
        BorderSizePixel = 0,
        BackgroundColor3 = Color3.fromRGB(30, 30, 30),
        AutomaticSize = Enum.AutomaticSize.Y,
        Size = UDim2.new(1, 0, 0, 100),
        Position = UDim2.new(0, 0, -0.01466, 0),
        BorderColor3 = Color3.fromRGB(0, 0, 0),
        Name = "Fade"
    }, extra)

    New("UIGradient", {
        Rotation = 90,
        Transparency = NumberSequence.new{NumberSequenceKeypoint.new(0, 0), NumberSequenceKeypoint.new(1, 1)}
    }, fade)

    -- Container
    local container = New("Frame", {
        BorderSizePixel = 0,
        BackgroundColor3 = Color3.fromRGB(255, 255, 255),
        Size = UDim2.new(1, 0, 0, 0),
        BorderColor3 = Color3.fromRGB(0, 0, 0),
        Name = "Container",
        BackgroundTransparency = 1
    }, main)

    New("UIFlexItem", {Name = "Flex", FlexMode = Enum.UIFlexMode.Fill}, container)
    New("UIListLayout", {
        VerticalAlignment = Enum.VerticalAlignment.Center,
        SortOrder = Enum.SortOrder.LayoutOrder,
        Name = "List",
        FillDirection = Enum.FillDirection.Horizontal
    }, container)
    New("UIPadding", {
        PaddingRight = UDim.new(0.02, 0),
        Name = "Padding",
        PaddingLeft = UDim.new(0.02, 0)
    }, container)

    -- Left panel (viewport)
    local leftPanel = New("Frame", {
        BorderSizePixel = 0,
        BackgroundColor3 = Color3.fromRGB(26, 26, 26),
        Size = UDim2.new(0.4, 0, 1, 0),
        BorderColor3 = Color3.fromRGB(0, 0, 0),
        Name = "Left",
        LayoutOrder = 1,
        BackgroundTransparency = 1
    }, container)

    local viewport = New("ViewportFrame", {
        BorderSizePixel = 0,
        BackgroundColor3 = Color3.fromRGB(26, 26, 26),
        Size = UDim2.new(1, 0, 0.55, 0),
        BorderColor3 = Color3.fromRGB(0, 0, 0),
        Name = "Avatar",
        LayoutOrder = 2
    }, leftPanel)

    local worldModel = New("WorldModel", {
        WorldPivot = CFrame.new(Vector3.new(72, -5.0503, 79), Vector3.new(0.17365, 0, 0.98481)),
        Name = "Model"
    }, viewport)

    -- Right panel (scroll)
    local scroll = New("ScrollingFrame", {
        Active = true,
        BorderSizePixel = 0,
        CanvasSize = UDim2.new(0, 0, 0, 0),
        TopImage = "",
        Name = "Scroll",
        ScrollBarImageTransparency = 1,
        BackgroundColor3 = Color3.fromRGB(255, 255, 255),
        MidImage = "",
        BottomImage = "",
        AutomaticCanvasSize = Enum.AutomaticSize.Y,
        ClipsDescendants = false,
        Size = UDim2.new(0, 0, 1, 0),
        BorderColor3 = Color3.fromRGB(0, 0, 0),
        ScrollBarThickness = 0,
        LayoutOrder = 2,
        BackgroundTransparency = 1
    }, container)

    New("UIListLayout", {
        HorizontalAlignment = Enum.HorizontalAlignment.Center,
        Padding = UDim.new(0, 14),
        SortOrder = Enum.SortOrder.LayoutOrder,
        Name = "List"
    }, scroll)

    New("UIPadding", {
        PaddingRight = UDim.new(0, 28),
        Name = "Padding",
        PaddingLeft = UDim.new(0, 28),
        PaddingBottom = UDim.new(0, 28)
    }, scroll)

    New("UIFlexItem", {Name = "Flex", FlexMode = Enum.UIFlexMode.Fill}, scroll)

    -- Helper: Category
    local function createCategory(name, order, tag)
        local cat = New("Frame", {
            Visible = false,
            BorderSizePixel = 0,
            BackgroundColor3 = Color3.fromRGB(255, 255, 255),
            AnchorPoint = Vector2.new(0.5, 0.5),
            AutomaticSize = Enum.AutomaticSize.Y,
            Size = UDim2.new(1, 0, 0, 0),
            BorderColor3 = Color3.fromRGB(0, 0, 0),
            Name = name,
            LayoutOrder = order,
            BackgroundTransparency = 1
        }, scroll)
        CollectionService:AddTag(cat, tag or "OrbitProfileCategory")

        New("UIListLayout", {
            HorizontalAlignment = Enum.HorizontalAlignment.Center,
            Wraps = true,
            Padding = UDim.new(0, 6),
            SortOrder = Enum.SortOrder.LayoutOrder,
            Name = "Layout",
            FillDirection = Enum.FillDirection.Horizontal
        }, cat)

        New("UIPadding", {
            PaddingTop = UDim.new(0, 12),
            Name = "Padding",
            PaddingBottom = UDim.new(0, 3)
        }, cat)

        local header = New("Frame", {
            BorderSizePixel = 0,
            BackgroundColor3 = Color3.fromRGB(49, 49, 49),
            AnchorPoint = Vector2.new(0.5, 0),
            AutomaticSize = Enum.AutomaticSize.Y,
            Size = UDim2.new(1, -40, 0, 1),
            Position = UDim2.new(0.5, 0, 0, -11),
            BorderColor3 = Color3.fromRGB(0, 0, 0),
            Name = "header",
            LayoutOrder = -999999,
            BackgroundTransparency = 1
        }, cat)

        New("UIListLayout", {
            Padding = UDim.new(0, 12),
            VerticalAlignment = Enum.VerticalAlignment.Center,
            SortOrder = Enum.SortOrder.LayoutOrder,
            Name = "List",
            FillDirection = Enum.FillDirection.Horizontal
        }, header)

        local leftDiv = New("Frame", {
            BorderSizePixel = 0,
            BackgroundColor3 = Color3.fromRGB(49, 49, 49),
            AnchorPoint = Vector2.new(0.5, 0.5),
            Size = UDim2.new(1, 0, 0, 1),
            Position = UDim2.new(0.5, 0, 0.5, 0),
            BorderColor3 = Color3.fromRGB(0, 0, 0),
            Name = "left",
            LayoutOrder = -999
        }, header)
        New("UIFlexItem", {Name = "Flex", FlexMode = Enum.UIFlexMode.Fill}, leftDiv)

        local headerLabel = New("TextLabel", {
            BorderSizePixel = 0,
            TextSize = 16,
            TextTransparency = 0.8,
            BackgroundColor3 = Color3.fromRGB(255, 255, 255),
            FontFace = Font.new("rbxassetid://12187365364", Enum.FontWeight.SemiBold, Enum.FontStyle.Normal),
            TextColor3 = Color3.fromRGB(255, 255, 255),
            BackgroundTransparency = 1,
            BorderColor3 = Color3.fromRGB(0, 0, 0),
            Text = name:gsub("^%l", string.upper),
            LayoutOrder = 1,
            AutomaticSize = Enum.AutomaticSize.XY,
            Name = "header"
        }, header)
        headerLabel:SetAttribute("Key", "orbit.modals.player." .. name)

        local rightDiv = New("Frame", {
            BorderSizePixel = 0,
            BackgroundColor3 = Color3.fromRGB(49, 49, 49),
            AnchorPoint = Vector2.new(0.5, 0.5),
            Size = UDim2.new(1, 0, 0, 1),
            Position = UDim2.new(0.5, 0, 0.5, 0),
            BorderColor3 = Color3.fromRGB(0, 0, 0),
            Name = "right",
            LayoutOrder = 999
        }, header)
        New("UIFlexItem", {Name = "Flex", FlexMode = Enum.UIFlexMode.Fill}, rightDiv)

        return cat
    end

    -- Helper: Grid button
    local function createGridButton(parent, name, iconId, callback)
        local btn = New("ImageButton", {
            Active = false,
            BorderSizePixel = 0,
            AutoButtonColor = false,
            BackgroundColor3 = Color3.fromRGB(25, 25, 25),
            Selectable = false,
            Size = UDim2.new(0.5, -3, 0, 40),
            LayoutOrder = 12,
            BorderColor3 = Color3.fromRGB(0, 0, 0),
            Name = name
        }, parent)

        New("UICorner", {Name = "Corner", CornerRadius = UDim.new(0, 12)}, btn)

        New("UIListLayout", {
            Padding = UDim.new(0, 10),
            VerticalAlignment = Enum.VerticalAlignment.Center,
            SortOrder = Enum.SortOrder.LayoutOrder,
            Name = "list",
            FillDirection = Enum.FillDirection.Horizontal
        }, btn)

        New("UIPadding", {
            PaddingRight = UDim.new(0, 12),
            Name = "padding",
            PaddingLeft = UDim.new(0, 12)
        }, btn)

        local icon = New("ImageLabel", {
            BorderSizePixel = 0,
            ScaleType = Enum.ScaleType.Fit,
            BackgroundColor3 = Color3.fromRGB(255, 255, 255),
            ImageTransparency = 0.2,
            Image = "rbxassetid://" .. iconId,
            Size = UDim2.new(0, 17, 0, 17),
            BorderColor3 = Color3.fromRGB(0, 0, 0),
            BackgroundTransparency = 1,
            LayoutOrder = 1,
            Name = "Icon"
        }, btn)
        New("UIScale", {Name = "scale"}, icon)

        local nameLabel = New("TextLabel", {
            BorderSizePixel = 0,
            AutoLocalize = false,
            TextSize = 14,
            TextXAlignment = Enum.TextXAlignment.Left,
            TextTransparency = 0.2,
            BackgroundColor3 = Color3.fromRGB(255, 255, 255),
            FontFace = fonts.med,
            TextColor3 = Color3.fromRGB(255, 255, 255),
            BackgroundTransparency = 1,
            Size = UDim2.new(1, -20, 1, 0),
            BorderColor3 = Color3.fromRGB(0, 0, 0),
            Text = name:gsub("^%l", string.upper),
            LayoutOrder = 2,
            Name = "Name"
        }, btn)
        nameLabel:SetAttribute("Key", "orbit.modals.player." .. name)
        New("UIFlexItem", {Name = "flex", FlexMode = Enum.UIFlexMode.Fill}, nameLabel)

        New("UIFlexItem", {Name = "flex", FlexMode = Enum.UIFlexMode.Fill}, btn)

        if callback then
            btn.MouseButton1Click:Connect(callback)
        end

        return btn
    end

    -- Character category
    local characterCat = createCategory("character", 5)
    characterCat.Visible = true

    local charContent = New("Frame", {
        BorderSizePixel = 0,
        BackgroundColor3 = Color3.fromRGB(255, 255, 255),
        AutomaticSize = Enum.AutomaticSize.Y,
        Size = UDim2.new(1, 0, 0, 0),
        BorderColor3 = Color3.fromRGB(0, 0, 0),
        Name = "content",
        LayoutOrder = 1,
        BackgroundTransparency = 1
    }, characterCat)

    New("UIGridLayout", {
        CellSize = UDim2.new(0.5, -6, 0, 40),
        SortOrder = Enum.SortOrder.LayoutOrder,
        CellPadding = UDim2.new(0, 6, 0, 6)
    }, charContent)

    createGridButton(charContent, "kill", "12967641870", function()
        local char = LocalPlayer.Character
        if char and char:FindFirstChild("Humanoid") then
            char.Humanoid.Health = 0
        end
    end)

    -- Advanced category (no buttons)
    local advancedCat = createCategory("advanced", 6)
    advancedCat.Visible = true


    -- Loading done
    loading.Visible = false

    -- Close button
    local closeBtn = New("ImageButton", {
        Name = "close",
        BorderSizePixel = 0,
        Size = UDim2.new(0, 22, 0, 22),
        BackgroundTransparency = 0.8,
        BackgroundColor3 = Color3.fromRGB(13, 13, 13),
        Position = UDim2.new(1, -28, 0, 10),
        AnchorPoint = Vector2.new(1, 0),
        ZIndex = 100
    }, profile)

    New("ImageLabel", {
        Name = "icon",
        AnchorPoint = Vector2.new(0.5, 0.5),
        Position = UDim2.new(0.5, 0, 0.5, 0),
        Size = UDim2.new(0, 16, 0, 16),
        BackgroundTransparency = 1,
        BorderSizePixel = 0,
        Image = "rbxassetid://11293981586"
    }, closeBtn)

    New("UICorner", {CornerRadius = UDim.new(0, 5)}, closeBtn)
    New("UIScale", {}, closeBtn)

    closeBtn.MouseButton1Click:Connect(function()
        screenGui:Destroy()
    end)

    return screenGui
end
