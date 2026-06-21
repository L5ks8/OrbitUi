-- Dropdown Component
return function(Tab, mainfunctions, configTitle, configOptions, callback, overrideParent, layoutOrder)
    local TweenService = game:GetService("TweenService")
    local New = mainfunctions.New
    local fonts = mainfunctions.GetFonts()

    local title = type(configTitle) == "table" and configTitle.Title or configTitle
    local options = type(configTitle) == "table" and configTitle.Options or configOptions
    local cb = type(configTitle) == "table" and configTitle.Callback or callback
    local default = type(configTitle) == "table" and configTitle.Default or (options and options[1] or "None")
    local colName = type(configTitle) == "table" and configTitle.Column or nil
    local searchbar = type(configTitle) == "table" and (configTitle.Searchbar or configTitle.searchbar or configTitle.SearchBar) or false
    
    local parent = Tab.getWidgetParent(overrideParent, colName)
    Tab.WidgetCount = Tab.WidgetCount + 1
    local lOrder = layoutOrder or Tab.WidgetCount

    local dropped = false
    local selected = default
    
    local accent = mainfunctions.CurrentAccent

    local dropdownFrame = New("Frame", {
        Size = UDim2.new(1, 0, 0, 44),
        BackgroundColor3 = Color3.fromRGB(25, 25, 25),
        LayoutOrder = lOrder,
        ClipsDescendants = true
    }, parent)

    New("UICorner", {CornerRadius = UDim.new(0, 8)}, dropdownFrame)

    New("UIStroke", {
        Color = Color3.fromRGB(50, 50, 50),
        Thickness = 1,
        Transparency = 0.4
    }, dropdownFrame)

    New("TextLabel", {
        Size = UDim2.new(1, -24, 0, 16),
        Position = UDim2.new(0, 12, 0, 3),
        Text = title,
        TextColor3 = Color3.fromRGB(180, 180, 180),
        BackgroundTransparency = 1,
        TextXAlignment = Enum.TextXAlignment.Left,
        FontFace = fonts.med,
        TextSize = 12
    }, dropdownFrame)

    local btn = New("TextButton", {
        Size = UDim2.new(1, -24, 0, 22),
        Position = UDim2.new(0, 12, 0, 19),
        BackgroundColor3 = Color3.fromRGB(35, 35, 35),
        Text = "  " .. selected,
        TextColor3 = Color3.fromRGB(220, 220, 220),
        FontFace = fonts.med,
        TextSize = 13,
        TextXAlignment = Enum.TextXAlignment.Left,
        AutoButtonColor = false
    }, dropdownFrame)

    New("UICorner", {CornerRadius = UDim.new(0, 6)}, btn)

    local arrow = New("TextLabel", {
        Size = UDim2.new(0, 20, 0, 22),
        Position = UDim2.new(1, -24, 0.5, 0),
        AnchorPoint = Vector2.new(1, 0.5),
        Text = "▼",
        BackgroundTransparency = 1,
        TextColor3 = Color3.fromRGB(140, 140, 140),
        TextSize = 11,
        Rotation = -90
    }, btn)

    local function setTabScrollingEnabled(enabled)
        local function recurse(frame)
            if frame:IsA("ScrollingFrame") and frame.Name ~= "list" then
                frame.ScrollingEnabled = enabled
            end
            for _, child in pairs(frame:GetChildren()) do
                recurse(child)
            end
        end

        if Tab and Tab.tabFrame then
            recurse(Tab.tabFrame)
        end
    end

    Tab._activeDropdownCount = Tab._activeDropdownCount or 0

    local function updateDropdownScrollState(droppedState)
        if droppedState then
            Tab._activeDropdownCount = Tab._activeDropdownCount + 1
        else
            Tab._activeDropdownCount = math.max(0, Tab._activeDropdownCount - 1)
        end
        setTabScrollingEnabled(Tab._activeDropdownCount == 0)
    end

    local listPosition = searchbar and UDim2.new(0, 10, 0, 76) or UDim2.new(0, 10, 0, 48)
    local listSize = searchbar and UDim2.new(1, -20, 1, -80) or UDim2.new(1, -20, 1, -50)

    local list = New("ScrollingFrame", {
        Name = "list",
        Position = listPosition,
        Size = listSize,
        BackgroundTransparency = 1,
        Visible = false,
        ScrollBarThickness = 4,
        ScrollBarImageColor3 = mainfunctions.CurrentAccent,
        AutomaticCanvasSize = Enum.AutomaticSize.Y,
        CanvasSize = UDim2.new(0, 0, 0, 0),
        BorderSizePixel = 0,
        BackgroundColor3 = Color3.fromRGB(35, 35, 35)
    }, dropdownFrame)

    local listLayout = New("UIListLayout", {Padding = UDim.new(0, 4)}, list)

    local searchBox
    if searchbar then
        searchBox = New("TextBox", {
            Name = "search",
            Size = UDim2.new(1, -20, 0, 26),
            Position = UDim2.new(0, 30, 0, 48),
            BackgroundColor3 = Color3.fromRGB(28, 28, 28),
            Text = "",
            PlaceholderText = "Search...",
            TextColor3 = Color3.new(1, 1, 1),
            PlaceholderColor3 = Color3.fromRGB(130, 130, 130),
            FontFace = fonts.reg,
            TextSize = 13,
            TextXAlignment = Enum.TextXAlignment.Left,
            ClearTextOnFocus = false,
            Visible = false
        }, dropdownFrame)

        New("UICorner", {CornerRadius = UDim.new(0, 6)}, searchBox)
        New("UIPadding", {
            PaddingLeft = UDim.new(0, 10),
            PaddingRight = UDim.new(0, 10)
        }, searchBox)

        New("ImageLabel", {
            Name = "Icon",
            Size = UDim2.new(0, 14, 0, 14),
            Position = UDim2.new(0, 12, 0, 59),
            AnchorPoint = Vector2.new(0, 0.5),
            Image = "rbxassetid://112780490255100",
            ImageColor3 = Color3.fromRGB(200, 200, 200),
            BackgroundTransparency = 1,
            ZIndex = 11
        }, dropdownFrame)

        searchBox:GetPropertyChangedSignal("Text"):Connect(function()
            local query = searchBox.Text:lower()
            for _, child in pairs(list:GetChildren()) do
                if child:IsA("TextButton") then
                    local itemText = child.Text:lower():gsub("^%s+", "")
                    if itemText:find(query, 1, true) then
                        child.Visible = true
                    else
                        child.Visible = false
                    end
                end
            end
        end)
    end
    
    local function populateOptions(listOptions)
        for _, child in pairs(list:GetChildren()) do
            if child:IsA("TextButton") then 
                child:Destroy() 
            end
        end
        
        local function refreshOptionStyles()
            for _, child in ipairs(list:GetChildren()) do
                if child:IsA("TextButton") then
                    local isSel = child:GetAttribute("OptionValue") == tostring(selected)
                    if isSel then
                        child.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
                        child.TextColor3 = Color3.new(1, 1, 1)
                    else
                        child.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
                        child.TextColor3 = Color3.fromRGB(180, 180, 180)
                    end
                end
            end
        end

        for _, opt in pairs(listOptions) do
            local optionBtn = New("TextButton", {
                Size = UDim2.new(1, 0, 0, 30),
                BackgroundColor3 = Color3.fromRGB(35, 35, 35),
                Text = "  " .. tostring(opt),
                TextColor3 = Color3.fromRGB(180, 180, 180),
                FontFace = fonts.med,
                TextSize = 13,
                TextXAlignment = Enum.TextXAlignment.Left,
                AutoButtonColor = false
            }, list)

            optionBtn:SetAttribute("OptionValue", tostring(opt))
            New("UICorner", {CornerRadius = UDim.new(0, 6)}, optionBtn)

            optionBtn.MouseEnter:Connect(function()
                TweenService:Create(optionBtn, TweenInfo.new(0.12, Enum.EasingStyle.Quad), {BackgroundColor3 = Color3.fromRGB(55, 55, 55), TextColor3 = Color3.new(1, 1, 1)}):Play()
            end)
            optionBtn.MouseLeave:Connect(function()
                local isSel = optionBtn:GetAttribute("OptionValue") == tostring(selected)
                if isSel then
                    TweenService:Create(optionBtn, TweenInfo.new(0.12, Enum.EasingStyle.Quad), {BackgroundColor3 = Color3.fromRGB(45, 45, 45), TextColor3 = Color3.new(1, 1, 1)}):Play()
                else
                    TweenService:Create(optionBtn, TweenInfo.new(0.12, Enum.EasingStyle.Quad), {BackgroundColor3 = Color3.fromRGB(35, 35, 35), TextColor3 = Color3.fromRGB(180, 180, 180)}):Play()
                end
            end)

            optionBtn.MouseButton1Click:Connect(function()
                selected = opt
                btn.Text = "  " .. tostring(opt)
                btn.TextColor3 = Color3.fromRGB(255, 255, 255)
                dropped = false
                list.Visible = false
                if searchBox then
                    searchBox.Visible = false
                    searchBox.Text = ""
                end

                refreshOptionStyles()

                updateDropdownScrollState(false)
                TweenService:Create(arrow, TweenInfo.new(0.35, Enum.EasingStyle.Quart), {Rotation = -90}):Play()

                TweenService:Create(dropdownFrame, TweenInfo.new(0.35, Enum.EasingStyle.Quart), {Size = UDim2.new(1, 0, 0, 44)}):Play()
                if cb then
                    pcall(cb, opt)
                end
            end)
        end

        refreshOptionStyles()
    end
    
    populateOptions(options)
    
    btn.MouseButton1Click:Connect(function()
        dropped = not dropped
        list.Visible = dropped
        if searchBox then
            searchBox.Visible = dropped
            if not dropped then
                searchBox.Text = ""
            end
        end

        updateDropdownScrollState(dropped)
        TweenService:Create(arrow, TweenInfo.new(0.35, Enum.EasingStyle.Quart), {Rotation = dropped and 0 or -90}):Play()

        local targetHeight = dropped and (searchbar and 200 or math.min(listLayout.AbsoluteContentSize.Y + 54, 200)) or 44
        TweenService:Create(dropdownFrame, TweenInfo.new(0.35, Enum.EasingStyle.Quart), {Size = UDim2.new(1, 0, 0, targetHeight)}):Play()
    end)

    return {
        Refresh = function(_, newList)
            populateOptions(newList)
        end,
        Set = function(_, value)
            selected = value
            btn.Text = "  " .. tostring(value)
            btn.TextColor3 = Color3.fromRGB(255, 255, 255)
            if cb then 
                pcall(cb, value) 
            end
        end
    }
end
