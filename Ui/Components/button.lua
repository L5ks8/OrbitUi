-- Button Component
return function(Tab, mainfunctions, configTitle, callback, overrideParent, layoutOrder)
    local TweenService = game:GetService("TweenService")
    local New = mainfunctions.New
    local fonts = mainfunctions.GetFonts()

    local title = type(configTitle) == "table" and configTitle.Title or configTitle
    local cb = type(configTitle) == "table" and configTitle.Callback or callback
    local colName = type(configTitle) == "table" and configTitle.Column or nil
    
    local parent = Tab.getWidgetParent(overrideParent, colName)
    Tab.WidgetCount = Tab.WidgetCount + 1
    local lOrder = layoutOrder or Tab.WidgetCount

    local buttonWidget = New("TextButton", {
        Size = UDim2.new(1, 0, 0, 28),
        BackgroundColor3 = Color3.fromRGB(41, 41, 41),
        Text = title,
        TextColor3 = Color3.new(1, 1, 1),
        FontFace = fonts.bold,
        TextSize = 14,
        TextTruncate = Enum.TextTruncate.AtEnd,
        LayoutOrder = lOrder,
        AutoButtonColor = false
    }, parent)

    New("UICorner", {CornerRadius = UDim.new(0, 6)}, buttonWidget)
    
    local stroke = New("UIStroke", {
        Color = Color3.fromRGB(60, 60, 60),
        Thickness = 1,
        Transparency = 0.5
    }, buttonWidget)

    buttonWidget.MouseEnter:Connect(function()
        TweenService:Create(buttonWidget, TweenInfo.new(0.25), {BackgroundColor3 = Color3.fromRGB(50, 50, 50)}):Play()
    end)
    buttonWidget.MouseLeave:Connect(function()
        TweenService:Create(buttonWidget, TweenInfo.new(0.25), {BackgroundColor3 = Color3.fromRGB(41, 41, 41)}):Play()
    end)

    buttonWidget.MouseButton1Click:Connect(function()
        TweenService:Create(buttonWidget, TweenInfo.new(0.1, Enum.EasingStyle.Quart), {Size = UDim2.new(1, -6, 0, 26)}):Play()
        task.wait(0.08)
        TweenService:Create(buttonWidget, TweenInfo.new(0.15, Enum.EasingStyle.Quart), {Size = UDim2.new(1, 0, 0, 28)}):Play()
        if cb then 
            pcall(cb) 
        end
    end)

    -- Consistent API: return table with methods (like other components)
    return {
        Instance = buttonWidget,
        SetText = function(_, newText)
            buttonWidget.Text = tostring(newText)
        end,
        SetCallback = function(_, newCb)
            cb = newCb
        end
    }
end
