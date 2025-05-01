--[[
    ColorPicker Component
    RGB color selection with optional transparency
]]

local ColorPicker = {}
ColorPicker.__index = ColorPicker

function ColorPicker.new(library, options)
    local self = setmetatable({}, ColorPicker)
    
    -- Default options
    options = options or {}
    self.Library = library
    self.Tab = options.Tab
    self.Name = options.Name or "Color Picker"
    self.Default = options.Default or Color3.fromRGB(255, 255, 255)
    self.DefaultTransparency = options.DefaultTransparency or 0
    self.ShowTransparency = options.ShowTransparency ~= nil and options.ShowTransparency or true
    self.Callback = options.Callback or function() end
    self.LayoutOrder = options.LayoutOrder or 1
    
    -- Internal properties
    self.Value = self.Default
    self.Transparency = self.DefaultTransparency
    self.Open = false
    self.Dragging = {
        Color = false,
        Hue = false,
        Transparency = false
    }
    self.HSV = {H = 0, S = 0, V = 1}
    
    -- Create UI
    self:_createUI()
    
    -- Initialize with default color
    self:SetColor(self.Default, self.DefaultTransparency, true)
    
    return self
end

-- Create the color picker UI elements
function ColorPicker:_createUI()
    -- Container frame
    self.Container = Instance.new("Frame")
    self.Container.Name = self.Name .. "ColorPicker"
    self.Container.Size = UDim2.new(1, 0, 0, 50)
    self.Container.BackgroundColor3 = self.Library.Theme.GetColor("ComponentBackground")
    self.Container.BorderSizePixel = 0
    self.Container.ClipsDescendants = true
    self.Container.LayoutOrder = self.LayoutOrder
    self.Container.Parent = self.Tab.Container
    
    -- Corner radius
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 4)
    corner.Parent = self.Container
    
    -- Title label
    self.Title = Instance.new("TextLabel")
    self.Title.Name = "Title"
    self.Title.Size = UDim2.new(1, -60, 0, 20)
    self.Title.Position = UDim2.new(0, 8, 0, 5)
    self.Title.BackgroundTransparency = 1
    self.Title.Text = self.Name
    self.Title.TextColor3 = self.Library.Theme.GetColor("PrimaryText")
    self.Title.TextSize = 14
    self.Title.Font = Enum.Font.GothamMedium
    self.Title.TextXAlignment = Enum.TextXAlignment.Left
    self.Title.Parent = self.Container
    
    -- Color preview box
    self.ColorPreview = Instance.new("Frame")
    self.ColorPreview.Name = "ColorPreview"
    self.ColorPreview.Size = UDim2.new(0, 30, 0, 30)
    self.ColorPreview.Position = UDim2.new(1, -40, 0, 10)
    self.ColorPreview.BackgroundColor3 = self.Value
    self.ColorPreview.BorderSizePixel = 0
    self.ColorPreview.Parent = self.Container
    
    -- Preview corner radius
    local previewCorner = Instance.new("UICorner")
    previewCorner.CornerRadius = UDim.new(0, 4)
    previewCorner.Parent = self.ColorPreview
    
    -- Create checker pattern for transparency visualization
    self:_createTransparencyPattern(self.ColorPreview)
    
    -- Color picker window (expanded when opened)
    self.PickerWindow = Instance.new("Frame")
    self.PickerWindow.Name = "PickerWindow"
    self.PickerWindow.Size = UDim2.new(1, -16, 0, 0) -- Will be resized when opened
    self.PickerWindow.Position = UDim2.new(0, 8, 0, 50)
    self.PickerWindow.BackgroundColor3 = self.Library.Theme.GetColor("DropdownContentBackground")
    self.PickerWindow.BorderSizePixel = 0
    self.PickerWindow.Visible = false
    self.PickerWindow.ZIndex = 5
    self.PickerWindow.Parent = self.Container
    
    -- Picker window corner radius
    local windowCorner = Instance.new("UICorner")
    windowCorner.CornerRadius = UDim.new(0, 4)
    windowCorner.Parent = self.PickerWindow
    
    -- Create color picker elements
    self:_createPickerElements()
    
    -- Toggle picker on preview click
    self.ColorPreview.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            self:Toggle()
        end
    end)
    
    -- Close picker when clicking outside
    game:GetService("UserInputService").InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 and self.Open then
            local mousePos = game:GetService("UserInputService"):GetMouseLocation()
            local pickerPosition = self.PickerWindow.AbsolutePosition
            local pickerSize = self.PickerWindow.AbsoluteSize
            
            -- Check if click is outside the picker window
            if mousePos.X < pickerPosition.X or mousePos.X > pickerPosition.X + pickerSize.X or
               mousePos.Y < pickerPosition.Y or mousePos.Y > pickerPosition.Y + pickerSize.Y then
                -- Also make sure it's not on the color preview
                local previewPosition = self.ColorPreview.AbsolutePosition
                local previewSize = self.ColorPreview.AbsoluteSize
                
                if mousePos.X < previewPosition.X or mousePos.X > previewPosition.X + previewSize.X or
                   mousePos.Y < previewPosition.Y or mousePos.Y > previewPosition.Y + previewSize.Y then
                    self:Close()
                end
            end
        end
    end)
