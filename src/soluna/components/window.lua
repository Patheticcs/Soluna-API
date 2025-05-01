--[[
    Window Component
    Main container for UI elements
]]

local Window = {}
Window.__index = Window

-- Import dependencies
local Tab = require("soluna/components/tab")
local Utils = require("soluna/utils/utils")

-- Create a new window
function Window.new(library, options)
    local self = setmetatable({}, Window)
    
    -- Default options
    options = options or {}
    self.Library = library
    self.Title = options.Title or "Soluna"
    self.Subtitle = options.Subtitle or ""
    self.Size = options.Size or {X = 550, Y = 600}
    self.MinimizeKey = options.MinimizeKey or Enum.KeyCode.RightShift
    self.Acrylic = options.Acrylic ~= nil and options.Acrylic or true
    self.TabWidth = options.TabWidth or 150
    
    -- Internal properties
    self.Tabs = {}
    self.ActiveTab = nil
    self.Minimized = false
    
    -- Create window UI
    self:_createUI()
    
    -- Setup minimize keybind
    self:_setupMinimizeKey()
    
    return self
end

-- Create the window UI elements
function Window:_createUI()
    -- Create the main frame
    self.Container = Instance.new("ScreenGui")
    self.Container.Name = "SolunaUI"
    self.Container.ResetOnSpawn = false
    
    -- Protect GUI from game
    if syn then
        syn.protect_gui(self.Container)
    end
    
    -- Parent to CoreGui or PlayerGui as fallback
    local success, result = pcall(function()
        self.Container.Parent = game:GetService("CoreGui")
    end)
    
    if not success then
        self.Container.Parent = game:GetService("Players").LocalPlayer:WaitForChild("PlayerGui")
    end
    
    -- Main window frame
    self.MainFrame = Instance.new("Frame")
    self.MainFrame.Name = "MainFrame"
    self.MainFrame.Size = UDim2.new(0, self.Size.X, 0, self.Size.Y)
    self.MainFrame.Position = UDim2.new(0.5, -self.Size.X/2, 0.5, -self.Size.Y/2)
    self.MainFrame.BackgroundColor3 = self.Library.Theme.GetColor("Background")
    self.MainFrame.BorderSizePixel = 0
    self.MainFrame.Parent = self.Container
    
    -- Apply corner radius
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 8)
    corner.Parent = self.MainFrame
    
    -- Apply acrylic effect if enabled
    if self.Acrylic then
        local blur = Instance.new("BlurEffect")
        blur.Size = 10
        blur.Parent = game:GetService("Lighting")
        self.BlurEffect = blur
        
        -- Make background slightly transparent
        self.MainFrame.BackgroundTransparency = 0.1
    end
    
    -- Create title bar
    self:_createTitleBar()
    
    -- Create content area
    self:_createContentArea()
    
    -- Make window draggable
    Utils.MakeDraggable(self.MainFrame, self.TitleBar)
end

-- Create the title bar
function Window:_createTitleBar()
    self.TitleBar = Instance.new("Frame")
    self.TitleBar.Name = "TitleBar"
    self.TitleBar.Size = UDim2.new(1, 0, 0, 30)
    self.TitleBar.Position = UDim2.new(0, 0, 0, 0)
    self.TitleBar.BackgroundColor3 = self.Library.Theme.GetColor("TitleBackground")
    self.TitleBar.BorderSizePixel = 0
    self.TitleBar.Parent = self.MainFrame
    
    -- Apply corner radius (only top corners)
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 8)
    corner.Parent = self.TitleBar
    
    -- Corner fix
    local fix = Instance.new("Frame")
    fix.Name = "CornerFix"
    fix.Size = UDim2.new(1, 0, 0.5, 0)
    fix.Position = UDim2.new(0, 0, 0.5, 0)
    fix.BackgroundColor3 = self.Library.Theme.GetColor("TitleBackground")
    fix.BorderSizePixel = 0
    fix.ZIndex = 0
    fix.Parent = self.TitleBar
    
    -- Title label
    self.TitleLabel = Instance.new("TextLabel")
    self.TitleLabel.Name = "Title"
    self.TitleLabel.Size = UDim2.new(1, -10, 1, 0)
    self.TitleLabel.Position = UDim2.new(0, 10, 0, 0)
    self.TitleLabel.BackgroundTransparency = 1
    self.TitleLabel.Text = self.Title
    self.TitleLabel.TextColor3 = self.Library.Theme.GetColor("TitleText")
    self.TitleLabel.TextSize = 16
    self.TitleLabel.Font = Enum.Font.GothamSemibold
    self.TitleLabel.TextXAlignment = Enum.TextXAlignment.Left
    self.TitleLabel.Parent = self.TitleBar
    
    -- Subtitle label
    if self.Subtitle and self.Subtitle ~= "" then
        self.SubtitleLabel = Instance.new("TextLabel")
        self.SubtitleLabel.Name = "Subtitle"
        self.SubtitleLabel.Size = UDim2.new(0.5, 0, 1, 0)
        self.SubtitleLabel.Position = UDim2.new(0.5, 0, 0, 0)
        self.SubtitleLabel.BackgroundTransparency = 1
        self.SubtitleLabel.Text = self.Subtitle
        self.SubtitleLabel.TextColor3 = self.Library.Theme.GetColor("SubtitleText")
        self.SubtitleLabel.TextSize = 14
        self.SubtitleLabel.Font = Enum.Font.Gotham
        self.SubtitleLabel.TextXAlignment = Enum.TextXAlignment.Right
        self.SubtitleLabel.Parent = self.TitleBar
    end
