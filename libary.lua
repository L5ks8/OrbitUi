--// Services
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

--// Setup
local Setup = {
    Keybind = Enum.KeyCode.RightControl,
    Transparency = 0,
    ThemeMode = "Dark",
    Blur = false
}

local Themes = {
    Dark = {
        Primary = Color3.fromRGB(30, 30, 30),
        Secondary = Color3.fromRGB(35, 35, 35),
        Component = Color3.fromRGB(40, 40, 40),
        Interactables = Color3.fromRGB(45, 45, 45),
        Tab = Color3.fromRGB(200, 200, 200),
        Title = Color3.fromRGB(240, 240, 240),
        Description = Color3.fromRGB(200, 200, 200),
        Shadow = Color3.fromRGB(0, 0, 0),
        Outline = Color3.fromRGB(40, 40, 40),
        Icon = Color3.fromRGB(220, 220, 220),
        Accent = Color3.fromRGB(248, 191, 212)
    }
}

local Fonts = {
    reg = Font.fromId(12187365364),
    bold = Font.fromId(12187365364, Enum.FontWeight.Bold),
    med = Font.fromId(12187365364, Enum.FontWeight.Medium),
    logo = Font.fromId(12187365364, Enum.FontWeight.Bold)
}

--// Utilities
local function New(class, props, parent)
    local i = Instance.new(class)
    for k, v in pairs(props) do i[k] = v end
    if parent then i.Parent = parent end
    return i
end

local function SetProperty(Object, Properties)
    for k, v in pairs(Properties) do Object[k] = v end
    return Object
end

local function Tween(Object, Speed, Properties)
    return TweenService:Create(Object, TweenInfo.new(Speed, Enum.EasingStyle.Sine), Properties):Play()
end

--// Tables
local Animations = {}
local StoredInfo = { Sections = {}, Tabs = {} }
local Library = {}

--// Animations
function Animations:Open(Window, Transparency)
    SetProperty(Window, { 
        GroupTransparency = 1, 
        Visible = true 
    })
    Tween(Window, 0.25, { 
        GroupTransparency = Transparency or 0 
    })
end

function Animations:Close(Window)
    Tween(Window, 0.25, { 
        GroupTransparency = 1 
    })
    task.wait(0.25)
    Window.Visible = false
end

function Animations:Component(Component)
    Component.InputBegan:Connect(function()
        Tween(Component, 0.2, { 
            BackgroundColor3 = Color3.fromRGB(50, 50, 50) 
        })
    end)
    Component.InputEnded:Connect(function()
        Tween(Component, 0.2, { 
            BackgroundColor3 = Themes.Dark.Component 
        })
    end)
end