end

-- Create transparency checkerboard pattern
function ColorPicker:_createTransparencyPattern(parent)
    local pattern = Instance.new("Frame")
    pattern.Name = "TransparencyPattern"
    pattern.Size = UDim2.new(1, 0, 1, 0)
    pattern.BackgroundTransparency = 1
    pattern.ClipsDescendants = true
    pattern.ZIndex = parent.ZIndex - 1
    pattern.Parent = parent
    
    -- Create checkerboard pattern
    local tileSize = 5
    local tiles = {}
    local isWhite = true
    
    for x = 0, math.ceil(parent.AbsoluteSize.X / tileSize) do
        for y = 0, math.ceil(parent.AbsoluteSize.Y / tileSize) do
            local tile = Instance.new("Frame")
            tile.Size = UDim2.new(0, tileSize, 0, tileSize)
            tile.Position = UDim2.new(0, x * tileSize, 0, y * tileSize)
            tile.BorderSizePixel = 0
            tile.ZIndex = parent.ZIndex - 1
            
            if isWhite then
                tile.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
            else
                tile.BackgroundColor3 = Color3.fromRGB(200, 200, 200)
            end
            
            tile.Parent = pattern
            table.insert(tiles, tile)
            isWhite = not isWhite
        end
        -- Offset pattern for next row
        isWhite = not isWhite
    end
end

