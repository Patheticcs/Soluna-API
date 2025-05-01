-- Soluna/init.lua
local Soluna = {
    Version = "1.0.0",
    Components = {},
    Themes = {},
    Config = {},
    Utility = {}
}

-- Import dependencies
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local HttpService = game:GetService("HttpService")

-- Utility functions
function Soluna.Utility.Create(instanceType, properties)
    local instance = Instance.new(instanceType)
    for property, value in pairs(properties) do
        instance[property] = value
    end
    return instance
end

function Soluna.Utility.DeepCopy(original)
    local copy = {}
    for k, v in pairs(original) do
        if type(v) == "table" then
            v = Soluna.Utility.DeepCopy(v)
        end
        copy[k] = v
    end
    return copy
end

-- Theme management
Soluna.Themes.Current = {
    Primary = Color3.fromRGB(0, 120, 215),
    Secondary = Color3.fromRGB(30, 30, 30),
    Background = Color3.fromRGB(20, 20, 20),
    Text = Color3.fromRGB(240, 240, 240),
    Accent = Color3.fromRGB(0, 180, 255),
    Error = Color3.fromRGB(255, 60, 60),
    Success = Color3.fromRGB(60, 255, 60),
    Warning = Color3.fromRGB(255, 180, 60)
}

function Soluna.Themes.SetTheme(themeTable)
    Soluna.Themes.Current = Soluna.Utility.DeepCopy(themeTable)
end

-- Configuration management
function Soluna.Config.Save(name, data, ignoreTheme)
    local saveData = Soluna.Utility.DeepCopy(data)
    if ignoreTheme then
        saveData.Theme = nil
    end
    local json = HttpService:JSONEncode(saveData)
    -- Implementation for saving to Roblox datastores or files
end

function Soluna.Config.Load(name)
    -- Implementation for loading from Roblox datastores or files
    -- Return decoded data
end

