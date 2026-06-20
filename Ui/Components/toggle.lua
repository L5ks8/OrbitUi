-- Toggle Component
return function(Tab, mainfunctions, configTitle, defaultState, callback, overrideParent, layoutOrder)
    local TweenService = game:GetService("TweenService")
    local RunService = game:GetService("RunService")
    local New = mainfunctions.New
    local fonts = mainfunctions.GetFonts()

    local title = type(configTitle) == "table" and configTitle.Title or configTitle
    local default = type(configTitle) == "table" and configTitle.Default or defaultState
    local cb = type(configTitle) == "table" and configTitle.Callback or callback
    local subTitle = type(configTitle) == "table" and configTitle.SubTitle or nil
    local colName = type(configTitle) == "table" and configTitle.Column or nil
    
    local parent = Tab.getWidgetParent(overrideParent, colName)
    Tab.WidgetCount = Tab.WidgetCount + 1
    local lOrder = layoutOrder or Tab.WidgetCount

    local state = default or false
    local hasSub = (subTitle ~= nil)
    
    local widgetFrame = New("Frame", {
        Size = UDim2.new(1, 0, 0, hasSub and 42 or 30),
        BackgroundColor3 = Color3.fromRGB(30, 30, 30),
        LayoutOrder = lOrder
    }, parent)
    
    New("UICorner", {CornerRadius = UDim.new(0, 6)}, widgetFrame)
    
    local borderStroke = New("UIStroke", {
        Color = Color3.fromRGB(45, 45, 45),
        Thickness = 1,
        Transparency = 0.5
    }, widgetFrame)

    if hasSub then
        New("TextLabel", {
            Size = UDim2.new(1, -60, 0, 18),
            Position = UDim2.new(0, 10, 0, 4),
            Text = title,
            TextColor3 = Color3.new(1, 1, 1),
            BackgroundTransparency = 1, 
            TextXAlignment = Enum.TextXAlignment.Left,
            FontFace = fonts.bold,
            TextSize = 14,
            TextTruncate = Enum.TextTruncate.AtEnd
        }, widgetFrame)
        
        New("TextLabel", {
            Size = UDim2.new(1, -60, 0, 14),
            Position = UDim2.new(0, 10, 0, 22),
            Text = subTitle,
            TextColor3 = Color3.fromRGB(150, 150, 150),
            BackgroundTransparency = 1,
            TextXAlignment = Enum.TextXAlignment.Left,
            FontFace = fonts.reg,
            TextSize = 12,
            RichText = true,
            TextTruncate = Enum.TextTruncate.AtEnd
        }, widgetFrame)
    else
        New("TextLabel", {
            Size = UDim2.new(1, -60, 1, 0),
            Position = UDim2.new(0, 10, 0, 0),
            Text = title,
            TextColor3 = Color3.new(1, 1, 1),
            BackgroundTransparency = 1,
            TextXAlignment = Enum.TextXAlignment.Left, 
            FontFace = fonts.bold,
            TextSize = 14, 
            TextTruncate = Enum.TextTruncate.AtEnd
        }, widgetFrame)
    end

    local toggleBtn = New("TextButton", {
        Size = UDim2.new(0, 36, 0, 18),
        Position = UDim2.new(1, -12, 0.5, 0),
        AnchorPoint = Vector2.new(1, 0.5),
        BackgroundColor3 = state and mainfunctions.CurrentAccent or Color3.fromRGB(45, 45, 45),
        Text = "",
        AutoButtonColor = false
    }, widgetFrame)

    New("UICorner", {CornerRadius = UDim.new(1, 0)}, toggleBtn)
    
    local sliderCircle = New("Frame", {
        Size = UDim2.new(0, 14, 0, 14),
        Position = state and UDim2.new(1, -16, 0.5, 0) or UDim2.new(0, 2, 0.5, 0),
        AnchorPoint = Vector2.new(0, 0.5),
        BackgroundColor3 = Color3.new(1, 1, 1)
    }, toggleBtn)
    
    New("UICorner", {CornerRadius = UDim.new(1, 0)}, sliderCircle)

    local hoverSelector = New("Frame", {
        Name = "selector",
        Size = UDim2.new(1, 0, 1, 0),
        BackgroundTransparency = 1,
        ZIndex = 10
    }, toggleBtn)
    New("UICorner", {CornerRadius = UDim.new(1, 0)}, hoverSelector)
    
    local hoverStroke = New("UIStroke", {
        Color = Color3.new(1, 1, 1),
        Thickness = 1.5,
        Transparency = 1,
        ApplyStrokeMode = "Border"
    }, hoverSelector)

    local toggleGradient = New("UIGradient", {
        Transparency = NumberSequence.new({
            NumberSequenceKeypoint.new(0, 1),
            NumberSequenceKeypoint.new(0.45, 0),
            NumberSequenceKeypoint.new(0.55, 0),
            NumberSequenceKeypoint.new(1, 1)
        })
    }, hoverStroke)

    local toggleSpinConn
    toggleSpinConn = RunService.RenderStepped:Connect(function(dt)
        if not toggleBtn or not toggleBtn.Parent then
            toggleSpinConn:Disconnect()
            return
        end
        toggleGradient.Rotation = (toggleGradient.Rotation + 120 * dt) % 360
    end)

    widgetFrame.Destroying:Connect(function()
        if toggleSpinConn then toggleSpinConn:Disconnect() end
    end)

    widgetFrame.MouseEnter:Connect(function()
        TweenService:Create(hoverStroke, TweenInfo.new(0.3), {Transparency = 0.5}):Play()
    end)
    widgetFrame.MouseLeave:Connect(function()
        TweenService:Create(hoverStroke, TweenInfo.new(0.3), {Transparency = 1}):Play()
    end)

    toggleBtn.MouseButton1Click:Connect(function()
        state = not state
        TweenService:Create(toggleBtn, TweenInfo.new(0.25, Enum.EasingStyle.Quart), {
            BackgroundColor3 = state and mainfunctions.CurrentAccent or Color3.fromRGB(45, 45, 45)
        }):Play()
        TweenService:Create(sliderCircle, TweenInfo.new(0.25, Enum.EasingStyle.Quart), {
            Position = state and UDim2.new(1, -16, 0.5, 0) or UDim2.new(0, 2, 0.5, 0)
        }):Play()
        if cb then 
            pcall(cb, state) 
        end
    end)
    
    return {
        Set = function(_, newState)
            state = newState
            TweenService:Create(toggleBtn, TweenInfo.new(0.25, Enum.EasingStyle.Quart), {
                BackgroundColor3 = state and mainfunctions.CurrentAccent or Color3.fromRGB(45, 45, 45)
            }):Play()
            TweenService:Create(sliderCircle, TweenInfo.new(0.25, Enum.EasingStyle.Quart), {
                Position = state and UDim2.new(1, -16, 0.5, 0) or UDim2.new(0, 2, 0.5, 0)
            }):Play()
            if cb then 
                pcall(cb, state) 
            end
        end
    }
end
