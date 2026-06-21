return function(mainfunctions)
    local CollectionService = game:GetService("CollectionService")
    local New = mainfunctions.New
    local fonts = mainfunctions.GetFonts()
    local TweenService = game:GetService("TweenService")
    local Players = game:GetService("Players")
    local LocalPlayer = Players.LocalPlayer
    local targetParent = (gethui and gethui()) or game:GetService("CoreGui") or (LocalPlayer and LocalPlayer:WaitForChild("PlayerGui"))

    if not targetParent then
        error("Orbit UI: Could not locate a valid GUI parent container.")
    end

    local screenGui = New("ScreenGui", {
        Name = "loading",
        ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    }, targetParent)

    local progress = New("CanvasGroup", {
        BorderSizePixel = 0,
        BackgroundColor3 = Color3.fromRGB(35, 35, 35),
        AnchorPoint = Vector2.new(0.5, 0.5),
        Size = UDim2.new(0, 200, 0, 135),
        Position = UDim2.new(0.5, 0, 0.5, 0),
        Name = "Progress"
    }, screenGui)
    progress:SetAttribute("Position", -1)
    progress:SetAttribute("Key", "Progress")
    progress:SetAttribute("Active", false)
    CollectionService:AddTag(progress, "OrbitModalFrame")

    New("UICorner", {Name = "Corner", CornerRadius = UDim.new(0, 28)}, progress)

    local scale = New("UIScale", {Name = "Scale"}, progress)
    scale.Scale = 0
    CollectionService:AddTag(scale, "OrbitModalFrameScale")

    New("UIListLayout", {
        HorizontalAlignment = Enum.HorizontalAlignment.Center,
        Padding = UDim.new(0, 4),
        VerticalAlignment = Enum.VerticalAlignment.Center,
        SortOrder = Enum.SortOrder.LayoutOrder,
        Name = "List"
    }, progress)

    New("UIPadding", {Name = "Padding"}, progress)

    local iconFrame = New("Frame", {
        BorderSizePixel = 0,
        BackgroundColor3 = Color3.fromRGB(255, 255, 255),
        Size = UDim2.new(0, 20, 0, 20),
        Name = "Icon",
        BackgroundTransparency = 1
    }, progress)

    local spinIcon = New("ImageLabel", {
        BorderSizePixel = 0,
        ScaleType = Enum.ScaleType.Fit,
        BackgroundColor3 = Color3.fromRGB(255, 255, 255),
        ImageTransparency = 0.5,
        AnchorPoint = Vector2.new(0.5, 0.5),
        Image = "rbxassetid://10723433935",
        Size = UDim2.new(1, 0, 1, 0),
        BackgroundTransparency = 1,
        Name = "icon",
        Position = UDim2.new(0.5, 0, 0.5, 0)
    }, iconFrame)

    New("TextLabel", {
        BorderSizePixel = 0,
        AutoLocalize = false,
        TextSize = 15,
        TextTransparency = 0.5,
        BackgroundColor3 = Color3.fromRGB(255, 255, 255),
        FontFace = fonts.med,
        TextColor3 = Color3.fromRGB(255, 255, 255),
        BackgroundTransparency = 1,
        Size = UDim2.new(1, 0, 0, 20),
        Text = "Loading",
        Name = "Process"
    }, progress)

    -- Open animation
    TweenService:Create(scale, TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Scale = 1}):Play()

    -- Spin animation (frame-rate independent using dt)
    local spinConn
    spinConn = game:GetService("RunService").RenderStepped:Connect(function(dt)
        if not screenGui or not screenGui.Parent then
            spinConn:Disconnect()
            return
        end
        spinIcon.Rotation = (spinIcon.Rotation + 180 * dt) % 360
    end)

    local loading = {}
    loading.screen = screenGui

    function loading:Close()
        -- Disconnect spin animation to prevent memory leak
        if spinConn then
            spinConn:Disconnect()
            spinConn = nil
        end

        local closeTween = TweenService:Create(scale, TweenInfo.new(0.15, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Scale = 0})
        closeTween.Completed:Connect(function()
            screenGui:Destroy()
        end)
        closeTween:Play()
    end

    return loading
end