-- Window component
function Soluna.Components.Window(options)
    local window = {
        Title = options.Title or "Window",
        SubTitle = options.SubTitle or "",
        Size = options.Size or UDim2.new(0, 400, 0, 500),
        Position = options.Position or UDim2.new(0.5, -200, 0.5, -250),
        Acrylic = options.Acrylic or false,
        Minimized = false,
        ToggleKey = options.ToggleKey or Enum.KeyCode.RightShift,
        Tabs = {},
        ActiveTab = nil
    }

    -- Create UI elements
    local screenGui = Soluna.Utility.Create("ScreenGui", {
        Name = "SolunaWindow_" .. window.Title,
        ResetOnSpawn = false
    })

    local mainFrame = Soluna.Utility.Create("Frame", {
        Name = "MainFrame",
        Size = window.Size,
        Position = window.Position,
        BackgroundColor3 = Soluna.Themes.Current.Background,
        BackgroundTransparency = window.Acrylic and 0.2 or 0,
        AnchorPoint = Vector2.new(0.5, 0.5),
        Parent = screenGui
    })

    -- Add blur effect if acrylic
    if window.Acrylic then
        local blur = Soluna.Utility.Create("BlurEffect", {
            Name = "Blur",
            Size = 10,
            Parent = mainFrame
        })
    end

    -- Title bar
    local titleBar = Soluna.Utility.Create("Frame", {
        Name = "TitleBar",
        Size = UDim2.new(1, 0, 0, 40),
        BackgroundColor3 = Soluna.Themes.Current.Primary,
        BackgroundTransparency = 0,
        Parent = mainFrame
    })

    -- Add title text
    local titleText = Soluna.Utility.Create("TextLabel", {
        Name = "TitleText",
        Size = UDim2.new(0.7, 0, 1, 0),
        Position = UDim2.new(0, 10, 0, 0),
        BackgroundTransparency = 1,
        Text = window.Title,
        TextColor3 = Soluna.Themes.Current.Text,
        TextXAlignment = Enum.TextXAlignment.Left,
        Font = Enum.Font.GothamBold,
        TextSize = 18,
        Parent = titleBar
    })

    -- Add subtitle text if exists
    if window.SubTitle ~= "" then
        local subTitleText = Soluna.Utility.Create("TextLabel", {
            Name = "SubTitleText",
            Size = UDim2.new(0.7, 0, 1, 0),
            Position = UDim2.new(0, 10, 0, 20),
            BackgroundTransparency = 1,
            Text = window.SubTitle,
            TextColor3 = Color3.new(0.8, 0.8, 0.8),
            TextXAlignment = Enum.TextXAlignment.Left,
            Font = Enum.Font.Gotham,
            TextSize = 14,
            Parent = titleBar
        })
    end

    -- Add close button
    local closeButton = Soluna.Utility.Create("TextButton", {
        Name = "CloseButton",
        Size = UDim2.new(0, 40, 0, 40),
        Position = UDim2.new(1, -40, 0, 0),
        BackgroundColor3 = Color3.new(1, 0.2, 0.2),
        BackgroundTransparency = 0,
        Text = "X",
        TextColor3 = Color3.new(1, 1, 1),
        Font = Enum.Font.GothamBold,
        TextSize = 18,
        Parent = titleBar
    })

    closeButton.MouseButton1Click:Connect(function()
        screenGui:Destroy()
    end)

    -- Add minimize button
    local minimizeButton = Soluna.Utility.Create("TextButton", {
        Name = "MinimizeButton",
        Size = UDim2.new(0, 40, 0, 40),
        Position = UDim2.new(1, -80, 0, 0),
        BackgroundColor3 = Soluna.Themes.Current.Secondary,
        BackgroundTransparency = 0,
        Text = "_",
        TextColor3 = Color3.new(1, 1, 1),
        Font = Enum.Font.GothamBold,
        TextSize = 18,
        Parent = titleBar
    })

    -- Tab container
    local tabContainer = Soluna.Utility.Create("Frame", {
        Name = "TabContainer",
        Size = UDim2.new(1, 0, 0, 40),
        Position = UDim2.new(0, 0, 0, 40),
        BackgroundColor3 = Soluna.Themes.Current.Secondary,
        BackgroundTransparency = 0,
        Parent = mainFrame
    })

    local tabListLayout = Soluna.Utility.Create("UIListLayout", {
        Name = "TabListLayout",
        FillDirection = Enum.FillDirection.Horizontal,
        SortOrder = Enum.SortOrder.LayoutOrder,
        Parent = tabContainer
    })

    -- Content area
    local contentArea = Soluna.Utility.Create("Frame", {
        Name = "ContentArea",
        Size = UDim2.new(1, -20, 1, -100),
        Position = UDim2.new(0, 10, 0, 90),
        BackgroundTransparency = 1,
        ClipsDescendants = true,
        Parent = mainFrame
    })

    local contentScrolling = Soluna.Utility.Create("ScrollingFrame", {
        Name = "ContentScrolling",
        Size = UDim2.new(1, 0, 1, 0),
        BackgroundTransparency = 1,
        ScrollBarThickness = 5,
        CanvasSize = UDim2.new(0, 0, 0, 0),
        Parent = contentArea
    })

    local contentLayout = Soluna.Utility.Create("UIListLayout", {
        Name = "ContentLayout",
        SortOrder = Enum.SortOrder.LayoutOrder,
        Padding = UDim.new(0, 5),
        Parent = contentScrolling
    })

    -- Add tab function
    function window:AddTab(name, icon)
        local tab = {
            Name = name,
            Icon = icon,
            Content = {}
        }

        local tabButton = Soluna.Utility.Create("TextButton", {
            Name = "Tab_" .. name,
            Size = UDim2.new(0, 100, 1, 0),
            BackgroundColor3 = Soluna.Themes.Current.Secondary,
            BackgroundTransparency = 0,
            Text = name,
            TextColor3 = Soluna.Themes.Current.Text,
            Font = Enum.Font.Gotham,
            TextSize = 14,
            LayoutOrder = #window.Tabs + 1,
            Parent = tabContainer
        })

        -- Add icon if provided
        if icon then
            -- Implementation for Lucide icons would go here
            -- This would involve creating ImageLabels with the appropriate icons
        end

        -- Tab selection logic
        tabButton.MouseButton1Click:Connect(function()
            window:SetActiveTab(name)
        end)

        table.insert(window.Tabs, tab)
        
        if #window.Tabs == 1 then
            window:SetActiveTab(name)
        end

        return tab
    end

    -- Set active tab function
    function window:SetActiveTab(name)
        for _, tab in ipairs(self.Tabs) do
            local tabButton = tabContainer:FindFirstChild("Tab_" .. tab.Name)
            if tabButton then
                if tab.Name == name then
                    tabButton.BackgroundColor3 = Soluna.Themes.Current.Primary
                    self.ActiveTab = tab
                    -- Show content for this tab
                else
                    tabButton.BackgroundColor3 = Soluna.Themes.Current.Secondary
                    -- Hide content for other tabs
                end
            end
        end
    end

    -- Minimize toggle function
    function window:ToggleMinimize()
        self.Minimized = not self.Minimized
        if self.Minimized then
            -- Tween to minimized state
        else
            -- Tween to normal state
        end
    end

    -- Keybind for minimize toggle
    UserInputService.InputBegan:Connect(function(input, gameProcessed)
        if not gameProcessed and input.KeyCode == window.ToggleKey then
            window:ToggleMinimize()
        end
    end)

    -- Make window draggable
    local dragging
    local dragInput
    local dragStart
    local startPos

    local function update(input)
        local delta = input.Position - dragStart
        mainFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
    end

    titleBar.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
            dragStart = input.Position
            startPos = mainFrame.Position
            
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    dragging = false
                end
            end)
        end
    end)

    titleBar.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement then
            dragInput = input
        end
    end)

    UserInputService.InputChanged:Connect(function(input)
        if input == dragInput and dragging then
            update(input)
        end
    end)

    return window
