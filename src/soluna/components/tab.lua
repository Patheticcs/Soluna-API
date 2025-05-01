--[[
    Tab Component
    Container for UI elements within the window
]]

local Tab = {}
Tab.__index = Tab

-- Import component modules
local Button = require("soluna/components/button")
local Toggle = require("soluna/components/toggle")
local Slider = require("soluna/components/slider")
local Dropdown = require("soluna/components/dropdown")
local ColorPicker = require("soluna/components/colorpicker")
local Keybind = require("soluna/components/keybind")
local Input = require("soluna/components/input")
local Paragraph = require("soluna/components/paragraph")

function Tab.new(library, options)
    local self = setmetatable({}, Tab)
    
    -- Default options
    options = options or {}
    self.Library = library
    self.Window = options.Window
    self.Name = options.Name or "Tab"
    self.Icon = options.Icon -- Optional icon from Lucide
    self.LayoutOrder = options.LayoutOrder or 1
    
    -- Internal properties
    self.Components = {}
    self.Visible = false
    
    -- Create tab UI
    self:_createUI()
    
    return self
end

-- Create the tab UI elements
function Tab:_createUI()
    -- Create tab button (in sidebar)
    self.TabButton = Instance.new("TextButton")
    self.TabButton.Name = self.Name .. "Tab"
    self.TabButton.Size = UDim2.new(1, 0, 0, 32)
    self.TabButton.BackgroundColor3 = self.Library.Theme.GetColor("TabInactive")
    self.TabButton.BorderSizePixel = 0
    self.TabButton.Text = ""
    self.TabButton.AutoButtonColor = false
    self.TabButton.LayoutOrder = self.LayoutOrder
    self.TabButton.Parent = self.Window.TabContainer
    
    -- Tab button corner radius
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 4)
    corner.Parent = self.TabButton
    
    -- Icon (if provided)
    if self.Icon then
        self.IconImage = Instance.new("ImageLabel")
        self.IconImage.Name = "Icon"
        self.IconImage.Size = UDim2.new(0, 20, 0, 20)
        self.IconImage.Position = UDim2.new(0, 8, 0.5, -10)
        self.IconImage.BackgroundTransparency = 1
        self.IconImage.Image = self.Library.Icons.Get(self.Icon)
        self.IconImage.ImageColor3 = self.Library.Theme.GetColor("TabText")
        self.IconImage.Parent = self.TabButton
        
        -- Adjust label position for icon
        self.TabLabel = Instance.new("TextLabel")
        self.TabLabel.Name = "Label"
        self.TabLabel.Size = UDim2.new(1, -36, 1, 0)
        self.TabLabel.Position = UDim2.new(0, 36, 0, 0)
        self.TabLabel.BackgroundTransparency = 1
        self.TabLabel.Text = self.Name
        self.TabLabel.TextColor3 = self.Library.Theme.GetColor("TabText")
        self.TabLabel.TextSize = 14
        self.TabLabel.Font = Enum.Font.Gotham
        self.TabLabel.TextXAlignment = Enum.TextXAlignment.Left
        self.TabLabel.Parent = self.TabButton
    else
        -- No icon, center text
        self.TabLabel = Instance.new("TextLabel")
        self.TabLabel.Name = "Label"
        self.TabLabel.Size = UDim2.new(1, -16, 1, 0)
        self.TabLabel.Position = UDim2.new(0, 8, 0, 0)
        self.TabLabel.BackgroundTransparency = 1
        self.TabLabel.Text = self.Name
        self.TabLabel.TextColor3 = self.Library.Theme.GetColor("TabText")
        self.TabLabel.TextSize = 14
        self.TabLabel.Font = Enum.Font.Gotham
        self.TabLabel.TextXAlignment = Enum.TextXAlignment.Left
        self.TabLabel.Parent = self.TabButton
    end
    
    -- Content container (where all tab components will be parented)
    self.Container = Instance.new("ScrollingFrame")
    self.Container.Name = self.Name .. "Content"
    self.Container.Size = UDim2.new(1, -16, 1, -16)
    self.Container.Position = UDim2.new(0, 8, 0, 8)
    self.Container.BackgroundTransparency = 1
    self.Container.BorderSizePixel = 0
    self.Container.ScrollBarThickness = 4
    self.Container.ScrollBarImageColor3 = self.Library.Theme.GetColor("ScrollBar")
    self.Container.ScrollingDirection = Enum.ScrollingDirection.Y
    self.Container.VerticalScrollBarPosition = Enum.VerticalScrollBarPosition.Right
    self.Container.Visible = false
    self.Container.Parent = self.Window.ContentFrame
    
    -- Auto layout for content
    self.Layout = Instance.new("UIListLayout")
    self.Layout.SortOrder = Enum.SortOrder.LayoutOrder
    self.Layout.Padding = UDim.new(0, 8)
    self.Layout.Parent = self.Container
    
    -- Add padding to ensure proper spacing
    local padding = Instance.new("UIPadding")
    padding.PaddingTop = UDim.new(0, 8)
    padding.PaddingLeft = UDim.new(0, 8)
    padding.PaddingRight = UDim.new(0, 8)
    padding.PaddingBottom = UDim.new(0, 8)
    padding.Parent = self.Container
    
    -- Update canvas size when new items are added
    self.Layout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        self.Container.CanvasSize = UDim2.new(0, 0, 0, self.Layout.AbsoluteContentSize.Y + 16)
    end)
    
    -- Button click handler
    self.TabButton.MouseButton1Click:Connect(function()
        self.Window:SelectTab(self)
    end)
    
    -- Hover effect
    self.TabButton.MouseEnter:Connect(function()
        if not self.Visible then
            self.TabButton.BackgroundColor3 = self.Library.Theme.GetColor("TabHover")
        end
    end)
    
    self.TabButton.MouseLeave:Connect(function()
        if not self.Visible then
            self.TabButton.BackgroundColor3 = self.Library.Theme.GetColor("TabInactive")
        end
    end)
