local CollectionService = game:GetService("CollectionService")
local TweenService = game:GetService("TweenService")
local Players = game:GetService("Players")

return function(mainfunctions, components)
    local New = mainfunctions.New
    local fonts = mainfunctions.GetFonts()
    local UserInputService = game:GetService("UserInputService")
    local LocalPlayer = Players.LocalPlayer
    local targetParent = (gethui and gethui()) or game:GetService("CoreGui") or (LocalPlayer and LocalPlayer:WaitForChild("PlayerGui"))

    return function(config)
        config = config or {}
        local titleText = config.Title or "Confirmation"
        local descText = config.Description or "Are you sure?"
        local confirmText = config.ConfirmText or "Confirm"
        local cancelText = config.CancelText or "Cancel"
        local onConfirm = config.OnConfirm or function() end
        local onCancel = config.OnCancel or function() end

        local screenGui = New("ScreenGui", {
            Name = "Confirmation",
            DisplayOrder = 10,
            ZIndexBehavior = Enum.ZIndexBehavior.Sibling
        }, targetParent)

        local container = New("ImageLabel", {
            ZIndex = 10,
            BorderSizePixel = 0,
            SliceCenter = Rect.new(300, 300, 300, 300),
            SliceScale = 0.5,
            ScaleType = Enum.ScaleType.Slice,
            BackgroundColor3 = Color3.fromRGB(255, 255, 255),
            AutomaticSize = Enum.AutomaticSize.Y,
            ImageColor3 = Color3.fromRGB(0, 0, 0),
            AnchorPoint = Vector2.new(0.5, 0.5),
            Size = UDim2.new(0, 450, 0, 0),
            BorderColor3 = Color3.fromRGB(0, 0, 0),
            BackgroundTransparency = 1,
            Selectable = true,
            Name = "confirmation",
            Position = UDim2.new(0.5, 0, 0.5, 0)
        }, screenGui)

        container:SetAttribute("CurrentPromptID", "")

        local containerScale = New("UIScale", {Name = "scale"}, container)

        New("UIPadding", {
            PaddingTop = UDim.new(0, 75),
            PaddingRight = UDim.new(0, 75),
            Name = "padding",
            PaddingLeft = UDim.new(0, 75),
            PaddingBottom = UDim.new(0, 75)
        }, container)

        New("UIListLayout", {
            SortOrder = Enum.SortOrder.LayoutOrder,
            Name = "list"
        }, container)

        local frame = New("ImageButton", {
            SliceScale = 0.12,
            BorderSizePixel = 0,
            SliceCenter = Rect.new(512, 512, 512, 512),
            ScaleType = Enum.ScaleType.Slice,
            Modal = true,
            AutoButtonColor = false,
            BackgroundTransparency = 1,
            BackgroundColor3 = Color3.fromRGB(255, 255, 255),
            ImageColor3 = Color3.fromRGB(35, 35, 35),
            AnchorPoint = Vector2.new(0.5, 0),
            Image = "rbxassetid://125088425775676",
            AutomaticSize = Enum.AutomaticSize.Y,
            Size = UDim2.new(1, 0, 0, 0),
            BorderColor3 = Color3.fromRGB(0, 0, 0),
            Name = "frame",
            Position = UDim2.new(0.5, 0, 0, 0)
        }, container)

        local content = New("CanvasGroup", {
            Active = true,
            BorderSizePixel = 0,
            BackgroundColor3 = Color3.fromRGB(255, 255, 255),
            Selectable = true,
            AutomaticSize = Enum.AutomaticSize.Y,
            Size = UDim2.new(1, 0, 0, 0),
            BorderColor3 = Color3.fromRGB(0, 0, 0),
            Name = "content",
            LayoutOrder = 1,
            BackgroundTransparency = 1,
            SelectionGroup = true
        }, frame)

        local headerLabel = New("TextLabel", {
            TextWrapped = true,
            BorderSizePixel = 0,
            TextSize = 18,
            TextXAlignment = Enum.TextXAlignment.Left,
            TextYAlignment = Enum.TextYAlignment.Top,
            BackgroundColor3 = Color3.fromRGB(255, 255, 255),
            FontFace = Font.new("rbxassetid://12187365364", Enum.FontWeight.SemiBold, Enum.FontStyle.Normal),
            TextColor3 = Color3.fromRGB(255, 255, 255),
            BackgroundTransparency = 1,
            Size = UDim2.new(1, 0, 0, 0),
            BorderColor3 = Color3.fromRGB(0, 0, 0),
            Text = titleText,
            AutomaticSize = Enum.AutomaticSize.Y,
            Name = "header"
        }, content)

        local descLabel = New("TextLabel", {
            TextWrapped = true,
            BorderSizePixel = 0,
            TextSize = 15,
            TextXAlignment = Enum.TextXAlignment.Left,
            TextTransparency = 0.3,
            TextYAlignment = Enum.TextYAlignment.Top,
            BackgroundColor3 = Color3.fromRGB(255, 255, 255),
            FontFace = fonts.reg,
            TextColor3 = Color3.fromRGB(255, 255, 255),
            BackgroundTransparency = 1,
            Size = UDim2.new(1, 0, 0, 0),
            BorderColor3 = Color3.fromRGB(0, 0, 0),
            Text = descText,
            AutomaticSize = Enum.AutomaticSize.Y,
            Name = "label"
        }, content)

        New("UIListLayout", {
            HorizontalAlignment = Enum.HorizontalAlignment.Center,
            Padding = UDim.new(0, 5),
            SortOrder = Enum.SortOrder.LayoutOrder,
            Name = "list"
        }, content)

        local actionsFrame = New("Frame", {
            BorderSizePixel = 0,
            BackgroundColor3 = Color3.fromRGB(255, 255, 255),
            Size = UDim2.new(1, 0, 0, 60),
            BorderColor3 = Color3.fromRGB(0, 0, 0),
            Name = "actions",
            LayoutOrder = 2,
            BackgroundTransparency = 1
        }, content)

        New("UIListLayout", {
            HorizontalAlignment = Enum.HorizontalAlignment.Center,
            HorizontalFlex = Enum.UIFlexAlignment.Fill,
            Padding = UDim.new(0, 10),
            VerticalAlignment = Enum.VerticalAlignment.Bottom,
            SortOrder = Enum.SortOrder.LayoutOrder,
            Name = "list",
            FillDirection = Enum.FillDirection.Horizontal
        }, actionsFrame)

        New("UIPadding", {
            PaddingRight = UDim.new(0, 1),
            Name = "padding",
            PaddingLeft = UDim.new(0, 1),
            PaddingBottom = UDim.new(0, 1)
        }, actionsFrame)

        local cancelBtn = New("TextButton", {
            BorderSizePixel = 0,
            TextSize = 15,
            TextColor3 = Color3.fromRGB(255, 255, 255),
            BackgroundColor3 = Color3.fromRGB(176, 0, 0),
            FontFace = Font.new("rbxassetid://12187365364", Enum.FontWeight.SemiBold, Enum.FontStyle.Normal),
            AnchorPoint = Vector2.new(0, 0.5),
            AutomaticSize = Enum.AutomaticSize.X,
            Size = UDim2.new(0, 0, 0, 40),
            LayoutOrder = 1,
            BorderColor3 = Color3.fromRGB(0, 0, 0),
            Text = cancelText,
            Name = "cancel",
            Position = UDim2.new(0, 0, 0.5, 0)
        }, actionsFrame)

        New("UICorner", {Name = "corner", CornerRadius = UDim.new(1, 0)}, cancelBtn)

        New("UIPadding", {
            PaddingRight = UDim.new(0, 20),
            Name = "padding",
            PaddingLeft = UDim.new(0, 20)
        }, cancelBtn)

        local acceptBtn = New("TextButton", {
            BorderSizePixel = 0,
            TextSize = 15,
            TextColor3 = Color3.fromRGB(255, 255, 255),
            BackgroundColor3 = Color3.fromRGB(0, 141, 255),
            FontFace = Font.new("rbxassetid://12187365364", Enum.FontWeight.SemiBold, Enum.FontStyle.Normal),
            AnchorPoint = Vector2.new(0, 0.5),
            AutomaticSize = Enum.AutomaticSize.X,
            Size = UDim2.new(0, 0, 0, 40),
            LayoutOrder = 2,
            BorderColor3 = Color3.fromRGB(0, 0, 0),
            Text = confirmText,
            Name = "accept",
            Position = UDim2.new(0, 0, 0.5, 0)
        }, actionsFrame)

        CollectionService:AddTag(acceptBtn, "Exe6PrimaryThemeBackgroundColor3")

        New("UIPadding", {
            PaddingRight = UDim.new(0, 24),
            Name = "padding",
            PaddingLeft = UDim.new(0, 24)
        }, acceptBtn)

        New("UICorner", {Name = "corner", CornerRadius = UDim.new(1, 0)}, acceptBtn)

        local acceptStroke = New("UIStroke", {
            Color = Color3.fromRGB(255, 255, 255),
            ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
            Name = "stroke"
        }, acceptBtn)

        CollectionService:AddTag(acceptStroke, "Exe6AerialEffect")

        local acceptGradient = New("UIGradient", {
            Rotation = 62,
            Transparency = NumberSequence.new{
                NumberSequenceKeypoint.new(0, 0),
                NumberSequenceKeypoint.new(0.5, 1),
                NumberSequenceKeypoint.new(1, 0)
            },
            Name = "gradient",
            Color = ColorSequence.new{
                ColorSequenceKeypoint.new(0, Color3.fromRGB(90, 178, 255)),
                ColorSequenceKeypoint.new(1, Color3.fromRGB(90, 178, 255))
            }
        }, acceptStroke)

        CollectionService:AddTag(acceptGradient, "Exe6DynamicSpeculars")
        CollectionService:AddTag(acceptGradient, "Exe6PrimarySpeculars")

        New("UIPadding", {
            PaddingTop = UDim.new(0, 25),
            PaddingRight = UDim.new(0, 25),
            Name = "padding",
            PaddingLeft = UDim.new(0, 25),
            PaddingBottom = UDim.new(0, 25)
        }, content)

        -- LeafletControls (top bar with close button)
        local leafletControls = New("Frame", {
            ZIndex = 99999,
            BorderSizePixel = 0,
            BackgroundColor3 = Color3.fromRGB(255, 255, 255),
            AnchorPoint = Vector2.new(1, 1),
            Size = UDim2.new(1, 0, 1, 0),
            Position = UDim2.new(1, 0, 1, 0),
            BorderColor3 = Color3.fromRGB(0, 0, 0),
            Name = "LeafletControls",
            BackgroundTransparency = 1
        }, frame)

        local topBar = New("Frame", {
            BorderSizePixel = 0,
            BackgroundColor3 = Color3.fromRGB(255, 255, 255),
            AnchorPoint = Vector2.new(0.5, 0),
            Size = UDim2.new(1, 0, 0, 50),
            Position = UDim2.new(0.5, 0, 0, 0),
            BorderColor3 = Color3.fromRGB(0, 0, 0),
            Name = "Top",
            BackgroundTransparency = 1
        }, leafletControls)

        New("UIPadding", {
            PaddingTop = UDim.new(0, 5),
            PaddingRight = UDim.new(0, 5),
            Name = "padding"
        }, topBar)

        New("UIListLayout", {
            HorizontalAlignment = Enum.HorizontalAlignment.Right,
            Padding = UDim.new(0, -5),
            SortOrder = Enum.SortOrder.LayoutOrder,
            Name = "list",
            FillDirection = Enum.FillDirection.Horizontal
        }, topBar)

        local closeHolder = New("ImageLabel", {
            BorderSizePixel = 0,
            ScaleType = Enum.ScaleType.Fit,
            BackgroundColor3 = Color3.fromRGB(255, 255, 255),
            ImageTransparency = 1,
            ImageColor3 = Color3.fromRGB(0, 0, 0),
            AnchorPoint = Vector2.new(1, 0),
            Image = "rbxassetid://72548733587158",
            Size = UDim2.new(0, 40, 0, 40),
            BorderColor3 = Color3.fromRGB(0, 0, 0),
            BackgroundTransparency = 1,
            LayoutOrder = 3,
            Name = "Close",
            Position = UDim2.new(1, 0, 0, 0)
        }, topBar)

        local closeBtn = New("ImageButton", {
            BorderSizePixel = 0,
            ScaleType = Enum.ScaleType.Fit,
            BackgroundColor3 = Color3.fromRGB(43, 43, 43),
            Selectable = false,
            AnchorPoint = Vector2.new(0.5, 0.5),
            Size = UDim2.new(0, 24, 0, 24),
            LayoutOrder = 1,
            BorderColor3 = Color3.fromRGB(0, 0, 0),
            Name = "Button",
            Position = UDim2.new(0.5, 0, 0.5, 0)
        }, closeHolder)

        New("ImageLabel", {
            BorderSizePixel = 0,
            ScaleType = Enum.ScaleType.Fit,
            BackgroundColor3 = Color3.fromRGB(255, 255, 255),
            ImageTransparency = 0.2,
            AnchorPoint = Vector2.new(0.5, 0.5),
            Image = "rbxassetid://11293981586",
            Size = UDim2.new(0, 12, 0, 12),
            BorderColor3 = Color3.fromRGB(0, 0, 0),
            BackgroundTransparency = 1,
            Name = "icon",
            Position = UDim2.new(0.5, 0, 0.5, 0)
        }, closeBtn)

        New("UICorner", {Name = "corner", CornerRadius = UDim.new(1, 0)}, closeBtn)

        New("UIStroke", {
            Color = Color3.fromRGB(255, 255, 255),
            ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
            Name = "stroke"
        }, closeBtn)

        local bottomBar = New("Frame", {
            BorderSizePixel = 0,
            BackgroundColor3 = Color3.fromRGB(255, 255, 255),
            AnchorPoint = Vector2.new(1, 1),
            Size = UDim2.new(0, 50, 0, 50),
            Position = UDim2.new(1, 0, 1, 0),
            BorderColor3 = Color3.fromRGB(0, 0, 0),
            Name = "Bottom",
            BackgroundTransparency = 1
        }, leafletControls)

        New("UIListLayout", {
            HorizontalFlex = Enum.UIFlexAlignment.Fill,
            SortOrder = Enum.SortOrder.LayoutOrder,
            Name = "list",
            FillDirection = Enum.FillDirection.Horizontal
        }, bottomBar)

        local resizeBtn = New("ImageButton", {
            BorderSizePixel = 0,
            AutoButtonColor = false,
            Visible = false,
            BackgroundTransparency = 1,
            BackgroundColor3 = Color3.fromRGB(255, 255, 255),
            Size = UDim2.new(1, 0, 1, 0),
            BorderColor3 = Color3.fromRGB(0, 0, 0),
            Name = "Resize"
        }, bottomBar)

        CollectionService:AddTag(resizeBtn, "Exe6ResizeHandle")

        local resizeIcon = New("ImageLabel", {
            BorderSizePixel = 0,
            SliceCenter = Rect.new(51, 52, 51, 52),
            SliceScale = 0.5,
            ScaleType = Enum.ScaleType.Slice,
            BackgroundColor3 = Color3.fromRGB(255, 255, 255),
            ImageColor3 = Color3.fromRGB(60, 60, 60),
            AnchorPoint = Vector2.new(1, 1),
            Image = "rbxassetid://86527207319523",
            Size = UDim2.new(0, 18, 0, 18),
            BorderColor3 = Color3.fromRGB(0, 0, 0),
            BackgroundTransparency = 1,
            Name = "icon",
            Position = UDim2.new(1, 0, 1, 0)
        }, resizeBtn)

        New("UIScale", {Name = "scale"}, resizeIcon)

        New("UIPadding", {
            PaddingRight = UDim.new(0, 8),
            Name = "padding",
            PaddingBottom = UDim.new(0, 8)
        }, resizeBtn)

        -- Protection (invisible click-blocker)
        New("ImageButton", {
            BorderSizePixel = 0,
            AutoButtonColor = false,
            Visible = false,
            BackgroundTransparency = 1,
            BackgroundColor3 = Color3.fromRGB(255, 255, 255),
            AnchorPoint = Vector2.new(0.5, 0.5),
            Size = UDim2.new(1, 0, 1, 0),
            BorderColor3 = Color3.fromRGB(0, 0, 0),
            Name = "Protection",
            Position = UDim2.new(0.5, 0, 0.5, 0)
        }, leafletControls)

        New("Frame", {
            BorderSizePixel = 0,
            BackgroundColor3 = Color3.fromRGB(255, 255, 255),
            Selectable = true,
            AnchorPoint = Vector2.new(0.5, 0.5),
            Size = UDim2.new(1, 0, 1, 0),
            Position = UDim2.new(0.5, 0, 0.5, 0),
            BorderColor3 = Color3.fromRGB(0, 0, 0),
            Name = "Space",
            BackgroundTransparency = 1
        }, leafletControls)

        New("ImageButton", {
            BorderSizePixel = 0,
            AutoButtonColor = false,
            Visible = false,
            BackgroundTransparency = 1,
            BackgroundColor3 = Color3.fromRGB(255, 255, 255),
            AnchorPoint = Vector2.new(0.5, 0.5),
            Size = UDim2.new(1, 0, 1, 0),
            BorderColor3 = Color3.fromRGB(0, 0, 0),
            Name = "Shield",
            Position = UDim2.new(0.5, 0, 0.5, 0)
        }, leafletControls)

        -- Close logic
        local isClosed = false
        local function close()
            if isClosed then return end
            isClosed = true
            TweenService:Create(containerScale, TweenInfo.new(0.15, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Scale = 0}):Play()
            task.wait(0.15)
            screenGui:Destroy()
        end

        -- Open animation
        containerScale.Scale = 0
        TweenService:Create(containerScale, TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Scale = 1}):Play()

        -- Connections
        closeBtn.MouseButton1Click:Connect(function()
            onCancel()
            close()
        end)

        cancelBtn.MouseButton1Click:Connect(function()
            onCancel()
            close()
        end)

        acceptBtn.MouseButton1Click:Connect(function()
            onConfirm()
            close()
        end)

        return {
            ScreenGui = screenGui,
            Close = close
        }
    end
end