-- Create color picker elements inside the picker window
function ColorPicker:_createPickerElements()
    -- Calculate window height
    local windowHeight = self.ShowTransparency and 185 or 160
    self.WindowHeight = windowHeight
    
    -- Color saturation/value selector
    self.SaturationValue = Instance.new("ImageLabel")
    self.SaturationValue.Name = "SaturationValue"
    self.SaturationValue.Size = UDim2.new(1, -20, 0, 120)
    self.SaturationValue.Position = UDim2.new(0, 10, 0, 10)
    self.SaturationValue.BackgroundColor3 = Color3.fromRGB(255, 0, 0) -- Will be updated based on hue
    self.SaturationValue.BorderSizePixel = 0
    self.SaturationValue.Image = "rbxassetid://4155801252" -- Saturation/value gradient
    self.SaturationValue.ZIndex = 6
    self.SaturationValue.Parent = self.PickerWindow
    
    -- Saturation/Value corner radius
    local svCorner = Instance.new("UICorner")
    svCorner.CornerRadius = UDim.new(0, 4)
    svCorner.Parent = self.SaturationValue
    
    -- Saturation/Value selector cursor
    self.SVCursor = Instance.new("Frame")
    self.SVCursor.Name = "Cursor"
    self.SVCursor.Size = UDim2.new(0, 10, 0, 10)
    self.SVCursor.AnchorPoint = Vector2.new(0.5, 0.5)
    self.SVCursor.Position = UDim2.new(1, 0, 0, 0)
    self.SVCursor.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    self.SVCursor.BorderSizePixel = 0
    self.SVCursor.ZIndex = 7
    self.SVCursor.Parent = self.SaturationValue
    
    -- Cursor corner radius
    local cursorCorner = Instance.new("UICorner")
    cursorCorner.CornerRadius = UDim.new(1, 0)
    cursorCorner.Parent = self.SVCursor
    
    -- Cursor outline
    local cursorOutline = Instance.new("UIStroke")
    cursorOutline.Color = Color3.fromRGB(0, 0, 0)
    cursorOutline.Thickness = 1
    cursorOutline.Transparency = 0.5
    cursorOutline.Parent = self.SVCursor
    
    -- Hue slider
    self.HueSlider = Instance.new("ImageLabel")
    self.HueSlider.Name = "HueSlider"
    self.HueSlider.Size = UDim2.new(1, -20, 0, 15)
    self.HueSlider.Position = UDim2.new(0, 10, 0, 135)
    self.HueSlider.BackgroundTransparency = 1
    self.HueSlider.Image = "rbxassetid://3283651682" -- Hue gradient
    self.HueSlider.ZIndex = 6
    self.HueSlider.Parent = self.PickerWindow
    
    -- Hue slider corner radius
    local hueCorner = Instance.new("UICorner")
    hueCorner.CornerRadius = UDim.new(0, 4)
    hueCorner.Parent = self.HueSlider
    
    -- Hue slider cursor
    self.HueCursor = Instance.new("Frame")
    self.HueCursor.Name = "Cursor"
    self.HueCursor.Size = UDim2.new(0, 5, 1, 0)
    self.HueCursor.Position = UDim2.new(0, 0, 0, 0)
    self.HueCursor.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    self.HueCursor.BorderSizePixel = 0
    self.HueCursor.ZIndex = 7
    self.HueCursor.Parent = self.HueSlider
    
    -- Hue cursor corner radius
    local hueCursorCorner = Instance.new("UICorner")
    hueCursorCorner.CornerRadius = UDim.new(0, 2)
    hueCursorCorner.Parent = self.HueCursor
    
    -- Transparency slider (if enabled)
    if self.ShowTransparency then
        self.TransparencySlider = Instance.new("Frame")
        self.TransparencySlider.Name = "TransparencySlider"
        self.TransparencySlider.Size = UDim2.new(1, -20, 0, 15)
        self.TransparencySlider.Position = UDim2.new(0, 10, 0, 155)
        self.TransparencySlider.BackgroundColor3 = self.Value
        self.TransparencySlider.BorderSizePixel = 0
        self.TransparencySlider.ZIndex = 6
        self.TransparencySlider.Parent = self.PickerWindow
        
        -- Create transparency gradient
        local transparencyGradient = Instance.new("UIGradient")
        transparencyGradient.Transparency = NumberSequence.new({
            NumberSequenceKeypoint.new(0, 0),
            NumberSequenceKeypoint.new(1, 1)
        })
        transparencyGradient.Parent = self.TransparencySlider
        
        -- Create checker pattern for transparency visualization
        self:_createTransparencyPattern(self.TransparencySlider)
        
        -- Transparency slider corner radius
        local transparencyCorner = Instance.new("UICorner")
        transparencyCorner.CornerRadius = UDim.new(0, 4)
        transparencyCorner.Parent = self.TransparencySlider
        
        -- Transparency slider cursor
        self.TransparencyCursor = Instance.new("Frame")
        self.TransparencyCursor.Name = "Cursor"
        self.TransparencyCursor.Size = UDim2.new(0, 5, 1, 0)
        self.TransparencyCursor.Position = UDim2.new(0, 0, 0, 0)
        self.TransparencyCursor.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
        self.TransparencyCursor.BorderSizePixel = 0
        self.TransparencyCursor.ZIndex = 7
        self.TransparencyCursor.Parent = self.TransparencySlider
        
        -- Transparency cursor corner radius
        local transparencyCursorCorner = Instance.new("UICorner")
        transparencyCursorCorner.CornerRadius = UDim.new(0, 2)
        transparencyCursorCorner.Parent = self.TransparencyCursor
    end
    
    -- Setup event handlers for color selection
    self:_setupColorEvents()