end

-- Button component
function Soluna.Components.Button(options)
    local button = {
        Text = options.Text or "Button",
        Callback = options.Callback or function() end,
        Dialog = options.Dialog or nil,
        Parent = options.Parent or error("Button must have a parent")
    }

    local buttonFrame = Soluna.Utility.Create("TextButton", {
        Name = "Button_" .. button.Text,
        Size = UDim2.new(1, 0, 0, 40),
        BackgroundColor3 = Soluna.Themes.Current.Primary,
        BackgroundTransparency = 0,
        Text = button.Text,
        TextColor3 = Soluna.Themes.Current.Text,
        Font = Enum.Font.Gotham,
        TextSize = 14,
        Parent = button.Parent
    })

    -- Button effects
    buttonFrame.MouseEnter:Connect(function()
        TweenService:Create(buttonFrame, TweenInfo.new(0.1), {
            BackgroundColor3 = Color3.new(
                math.clamp(Soluna.Themes.Current.Primary.R * 1.2, 0, 1),
                math.clamp(Soluna.Themes.Current.Primary.G * 1.2, 0, 1),
                math.clamp(Soluna.Themes.Current.Primary.B * 1.2, 0, 1)
            )
        }):Play()
    end)

    buttonFrame.MouseLeave:Connect(function()
        TweenService:Create(buttonFrame, TweenInfo.new(0.1), {
            BackgroundColor3 = Soluna.Themes.Current.Primary
        }):Play()
    end)

    -- Button click handler
    buttonFrame.MouseButton1Click:Connect(function()
        if button.Dialog then
            -- Show dialog confirmation
            Soluna.Components.Dialog({
                Title = button.Dialog.Title or "Confirm",
                Content = button.Dialog.Content or "Are you sure?",
                OnConfirm = function()
                    button.Callback()
                end,
                OnCancel = button.Dialog.OnCancel or function() end
            })
        else
            button.Callback()
        end
    end)

    return button
