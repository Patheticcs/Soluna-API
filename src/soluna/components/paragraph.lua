--[[
    Paragraph Component
    Multi-line text display
]]

local Paragraph = {}
Paragraph.__index = Paragraph

function Paragraph.new(library, options)
    local self = setmetatable({}, Paragraph)
    
    -- Default options
    options = options or {}
    self.Library = library
    self.Tab = options.Tab
    self.Title = options.Title or "Paragraph"
    self.Content = options.Content or ""
    self.LayoutOrder = options.LayoutOrder or 1
    
    -- Create paragraph UI
    self:_createUI()
    
    return self
end

-- Create the paragraph UI elements
function Paragraph:_createUI()
    -- Container frame
    self.Container = Instance.new("Frame")
    self.Container.Name = self.Title .. "Paragraph"
    self.Container.Size = UDim2.new(1, 0, 0, 0) -- Will be auto-sized based on content
    self.Container.BackgroundColor3 = self.Library.Theme.GetColor("ComponentBackground")
    self.Container.BorderSizePixel = 0
    self.Container.AutomaticSize = Enum.AutomaticSize.Y
    self.Container.LayoutOrder = self.LayoutOrder
    self.Container.Parent = self.Tab.Container
    
    -- Corner radius
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 4)
    corner.Parent = self.Container
    
    -- Title label
    self.TitleLabel = Instance.new("TextLabel")
    self.TitleLabel.Name = "Title"
    self.TitleLabel.Size = UDim2.new(1, -16, 0, 24)
    self.TitleLabel.Position = UDim2.new(0, 8, 0, 8)
    self.TitleLabel.BackgroundTransparency = 1
    self.TitleLabel.Text = self.Title
    self.TitleLabel.TextColor3 = self.Library.Theme.GetColor("PrimaryText")
    self.TitleLabel.TextSize = 14
    self.TitleLabel.Font = Enum.Font.GothamBold
    self.TitleLabel.TextXAlignment = Enum.TextXAlignment.Left
    self.TitleLabel.Parent = self.Container
    
    -- Content text
    self.ContentLabel = Instance.new("TextLabel")
    self.ContentLabel.Name = "Content"
    self.ContentLabel.Size = UDim2.new(1, -16, 0, 0)
    self.ContentLabel.Position = UDim2.new(0, 8, 0, 32)
    self.ContentLabel.BackgroundTransparency = 1
    self.ContentLabel.Text = self.Content
    self.ContentLabel.TextColor3 = self.Library.Theme.GetColor("SecondaryText")
    self.ContentLabel.TextSize = 14
    self.ContentLabel.Font = Enum.Font.Gotham
    self.ContentLabel.TextXAlignment = Enum.TextXAlignment.Left
    self.ContentLabel.TextYAlignment = Enum.TextYAlignment.Top
    self.ContentLabel.TextWrapped = true
    self.ContentLabel.AutomaticSize = Enum.AutomaticSize.Y
    self.ContentLabel.Parent = self.Container
    
    -- Add padding at the bottom
    local padding = Instance.new("UIPadding")
    padding.PaddingBottom = UDim.new(0, 8)
    padding.Parent = self.Container
end

-- Set paragraph content
function Paragraph:SetContent(content)
    self.Content = content
    self.ContentLabel.Text = content
end

-- Set paragraph title
function Paragraph:SetTitle(title)
    self.Title = title
    self.TitleLabel.Text = title
end

-- Update theme colors
function Paragraph:_updateTheme()
    self.Container.BackgroundColor3 = self.Library.Theme.GetColor("ComponentBackground")
    self.TitleLabel.TextColor3 = self.Library.Theme.GetColor("PrimaryText")
    self.ContentLabel.TextColor3 = self.Library.Theme.GetColor("SecondaryText")
end

return Paragraph
