--[[
    Toggle Component
    Boolean toggle switch with callback
]]

local Toggle = {}
Toggle.__index = Toggle

function Toggle.new(library, options)
    local self = setmetatable({}, Toggle)
    
    -- Default options
    options = options or {}
    self.Library = library
    self.Tab = options.Tab
    self.Name = options.Name or "Toggle"
    self.Default = options.Default or false
    self.Callback = options.Callback or function() end
    self.LayoutOrder = options.LayoutOrder or 1
    
    -- Internal properties
    self.Value = self.Default
    
    -- Create toggle UI
    self:_createUI()
    
    -- Initialize with default value
    self:SetValue(self.Default, true)
    
    return self
end

-- Create the toggle UI elements
function Toggle:_createUI()
    -- Container frame
    self.Container = Instance.new("Frame")
    self.Container.Name = self.Name .. "Toggle"
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
    self.Title.Size = UDim2.new(1, -60, 1, 0)
    self.Title.Position = UDim2.new(0, 8, 0, 0)
    self.Title.BackgroundTransparency = 1
    self.Title.Text = self.Name
    self.Title.TextColor3 = self.Library.Theme.GetColor("PrimaryText")
    self.Title.TextSize = 14
    self.Title.Font = Enum.Font.GothamMedium
    self.Title.TextXAlignment = Enum.TextXAlignment.Left
    self.Title.Parent = self.Container
    
    -- Toggle background (track)
    self.ToggleBackground = Instance.new("Frame")
    self.ToggleBackground.Name = "ToggleBackground"
    self.ToggleBackground.Size = UDim2.new(0, 40, 0, 20)
    self.ToggleBackground.Position = UDim2.new(1, -48, 0.5, -10)
    self.ToggleBackground.BackgroundColor3 = self.Library.Theme.GetColor("ToggleBackgroundOff")
    self.ToggleBackground.BorderSizePixel = 0
    self.ToggleBackground.Parent = self.Container
    
    -- Track corner radius
    local trackCorner = Instance.new("UICorner")
    trackCorner.CornerRadius = UDim.new(1, 0)
    trackCorner.Parent = self.ToggleBackground
    
    -- Toggle indicator (knob)
    self.ToggleIndicator = Instance.new("Frame")
    self.ToggleIndicator.Name = "ToggleIndicator"
    self.ToggleIndicator.Size = UDim2.new(0, 16, 0, 16)
    self.ToggleIndicator.Position = UDim2.new(0, 2, 0.5, -8)
    self.ToggleIndicator.BackgroundColor3 = self.Library.Theme.GetColor("ToggleKnob")
    self.ToggleIndicator.BorderSizePixel = 0
    self.ToggleIndicator.ZIndex = 2
    self.ToggleIndicator.Parent = self.ToggleBackground
    
    -- Knob corner radius
    local knobCorner = Instance.new("UICorner")
    knobCorner.CornerRadius = UDim.new(1, 0)
    knobCorner.Parent = self.ToggleIndicator
    
    -- Make the toggle clickable
    self.Container.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            self:Toggle()
        end
    end)
end

-- Toggle the switch
function Toggle:Toggle()
    self:SetValue(not self.Value)
end

-- Set toggle value
function Toggle:SetValue(value, noCallback)
    -- Update internal value
    self.Value = value
    
    -- Update visuals
    if value then
        -- ON state
        game:GetService("TweenService"):Create(
            self.ToggleBackground,
            TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
            {BackgroundColor3 = self.Library.Theme.GetColor("ToggleBackgroundOn")}
        ):Play()
        
        game:GetService("TweenService"):Create(
            self.ToggleIndicator,
            TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
            {Position = UDim2.new(0, 22, 0.5, -8)}
        ):Play()
    else
        -- OFF state
        game:GetService("TweenService"):Create(
            self.ToggleBackground,
            TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
            {BackgroundColor3 = self.Library.Theme.GetColor("ToggleBackgroundOff")}
        ):Play()
        
        game:GetService("TweenService"):Create(
            self.ToggleIndicator,
            TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
            {Position = UDim2.new(0, 2, 0.5, -8)}
        ):Play()
    end
    
    -- Call the callback function with the new value (unless suppressed)
    if not noCallback then
        self.Callback(value)
    end
end

-- Get current value
function Toggle:GetValue()
    return self.Value
end

-- Update theme colors
function Toggle:_updateTheme()
    self.Container.BackgroundColor3 = self.Library.Theme.GetColor("ComponentBackground")
    self.Title.TextColor3 = self.Library.Theme.GetColor("PrimaryText")
    self.ToggleIndicator.BackgroundColor3 = self.Library.Theme.GetColor("ToggleKnob")
    
    -- Update toggle background based on current value
    if self.Value then
        self.ToggleBackground.BackgroundColor3 = self.Library.Theme.GetColor("ToggleBackgroundOn")
    else
        self.ToggleBackground.BackgroundColor3 = self.Library.Theme.GetColor("ToggleBackgroundOff")
    end
end

return Toggle
