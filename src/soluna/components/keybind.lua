--[[
    Keybind Component
    Key binding with callback
]]

local Keybind = {}
Keybind.__index = Keybind

function Keybind.new(library, options)
    local self = setmetatable({}, Keybind)
    
    -- Default options
    options = options or {}
    self.Library = library
    self.Tab = options.Tab
    self.Name = options.Name or "Keybind"
    self.Default = options.Default or Enum.KeyCode.Unknown
    self.Mode = options.Mode or "Toggle" -- "Toggle", "Hold", "Always"
    self.OnClick = options.OnClick or function() end
    self.OnChanged = options.OnChanged or function() end
    self.LayoutOrder = options.LayoutOrder or 1
    
    -- Internal properties
    self.Value = self.Default
    self.State = false
    self.Binding = false
    
    -- Create keybind UI
    self:_createUI()
    
    -- Set initial keybind
    self:SetKeybind(self.Default, true)
    
    -- Setup input monitoring
    self:_setupInputHandling()
    
    return self
end

-- Create the keybind UI elements
function Keybind:_createUI()
    -- Container frame
    self.Container = Instance.new("Frame")
    self.Container.Name = self.Name .. "Keybind"
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
    self.Title.Size = UDim2.new(1, -120, 1, 0)
    self.Title.Position = UDim2.new(0, 8, 0, 0)
    self.Title.BackgroundTransparency = 1
    self.Title.Text = self.Name
    self.Title.TextColor3 = self.Library.Theme.GetColor("PrimaryText")
    self.Title.TextSize = 14
    self.Title.Font = Enum.Font.GothamMedium
    self.Title.TextXAlignment = Enum.TextXAlignment.Left
    self.Title.Parent = self.Container
    
    -- Mode label
    self.ModeLabel = Instance.new("TextLabel")
    self.ModeLabel.Name = "ModeLabel"
    self.ModeLabel.Size = UDim2.new(0, 60, 1, 0)
    self.ModeLabel.Position = UDim2.new(1, -110, 0, 0)
    self.ModeLabel.BackgroundTransparency = 1
    self.ModeLabel.Text = "("..self.Mode..")"
    self.ModeLabel.TextColor3 = self.Library.Theme.GetColor("SecondaryText")
    self.ModeLabel.TextSize = 12
    self.ModeLabel.Font = Enum.Font.Gotham
    self.ModeLabel.TextXAlignment = Enum.TextXAlignment.Left
    self.ModeLabel.Parent = self.Container
    
    -- Keybind button
    self.KeybindButton = Instance.new("TextButton")
    self.KeybindButton.Name = "KeybindButton"
    self.KeybindButton.Size = UDim2.new(0, 50, 0, 24)
    self.KeybindButton.Position = UDim2.new(1, -58, 0.5, -12)
    self.KeybindButton.BackgroundColor3 = self.Library.Theme.GetColor("InputBackground")
    self.KeybindButton.Text = "?"
    self.KeybindButton.TextColor3 = self.Library.Theme.GetColor("InputText")
    self.KeybindButton.TextSize = 14
    self.KeybindButton.Font = Enum.Font.Gotham
    self.KeybindButton.AutoButtonColor = false
    self.KeybindButton.Parent = self.Container
    
    -- Button corner radius
    local btnCorner = Instance.new("UICorner")
    btnCorner.CornerRadius = UDim.new(0, 4)
    btnCorner.Parent = self.KeybindButton
    
    -- Button hover effect
    self.KeybindButton.MouseEnter:Connect(function()
        self.KeybindButton.BackgroundColor3 = self.Library.Theme.GetColor("InputBackgroundHover")
    end)
    
    self.KeybindButton.MouseLeave:Connect(function()
        self.KeybindButton.BackgroundColor3 = self.Library.Theme.GetColor("InputBackground")
    end)
    
    -- Button click handler to start binding
    self.KeybindButton.MouseButton1Click:Connect(function()
        self:_beginBinding()
    end)
end