end

-- Show tab content
function Tab:Show()
    -- Hide all other tab contents
    for _, child in ipairs(self.Window.ContentFrame:GetChildren()) do
        if child:IsA("ScrollingFrame") then
            child.Visible = false
        end
    end
    
    -- Reset all tab button styles
    for _, tab in ipairs(self.Window.Tabs) do
        tab.TabButton.BackgroundColor3 = self.Library.Theme.GetColor("TabInactive")
        tab.Visible = false
    end
    
    -- Show this tab
    self.Container.Visible = true
    self.TabButton.BackgroundColor3 = self.Library.Theme.GetColor("TabActive")
    self.Visible = true
end

-- Hide tab content
function Tab:Hide()
    self.Container.Visible = false
    self.TabButton.BackgroundColor3 = self.Library.Theme.GetColor("TabInactive")
    self.Visible = false
end

-- Update theme colors
function Tab:_updateTheme()
    if self.Visible then
        self.TabButton.BackgroundColor3 = self.Library.Theme.GetColor("TabActive")
    else
        self.TabButton.BackgroundColor3 = self.Library.Theme.GetColor("TabInactive")
    end
    
    self.TabLabel.TextColor3 = self.Library.Theme.GetColor("TabText")
    self.Container.ScrollBarImageColor3 = self.Library.Theme.GetColor("ScrollBar")
    
    if self.Icon and self.IconImage then
        self.IconImage.ImageColor3 = self.Library.Theme.GetColor("TabText")
    end
    
    -- Update all components
    for _, component in ipairs(self.Components) do
        if component._updateTheme then
            component:_updateTheme()
        end
    end
end

-- Create button
function Tab:AddButton(options)
    options = options or {}
    options.Tab = self
    options.LayoutOrder = #self.Components + 1
    
    local button = Button.new(self.Library, options)
    table.insert(self.Components, button)
    
    return button
end

-- Create toggle
function Tab:AddToggle(options)
    options = options or {}
    options.Tab = self
    options.LayoutOrder = #self.Components + 1
    
    local toggle = Toggle.new(self.Library, options)
    table.insert(self.Components, toggle)
    
    return toggle
end

-- Create slider
function Tab:AddSlider(options)
    options = options or {}
    options.Tab = self
    options.LayoutOrder = #self.Components + 1
    
    local slider = Slider.new(self.Library, options)
    table.insert(self.Components, slider)
    
    return slider
end

-- Create dropdown (single selection)
function Tab:AddDropdown(options)
    options = options or {}
    options.Tab = self
    options.LayoutOrder = #self.Components + 1
    options.MultiSelect = false
    
    local dropdown = Dropdown.new(self.Library, options)
    table.insert(self.Components, dropdown)
    
    return dropdown
end

-- Create dropdown (multi selection)
function Tab:AddMultiDropdown(options)
    options = options or {}
    options.Tab = self
    options.LayoutOrder = #self.Components + 1
    options.MultiSelect = true
    
    local dropdown = Dropdown.new(self.Library, options)
    table.insert(self.Components, dropdown)
    
    return dropdown
end

-- Create color picker
function Tab:AddColorPicker(options)
    options = options or {}
    options.Tab = self
    options.LayoutOrder = #self.Components + 1
    
    local colorPicker = ColorPicker.new(self.Library, options)
    table.insert(self.Components, colorPicker)
    
    return colorPicker
end

-- Create keybind
function Tab:AddKeybind(options)
    options = options or {}
    options.Tab = self
    options.LayoutOrder = #self.Components + 1
    
    local keybind = Keybind.new(self.Library, options)
    table.insert(self.Components, keybind)
    
    return keybind
end

-- Create input field
function Tab:AddInput(options)
    options = options or {}
    options.Tab = self
    options.LayoutOrder = #self.Components + 1
    
    local input = Input.new(self.Library, options)
    table.insert(self.Components, input)
    
    return input
end

-- Create paragraph
function Tab:AddParagraph(options)
    options = options or {}
    options.Tab = self
    options.LayoutOrder = #self.Components + 1
    
    local paragraph = Paragraph.new(self.Library, options)
    table.insert(self.Components, paragraph)
    
    return paragraph
end

return Tab
