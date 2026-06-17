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

    -- Keybind Toggle (RightControl)
    UserInputService.InputBegan:Connect(function(input, gpe)
        if not gpe and input.KeyCode == Enum.KeyCode.RightControl then
            animateToggle()
            return
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

    -- Sidebar Toggle Connection
    if G2L["80"] then
        G2L["80"].MouseButton1Click:Connect(function()
            sidebarOpen = not sidebarOpen
            TweenService:Create(G2L["16"], TweenInfo.new(0.35, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {Size = sidebarOpen and UDim2.new(0, 220, 1, 0) or UDim2.new(0, 0, 1, 0)}):Play()
            TweenService:Create(G2L["11"], TweenInfo.new(0.35, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {Size = sidebarOpen and UDim2.new(1, -235, 1, 0) or UDim2.new(1, 0, 1, 0)}):Play()
        end)
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
                logoText.Text = '<font color="rgb(248, 191, 212)">Goon</font>Hub'
                logoText.Visible = true
            end

            if miniButtons:FindFirstChild("close") then 
                miniButtons.close.MouseButton1Click:Connect(closeUI) 
            end
            if miniButtons:FindFirstChild("maximize") then 
                miniButtons.maximize.MouseButton1Click:Connect(toggleMinimize) 
            end
            if miniButtons:FindFirstChild("sidebar_toggle") then
                miniButtons.sidebar_toggle.MouseButton1Click:Connect(function()
                    sidebarOpen = not sidebarOpen
                    TweenService:Create(G2L["16"], TweenInfo.new(0.35, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {Size = sidebarOpen and UDim2.new(0, 220, 1, 0) or UDim2.new(0, 0, 1, 0)}):Play()
                    TweenService:Create(G2L["11"], TweenInfo.new(0.35, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {Size = sidebarOpen and UDim2.new(1, -235, 1, 0) or UDim2.new(1, 0, 1, 0)}):Play()
                end)
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
                if G2L["time_text"] then
                    G2L["time_text"].Text = os.date("%I:%M %p")
                end
            end)
        end
    end)
end

return UIFunctions