end

-- Toggle component
function Soluna.Components.Toggle(options)
    local toggle = {
        Text = options.Text or "Toggle",
        Default = options.Default or false,
        Callback = options.Callback or function() end,
        Parent = options.Parent or error("Toggle must have a parent"),
        Value = options.Default or false
    }

    local toggleFrame = Soluna.Utility.Create("Frame", {
        Name = "Toggle_" .. toggle.Text,
        Size = UDim2.new(1, 0, 0, 40),
        BackgroundTransparency = 1,
        Parent = toggle.Parent
    })

    local toggleText = Soluna.Utility.Create("TextLabel", {
        Name = "ToggleText",
        Size = UDim2.new(0.7, 0, 1, 0),
        BackgroundTransparency = 1,
        Text = toggle.Text,
        TextColor3 = Soluna.Themes.Current.Text,
        TextXAlignment = Enum.TextXAlignment.Left,
        Font = Enum.Font.Gotham,
        TextSize = 14,
        Parent = toggleFrame
    })

    local toggleSwitch = Soluna.Utility.Create("Frame", {
        Name = "ToggleSwitch",
        Size = UDim2.new(0, 50, 0, 25),
        Position = UDim2.new(1, -60, 0.5, -12.5),
        BackgroundColor3 = Soluna.Themes.Current.Secondary,
        Parent = toggleFrame
    })

    local toggleCircle = Soluna.Utility.Create("Frame", {
        Name = "ToggleCircle",
        Size = UDim2.new(0, 21, 0, 21),
        Position = UDim2.new(0, toggle.Default and 25 or 2, 0.5, -10.5),
        BackgroundColor3 = toggle.Default and Soluna.Themes.Current.Primary or Color3.new(0.5, 0.5, 0.5),
        AnchorPoint = Vector2.new(0, 0.5),
        Parent = toggleSwitch
    })

    -- Update toggle visual state
    local function updateToggle()
        local targetPosition = toggle.Value and 25 or 2
        local targetColor = toggle.Value and Soluna.Themes.Current.Primary or Color3.new(0.5, 0.5, 0.5)
        
        TweenService:Create(toggleCircle, TweenInfo.new(0.2), {
            Position = UDim2.new(0, targetPosition, 0.5, -10.5),
            BackgroundColor3 = targetColor
        }):Play()
    end

    -- Toggle click handler
    toggleSwitch.MouseButton1Click:Connect(function()
        toggle.Value = not toggle.Value
        updateToggle()
        toggle.Callback(toggle.Value)
    end)

    -- Programmatic value setter
    function toggle:SetValue(value)
        if type(value) == "boolean" then
            self.Value = value
            updateToggle()
        end
    end

    return toggle
end

