-- Avatar Component (3D Viewport character viewer with drag rotation)
return function(Tab, mainfunctions, configTitle, overrideParent, layoutOrder)
    local TweenService = game:GetService("TweenService")
    local UserInputService = game:GetService("UserInputService")
    local Players = game:GetService("Players")
    local New = mainfunctions.New
    local fonts = mainfunctions.GetFonts()

    local localPlayer = Players.LocalPlayer
    local title = type(configTitle) == "table" and configTitle.Title or (type(configTitle) == "string" and configTitle or nil)
    local colName = type(configTitle) == "table" and configTitle.Column or nil
    
    local parent = Tab.getWidgetParent(overrideParent, colName)
    Tab.WidgetCount = Tab.WidgetCount + 1
    local lOrder = layoutOrder or Tab.WidgetCount

    local hasTitle = (title ~= nil)
    
    local widgetFrame = New("Frame", {
        Size = UDim2.new(1, 0, 0, hasTitle and 280 or 240),
        BackgroundColor3 = Color3.fromRGB(30, 30, 30),
        LayoutOrder = lOrder
    }, parent)
    
    New("UICorner", {CornerRadius = UDim.new(0, 6)}, widgetFrame)
    
    New("UIStroke", {
        Color = Color3.fromRGB(45, 45, 45),
        Thickness = 1,
        Transparency = 0.5
    }, widgetFrame)

    if hasTitle then
        New("TextLabel", {
            Size = UDim2.new(1, -20, 0, 24),
            Position = UDim2.new(0, 10, 0, 4),
            Text = title,
            TextColor3 = Color3.new(1, 1, 1),
            BackgroundTransparency = 1, 
            TextXAlignment = Enum.TextXAlignment.Left,
            FontFace = fonts.bold,
            TextSize = 14,
            TextTruncate = Enum.TextTruncate.AtEnd
        }, widgetFrame)
    end

    -- ViewportFrame
    local viewportFrame = New("ViewportFrame", {
        Size = UDim2.new(0, 160, 0, 220),
        Position = UDim2.new(0.5, 0, 0.5, hasTitle and 10 or 0),
        AnchorPoint = Vector2.new(0.5, 0.5),
        BackgroundTransparency = 1,
        ZIndex = 2
    }, widgetFrame)

    local camera = Instance.new("Camera")
    camera.FieldOfView = 50
    viewportFrame.CurrentCamera = camera
    camera.Parent = viewportFrame

    local charClone
    local yaw = 180    -- Horizontal rotation angle (degrees) - starts facing the camera
    local pitch = 0    -- Vertical rotation angle (degrees)
    local distance = 8.0 -- Camera distance (zoomed out slightly to fit feet)

    local function updateCamera()
        if not camera then return end
        local center = Vector3.new(0, 0.1, 0) -- Look at character center
        local rotationCFrame = CFrame.Angles(0, math.rad(yaw), 0) * CFrame.Angles(math.rad(pitch), 0, 0)
        camera.CFrame = CFrame.new(center) * rotationCFrame * CFrame.new(0, 0, distance)
        camera.Focus = CFrame.new(center)
    end

    local function setupCharacter()
        if charClone then charClone:Destroy() end
        local originalChar = localPlayer.Character
        if not originalChar then return end

        local wasArchivable = originalChar.Archivable
        originalChar.Archivable = true
        charClone = originalChar:Clone()
        originalChar.Archivable = wasArchivable

        -- Clean up non-visual scripts / sounds
        for _, child in ipairs(charClone:GetDescendants()) do
            if child:IsA("LuaSourceContainer") or child:IsA("Sound") or child:IsA("ForceField") then
                child:Destroy()
            end
        end

        -- Anchor parts and disable collision
        for _, part in ipairs(charClone:GetDescendants()) do
            if part:IsA("BasePart") then
                part.Anchored = true
                part.CanCollide = false
            end
        end

        charClone:SetPrimaryPartCFrame(CFrame.new(0, 0, 0))
        charClone.Parent = viewportFrame
    end

    -- Initial load
    task.spawn(function()
        setupCharacter()
        updateCamera()
    end)

    -- Listen for player respawns to update the character model
    local charAddedConn
    charAddedConn = localPlayer.CharacterAdded:Connect(function()
        task.wait(0.5) -- Wait briefly for parts/accessories to instantiate
        setupCharacter()
        updateCamera()
    end)

    -- Drag to Rotate Logic
    local dragging = false
    local lastMousePos

    local inputOverlay = New("TextButton", {
        Size = UDim2.new(1, 0, 1, 0),
        BackgroundTransparency = 1,
        Text = "",
        ZIndex = 10
    }, viewportFrame)

    inputOverlay.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            lastMousePos = input.Position
        end
    end)

    local dragConn
    dragConn = UserInputService.InputChanged:Connect(function(input)
        if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
            if lastMousePos then
                local delta = input.Position - lastMousePos
                yaw = (yaw - delta.X * 0.6) % 360
                pitch = math.clamp(pitch - delta.Y * 0.6, -70, 70)
                updateCamera()
            end
            lastMousePos = input.Position
        end
    end)

    local endConn
    endConn = UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = false
            lastMousePos = nil
        end
    end)

    widgetFrame.Destroying:Connect(function()
        if charAddedConn then charAddedConn:Disconnect() end
        if dragConn then dragConn:Disconnect() end
        if endConn then endConn:Disconnect() end
        if charClone then charClone:Destroy() end
    end)

    return {
        Refresh = function()
            setupCharacter()
            updateCamera()
        end
    }
end
