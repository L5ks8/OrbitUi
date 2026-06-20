-- Notification Component for Orbit UI
local CollectionService = game:GetService("CollectionService")
local TweenService = game:GetService("TweenService")
local Players = game:GetService("Players")

return function(mainfunctions)
    local New = mainfunctions.New
    local fonts = mainfunctions.GetFonts()
    
    local NotificationSystem = {}
    local LocalPlayer = Players.LocalPlayer
    local targetParent = (gethui and gethui()) or game:GetService("CoreGui") or (LocalPlayer and LocalPlayer:WaitForChild("PlayerGui"))
    
    -- Dedicated ScreenGui for Notifications (always on top)
    local screenGui = targetParent:FindFirstChild("Notifications")
    if not screenGui then
        screenGui = New("ScreenGui", {
            Name = "Notifications",
            IgnoreGuiInset = true,
            ResetOnSpawn = false,
            ZIndexBehavior = Enum.ZIndexBehavior.Sibling,
            DisplayOrder = 99999
        }, targetParent)
    end
    
    -- Notifications Container Frame (aligned to top-right)
    local container = screenGui:FindFirstChild("Notifications")
    if not container then
        container = New("Frame", {
            Name = "Notifications",
            Size = UDim2.new(0, 450, 1, -40),
            Position = UDim2.new(0.5, 0, 0, 20),
            AnchorPoint = Vector2.new(0.5, 0),
            BackgroundTransparency = 1,
            ZIndex = 3
        }, screenGui)
        
        New("UIListLayout", {
            Name = "Layout",
            HorizontalAlignment = Enum.HorizontalAlignment.Center,
            VerticalAlignment = Enum.VerticalAlignment.Top,
            SortOrder = Enum.SortOrder.LayoutOrder,
            Padding = UDim.new(0, 10)
        }, container)
        
        New("UIPadding", {
            Name = "Padding",
            PaddingTop = UDim.new(0, 12)
        }, container)
    end
    
    function NotificationSystem:Notify(config)
        config = config or {}
        local titleText = config.Title or "Notification"
        local descText = config.Description or ""
        local duration = config.Duration or 5
        local iconId = config.Icon or nil
        local userId = config.UserId or nil
        
        -- Create cloned Notification Frame (G2L["4"] equivalent)
        local notificationBtn = New("ImageButton", {
            Name = "Notification",
            BorderSizePixel = 0,
            AutoButtonColor = false,
            ImageTransparency = 1,
            BackgroundTransparency = 1,
            BackgroundColor3 = Color3.fromRGB(255, 255, 255),
            AutomaticSize = Enum.AutomaticSize.XY,
            ClipsDescendants = true
        })
        
        New("UIPadding", {
            Name = "Padding",
            PaddingTop = UDim.new(0, 5),
            PaddingBottom = UDim.new(0, 5)
        }, notificationBtn)
        
        local banner = New("CanvasGroup", {
            Name = "Banner",
            BorderSizePixel = 0,
            BackgroundColor3 = Color3.fromRGB(37, 37, 37),
            AutomaticSize = Enum.AutomaticSize.XY,
            GroupTransparency = 1 -- Start transparent for fade-in
        }, notificationBtn)
        
        New("UICorner", {
            Name = "Corner",
            CornerRadius = UDim.new(0, 20)
        }, banner)
        
        local listLayout = New("UIListLayout", {
            Name = "List",
            HorizontalAlignment = Enum.HorizontalAlignment.Center,
            VerticalAlignment = Enum.VerticalAlignment.Center,
            SortOrder = Enum.SortOrder.LayoutOrder,
            FillDirection = Enum.FillDirection.Horizontal,
            Padding = UDim.new(0, 14)
        }, banner)
        
        local scale = New("UIScale", {
            Name = "Scale",
            Scale = 1
        }, banner)
        
        if iconId then
            local holder = New("ImageLabel", {
                Name = "holder",
                BorderSizePixel = 0,
                BackgroundColor3 = Color3.fromRGB(0, 0, 0),
                ImageTransparency = 1,
                Size = UDim2.new(0, 32, 0, 32),
                BackgroundTransparency = 0.8,
                LayoutOrder = 1
            }, banner)
            
            New("UICorner", {
                Name = "Corner",
                CornerRadius = UDim.new(0, 6)
            }, holder)
            
            local iconStr = tostring(iconId)
            local finalIcon = iconStr:find("rbxasset") and iconStr or "rbxassetid://" .. iconStr
            
            New("ImageLabel", {
                Name = "icon",
                BorderSizePixel = 0,
                BackgroundColor3 = Color3.fromRGB(255, 255, 255),
                AnchorPoint = Vector2.new(0.5, 0.5),
                Size = UDim2.new(0, 20, 0, 20),
                BackgroundTransparency = 1,
                Position = UDim2.new(0.5, 0, 0.5, 0),
                Image = finalIcon,
                ImageColor3 = mainfunctions.CurrentAccent
            }, holder)
        end
        
        local infoFrame = New("Frame", {
            Name = "information",
            BorderSizePixel = 0,
            AutomaticSize = Enum.AutomaticSize.XY,
            BackgroundTransparency = 1,
            LayoutOrder = 2
        }, banner)
        
        New("UIListLayout", {
            Name = "list",
            Padding = UDim.new(0, 4),
            VerticalAlignment = Enum.VerticalAlignment.Center,
            SortOrder = Enum.SortOrder.LayoutOrder
        }, infoFrame)
        
        -- Title (G2L["c"] equivalent)
        local titleLabel = New("TextLabel", {
            Name = "title",
            Text = titleText,
            TextWrapped = true,
            BorderSizePixel = 0,
            AutoLocalize = false,
            TextSize = 15,
            TextXAlignment = Enum.TextXAlignment.Left,
            BackgroundColor3 = Color3.fromRGB(255, 255, 255),
            FontFace = fonts.med,
            TextColor3 = Color3.fromRGB(255, 255, 255),
            BackgroundTransparency = 1,
            LayoutOrder = 1,
            AutomaticSize = Enum.AutomaticSize.XY
        }, infoFrame)
        
        -- Description (G2L["d"] equivalent)
        if descText and descText ~= "" then
            local descLabel = New("TextLabel", {
                Name = "description",
                Text = descText,
                TextWrapped = true,
                BorderSizePixel = 0,
                AutoLocalize = false,
                TextSize = 12,
                TextXAlignment = Enum.TextXAlignment.Left,
                TextTransparency = 0.5,
                TextYAlignment = Enum.TextYAlignment.Top,
                BackgroundColor3 = Color3.fromRGB(255, 255, 255),
                FontFace = fonts.reg,
                TextColor3 = Color3.fromRGB(255, 255, 255),
                BackgroundTransparency = 1,
                LayoutOrder = 2,
                AutomaticSize = Enum.AutomaticSize.XY
            }, infoFrame)
        end
        
        if userId then
            local groupFrame = New("Frame", {
                Name = "group",
                BorderSizePixel = 0,
                AutomaticSize = Enum.AutomaticSize.XY,
                BackgroundTransparency = 1,
                LayoutOrder = 3
            }, infoFrame)
            
            New("UIListLayout", {
                Name = "list",
                Padding = UDim.new(0, -4),
                VerticalAlignment = Enum.VerticalAlignment.Bottom,
                SortOrder = Enum.SortOrder.LayoutOrder,
                FillDirection = Enum.FillDirection.Horizontal
            }, groupFrame)
            
            local userImage = New("ImageLabel", {
                Name = "user",
                ZIndex = 2,
                BorderSizePixel = 0,
                ScaleType = Enum.ScaleType.Fit,
                BackgroundColor3 = Color3.fromRGB(27, 27, 27),
                Image = "rbxthumb://type=AvatarHeadShot&id=" .. userId .. "&w=150&h=150",
                Size = UDim2.new(0, 26, 0, 26),
                LayoutOrder = 2
            }, groupFrame)
            
            CollectionService:AddTag(userImage, "ThemesOnlyIncludeBg")
            
            New("UICorner", {
                Name = "corner",
                CornerRadius = UDim.new(1, 0)
            }, userImage)
            
            New("UIStroke", {
                Name = "stroke",
                Thickness = 4,
                Color = Color3.fromRGB(35, 35, 35)
            }, userImage)
        end
        
        New("UIPadding", {
            Name = "Padding",
            PaddingTop = UDim.new(0, 18),
            PaddingRight = UDim.new(0, 25),
            PaddingLeft = UDim.new(0, 25),
            PaddingBottom = UDim.new(0, 18)
        }, banner)
        
        banner.Position = UDim2.new(0, 0, -1.2, 0)
        notificationBtn.Parent = container
        
        task.wait()
        
        local slideInTween = TweenService:Create(banner, TweenInfo.new(0.4, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {
            Position = UDim2.new(0, 0, 0, 0),
            GroupTransparency = 0
        })
        slideInTween:Play()
        
        -- Cleanup animation helper
        local isClosing = false
        local function closeNotification()
            if isClosing then return end
            isClosing = true
            
            -- Slide out to the top and fade out
            local slideOutTween = TweenService:Create(banner, TweenInfo.new(0.35, Enum.EasingStyle.Quart, Enum.EasingDirection.In), {
                Position = UDim2.new(0, 0, -1.2, 0),
                GroupTransparency = 1
            })
            slideOutTween:Play()
            slideOutTween.Completed:Connect(function()
                -- Temporarily override automatic size to collapse the height to 0 smoothly
                notificationBtn.AutomaticSize = Enum.AutomaticSize.None
                local currentHeight = notificationBtn.AbsoluteSize.Y
                notificationBtn.Size = UDim2.new(1, 0, 0, currentHeight)
                
                local collapseTween = TweenService:Create(notificationBtn, TweenInfo.new(0.25, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {
                    Size = UDim2.new(1, 0, 0, 0)
                })
                collapseTween:Play()
                collapseTween.Completed:Connect(function()
                    notificationBtn:Destroy()
                end)
            end)
        end
        
        -- Close on click
        local clickConn
        clickConn = notificationBtn.MouseButton1Click:Connect(function()
            if clickConn then
                clickConn:Disconnect()
                clickConn = nil
            end
            closeNotification()
        end)
        
        -- Auto close after duration
        task.delay(duration, function()
            if clickConn then
                clickConn:Disconnect()
                clickConn = nil
            end
            closeNotification()
        end)
    end
    
    return NotificationSystem
end
