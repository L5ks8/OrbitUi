return function(mainfunctions, components)
    local New = mainfunctions.New
    local fonts = mainfunctions.GetFonts()
    local Players = game:GetService("Players")
    local LocalPlayer = Players.LocalPlayer
    local TweenService = game:GetService("TweenService")
    local RunService = game:GetService("RunService")
    local UserInputService = game:GetService("UserInputService")
    local targetParent = (gethui and gethui()) or game:GetService("CoreGui") or (LocalPlayer and LocalPlayer:WaitForChild("PlayerGui"))

    local Camera = workspace.CurrentCamera
    workspace:GetPropertyChangedSignal("CurrentCamera"):Connect(function()
        local newCam = workspace.CurrentCamera
        if newCam then Camera = newCam end
    end)

    return function(targetPlayer, onClose)
        local screenGui = New("ScreenGui", {
            Name = "Spectate",
            DisplayOrder = 10,
            ZIndexBehavior = Enum.ZIndexBehavior.Sibling
        }, targetParent)

        local canvas = New("CanvasGroup", {
            BorderSizePixel = 0,
            BackgroundColor3 = Color3.fromRGB(0, 0, 0),
            Selectable = true,
            AnchorPoint = Vector2.new(0.5, 0.5),
            Size = UDim2.new(1, 0, 1, 0),
            Position = UDim2.new(0.5, 0, 0.5, 0),
            BorderColor3 = Color3.fromRGB(0, 0, 0),
            Name = "spectate",
            BackgroundTransparency = 1
        }, screenGui)

        local scale = New("UIScale", {Name = "scale"}, canvas)

        local frame = New("Frame", {
            BorderSizePixel = 0,
            BackgroundColor3 = Color3.fromRGB(0, 0, 0),
            AnchorPoint = Vector2.new(0.5, 0.5),
            Size = UDim2.new(1, 0, 1, 0),
            Position = UDim2.new(0.5, 0, 0.5, 0),
            BorderColor3 = Color3.fromRGB(0, 0, 0),
            Name = "frame",
            BackgroundTransparency = 0.3
        }, canvas)

        New("UIGradient", {
            Rotation = 90,
            Transparency = NumberSequence.new{
                NumberSequenceKeypoint.new(0, 1),
                NumberSequenceKeypoint.new(0.3, 1),
                NumberSequenceKeypoint.new(0.5, 1),
                NumberSequenceKeypoint.new(0.7, 1),
                NumberSequenceKeypoint.new(1, 0)
            },
            Name = "gradient"
        }, frame)

        New("UIListLayout", {
            HorizontalAlignment = Enum.HorizontalAlignment.Center,
            VerticalAlignment = Enum.VerticalAlignment.Bottom,
            SortOrder = Enum.SortOrder.LayoutOrder,
            Name = "list"
        }, frame)

        New("UIPadding", {
            PaddingTop = UDim.new(0, 50),
            Name = "padding",
            PaddingBottom = UDim.new(0, 50)
        }, frame)

        local menu = New("Frame", {
            BorderSizePixel = 0,
            BackgroundColor3 = Color3.fromRGB(255, 255, 255),
            AnchorPoint = Vector2.new(0.5, 1),
            AutomaticSize = Enum.AutomaticSize.X,
            Size = UDim2.new(0, 0, 0, 60),
            Position = UDim2.new(0.5, 0, 1, -50),
            BorderColor3 = Color3.fromRGB(0, 0, 0),
            Name = "menu",
            BackgroundTransparency = 1
        }, frame)

        New("UIListLayout", {
            HorizontalAlignment = Enum.HorizontalAlignment.Center,
            Padding = UDim.new(0, 10),
            VerticalAlignment = Enum.VerticalAlignment.Center,
            SortOrder = Enum.SortOrder.LayoutOrder,
            Name = "list",
            FillDirection = Enum.FillDirection.Horizontal
        }, menu)

        local function makeActionButton(iconId, layoutOrder)
            local btn = New("ImageButton", {
                BorderSizePixel = 0,
                SliceCenter = Rect.new(512, 512, 512, 512),
                ImageTransparency = 0.8,
                BackgroundTransparency = 0.5,
                BackgroundColor3 = Color3.fromRGB(63, 63, 63),
                AnchorPoint = Vector2.new(0.5, 0),
                Image = "rbxassetid://122971705612181",
                TileSize = UDim2.new(0, 200, 0, 100),
                Size = UDim2.new(0, 60, 0, 60),
                LayoutOrder = layoutOrder,
                BorderColor3 = Color3.fromRGB(0, 0, 0),
                Name = "action",
                Position = UDim2.new(0.5, 0, 0, 30)
            }, menu)

            New("UIListLayout", {
                HorizontalAlignment = Enum.HorizontalAlignment.Center,
                Padding = UDim.new(0, 10),
                VerticalAlignment = Enum.VerticalAlignment.Center,
                SortOrder = Enum.SortOrder.LayoutOrder,
                Name = "list",
                FillDirection = Enum.FillDirection.Horizontal
            }, btn)

            New("UIPadding", {
                PaddingRight = UDim.new(0, 20),
                Name = "padding",
                PaddingLeft = UDim.new(0, 20)
            }, btn)

            local icon = New("ImageLabel", {
                BorderSizePixel = 0,
                BackgroundColor3 = Color3.fromRGB(255, 255, 255),
                Image = iconId,
                Size = UDim2.new(0, 16, 0, 16),
                BorderColor3 = Color3.fromRGB(0, 0, 0),
                BackgroundTransparency = 1,
                Name = "icon"
            }, btn)

            New("UIScale", {Name = "scale"}, icon)
            New("UICorner", {Name = "corner", CornerRadius = UDim.new(1, 0)}, btn)

            New("UIStroke", {
                Color = Color3.fromRGB(255, 255, 255),
                ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
                Name = "stroke"
            }, btn)

            New("UIGradient", {
                Rotation = 77,
                Transparency = NumberSequence.new{
                    NumberSequenceKeypoint.new(0, 0),
                    NumberSequenceKeypoint.new(0.5, 1),
                    NumberSequenceKeypoint.new(1, 0)
                },
                Name = "gradient",
                Color = ColorSequence.new{
                    ColorSequenceKeypoint.new(0, Color3.fromRGB(190, 190, 190)),
                    ColorSequenceKeypoint.new(1, Color3.fromRGB(190, 190, 190))
                }
            }, btn:FindFirstChild("stroke"))

            return btn
        end

        -- Camera follow logic
        local isFollowing = false
        local followConnection = nil
        local unfollowTimeout = nil
        local lastUserInput = 0
        local returnDelay = 3
        local inputConn = nil

        local function stopFollow()
            if followConnection then
                followConnection:Disconnect()
                followConnection = nil
            end
            if unfollowTimeout then
                unfollowTimeout:Cancel()
                unfollowTimeout = nil
            end
            if inputConn then
                inputConn:Disconnect()
                inputConn = nil
            end
            isFollowing = false
        end

        local function startFollow()
            stopFollow()
            isFollowing = true
            lastUserInput = os.clock()

            inputConn = UserInputService.InputChanged:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseMovement then
                    lastUserInput = os.clock()
                end
            end)

            followConnection = RunService.RenderStepped:Connect(function(dt)
                local char = targetPlayer.Character
                if not char then
                    stopFollow()
                    return
                end
                local root = char:FindFirstChild("HumanoidRootPart") or char:FindFirstChild("Torso") or char:FindFirstChild("UpperTorso")
                if not root then return end

                local targetCF = root.CFrame
                local targetPos = targetCF.p + Vector3.new(0, 2, 0)
                local lookDir = targetCF.LookVector
                local behindPos = targetPos - lookDir * 8 + Vector3.new(0, 4, 0)

                local timeSinceInput = os.clock() - lastUserInput
                if timeSinceInput < returnDelay then
                    Camera.CFrame = CFrame.new(Camera.CFrame.p, targetPos)
                else
                    local smoothPos = Camera.CFrame:Lerp(CFrame.new(behindPos, targetPos), dt * 3)
                    Camera.CFrame = smoothPos
                    Camera.CameraSubject = root
                end
            end)
        end

        local followBtn = makeActionButton("rbxassetid://11963367322", 0)
        local unfollowBtn = makeActionButton("rbxassetid://11419717224", 1)

        followBtn.MouseButton1Click:Connect(startFollow)
        unfollowBtn.MouseButton1Click:Connect(stopFollow)

        local closeBtn = New("ImageButton", {
            BorderSizePixel = 0,
            SliceCenter = Rect.new(512, 512, 512, 512),
            ImageTransparency = 0.8,
            BackgroundTransparency = 0.5,
            BackgroundColor3 = Color3.fromRGB(63, 63, 63),
            AnchorPoint = Vector2.new(0.5, 0),
            Image = "rbxassetid://122971705612181",
            TileSize = UDim2.new(0, 200, 0, 100),
            Size = UDim2.new(0, 60, 0, 60),
            LayoutOrder = 4,
            BorderColor3 = Color3.fromRGB(0, 0, 0),
            Name = "close",
            Position = UDim2.new(0.5, 0, 0, 30)
        }, menu)

        New("UIListLayout", {
            HorizontalAlignment = Enum.HorizontalAlignment.Center,
            Padding = UDim.new(0, 10),
            VerticalAlignment = Enum.VerticalAlignment.Center,
            SortOrder = Enum.SortOrder.LayoutOrder,
            Name = "list",
            FillDirection = Enum.FillDirection.Horizontal
        }, closeBtn)

        New("UIPadding", {
            PaddingRight = UDim.new(0, 20),
            Name = "padding",
            PaddingLeft = UDim.new(0, 20)
        }, closeBtn)

        local closeIcon = New("ImageLabel", {
            BorderSizePixel = 0,
            BackgroundColor3 = Color3.fromRGB(255, 255, 255),
            Image = "rbxassetid://11293981586",
            Size = UDim2.new(0, 16, 0, 16),
            BorderColor3 = Color3.fromRGB(0, 0, 0),
            BackgroundTransparency = 1,
            Name = "icon"
        }, closeBtn)

        New("UIScale", {Name = "scale"}, closeIcon)
        New("UICorner", {Name = "corner", CornerRadius = UDim.new(1, 0)}, closeBtn)

        local closeStroke = New("UIStroke", {
            Color = Color3.fromRGB(255, 255, 255),
            ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
            Name = "stroke"
        }, closeBtn)

        New("UIGradient", {
            Rotation = 77,
            Transparency = NumberSequence.new{
                NumberSequenceKeypoint.new(0, 0),
                NumberSequenceKeypoint.new(0.5, 1),
                NumberSequenceKeypoint.new(1, 0)
            },
            Name = "gradient",
            Color = ColorSequence.new{
                ColorSequenceKeypoint.new(0, Color3.fromRGB(190, 190, 190)),
                ColorSequenceKeypoint.new(1, Color3.fromRGB(190, 190, 190))
            }
        }, closeStroke)

        local infoFrame = New("ImageButton", {
            BorderSizePixel = 0,
            SliceCenter = Rect.new(512, 512, 512, 512),
            AutoButtonColor = false,
            ImageTransparency = 0.8,
            BackgroundTransparency = 0.5,
            BackgroundColor3 = Color3.fromRGB(63, 63, 63),
            AnchorPoint = Vector2.new(0.5, 0),
            Image = "rbxassetid://122971705612181",
            TileSize = UDim2.new(0, 200, 0, 100),
            AutomaticSize = Enum.AutomaticSize.X,
            Size = UDim2.new(0, 0, 0, 60),
            LayoutOrder = 3,
            BorderColor3 = Color3.fromRGB(0, 0, 0),
            Name = "frame",
            Position = UDim2.new(0.5, 0, 0, 30)
        }, menu)

        New("UIListLayout", {
            HorizontalAlignment = Enum.HorizontalAlignment.Center,
            Padding = UDim.new(0, 5),
            VerticalAlignment = Enum.VerticalAlignment.Center,
            SortOrder = Enum.SortOrder.LayoutOrder,
            Name = "list",
            FillDirection = Enum.FillDirection.Horizontal
        }, infoFrame)

        local userFrame = New("Frame", {
            BorderSizePixel = 0,
            BackgroundColor3 = Color3.fromRGB(255, 255, 255),
            AutomaticSize = Enum.AutomaticSize.X,
            Size = UDim2.new(0, 0, 0, 30),
            BorderColor3 = Color3.fromRGB(0, 0, 0),
            Name = "user",
            BackgroundTransparency = 1
        }, infoFrame)

        local profilePic = New("ImageLabel", {
            BorderSizePixel = 0,
            ScaleType = Enum.ScaleType.Crop,
            BackgroundColor3 = Color3.fromRGB(23, 23, 23),
            AnchorPoint = Vector2.new(0, 0.5),
            Image = "https://www.roblox.com/headshot-thumbnail/image?userId=" .. tostring(targetPlayer.UserId) .. "&width=420&height=420&format=png",
            Size = UDim2.new(0, 30, 0, 30),
            BorderColor3 = Color3.fromRGB(0, 0, 0),
            BackgroundTransparency = 0.5,
            LayoutOrder = 1,
            Name = "profile",
            Position = UDim2.new(0, 0, 0.5, 0)
        }, userFrame)

        New("UICorner", {Name = "corner", CornerRadius = UDim.new(1, 0)}, profilePic)

        local displayLabel = New("TextLabel", {
            TextTruncate = Enum.TextTruncate.SplitWord,
            BorderSizePixel = 0,
            AutoLocalize = false,
            TextSize = 14,
            TextXAlignment = Enum.TextXAlignment.Left,
            BackgroundColor3 = Color3.fromRGB(0, 0, 0),
            FontFace = Font.new("rbxassetid://12187365364", Enum.FontWeight.Medium, Enum.FontStyle.Normal),
            TextColor3 = Color3.fromRGB(255, 255, 255),
            BackgroundTransparency = 1,
            AnchorPoint = Vector2.new(0.5, 0),
            Size = UDim2.new(0, 0, 0, 10),
            BorderColor3 = Color3.fromRGB(0, 0, 0),
            Text = targetPlayer.DisplayName,
            LayoutOrder = 2,
            AutomaticSize = Enum.AutomaticSize.X,
            Name = "display",
            Position = UDim2.new(0.5, 0, 0, 0)
        }, userFrame)

        New("UIFlexItem", {
            ShrinkRatio = 1,
            Name = "flex",
            FlexMode = Enum.UIFlexMode.Fill
        }, displayLabel)

        New("UIListLayout", {
            Padding = UDim.new(0, 15),
            VerticalAlignment = Enum.VerticalAlignment.Center,
            SortOrder = Enum.SortOrder.LayoutOrder,
            Name = "list",
            FillDirection = Enum.FillDirection.Horizontal
        }, userFrame)

        New("UIPadding", {
            PaddingRight = UDim.new(0, 14),
            Name = "padding",
            PaddingLeft = UDim.new(0, 20)
        }, infoFrame)

        local indicator = New("Frame", {
            BorderSizePixel = 0,
            BackgroundColor3 = Color3.fromRGB(255, 255, 255),
            AnchorPoint = Vector2.new(0, 1),
            Size = UDim2.new(0, 30, 0, 30),
            Position = UDim2.new(0, 0, 1, 0),
            BorderColor3 = Color3.fromRGB(0, 0, 0),
            Name = "indicator",
            BackgroundTransparency = 1
        }, infoFrame)

        local badge = New("ImageLabel", {
            BorderSizePixel = 0,
            ScaleType = Enum.ScaleType.Fit,
            BackgroundColor3 = Color3.fromRGB(255, 255, 255),
            ImageColor3 = Color3.fromRGB(255, 24, 24),
            AnchorPoint = Vector2.new(0.5, 0.5),
            Image = "rbxassetid://92562308197003",
            Size = UDim2.new(0, 20, 0, 20),
            BorderColor3 = Color3.fromRGB(0, 0, 0),
            BackgroundTransparency = 1,
            Name = "badge",
            Position = UDim2.new(0.5, 0, 0.5, 0)
        }, indicator)

        local badgeScale = Instance.new("UIScale")
        badgeScale.Scale = 0.6
        badgeScale.Name = "scale"
        badgeScale.Parent = badge

        local pulse = New("ImageLabel", {
            BorderSizePixel = 0,
            ScaleType = Enum.ScaleType.Fit,
            BackgroundColor3 = Color3.fromRGB(255, 255, 255),
            ImageTransparency = 0.5,
            ImageColor3 = Color3.fromRGB(255, 24, 24),
            AnchorPoint = Vector2.new(0.5, 0.5),
            Image = "rbxassetid://92562308197003",
            Size = UDim2.new(0, 20, 0, 20),
            BorderColor3 = Color3.fromRGB(0, 0, 0),
            BackgroundTransparency = 1,
            Name = "pulse",
            Position = UDim2.new(0.5, 0, 0.5, 0)
        }, indicator)

        local pulseScale = Instance.new("UIScale")
        pulseScale.Scale = 0
        pulseScale.Name = "scale"
        pulseScale.Parent = pulse

        New("UICorner", {Name = "corner", CornerRadius = UDim.new(1, 0)}, infoFrame)

        local infoStroke = New("UIStroke", {
            Color = Color3.fromRGB(255, 255, 255),
            ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
            Name = "stroke"
        }, infoFrame)

        New("UIGradient", {
            Rotation = 77,
            Transparency = NumberSequence.new{
                NumberSequenceKeypoint.new(0, 0),
                NumberSequenceKeypoint.new(0.5, 1),
                NumberSequenceKeypoint.new(1, 0)
            },
            Name = "gradient",
            Color = ColorSequence.new{
                ColorSequenceKeypoint.new(0, Color3.fromRGB(190, 190, 190)),
                ColorSequenceKeypoint.new(1, Color3.fromRGB(190, 190, 190))
            }
        }, infoStroke)

        New("ImageLabel", {
            ZIndex = 0,
            BorderSizePixel = 0,
            SliceCenter = Rect.new(512, 512, 512, 512),
            SliceScale = 0.05,
            ScaleType = Enum.ScaleType.Slice,
            BackgroundColor3 = Color3.fromRGB(255, 255, 255),
            ImageTransparency = 0.8,
            AnchorPoint = Vector2.new(0.5, 0.5),
            Image = "rbxassetid://104702090792389",
            Size = UDim2.new(1, -100, 1, -100),
            BorderColor3 = Color3.fromRGB(0, 0, 0),
            BackgroundTransparency = 1,
            Name = "camera",
            Position = UDim2.new(0.5, 0, 0.5, 0)
        }, canvas)

        local pulseTween = TweenService:Create(pulseScale, TweenInfo.new(1, Enum.EasingStyle.Quad, Enum.EasingDirection.Out, -1, true), {Scale = 1})
        pulseTween:Play()

        scale.Scale = 0
        TweenService:Create(scale, TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Scale = 1}):Play()

        local function close()
            stopFollow()
            pulseTween:Cancel()
            local char = LocalPlayer.Character
            if char and char:FindFirstChild("Humanoid") then
                workspace.CurrentCamera.CameraSubject = char.Humanoid
                workspace.CurrentCamera.CameraType = Enum.CameraType.Custom
            end
            if onClose then onClose() end
            local closeTween = TweenService:Create(scale, TweenInfo.new(0.15, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Scale = 0})
            closeTween.Completed:Connect(function()
                screenGui:Destroy()
            end)
            closeTween:Play()
        end

        closeBtn.MouseButton1Click:Connect(close)

        return {
            ScreenGui = screenGui,
            Close = close
        }
    end
end
