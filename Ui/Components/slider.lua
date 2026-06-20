-- Slider Component
return function(Tab, mainfunctions, configTitle, minVal, maxVal, defaultState, callback, overrideParent, layoutOrder)
    local TweenService = game:GetService("TweenService")
    local UserInputService = game:GetService("UserInputService")
    local New = mainfunctions.New
    local fonts = mainfunctions.GetFonts()

    local title = type(configTitle) == "table" and configTitle.Title or configTitle
    local min = type(configTitle) == "table" and configTitle.Min or minVal
    local max = type(configTitle) == "table" and configTitle.Max or maxVal
    local default = type(configTitle) == "table" and configTitle.Default or defaultState
    local cb = type(configTitle) == "table" and configTitle.Callback or callback
    local colName = type(configTitle) == "table" and configTitle.Column or nil
    local suffix = type(configTitle) == "table" and (configTitle.Suffix or "") or ""
    
    local parent = Tab.getWidgetParent(overrideParent, colName)
    Tab.WidgetCount = Tab.WidgetCount + 1
    local lOrder = layoutOrder or Tab.WidgetCount

    local valText = default or min

    local widgetFrame = New("Frame", {
        Size = UDim2.new(1, 0, 0, 48),
        BackgroundColor3 = Color3.fromRGB(30, 30, 30),
        LayoutOrder = lOrder
    }, parent)

    New("UICorner", {CornerRadius = UDim.new(0, 6)}, widgetFrame)

    New("UIStroke", {
        Color = Color3.fromRGB(45, 45, 45),
        Thickness = 1,
        Transparency = 0.5
    }, widgetFrame)
    
    New("TextLabel", {
        Size = UDim2.new(1, -60, 0, 24),
        Position = UDim2.new(0, 10, 0, 2),
        Text = title,
        TextColor3 = Color3.new(1, 1, 1),
        BackgroundTransparency = 1, 
        TextXAlignment = Enum.TextXAlignment.Left,
        FontFace = fonts.bold,
        TextSize = 14
    }, widgetFrame)

    local valueBox = New("TextBox", {
        Size = UDim2.new(0, 45, 0, 18),
        Position = UDim2.new(1, -10, 0, 4),
        AnchorPoint = Vector2.new(1, 0),
        Text = tostring(math.floor(valText)) .. suffix,
        TextColor3 = mainfunctions.CurrentAccent,
        BackgroundColor3 = Color3.fromRGB(20, 20, 20),
        BackgroundTransparency = 0,
        TextXAlignment = Enum.TextXAlignment.Center,
        FontFace = fonts.bold,
        TextSize = 12,
        ClearTextOnFocus = false,
        ZIndex = 10,
        AutomaticSize = Enum.AutomaticSize.X
    }, widgetFrame)

    New("UICorner", {CornerRadius = UDim.new(0, 4)}, valueBox)

    New("UISizeConstraint", {
        MinSize = Vector2.new(45, 18)
    }, valueBox)

    New("UIPadding", {
        PaddingLeft = UDim.new(0, 6),
        PaddingRight = UDim.new(0, 6)
    }, valueBox)
    
    local sliderBg = New("Frame", {
        Size = UDim2.new(1, -20, 0, 6),
        Position = UDim2.new(0.5, 0, 0.5, 12),
        AnchorPoint = Vector2.new(0.5, 0.5),
        BackgroundColor3 = Color3.fromRGB(60, 60, 60)
    }, widgetFrame)

    New("UICorner", {CornerRadius = UDim.new(1, 0)}, sliderBg)
    
    local sliderFill = New("Frame", {
        Size = UDim2.new(math.clamp((valText - min) / (max - min), 0, 1), 0, 1, 0),
        BackgroundColor3 = mainfunctions.CurrentAccent
    }, sliderBg)

    New("UICorner", {CornerRadius = UDim.new(1, 0)}, sliderFill)

    local sliderTrigger = New("TextButton", {
        Size = UDim2.new(1, -20, 0, 36),
        Position = UDim2.new(0.5, 0, 0.5, 12),
        AnchorPoint = Vector2.new(0.5, 0.5),
        BackgroundTransparency = 1,
        Text = "",
        AutoButtonColor = false
    }, widgetFrame)

    local function updateSlider(posInput)
        local scale = math.clamp(posInput, 0, 1)
        sliderFill.Size = UDim2.new(scale, 0, 1, 0)
        local exactValue = min + (scale * (max - min))
        local floorValue = math.floor(exactValue)
        valueBox.Text = tostring(floorValue) .. suffix
        if cb then 
            pcall(cb, floorValue) 
        end
    end

    -- Manual numeric input connection
    valueBox.FocusLost:Connect(function()
        local val = tonumber(valueBox.Text:match("%d+"))
        if val then
            val = math.clamp(val, min, max)
            valueBox.Text = tostring(val) .. suffix
            sliderFill.Size = UDim2.new(math.clamp((val - min) / (max - min), 0, 1), 0, 1, 0)
            if cb then 
                pcall(cb, val) 
            end
        else
            valueBox.Text = tostring(math.floor(min + (sliderFill.Size.X.Scale * (max - min)))) .. suffix
        end
    end)

    local dragging = false
    
    sliderTrigger.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
            local relativeX = (input.Position.X - sliderTrigger.AbsolutePosition.X) / sliderTrigger.AbsoluteSize.X
            updateSlider(relativeX)
        end
    end)
    
    UserInputService.InputChanged:Connect(function(input)
        if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
            local relativeX = (input.Position.X - sliderTrigger.AbsolutePosition.X) / sliderTrigger.AbsoluteSize.X
            updateSlider(relativeX)
        end
    end)
    
    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then 
            dragging = false 
        end
    end)

    if cb then
        task.spawn(pcall, cb, valText)
    end

    return {
        Set = function(_, newVal)
            newVal = math.clamp(newVal, min, max)
            valueBox.Text = tostring(newVal) .. suffix
            sliderFill.Size = UDim2.new(math.clamp((newVal - min) / (max - min), 0, 1), 0, 1, 0)
            if cb then 
                pcall(cb, newVal) 
            end
        end
    }
end
