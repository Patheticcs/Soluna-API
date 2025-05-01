--[[
    Button Component
    Clickable button with callback
]]

local Button = {}
Button.__index = Button

function Button.new(library, options)
    local self = setmetatable({}, Button)
    
    -- Default options
    options = options or {}
    self.Library = library
    self.Tab = options.Tab
    self.Name = options.Name or "Button"
    self.Callback = options.Callback or function() end
    self.LayoutOrder = options.LayoutOrder or 1
    self.ConfirmPrompt = options.ConfirmPrompt
    
    -- Create button UI
    self:_createUI()
    
    return self
end

-- Create the button UI elements
function Button:_createUI()
    -- Container frame
    self.Container = Instance.new("Frame")
    self.Container.Name = self.Name .. "Button"
    self.Container.Size = UDim2.new(1, 0, 0, 40)
    self.Container.BackgroundColor3 = self.Library.Theme.GetColor("ComponentBackground")
    self.Container.BorderSizePixel = 0
    self.Container.LayoutOrder = self.LayoutOrder
    self.Container.Parent = self.Tab.Container
    
    -- Corner radius
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 4)
    corner.Parent = self.Container
    
    -- Title label
    self.Title = Instance.new("TextLabel")
    self.Title.Name = "Title"
    self.Title.Size = UDim2.new(1, -16, 0, 20)
    self.Title.Position = UDim2.new(0, 8, 0, 4)
    self.Title.BackgroundTransparency = 1
    self.Title.Text = self.Name
    self.Title.TextColor3 = self.Library.Theme.GetColor("PrimaryText")
    self.Title.TextSize = 14
    self.Title.Font = Enum.Font.GothamMedium
    self.Title.TextXAlignment = Enum.TextXAlignment.Left
    self.Title.Parent = self.Container
    
    -- Button
    self.ButtonFrame = Instance.new("TextButton")
    self.ButtonFrame.Name = "Button"
    self.ButtonFrame.Size = UDim2.new(1, -16, 0, 24)
    self.ButtonFrame.Position = UDim2.new(0, 8, 0, 8)
    self.ButtonFrame.AnchorPoint = Vector2.new(0, 0)
    self.ButtonFrame.BackgroundColor3 = self.Library.Theme.GetColor("ButtonBackground")
    self.ButtonFrame.Text = "Click Me"
    self.ButtonFrame.TextColor3 = self.Library.Theme.GetColor("ButtonText")
    self.ButtonFrame.TextSize = 14
    self.ButtonFrame.Font = Enum.Font.Gotham
    self.ButtonFrame.AutoButtonColor = false
    self.ButtonFrame.Parent = self.Container
    
    -- Button corner radius
    local btnCorner = Instance.new("UICorner")
    btnCorner.CornerRadius = UDim.new(0, 4)
    btnCorner.Parent = self.ButtonFrame
    
    -- Click animation effect
    local clickEffect = Instance.new("Frame")
    clickEffect.Name = "ClickEffect"
    clickEffect.Size = UDim2.new(1, 0, 1, 0)
    clickEffect.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    clickEffect.BackgroundTransparency = 1
    clickEffect.BorderSizePixel = 0
    clickEffect.ZIndex = 10
    clickEffect.Parent = self.ButtonFrame
    
    local clickCorner = Instance.new("UICorner")
    clickCorner.CornerRadius = UDim.new(0, 4)
    clickCorner.Parent = clickEffect
    
    -- Connect events
    self.ButtonFrame.MouseButton1Click:Connect(function()
        self:_onClick()
    end)
    
    -- Button hover/click effects
    self.ButtonFrame.MouseEnter:Connect(function()
        self.ButtonFrame.BackgroundColor3 = self.Library.Theme.GetColor("ButtonHover")
    end)
    
    self.ButtonFrame.MouseLeave:Connect(function()
        self.ButtonFrame.BackgroundColor3 = self.Library.Theme.GetColor("ButtonBackground")
    end)
    
    self.ButtonFrame.MouseButton1Down:Connect(function()
        self.ButtonFrame.BackgroundColor3 = self.Library.Theme.GetColor("ButtonPress")
        
        -- Show click animation
        clickEffect.BackgroundTransparency = 0.7
        game:GetService("TweenService"):Create(
            clickEffect, 
            TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
            {BackgroundTransparency = 1}
        ):Play()
    end)
    
    self.ButtonFrame.MouseButton1Up:Connect(function()
        self.ButtonFrame.BackgroundColor3 = self.Library.Theme.GetColor("ButtonHover")
    end)
end

