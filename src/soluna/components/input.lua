--[[
    Input Component
    Text input field with callback
]]

local Input = {}
Input.__index = Input

function Input.new(library, options)
    local self = setmetatable({}, Input)
    
    -- Default options
    options = options or {}
    self.Library = library
    self.Tab = options.Tab
    self.Name = options.Name or "Input"
    self.PlaceholderText = options.PlaceholderText or "Enter text..."
    self.Default = options.Default or ""
    self.NumericOnly = options.NumericOnly or false
    self.Callback = options.Callback or function() end
    self.CallbackOnlyOnEnter = options.CallbackOnlyOnEnter or false
    self.LayoutOrder = options.LayoutOrder or 1
    
    -- Internal properties
    self.Value = self.Default
    
    -- Create input UI
    self:_createUI()
    
    -- Initialize with default value
    self:SetValue(self.Default, true)
    
    return self
end

-- Create the input UI elements
function Input:_createUI()
    -- Container frame
    self.Container = Instance.new("Frame")
    self.Container.Name = self.Name .. "Input"
    self.Container.Size = UDim2.new(1, 0, 0, 50)
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
    self.Title.Position = UDim2.new(0, 8, 0, 5)
    self.Title.BackgroundTransparency = 1
    self.Title.Text = self.Name
    self.Title.TextColor3 = self.Library.Theme.GetColor("PrimaryText")
    self.Title.TextSize = 14
    self.Title.Font = Enum.Font.GothamMedium
    self.Title.TextXAlignment = Enum.TextXAlignment.Left
    self.Title.Parent = self.Container
    
    -- Input box
    self.InputBox = Instance.new("TextBox")
    self.InputBox.Name = "InputBox"
    self.InputBox.Size = UDim2.new(1, -16, 0, 24)
    self.InputBox.Position = UDim2.new(0, 8, 0, 25)
    self.InputBox.BackgroundColor3 = self.Library.Theme.GetColor("InputBackground")
    self.InputBox.Text = self.Default
    self.InputBox.PlaceholderText = self.PlaceholderText
    self.InputBox.PlaceholderColor3 = self.Library.Theme.GetColor("PlaceholderText")
    self.InputBox.TextColor3 = self.Library.Theme.GetColor("InputText")
    self.InputBox.TextSize = 14
    self.InputBox.Font = Enum.Font.Gotham
    self.InputBox.TextXAlignment = Enum.TextXAlignment.Left
    self.InputBox.ClearTextOnFocus = false
    self.InputBox.ClipsDescendants = true
    self.InputBox.Parent = self.Container
    
    -- Add padding to text
    local padding = Instance.new("UIPadding")
    padding.PaddingLeft = UDim.new(0, 8)
    padding.PaddingRight = UDim.new(0, 8)
    padding.Parent = self.InputBox
    
    -- Input corner radius
    local inputCorner = Instance.new("UICorner")
    inputCorner.CornerRadius = UDim.new(0, 4)
    inputCorner.Parent = self.InputBox
    
    -- Connect input events
    self.InputBox.FocusLost:Connect(function(enterPressed)
        local newValue = self.InputBox.Text
        
        -- Apply numeric filter if needed
        if self.NumericOnly then
            local numericValue = tonumber(newValue)
            if numericValue then
                newValue = tostring(numericValue)
            else
                -- Revert to previous valid value
                newValue = tostring(self.Value)
                self.InputBox.Text = newValue
            end
        end
        
        -- Update value
        self.Value = newValue
        
        -- Call the callback if enter was pressed or the setting doesn't require it
        if enterPressed or not self.CallbackOnlyOnEnter then
            self.Callback(newValue)
        end
    end)
    
    -- Input hover effect
    self.InputBox.MouseEnter:Connect(function()
        self.InputBox.BackgroundColor3 = self.Library.Theme.GetColor("InputBackgroundHover")
    end)
    
    self.InputBox.MouseLeave:Connect(function()
        self.InputBox.BackgroundColor3 = self.Library.Theme.GetColor("InputBackground")
    end)
    
    -- Only allow numeric input if specified
    self.InputBox.Changed:Connect(function(property)
        if property == "Text" and self.NumericOnly then
            local text = self.InputBox.Text
            if text ~= "" and not tonumber(text) then
                -- Remove non-numeric characters
                self.InputBox.Text = text:gsub("[^%d%.%-]", "")
            end
        end
    end)
end

-- Set input value
function Input:SetValue(value, noCallback)
    -- Convert to string for display
    value = tostring(value)
    
    -- Update input box text
    self.InputBox.Text = value
    
    -- Update internal value
    self.Value = value
    
    -- Call the callback function with the new value (unless suppressed)
    if not noCallback then
        self.Callback(value)
    end
end

-- Get current value
function Input:GetValue()
    return self.Value
end

-- Update theme colors
function Input:_updateTheme()
    self.Container.BackgroundColor3 = self.Library.Theme.GetColor("ComponentBackground")
    self.Title.TextColor3 = self.Library.Theme.GetColor("PrimaryText")
    self.InputBox.BackgroundColor3 = self.Library.Theme.GetColor("InputBackground")
    self.InputBox.TextColor3 = self.Library.Theme.GetColor("InputText")
    self.InputBox.PlaceholderColor3 = self.Library.Theme.GetColor("PlaceholderText")
end

return Input