--// Core Library
function Library:CreateWindow(Settings)
    local Title = Settings.Title or "Goon Hub"
    local Size = Settings.Size or UDim2.new(0, 850, 0, 580)
    local Transparency = Settings.Transparency or 0
    local Theme = Themes.Dark

    -- Configuration
    if Settings.MinimizeKeybind then
        Setup.Keybind = Settings.MinimizeKeybind
    end
    
    -- Target UI Root
    local target = (gethui and gethui()) or game:GetService("CoreGui") or LocalPlayer:WaitForChild("PlayerGui")
    if target:FindFirstChild("GoonHub") then target["GoonHub"]:Destroy() end

    -- Build Main UI
    local Screen = New("ScreenGui", { 
        Name = "GoonHub", 
        IgnoreGuiInset = true, 
        ResetOnSpawn = false 
    }, target)
    local Main = New("CanvasGroup", {
        Name = "Main",
        BackgroundColor3 = Theme.Primary,
        AnchorPoint = Vector2.new(0.5, 0.5),
        Size = Size,
        Position = UDim2.new(0.5, 0, 0.5, 0),
        ClipsDescendants = true
    }, Screen)

    New("UICorner", { CornerRadius = UDim.new(0, 18) }, Main)
    local Stroke = New("UIStroke", { 
        Transparency = 0.75, 
        Thickness = 2, 
        Color = Color3.new(1, 1, 1) 
    }, Main)

    -- Layout Structure
    local Content = New("Frame", { 
        Name = "Content", 
        Size = UDim2.new(1, 0, 1, -35), 
        Position = UDim2.new(0.5, 0, 1, 0), 
        AnchorPoint = Vector2.new(0.5, 1), 
        BackgroundTransparency = 1 
    }, Main)

    New("UIPadding", { 
        PaddingTop = UDim.new(0, 10), 
        PaddingBottom = UDim.new(0, 35), 
        PaddingRight = UDim.new(0, 15) 
    }, Content)

    local Sidebar = New("Frame", { 
        Name = "Sidebar", 
        Size = UDim2.new(0, 220, 1, 0), 
        BackgroundTransparency = 1 
    }, Content)

    New("UIListLayout", { 
        Padding = UDim.new(0, 7), 
        HorizontalAlignment = Enum.HorizontalAlignment.Center 
    }, Sidebar)

    local NavHolder = New("Frame", { 
        Name = "NavHolder", 
        Size = UDim2.new(1, -22, 0, 0), 
        BackgroundColor3 = Color3.fromRGB(9, 9, 9), 
        BackgroundTransparency = 0.7 
    }, Sidebar)

    New("UICorner", { CornerRadius = UDim.new(0, 15) }, NavHolder)
    New("UIFlexItem", { FlexMode = Enum.UIFlexMode.Fill }, NavHolder)

    local NavScroll = New("ScrollingFrame", { 
        Name = "Navigation", 
        Size = UDim2.new(1, 0, 1, -16), 
        Position = UDim2.new(0, 0, 0, 8), 
        BackgroundTransparency = 1, 
        ScrollBarThickness = 0, 
        AutomaticCanvasSize = Enum.AutomaticSize.Y 
    }, NavHolder)

    New("UIListLayout", { 
        Padding = UDim.new(0, 5), 
        HorizontalAlignment = Enum.HorizontalAlignment.Center 
    }, NavScroll)

    local PageHolder = New("Frame", { 
        Name = "PageHolder", 
        Size = UDim2.new(1, -235, 1, 0), 
        Position = UDim2.new(1, 0, 1, 0), 
        AnchorPoint = Vector2.new(1, 1), 
        BackgroundColor3 = Color3.fromRGB(21, 21, 21), 
        BackgroundTransparency = 0.7 
    }, Content)

    New("UICorner", { CornerRadius = UDim.new(0, 12) }, PageHolder)
    local Pages = New("UIPageLayout", { 
        Animated = true, 
        EasingStyle = Enum.EasingStyle.Quart, 
        TweenTime = 0.45 
    }, PageHolder)

    local Topbar = New("Frame", { 
        Name = "Topbar",
        Size = UDim2.new(1, 0, 0, 35),
        BackgroundTransparency = 1
    }, Main)

    local Buttons = New("Frame", {
        Name = "Buttons",
        Size = UDim2.new(0, 80, 1, 0),
        Position = UDim2.new(1, -90, 0, 0),
        BackgroundTransparency = 1
    }, Topbar)

    local CloseBtn = New("TextButton", {
        Name = "Close",
        Size = UDim2.new(0, 25, 0, 25),
        Position = UDim2.new(1, -25, 0.5, -12),
        BackgroundColor3 = Color3.fromRGB(200, 50, 50),
        Text = "",
        AutoButtonColor = true
    }, Buttons)
    New("UICorner", { CornerRadius = UDim.new(1, 0) }, CloseBtn)
    CloseBtn.MouseButton1Click:Connect(function() Screen:Destroy() end)

    local TitleLabel = New("TextLabel", {
        Position = UDim2.new(0, 15, 0, 0),
        Size = UDim2.new(0, 0, 1, 0),
        AutomaticSize = Enum.AutomaticSize.X,
        Text = string.format("<font color=\"rgb(248, 191, 212)\">Goon</font>Hub | %s", Title),
        RichText = true, 
        FontFace = Fonts.logo, 
        TextSize = 20, 
        TextColor3 = Color3.new(1, 1, 1), 
        BackgroundTransparency = 1, 
        TextXAlignment = Enum.TextXAlignment.Left
    }, Topbar)

    -- Dragging Logic
    local dragging, dragStart, startPos

    Topbar.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
            dragStart = input.Position
            startPos = Main.Position
        end
    end)

    UserInputService.InputChanged:Connect(function(input)
        if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
            local delta = input.Position - dragStart
            Main.Position = UDim2.new(
                startPos.X.Scale, 
                startPos.X.Offset + delta.X, 
                startPos.Y.Scale, 
                startPos.Y.Offset + delta.Y
            )
        end
    end)

    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = false
        end
    end)

    -- Return Options (API)
    local Options = { LastSection = {} }

    function Options:AddTabSection(data)
        StoredInfo.Sections[data.Name] = data.Order or 0

        New("TextLabel", {
            Parent = NavScroll,
            Size = UDim2.new(1, 0, 0, 20),
            Text = data.Name:upper(),
            FontFace = Fonts.bold,
            TextSize = 12,
            TextColor3 = Color3.fromRGB(
                120, 
                120, 
                120
            ),
            BackgroundTransparency = 1,
            LayoutOrder = data.Order or 0
        })
    end


    function Options:AddTab(data)
        local tabBtn = New("TextButton", {
            Parent = NavScroll,
            Size = UDim2.new(1, -10, 0, 35),
            BackgroundColor3 = Theme.Interactables,
            BackgroundTransparency = 1,
            Text = "  " .. (data.Title or "Tab"),
            FontFace = Fonts.med,
            TextSize = 14,
            TextColor3 = Theme.Tab,
            LayoutOrder = StoredInfo.Sections[data.Section] or 0,
            TextXAlignment = Enum.TextXAlignment.Left
        })
        New("UICorner", { CornerRadius = UDim.new(0, 8) }, tabBtn)

        local page = New("ScrollingFrame", {
            Parent = PageHolder,
            Size = UDim2.new(1, 0, 1, 0),
            BackgroundTransparency = 1,
            ScrollBarThickness = 0,
            AutomaticCanvasSize = Enum.AutomaticSize.Y
        })

        New("UIListLayout", {
            Padding = UDim.new(0, 10),
            HorizontalAlignment = Enum.HorizontalAlignment.Center
        }, page)

        New("UIPadding", {
            PaddingTop = UDim.new(
                0, 
                10
            ),
            PaddingBottom = UDim.new(
                0, 
                10
            )
        }, page)

        tabBtn.MouseButton1Click:Connect(function()
            Pages:JumpTo(page)
            for _, v in pairs(NavScroll:GetChildren()) do 
                if v:IsA("TextButton") then 
                    v.BackgroundTransparency = 1 
                end 
            end
            tabBtn.BackgroundTransparency = 0.8
        end)

        local TabObj = { Page = page }
        Options.LastSection[TabObj] = Options:AddSection({ Name = "General", Tab = TabObj })
        return TabObj
    end

    function Options:AddSection(data)
        local sec = New("Frame", {
            Parent = data.Tab.Page,
            Size = UDim2.new(1, -20, 0, 0),
            AutomaticSize = Enum.AutomaticSize.Y,
            BackgroundColor3 = Theme.Secondary,
            BackgroundTransparency = 0.5
        })
        New("UICorner", { CornerRadius = UDim.new(0, 10) }, sec)

        New("UIListLayout", { 
            Padding = UDim.new(0, 5), 
            HorizontalAlignment = Enum.HorizontalAlignment.Center 
        }, sec)

        New("UIPadding", { 
            PaddingTop = UDim.new(0, 10), 
            PaddingBottom = UDim.new(0, 10) 
        }, sec)
        
        New("TextLabel", {
            Parent = sec,
            Size = UDim2.new(1, -20, 0, 20),
            Text = data.Name,
            FontFace = Fonts.bold,
            TextSize = 14,
            TextColor3 = Theme.Accent,
            BackgroundTransparency = 1,
            TextXAlignment = Enum.TextXAlignment.Left
        })

        Options.LastSection[data.Tab] = sec
        return sec
    end

    function Options:AddButton(data)
        local target = Options.LastSection[data.Tab]
        local btn = New("TextButton", {
            Parent = target,
            Size = UDim2.new(1, -20, 0, 35),
            BackgroundColor3 = Theme.Component,
            Text = data.Title,
            TextColor3 = Theme.Title,
            FontFace = Fonts.reg,
            TextSize = 14
        })
        New("UICorner", { CornerRadius = UDim.new(0, 6) }, btn)
        
        if data.Description then
            btn.ToolTip = data.Description -- Falls Tooltips existieren
        end

        Animations:Component(btn)

        btn.MouseButton1Click:Connect(function()
            if data.Callback then data.Callback() end
        end)
    end

    function Options:AddToggle(data)
        local target = Options.LastSection[data.Tab]
        local state = data.Default or false
        
        local frame = New("TextButton", {
            Parent = target,
            Size = UDim2.new(1, -20, 0, 35),
            BackgroundColor3 = Theme.Component,
            Text = "  " .. data.Title,
            TextColor3 = Theme.Title,
            FontFace = Fonts.reg,
            TextSize = 14,
            TextXAlignment = Enum.TextXAlignment.Left
        })

        New("UICorner", { CornerRadius = UDim.new(0, 6) }, frame)

        local indicator = New("Frame", {
            Parent = frame,
            Size = UDim2.new(0, 40, 0, 20),
            Position = UDim2.new(1, -50, 0.5, -10),
            BackgroundColor3 = state and Theme.Accent or Color3.fromRGB(60, 60, 60)
        }, frame)
        New("UICorner", { CornerRadius = UDim.new(1, 0) }, indicator)

        frame.MouseButton1Click:Connect(function()
            state = not state
            
            local targetColor = state and Theme.Accent or Color3.fromRGB(60, 60, 60)
            Tween(indicator, 0.3, { 
                BackgroundColor3 = targetColor 
            })

            if data.Callback then data.Callback(state) end
        end)
    end

    function Options:AddSlider(data)
        local target = Options.LastSection[data.Tab]
        local min, max = data.MinValue or 0, data.MaxValue or 100
        local f = New("Frame", { 
            Parent = target, 
            Size = UDim2.new(1, -20, 0, 50), 
            BackgroundColor3 = Theme.Component 
        })
        
        New("UICorner", { CornerRadius = UDim.new(0, 6) }, f)

        New("TextLabel", { 
            Parent = f, 
            Size = UDim2.new(
                1, 
                -20, 
                0, 
                20
            ), 
            Position = UDim2.new(0, 10, 0, 5), 
            Text = data.Title, 
            FontFace = Fonts.reg, 
            TextSize = 14, 
            TextColor3 = Theme.Title, 
            BackgroundTransparency = 1, 
            TextXAlignment = Enum.TextXAlignment.Left 
        })
        
        local bg = New("Frame", { 
            Parent = f, 
            Size = UDim2.new(1, -20, 0, 6), 
            Position = UDim2.new(0, 10, 0, 35), 
            BackgroundColor3 = Color3.fromRGB(60, 60, 60) 
        })

        local fill = New("Frame", { 
            Parent = bg, 
            Size = UDim2.new(0, 0, 1, 0), 
            BackgroundColor3 = Theme.Accent 
        })
        
        local valLabel = New("TextBox", {
            Parent = f,
            Size = UDim2.new(0, 40, 0, 20),
            Position = UDim2.new(1, -50, 0, 5),
            BackgroundTransparency = 1,
            Text = tostring(data.Default or min),
            TextColor3 = Theme.Title,
            FontFace = Fonts.reg,
            TextSize = 14,
            TextXAlignment = Enum.TextXAlignment.Right
        })

        local function UpdateSlider(p)
            local raw = min + (max - min) * p
            local value = data.AllowDecimals and (math.floor(raw * 100) / 100) or math.floor(raw)
            
            fill.Size = UDim2.new(p, 0, 1, 0)
            valLabel.Text = tostring(value)
            if data.Callback then data.Callback(value) end
        end

        bg.InputBegan:Connect(function(i)
            if i.UserInputType == Enum.UserInputType.MouseButton1 then
                local conn
                conn = UserInputService.InputChanged:Connect(function(m)
                    if m.UserInputType == Enum.UserInputType.MouseMovement then
                        local p = math.clamp((m.Position.X - bg.AbsolutePosition.X) / bg.AbsoluteSize.X, 0, 1)
                        UpdateSlider(p)
                    end
                end)

                UserInputService.InputEnded:Connect(function(u) 
                    if u.UserInputType == Enum.UserInputType.MouseButton1 then 
                        conn:Disconnect() 
                    end 
                end)
            end
        end)
    end

    function Options:AddInput(data)
        local target = Options.LastSection[data.Tab]
        local f = New("Frame", { 
            Parent = target, 
            Size = UDim2.new(1, -20, 0, 35), 
            BackgroundColor3 = Theme.Component 
        })

        New("UICorner", { CornerRadius = UDim.new(0, 6) }, f)
        local i = New("TextBox", { 
            Parent = f, Size = UDim2.new(1, -20, 1, 0), Position = UDim2.new(0, 10, 0, 0), 
            BackgroundTransparency = 1, Text = "", PlaceholderText = data.Title .. "...", 
            TextColor3 = Theme.Title, FontFace = Fonts.reg, TextSize = 14, TextXAlignment = Enum.TextXAlignment.Left 
        })

        i.FocusLost:Connect(function() if data.Callback then data.Callback(i.Text) end end)
    end

    function Options:AddDropdown(data)
        local target = Options.LastSection[data.Tab]
        local f = New("TextButton", { Parent = target, Size = UDim2.new(1, -20, 0, 35), BackgroundColor3 = Theme.Component, Text = "  " .. data.Title, TextColor3 = Theme.Title, FontFace = Fonts.reg, TextSize = 14, TextXAlignment = Enum.TextXAlignment.Left })
        New("UICorner", { CornerRadius = UDim.new(0, 6) }, f)

        f.MouseButton1Click:Connect(function() 
            if data.Callback then 
                data.Callback(next(data.Options)) 
            end 
        end)
    end

    function Options:AddKeybind(data)
        local target = Options.LastSection[data.Tab]
        local key = data.Default or Enum.KeyCode.F
        
        local f = New("TextButton", { 
            Parent = target, 
            Size = UDim2.new(1, -20, 0, 35), 
            BackgroundColor3 = Theme.Component, 
            Text = "  " .. data.Title, 
            TextColor3 = Theme.Title, 
            FontFace = Fonts.reg, 
            TextSize = 14, 
            TextXAlignment = Enum.TextXAlignment.Left 
        })

        New("UICorner", { CornerRadius = UDim.new(0, 6) }, f)
        
        local l = New("TextLabel", { 
            Parent = f, 
            Size = UDim2.new(0, 60, 0, 20), 
            Position = UDim2.new(1, -70, 0.5, -10), 
            Text = key.Name, 
            BackgroundColor3 = Color3.fromRGB(60, 60, 60), 
            TextColor3 = Theme.Title 
        })

        f.MouseButton1Click:Connect(function()
            l.Text = "..."
            local c
            c = UserInputService.InputBegan:Connect(function(i)
                if i.UserInputType == Enum.UserInputType.Keyboard then
                    key = i.KeyCode
                    l.Text = key.Name
                    if data.Callback then data.Callback(key) end
                    c:Disconnect()
                end
            end)
        end)
    end

    function Options:AddParagraph(data)
        local target = Options.LastSection[data.Tab]
        local f = New("Frame", { 
            Parent = target, 
            Size = UDim2.new(1, -20, 0, 0), 
            AutomaticSize = Enum.AutomaticSize.Y, 
            BackgroundColor3 = Theme.Secondary 
        })

        New("UICorner", { CornerRadius = UDim.new(0, 6) }, f)

        New("UIPadding", { 
            PaddingTop = UDim.new(0, 8), 
            PaddingBottom = UDim.new(0, 8), 
            PaddingLeft = UDim.new(0, 10), 
            PaddingRight = UDim.new(0, 10) 
        }, f)

        New("UIListLayout", { Padding = UDim.new(0, 2) }, f)

        New("TextLabel", { 
            Parent = f, 
            Size = UDim2.new(1, 0, 0, 18), 
            Text = data.Title, 
            FontFace = Fonts.bold, 
            TextSize = 14, 
            TextColor3 = Theme.Title, 
            BackgroundTransparency = 1, 
            TextXAlignment = Enum.TextXAlignment.Left 
        })

        New("TextLabel", { 
            Parent = f, 
            Size = UDim2.new(1, 0, 0, 0), 
            AutomaticSize = Enum.AutomaticSize.Y, 
            Text = data.Description, 
            FontFace = Fonts.reg, 
            TextSize = 13, 
            TextColor3 = Theme.Description, 
            BackgroundTransparency = 1, 
            TextXAlignment = Enum.TextXAlignment.Left, 
            TextWrapped = true 
        })
    end

    function Options:Notify(data)
        local h = Screen:FindFirstChild("Notifs") or New("Frame", { 
            Name = "Notifs", 
            Position = UDim2.new(1, -330, 0, 20), 
            Size = UDim2.new(0, 310, 1, -40), 
            BackgroundTransparency = 1 
        }, Screen)

        if not h:FindFirstChild("Layout") then 
            New("UIListLayout", { 
                Name = "Layout", 
                Padding = UDim.new(0, 10), 
                VerticalAlignment = Enum.VerticalAlignment.Top 
            }, h) 
        end
        
        local b = New("CanvasGroup", { 
            Size = UDim2.new(1, 0, 0, 60), 
            BackgroundColor3 = Theme.Secondary, 
            GroupTransparency = 1 
        }, h)

        New("UICorner", { CornerRadius = UDim.new(0, 10) }, b)

        New("TextLabel", { 
            Parent = b, 
            Size = UDim2.new(1, -20, 1, 0), 
            Position = UDim2.new(0, 10, 0, 0), 
            Text = data.Description, 
            TextColor3 = Theme.Title, 
            BackgroundTransparency = 1, 
            TextWrapped = true, 
            FontFace = Fonts.reg, 
            TextSize = 14 
        })
        
        Tween(b, 0.4, { 
            GroupTransparency = 0 
        })

        task.delay(data.Duration or 5, function()
            Tween(b, 0.4, { 
                GroupTransparency = 1 
            })
            task.wait(0.4)
            b:Destroy()
        end)
    end

    function Options:SetSetting(k, v)
        if k == "Transparency" then Main.BackgroundTransparency = v end
        if k == "Keybind" then Setup.Keybind = v end
        if k == "Blur" then Setup.Blur = v end
    end

    UserInputService.InputBegan:Connect(function(input, gpe)
        if not gpe and input.KeyCode == Setup.Keybind then
            Main.Visible = not Main.Visible
        end
    end)

    -- Initialization
    SetProperty(Main, { Size = Size, Visible = true })
    Animations:Open(Main, Transparency)

    return Options
end

return Library