-- Handle button click
function Button:_onClick()
    if self.ConfirmPrompt then
        -- Create confirmation dialog
        local dialog = Instance.new("Frame")
        dialog.Name = "ConfirmDialog"
        dialog.Size = UDim2.new(0, 220, 0, 120)
        dialog.Position = UDim2.new(0.5, -110, 0.5, -60)
        dialog.BackgroundColor3 = self.Library.Theme.GetColor("DialogBackground")
        dialog.BorderSizePixel = 0
        dialog.ZIndex = 100
        dialog.Parent = self.Library.Windows[1].Container
        
        -- Dialog corner radius
        local corner = Instance.new("UICorner")
        corner.CornerRadius = UDim.new(0, 6)
        corner.Parent = dialog
        
        -- Dialog shadow
        local shadow = Instance.new("ImageLabel")
        shadow.Name = "Shadow"
        shadow.Size = UDim2.new(1, 30, 1, 30)
        shadow.Position = UDim2.new(0.5, 0, 0.5, 0)
        shadow.AnchorPoint = Vector2.new(0.5, 0.5)
        shadow.BackgroundTransparency = 1
        shadow.Image = "rbxassetid://5553946656"
        shadow.ImageColor3 = Color3.fromRGB(0, 0, 0)
        shadow.ImageTransparency = 0.6
        shadow.ZIndex = 99
        shadow.Parent = dialog
        
        -- Message title
        local title = Instance.new("TextLabel")
        title.Name = "Title"
        title.Size = UDim2.new(1, -20, 0, 30)
        title.Position = UDim2.new(0, 10, 0, 10)
        title.BackgroundTransparency = 1
        title.Text = "Confirm Action"
        title.TextColor3 = self.Library.Theme.GetColor("DialogTitle")
        title.TextSize = 16
        title.Font = Enum.Font.GothamBold
        title.ZIndex = 101
        title.Parent = dialog
        
        -- Message content
        local message = Instance.new("TextLabel")
        message.Name = "Message"
        message.Size = UDim2.new(1, -20, 0, 30)
        message.Position = UDim2.new(0, 10, 0, 40)
        message.BackgroundTransparency = 1
        message.Text = self.ConfirmPrompt
        message.TextColor3 = self.Library.Theme.GetColor("DialogText")
        message.TextSize = 14
        message.Font = Enum.Font.Gotham
        message.TextWrapped = true
        message.ZIndex = 101
        message.Parent = dialog
        
        -- Confirm button
        local confirmBtn = Instance.new("TextButton")
        confirmBtn.Name = "ConfirmButton"
        confirmBtn.Size = UDim2.new(0, 90, 0, 30)
        confirmBtn.Position = UDim2.new(0, 10, 1, -40)
        confirmBtn.BackgroundColor3 = self.Library.Theme.GetColor("SuccessBackground")
        confirmBtn.Text = "Confirm"
        confirmBtn.TextColor3 = self.Library.Theme.GetColor("ButtonText")
        confirmBtn.TextSize = 14
        confirmBtn.Font = Enum.Font.Gotham
        confirmBtn.ZIndex = 101
        confirmBtn.Parent = dialog
        
        -- Confirm button corner radius
        local confirmCorner = Instance.new("UICorner")
        confirmCorner.CornerRadius = UDim.new(0, 4)
        confirmCorner.Parent = confirmBtn
        
        -- Cancel button
        local cancelBtn = Instance.new("TextButton")
        cancelBtn.Name = "CancelButton"
        cancelBtn.Size = UDim2.new(0, 90, 0, 30)
        cancelBtn.Position = UDim2.new(1, -100, 1, -40)
        cancelBtn.BackgroundColor3 = self.Library.Theme.GetColor("DangerBackground")
        cancelBtn.Text = "Cancel"
        cancelBtn.TextColor3 = self.Library.Theme.GetColor("ButtonText")
        cancelBtn.TextSize = 14
        cancelBtn.Font = Enum.Font.Gotham
        cancelBtn.ZIndex = 101
        cancelBtn.Parent = dialog
        
        -- Cancel button corner radius
        local cancelCorner = Instance.new("UICorner")
        cancelCorner.CornerRadius = UDim.new(0, 4)
        cancelCorner.Parent = cancelBtn
        
        -- Button hover effects
        confirmBtn.MouseEnter:Connect(function()
            confirmBtn.BackgroundColor3 = self.Library.Theme.GetColor("SuccessBackgroundHover")
        end)
        
        confirmBtn.MouseLeave:Connect(function()
            confirmBtn.BackgroundColor3 = self.Library.Theme.GetColor("SuccessBackground")
        end)
        
        cancelBtn.MouseEnter:Connect(function()
            cancelBtn.BackgroundColor3 = self.Library.Theme.GetColor("DangerBackgroundHover")
        end)
        
        cancelBtn.MouseLeave:Connect(function()
            cancelBtn.BackgroundColor3 = self.Library.Theme.GetColor("DangerBackground")
        end)
        
        -- Button click handlers
        confirmBtn.MouseButton1Click:Connect(function()
            dialog:Destroy()
            self.Callback()
        end)
        
        cancelBtn.MouseButton1Click:Connect(function()
            dialog:Destroy()
        end)
    else
        -- No confirmation needed, call callback directly
        self.Callback()
    end
end

-- Update theme colors
function Button:_updateTheme()
    self.Container.BackgroundColor3 = self.Library.Theme.GetColor("ComponentBackground")
    self.Title.TextColor3 = self.Library.Theme.GetColor("PrimaryText")
    self.ButtonFrame.BackgroundColor3 = self.Library.Theme.GetColor("ButtonBackground")
    self.ButtonFrame.TextColor3 = self.Library.Theme.GetColor("ButtonText")
end

-- Set button text
function Button:SetText(text)
    self.ButtonFrame.Text = text
end

-- Enable or disable the button
function Button:SetEnabled(enabled)
    self.ButtonFrame.Active = enabled
    
    if enabled then
        self.ButtonFrame.BackgroundColor3 = self.Library.Theme.GetColor("ButtonBackground")
        self.ButtonFrame.TextColor3 = self.Library.Theme.GetColor("ButtonText")
    else
        self.ButtonFrame.BackgroundColor3 = self.Library.Theme.GetColor("DisabledBackground")
        self.ButtonFrame.TextColor3 = self.Library.Theme.GetColor("DisabledText")
    end
end

return Button
