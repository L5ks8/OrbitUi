return function(mainfunctions)
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

    -- Profile
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

    -- Loading text
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

    -- Actions (close button top-right)
    local actions = New("Frame", {
        ZIndex = 5,
        BorderSizePixel = 0,
        BackgroundColor3 = Color3.fromRGB(255, 255, 255),
        AnchorPoint = Vector2.new(1, 0),
        AutomaticSize = Enum.AutomaticSize.XY,
        Position = UDim2.new(1, 0, 0, 0),
        BorderColor3 = Color3.fromRGB(0, 0, 0),
        Name = "actions",
        BackgroundTransparency = 1
    }, profile)

    New("UIPadding", {
        PaddingTop = UDim.new(0, 14),
        PaddingRight = UDim.new(0, 20),
        Name = "Padding",
        PaddingLeft = UDim.new(0, 20),
        PaddingBottom = UDim.new(0, 14)
    }, actions)

    New("UIListLayout", {
        HorizontalAlignment = Enum.HorizontalAlignment.Center,
        Padding = UDim.new(0, 2),
        VerticalAlignment = Enum.VerticalAlignment.Center,
        SortOrder = Enum.SortOrder.LayoutOrder,
        Name = "list",
        FillDirection = Enum.FillDirection.Horizontal
    }, actions)

    local closeBtn = New("ImageButton", {
        BorderSizePixel = 0,
        ImageTransparency = 1,
        BackgroundTransparency = 0.8,
        BackgroundColor3 = Color3.fromRGB(13, 13, 13),
        Size = UDim2.new(0, 22, 0, 22),
        BorderColor3 = Color3.fromRGB(0, 0, 0),
        Name = "close"
    }, actions)
    CollectionService:AddTag(closeBtn, "OrbitModalCloseAction")

    local closeIcon = New("ImageLabel", {
        BorderSizePixel = 0,
        ScaleType = Enum.ScaleType.Fit,
        BackgroundColor3 = Color3.fromRGB(255, 255, 255),
        ImageTransparency = 0.5,
        AnchorPoint = Vector2.new(0.5, 0.5),
        Image = "rbxassetid://11293981586",
        Size = UDim2.new(0, 16, 0, 16),
        BorderColor3 = Color3.fromRGB(0, 0, 0),
        BackgroundTransparency = 1,
        Name = "icon",
        Position = UDim2.new(0.5, 0, 0.5, 0)
    }, closeBtn)
    New("UIScale", {Name = "scale"}, closeIcon)
    New("UICorner", {Name = "corner", CornerRadius = UDim.new(0, 5)}, closeBtn)
    New("UIScale", {Name = "scale"}, closeBtn)

    closeBtn.MouseButton1Click:Connect(function()
        screenGui:Destroy()
    end)

    -- SizeLimit
    New("UISizeConstraint", {MinSize = Vector2.new(0, 300), Name = "SizeLimit"}, profile)

    -- Main
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

    -- Top
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

    -- Top Padding
    New("UIPadding", {
        PaddingTop = UDim.new(0, 20),
        PaddingRight = UDim.new(0, 24),
        Name = "Padding",
        PaddingLeft = UDim.new(0, 24),
        PaddingBottom = UDim.new(0, 20)
    }, top)

    -- Extra / Fade
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

    -- Left panel
    local leftPanel = New("Frame", {
        BorderSizePixel = 0,
        BackgroundColor3 = Color3.fromRGB(26, 26, 26),
        Size = UDim2.new(0.4, 0, 1, 0),
        BorderColor3 = Color3.fromRGB(0, 0, 0),
        Name = "Left",
        LayoutOrder = 1,
        BackgroundTransparency = 1
    }, container)

    -- Viewport
    local viewport = New("ViewportFrame", {
        BorderSizePixel = 0,
        BackgroundColor3 = Color3.fromRGB(26, 26, 26),
        Size = UDim2.new(1, 0, 0.55, 0),
        BorderColor3 = Color3.fromRGB(0, 0, 0),
        Name = "Avatar",
        LayoutOrder = 2
    }, leftPanel)

    local camera = Instance.new("Camera")
    camera.FieldOfView = 35
    camera.CFrame = CFrame.new(Vector3.new(0, 1.5, 3.5), Vector3.new(0, 1.5, 0))
    viewport.CurrentCamera = camera

    local charClone
    local function loadCharacter()
        if charClone then charClone:Destroy() end
        local origChar = LocalPlayer.Character
        if not origChar then return end
        local wasArchivable = origChar.Archivable
        origChar.Archivable = true
        charClone = origChar:Clone()
        origChar.Archivable = wasArchivable
        for _, child in ipairs(charClone:GetDescendants()) do
            if child:IsA("LuaSourceContainer") or child:IsA("Sound") or child:IsA("ForceField") then
                child:Destroy()
            end
        end
        for _, part in ipairs(charClone:GetDescendants()) do
            if part:IsA("BasePart") then
                part.Anchored = true
                part.CanCollide = false
            end
        end
        charClone.Parent = viewport
    end

    task.spawn(loadCharacter)
    LocalPlayer.CharacterAdded:Connect(function()
        task.wait(0.5)
        loadCharacter()
    end)

    New("UICorner", {Name = "corner", CornerRadius = UDim.new(0.1, 0)}, viewport)

    -- Left info section (Account Age, Playtime)
    New("UIListLayout", {
        Padding = UDim.new(0, 15),
        SortOrder = Enum.SortOrder.LayoutOrder,
        Name = "List"
    }, leftPanel)

    local leftInfo = New("Frame", {
        BorderSizePixel = 0,
        BackgroundColor3 = Color3.fromRGB(255, 255, 255),
        AnchorPoint = Vector2.new(0.5, 0.5),
        AutomaticSize = Enum.AutomaticSize.Y,
        Size = UDim2.new(1, 0, 0, 0),
        Position = UDim2.new(0.5, 0, 0, 0),
        BorderColor3 = Color3.fromRGB(0, 0, 0),
        Name = "info",
        LayoutOrder = 1,
        BackgroundTransparency = 1
    }, leftPanel)
    CollectionService:AddTag(leftInfo, "OrbitProfileCategory")

    New("UIListLayout", {
        HorizontalAlignment = Enum.HorizontalAlignment.Center,
        Padding = UDim.new(0, 10),
        SortOrder = Enum.SortOrder.LayoutOrder,
        Name = "List",
        FillDirection = Enum.FillDirection.Horizontal
    }, leftInfo)

    New("UIPadding", {
        Name = "Padding",
        PaddingBottom = UDim.new(0, 12)
    }, leftInfo)

    -- Account Age card
    local ageCard = New("ImageButton", {
        Active = false,
        BorderSizePixel = 0,
        AutoButtonColor = false,
        BackgroundColor3 = Color3.fromRGB(23, 23, 23),
        Selectable = false,
        AnchorPoint = Vector2.new(0.5, 0.5),
        AutomaticSize = Enum.AutomaticSize.X,
        Size = UDim2.new(0, 100, 0, 75),
        LayoutOrder = 2,
        BorderColor3 = Color3.fromRGB(0, 0, 0),
        Name = "Age"
    }, leftInfo)

    New("UICorner", {Name = "Corner", CornerRadius = UDim.new(0, 18)}, ageCard)
    New("UIFlexItem", {Name = "Flex", FlexMode = Enum.UIFlexMode.Fill}, ageCard)

    local ageName = New("TextLabel", {
        BorderSizePixel = 0,
        TextSize = 15,
        TextXAlignment = Enum.TextXAlignment.Left,
        TextTransparency = 0.8,
        BackgroundColor3 = Color3.fromRGB(255, 255, 255),
        FontFace = Font.new("rbxassetid://12187365364", Enum.FontWeight.SemiBold, Enum.FontStyle.Normal),
        TextColor3 = Color3.fromRGB(255, 255, 255),
        BackgroundTransparency = 1,
        Size = UDim2.new(0, 0, 0, 18),
        BorderColor3 = Color3.fromRGB(0, 0, 0),
        Text = "Account Age",
        AutomaticSize = Enum.AutomaticSize.X,
        Name = "Name"
    }, ageCard)
    ageName:SetAttribute("Key", "orbit.modals.player.accountage")
    CollectionService:AddTag(ageName, "OrbitTranslation")
    New("UIPadding", {PaddingRight = UDim.new(0, 12), Name = "Padding"}, ageName)

    local ageValue = New("TextLabel", {
        TextWrapped = true,
        TextTruncate = Enum.TextTruncate.AtEnd,
        ZIndex = 2,
        BorderSizePixel = 0,
        AutoLocalize = false,
        TextSize = 22,
        TextXAlignment = Enum.TextXAlignment.Left,
        TextYAlignment = Enum.TextYAlignment.Bottom,
        TextScaled = true,
        BackgroundColor3 = Color3.fromRGB(0, 0, 0),
        FontFace = Font.new("rbxassetid://12187365364", Enum.FontWeight.SemiBold, Enum.FontStyle.Normal),
        TextColor3 = Color3.fromRGB(255, 255, 255),
        BackgroundTransparency = 1,
        AnchorPoint = Vector2.new(0, 1),
        Size = UDim2.new(0, 0, 0, 26),
        BorderColor3 = Color3.fromRGB(0, 0, 0),
        Text = "NaN",
        LayoutOrder = 1,
        AutomaticSize = Enum.AutomaticSize.X,
        Name = "Value",
        Position = UDim2.new(0, 0, 1, 0)
    }, ageCard)
    New("UIPadding", {PaddingRight = UDim.new(0, 12), Name = "Padding"}, ageValue)

    local ageDays = LocalPlayer.AccountAge
    if ageDays then
        if ageDays < 30 then
            ageValue.Text = ageDays .. "d"
        elseif ageDays < 365 then
            ageValue.Text = math.floor(ageDays / 30) .. "m"
        else
            local years = math.floor(ageDays / 365)
            ageValue.Text = years .. "y"
        end
    end

    New("UIPadding", {
        PaddingTop = UDim.new(0, 15),
        PaddingRight = UDim.new(0, 17),
        Name = "Padding",
        PaddingLeft = UDim.new(0, 17),
        PaddingBottom = UDim.new(0, 15)
    }, ageCard)

    -- Playtime card
    local playtimeCard = New("ImageButton", {
        Active = false,
        BorderSizePixel = 0,
        AutoButtonColor = false,
        BackgroundColor3 = Color3.fromRGB(23, 23, 23),
        Selectable = false,
        AnchorPoint = Vector2.new(0.5, 0.5),
        AutomaticSize = Enum.AutomaticSize.X,
        Size = UDim2.new(0, 100, 0, 75),
        LayoutOrder = 1,
        BorderColor3 = Color3.fromRGB(0, 0, 0),
        Name = "Playtime"
    }, leftInfo)

    New("UICorner", {Name = "Corner", CornerRadius = UDim.new(0, 18)}, playtimeCard)
    New("UIFlexItem", {Name = "Flex", FlexMode = Enum.UIFlexMode.Fill}, playtimeCard)

    local playtimeName = New("TextLabel", {
        BorderSizePixel = 0,
        TextSize = 15,
        TextXAlignment = Enum.TextXAlignment.Left,
        TextTransparency = 0.8,
        BackgroundColor3 = Color3.fromRGB(255, 255, 255),
        FontFace = Font.new("rbxassetid://12187365364", Enum.FontWeight.SemiBold, Enum.FontStyle.Normal),
        TextColor3 = Color3.fromRGB(255, 255, 255),
        BackgroundTransparency = 1,
        Size = UDim2.new(0, 0, 0, 18),
        BorderColor3 = Color3.fromRGB(0, 0, 0),
        Text = "Playtime",
        AutomaticSize = Enum.AutomaticSize.X,
        Name = "Name"
    }, playtimeCard)
    playtimeName:SetAttribute("Key", "orbit.modals.player.playtime")
    CollectionService:AddTag(playtimeName, "OrbitTranslation")
    New("UIPadding", {PaddingRight = UDim.new(0, 12), Name = "Padding"}, playtimeName)

    local playtimeValue = New("TextLabel", {
        TextWrapped = true,
        TextTruncate = Enum.TextTruncate.AtEnd,
        ZIndex = 2,
        BorderSizePixel = 0,
        AutoLocalize = false,
        TextSize = 22,
        TextXAlignment = Enum.TextXAlignment.Left,
        TextYAlignment = Enum.TextYAlignment.Bottom,
        TextScaled = true,
        BackgroundColor3 = Color3.fromRGB(0, 0, 0),
        FontFace = Font.new("rbxassetid://12187365364", Enum.FontWeight.SemiBold, Enum.FontStyle.Normal),
        TextColor3 = Color3.fromRGB(255, 255, 255),
        BackgroundTransparency = 1,
        AnchorPoint = Vector2.new(0, 1),
        Size = UDim2.new(0, 0, 0, 26),
        BorderColor3 = Color3.fromRGB(0, 0, 0),
        Text = "NaN",
        LayoutOrder = 1,
        AutomaticSize = Enum.AutomaticSize.X,
        Name = "Value",
        Position = UDim2.new(0, 0, 1, 0)
    }, playtimeCard)
    New("UIPadding", {PaddingRight = UDim.new(0, 12), Name = "Padding"}, playtimeValue)

    local sessionStart = os.clock()
    task.spawn(function()
        while screenGui and screenGui.Parent do
            local elapsed = os.clock() - sessionStart
            local hours = math.floor(elapsed / 3600)
            local minutes = math.floor((elapsed % 3600) / 60)
            local seconds = math.floor(elapsed % 60)
            if hours > 0 then
                playtimeValue.Text = string.format("%dh %dm", hours, minutes)
            elseif minutes > 0 then
                playtimeValue.Text = string.format("%dm %ds", minutes, seconds)
            else
                playtimeValue.Text = string.format("%ds", seconds)
            end
            task.wait(1)
        end
    end)

    New("UIPadding", {
        PaddingTop = UDim.new(0, 15),
        PaddingRight = UDim.new(0, 17),
        Name = "Padding",
        PaddingLeft = UDim.new(0, 17),
        PaddingBottom = UDim.new(0, 15)
    }, playtimeCard)

    -- Inspect Avatar button
    local inspectBtn = New("ImageButton", {
        Active = false,
        BorderSizePixel = 0,
        AutoButtonColor = false,
        BackgroundColor3 = Color3.fromRGB(25, 25, 25),
        Selectable = false,
        Size = UDim2.new(1, 0, 0.1, 0),
        LayoutOrder = 3,
        BorderColor3 = Color3.fromRGB(0, 0, 0),
        Name = "inspect_avatar"
    }, leftPanel)

    New("UICorner", {Name = "Corner", CornerRadius = UDim.new(0, 12)}, inspectBtn)

    New("UIListLayout", {
        Padding = UDim.new(0, 10),
        VerticalAlignment = Enum.VerticalAlignment.Center,
        SortOrder = Enum.SortOrder.LayoutOrder,
        Name = "list",
        FillDirection = Enum.FillDirection.Horizontal
    }, inspectBtn)

    New("UIPadding", {
        PaddingRight = UDim.new(0, 12),
        Name = "padding",
        PaddingLeft = UDim.new(0, 12)
    }, inspectBtn)

    local inspectIcon = New("ImageLabel", {
        BorderSizePixel = 0,
        ScaleType = Enum.ScaleType.Fit,
        BackgroundColor3 = Color3.fromRGB(255, 255, 255),
        ImageTransparency = 0.2,
        Image = "rbxassetid://11422143750",
        Size = UDim2.new(0, 17, 0, 17),
        BorderColor3 = Color3.fromRGB(0, 0, 0),
        BackgroundTransparency = 1,
        LayoutOrder = 1,
        Name = "Icon"
    }, inspectBtn)
    New("UIScale", {Name = "scale"}, inspectIcon)

    local inspectLabel = New("TextLabel", {
        BorderSizePixel = 0,
        AutoLocalize = false,
        TextSize = 14,
        TextXAlignment = Enum.TextXAlignment.Left,
        TextTransparency = 0.2,
        BackgroundColor3 = Color3.fromRGB(255, 255, 255),
        FontFace = fonts.med,
        TextColor3 = Color3.fromRGB(255, 255, 255),
        BackgroundTransparency = 1,
        Size = UDim2.new(0.27253, -20, 1, 0),
        BorderColor3 = Color3.fromRGB(0, 0, 0),
        Text = "Inspect Avatar",
        LayoutOrder = 2,
        Name = "Name",
        Position = UDim2.new(0.06649, 0, 0, 0)
    }, inspectBtn)
    inspectLabel:SetAttribute("Key", "orbit.modals.player.inspect")
    CollectionService:AddTag(inspectLabel, "OrbitTranslation")
    New("UIFlexItem", {Name = "flex", FlexMode = Enum.UIFlexMode.Fill}, inspectLabel)

    -- Right panel (Scroll)
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
    local function createCategory(name, order)
        local cat = New("Frame", {
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
        CollectionService:AddTag(cat, "OrbitProfileCategory")

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

        local headerFrame = New("Frame", {
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
        }, headerFrame)

        local leftDiv = New("Frame", {
            BorderSizePixel = 0,
            BackgroundColor3 = Color3.fromRGB(49, 49, 49),
            AnchorPoint = Vector2.new(0.5, 0.5),
            Size = UDim2.new(1, 0, 0, 1),
            Position = UDim2.new(0.5, 0, 0.5, 0),
            BorderColor3 = Color3.fromRGB(0, 0, 0),
            Name = "left",
            LayoutOrder = -999
        }, headerFrame)
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
        }, headerFrame)
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
        }, headerFrame)
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

    -- Advanced category
    local advancedCat = createCategory("advanced", 6)
    advancedCat.Visible = true

    local advContent = New("Frame", {
        BorderSizePixel = 0,
        BackgroundColor3 = Color3.fromRGB(255, 255, 255),
        AutomaticSize = Enum.AutomaticSize.Y,
        Size = UDim2.new(1, 0, 0, 0),
        BorderColor3 = Color3.fromRGB(0, 0, 0),
        Name = "content",
        LayoutOrder = 1,
        BackgroundTransparency = 1
    }, advancedCat)

    New("UIGridLayout", {
        HorizontalAlignment = Enum.HorizontalAlignment.Center,
        CellSize = UDim2.new(0.5, -3, 0, 40),
        SortOrder = Enum.SortOrder.LayoutOrder,
        CellPadding = UDim2.new(0, 6, 0, 6)
    }, advContent)

    -- Loading done
    loading.Visible = false

    return screenGui
end