-- Slider component
function Soluna.Components.Slider(options)
    local slider = {
        Text = options.Text or "Slider",
        Min = options.Min or 0,
        Max = options.Max or 100,
        Default = options.Default or 50,
        Rounding = options.Rounding or 0,
        Callback = options.Callback or function() end,
        Parent = options.Parent or error("Slider must have a parent"),
        Value = options.Default or 50
    }

    local sliderFrame = Soluna.Utility.Create("Frame", {
        Name = "Slider_" .. slider.Text,
        Size = UDim2.new(1, 0, 0, 60),
        BackgroundTransparency = 1,
        Parent = slider.Parent
    })

    local sliderText = Soluna.Utility.Create("TextLabel", {
        Name = "SliderText",
        Size = UDim2.new(1, 0, 0, 20),
        BackgroundTransparency = 1,
        Text = slider.Text .. ": " .. slider.Value,
        TextColor3 = Soluna.Themes.Current.Text,
        TextXAlignment = Enum.TextXAlignment.Left,
        Font = Enum.Font.Gotham,
        TextSize = 14,
        Parent = sliderFrame
    })

    local sliderTrack = Soluna.Utility.Create("Frame", {
        Name = "SliderTrack",
        Size = UDim2.new(1, 0, 0, 5),
        Position = UDim2.new(0, 0, 0, 30),
        BackgroundColor3 = Soluna.Themes.Current.Secondary,
        Parent = sliderFrame
    })

    local sliderFill = Soluna.Utility.Create("Frame", {
        Name = "SliderFill",
        Size = UDim2.new((slider.Value - slider.Min) / (slider.Max - slider.Min), 0, 1, 0),
        BackgroundColor3 = Soluna.Themes.Current.Primary,
        Parent = sliderTrack
    })

    local sliderHandle = Soluna.Utility.Create("Frame", {
        Name = "SliderHandle",
        Size = UDim2.new(0, 15, 0, 15),
        Position = UDim2.new((slider.Value - slider.Min) / (slider.Max - slider.Min), -7.5, 0.5, -7.5),
        BackgroundColor3 = Soluna.Themes.Current.Accent,
        AnchorPoint = Vector2.new(0.5, 0.5),
        Parent = sliderTrack
    })

    -- Slider interaction logic
    local dragging = false

    local function updateSlider(value)
        local roundedValue = slider.Rounding > 0 and math.floor((value / slider.Rounding) + 0.5) * slider.Rounding or value
        roundedValue = math.clamp(roundedValue, slider.Min, slider.Max)
        
        slider.Value = roundedValue
        sliderText.Text = slider.Text .. ": " .. roundedValue
        
        local fillWidth = (roundedValue - slider.Min) / (slider.Max - slider.Min)
        sliderFill.Size = UDim2.new(fillWidth, 0, 1, 0)
        sliderHandle.Position = UDim2.new(fillWidth, -7.5, 0.5, -7.5)
        
        slider.Callback(roundedValue)
    end

    sliderTrack.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
            local relativeX = (input.Position.X - sliderTrack.AbsolutePosition.X) / sliderTrack.AbsoluteSize.X
            local value = slider.Min + (slider.Max - slider.Min) * relativeX
            updateSlider(value)
        end
    end)

    sliderTrack.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = false
        end
    end)

    UserInputService.InputChanged:Connect(function(input)
        if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
            local relativeX = (input.Position.X - sliderTrack.AbsolutePosition.X) / sliderTrack.AbsoluteSize.X
            local value = slider.Min + (slider.Max - slider.Min) * math.clamp(relativeX, 0, 1)
            updateSlider(value)
        end
    end)

    -- Programmatic value setter
    function slider:SetValue(value)
        updateSlider(value)
    end

    return slider
end

