-- UI Keybind Component
return function(Tab, mainfunctions, configTitle, defaultKey, callback, overrideParent, layoutOrder)
    local UserInputService = game:GetService("UserInputService")
    local TweenService = game:GetService("TweenService")
    local New = mainfunctions.New
    local fonts = mainfunctions.GetFonts()

    local title = type(configTitle) == "table" and configTitle.Title or configTitle
    local default = type(configTitle) == "table" and configTitle.Default or defaultKey
    local cb = type(configTitle) == "table" and configTitle.Callback or callback
    local colName = type(configTitle) == "table" and configTitle.Column or nil

    if mainfunctions.UIToggleBindRegistered then
        warn("Orbit Ui: UI Keybind toggle can only be used once per UI.")
        return nil
    end
    mainfunctions.UIToggleBindRegistered = true
    mainfunctions.ToggleKey = default

    local parent = Tab.getWidgetParent(overrideParent, colName)
    Tab.WidgetCount = Tab.WidgetCount + 1
    local lOrder = layoutOrder or Tab.WidgetCount

    -- Convert KeyCode to a readable string
    local function getKeyName(key)
        if not key then return "None" end
        if type(key) == "string" then return key end
        if typeof(key) == "EnumItem" then return key.Name end
        return tostring(key)
    end

    local currentKey = default
    local isBinding = false

    local widgetFrame = New("Frame", {
        Size = UDim2.new(1, 0, 0, 30),
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
        Size = UDim2.new(1, -90, 1, 0),
        Position = UDim2.new(0, 10, 0, 0),
        Text = title,
        TextColor3 = Color3.new(1, 1, 1),
        BackgroundTransparency = 1,
        TextXAlignment = Enum.TextXAlignment.Left,
        FontFace = fonts.bold,
        TextSize = 14,
        TextTruncate = Enum.TextTruncate.AtEnd
    }, widgetFrame)

    local bindBtn = New("TextButton", {
        Size = UDim2.new(0, 70, 0, 20),
        Position = UDim2.new(1, -10, 0.5, 0),
        AnchorPoint = Vector2.new(1, 0.5),
        BackgroundColor3 = Color3.fromRGB(40, 40, 40),
        Text = getKeyName(currentKey),
        TextColor3 = mainfunctions.CurrentAccent,
        FontFace = fonts.bold,
        TextSize = 12,
        AutomaticSize = Enum.AutomaticSize.X,
        AutoButtonColor = false
    }, widgetFrame)

    New("UICorner", {CornerRadius = UDim.new(0, 5)}, bindBtn)
    
    New("UIPadding", {
        PaddingLeft = UDim.new(0, 8),
        PaddingRight = UDim.new(0, 8)
    }, bindBtn)

    New("UIStroke", {
        Color = Color3.fromRGB(60, 60, 60),
        Thickness = 1,
        Transparency = 0.5
    }, bindBtn)

    bindBtn.MouseEnter:Connect(function()
        TweenService:Create(bindBtn, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(50, 50, 50)}):Play()
    end)
    bindBtn.MouseLeave:Connect(function()
        if not isBinding then
            TweenService:Create(bindBtn, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(40, 40, 40)}):Play()
        end
    end)

    local inputConn
    bindBtn.MouseButton1Click:Connect(function()
        if isBinding then return end
        isBinding = true
        bindBtn.Text = "..."
        bindBtn.TextColor3 = Color3.fromRGB(200, 200, 200)

        inputConn = UserInputService.InputBegan:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.Keyboard then
                local code = input.KeyCode
                if code ~= Enum.KeyCode.Unknown then
                    inputConn:Disconnect()
                    inputConn = nil
                    isBinding = false
                    
                    if code == Enum.KeyCode.Escape then
                        bindBtn.Text = getKeyName(currentKey)
                        bindBtn.TextColor3 = mainfunctions.CurrentAccent
                        TweenService:Create(bindBtn, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(40, 40, 40)}):Play()
                        return
                    end
                    
                    currentKey = code
                    bindBtn.Text = code.Name
                    bindBtn.TextColor3 = mainfunctions.CurrentAccent
                    TweenService:Create(bindBtn, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(40, 40, 40)}):Play()
                    mainfunctions.ToggleKey = code
                    if cb then
                        pcall(cb, code)
                    end
                end
            end
        end)
    end)

    widgetFrame.Destroying:Connect(function()
        if inputConn then inputConn:Disconnect() end
    end)

    return {
        Set = function(_, newKey)
            currentKey = newKey
            bindBtn.Text = getKeyName(newKey)
            mainfunctions.ToggleKey = newKey
            if cb then
                pcall(cb, newKey)
            end
        end,
        Get = function()
            return currentKey
        end
    }
end