-- Begin binding a new key
function Keybind:_beginBinding()
    -- Already binding, cancel
    if self.Binding then
        self:_cancelBinding()
        return
    end
    
    -- Set binding state
    self.Binding = true
    self.KeybindButton.Text = "..."
    self.KeybindButton.TextColor3 = self.Library.Theme.GetColor("AccentText")
end

-- Cancel key binding
function Keybind:_cancelBinding()
    self.Binding = false
    self:_updateButtonText()
    self.KeybindButton.TextColor3 = self.Library.Theme.GetColor("InputText")
end

-- Update button text to show current keybind
function Keybind:_updateButtonText()
    if self.Value == Enum.KeyCode.Unknown then
        self.KeybindButton.Text = "?"
    else
        -- Convert KeyCode to readable text
        local keyName = tostring(self.Value):gsub("Enum.KeyCode.", "")
        self.KeybindButton.Text = keyName
    end
end

-- Setup input handling for keybind
function Keybind:_setupInputHandling()
    -- Track input service
    local inputService = game:GetService("UserInputService")
    
    -- Key binding input handler
    inputService.InputBegan:Connect(function(input, gameProcessed)
        -- Don't process if game already handled the input
        if gameProcessed then return end
        
        -- If currently binding, set the new key
        if self.Binding then
            -- Check for key input
            if input.UserInputType == Enum.UserInputType.Keyboard then
                -- Set the new keybind
                self:SetKeybind(input.KeyCode)
                
                -- End binding mode
                self.Binding = false
                self.KeybindButton.TextColor3 = self.Library.Theme.GetColor("InputText")
            end
            return
        end
        
        -- Check if the input matches our keybind
        if input.KeyCode == self.Value then
            -- Handle according to mode
            if self.Mode == "Toggle" then
                self.State = not self.State
                self.OnClick(self.State)
            elseif self.Mode == "Hold" then
                self.State = true
                self.OnClick(true)
            elseif self.Mode == "Always" then
                self.OnClick()
            end
        end
    end)
    
    -- For "Hold" mode, track key releases
    inputService.InputEnded:Connect(function(input, gameProcessed)
        if gameProcessed then return end
        
        if input.KeyCode == self.Value and self.Mode == "Hold" and self.State then
            self.State = false
            self.OnClick(false)
        end
    end)
end

-- Set keybind value
function Keybind:SetKeybind(keyCode, noCallback)
    -- Update internal value
    self.Value = keyCode
    
    -- Update button text
    self:_updateButtonText()
    
    -- Call the callback function with the new value (unless suppressed)
    if not noCallback then
        self.OnChanged(keyCode)
    end
end

-- Get current keybind
function Keybind:GetKeybind()
    return self.Value
end

-- Get current state (for Toggle and Hold modes)
function Keybind:GetState()
    return self.State
end

-- Set state (for Toggle and Hold modes)
function Keybind:SetState(state, noCallback)
    if self.Mode == "Always" then return end
    
    -- Update state
    self.State = state
    
    -- Call callback if not suppressed
    if not noCallback then
        self.OnClick(state)
    end
end

-- Set mode
function Keybind:SetMode(mode)
    if mode ~= "Toggle" and mode ~= "Hold" and mode ~= "Always" then
        return
    end
    
    self.Mode = mode
    self.ModeLabel.Text = "("..mode..")"
    
    -- Reset state if changing to Always mode
    if mode == "Always" and self.State then
        self.State = false
    end
end

-- Update theme colors
function Keybind:_updateTheme()
    self.Container.BackgroundColor3 = self.Library.Theme.GetColor("ComponentBackground")
    self.Title.TextColor3 = self.Library.Theme.GetColor("PrimaryText")
    self.ModeLabel.TextColor3 = self.Library.Theme.GetColor("SecondaryText")
    self.KeybindButton.BackgroundColor3 = self.Library.Theme.GetColor("InputBackground")
    
    -- Only update text color if not currently binding
    if not self.Binding then
        self.KeybindButton.TextColor3 = self.Library.Theme.GetColor("InputText")
    else
        self.KeybindButton.TextColor3 = self.Library.Theme.GetColor("AccentText")
    end
end

return Keybind