-- Dropdown component
function Soluna.Components.Dropdown(options)
    local dropdown = {
        Text = options.Text or "Dropdown",
        Options = options.Options or {"Option 1", "Option 2", "Option 3"},
        MultiSelect = options.MultiSelect or false,
        Default = options.Default or (options.MultiSelect and {} or options.Options[1]),
        Callback = options.Callback or function() end,
        Parent = options.Parent or error("Dropdown must have a parent"),
        Selected = options.Default or (options.MultiSelect and {} or options.Options[1]),
        Open = false
    }

    local dropdownFrame = Soluna.Utility.Create("Frame", {
        Name = "Dropdown_" .. dropdown.Text,
        Size = UDim2.new(1, 0, 0, 40),
        BackgroundTransparency = 1,
        Parent = dropdown.Parent
    })

    local dropdownButton = Soluna.Utility.Create("TextButton", {
        Name = "DropdownButton",
        Size = UDim2.new(1, 0, 0, 40),
        BackgroundColor3 = Soluna.Themes.Current.Secondary,
        Text = dropdown.Text .. ": " .. (dropdown.MultiSelect and "Select" or tostring(dropdown.Selected)),
        TextColor3 = Soluna.Themes.Current.Text,
        TextXAlignment = Enum.TextXAlignment.Left,
        Font = Enum.Font.Gotham,
        TextSize = 14,
        Parent = dropdownFrame
    })

    local dropdownList = Soluna.Utility.Create("Frame", {
        Name = "DropdownList",
        Size = UDim2.new(1, 0, 0, 0),
        Position = UDim2.new(0, 0, 1, 5),
        BackgroundColor3 = Soluna.Themes.Current.Background,
        BackgroundTransparency = 0,
        Visible = false,
        ClipsDescendants = true,
        Parent = dropdownFrame
    })

    local dropdownListLayout = Soluna.Utility.Create("UIListLayout", {
        Name = "DropdownListLayout",
        SortOrder = Enum.SortOrder.LayoutOrder,
        Parent = dropdownList
    })

    -- Toggle dropdown visibility
    local function toggleDropdown()
        dropdown.Open = not dropdown.Open
        dropdownList.Visible = dropdown.Open
        
        if dropdown.Open then
            local height = 0
            for _, option in ipairs(dropdown.Options) do
                height = height + 30
            end
            dropdownList.Size = UDim2.new(1, 0, 0, math.min(height, 150))
        end
    end

    dropdownButton.MouseButton1Click:Connect(toggleDropdown)

    -- Populate dropdown options
    local function populateOptions()
        for _, option in ipairs(dropdown.Options) do
            local optionFrame = Soluna.Utility.Create("TextButton", {
                Name = "Option_" .. option,
                Size = UDim2.new(1, 0, 0, 30),
                BackgroundColor3 = Soluna.Themes.Current.Secondary,
                Text = option,
                TextColor3 = Soluna.Themes.Current.Text,
                TextXAlignment = Enum.TextXAlignment.Left,
                Font = Enum.Font.Gotham,
                TextSize = 14,
                LayoutOrder = _,
                Parent = dropdownList
            })

            if dropdown.MultiSelect then
                local checkbox = Soluna.Utility.Create("Frame", {
                    Name = "Checkbox",
                    Size = UDim2.new(0, 20, 0, 20),
                    Position = UDim2.new(1, -25, 0.5, -10),
                    BackgroundColor3 = table.find(dropdown.Selected, option) and Soluna.Themes.Current.Primary or Soluna.Themes.Current.Secondary,
                    Parent = optionFrame
                })

                optionFrame.MouseButton1Click:Connect(function()
                    if table.find(dropdown.Selected, option) then
                        table.remove(dropdown.Selected, table.find(dropdown.Selected, option))
                        checkbox.BackgroundColor3 = Soluna.Themes.Current.Secondary
                    else
                        table.insert(dropdown.Selected, option)
                        checkbox.BackgroundColor3 = Soluna.Themes.Current.Primary
                    end
                    dropdownButton.Text = dropdown.Text .. ": " .. (#dropdown.Selected > 0 and table.concat(dropdown.Selected, ", ") or "Select")
                    dropdown.Callback(dropdown.Selected)
                end)
            else
                optionFrame.MouseButton1Click:Connect(function()
                    dropdown.Selected = option
                    dropdownButton.Text = dropdown.Text .. ": " .. option
                    dropdown.Callback(option)
                    toggleDropdown()
                end)
            end
        end
    end

    populateOptions()

    -- Close dropdown when clicking outside
    UserInputService.InputBegan:Connect(function(input, processed)
        if input.UserInputType == Enum.UserInputType.MouseButton1 and dropdown.Open then
            if not dropdownList:IsDescendantOf(input:GetMouseTarget()) and not dropdownButton:IsDescendantOf(input:GetMouseTarget()) then
                toggleDropdown()
            end
        end
    end)

    -- Programmatic value setter
    function dropdown:SetSelected(value)
        if dropdown.MultiSelect then
            if type(value) == "table" then
                dropdown.Selected = value
                -- Update UI
            end
        else
            if table.find(dropdown.Options, value) then
                dropdown.Selected = value
                dropdownButton.Text = dropdown.Text .. ": " .. value
            end
        end
    end

    return dropdown
end

-- Notification system
function Soluna.Components.Notify(options)
    local notification = {
        Title = options.Title or "Notification",
        Content = options.Content or "",
        SubContent = options.SubContent or "",
        Duration = options.Duration or 5,
        Persistent = options.Persistent or false,
        Type = options.Type or "Info" -- "Info", "Success", "Warning", "Error"
    }

    -- Create notification UI
    local screenGui = Soluna.Utility.Create("ScreenGui", {
        Name = "SolunaNotification_" .. notification.Title,
        ResetOnSpawn = false
    })

    local mainFrame = Soluna.Utility.Create("Frame", {
        Name = "NotificationFrame",
        Size = UDim2.new(0, 300, 0, 100),
        Position = UDim2.new(1, -320, 1, -120),
        BackgroundColor3 = Soluna.Themes.Current.Background,
        BackgroundTransparency = 0,
        AnchorPoint = Vector2.new(1, 1),
        Parent = screenGui
    })

    -- Add title
    local titleText = Soluna.Utility.Create("TextLabel", {
        Name = "TitleText",
        Size = UDim2.new(1, -40, 0, 30),
        Position = UDim2.new(0, 10, 0, 10),
        BackgroundTransparency = 1,
        Text = notification.Title,
        TextColor3 = Soluna.Themes.Current.Text,
        TextXAlignment = Enum.TextXAlignment.Left,
        Font = Enum.Font.GothamBold,
        TextSize = 16,
        Parent = mainFrame
    })

    -- Add content
    local contentText = Soluna.Utility.Create("TextLabel", {
        Name = "ContentText",
        Size = UDim2.new(1, -20, 0, 30),
        Position = UDim2.new(0, 10, 0, 40),
        BackgroundTransparency = 1,
        Text = notification.Content,
        TextColor3 = Soluna.Themes.Current.Text,
        TextXAlignment = Enum.TextXAlignment.Left,
        Font = Enum.Font.Gotham,
        TextSize = 14,
        Parent = mainFrame
    })

    -- Add sub-content if exists
    if notification.SubContent ~= "" then
        local subContentText = Soluna.Utility.Create("TextLabel", {
            Name = "SubContentText",
            Size = UDim2.new(1, -20, 0, 20),
            Position = UDim2.new(0, 10, 0, 70),
            BackgroundTransparency = 1,
            Text = notification.SubContent,
            TextColor3 = Color3.new(0.7, 0.7, 0.7),
            TextXAlignment = Enum.TextXAlignment.Left,
            Font = Enum.Font.Gotham,
            TextSize = 12,
            Parent = mainFrame
        })
    end

    -- Add close button
    local closeButton = Soluna.Utility.Create("TextButton", {
        Name = "CloseButton",
        Size = UDim2.new(0, 30, 0, 30),
        Position = UDim2.new(1, -30, 0, 0),
        BackgroundTransparency = 1,
        Text = "X",
        TextColor3 = Soluna.Themes.Current.Text,
        Font = Enum.Font.GothamBold,
        TextSize = 16,
        Parent = mainFrame
    })

    closeButton.MouseButton1Click:Connect(function()
        screenGui:Destroy()
    end)

    -- Auto-close if not persistent
    if not notification.Persistent then
        task.delay(notification.Duration, function()
            if screenGui and screenGui.Parent then
                screenGui:Destroy()
            end
        end)
    end

    return {
        Close = function()
            if screenGui and screenGui.Parent then
                screenGui:Destroy()
            end
        end
    }
end

-- Initialize the library
return Soluna