end

-- Setup event handlers for the color picker
function ColorPicker:_setupColorEvents()
    local inputService = game:GetService("UserInputService")
    
    -- Saturation/Value selector
    self.SaturationValue.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            self.Dragging.Color = true
            self:_updateColorSelection(input.Position.X, input.Position.Y)
        end
    end)
    
    -- Hue slider
    self.HueSlider.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            self.Dragging.Hue = true
            self:_updateHueSelection(input.Position.X)
        end
    end)
    
    -- Transparency slider
    if self.ShowTransparency then
        self.TransparencySlider.InputBegan:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 then
                self.Dragging.Transparency = true
                self:_updateTransparencySelection(input.Position.X)
            end
        end)
    end
    
    -- Mouse movement while dragging
    inputService.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement then
            if self.Dragging.Color then
                self:_updateColorSelection(input.Position.X, input.Position.Y)
            elseif self.Dragging.Hue then
                self:_updateHueSelection(input.Position.X)
            elseif self.Dragging.Transparency then
                self:_updateTransparencySelection(input.Position.X)
            end
        end
    end)
    
    -- Stop dragging on mouse up
    inputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            self.Dragging.Color = false
            self.Dragging.Hue = false
            self.Dragging.Transparency = false
        end
    end)
end

-- Update color selection from saturation/value picker
function ColorPicker:_updateColorSelection(mouseX, mouseY)
    local svPosition = self.SaturationValue.AbsolutePosition
    local svSize = self.SaturationValue.AbsoluteSize
    
    -- Calculate normalized position (0-1)
    local saturation = math.clamp((mouseX - svPosition.X) / svSize.X, 0, 1)
    local value = 1 - math.clamp((mouseY - svPosition.Y) / svSize.Y, 0, 1)
    
    -- Update cursor position
    self.SVCursor.Position = UDim2.new(saturation, 0, 1 - value, 0)
    
    -- Update HSV values
    self.HSV.S = saturation
    self.HSV.V = value
    
    -- Update color
    self:_updateColorFromHSV()
end

-- Update hue selection from hue slider
function ColorPicker:_updateHueSelection(mouseX)
    local huePosition = self.HueSlider.AbsolutePosition
    local hueSize = self.HueSlider.AbsoluteSize
    
    -- Calculate normalized position (0-1)
    local hue = math.clamp((mouseX - huePosition.X) / hueSize.X, 0, 1)
    
    -- Update cursor position
    self.HueCursor.Position = UDim2.new(hue, 0, 0, 0)
    
    -- Update HSV values
    self.HSV.H = hue
    
    -- Update saturation/value background color
    self.SaturationValue.BackgroundColor3 = Color3.fromHSV(hue, 1, 1)
    
    -- Update color
    self:_updateColorFromHSV()
end

-- Update transparency selection from transparency slider
function ColorPicker:_updateTransparencySelection(mouseX)
    if not self.ShowTransparency then return end
    
    local transparencyPosition = self.TransparencySlider.AbsolutePosition
    local transparencySize = self.TransparencySlider.AbsoluteSize
    
    -- Calculate normalized position (0-1)
    local transparency = math.clamp((mouseX - transparencyPosition.X) / transparencySize.X, 0, 1)
    
    -- Update cursor position
    self.TransparencyCursor.Position = UDim2.new(transparency, 0, 0, 0)
    
    -- Update transparency value
    self.Transparency = transparency
    
    -- Update color
    self:_updateColorFromHSV()