end

-- Create the content area
function Window:_createContentArea()
    -- Tab container (sidebar)
    self.TabContainer = Instance.new("Frame")
    self.TabContainer.Name = "TabContainer"
    self.TabContainer.Size = UDim2.new(0, self.TabWidth, 1, -30)
    self.TabContainer.Position = UDim2.new(0, 0, 0, 30)
    self.TabContainer.BackgroundColor3 = self.Library.Theme.GetColor("TabBackground")
    self.TabContainer.BorderSizePixel = 0
    self.TabContainer.Parent = self.MainFrame
    
    -- Tab list layout
    self.TabListLayout = Instance.new("UIListLayout")
    self.TabListLayout.SortOrder = Enum.SortOrder.LayoutOrder
    self.TabListLayout.Padding = UDim.new(0, 2)
    self.TabListLayout.Parent = self.TabContainer
    
    -- Content frame (where tab content will be displayed)
    self.ContentFrame = Instance.new("Frame")
    self.ContentFrame.Name = "ContentFrame"
    self.ContentFrame.Size = UDim2.new(1, -self.TabWidth, 1, -30)
    self.ContentFrame.Position = UDim2.new(0, self.TabWidth, 0, 30)
    self.ContentFrame.BackgroundColor3 = self.Library.Theme.GetColor("ContentBackground")
    self.ContentFrame.BorderSizePixel = 0
    self.ContentFrame.Parent = self.MainFrame
end

-- Setup minimize key
function Window:_setupMinimizeKey()
    -- Connect input event
    game:GetService("UserInputService").InputBegan:Connect(function(input, gameProcessed)
        if not gameProcessed and input.KeyCode == self.MinimizeKey then
            self:ToggleMinimize()
        end
    end)
end

-- Toggle window minimize state
function Window:ToggleMinimize()
    self.Minimized = not self.Minimized
    self.MainFrame.Visible = not self.Minimized
end

-- Create a new tab
function Window:AddTab(options)
    options = options or {}
    options.Window = self
    options.LayoutOrder = #self.Tabs + 1
    
    local tab = Tab.new(self.Library, options)
    table.insert(self.Tabs, tab)
    
    -- Set as active tab if first one
    if #self.Tabs == 1 then
        self:SelectTab(tab)
    end
    
    return tab
end

-- Select a tab
function Window:SelectTab(tab)
    -- Hide current active tab if exists
    if self.ActiveTab then
        self.ActiveTab:Hide()
    end
    
    -- Show new tab
    tab:Show()
    self.ActiveTab = tab
end

-- Change theme
function Window:SetTheme(theme)
    self.Library.Theme.SetTheme(theme)
    self:_updateTheme()
end

-- Update UI with current theme
function Window:_updateTheme()
    self.MainFrame.BackgroundColor3 = self.Library.Theme.GetColor("Background")
    self.TitleBar.BackgroundColor3 = self.Library.Theme.GetColor("TitleBackground")
    self.TitleLabel.TextColor3 = self.Library.Theme.GetColor("TitleText")
    self.TabContainer.BackgroundColor3 = self.Library.Theme.GetColor("TabBackground")
    self.ContentFrame.BackgroundColor3 = self.Library.Theme.GetColor("ContentBackground")
    
    -- Update subtitle if it exists
    if self.SubtitleLabel then
        self.SubtitleLabel.TextColor3 = self.Library.Theme.GetColor("SubtitleText")
    end
    
    -- Update all tabs
    for _, tab in ipairs(self.Tabs) do
        tab:_updateTheme()
    end
end

-- Toggle acrylic effect
function Window:ToggleAcrylic(enabled)
    self.Acrylic = enabled
    
    if enabled then
        -- Create blur effect if it doesn't exist
        if not self.BlurEffect then
            local blur = Instance.new("BlurEffect")
            blur.Size = 10
            blur.Parent = game:GetService("Lighting")
            self.BlurEffect = blur
        end
        
        -- Make background slightly transparent
        self.MainFrame.BackgroundTransparency = 0.1
    else
        -- Remove blur effect if it exists
        if self.BlurEffect then
            self.BlurEffect:Destroy()
            self.BlurEffect = nil
        end
        
        -- Make background fully opaque
        self.MainFrame.BackgroundTransparency = 0
    end
end

-- Set window size
function Window:SetSize(width, height)
    self.Size = {X = width, Y = height}
    self.MainFrame.Size = UDim2.new(0, width, 0, height)
    self.MainFrame.Position = UDim2.new(0.5, -width/2, 0.5, -height/2)
end

-- Set tab width
function Window:SetTabWidth(width)
    self.TabWidth = width
    self.TabContainer.Size = UDim2.new(0, width, 1, -30)
    self.ContentFrame.Size = UDim2.new(1, -width, 1, -30)
    self.ContentFrame.Position = UDim2.new(0, width, 0, 30)
end

return Window
