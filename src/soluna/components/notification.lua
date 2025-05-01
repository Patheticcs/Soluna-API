--[[
    Notification Component
    Popup notifications with title, content, and duration
]]

local Notification = {}
Notification.__index = Notification

-- Create a new notification
function Notification.create(library, options)
    local self = setmetatable({}, Notification)
    
    -- Default options
    options = options or {}
    self.Library = library
    self.Title = options.Title or "Notification"
    self.Content = options.Content or ""
    self.SubContent = options.SubContent
    self.Duration = options.Duration or 5 -- Duration in seconds, nil for persistent
    
    -- Create notification UI
    self:_createUI()
    
    -- Auto close if duration is set
    if self.Duration then
        delay(self.Duration, function()
            self:Close()
        end)
    end
    
    return self
end

-- Create the notification UI elements
function Notification:_createUI()
    -- Find or create the notification container
    local guiContainer = self:_getNotificationContainer()
    
    -- Notification frame
    self.NotificationFrame = Instance.new("Frame")
    self.NotificationFrame.Name = "Notification"
    self.NotificationFrame.Size = UDim2.new(0, 300, 0, self.SubContent and 100 or 80)
    self.NotificationFrame.Position = UDim2.new(1, 350, 1, -20)
    self.NotificationFrame.AnchorPoint = Vector2.new(1, 1)
    self.NotificationFrame.BackgroundColor3 = self.Library.Theme.GetColor("NotificationBackground")
    self.NotificationFrame.BorderSizePixel = 0
    self.NotificationFrame.Parent = guiContainer
    
    -- Corner radius
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 6)
    corner.Parent = self.NotificationFrame
    
    -- Shadow effect
    local shadow = Instance.new("ImageLabel")
    shadow.Name = "Shadow"
    shadow.Size = UDim2.new(1, 30, 1, 30)
    shadow.Position = UDim2.new(0.5, 0, 0.5, 0)
    shadow.AnchorPoint = Vector2.new(0.5, 0.5)
    shadow.BackgroundTransparency = 1
    shadow.Image = "rbxassetid://5553946656"
    shadow.ImageColor3 = Color3.fromRGB(0, 0, 0)
    shadow.ImageTransparency = 0.7
    shadow.ZIndex = -1
    shadow.Parent = self.NotificationFrame
    
    -- Title label
    self.TitleLabel = Instance.new("TextLabel")
    self.TitleLabel.Name = "Title"
    self.TitleLabel.Size = UDim2.new(1, -40, 0, 30)
    self.TitleLabel.Position = UDim2.new(0, 15, 0, 5)
    self.TitleLabel.BackgroundTransparency = 1
    self.TitleLabel.Text = self.Title
    self.TitleLabel.TextColor3 = self.Library.Theme.GetColor("NotificationTitle")
    self.TitleLabel.TextSize = 16
    self.TitleLabel.Font = Enum.Font.GothamBold
    self.TitleLabel.TextXAlignment = Enum.TextXAlignment.Left
    self.TitleLabel.Parent = self.NotificationFrame
    
    -- Close button
    self.CloseButton = Instance.new("TextButton")
    self.CloseButton.Name = "CloseButton"
    self.CloseButton.Size = UDim2.new(0, 20, 0, 20)
    self.CloseButton.Position = UDim2.new(1, -25, 0, 10)
    self.CloseButton.BackgroundTransparency = 1
    self.CloseButton.Text = "✕"
    self.CloseButton.TextColor3 = self.Library.Theme.GetColor("NotificationCloseButton")
    self.CloseButton.TextSize = 14
    self.CloseButton.Font = Enum.Font.GothamBold
    self.CloseButton.Parent = self.NotificationFrame
    
    -- Content text
    self.ContentLabel = Instance.new("TextLabel")
    self.ContentLabel.Name = "Content"
    self.ContentLabel.Size = UDim2.new(1, -30, 0, 40)
    self.ContentLabel.Position = UDim2.new(0, 15, 0, 35)
    self.ContentLabel.BackgroundTransparency = 1
    self.ContentLabel.Text = self.Content
    self.ContentLabel.TextColor3 = self.Library.Theme.GetColor("NotificationText")
    self.ContentLabel.TextSize = 14
    self.ContentLabel.Font = Enum.Font.Gotham
    self.ContentLabel.TextXAlignment = Enum.TextXAlignment.Left
    self.ContentLabel.TextWrapped = true
    self.ContentLabel.Parent = self.NotificationFrame
    
    -- Sub-content text (if provided)
    if self.SubContent then
        self.SubContentLabel = Instance.new("TextLabel")
        self.SubContentLabel.Name = "SubContent"
        self.SubContentLabel.Size = UDim2.new(1, -30, 0, 20)
        self.SubContentLabel.Position = UDim2.new(0, 15, 0, 75)
        self.SubContentLabel.BackgroundTransparency = 1
        self.SubContentLabel.Text = self.SubContent
        self.SubContentLabel.TextColor3 = self.Library.Theme.GetColor("NotificationSubText")
        self.SubContentLabel.TextSize = 12
        self.SubContentLabel.Font = Enum.Font.Gotham
        self.SubContentLabel.TextXAlignment = Enum.TextXAlignment.Left
        self.SubContentLabel.TextWrapped = true
        self.SubContentLabel.Parent = self.NotificationFrame
    end
    
    -- Progress bar (if duration is set)
    if self.Duration then
        self.ProgressBar = Instance.new("Frame")
        self.ProgressBar.Name = "ProgressBar"
        self.ProgressBar.Size = UDim2.new(1, 0, 0, 2)
        self.ProgressBar.Position = UDim2.new(0, 0, 1, -2)
        self.ProgressBar.BackgroundColor3 = self.Library.Theme.GetColor("NotificationProgress")
        self.ProgressBar.BorderSizePixel = 0
        self.ProgressBar.Parent = self.NotificationFrame
        
        -- Animate progress bar
        game:GetService("TweenService"):Create(
            self.ProgressBar, 
            TweenInfo.new(self.Duration, Enum.EasingStyle.Linear),
            {Size = UDim2.new(0, 0, 0, 2)}
        ):Play()
    end
    
    -- Connect close button
    self.CloseButton.MouseButton1Click:Connect(function()
        self:Close()
    end)
    
    -- Slide in animation
    self:_animateIn()
    
    -- Position this notification relative to others
    self:_positionWithOthers()
