return function(mainfunctions, components)
    local CollectionService = game:GetService("CollectionService")
    local New = mainfunctions.New
    local fonts = mainfunctions.GetFonts()
    local Players = game:GetService("Players")
    local LocalPlayer = Players.LocalPlayer
    local targetParent = (gethui and gethui()) or game:GetService("CoreGui") or (LocalPlayer and LocalPlayer:WaitForChild("PlayerGui"))

    if not targetParent then
        error("Orbit UI: Could not locate a valid GUI parent container.")
    end

    -- Show loading screen
    local loadingScreen
    local loadStart = os.clock()
    if components and components.loading then
        local ok, loadScr = pcall(components.loading, mainfunctions)
        if ok and loadScr then
            loadingScreen = loadScr
        end
    end

    local userId = LocalPlayer and LocalPlayer.UserId or 0
    local displayName = LocalPlayer and LocalPlayer.DisplayName or "Offline Developer"
    local userName = LocalPlayer and LocalPlayer.Name or "dev"
    local TweenService = game:GetService("TweenService")
    local UserInputService = game:GetService("UserInputService")

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
        Size = UDim2.new(0.32, 0, 0.52, 0),
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
    scale.Scale = 0
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
        local closeTween = TweenService:Create(scale, TweenInfo.new(0.15, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Scale = 0})
        closeTween.Completed:Connect(function()
            screenGui:Destroy()
        end)
        closeTween:Play()
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
    camera.FieldOfView = 30
    viewport.CurrentCamera = camera

    local function findRigPart(rig, partName)
        local part = rig:FindFirstChild(partName)
        if part then return part end
        local r15toR6 = {
            UpperTorso = "Torso",
            LowerTorso = "Torso",
            LeftUpperArm = "Left Arm",
            LeftLowerArm = "Left Arm",
            LeftHand = "Left Arm",
            RightUpperArm = "Right Arm",
            RightLowerArm = "Right Arm",
            RightHand = "Right Arm",
            LeftUpperLeg = "Left Leg",
            LeftLowerLeg = "Left Leg",
            LeftFoot = "Left Leg",
            RightUpperLeg = "Right Leg",
            RightLowerLeg = "Right Leg",
            RightFoot = "Right Leg",
        }
        return rig:FindFirstChild(r15toR6[partName])
    end

    local function buildRig()
        -- WorldModel
        local world = Instance.new("WorldModel")
        world.WorldPivot = CFrame.new(Vector3.new(268, 1257.94971, -1105), Vector3.new(0.17365, 0, 0.98481))
        world.Name = "Model"

        -- Rig (Model)
        local rig = Instance.new("Model")
        rig.WorldPivot = CFrame.new(Vector3.new(0, 0.5, -5.5), Vector3.new(0.17365, 0, 0.98481))
        rig.Name = "Rig"
        rig.Parent = world

        -- Humanoid
        local humanoid = Instance.new("Humanoid", rig)
        humanoid.HealthDisplayType = Enum.HumanoidHealthDisplayType.AlwaysOff
        humanoid.HealthDisplayDistance = 0
        humanoid.DisplayDistanceType = Enum.HumanoidDisplayDistanceType.None
        humanoid.NameDisplayDistance = 0

        -- Shirt & Pants
        local shirt = Instance.new("Shirt", rig)
        shirt.ShirtTemplate = "http://www.roblox.com/asset/?id=8231083597"
        local pants = Instance.new("Pants", rig)
        pants.PantsTemplate = "http://www.roblox.com/asset/?id=8231088930"

        local rootCF = CFrame.new(Vector3.new(0, 0.5, -5.5), Vector3.new(0.17365, 0, 0.98481))
        local rootRot = Vector3.new(180, -10, 180)

        -- Head
        local head = Instance.new("Part", rig)
        head.TopSurface = Enum.SurfaceType.Smooth
        head.CFrame = CFrame.new(Vector3.new(0, 2, -5.5), Vector3.new(0.17365, 0, 0.98481))
        head.Size = Vector3.new(2, 1, 1)
        head.Rotation = rootRot
        head.Name = "Head"
        head.Anchored = true
        head.CanCollide = false
        Instance.new("SpecialMesh", head).Scale = Vector3.new(1.25, 1.25, 1.25)
        local hairAtt = Instance.new("Attachment", head)
        hairAtt.CFrame = CFrame.new(Vector3.new(0, 0.6, 0), Vector3.new(0, 0, -1))
        hairAtt.Name = "HairAttachment"
        local hatAtt = Instance.new("Attachment", head)
        hatAtt.CFrame = CFrame.new(Vector3.new(0, 0.6, 0), Vector3.new(0, 0, -1))
        hatAtt.Name = "HatAttachment"
        local faceFront = Instance.new("Attachment", head)
        faceFront.CFrame = CFrame.new(Vector3.new(0, 0, -0.6), Vector3.new(0, 0, -1))
        faceFront.Name = "FaceFrontAttachment"
        local faceCenter = Instance.new("Attachment", head)
        faceCenter.Name = "FaceCenterAttachment"
        local faceDecal = Instance.new("Decal", head)
        faceDecal.Texture = "rbxasset://textures/face.png"
        faceDecal.ColorMap = "rbxasset://textures/face.png"
        faceDecal.Name = "face"

        -- Torso
        local torso = Instance.new("Part", rig)
        torso.RightSurface = Enum.SurfaceType.Weld
        torso.LeftSurface = Enum.SurfaceType.Weld
        torso.CFrame = rootCF
        torso.Size = Vector3.new(2, 2, 1)
        torso.Rotation = rootRot
        torso.Name = "Torso"
        torso.Anchored = true
        torso.CanCollide = false
        local neckAtt = Instance.new("Attachment", torso)
        neckAtt.CFrame = CFrame.new(Vector3.new(0, 1, 0), Vector3.new(0, 0, -1))
        neckAtt.Name = "NeckAttachment"
        local bodyFront = Instance.new("Attachment", torso)
        bodyFront.CFrame = CFrame.new(Vector3.new(0, 0, -0.5), Vector3.new(0, 0, -1))
        bodyFront.Name = "BodyFrontAttachment"
        local bodyBack = Instance.new("Attachment", torso)
        bodyBack.CFrame = CFrame.new(Vector3.new(0, 0, 0.5), Vector3.new(0, 0, -1))
        bodyBack.Name = "BodyBackAttachment"
        local leftCollar = Instance.new("Attachment", torso)
        leftCollar.CFrame = CFrame.new(Vector3.new(-1, 1, 0), Vector3.new(0, 0, -1))
        leftCollar.Name = "LeftCollarAttachment"
        local rightCollar = Instance.new("Attachment", torso)
        rightCollar.CFrame = CFrame.new(Vector3.new(1, 1, 0), Vector3.new(0, 0, -1))
        rightCollar.Name = "RightCollarAttachment"
        local waistFront = Instance.new("Attachment", torso)
        waistFront.CFrame = CFrame.new(Vector3.new(0, -1, -0.5), Vector3.new(0, 0, -1))
        waistFront.Name = "WaistFrontAttachment"
        local waistCenter = Instance.new("Attachment", torso)
        waistCenter.CFrame = CFrame.new(Vector3.new(0, -1, 0), Vector3.new(0, 0, -1))
        waistCenter.Name = "WaistCenterAttachment"
        local waistBack = Instance.new("Attachment", torso)
        waistBack.CFrame = CFrame.new(Vector3.new(0, -1, 0.5), Vector3.new(0, 0, -1))
        waistBack.Name = "WaistBackAttachment"

        -- Motor6Ds on Torso
        local rShoulder = Instance.new("Motor6D", torso)
        rShoulder.MaxVelocity = 0.1
        rShoulder.C1 = CFrame.new(Vector3.new(-0.5, 0.5, 0), Vector3.new(-1, 0, 0))
        rShoulder.C0 = CFrame.new(Vector3.new(1, 0.5, 0), Vector3.new(-1, 0, 0))
        rShoulder.Name = "Right Shoulder"
        rShoulder.Part0 = torso
        local lShoulder = Instance.new("Motor6D", torso)
        lShoulder.MaxVelocity = 0.1
        lShoulder.C1 = CFrame.new(Vector3.new(0.5, 0.5, 0), Vector3.new(1, 0, 0))
        lShoulder.C0 = CFrame.new(Vector3.new(-1, 0.5, 0), Vector3.new(1, 0, 0))
        lShoulder.Name = "Left Shoulder"
        lShoulder.Part0 = torso
        local rHip = Instance.new("Motor6D", torso)
        rHip.MaxVelocity = 0.1
        rHip.C1 = CFrame.new(Vector3.new(0.5, 1, 0), Vector3.new(-1, 0, 0))
        rHip.C0 = CFrame.new(Vector3.new(1, -1, 0), Vector3.new(-1, 0, 0))
        rHip.Name = "Right Hip"
        rHip.Part0 = torso
        local lHip = Instance.new("Motor6D", torso)
        lHip.MaxVelocity = 0.1
        lHip.C1 = CFrame.new(Vector3.new(-0.5, 1, 0), Vector3.new(1, 0, 0))
        lHip.C0 = CFrame.new(Vector3.new(-1, -1, 0), Vector3.new(1, 0, 0))
        lHip.Name = "Left Hip"
        lHip.Part0 = torso
        local neck = Instance.new("Motor6D", torso)
        neck.MaxVelocity = 0.1
        neck.C1 = CFrame.new(Vector3.new(0, -0.5, 0), Vector3.new(0, -1, 0))
        neck.C0 = CFrame.new(Vector3.new(0, 1, 0), Vector3.new(0, -1, 0))
        neck.Name = "Neck"
        neck.Part0 = torso

        -- Left Arm
        local leftArm = Instance.new("Part", rig)
        leftArm.CanCollide = false
        leftArm.CFrame = CFrame.new(Vector3.new(1.47721, 0.5, -5.76047), Vector3.new(0.17365, 0, 0.98481))
        leftArm.Size = Vector3.new(1, 2, 1)
        leftArm.Rotation = rootRot
        leftArm.Name = "Left Arm"
        leftArm.Anchored = true
        local lShoulderAtt = Instance.new("Attachment", leftArm)
        lShoulderAtt.CFrame = CFrame.new(Vector3.new(0, 1, 0), Vector3.new(0, 0, -1))
        lShoulderAtt.Name = "LeftShoulderAttachment"
        local lGripAtt = Instance.new("Attachment", leftArm)
        lGripAtt.CFrame = CFrame.new(Vector3.new(0, -1, 0), Vector3.new(0, 0, -1))
        lGripAtt.Name = "LeftGripAttachment"
        lShoulder.Part1 = leftArm

        -- Right Arm
        local rightArm = Instance.new("Part", rig)
        rightArm.CanCollide = false
        rightArm.CFrame = CFrame.new(Vector3.new(-1.47721, 0.5, -5.23953), Vector3.new(0.17365, 0, 0.98481))
        rightArm.Size = Vector3.new(1, 2, 1)
        rightArm.Rotation = rootRot
        rightArm.Name = "Right Arm"
        rightArm.Anchored = true
        local rShoulderAtt = Instance.new("Attachment", rightArm)
        rShoulderAtt.CFrame = CFrame.new(Vector3.new(0, 1, 0), Vector3.new(0, 0, -1))
        rShoulderAtt.Name = "RightShoulderAttachment"
        local rGripAtt = Instance.new("Attachment", rightArm)
        rGripAtt.CFrame = CFrame.new(Vector3.new(0, -1, 0), Vector3.new(0, 0, -1))
        rGripAtt.Name = "RightGripAttachment"
        rShoulder.Part1 = rightArm

        -- Left Leg
        local leftLeg = Instance.new("Part", rig)
        leftLeg.BottomSurface = Enum.SurfaceType.Smooth
        leftLeg.CanCollide = false
        leftLeg.CFrame = CFrame.new(Vector3.new(0.4924, -1.5, -5.58682), Vector3.new(0.17365, 0, 0.98481))
        leftLeg.Size = Vector3.new(1, 2, 1)
        leftLeg.Rotation = rootRot
        leftLeg.Name = "Left Leg"
        leftLeg.Anchored = true
        local lFootAtt = Instance.new("Attachment", leftLeg)
        lFootAtt.CFrame = CFrame.new(Vector3.new(0, -1, 0), Vector3.new(0, 0, -1))
        lFootAtt.Name = "LeftFootAttachment"

        -- Right Leg
        local rightLeg = Instance.new("Part", rig)
        rightLeg.BottomSurface = Enum.SurfaceType.Smooth
        rightLeg.CanCollide = false
        rightLeg.CFrame = CFrame.new(Vector3.new(-0.4924, -1.5, -5.41318), Vector3.new(0.17365, 0, 0.98481))
        rightLeg.Size = Vector3.new(1, 2, 1)
        rightLeg.Rotation = rootRot
        rightLeg.Name = "Right Leg"
        rightLeg.Anchored = true
        local rFootAtt = Instance.new("Attachment", rightLeg)
        rFootAtt.CFrame = CFrame.new(Vector3.new(0, -1, 0), Vector3.new(0, 0, -1))
        rFootAtt.Name = "RightFootAttachment"

        -- HumanoidRootPart
        local rootPart = Instance.new("Part", rig)
        rootPart.Anchored = true
        rootPart.BottomSurface = Enum.SurfaceType.Smooth
        rootPart.CanCollide = false
        rootPart.Transparency = 1
        rootPart.TopSurface = Enum.SurfaceType.Smooth
        rootPart.CFrame = rootCF
        rootPart.Size = Vector3.new(2, 2, 1)
        rootPart.Rotation = rootRot
        rootPart.Name = "HumanoidRootPart"
        local rootAtt = Instance.new("Attachment", rootPart)
        rootAtt.Name = "RootAttachment"
        local rootJoint = Instance.new("Motor6D", rootPart)
        rootJoint.MaxVelocity = 0.1
        rootJoint.C1 = CFrame.new(Vector3.new(0, 0, 0), Vector3.new(0, -1, 0))
        rootJoint.C0 = CFrame.new(Vector3.new(0, 0, 0), Vector3.new(0, -1, 0))
        rootJoint.Name = "RootJoint"
        rootJoint.Part0 = rootPart

        -- Set camera to look at the rig
        camera.CFrame = CFrame.lookAt(Vector3.new(0, 0, 7), Vector3.new(0, 0, -5.5))

        -- Apply player appearance
        local playerChar = LocalPlayer.Character
        if playerChar then
            -- Shirt & Pants
            local charShirt = playerChar:FindFirstChildOfClass("Shirt")
            if charShirt and shirt then
                shirt.ShirtTemplate = charShirt.ShirtTemplate
            end
            local charPants = playerChar:FindFirstChildOfClass("Pants")
            if charPants and pants then
                pants.PantsTemplate = charPants.PantsTemplate
            end
            -- Body part colors
            local bodyColors = playerChar:FindFirstChildOfClass("BodyColors")
            if bodyColors then
                head.Color = bodyColors.HeadColor.Color
                torso.Color = bodyColors.TorsoColor.Color
                leftArm.Color = bodyColors.LeftArmColor.Color
                rightArm.Color = bodyColors.RightArmColor.Color
                leftLeg.Color = bodyColors.LeftLegColor.Color
                rightLeg.Color = bodyColors.RightLegColor.Color
            else
                local function copyColor(rigPart, charName)
                    local charPart = playerChar:FindFirstChild(charName)
                    if charPart and charPart:IsA("BasePart") and rigPart then
                        rigPart.Color = charPart.Color
                    end
                end
                copyColor(head, "Head")
                copyColor(torso, "Torso")
                copyColor(leftArm, "Left Arm")
                copyColor(rightArm, "Right Arm")
                copyColor(leftLeg, "Left Leg")
                copyColor(rightLeg, "Right Leg")
            end
            -- Face decal
            local charHead = playerChar:FindFirstChild("Head")
            if charHead and faceDecal then
                local charDecal = charHead:FindFirstChild("face")
                if charDecal and charDecal:IsA("Decal") then
                    faceDecal.Texture = charDecal.Texture
                    faceDecal.ColorMap = charDecal.ColorMap
                end
            end
        end

        -- Load hair & accessories
        local char = LocalPlayer.Character
        if char then
            -- Remove old accessories from rig
            for _, child in ipairs(rig:GetChildren()) do
                if child:IsA("Accessory") or (child:IsA("Model") and child:FindFirstChild("Handle")) then
                    child:Destroy()
                end
            end
            for _, child in ipairs(char:GetChildren()) do
                if child:IsA("Accessory") or (child:IsA("Model") and child:FindFirstChild("Handle")) then
                    local cloned = child:Clone()
                    cloned.Parent = rig
                    local handle = cloned:FindFirstChild("Handle")
                    if handle and handle:IsA("BasePart") then
                        for _, j in ipairs(handle:GetChildren()) do
                            if j:IsA("JointInstance") then j:Destroy() end
                        end
                        handle.Anchored = true
                        handle.CanCollide = false
                        local originalHandle = child:FindFirstChild("Handle")
                        if originalHandle and originalHandle:IsA("BasePart") then
                            local originalWeld = originalHandle:FindFirstChildOfClass("Weld") or originalHandle:FindFirstChildOfClass("Motor6D") or originalHandle:FindFirstChildOfClass("WeldConstraint")
                            if originalWeld and originalWeld.Part1 and originalWeld.Part1:IsA("BasePart") then
                                -- Calculate handle's position relative to the body part it attaches to
                                local relCF = originalWeld.Part1.CFrame:ToObjectSpace(originalHandle.CFrame)
                                local targetName = originalWeld.Part1.Name
                                local rigPart = findRigPart(rig, targetName)
                                if rigPart and rigPart:IsA("BasePart") then
                                    handle.CFrame = rigPart.CFrame:ToWorldSpace(relCF)
                                end
                            end
                        end
                    end
                end
            end
        end

        return world
    end

    local avatarModel = buildRig()
    avatarModel.Parent = viewport

    -- Reload accessories after a short delay (covers late-loading accessories)
    task.spawn(function()
        task.wait(1)
        local char = LocalPlayer.Character
        if not char then return end
        local rigModel = viewport:FindFirstChildOfClass("WorldModel")
        if not rigModel then return end
        local rig = rigModel:FindFirstChild("Rig")
        if not rig then return end
        for _, child in ipairs(rig:GetChildren()) do
            if child:IsA("Accessory") or (child:IsA("Model") and child:FindFirstChild("Handle")) then
                child:Destroy()
            end
        end
        for _, child in ipairs(char:GetChildren()) do
            if child:IsA("Accessory") or (child:IsA("Model") and child:FindFirstChild("Handle")) then
                local cloned = child:Clone()
                cloned.Parent = rig
                local handle = cloned:FindFirstChild("Handle")
                if handle and handle:IsA("BasePart") then
                    for _, j in ipairs(handle:GetChildren()) do
                        if j:IsA("JointInstance") then j:Destroy() end
                    end
                    handle.Anchored = true
                    handle.CanCollide = false
                    local originalHandle = child:FindFirstChild("Handle")
                    if originalHandle and originalHandle:IsA("BasePart") then
                        local originalWeld = originalHandle:FindFirstChildOfClass("Weld") or originalHandle:FindFirstChildOfClass("Motor6D") or originalHandle:FindFirstChildOfClass("WeldConstraint")
                        if originalWeld and originalWeld.Part1 and originalWeld.Part1:IsA("BasePart") then
                            local relCF = originalWeld.Part1.CFrame:ToObjectSpace(originalHandle.CFrame)
                            local targetName = originalWeld.Part1.Name
                            local rigPart = findRigPart(rig, targetName)
                            if rigPart and rigPart:IsA("BasePart") then
                                handle.CFrame = rigPart.CFrame:ToWorldSpace(relCF)
                            end
                        end
                    end
                end
            end
        end
    end)

    -- Re-apply appearance when character respawns
    LocalPlayer.CharacterAdded:Connect(function()
        task.wait(0.5)
        local char = LocalPlayer.Character
        if not char then return end
        local rigModel = viewport:FindFirstChildOfClass("WorldModel")
        if not rigModel then return end
        local rig = rigModel:FindFirstChild("Rig")
        if not rig then return end
        -- Shirt & Pants
        local charShirt = char:FindFirstChildOfClass("Shirt")
        local shirtInst = rig:FindFirstChildOfClass("Shirt")
        if charShirt and shirtInst then
            shirtInst.ShirtTemplate = charShirt.ShirtTemplate
        end
        local charPants = char:FindFirstChildOfClass("Pants")
        local pantsInst = rig:FindFirstChildOfClass("Pants")
        if charPants and pantsInst then
            pantsInst.PantsTemplate = charPants.PantsTemplate
        end
            -- Body part colors
            local bodyColors = char:FindFirstChildOfClass("BodyColors")
            if bodyColors then
                for _, data in ipairs({{"Head", "HeadColor"}, {"Torso", "TorsoColor"}, {"Left Arm", "LeftArmColor"}, {"Right Arm", "RightArmColor"}, {"Left Leg", "LeftLegColor"}, {"Right Leg", "RightLegColor"}}) do
                    local rigPart = rig:FindFirstChild(data[1])
                    if rigPart and rigPart:IsA("BasePart") then
                        rigPart.Color = bodyColors[data[2]].Color
                    end
                end
            else
                local function setPartColor(name)
                    local charPart = char:FindFirstChild(name)
                    local rigPart = rig:FindFirstChild(name)
                    if charPart and charPart:IsA("BasePart") and rigPart and rigPart:IsA("BasePart") then
                        rigPart.Color = charPart.Color
                    end
                end
                setPartColor("Head")
                setPartColor("Torso")
                setPartColor("Left Arm")
                setPartColor("Right Arm")
                setPartColor("Left Leg")
                setPartColor("Right Leg")
            end
        -- Face decal
        local charHead = char:FindFirstChild("Head")
        if charHead then
            local charDecal = charHead:FindFirstChild("face")
            local rigHead = rig:FindFirstChild("Head")
            if rigHead then
                local rigDecal = rigHead:FindFirstChild("face")
                if charDecal and charDecal:IsA("Decal") and rigDecal and rigDecal:IsA("Decal") then
                    rigDecal.Texture = charDecal.Texture
                    rigDecal.ColorMap = charDecal.ColorMap
                end
            end
        end
        -- Remove old accessories from rig
        for _, child in ipairs(rig:GetChildren()) do
            if child:IsA("Accessory") or (child:IsA("Model") and child:FindFirstChild("Handle")) then
                child:Destroy()
            end
        end
        -- Load hair & accessories on respawn
        for _, child in ipairs(char:GetChildren()) do
            if child:IsA("Accessory") or (child:IsA("Model") and child:FindFirstChild("Handle")) then
                local cloned = child:Clone()
                cloned.Parent = rig
                local handle = cloned:FindFirstChild("Handle")
                if handle and handle:IsA("BasePart") then
                    for _, j in ipairs(handle:GetChildren()) do
                        if j:IsA("JointInstance") then j:Destroy() end
                    end
                    handle.Anchored = true
                    handle.CanCollide = false
                    local originalHandle = child:FindFirstChild("Handle")
                    if originalHandle and originalHandle:IsA("BasePart") then
                        local originalWeld = originalHandle:FindFirstChildOfClass("Weld") or originalHandle:FindFirstChildOfClass("Motor6D") or originalHandle:FindFirstChildOfClass("WeldConstraint")
                        if originalWeld and originalWeld.Part1 and originalWeld.Part1:IsA("BasePart") then
                            local relCF = originalWeld.Part1.CFrame:ToObjectSpace(originalHandle.CFrame)
                            local targetName = originalWeld.Part1.Name
                            local rigPart = findRigPart(rig, targetName)
                            if rigPart and rigPart:IsA("BasePart") then
                                handle.CFrame = rigPart.CFrame:ToWorldSpace(relCF)
                            end
                        end
                    end
                end
            end
        end
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
            ageValue.Text = ageDays .. "day"
        elseif ageDays < 365 then
            ageValue.Text = math.floor(ageDays / 30) .. "month"
        else
            local years = math.floor(ageDays / 365)
            ageValue.Text = years .. "year"
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

    createGridButton(charContent, "leave", "138668025068101", function()
        pcall(function() game:Shutdown() end)
        task.wait(0.5)
        LocalPlayer:Kick()
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

    New("UIListLayout", {
        Padding = UDim.new(0, 6),
        SortOrder = Enum.SortOrder.LayoutOrder,
        Name = "List",
        FillDirection = Enum.FillDirection.Horizontal
    }, advContent)

    -- Left: player list
    local playerListFrame = New("ScrollingFrame", {
        BorderSizePixel = 0,
        BackgroundColor3 = Color3.fromRGB(23, 23, 23),
        Size = UDim2.new(0.5, -3, 0, 200),
        BorderColor3 = Color3.fromRGB(0, 0, 0),
        Name = "PlayerList",
        ScrollBarThickness = 0,
        CanvasSize = UDim2.new(0, 0, 0, 0),
        AutomaticCanvasSize = Enum.AutomaticSize.Y
    }, advContent)

    New("UICorner", {Name = "Corner", CornerRadius = UDim.new(0, 12)}, playerListFrame)

    New("UIListLayout", {
        Padding = UDim.new(0, 2),
        SortOrder = Enum.SortOrder.LayoutOrder,
        Name = "List"
    }, playerListFrame)

    New("UIPadding", {
        PaddingTop = UDim.new(0, 4),
        PaddingRight = UDim.new(0, 4),
        PaddingLeft = UDim.new(0, 4),
        PaddingBottom = UDim.new(0, 4)
    }, playerListFrame)

    local selectedPlayer = nil

    local function refreshPlayerList()
        for _, child in ipairs(playerListFrame:GetChildren()) do
            if child:IsA("TextButton") then
                child:Destroy()
            end
        end
        for _, player in ipairs(Players:GetPlayers()) do
            if player ~= LocalPlayer then
                local btn = New("TextButton", {
                    BorderSizePixel = 0,
                    AutoLocalize = false,
                    TextSize = 14,
                    TextXAlignment = Enum.TextXAlignment.Left,
                    BackgroundColor3 = Color3.fromRGB(255, 255, 255),
                    FontFace = fonts.reg,
                    TextColor3 = Color3.fromRGB(200, 200, 200),
                    Size = UDim2.new(1, 0, 0, 28),
                    BorderColor3 = Color3.fromRGB(0, 0, 0),
                    Text = player.Name,
                    Name = "PlayerBtn",
                    BackgroundTransparency = 1
                }, playerListFrame)
                New("UICorner", {Name = "Corner", CornerRadius = UDim.new(0, 8)}, btn)
                btn.MouseButton1Click:Connect(function()
                    selectedPlayer = player
                    for _, b in ipairs(playerListFrame:GetChildren()) do
                        if b:IsA("TextButton") then
                            b.BackgroundTransparency = 1
                            b.TextColor3 = Color3.fromRGB(200, 200, 200)
                        end
                    end
                    btn.BackgroundTransparency = 0.6
                    btn.TextColor3 = Color3.fromRGB(255, 255, 255)
                end)
            end
        end
    end

    refreshPlayerList()
    Players.PlayerAdded:Connect(refreshPlayerList)
    Players.PlayerRemoving:Connect(refreshPlayerList)

    -- Right: spectate controls
    local spectatePanel = New("Frame", {
        BorderSizePixel = 0,
        BackgroundColor3 = Color3.fromRGB(255, 255, 255),
        Size = UDim2.new(0.5, -3, 0, 200),
        BorderColor3 = Color3.fromRGB(0, 0, 0),
        Name = "Spectate",
        BackgroundTransparency = 1
    }, advContent)

    New("UIListLayout", {
        Padding = UDim.new(0, 6),
        VerticalAlignment = Enum.VerticalAlignment.Center,
        SortOrder = Enum.SortOrder.LayoutOrder,
        Name = "List",
        FillDirection = Enum.FillDirection.Vertical
    }, spectatePanel)

    New("UIPadding", {
        PaddingTop = UDim.new(0, 20),
        PaddingRight = UDim.new(0, 10),
        PaddingLeft = UDim.new(0, 10),
        PaddingBottom = UDim.new(0, 20)
    }, spectatePanel)

    local function createActionBtn(parent, name, iconId, callback)
        local btn = New("ImageButton", {
            Active = false,
            BorderSizePixel = 0,
            AutoButtonColor = false,
            BackgroundColor3 = Color3.fromRGB(25, 25, 25),
            Selectable = false,
            Size = UDim2.new(1, 0, 0, 40),
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
            Image = iconId,
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
            Text = name,
            LayoutOrder = 2,
            Name = "Name"
        }, btn)
        New("UIFlexItem", {Name = "flex", FlexMode = Enum.UIFlexMode.Fill}, nameLabel)
        New("UIFlexItem", {Name = "flex", FlexMode = Enum.UIFlexMode.Fill}, btn)

        if callback then
            btn.MouseButton1Click:Connect(callback)
        end

        return btn
    end

    local spectateInstance = nil

    createActionBtn(spectatePanel, "Spectate", "rbxassetid://11963367322", function()
        if not selectedPlayer then return end
        if spectateInstance then
            spectateInstance.Close()
            spectateInstance = nil
        end
        if selectedPlayer.Character and selectedPlayer.Character:FindFirstChild("Humanoid") then
            workspace.CurrentCamera.CameraSubject = selectedPlayer.Character.Humanoid
            workspace.CurrentCamera.CameraType = Enum.CameraType.Custom
            local ok, result = pcall(components.spectate, mainfunctions, components)
            if ok then
                spectateInstance = result(selectedPlayer)
            end
        end
    end)

    -- Loading done
    loading.Visible = false
    if loadingScreen then
        local elapsed = os.clock() - loadStart
        if elapsed < 1 then
            task.wait(1 - elapsed)
        end
        loadingScreen:Close()
    end

    -- Open animation
    TweenService:Create(scale, TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Scale = 1}):Play()

    -- Dragging
    local dragActive, dragStart, dragPos

    top.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragActive = true
            dragStart = input.Position
            dragPos = profile.Position
        end
    end)

    top.InputChanged:Connect(function(input)
        if not dragActive then return end
        if input.UserInputType ~= Enum.UserInputType.MouseMovement and input.UserInputType ~= Enum.UserInputType.Touch then return end
        local delta = input.Position - dragStart
        profile.Position = UDim2.new(dragPos.X.Scale, dragPos.X.Offset + delta.X, dragPos.Y.Scale, dragPos.Y.Offset + delta.Y)
    end)

    top.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragActive = false
        end
    end)

    return screenGui
end
