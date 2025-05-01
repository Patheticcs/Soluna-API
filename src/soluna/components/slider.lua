--[[
    Slider Component
    Value slider with min/max and callback
]]

local Slider = {}
Slider.__index = Slider

function Slider.new(library, options)
    local self = setmetatable({}, Slider)
    
    -- Default options
    options = options or {}
    self.Library = library
    self.Tab = options.Tab
    self.Name = options.Name or "Slider"
    self.Min = options.Min or 0
    self.Max = options.Max or 100
    self.Default = options.Default or self.Min
    self.Rounding = options.Rounding or 1
    self.Callback = options.Callback or function() end
    self.LayoutOrder = options.LayoutOrder or 1
    
    -- Internal properties
    self.Value = self.Default
    self.Dragging = false
    
    -- Create slider UI
    self:_createUI()
    
    -- Initialize with default value
    self:SetValue(self.Default, true)
    
    return self
end

-- Create the slider UI elements
function Slider:_createUI()
    -- Container frame
    self.Container = Instance.new("Frame")
    self.Container.Name = self.Name .. "Slider"
    self.Container.Size = UDim2.new(1, 0, 0, 50)
    self.Container.BackgroundColor3 = self.Library.Theme.GetColor("ComponentBackground")
    self.Container.BorderSizePixel = 0
    self.Container.LayoutOrder = self.LayoutOrder
    self.Container.Parent = self.Tab.Container
    
    -- Corner radius
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 4)
    corner.Parent = self.Container
    
    -- Title and value display
    self.TitleDisplay = Instance.new("Frame")
    self.TitleDisplay.Name = "TitleDisplay"
    self.TitleDisplay.Size = UDim2.new(1, -16, 0, 20)
    self.TitleDisplay.Position = UDim2.new(0, 8, 0, 5)
    self.TitleDisplay.BackgroundTransparency = 1
    self.TitleDisplay.Parent = self.Container
    
    -- Title label
    self.Title = Instance.new("TextLabel")
    self.Title.Name = "Title"
    self.Title.Size = UDim2.new(0.7, 0, 1, 0)
    self.Title.BackgroundTransparency = 1
    self.Title.Text = self.Name
    self.Title.TextColor3 = self.Library.Theme.GetColor("PrimaryText")
    self.Title.TextSize = 14
    self.Title.Font = Enum.Font.GothamMedium
    self.Title.TextXAlignment = Enum.TextXAlignment.Left
    self.Title.Parent = self.TitleDisplay
    
    -- Value display
    self.ValueDisplay = Instance.new("TextBox")
    self.ValueDisplay.Name = "Value"
    self.ValueDisplay.Size = UDim2.new(0.3, 0, 1, 0)
    self.ValueDisplay.Position = UDim2.new(0.7, 0, 0, 0)
    self.ValueDisplay.BackgroundTransparency = 1
    self.ValueDisplay.Text = tostring(self.Value)
    self.ValueDisplay.TextColor3 = self.Library.Theme.GetColor("SecondaryText")
    self.ValueDisplay.TextSize = 14
    self.ValueDisplay.Font = Enum.Font.Gotham
    self.ValueDisplay.TextXAlignment = Enum.TextXAlignment.Right
    self.ValueDisplay.ClearTextOnFocus = false
    self.ValueDisplay.Parent = self.TitleDisplay
    
    -- Slider track
    self.SliderTrack = Instance.new("Frame")
    self.SliderTrack.Name = "SliderTrack"
    self.SliderTrack.Size = UDim2.new(1, -16, 0, 6)
    self.SliderTrack.Position = UDim2.new(0, 8, 0, 34)
    self.SliderTrack.BackgroundColor3 = self.Library.Theme.GetColor("SliderBackground")
    self.SliderTrack.BorderSizePixel = 0
    self.SliderTrack.Parent = self.Container
    
    -- Track corner radius
    local trackCorner = Instance.new("UICorner")
    trackCorner.CornerRadius = UDim.new(1, 0)
    trackCorner.Parent = self.SliderTrack
    
    -- Slider fill
    self.SliderFill = Instance.new("Frame")
    self.SliderFill.Name = "SliderFill"
    self.SliderFill.Size = UDim2.new(0.5, 0, 1, 0)
    self.SliderFill.BackgroundColor3 = self.Library.Theme.GetColor("SliderFill")
    self.SliderFill.BorderSizePixel = 0
    self.SliderFill.Parent = self.SliderTrack
    
    -- Fill corner radius
    local fillCorner = Instance.new("UICorner")
    fillCorner.CornerRadius = UDim.new(1, 0)
    fillCorner.Parent = self.SliderFill
    
    -- Slider knob
    self.SliderKnob = Instance.new("Frame")
    self.SliderKnob.Name = "SliderKnob"
    self.SliderKnob.Size = UDim2.new(0, 16, 0, 16)
    self.SliderKnob.Position = UDim2.new(0.5, -8, 0.5, -8)
    self.SliderKnob.AnchorPoint = Vector2.new(0, 0.5)
    self.SliderKnob.BackgroundColor3 = self.Library.Theme.GetColor("SliderKnob")
    self.SliderKnob.BorderSizePixel = 0
    self.SliderKnob.ZIndex = 2
    self.SliderKnob.Parent = self.SliderFill
    
    -- Knob corner radius
    local knobCorner = Instance.new("UICorner")
    knobCorner.CornerRadius = UDim.new(1, 0)
    knobCorner.Parent = self.SliderKnob
    
    -- Handle drag events
    self:_setupDragEvents()
    
    -- Handle typing in the value display
    self.ValueDisplay.FocusLost:Connect(function(enterPressed)
        if enterPressed then
            local inputValue = tonumber(self.ValueDisplay.Text)
            if inputValue then
                self:SetValue(inputValue)
            else
                self.ValueDisplay.Text = self:_roundValue(self.Value)
            end
        else
            self.ValueDisplay.Text = self:_roundValue(self.Value)
        end
    end)
