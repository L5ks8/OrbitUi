local UIFunctions = {}

local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local Stats = game:GetService("Stats")

UIFunctions.CurrentAccent = Color3.fromRGB(248, 191, 212)
UIFunctions.CurrentMain = Color3.fromRGB(36, 36, 36)

UIFunctions.Themes = {}

function UIFunctions.New(class, props, parent)
    local i = Instance.new(class)
    for k, v in pairs(props) do 
        i[k] = v 
    end
    if parent then 
        i.Parent = parent 
    end
    return i
end

function UIFunctions.GetFonts()
    return {
        reg = Font.new("rbxassetid://12187365364"),
        bold = Font.new("rbxassetid://12187365364", Enum.FontWeight.Bold),
        med = Font.new("rbxassetid://12187365364", Enum.FontWeight.Medium),
        logo = Font.new("rbxasset://fonts/families/SourceSansPro.json", Enum.FontWeight.Bold)
    }
end

-- Theme Switcher with Smooth Tweens
function UIFunctions.SetTheme(G2L, themeName)
    local themes = UIFunctions.Themes or {}
    local theme = themes[themeName]
    if not theme then
        for _, t in pairs(themes) do
            theme = t
            break
        end
    end
    if not theme then return end
    
    local newAccent = theme.Accent
    local oldAccent = UIFunctions.CurrentAccent
    
    UIFunctions.CurrentMain = theme.Main
    
    local tweenInfo = TweenInfo.new(0.35, Enum.EasingStyle.Quart, Enum.EasingDirection.Out)
    
    if G2L["2"] then 
        TweenService:Create(G2L["2"], tweenInfo, {BackgroundColor3 = theme.Main}):Play() 
    end
    
    for _, v in pairs(G2L["1"]:GetDescendants()) do
        if (v:IsA("TextLabel") or v:IsA("TextButton") or v:IsA("TextBox")) and v.TextColor3 == oldAccent then
            TweenService:Create(v, tweenInfo, {TextColor3 = newAccent}):Play()
        elseif (v:IsA("Frame") or v:IsA("ScrollingFrame") or v:IsA("TextButton") or v:IsA("ImageButton")) and v.BackgroundColor3 == oldAccent then
            TweenService:Create(v, tweenInfo, {BackgroundColor3 = newAccent}):Play()
        elseif v:IsA("ScrollingFrame") and v.ScrollBarImageColor3 == oldAccent then
            TweenService:Create(v, tweenInfo, {ScrollBarImageColor3 = newAccent}):Play()
        end
    end
    
    UIFunctions.CurrentAccent = newAccent
end