end

-- Get or create the notification container
function Notification:_getNotificationContainer()
    -- Try to find existing container
    local existingContainer = game:GetService("CoreGui"):FindFirstChild("SolunaNotifications")
    
    if existingContainer then
        return existingContainer
    end
    
    -- Create new container
    local container = Instance.new("ScreenGui")
    container.Name = "SolunaNotifications"
    
    -- Protect GUI if using Synapse
    if syn then
        syn.protect_gui(container)
    end
    
    -- Try to parent to CoreGui, fallback to PlayerGui
    local success, result = pcall(function()
        container.Parent = game:GetService("CoreGui")
    end)
    
    if not success then
        container.Parent = game:GetService("Players").LocalPlayer:WaitForChild("PlayerGui")
    end
    
    return container
end

-- Position this notification relative to others
function Notification:_positionWithOthers()
    local guiContainer = self:_getNotificationContainer()
    local notifications = {}
    
    -- Collect all visible notifications
    for _, child in ipairs(guiContainer:GetChildren()) do
        if child:IsA("Frame") and child.Name == "Notification" and child.Visible then
            table.insert(notifications, child)
        end
    end
    
    -- Sort by Y position (bottom to top)
    table.sort(notifications, function(a, b)
        return a.Position.Y.Offset > b.Position.Y.Offset
    end)
    
    -- Position this notification above others
    local totalHeight = 0
    for i, notif in ipairs(notifications) do
        if notif ~= self.NotificationFrame then
            totalHeight = totalHeight + notif.AbsoluteSize.Y + 10
        else
            break
        end
    end
    
    -- Set target position for animation
    self.TargetPosition = UDim2.new(1, -20, 1, -(20 + totalHeight))
end

-- Animate notification sliding in
function Notification:_animateIn()
    game:GetService("TweenService"):Create(
        self.NotificationFrame, 
        TweenInfo.new(0.5, Enum.EasingStyle.Quart, Enum.EasingDirection.Out),
        {Position = self.TargetPosition}
    ):Play()
end

-- Close the notification
function Notification:Close()
    -- Animate sliding out
    local closeTween = game:GetService("TweenService"):Create(
        self.NotificationFrame, 
        TweenInfo.new(0.5, Enum.EasingStyle.Quart, Enum.EasingDirection.In),
        {Position = UDim2.new(1, 350, self.NotificationFrame.Position.Y.Scale, self.NotificationFrame.Position.Y.Offset)}
    )
    
    closeTween:Play()
    
    -- Destroy after animation
    closeTween.Completed:Connect(function()
        self.NotificationFrame:Destroy()
        
        -- Reposition other notifications
        delay(0.1, function()
            self:_repositionOtherNotifications()
        end)
    end)
end

-- Reposition other notifications after this one is closed
function Notification:_repositionOtherNotifications()
    local guiContainer = self:_getNotificationContainer()
    local notifications = {}
    
    -- Collect all visible notifications
    for _, child in ipairs(guiContainer:GetChildren()) do
        if child:IsA("Frame") and child.Name == "Notification" and child.Visible then
            table.insert(notifications, child)
        end
    end
    
    -- Sort by Y position (bottom to top)
    table.sort(notifications, function(a, b)
        return a.Position.Y.Offset > b.Position.Y.Offset
    end)
    
    -- Reposition all notifications
    local currentHeight = 20
    for _, notif in ipairs(notifications) do
        local newPosition = UDim2.new(1, -20, 1, -currentHeight)
        
        -- Animate to new position
        game:GetService("TweenService"):Create(
            notif, 
            TweenInfo.new(0.3, Enum.EasingStyle.Quart, Enum.EasingDirection.Out),
            {Position = newPosition}
        ):Play()
        
        currentHeight = currentHeight + notif.AbsoluteSize.Y + 10
    end
end

return Notification