end

-- Setup drag events
function Slider:_setupDragEvents()
    -- Track mouse input
    local inputService = game:GetService("UserInputService")
    local dragging = false
    
    -- Mouse down on slider track
    self.SliderTrack.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
            self:_updateSliderFromMouse(input.Position.X)
        end
    end)
    
    -- Mouse down on slider knob
    self.SliderKnob.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
        end
    end)
    
    -- Mouse move while dragging
    inputService.InputChanged:Connect(function(input)
        if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
            self:_updateSliderFromMouse(input.Position.X)
        end
    end)
    
    -- Mouse up to stop dragging
    inputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = false
        end
    end)
end

-- Update slider value from mouse position
function Slider:_updateSliderFromMouse(mouseX)
    -- Calculate relative position within track
    local trackPosition = self.SliderTrack.AbsolutePosition.X
    local trackSize = self.SliderTrack.AbsoluteSize.X
    
    -- Calculate normalized position (0-1)
    local normalizedPosition = math.clamp((mouseX - trackPosition) / trackSize, 0, 1)
    
    -- Map to value range and set
    local newValue = self.Min + (self.Max - self.Min) * normalizedPosition
    self:SetValue(newValue)
end

-- Round value to specified decimal places
function Slider:_roundValue(value)
    if self.Rounding == 0 then
        return math.floor(value)
    end
    
    local mult = 10 ^ self.Rounding
    return math.floor(value * mult + 0.5) / mult
end

-- Set slider value
function Slider:SetValue(value, noCallback)
    -- Clamp to min/max range
    value = math.clamp(value, self.Min, self.Max)
    
    -- Apply rounding
    value = self:_roundValue(value)
    
    -- Update internal value
    self.Value = value
    
    -- Update visuals
    local normalizedValue = (value - self.Min) / (self.Max - self.Min)
    
    -- Update slider fill and knob position
    self.SliderFill.Size = UDim2.new(normalizedValue, 0, 1, 0)
    self.ValueDisplay.Text = tostring(value)
    
    -- Call the callback function with the new value (unless suppressed)
    if not noCallback then
        self.Callback(value)
    end
end

-- Get current value
function Slider:GetValue()
    return self.Value
end

-- Set min and max values
function Slider:SetMinMax(min, max)
    if min >= max then return end
    
    self.Min = min
    self.Max = max
    
    -- Adjust current value if needed
    if self.Value < min then
        self:SetValue(min)
    elseif self.Value > max then
        self:SetValue(max)
    else
        -- Just update the visuals since min/max changed
        self:SetValue(self.Value)
    end
end

-- Update theme colors
function Slider:_updateTheme()
    self.Container.BackgroundColor3 = self.Library.Theme.GetColor("ComponentBackground")
    self.Title.TextColor3 = self.Library.Theme.GetColor("PrimaryText")
    self.ValueDisplay.TextColor3 = self.Library.Theme.GetColor("SecondaryText")
    self.SliderTrack.BackgroundColor3 = self.Library.Theme.GetColor("SliderBackground")
    self.SliderFill.BackgroundColor3 = self.Library.Theme.GetColor("SliderFill")
    self.SliderKnob.BackgroundColor3 = self.Library.Theme.GetColor("SliderKnob")
end

return Slider