end

-- Convert HSV to RGB and update the color
function ColorPicker:_updateColorFromHSV()
    -- Convert HSV to RGB
    local color = Color3.fromHSV(self.HSV.H, self.HSV.S, self.HSV.V)
    
    -- Update the color preview
    self.ColorPreview.BackgroundColor3 = color
    
    -- Update transparency slider color if exists
    if self.ShowTransparency then
        self.TransparencySlider.BackgroundColor3 = color
    end
    
    -- Update the internal value
    self.Value = color
    
    -- Call the callback
    self.Callback(color, self.Transparency)
end

-- Toggle color picker open/closed
function ColorPicker:Toggle()
    if self.Open then
        self:Close()
    else
        self:Open()
    end
end

-- Open the color picker
function ColorPicker:Open()
    self.Open = true
    
    -- Show content
    self.PickerWindow.Visible = true
    
    -- Resize container to fit content
    local newContainerHeight = 50 + self.WindowHeight
    
    game:GetService("TweenService"):Create(
        self.Container,
        TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
        {Size = UDim2.new(1, 0, 0, newContainerHeight)}
    ):Play()
    
    game:GetService("TweenService"):Create(
        self.PickerWindow,
        TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
        {Size = UDim2.new(1, -16, 0, self.WindowHeight)}
    ):Play()
end

-- Close the color picker
function ColorPicker:Close()
    self.Open = false
    
    -- Resize container to default
    game:GetService("TweenService"):Create(
        self.Container,
        TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
        {Size = UDim2.new(1, 0, 0, 50)}
    ):Play()
    
    game:GetService("TweenService"):Create(
        self.PickerWindow,
        TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
        {Size = UDim2.new(1, -16, 0, 0)}
    ):Play()
    
    -- Hide content after animation
    delay(0.2, function()
        if not self.Open then
            self.PickerWindow.Visible = false
        end
    end)
end

-- Set color programmatically
function ColorPicker:SetColor(color, transparency, noCallback)
    -- Convert Color3 to HSV
    local h, s, v = color:ToHSV()
    
    -- Update internal HSV values
    self.HSV = {H = h, S = s, V = v}
    
    -- Update transparency value if provided
    if transparency ~= nil then
        self.Transparency = transparency
    end
    
    -- Update UI elements
    self.ColorPreview.BackgroundColor3 = color
    
    if self.Open then
        -- Update hue slider background and cursor
        self.SaturationValue.BackgroundColor3 = Color3.fromHSV(h, 1, 1)
        self.HueCursor.Position = UDim2.new(h, 0, 0, 0)
        
        -- Update saturation/value cursor
        self.SVCursor.Position = UDim2.new(s, 0, 1 - v, 0)
        
        -- Update transparency slider if exists
        if self.ShowTransparency then
            self.TransparencySlider.BackgroundColor3 = color
            self.TransparencyCursor.Position = UDim2.new(self.Transparency, 0, 0, 0)
        end
    end
    
    -- Update the internal value
    self.Value = color
    
    -- Call the callback unless suppressed
    if not noCallback then
        self.Callback(color, self.Transparency)
    end
end

-- Get current color
function ColorPicker:GetColor()
    return self.Value, self.Transparency
end

-- Update theme colors
function ColorPicker:_updateTheme()
    self.Container.BackgroundColor3 = self.Library.Theme.GetColor("ComponentBackground")
    self.Title.TextColor3 = self.Library.Theme.GetColor("PrimaryText")
    self.PickerWindow.BackgroundColor3 = self.Library.Theme.GetColor("DropdownContentBackground")
end

return ColorPicker
