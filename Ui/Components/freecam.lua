return function(mainfunctions, components)
    local New = mainfunctions.New
    local fonts = mainfunctions.GetFonts()
    local Players = game:GetService("Players")
    local LocalPlayer = Players.LocalPlayer
    local TweenService = game:GetService("TweenService")
    local RunService = game:GetService("RunService")
    local ContextActionService = game:GetService("ContextActionService")
    local UserInputService = game:GetService("UserInputService")
    local StarterGui = game:GetService("StarterGui")
    local Workspace = game:GetService("Workspace")
    local CollectionService = game:GetService("CollectionService")
    local targetParent = (gethui and gethui()) or game:GetService("CoreGui") or (LocalPlayer and LocalPlayer:WaitForChild("PlayerGui"))

    local pi = math.pi
    local abs = math.abs
    local clamp = math.clamp
    local exp = math.exp
    local rad = math.rad
    local sign = math.sign
    local sqrt = math.sqrt
    local tan = math.tan

    return function(onClose)
        local screenGui = New("ScreenGui", {
            Name = "Freecam",
            ZIndexBehavior = Enum.ZIndexBehavior.Sibling
        }, targetParent)

        local container = New("ImageLabel", {
            BorderSizePixel = 0,
            SliceCenter = Rect.new(300, 300, 300, 300),
            SliceScale = 0.5,
            ScaleType = Enum.ScaleType.Slice,
            BackgroundColor3 = Color3.fromRGB(255, 255, 255),
            ImageColor3 = Color3.fromRGB(0, 0, 0),
            AnchorPoint = Vector2.new(0.5, 0.5),
            Image = "rbxassetid://72548733587158",
            Size = UDim2.new(0, 400, 0, 400),
            BorderColor3 = Color3.fromRGB(0, 0, 0),
            BackgroundTransparency = 1,
            Selectable = true,
            Name = "fly",
            Position = UDim2.new(0.5, 0, 0.5, 0)
        }, screenGui)

        local containerScale = New("UIScale", {Name = "scale"}, container)

        New("UIPadding", {
            PaddingTop = UDim.new(0, 75),
            PaddingRight = UDim.new(0, 75),
            Name = "padding",
            PaddingLeft = UDim.new(0, 75),
            PaddingBottom = UDim.new(0, 75)
        }, container)

        local frame = New("ImageButton", {
            SliceScale = 0.08,
            BorderSizePixel = 0,
            SliceCenter = Rect.new(512, 512, 512, 512),
            ScaleType = Enum.ScaleType.Slice,
            Modal = true,
            AutoButtonColor = false,
            BackgroundTransparency = 1,
            BackgroundColor3 = Color3.fromRGB(255, 255, 255),
            ImageColor3 = Color3.fromRGB(35, 35, 35),
            AnchorPoint = Vector2.new(0.5, 0.5),
            Image = "rbxassetid://125088425775676",
            Size = UDim2.new(1, 0, 1, 0),
            BorderColor3 = Color3.fromRGB(0, 0, 0),
            Name = "frame",
            Position = UDim2.new(0.5, 0, 0.5, 0)
        }, container)

        local content = New("Frame", {
            BorderSizePixel = 0,
            BackgroundColor3 = Color3.fromRGB(255, 255, 255),
            AnchorPoint = Vector2.new(0.5, 0.5),
            ClipsDescendants = true,
            Size = UDim2.new(1, 0, 1, 0),
            Position = UDim2.new(0.5, 0, 0.5, 0),
            BorderColor3 = Color3.fromRGB(0, 0, 0),
            Name = "content",
            BackgroundTransparency = 1
        }, frame)

        New("UICorner", {Name = "corner", CornerRadius = UDim.new(0, 26)}, content)

        New("UIPadding", {
            PaddingTop = UDim.new(0, 10),
            PaddingRight = UDim.new(0, 10),
            Name = "padding",
            PaddingLeft = UDim.new(0, 10)
        }, content)

        -- LeafletControls
        local controls = New("Frame", {
            ZIndex = 99999,
            BorderSizePixel = 0,
            BackgroundColor3 = Color3.fromRGB(255, 255, 255),
            AnchorPoint = Vector2.new(0.5, 0.5),
            Size = UDim2.new(1, 0, 1, 0),
            Position = UDim2.new(0.5, 0, 0.5, 0),
            BorderColor3 = Color3.fromRGB(0, 0, 0),
            Name = "LeafletControls",
            BackgroundTransparency = 1
        }, frame)

        -- Top bar
        local topBar = New("Frame", {
            BorderSizePixel = 0,
            BackgroundColor3 = Color3.fromRGB(255, 255, 255),
            AnchorPoint = Vector2.new(0.5, 0),
            Size = UDim2.new(1, 0, 0, 50),
            Position = UDim2.new(0.5, 0, 0, 0),
            BorderColor3 = Color3.fromRGB(0, 0, 0),
            Name = "Top",
            BackgroundTransparency = 1
        }, controls)

        New("UIPadding", {
            PaddingTop = UDim.new(0, 5),
            PaddingRight = UDim.new(0, 5),
            Name = "padding",
            PaddingLeft = UDim.new(0, 10)
        }, topBar)

        New("UIListLayout", {
            HorizontalAlignment = Enum.HorizontalAlignment.Right,
            Padding = UDim.new(0, -5),
            SortOrder = Enum.SortOrder.LayoutOrder,
            Name = "list",
            FillDirection = Enum.FillDirection.Horizontal
        }, topBar)

        -- Space flex
        local spaceFlex = New("Frame", {
            BorderSizePixel = 0,
            BackgroundColor3 = Color3.fromRGB(255, 255, 255),
            BorderColor3 = Color3.fromRGB(0, 0, 0),
            Name = "space",
            LayoutOrder = 1,
            BackgroundTransparency = 1
        }, topBar)

        New("UIFlexItem", {FlexMode = Enum.UIFlexMode.Fill}, spaceFlex)

        -- Title
        local titleHolder = New("ImageLabel", {
            BorderSizePixel = 0,
            SliceCenter = Rect.new(300, 300, 300, 300),
            SliceScale = 0.2,
            ScaleType = Enum.ScaleType.Slice,
            BackgroundColor3 = Color3.fromRGB(255, 255, 255),
            ImageTransparency = 0.5,
            AutomaticSize = Enum.AutomaticSize.X,
            ImageColor3 = Color3.fromRGB(0, 0, 0),
            AnchorPoint = Vector2.new(1, 0),
            Image = "rbxassetid://72548733587158",
            Size = UDim2.new(0, 40, 0, 40),
            BorderColor3 = Color3.fromRGB(0, 0, 0),
            BackgroundTransparency = 1,
            Name = "Title",
            Position = UDim2.new(1, 0, 0, 0)
        }, topBar)

        New("UIListLayout", {
            HorizontalAlignment = Enum.HorizontalAlignment.Center,
            Padding = UDim.new(0, 10),
            VerticalAlignment = Enum.VerticalAlignment.Center,
            SortOrder = Enum.SortOrder.LayoutOrder,
            Name = "list",
            FillDirection = Enum.FillDirection.Horizontal
        }, titleHolder)

        New("UIPadding", {
            PaddingRight = UDim.new(0, 5),
            Name = "padding",
            PaddingLeft = UDim.new(0, 5)
        }, titleHolder)

        local titleBtn = New("TextButton", {
            BorderSizePixel = 0,
            TextSize = 12,
            AutoButtonColor = false,
            TextColor3 = Color3.fromRGB(255, 255, 255),
            BackgroundColor3 = Color3.fromRGB(43, 43, 43),
            FontFace = Font.new("rbxassetid://12187365364", Enum.FontWeight.Regular, Enum.FontStyle.Normal),
            Selectable = false,
            AnchorPoint = Vector2.new(0.5, 0.5),
            AutomaticSize = Enum.AutomaticSize.X,
            Size = UDim2.new(0, 24, 0, 24),
            LayoutOrder = 1,
            BorderColor3 = Color3.fromRGB(0, 0, 0),
            Text = "Freecam",
            Name = "Container",
            Position = UDim2.new(0.5, 0, 0.5, 0)
        }, titleHolder)

        New("UICorner", {Name = "corner", CornerRadius = UDim.new(1, 0)}, titleBtn)
        New("UIPadding", {
            PaddingRight = UDim.new(0, 12),
            Name = "padding",
            PaddingLeft = UDim.new(0, 12)
        }, titleBtn)

        local titleStroke = New("UIStroke", {
            Color = Color3.fromRGB(186, 186, 186),
            ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
            Name = "stroke"
        }, titleBtn)

        New("UIGradient", {
            Rotation = 76,
            Name = "gradient",
            Color = ColorSequence.new{
                ColorSequenceKeypoint.new(0, Color3.fromRGB(74, 74, 74)),
                ColorSequenceKeypoint.new(0.488, Color3.fromRGB(27, 27, 27)),
                ColorSequenceKeypoint.new(1, Color3.fromRGB(74, 74, 74))
            }
        }, titleStroke)

        -- Close button (top right)
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

        local closeIcon = New("ImageLabel", {
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

        local closeStroke = New("UIStroke", {
            Color = Color3.fromRGB(255, 255, 255),
            ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
            Name = "stroke"
        }, closeBtn)

        New("UIGradient", {
            Rotation = 38,
            Name = "gradient",
            Color = ColorSequence.new{
                ColorSequenceKeypoint.new(0, Color3.fromRGB(74, 74, 74)),
                ColorSequenceKeypoint.new(0.488, Color3.fromRGB(27, 27, 27)),
                ColorSequenceKeypoint.new(1, Color3.fromRGB(74, 74, 74))
            }
        }, closeStroke)

        -- Drag handle
        local dragActive = false
        local dragStart = Vector2.new()
        local dragPos = UDim2.new()
        topBar.InputBegan:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                dragActive = true
                dragStart = input.Position
                dragPos = UDim2.new(container.Position.X.Scale, container.Position.X.Offset, container.Position.Y.Scale, container.Position.Y.Offset)
            end
        end)
        topBar.InputChanged:Connect(function(input)
            if not dragActive then return end
            if input.UserInputType ~= Enum.UserInputType.MouseMovement and input.UserInputType ~= Enum.UserInputType.Touch then return end
            local delta = input.Position - dragStart
            container.Position = UDim2.new(dragPos.X.Scale, dragPos.X.Offset + delta.X, dragPos.Y.Scale, dragPos.Y.Offset + delta.Y)
        end)
        topBar.InputEnded:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                dragActive = false
            end
        end)

        -- Bottom resize handle
        local bottomBar = New("Frame", {
            BorderSizePixel = 0,
            BackgroundColor3 = Color3.fromRGB(255, 255, 255),
            AnchorPoint = Vector2.new(1, 1),
            Size = UDim2.new(0, 50, 0, 50),
            Position = UDim2.new(1, 0, 1, 0),
            BorderColor3 = Color3.fromRGB(0, 0, 0),
            Name = "Bottom",
            BackgroundTransparency = 1
        }, controls)

        New("UIListLayout", {
            HorizontalFlex = Enum.UIFlexAlignment.Fill,
            SortOrder = Enum.SortOrder.LayoutOrder,
            Name = "list",
            FillDirection = Enum.FillDirection.Horizontal
        }, bottomBar)

        -- Power button (center)
        local powerHolder = New("Frame", {
            Active = true,
            BorderSizePixel = 0,
            BackgroundColor3 = Color3.fromRGB(255, 255, 255),
            Selectable = true,
            AnchorPoint = Vector2.new(0.5, 0.5),
            Size = UDim2.new(0, 100, 0, 100),
            Position = UDim2.new(0.5, 0, 0.5, 0),
            BorderColor3 = Color3.fromRGB(0, 0, 0),
            Name = "Power",
            BackgroundTransparency = 1
        }, content)

        local powerScale = New("UIScale", {Name = "scale"}, powerHolder)

        local shadow = New("ImageLabel", {
            ZIndex = 0,
            BorderSizePixel = 0,
            ScaleType = Enum.ScaleType.Fit,
            BackgroundColor3 = Color3.fromRGB(255, 255, 255),
            ImageColor3 = Color3.fromRGB(0, 0, 0),
            AnchorPoint = Vector2.new(0.5, 0.5),
            Image = "rbxassetid://88592542618493",
            Size = UDim2.new(1, 0, 1, 0),
            BorderColor3 = Color3.fromRGB(0, 0, 0),
            BackgroundTransparency = 1,
            Name = "Shadow",
            Position = UDim2.new(0.5, 0, 0.5, 0)
        }, powerHolder)

        local shadowScale = New("UIScale", {Name = "scale"}, shadow)
        shadowScale.Scale = 1.5

        local powerBtn = New("ImageButton", {
            BorderSizePixel = 0,
            AutoButtonColor = false,
            BackgroundColor3 = Color3.fromRGB(43, 43, 43),
            Size = UDim2.new(1, 0, 1, 0),
            BorderColor3 = Color3.fromRGB(0, 0, 0),
            Name = "Button"
        }, powerHolder)

        New("UICorner", {Name = "corner", CornerRadius = UDim.new(1, 0)}, powerBtn)

        local powerStroke = New("UIStroke", {
            Color = Color3.fromRGB(186, 186, 186),
            ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
            Name = "stroke"
        }, powerBtn)

        New("UIGradient", {
            Rotation = 76,
            Name = "gradient",
            Color = ColorSequence.new{
                ColorSequenceKeypoint.new(0, Color3.fromRGB(74, 74, 74)),
                ColorSequenceKeypoint.new(0.488, Color3.fromRGB(27, 27, 27)),
                ColorSequenceKeypoint.new(1, Color3.fromRGB(74, 74, 74))
            }
        }, powerStroke)

        local powerIcon = New("ImageLabel", {
            BorderSizePixel = 0,
            ScaleType = Enum.ScaleType.Fit,
            BackgroundColor3 = Color3.fromRGB(255, 255, 255),
            AnchorPoint = Vector2.new(0.5, 0.5),
            Image = "rbxassetid://11433568090",
            Size = UDim2.new(0, 40, 0, 40),
            BorderColor3 = Color3.fromRGB(0, 0, 0),
            BackgroundTransparency = 1,
            Name = "Icon",
            Position = UDim2.new(0.5, 0, 0.5, 0)
        }, powerBtn)

        -- Freecam script (embedded)
        local Camera = Workspace.CurrentCamera
        Workspace:GetPropertyChangedSignal("CurrentCamera"):Connect(function()
            local newCamera = Workspace.CurrentCamera
            if newCamera then
                Camera = newCamera
            end
        end)

        local Spring = {}
        Spring.__index = Spring
        function Spring.new(freq, pos)
            local self = setmetatable({}, Spring)
            self.f = freq
            self.p = pos
            self.v = pos * 0
            return self
        end
        function Spring:Update(dt, goal)
            local f = self.f * 2 * pi
            local p0 = self.p
            local v0 = self.v
            local offset = goal - p0
            local decay = exp(-f * dt)
            local p1 = goal + (v0 * dt - offset * (f * dt + 1)) * decay
            local v1 = (f * dt * (offset * f - v0) + v0) * decay
            self.p = p1
            self.v = v1
            return p1
        end
        function Spring:Reset(pos)
            self.p = pos
            self.v = pos * 0
        end

        local freecamEnabled = false
        local rightClickHeld = false
        local cameraPos = Vector3.new()
        local cameraRot = Vector2.new()
        local cameraFov = 0
        local velSpring = Spring.new(1.5, Vector3.new())
        local panSpring = Spring.new(1.0, Vector2.new())
        local fovSpring = Spring.new(4.0, 0)

        local NAV_GAIN = Vector3.new(1, 1, 1) * 64
        local PAN_GAIN = Vector2.new(0.75, 1) * 8
        local FOV_GAIN = 300
        local PITCH_LIMIT = rad(90)

        local Input = {}
        do
            local thumbstickCurve
            do
                local K_CURVATURE = 2.0
                local K_DEADZONE = 0.15
                local function fCurve(x) return (exp(K_CURVATURE * x) - 1) / (exp(K_CURVATURE) - 1) end
                local function fDeadzone(x) return fCurve((x - K_DEADZONE) / (1 - K_DEADZONE)) end
                function thumbstickCurve(x) return sign(x) * clamp(fDeadzone(abs(x)), 0, 1) end
            end

            local gamepad = {ButtonX = 0, ButtonY = 0, DPadDown = 0, DPadUp = 0, ButtonL2 = 0, ButtonR2 = 0, Thumbstick1 = Vector2.new(), Thumbstick2 = Vector2.new()}
            local keyboard = {W = 0, A = 0, S = 0, D = 0, E = 0, Q = 0, U = 0, H = 0, J = 0, K = 0, I = 0, Y = 0, Up = 0, Down = 0, LeftShift = 0, RightShift = 0}
            local mouse = {Delta = Vector2.new(), MouseWheel = 0}
            local NAV_GAMEPAD_SPEED = Vector3.new(1, 1, 1)
            local NAV_KEYBOARD_SPEED = Vector3.new(1, 1, 1)
            local PAN_MOUSE_SPEED = Vector2.new(1, 1) * (pi / 64)
            local PAN_GAMEPAD_SPEED = Vector2.new(1, 1) * (pi / 8)
            local FOV_WHEEL_SPEED = 1.0
            local FOV_GAMEPAD_SPEED = 0.25
            local NAV_ADJ_SPEED = 0.75
            local NAV_SHIFT_MUL = 0.25
            local navSpeed = 1

            function Input.Vel(dt)
                navSpeed = clamp(navSpeed + dt * (keyboard.Up - keyboard.Down) * NAV_ADJ_SPEED, 0.01, 4)
                local kGamepad = Vector3.new(
                    thumbstickCurve(gamepad.Thumbstick1.X),
                    thumbstickCurve(gamepad.ButtonR2) - thumbstickCurve(gamepad.ButtonL2),
                    thumbstickCurve(-gamepad.Thumbstick1.Y)
                ) * NAV_GAMEPAD_SPEED
                local kKeyboard = Vector3.new(
                    keyboard.D - keyboard.A + keyboard.K - keyboard.H,
                    keyboard.E - keyboard.Q + keyboard.I - keyboard.Y,
                    keyboard.S - keyboard.W + keyboard.J - keyboard.U
                ) * NAV_KEYBOARD_SPEED
                local shift = UserInputService:IsKeyDown(Enum.KeyCode.LeftShift) or UserInputService:IsKeyDown(Enum.KeyCode.RightShift)
                return (kGamepad + kKeyboard) * (navSpeed * (shift and NAV_SHIFT_MUL or 1))
            end

            function Input.Pan(dt)
                local kGamepad = Vector2.new(thumbstickCurve(gamepad.Thumbstick2.Y), thumbstickCurve(-gamepad.Thumbstick2.X)) * PAN_GAMEPAD_SPEED
                local kMouse = Vector2.new()
                if rightClickHeld then
                    kMouse = mouse.Delta * PAN_MOUSE_SPEED
                end
                mouse.Delta = Vector2.new()
                return kGamepad + kMouse
            end

            function Input.Fov(dt)
                local kGamepad = (gamepad.ButtonX - gamepad.ButtonY) * FOV_GAMEPAD_SPEED
                local kMouse = mouse.MouseWheel * FOV_WHEEL_SPEED
                mouse.MouseWheel = 0
                return kGamepad + kMouse
            end

            local function Keypress(action, state, input)
                keyboard[input.KeyCode.Name] = state == Enum.UserInputState.Begin and 1 or 0
                return Enum.ContextActionResult.Sink
            end
            local function GpButton(action, state, input)
                gamepad[input.KeyCode.Name] = state == Enum.UserInputState.Begin and 1 or 0
                return Enum.ContextActionResult.Sink
            end
            local function MousePan(action, state, input)
                local delta = input.Delta
                mouse.Delta = Vector2.new(-delta.y, -delta.x)
                if rightClickHeld then
                    return Enum.ContextActionResult.Sink
                end
                return Enum.ContextActionResult.Pass
            end
            local function Thumb(action, state, input)
                gamepad[input.KeyCode.Name] = input.Position
                return Enum.ContextActionResult.Sink
            end
            local function Trigger(action, state, input)
                gamepad[input.KeyCode.Name] = input.Position.z
                return Enum.ContextActionResult.Sink
            end
            local function MouseWheel(action, state, input)
                mouse[input.UserInputType.Name] = -input.Position.z
                return Enum.ContextActionResult.Sink
            end

            local function Zero(t)
                for k, v in pairs(t) do
                    t[k] = v * 0
                end
            end

            function Input.StartCapture()
                ContextActionService:BindActionAtPriority("FreecamKeyboard", Keypress, false, Enum.ContextActionPriority.High.Value,
                    Enum.KeyCode.W, Enum.KeyCode.U, Enum.KeyCode.A, Enum.KeyCode.H,
                    Enum.KeyCode.S, Enum.KeyCode.J, Enum.KeyCode.D, Enum.KeyCode.K,
                    Enum.KeyCode.E, Enum.KeyCode.I, Enum.KeyCode.Q, Enum.KeyCode.Y,
                    Enum.KeyCode.Up, Enum.KeyCode.Down)
                ContextActionService:BindActionAtPriority("FreecamMousePan", MousePan, false, Enum.ContextActionPriority.High.Value, Enum.UserInputType.MouseMovement)
                ContextActionService:BindActionAtPriority("FreecamMouseWheel", MouseWheel, false, Enum.ContextActionPriority.High.Value, Enum.UserInputType.MouseWheel)
                ContextActionService:BindActionAtPriority("FreecamGamepadButton", GpButton, false, Enum.ContextActionPriority.High.Value, Enum.KeyCode.ButtonX, Enum.KeyCode.ButtonY)
                ContextActionService:BindActionAtPriority("FreecamGamepadTrigger", Trigger, false, Enum.ContextActionPriority.High.Value, Enum.KeyCode.ButtonR2, Enum.KeyCode.ButtonL2)
                ContextActionService:BindActionAtPriority("FreecamGamepadThumbstick", Thumb, false, Enum.ContextActionPriority.High.Value, Enum.KeyCode.Thumbstick1, Enum.KeyCode.Thumbstick2)
            end

            function Input.StopCapture()
                navSpeed = 1
                Zero(gamepad)
                Zero(keyboard)
                Zero(mouse)
                ContextActionService:UnbindAction("FreecamKeyboard")
                ContextActionService:UnbindAction("FreecamMousePan")
                ContextActionService:UnbindAction("FreecamMouseWheel")
                ContextActionService:UnbindAction("FreecamGamepadButton")
                ContextActionService:UnbindAction("FreecamGamepadTrigger")
                ContextActionService:UnbindAction("FreecamGamepadThumbstick")
            end
        end

        local function StepFreecam(dt)
            local vel = velSpring:Update(dt, Input.Vel(dt))
            local pan = panSpring:Update(dt, Input.Pan(dt))
            local fov = fovSpring:Update(dt, Input.Fov(dt))
            local zoomFactor = sqrt(tan(rad(70 / 2)) / tan(rad(cameraFov / 2)))
            cameraFov = clamp(cameraFov + fov * FOV_GAIN * (dt / zoomFactor), 1, 120)
            cameraRot = cameraRot + pan * PAN_GAIN * (dt / zoomFactor)
            cameraRot = Vector2.new(clamp(cameraRot.x, -PITCH_LIMIT, PITCH_LIMIT), cameraRot.y % (2 * pi))
            local cameraCFrame = CFrame.new(cameraPos) * CFrame.fromOrientation(cameraRot.x, cameraRot.y, 0) * CFrame.new(vel * NAV_GAIN * dt)
            cameraPos = cameraCFrame.p
            Camera.CFrame = cameraCFrame
            Camera.Focus = cameraCFrame
            Camera.FieldOfView = cameraFov
        end

        local PlayerState = {}
        do
            local mouseBehavior, mouseIconEnabled, cameraType, cameraFocus, cameraCFrame, cameraFieldOfView
            local screenGuis = {}
            local coreGuis = {Backpack = true, Chat = true, Health = true, PlayerList = true}
            local setCores = {BadgesNotificationsActive = true, PointsNotificationsActive = true}

            function PlayerState.Push()
                for name in pairs(coreGuis) do
                    coreGuis[name] = StarterGui:GetCoreGuiEnabled(Enum.CoreGuiType[name])
                    StarterGui:SetCoreGuiEnabled(Enum.CoreGuiType[name], false)
                end
                for name in pairs(setCores) do
                    setCores[name] = StarterGui:GetCore(name)
                    StarterGui:SetCore(name, false)
                end
                local playergui = LocalPlayer:FindFirstChildOfClass("PlayerGui")
                if playergui then
                    for _, gui in pairs(playergui:GetChildren()) do
                        if gui:IsA("ScreenGui") and gui.Enabled then
                            screenGuis[#screenGuis + 1] = gui
                            gui.Enabled = false
                        end
                    end
                end
                cameraFieldOfView = Camera.FieldOfView
                Camera.FieldOfView = 70
                cameraType = Camera.CameraType
                Camera.CameraType = Enum.CameraType.Custom
                cameraCFrame = Camera.CFrame
                cameraFocus = Camera.Focus
                mouseIconEnabled = UserInputService.MouseIconEnabled
                mouseBehavior = UserInputService.MouseBehavior
            end

            function PlayerState.Pop()
                for name, isEnabled in pairs(coreGuis) do
                    StarterGui:SetCoreGuiEnabled(Enum.CoreGuiType[name], isEnabled)
                end
                for name, isEnabled in pairs(setCores) do
                    StarterGui:SetCore(name, isEnabled)
                end
                for _, gui in pairs(screenGuis) do
                    if gui.Parent then
                        gui.Enabled = true
                    end
                end
                Camera.FieldOfView = cameraFieldOfView or 70
                Camera.CameraType = cameraType or Enum.CameraType.Custom
                if cameraCFrame then
                    Camera.CFrame = cameraCFrame
                    Camera.Focus = cameraFocus
                end
                if mouseIconEnabled ~= nil then UserInputService.MouseIconEnabled = mouseIconEnabled end
                if mouseBehavior then UserInputService.MouseBehavior = mouseBehavior end
            end
        end

        local rcBeganConn = UserInputService.InputBegan:Connect(function(input, gp)
            if gp then return end
            if input.UserInputType == Enum.UserInputType.MouseButton2 and freecamEnabled then
                rightClickHeld = true
                UserInputService.MouseIconEnabled = false
                UserInputService.MouseBehavior = Enum.MouseBehavior.LockCenter
            end
        end)
        local rcEndedConn = UserInputService.InputEnded:Connect(function(input, gp)
            if gp then return end
            if input.UserInputType == Enum.UserInputType.MouseButton2 then
                rightClickHeld = false
                if freecamEnabled then
                    UserInputService.MouseIconEnabled = true
                    UserInputService.MouseBehavior = Enum.MouseBehavior.Default
                end
            end
        end)

        local inactiveStatus = New("Frame", {
            BorderSizePixel = 0,
            BackgroundColor3 = Color3.fromRGB(255, 255, 255),
            AnchorPoint = Vector2.new(0, 1),
            Size = UDim2.new(1, 0, 0, 20),
            Position = UDim2.new(0, 0, 1, -30),
            BorderColor3 = Color3.fromRGB(0, 0, 0),
            Name = "InactiveStatus",
            BackgroundTransparency = 1
        }, content)

        New("UIListLayout", {
            HorizontalAlignment = Enum.HorizontalAlignment.Center,
            Padding = UDim.new(0, 5),
            VerticalAlignment = Enum.VerticalAlignment.Center,
            SortOrder = Enum.SortOrder.LayoutOrder,
            Name = "list",
            FillDirection = Enum.FillDirection.Horizontal
        }, inactiveStatus)

        New("UIPadding", {Name = "padding", PaddingLeft = UDim.new(0, 5)}, inactiveStatus)

        New("ImageLabel", {
            ZIndex = 20,
            BorderSizePixel = 0,
            ScaleType = Enum.ScaleType.Fit,
            BackgroundColor3 = Color3.fromRGB(255, 255, 255),
            ImageColor3 = Color3.fromRGB(55, 55, 55),
            AnchorPoint = Vector2.new(0.5, 0.5),
            Image = "rbxassetid://92562308197003",
            Size = UDim2.new(0, 10, 0, 10),
            BorderColor3 = Color3.fromRGB(0, 0, 0),
            BackgroundTransparency = 1,
            Name = "badge",
            Position = UDim2.new(0.5, 0, 0.5, 0)
        }, inactiveStatus)

        New("TextLabel", {
            BorderSizePixel = 0,
            TextSize = 12,
            TextXAlignment = Enum.TextXAlignment.Left,
            TextTransparency = 0.5,
            BackgroundColor3 = Color3.fromRGB(255, 255, 255),
            FontFace = Font.new("rbxassetid://12187365364", Enum.FontWeight.SemiBold, Enum.FontStyle.Normal),
            TextColor3 = Color3.fromRGB(255, 255, 255),
            BackgroundTransparency = 1,
            Size = UDim2.new(0, 0, 1, 0),
            BorderColor3 = Color3.fromRGB(0, 0, 0),
            Text = "Inactive",
            AutomaticSize = Enum.AutomaticSize.X,
            Name = "Label"
        }, inactiveStatus)

        local activeStatus = New("Frame", {
            Visible = false,
            BorderSizePixel = 0,
            BackgroundColor3 = Color3.fromRGB(255, 255, 255),
            AnchorPoint = Vector2.new(0, 1),
            Size = UDim2.new(1, 0, 0, 20),
            Position = UDim2.new(0, 0, 1, -30),
            BorderColor3 = Color3.fromRGB(0, 0, 0),
            Name = "ActiveStatus",
            BackgroundTransparency = 1
        }, content)

        New("UIListLayout", {
            HorizontalAlignment = Enum.HorizontalAlignment.Center,
            Padding = UDim.new(0, 5),
            VerticalAlignment = Enum.VerticalAlignment.Center,
            SortOrder = Enum.SortOrder.LayoutOrder,
            Name = "list",
            FillDirection = Enum.FillDirection.Horizontal
        }, activeStatus)

        New("UIPadding", {Name = "padding", PaddingLeft = UDim.new(0, 5)}, activeStatus)

        local activeBadge = New("ImageLabel", {
            ZIndex = 20,
            BorderSizePixel = 0,
            ScaleType = Enum.ScaleType.Fit,
            BackgroundColor3 = Color3.fromRGB(255, 255, 255),
            ImageColor3 = Color3.fromRGB(0, 241, 9),
            AnchorPoint = Vector2.new(0.5, 0.5),
            Image = "rbxassetid://92562308197003",
            Size = UDim2.new(0, 10, 0, 10),
            BorderColor3 = Color3.fromRGB(0, 0, 0),
            BackgroundTransparency = 1,
            Name = "badge",
            Position = UDim2.new(0.5, 0, 0.5, 0)
        }, activeStatus)

        local glow = New("ImageLabel", {
            ZIndex = 20,
            BorderSizePixel = 0,
            ScaleType = Enum.ScaleType.Fit,
            BackgroundColor3 = Color3.fromRGB(255, 255, 255),
            ImageColor3 = Color3.fromRGB(0, 241, 9),
            AnchorPoint = Vector2.new(0.5, 0.5),
            Image = "rbxassetid://88592542618493",
            Size = UDim2.new(0, 10, 0, 10),
            BorderColor3 = Color3.fromRGB(0, 0, 0),
            BackgroundTransparency = 1,
            Name = "glow",
            Position = UDim2.new(0.5, 0, 0.5, 0)
        }, activeBadge)

        local glowScale = New("UIScale", {Name = "scale"}, glow)

        New("TextLabel", {
            BorderSizePixel = 0,
            TextSize = 12,
            TextXAlignment = Enum.TextXAlignment.Left,
            TextTransparency = 0.5,
            BackgroundColor3 = Color3.fromRGB(255, 255, 255),
            FontFace = Font.new("rbxassetid://12187365364", Enum.FontWeight.SemiBold, Enum.FontStyle.Normal),
            TextColor3 = Color3.fromRGB(255, 255, 255),
            BackgroundTransparency = 1,
            Size = UDim2.new(0, 0, 1, 0),
            BorderColor3 = Color3.fromRGB(0, 0, 0),
            Text = "Active",
            AutomaticSize = Enum.AutomaticSize.X,
            Name = "Label"
        }, activeStatus)

        local function setFreecamState(enabled)
            freecamEnabled = enabled
            inactiveStatus.Visible = not enabled
            activeStatus.Visible = enabled
            if enabled then
                TweenService:Create(powerScale, TweenInfo.new(0.3, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {Scale = 1.1}):Play()
                TweenService:Create(glowScale, TweenInfo.new(0.8, Enum.EasingStyle.Quad, Enum.EasingDirection.Out, -1, true), {Scale = 2}):Play()
                powerStroke.Color = Color3.fromRGB(0, 241, 9)
            else
                TweenService:Create(powerScale, TweenInfo.new(0.3, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {Scale = 1}):Play()
                TweenService:Create(glowScale, TweenInfo.new(0.15), {Scale = 0}):Play()
                powerStroke.Color = Color3.fromRGB(186, 186, 186)
            end
        end

        powerBtn.MouseButton1Click:Connect(function()
            if freecamEnabled then
                if rightClickHeld then
                    rightClickHeld = false
                    UserInputService.MouseIconEnabled = true
                    UserInputService.MouseBehavior = Enum.MouseBehavior.Default
                end
                Input.StopCapture()
                RunService:UnbindFromRenderStep("Freecam")
                PlayerState.Pop()
                setFreecamState(false)
            else
                local cameraCFrame = Camera.CFrame
                cameraRot = Vector2.new(cameraCFrame:toEulerAnglesYXZ())
                cameraPos = cameraCFrame.p
                cameraFov = Camera.FieldOfView
                velSpring:Reset(Vector3.new())
                panSpring:Reset(Vector2.new())
                fovSpring:Reset(0)
                PlayerState.Push()
                RunService:BindToRenderStep("Freecam", Enum.RenderPriority.Camera.Value, StepFreecam)
                Input.StartCapture()
                setFreecamState(true)
            end
        end)

        -- Orientation indicator
        local orientationGroup = New("CanvasGroup", {
            GroupTransparency = 1,
            ZIndex = 0,
            BorderSizePixel = 0,
            BackgroundColor3 = Color3.fromRGB(255, 255, 255),
            AnchorPoint = Vector2.new(0.5, 0.5),
            Size = UDim2.new(0.8, 0, 0, 50),
            Position = UDim2.new(0.5, 0, 0.5, 0),
            BorderColor3 = Color3.fromRGB(0, 0, 0),
            Name = "Orientation",
            Rotation = 1,
            BackgroundTransparency = 1
        }, content)

        local orientationScale = New("UIScale", {Name = "scale"}, orientationGroup)

        local sprite = New("Frame", {
            Active = true,
            BorderSizePixel = 0,
            BackgroundColor3 = Color3.fromRGB(43, 43, 43),
            Selectable = true,
            AnchorPoint = Vector2.new(0.5, 0.5),
            Size = UDim2.new(0, 150, 0, 150),
            Position = UDim2.new(0.5, 0, 0.5, 0),
            BorderColor3 = Color3.fromRGB(0, 0, 0),
            Name = "Sprite",
            BackgroundTransparency = 1
        }, orientationGroup)

        New("UICorner", {Name = "corner", CornerRadius = UDim.new(1, 0)}, sprite)

        local spriteStroke = New("UIStroke", {
            Transparency = 0.8,
            Color = Color3.fromRGB(186, 186, 186),
            ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
            Name = "stroke"
        }, sprite)

        RunService:BindToRenderStep("FreecamOrientation", Enum.RenderPriority.Camera.Value - 1, function()
            if freecamEnabled then
                orientationGroup.GroupTransparency = 0
                local camDir = Camera.CFrame.LookVector
                local pitch = math.asin(-camDir.Y)
                if abs(pitch) > 0.1 then
                    orientationScale.Scale = 1 + abs(pitch) * 0.3
                else
                    orientationScale.Scale = 1
                end
                local flatDir = Vector3.new(camDir.X, 0, camDir.Z)
                if flatDir.Magnitude > 0.01 then
                    local yaw = math.atan2(-flatDir.X, -flatDir.Z)
                    sprite.Rotation = math.deg(yaw)
                end
                local pitchDeg = math.deg(pitch)
                spriteStroke.Color = Color3.fromRGB(
                    clamp(186 + pitchDeg * 2, 50, 255),
                    clamp(186 - abs(pitchDeg) * 2, 50, 255),
                    clamp(186 - abs(pitchDeg) * 3, 50, 255)
                )
            else
                orientationGroup.GroupTransparency = 1
            end
        end)

        -- Close logic
        local function close()
            if rightClickHeld then
                rightClickHeld = false
                UserInputService.MouseIconEnabled = true
                UserInputService.MouseBehavior = Enum.MouseBehavior.Default
            end
            if freecamEnabled then
                Input.StopCapture()
                RunService:UnbindFromRenderStep("Freecam")
                RunService:UnbindFromRenderStep("FreecamOrientation")
                PlayerState.Pop()
            end
            RunService:UnbindFromRenderStep("FreecamOrientation")
            rcBeganConn:Disconnect()
            rcEndedConn:Disconnect()
            if onClose then onClose() end
            local closeTween = TweenService:Create(containerScale, TweenInfo.new(0.15, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Scale = 0})
            closeTween.Completed:Connect(function()
                screenGui:Destroy()
            end)
            closeTween:Play()
        end

        closeBtn.MouseButton1Click:Connect(close)

        -- Open animation
        containerScale.Scale = 0
        TweenService:Create(containerScale, TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Scale = 1}):Play()

        return {Close = close, ScreenGui = screenGui}
    end
end