-- Drag, Resize, Minimize, stats handling
function UIFunctions.InitBehavior(G2L, window, closeCallback)
    local isMinimized = false
    local originalSize = G2L["2"].Size
    local sidebarOpen = true
    local miniButtons = nil
    local miniLogo = nil
    local resizing, resizeStartPos, resizeStartSize, resizeConn
    

    local drag, dragStart, startPos, windowDragged, windowTargetPos
    local dragThreshold = 5
    
    -- Smooth Scale Toggle Animation
    local isToggling = false
    local function animateToggle()
        if isToggling then return end
        isToggling = true
        
        if G2L["2"].Visible then
            local closeTween = TweenService:Create(
                G2L["2"], 
                TweenInfo.new(0.3, Enum.EasingStyle.Back, Enum.EasingDirection.In), 
                { Size = UDim2.new(0, 0, 0, 0) }
            )
            closeTween:Play()
            closeTween.Completed:Connect(function()
                G2L["2"].Visible = false
                isToggling = false
            end)
        else
            local targetSize = isMinimized and UDim2.new(0, 260, 0, 35) or originalSize
            G2L["2"].Size = UDim2.new(0, 0, 0, 0)
            G2L["2"].Visible = true
            
            local openTween = TweenService:Create(
                G2L["2"], 
                TweenInfo.new(0.4, Enum.EasingStyle.Back, Enum.EasingDirection.Out), 
                { Size = targetSize }
            )
            openTween:Play()
            openTween.Completed:Connect(function()
                isToggling = false
            end)
        end
    end

    UserInputService.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement then
            if drag and not resizing then
                local delta = input.Position - dragStart
                if not windowDragged and delta.Magnitude > dragThreshold then
                    windowDragged = true
                end
                if windowDragged then
                    windowTargetPos = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
                end
            end
        end
    end)

    UserInputService.InputEnded:Connect(function(input) 
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            drag, windowDragged = false, false
        end
    end)

    -- RenderStepped for Lerp movement
    local lerpConn
    lerpConn = RunService.RenderStepped:Connect(function()
        if not G2L["1"] or not G2L["1"].Parent then
            lerpConn:Disconnect()
            return
        end
        if drag and windowTargetPos then
            G2L["2"].Position = G2L["2"].Position:Lerp(windowTargetPos, 0.12)
        end
    end)

    -- Keybind Toggle (Customizable, defaults to RightControl)
    UserInputService.InputBegan:Connect(function(input, gpe)
        if not gpe then
            if input.KeyCode == (UIFunctions.ToggleKey or Enum.KeyCode.RightControl) then
                animateToggle()
                return
            end
        end

        if input.UserInputType == Enum.UserInputType.MouseButton1 and G2L["2"].Visible then
            if resizing then return end

            local pos = input.Position
            local onInteractive = false
            local objects = G2L["1"]:GetGuiObjectsAtPosition(pos.X, pos.Y)
            for _, obj in pairs(objects) do
                if obj:IsA("TextButton") or obj:IsA("ImageButton") or obj:IsA("TextBox") then
                    onInteractive = true
                    break
                end
            end

            if onInteractive or gpe then return end

            local absPos = G2L["2"].AbsolutePosition
            local absSize = G2L["2"].AbsoluteSize

            if pos.X >= absPos.X and pos.X <= absPos.X + absSize.X and pos.Y >= absPos.Y and pos.Y <= absPos.Y + absSize.Y then
                drag, dragStart, startPos, windowDragged, windowTargetPos = true, pos, G2L["2"].Position, false, G2L["2"].Position
            end
        end
    end)

    -- Sidebar Toggle Function
    local function animateSidebar()
        sidebarOpen = not sidebarOpen
        
        local barTargetSize = sidebarOpen and UDim2.new(0, 220, 1, 0) or UDim2.new(0, 70, 1, 0)
        local screenTargetSize = sidebarOpen and UDim2.new(1, -235, 1, 0) or UDim2.new(1, -85, 1, 0)
        
        TweenService:Create(G2L["16"], TweenInfo.new(0.35, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {Size = barTargetSize}):Play()
        TweenService:Create(G2L["11"], TweenInfo.new(0.35, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {Size = screenTargetSize}):Play()
        
        local navPadding = G2L["4c"]:FindFirstChildOfClass("UIPadding")
        if navPadding then
            navPadding.PaddingLeft = sidebarOpen and UDim.new(0, 8) or UDim.new(0, 0)
            navPadding.PaddingRight = sidebarOpen and UDim.new(0, 8) or UDim.new(0, 0)
        end
        
        local mainPadding = G2L["19"]:FindFirstChildOfClass("UIPadding")
        if mainPadding then
            mainPadding.PaddingLeft = sidebarOpen and UDim.new(0, 6) or UDim.new(0, 0)
            mainPadding.PaddingRight = sidebarOpen and UDim.new(0, 6) or UDim.new(0, 0)
        end
        
        local userPadding = G2L["38"]:FindFirstChildOfClass("UIPadding")
        if userPadding then
            userPadding.PaddingLeft = sidebarOpen and UDim.new(0, 10) or UDim.new(0, 11)
            userPadding.PaddingRight = sidebarOpen and UDim.new(0, 35) or UDim.new(0, 11)
        end
        
        local userInfo = G2L["38"]:FindFirstChild("info")
        if userInfo then
            userInfo.Visible = sidebarOpen
        end
        
        local userTime = G2L["38"]:FindFirstChild("time")
        if userTime then
            userTime.Visible = sidebarOpen
        end
        
        local function updateItems(parentFrame)
            for _, btn in ipairs(parentFrame:GetChildren()) do
                if btn:IsA("ImageButton") then
                    local innerItem = btn:FindFirstChild("item")
                    if innerItem then
                        local label = innerItem:FindFirstChild("label")
                        if label then
                            label.Visible = sidebarOpen
                        end
                        local uiPadding = innerItem:FindFirstChildOfClass("UIPadding")
                        if uiPadding then
                            uiPadding.PaddingLeft = sidebarOpen and UDim.new(0, 12) or UDim.new(0, 14)
                            uiPadding.PaddingRight = sidebarOpen and UDim.new(0, 12) or UDim.new(0, 14)
                        end
                    end
                end
            end
        end
        
        updateItems(G2L["4c"])
        updateItems(G2L["19"])
    end

    if G2L["80"] then
        G2L["80"].MouseButton1Click:Connect(animateSidebar)
    end

    local function closeUI()
        if closeCallback then 
            pcall(closeCallback) 
        end
        local closeTween = TweenService:Create(
            G2L["2"], 
            TweenInfo.new(0.35, Enum.EasingStyle.Back, Enum.EasingDirection.In), 
            { Size = UDim2.new(0, 0, 0, 0) }
        )
        closeTween:Play()
        closeTween.Completed:Connect(function()
            G2L["1"]:Destroy() 
        end)
    end

    if G2L["72"] then 
        G2L["72"].MouseButton1Click:Connect(closeUI) 
    end

    local function toggleMinimize()
        isMinimized = not isMinimized
        local targetSize = isMinimized and UDim2.new(0, 260, 0, 35) or originalSize

        local tween = TweenService:Create(
            G2L["2"], 
            TweenInfo.new(0.45, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), 
            { Size = targetSize })
        tween:Play()
        
        if isMinimized then

            G2L["10"].Visible = false
            G2L["65"].Visible = false
            G2L["a1"].Visible = false
            G2L["b"].Visible = false
            

            miniButtons = G2L["70"]:Clone()
            miniButtons.Name = "MiniButtons"
            miniButtons.Parent = G2L["5"]
            miniButtons.Size = UDim2.new(0, 85, 0, 27)
            miniButtons.AnchorPoint = Vector2.new(1, 0.5) 
            miniButtons.Position = UDim2.new(1, -15, 0, 17.5)
            miniButtons.ZIndex = 2000
            miniButtons.Visible = true
            
            for _, child in pairs(miniButtons:GetDescendants()) do
                if child:IsA("GuiObject") then
                    child.ZIndex = miniButtons.ZIndex + 5
                    if child:IsA("ImageLabel") then
                        child.ImageTransparency = 0
                    end
                    child.Visible = true
                end
            end

            miniLogo = G2L["6c"]:Clone()
            miniLogo.Name = "MiniLogo"
            miniLogo.Parent = G2L["5"]
            miniLogo.AnchorPoint = Vector2.new(0, 0.5)
            miniLogo.Position = UDim2.new(0, 15, 0, 17.5)
            miniLogo.ZIndex = 2000
            miniLogo.Visible = true

            local logoText = miniLogo:FindFirstChild("logo_text")
            if logoText then
                logoText.RichText = true
                logoText.TextTransparency = 0
                logoText.Text = window.Logo or '<font color="rgb(248, 191, 212)">Test</font>Ui'
                logoText.Visible = true
            end

            if miniButtons:FindFirstChild("close") then 
                miniButtons.close.MouseButton1Click:Connect(closeUI) 
            end
            if miniButtons:FindFirstChild("maximize") then 
                miniButtons.maximize.MouseButton1Click:Connect(toggleMinimize) 
            end
            if miniButtons:FindFirstChild("sidebar_toggle") then
                miniButtons.sidebar_toggle.MouseButton1Click:Connect(animateSidebar)
            end
        else

            if miniButtons then 
                miniButtons:Destroy() 
                miniButtons = nil 
            end
            if miniLogo then 
                miniLogo:Destroy() 
                miniLogo = nil 
            end
            G2L["10"].Visible = true
            G2L["65"].Visible = true
            G2L["a1"].Visible = true
            G2L["b"].Visible = true
        end
    end

    if G2L["94"] then 
        G2L["94"].MouseButton1Click:Connect(toggleMinimize) 
    end

    if G2L["b"] then
        G2L["b"].Size = UDim2.new(0, 30, 0, 30)
        G2L["b"].InputBegan:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 then
                drag = false
                resizing, resizeStartPos, resizeStartSize = true, input.Position, G2L["2"].AbsoluteSize
                resizeConn = UserInputService.InputChanged:Connect(function(move)
                    if move.UserInputType == Enum.UserInputType.MouseMovement then
                        local delta = move.Position - resizeStartPos
                        G2L["2"].Size = UDim2.new(0, math.clamp(resizeStartSize.X + delta.X, 500, 1200), 0, math.clamp(resizeStartSize.Y + delta.Y, 350, 800))
                        if not isMinimized then 
                            originalSize = G2L["2"].Size 
                        end
                    end
                end)
            end
        end)
        UserInputService.InputEnded:Connect(function(input) 
            if input.UserInputType == Enum.UserInputType.MouseButton1 and resizing then 
                resizing = false 
                if resizeConn then 
                    resizeConn:Disconnect() 
                end 
            end 
        end)
    end

    -- Calculate FPS precisely using RenderStepped
    local lastTime = os.clock()
    local fpsCount = 0
    local currentFps = 0
    local fpsConn
    fpsConn = RunService.RenderStepped:Connect(function()
        if not G2L["1"] or not G2L["1"].Parent then
            fpsConn:Disconnect()
            return
        end
        fpsCount = fpsCount + 1
        local now = os.clock()
        if now - lastTime >= 1 then
            currentFps = fpsCount
            fpsCount = 0
            lastTime = now
        end
    end)

    -- Stats Updater Loop (Runs once per second)
    task.spawn(function()
        while task.wait(1) do
            if not G2L["1"] or not G2L["1"].Parent then 
                break 
            end
            
            pcall(function()
                    if G2L["fps_label"] then
                    G2L["fps_label"].Text = "FPS: " .. currentFps
                end
                if G2L["ping_label"] then
                    local ping = math.floor(Stats:FindFirstChild("PerformanceStats") and Stats.PerformanceStats.Ping:GetValue() or 0)
                    G2L["ping_label"].Text = ping .. " ms"
                end
                if G2L["mem_label"] then
                    G2L["mem_label"].Text = string.format("%.1f MB", Stats:GetTotalMemoryUsageMb())
                end
                if G2L["region_label"] then
                    G2L["region_label"].Text = "Region: N/A"
                end
                if G2L["time_text"] then
                    G2L["time_text"].Text = os.date("%I:%M %p")
                end
            end)
        end
    end)
end

        function UIFunctions.BuildWindow(G2L, config, components)
            config = config or {}
            local title = config.Title or "Test UI"
            local versionText = config.Version or "1.0.0"
            local logo = config.Logo or "<font color=\"rgb(248, 191, 212)\">Test</font>Ui"
            local defaultTheme = config.Theme or "Dark"

            local Window = {
                G2L = G2L,
                TabCount = 0,
                Logo = logo,
                Stats = {
                    FPS = G2L["fps_label"],
                    Ping = G2L["ping_label"],
                    Memory = G2L["mem_label"]
                }
            }
            local secondaryTabCount = 0
            local New = UIFunctions.New
            local fonts = UIFunctions.GetFonts()

            function Window:CreateTab(tabNameOrConfig)
                self.TabCount = self.TabCount + 1
                local tabIndex = self.TabCount
                
                local tabName = ""
                local isSecondary = false
                local iconId = "11433532654"
                local hasColumns = false
                local searchbar = false
                
                if type(tabNameOrConfig) == "table" then
                    tabName = tabNameOrConfig.Name or "Tab"
                    iconId = tabNameOrConfig.Icon or "11433532654"
                    isSecondary = tabNameOrConfig.SecondaryTab or false
                    hasColumns = tabNameOrConfig.Columns or false
                    searchbar = tabNameOrConfig.Searchbar or tabNameOrConfig.searchbar or tabNameOrConfig.SearchBar or false
                else
                    tabName = tostring(tabNameOrConfig)
                end

                -- Enforce max 2 secondary tabs
                if isSecondary then
                    secondaryTabCount = secondaryTabCount + 1
                    if secondaryTabCount > 2 then
                        warn("Orbit Ui: Max 2 secondary tabs allowed. '" .. tabName .. "' was not created.")
                        return nil
                    end
                end

                -- Construct Tab Sidebar Navigation Button
                local parentFrame = isSecondary and G2L["19"] or G2L["4c"]
                
                local navBtn = New("ImageButton", {
                    Name = tabName,
                    Size = UDim2.new(1, 0, 0, 31),
                    BackgroundTransparency = 1,
                    AutoButtonColor = false,
                    LayoutOrder = tabIndex,
                    ClipsDescendants = false
                }, parentFrame)

                local innerItem = New("Frame", {
                    Name = "item",
                    Size = UDim2.new(1, 0, 1, 0),
                    BackgroundTransparency = 1,
                    ZIndex = 2
                }, navBtn)

                local selectorFrame = New("Frame", {
                    Name = "selector",
                    AnchorPoint = Vector2.new(0.5, 0.5),
                    Position = UDim2.new(0.5, 0, 0.5, 0),
                    Size = UDim2.new(1, 0, 1, 0),
                    BackgroundColor3 = Color3.fromRGB(41, 41, 41),
                    BackgroundTransparency = 1,
                    ZIndex = 0
                }, navBtn)

                New("UICorner", {CornerRadius = UDim.new(0, 10)}, selectorFrame)

                local stroke = New("UIStroke", {
                    Name = "SelectionStroke",
                    Color = Color3.new(1, 1, 1),
                    Thickness = 1.5,
                    Transparency = 1,
                    ApplyStrokeMode = "Border"
                }, selectorFrame)

                local gradient = New("UIGradient", {
                    Transparency = NumberSequence.new({
                        NumberSequenceKeypoint.new(0, 1),
                        NumberSequenceKeypoint.new(0.45, 0),
                        NumberSequenceKeypoint.new(0.55, 0),
                        NumberSequenceKeypoint.new(1, 1)
                    })
                }, stroke)

                -- Spin gradient border
                local borderSpinConn
                borderSpinConn = RunService.RenderStepped:Connect(function(dt)
                    if not navBtn or not navBtn.Parent then
                        borderSpinConn:Disconnect()
                        return
                    end
                    gradient.Rotation = (gradient.Rotation + 6 * dt) % 360
                end)

                New("UIListLayout", {
                    FillDirection = Enum.FillDirection.Horizontal,
                    VerticalAlignment = Enum.VerticalAlignment.Center,
                    Padding = UDim.new(0, 10)
                }, innerItem)

                New("UIPadding", {
                    PaddingLeft = UDim.new(0, 12),
                    PaddingRight = UDim.new(0, 12)
                }, innerItem)

                local iconHolder = New("ImageLabel", {
                    Name = "holder",
                    Size = UDim2.new(0, 20, 0, 20),
                    BackgroundColor3 = Color3.new(0, 0, 0),
                    BackgroundTransparency = 0.8,
                    ImageTransparency = 1,
                    LayoutOrder = 1,
                    ZIndex = 3
                }, innerItem)

                New("UICorner", {CornerRadius = UDim.new(0, 6)}, iconHolder)

                local iconImg = New("ImageLabel", {
                    Name = "icon",
                    Size = UDim2.new(0, 14, 0, 14),
                    Position = UDim2.new(0.5, 0, 0.5, 0),
                    AnchorPoint = Vector2.new(0.5, 0.5),
                    Image = "rbxassetid://" .. iconId,
                    ImageTransparency = 0.5,
                    ZIndex = 4,
                    BackgroundTransparency = 1
                }, iconHolder)

                local textLabel = New("TextLabel", {
                    Name = "label",
                    Text = tabName,
                    FontFace = fonts.bold,
                    TextSize = 15,
                    TextColor3 = Color3.new(1, 1, 1),
                    TextTransparency = 0.5,
                    BackgroundTransparency = 1,
                    LayoutOrder = 2,
                    ZIndex = 3,
                    TextXAlignment = Enum.TextXAlignment.Left
                }, innerItem)

                New("UIFlexItem", {FlexMode = Enum.UIFlexMode.Fill}, textLabel)

                -- Construct Tab Content Frame
                local tabContentFrame = New("ScrollingFrame", {
                    Name = tabName .. "Tab",
                    Size = UDim2.new(1, 0, 1, 0),
                    BackgroundTransparency = 1,
                    ScrollBarThickness = 3,
                    ScrollBarImageColor3 = UIFunctions.CurrentAccent,
                    AutomaticCanvasSize = Enum.AutomaticSize.Y,
                    CanvasSize = UDim2.new(0, 0, 0, 0),
                    LayoutOrder = tabIndex
                }, G2L["11"])

                New("UIPadding", {
                    PaddingLeft = UDim.new(0, 12),
                    PaddingRight = UDim.new(0, 12),
                    PaddingTop = UDim.new(0, 8),
                    PaddingBottom = UDim.new(0, 8)
                }, tabContentFrame)

                local searchOffset = searchbar and 42 or 0
                local leftCol, rightCol
                if hasColumns then
                    leftCol = New("ScrollingFrame", {
                        Name = "Left",
                        Size = UDim2.new(0.5, -6, 1, -searchOffset),
                        Position = UDim2.new(0, 0, 0, searchOffset),
                        BackgroundTransparency = 1,
                        ScrollBarThickness = 0,
                        AutomaticCanvasSize = Enum.AutomaticSize.Y,
                        CanvasSize = UDim2.new(0, 0, 0, 0)
                    }, tabContentFrame)

                    New("UIListLayout", {
                        Padding = UDim.new(0, 8),
                        SortOrder = Enum.SortOrder.LayoutOrder,
                        HorizontalAlignment = Enum.HorizontalAlignment.Center
                    }, leftCol)

                    New("UIPadding", {
                        PaddingTop = UDim.new(0, 4),
                        PaddingBottom = UDim.new(0, 4)
                    }, leftCol)

                    rightCol = New("ScrollingFrame", {
                        Name = "Right",
                        Size = UDim2.new(0.5, -6, 1, -searchOffset),
                        Position = UDim2.new(0.5, 6, 0, searchOffset),
                        BackgroundTransparency = 1,
                        ScrollBarThickness = 0,
                        AutomaticCanvasSize = Enum.AutomaticSize.Y,
                        CanvasSize = UDim2.new(0, 0, 0, 0)
                    }, tabContentFrame)

                    New("UIListLayout", {
                        Padding = UDim.new(0, 8),
                        SortOrder = Enum.SortOrder.LayoutOrder,
                        HorizontalAlignment = Enum.HorizontalAlignment.Center
                    }, rightCol)

                    New("UIPadding", {
                        PaddingTop = UDim.new(0, 4),
                        PaddingBottom = UDim.new(0, 4)
                    }, rightCol)

                    tabContentFrame.ScrollBarThickness = 0
                else
                    New("UIListLayout", {
                        Padding = UDim.new(0, 8),
                        HorizontalAlignment = Enum.HorizontalAlignment.Center,
                        SortOrder = Enum.SortOrder.LayoutOrder
                    }, tabContentFrame)
                end

                if searchbar then
                    local searchContainer = New("Frame", {
                        Name = "SearchContainer",
                        Size = UDim2.new(1, 0, 0, 32),
                        BackgroundTransparency = 1,
                        LayoutOrder = -1,
                        ZIndex = 10,
                    }, tabContentFrame)

                    local searchBox = New("TextBox", {
                        Name = "SearchBar",
                        Size = UDim2.new(1, 0, 1, 0),
                        Position = UDim2.new(0, 0, 0, 0),
                        BackgroundColor3 = Color3.fromRGB(30, 30, 30),
                        Text = "",
                        PlaceholderText = "Search in tab...",
                        TextColor3 = Color3.new(1, 1, 1),
                        PlaceholderColor3 = Color3.fromRGB(120, 120, 120),
                        FontFace = fonts.bold,
                        TextSize = 14,
                        TextXAlignment = Enum.TextXAlignment.Left,
                        ClearTextOnFocus = false,
                        LayoutOrder = 0,
                        ZIndex = 10,
                    }, searchContainer)

                    New("UICorner", {CornerRadius = UDim.new(0, 6)}, searchBox)
                    New("UIStroke", {
                        Color = Color3.fromRGB(45, 45, 45),
                        Thickness = 1,
                        Transparency = 0.5
                    }, searchBox)
                    New("UIPadding", {
                        PaddingLeft = UDim.new(0, 30),
                        PaddingRight = UDim.new(0, 10)
                    }, searchBox)

                    New("ImageLabel", {
                        Name = "Icon",
                        Size = UDim2.new(0, 16, 0, 16),
                        Position = UDim2.new(0, 8, 0.5, 0),
                        AnchorPoint = Vector2.new(0, 0.5),
                        Image = "rbxassetid://112780490255100",
                        ImageColor3 = Color3.fromRGB(180, 180, 180),
                        BackgroundTransparency = 1,
                        ZIndex = 11,
                    }, searchContainer)



                    searchBox:GetPropertyChangedSignal("Text"):Connect(function()
                        local query = searchBox.Text:lower()
                        
                        local function filterContainer(container)
                            for _, child in pairs(container:GetChildren()) do
                                if child:IsA("Frame") and child.Name ~= "SearchBar" then
                                    local innerContainer = child:FindFirstChild("container")
                                    if innerContainer then
                                        -- It's a Section
                                        local anyWidgetVisible = false
                                        for _, widget in pairs(innerContainer:GetChildren()) do
                                            if widget:IsA("Frame") or widget:IsA("TextButton") or widget:IsA("TextBox") then
                                                local titleText = ""
                                                local titleLabel = widget:FindFirstChild("label", true) or widget:FindFirstChildOfClass("TextLabel")
                                                if titleLabel and titleLabel:IsA("TextLabel") then
                                                    titleText = titleLabel.Text
                                                end
                                                titleText = titleText:lower()
                                                
                                                if query == "" or titleText:find(query, 1, true) then
                                                    widget.Visible = true
                                                    anyWidgetVisible = true
                                                else
                                                    widget.Visible = false
                                                end
                                            end
                                        end
                                        if query ~= "" and not anyWidgetVisible then
                                            child.Visible = false
                                        else
                                            child.Visible = true
                                        end
                                    else
                                        -- Normal widget placed directly
                                        local titleText = ""
                                        local titleLabel = child:FindFirstChild("label", true) or child:FindFirstChildOfClass("TextLabel")
                                        if titleLabel and titleLabel:IsA("TextLabel") then
                                            titleText = titleLabel.Text
                                        end
                                        titleText = titleText:lower()
                                        
                                        if query == "" or titleText:find(query, 1, true) then
                                            child.Visible = true
                                        else
                                            child.Visible = false
                                        end
                                    end
                                end
                            end
                        end

                        if hasColumns then
                            filterContainer(leftCol)
                            filterContainer(rightCol)
                        else
                            filterContainer(tabContentFrame)
                        end
                    end)
                end

                -- Wire Selection / Navigation jump
                navBtn.MouseButton1Click:Connect(function()
                    G2L["14"]:JumpTo(tabContentFrame)
                    
                    local function updateNavStyle(button, active)
                        local sel = button:FindFirstChild("selector") 
                        if sel then 
                            TweenService:Create(sel, TweenInfo.new(0.35, Enum.EasingStyle.Quart), {
                                BackgroundTransparency = active and 0 or 1, 
                                Size = active and UDim2.new(1, -12, 1, -4) or UDim2.new(1, 0, 1, 0)
                            }):Play() 
                            
                            local selectStroke = sel:FindFirstChild("SelectionStroke") 
                            if selectStroke then 
                                TweenService:Create(selectStroke, TweenInfo.new(0.35), {
                                    Transparency = active and 0 or 1
                                }):Play() 
                            end 
                        end
                        
                        local lbl = button:FindFirstChild("label", true) 
                        if lbl then 
                            TweenService:Create(lbl, TweenInfo.new(0.35, Enum.EasingStyle.Quart), {
                                TextTransparency = active and 0 or 0.5
                            }):Play() 
                        end
                        
                        local hld = button:FindFirstChild("holder", true) 
                        if hld then 
                            local icon = hld:FindFirstChild("icon", true) 
                            if icon then 
                                TweenService:Create(icon, TweenInfo.new(0.35, Enum.EasingStyle.Quart), {
                                    ImageTransparency = active and 0 or 0.5
                                }):Play() 
                            end 
                        end
                    end

                    -- Update states of all sidebar items
                    for _, child in pairs(G2L["4c"]:GetChildren()) do 
                        if child:IsA("ImageButton") then 
                            updateNavStyle(child, child == navBtn) 
                        end 
                    end
                    for _, child in pairs(G2L["19"]:GetChildren()) do 
                        if child:IsA("ImageButton") then 
                            updateNavStyle(child, child == navBtn) 
                        end 
                    end
                end)

                -- Initial style for active first tab
                if tabIndex == 1 then
                    selectorFrame.BackgroundTransparency = 0
                    selectorFrame.Size = UDim2.new(1, -12, 1, -4)
                    stroke.Transparency = 0
                    textLabel.TextTransparency = 0
                    iconImg.ImageTransparency = 0
                end

                local function getWidgetParent(overrideParent, colName)
                    if overrideParent then return overrideParent end
                    if hasColumns then
                        if colName == "Right" then
                            return rightCol
                        else
                            return leftCol
                        end
                    end
                    return tabContentFrame
                end

                local Tab = {
                    tabFrame = tabContentFrame,
                    WidgetCount = 0,
                    SectionCount = 0,
                    getWidgetParent = getWidgetParent
                }

                function Tab:CreateSection(sectionTitle, columnSelection)
                    local title = type(sectionTitle) == "table" and sectionTitle.Title or sectionTitle
                    local colName = type(sectionTitle) == "table" and sectionTitle.Column or columnSelection
                    local droppable = type(sectionTitle) == "table" and sectionTitle.Droppable or false
                    
                    local parent = getWidgetParent(nil, colName)
                    self.SectionCount = self.SectionCount + 1
                    
                    local secFrame = New("Frame", {
                        Size = UDim2.new(1, 0, 0, 32),
                        AutomaticSize = Enum.AutomaticSize.Y,
                        BackgroundColor3 = Color3.fromRGB(30, 30, 30),
                        LayoutOrder = self.SectionCount,
                        ClipsDescendants = false
                    }, parent)

                    New("UICorner", {CornerRadius = UDim.new(0, 6)}, secFrame)
                    
                    New("UIStroke", {
                        Color = Color3.fromRGB(45, 45, 45),
                        Thickness = 1,
                        Transparency = 0.5
                    }, secFrame)

                    local sectionText = New("TextLabel", {
                        Size = UDim2.new(1, -20, 0, 32),
                        Position = UDim2.new(0, 10, 0, 0),
                        Text = " " .. title,
                        TextColor3 = UIFunctions.CurrentAccent,
                        FontFace = fonts.bold,
                        TextSize = 14,
                        TextXAlignment = Enum.TextXAlignment.Left,
                        BackgroundTransparency = 1
                    }, secFrame)

                    local container = New("Frame", {
                        Name = "container",
                        Position = UDim2.new(0, 10, 0, 35),
                        Size = UDim2.new(1, -20, 0, 0),
                        AutomaticSize = Enum.AutomaticSize.Y,
                        BackgroundTransparency = 1,
                        ClipsDescendants = false
                    }, secFrame)

                    New("UIListLayout", {
                        Padding = UDim.new(0, 6),
                        SortOrder = Enum.SortOrder.LayoutOrder
                    }, container)

                    New("UIPadding", {
                        PaddingBottom = UDim.new(0, 8),
                        PaddingTop = UDim.new(0, 4)
                    }, container)

                    if droppable then
                        local arrow = New("TextLabel", {
                            Size = UDim2.new(0, 20, 0, 32),
                            Position = UDim2.new(1, -25, 0, 0),
                            Text = "▼",
                            TextColor3 = Color3.fromRGB(150, 150, 150),
                            FontFace = fonts.bold,
                            TextSize = 10,
                            BackgroundTransparency = 1,
                            ZIndex = 4
                        }, secFrame)

                        local toggleBtn = New("TextButton", {
                            Size = UDim2.new(1, 0, 0, 32),
                            BackgroundTransparency = 1,
                            Text = "",
                            ZIndex = 5
                        }, secFrame)

                        local dropped = true
                        local isAnimating = false
                        toggleBtn.MouseButton1Click:Connect(function()
                            if isAnimating then return end
                            dropped = not dropped
                            isAnimating = true
                            if not dropped then
                                -- COLLAPSE: tween secFrame from full height to header-only (32px)
                                secFrame.ClipsDescendants = true
                                local fullHeight = secFrame.AbsoluteSize.Y
                                secFrame.AutomaticSize = Enum.AutomaticSize.None
                                secFrame.Size = UDim2.new(1, 0, 0, fullHeight)
                                
                                local tween = TweenService:Create(secFrame, TweenInfo.new(0.25, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {
                                    Size = UDim2.new(1, 0, 0, 32)
                                })
                                tween:Play()
                                
                                TweenService:Create(arrow, TweenInfo.new(0.25, Enum.EasingStyle.Quart), {
                                    Rotation = -90
                                }):Play()
                                
                                tween.Completed:Connect(function()
                                    if not dropped then
                                        container.Visible = false
                                    end
                                    isAnimating = false
                                end)
                            else
                                -- EXPAND: tween secFrame from 32px back to full height
                                container.Visible = true
                                secFrame.ClipsDescendants = true
                                
                                -- Temporarily enable AutomaticSize to measure target height
                                secFrame.AutomaticSize = Enum.AutomaticSize.Y
                                RunService.RenderStepped:Wait()
                                local targetHeight = secFrame.AbsoluteSize.Y
                                secFrame.AutomaticSize = Enum.AutomaticSize.None
                                secFrame.Size = UDim2.new(1, 0, 0, 32)
                                
                                local tween = TweenService:Create(secFrame, TweenInfo.new(0.25, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {
                                    Size = UDim2.new(1, 0, 0, targetHeight)
                                })
                                tween:Play()
                                
                                TweenService:Create(arrow, TweenInfo.new(0.25, Enum.EasingStyle.Quart), {
                                    Rotation = 0
                                }):Play()
                                
                                tween.Completed:Connect(function()
                                    if dropped then
                                        secFrame.AutomaticSize = Enum.AutomaticSize.Y
                                        secFrame.ClipsDescendants = false
                                    end
                                    isAnimating = false
                                end)
                            end
                        end)
                    end

                    local Section = {
                        WidgetCount = 0
                    }
                    
                    function Section:CreateToggle(t, d, cb)
                        self.WidgetCount = self.WidgetCount + 1
                        return Tab:CreateToggle(t, d, cb, container, self.WidgetCount)
                    end
                    
                    function Section:CreateSlider(t, min, max, d, cb)
                        self.WidgetCount = self.WidgetCount + 1
                        return Tab:CreateSlider(t, min, max, d, cb, container, self.WidgetCount)
                    end
                    
                    function Section:CreateButton(t, cb)
                        self.WidgetCount = self.WidgetCount + 1
                        return Tab:CreateButton(t, cb, container, self.WidgetCount)
                    end
                    
                    function Section:CreateDropdown(t, options, cb)
                        self.WidgetCount = self.WidgetCount + 1
                        return Tab:CreateDropdown(t, options, cb, container, self.WidgetCount)
                    end
                    
                    function Section:CreateLabel(t, d)
                        self.WidgetCount = self.WidgetCount + 1
                        return Tab:CreateLabel(t, d, container, self.WidgetCount)
                    end
                    
                    function Section:CreateParagraph(text)
                        self.WidgetCount = self.WidgetCount + 1
                        return Tab:CreateParagraph(text, container, self.WidgetCount)
                    end

                    function Section:CreateAvatar(t)
                        self.WidgetCount = self.WidgetCount + 1
                        return Tab:CreateAvatar(t, container, self.WidgetCount)
                    end

                    function Section:CreateInput(t, d, cb)
                        self.WidgetCount = self.WidgetCount + 1
                        return Tab:CreateInput(t, d, cb, container, self.WidgetCount)
                    end

                    function Section:CreateKeybind(t, d, cb)
                        self.WidgetCount = self.WidgetCount + 1
                        return Tab:CreateKeybind(t, d, cb, container, self.WidgetCount)
                    end

                    return Section
                end

                -- Delegate widget creation to external components
                function Tab:CreateToggle(configTitle, defaultState, callback, overrideParent, layoutOrder)
                    return components.toggle(self, UIFunctions, configTitle, defaultState, callback, overrideParent, layoutOrder)
                end

                function Tab:CreateSlider(configTitle, minVal, maxVal, defaultState, callback, overrideParent, layoutOrder)
                    return components.slider(self, UIFunctions, configTitle, minVal, maxVal, defaultState, callback, overrideParent, layoutOrder)
                end

                function Tab:CreateButton(configTitle, callback, overrideParent, layoutOrder)
                    return components.button(self, UIFunctions, configTitle, callback, overrideParent, layoutOrder)
                end

                function Tab:CreateDropdown(configTitle, configOptions, callback, overrideParent, layoutOrder)
                    return components.dropdown(self, UIFunctions, configTitle, configOptions, callback, overrideParent, layoutOrder)
                end

                function Tab:CreateLabel(configTitle, defaultState, overrideParent, layoutOrder)
                    return components.status(self, UIFunctions, configTitle, defaultState, overrideParent, layoutOrder)
                end

                function Tab:CreateParagraph(configText, overrideParent, layoutOrder)
                    return components.paragraph(self, UIFunctions, configText, overrideParent, layoutOrder)
                end

                function Tab:CreateAvatar(configTitle, overrideParent, layoutOrder)
                    return components.avatar(self, UIFunctions, configTitle, overrideParent, layoutOrder)
                end

                function Tab:CreateInput(configTitle, defaultKey, callback, overrideParent, layoutOrder)
                    return components.input(self, UIFunctions, configTitle, defaultKey, callback, overrideParent, layoutOrder)
                end

                function Tab:CreateKeybind(configTitle, defaultKey, callback, overrideParent, layoutOrder)
                    return components.uikeybind(self, UIFunctions, configTitle, defaultKey, callback, overrideParent, layoutOrder)
                end

                return Tab
            end

            return Window
        end

        return UIFunctions
