local FluentGlass = {}

FluentGlass.Version = "1.0.0"

FluentGlass.Options = {}

FluentGlass.Themes = {
    Dark = {
        Primary = Color3.fromRGB(0, 120, 215),
        Background = Color3.fromRGB(32, 32, 32),
        Secondary = Color3.fromRGB(40, 40, 40),
        Text = Color3.fromRGB(255, 255, 255),
        SubText = Color3.fromRGB(200, 200, 200)
    },
    Light = {
        Primary = Color3.fromRGB(0, 120, 215),
        Background = Color3.fromRGB(240, 240, 240),
        Secondary = Color3.fromRGB(255, 255, 255),
        Text = Color3.fromRGB(0, 0, 0),
        SubText = Color3.fromRGB(80, 80, 80)
    },
    Amethyst = {
        Primary = Color3.fromRGB(156, 39, 176),
        Background = Color3.fromRGB(32, 32, 32),
        Secondary = Color3.fromRGB(40, 40, 40),
        Text = Color3.fromRGB(255, 255, 255),
        SubText = Color3.fromRGB(200, 200, 200)
    }
}

local function Tween(obj, props, duration, style, direction)
    style = style or Enum.EasingStyle.Quint
    direction = direction or Enum.EasingDirection.Out
    game:GetService("TweenService"):Create(obj, TweenInfo.new(duration, style, direction), props):Play()
end

function FluentGlass:CreateWindow(options)
    options = options or {}
    local window = {
        Title = options.Title or "Fluent Glass",
        SubTitle = options.SubTitle or "by Developer",
        Size = options.Size or UDim2.fromOffset(580, 460),
        Position = options.Position or UDim2.fromScale(0.5, 0.5),
        Acrylic = options.Acrylic == nil and true or options.Acrylic,
        Theme = options.Theme or "Dark",
        MinimizeKey = options.MinimizeKey or Enum.KeyCode.RightControl
    }

    local ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Name = "FluentGlassUI"
    ScreenGui.ResetOnSpawn = false
    ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Global
    ScreenGui.Parent = game:GetService("CoreGui")

    if window.Acrylic then
        local blur = Instance.new("BlurEffect")
        blur.Name = "AcrylicBlur"
        blur.Size = 12
        blur.Parent = ScreenGui
    end

    local MainFrame = Instance.new("Frame")
    MainFrame.Name = "MainFrame"
    MainFrame.Size = window.Size
    MainFrame.Position = window.Position
    MainFrame.AnchorPoint = Vector2.new(0.5, 0.5)
    MainFrame.BackgroundColor3 = FluentGlass.Themes[window.Theme].Secondary
    MainFrame.BackgroundTransparency = 0.5
    MainFrame.BorderSizePixel = 0
    MainFrame.ClipsDescendants = true
    MainFrame.ZIndex = 1

    local UICorner = Instance.new("UICorner")
    UICorner.CornerRadius = UDim.new(0, 8)
    UICorner.Parent = MainFrame

    local UIStroke = Instance.new("UIStroke")
    UIStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    UIStroke.Color = Color3.fromRGB(255, 255, 255)
    UIStroke.Transparency = 0.9
    UIStroke.Thickness = 1
    UIStroke.Parent = MainFrame

    local TitleBar = Instance.new("Frame")
    TitleBar.Name = "TitleBar"
    TitleBar.Size = UDim2.new(1, 0, 0, 40)
    TitleBar.BackgroundColor3 = FluentGlass.Themes[window.Theme].Primary
    TitleBar.BackgroundTransparency = 0.7
    TitleBar.BorderSizePixel = 0
    TitleBar.ZIndex = 2

    local TitleLabel = Instance.new("TextLabel")
    TitleLabel.Name = "TitleLabel"
    TitleLabel.Size = UDim2.new(1, -100, 1, 0)
    TitleLabel.Position = UDim2.new(0, 10, 0, 0)
    TitleLabel.BackgroundTransparency = 1
    TitleLabel.Text = window.Title
    TitleLabel.TextColor3 = FluentGlass.Themes[window.Theme].Text
    TitleLabel.TextSize = 18
    TitleLabel.TextXAlignment = Enum.TextXAlignment.Left
    TitleLabel.Font = Enum.Font.GothamSemibold
    TitleLabel.ZIndex = 3

    local SubTitleLabel = Instance.new("TextLabel")
    SubTitleLabel.Name = "SubTitleLabel"
    SubTitleLabel.Size = UDim2.new(1, -100, 0, 14)
    SubTitleLabel.Position = UDim2.new(0, 10, 0, 20)
    SubTitleLabel.BackgroundTransparency = 1
    SubTitleLabel.Text = window.SubTitle
    SubTitleLabel.TextColor3 = FluentGlass.Themes[window.Theme].SubText
    SubTitleLabel.TextSize = 12
    SubTitleLabel.TextXAlignment = Enum.TextXAlignment.Left
    SubTitleLabel.Font = Enum.Font.Gotham
    SubTitleLabel.ZIndex = 3

    local CloseButton = Instance.new("TextButton")
    CloseButton.Name = "CloseButton"
    CloseButton.Size = UDim2.new(0, 40, 0, 40)
    CloseButton.Position = UDim2.new(1, -40, 0, 0)
    CloseButton.BackgroundTransparency = 1
    CloseButton.TextColor3 = FluentGlass.Themes[window.Theme].Text
    CloseButton.Text = "×"
    CloseButton.TextSize = 24
    CloseButton.Font = Enum.Font.GothamSemibold
    CloseButton.ZIndex = 3

    local MinimizeButton = Instance.new("TextButton")
    MinimizeButton.Name = "MinimizeButton"
    MinimizeButton.Size = UDim2.new(0, 40, 0, 40)
    MinimizeButton.Position = UDim2.new(1, -80, 0, 0)
    MinimizeButton.BackgroundTransparency = 1
    MinimizeButton.TextColor3 = FluentGlass.Themes[window.Theme].Text
    MinimizeButton.Text = "-"
    MinimizeButton.TextSize = 24
    MinimizeButton.Font = Enum.Font.GothamSemibold
    MinimizeButton.ZIndex = 3

    local TabContainer = Instance.new("Frame")
    TabContainer.Name = "TabContainer"
    TabContainer.Size = UDim2.new(1, 0, 0, 40)
    TabContainer.Position = UDim2.new(0, 0, 0, 40)
    TabContainer.BackgroundTransparency = 1
    TabContainer.BorderSizePixel = 0
    TabContainer.ZIndex = 2

    local ContentFrame = Instance.new("Frame")
    ContentFrame.Name = "ContentFrame"
    ContentFrame.Size = UDim2.new(1, 0, 1, -80)
    ContentFrame.Position = UDim2.new(0, 0, 0, 80)
    ContentFrame.BackgroundTransparency = 1
    ContentFrame.BorderSizePixel = 0
    ContentFrame.ZIndex = 1

    TitleBar.Parent = MainFrame
    TitleLabel.Parent = TitleBar
    SubTitleLabel.Parent = TitleBar
    CloseButton.Parent = TitleBar
    MinimizeButton.Parent = TitleBar
    TabContainer.Parent = MainFrame
    ContentFrame.Parent = MainFrame
    MainFrame.Parent = ScreenGui

    local UserInputService = game:GetService("UserInputService")
    local dragging
    local dragInput
    local dragStart
    local startPos

    local function update(input)
        local delta = input.Position - dragStart
        MainFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
    end

    TitleBar.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
            dragStart = input.Position
            startPos = MainFrame.Position

            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    dragging = false
                end
            end)
        end
    end)

    TitleBar.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement then
            dragInput = input
        end
    end)

    UserInputService.InputChanged:Connect(function(input)
        if input == dragInput and dragging then
            update(input)
        end
    end)

    local function buttonHover(button)
        button.MouseEnter:Connect(function()
            Tween(button, {TextColor3 = Color3.fromRGB(255, 255, 255)}, 0.2)
        end)

        button.MouseLeave:Connect(function()
            Tween(button, {TextColor3 = FluentGlass.Themes[window.Theme].Text}, 0.2)
        end)
    end

    buttonHover(CloseButton)
    buttonHover(MinimizeButton)

    CloseButton.MouseButton1Click:Connect(function()
        Tween(MainFrame, {Size = UDim2.new(0, 0, 0, 0)}, 0.3, Enum.EasingStyle.Quint, Enum.EasingDirection.In)
        wait(0.3)
        ScreenGui:Destroy()
    end)

    local minimized = false
    MinimizeButton.MouseButton1Click:Connect(function()
        minimized = not minimized
        if minimized then
            Tween(MainFrame, {Size = UDim2.new(MainFrame.Size.X.Scale, MainFrame.Size.X.Offset, 0, 80)}, 0.3)
            Tween(ContentFrame, {BackgroundTransparency = 1}, 0.3)
        else
            Tween(MainFrame, {Size = window.Size}, 0.3)
            Tween(ContentFrame, {BackgroundTransparency = 0}, 0.3)
        end
    end)

    function window:AddTab(options)
        options = options or {}
        local tab = {
            Title = options.Title or "Tab",
            Icon = options.Icon or ""
        }

        local TabButton = Instance.new("TextButton")
        TabButton.Name = "TabButton_" .. tab.Title
        TabButton.Size = UDim2.new(0, 100, 1, 0)
        TabButton.Position = UDim2.new(0, (#TabContainer:GetChildren() - 1) * 100, 0, 0)
        TabButton.BackgroundTransparency = 1
        TabButton.Text = tab.Title
        TabButton.TextColor3 = FluentGlass.Themes[window.Theme].Text
        TabButton.TextSize = 14
        TabButton.Font = Enum.Font.GothamSemibold
        TabButton.ZIndex = 3

        local TabContent = Instance.new("ScrollingFrame")
        TabContent.Name = "TabContent_" .. tab.Title
        TabContent.Size = UDim2.new(1, 0, 1, 0)
        TabContent.Position = UDim2.new(0, 0, 0, 0)
        TabContent.BackgroundTransparency = 1
        TabContent.BorderSizePixel = 0
        TabContent.ScrollBarThickness = 3
        TabContent.ScrollBarImageColor3 = FluentGlass.Themes[window.Theme].Primary
        TabContent.ScrollBarImageTransparency = 0.7
        TabContent.Visible = false
        TabContent.AutomaticCanvasSize = Enum.AutomaticSize.Y
        TabContent.CanvasSize = UDim2.new(0, 0, 0, 0)
        TabContent.ZIndex = 1

        local UIListLayout = Instance.new("UIListLayout")
        UIListLayout.Padding = UDim.new(0, 10)
        UIListLayout.Parent = TabContent

        TabButton.Parent = TabContainer
        TabContent.Parent = ContentFrame

        buttonHover(TabButton)

        TabButton.MouseButton1Click:Connect(function()
            for _, child in ipairs(ContentFrame:GetChildren()) do
                if child:IsA("ScrollingFrame") then
                    child.Visible = false
                end
            end
            TabContent.Visible = true

            for _, btn in ipairs(TabContainer:GetChildren()) do
                if btn:IsA("TextButton") then
                    Tween(btn, {TextColor3 = FluentGlass.Themes[window.Theme].SubText}, 0.2)
                end
            end
            Tween(TabButton, {TextColor3 = FluentGlass.Themes[window.Theme].Primary}, 0.2)
        end)

        function tab:AddSection(options)
            options = options or {}
            local section = {
                Title = options.Title or "Section"
            }

            local SectionFrame = Instance.new("Frame")
            SectionFrame.Name = "Section_" .. section.Title
            SectionFrame.Size = UDim2.new(1, -20, 0, 0)
            SectionFrame.AutomaticSize = Enum.AutomaticSize.Y
            SectionFrame.BackgroundColor3 = FluentGlass.Themes[window.Theme].Secondary
            SectionFrame.BackgroundTransparency = 0.7
            SectionFrame.BorderSizePixel = 0
            SectionFrame.ZIndex = 2

            local UICorner = Instance.new("UICorner")
            UICorner.CornerRadius = UDim.new(0, 6)
            UICorner.Parent = SectionFrame

            local UIStroke = Instance.new("UIStroke")
            UIStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
            UIStroke.Color = Color3.fromRGB(255, 255, 255)
            UIStroke.Transparency = 0.9
            UIStroke.Thickness = 1
            UIStroke.Parent = SectionFrame

            local SectionTitle = Instance.new("TextLabel")
            SectionTitle.Name = "SectionTitle"
            SectionTitle.Size = UDim2.new(1, -20, 0, 30)
            SectionTitle.Position = UDim2.new(0, 10, 0, 0)
            SectionTitle.BackgroundTransparency = 1
            SectionTitle.Text = section.Title
            SectionTitle.TextColor3 = FluentGlass.Themes[window.Theme].Text
            SectionTitle.TextSize = 16
            SectionTitle.TextXAlignment = Enum.TextXAlignment.Left
            SectionTitle.Font = Enum.Font.GothamSemibold
            SectionTitle.ZIndex = 3

            local SectionContent = Instance.new("Frame")
            SectionContent.Name = "SectionContent"
            SectionContent.Size = UDim2.new(1, -20, 0, 0)
            SectionContent.Position = UDim2.new(0, 10, 0, 30)
            SectionContent.AutomaticSize = Enum.AutomaticSize.Y
            SectionContent.BackgroundTransparency = 1
            SectionContent.BorderSizePixel = 0
            SectionContent.ZIndex = 2

            local UIListLayout = Instance.new("UIListLayout")
            UIListLayout.Padding = UDim.new(0, 10)
            UIListLayout.Parent = SectionContent

            SectionTitle.Parent = SectionFrame
            SectionContent.Parent = SectionFrame
            SectionFrame.Parent = TabContent

            function section:AddButton(options)
                options = options or {}
                local button = {
                    Title = options.Title or "Button",
                    Description = options.Description or "",
                    Callback = options.Callback or function() end
                }

                local ButtonFrame = Instance.new("Frame")
                ButtonFrame.Name = "Button_" .. button.Title
                ButtonFrame.Size = UDim2.new(1, 0, 0, 40)
                ButtonFrame.BackgroundColor3 = FluentGlass.Themes[window.Theme].Secondary
                ButtonFrame.BackgroundTransparency = 0.8
                ButtonFrame.BorderSizePixel = 0
                ButtonFrame.ZIndex = 3

                local UICorner = Instance.new("UICorner")
                UICorner.CornerRadius = UDim.new(0, 4)
                UICorner.Parent = ButtonFrame

                local ButtonTitle = Instance.new("TextLabel")
                ButtonTitle.Name = "ButtonTitle"
                ButtonTitle.Size = UDim2.new(1, -20, 0.5, 0)
                ButtonTitle.Position = UDim2.new(0, 10, 0, 0)
                ButtonTitle.BackgroundTransparency = 1
                ButtonTitle.Text = button.Title
                ButtonTitle.TextColor3 = FluentGlass.Themes[window.Theme].Text
                ButtonTitle.TextSize = 14
                ButtonTitle.TextXAlignment = Enum.TextXAlignment.Left
                ButtonTitle.Font = Enum.Font.GothamSemibold
                ButtonTitle.ZIndex = 4

                local ButtonDesc = Instance.new("TextLabel")
                ButtonDesc.Name = "ButtonDesc"
                ButtonDesc.Size = UDim2.new(1, -20, 0.5, 0)
                ButtonDesc.Position = UDim2.new(0, 10, 0.5, 0)
                ButtonDesc.BackgroundTransparency = 1
                ButtonDesc.Text = button.Description
                ButtonDesc.TextColor3 = FluentGlass.Themes[window.Theme].SubText
                ButtonDesc.TextSize = 12
                ButtonDesc.TextXAlignment = Enum.TextXAlignment.Left
                ButtonDesc.Font = Enum.Font.Gotham
                ButtonDesc.ZIndex = 4

                local ButtonHighlight = Instance.new("Frame")
                ButtonHighlight.Name = "ButtonHighlight"
                ButtonHighlight.Size = UDim2.new(1, 0, 1, 0)
                ButtonHighlight.BackgroundTransparency = 1
                ButtonHighlight.BackgroundColor3 = FluentGlass.Themes[window.Theme].Primary
                ButtonHighlight.BackgroundTransparency = 1
                ButtonHighlight.BorderSizePixel = 0
                ButtonHighlight.ZIndex = 3

                local UICorner = Instance.new("UICorner")
                UICorner.CornerRadius = UDim.new(0, 4)
                UICorner.Parent = ButtonHighlight

                local ButtonClick = Instance.new("TextButton")
                ButtonClick.Name = "ButtonClick"
                ButtonClick.Size = UDim2.new(1, 0, 1, 0)
                ButtonClick.BackgroundTransparency = 1
                ButtonClick.Text = ""
                ButtonClick.ZIndex = 5

                ButtonTitle.Parent = ButtonFrame
                ButtonDesc.Parent = ButtonFrame
                ButtonHighlight.Parent = ButtonFrame
                ButtonClick.Parent = ButtonFrame
                ButtonFrame.Parent = SectionContent

                ButtonClick.MouseEnter:Connect(function()
                    Tween(ButtonHighlight, {BackgroundTransparency = 0.9}, 0.2)
                end)

                ButtonClick.MouseLeave:Connect(function()
                    Tween(ButtonHighlight, {BackgroundTransparency = 1}, 0.2)
                end)

                ButtonClick.MouseButton1Down:Connect(function()
                    Tween(ButtonHighlight, {BackgroundTransparency = 0.8}, 0.1)
                end)

                ButtonClick.MouseButton1Up:Connect(function()
                    Tween(ButtonHighlight, {BackgroundTransparency = 0.9}, 0.1)
                    button.Callback()
                end)

                return button
            end

            function section:AddToggle(options)
                options = options or {}
                local toggle = {
                    Title = options.Title or "Toggle",
                    Description = options.Description or "",
                    Default = options.Default or false,
                    Callback = options.Callback or function() end
                }

                local ToggleFrame = Instance.new("Frame")
                ToggleFrame.Name = "Toggle_" .. toggle.Title
                ToggleFrame.Size = UDim2.new(1, 0, 0, 40)
                ToggleFrame.BackgroundTransparency = 1
                ToggleFrame.BorderSizePixel = 0
                ToggleFrame.ZIndex = 3

                local ToggleTitle = Instance.new("TextLabel")
                ToggleTitle.Name = "ToggleTitle"
                ToggleTitle.Size = UDim2.new(1, -60, 0.5, 0)
                ToggleTitle.Position = UDim2.new(0, 10, 0, 0)
                ToggleTitle.BackgroundTransparency = 1
                ToggleTitle.Text = toggle.Title
                ToggleTitle.TextColor3 = FluentGlass.Themes[window.Theme].Text
                ToggleTitle.TextSize = 14
                ToggleTitle.TextXAlignment = Enum.TextXAlignment.Left
                ToggleTitle.Font = Enum.Font.GothamSemibold
                ToggleTitle.ZIndex = 4

                local ToggleDesc = Instance.new("TextLabel")
                ToggleDesc.Name = "ToggleDesc"
                ToggleDesc.Size = UDim2.new(1, -60, 0.5, 0)
                ToggleDesc.Position = UDim2.new(0, 10, 0.5, 0)
                ToggleDesc.BackgroundTransparency = 1
                ToggleDesc.Text = toggle.Description
                ToggleDesc.TextColor3 = FluentGlass.Themes[window.Theme].SubText
                ToggleDesc.TextSize = 12
                ToggleDesc.TextXAlignment = Enum.TextXAlignment.Left
                ToggleDesc.Font = Enum.Font.Gotham
                ToggleDesc.ZIndex = 4

                local ToggleSwitch = Instance.new("Frame")
                ToggleSwitch.Name = "ToggleSwitch"
                ToggleSwitch.Size = UDim2.new(0, 40, 0, 20)
                ToggleSwitch.Position = UDim2.new(1, -50, 0.5, -10)
                ToggleSwitch.BackgroundColor3 = FluentGlass.Themes[window.Theme].Secondary
                ToggleSwitch.BackgroundTransparency = 0.7
                ToggleSwitch.BorderSizePixel = 0
                ToggleSwitch.ZIndex = 4

                local UICorner = Instance.new("UICorner")
                UICorner.CornerRadius = UDim.new(1, 0)
                UICorner.Parent = ToggleSwitch

                local ToggleKnob = Instance.new("Frame")
                ToggleKnob.Name = "ToggleKnob"
                ToggleKnob.Size = UDim2.new(0, 16, 0, 16)
                ToggleKnob.Position = UDim2.new(0, 2, 0.5, -8)
                ToggleKnob.BackgroundColor3 = FluentGlass.Themes[window.Theme].Text
                ToggleKnob.BorderSizePixel = 0
                ToggleKnob.ZIndex = 5

                local UICorner = Instance.new("UICorner")
                UICorner.CornerRadius = UDim.new(1, 0)
                UICorner.Parent = ToggleKnob

                local ToggleClick = Instance.new("TextButton")
                ToggleClick.Name = "ToggleClick"
                ToggleClick.Size = UDim2.new(1, 0, 1, 0)
                ToggleClick.BackgroundTransparency = 1
                ToggleClick.Text = ""
                ToggleClick.ZIndex = 6

                local state = toggle.Default
                if state then
                    Tween(ToggleSwitch, {BackgroundColor3 = FluentGlass.Themes[window.Theme].Primary}, 0.1)
                    Tween(ToggleKnob, {Position = UDim2.new(1, -18, 0.5, -8)}, 0.1)
                end

                ToggleTitle.Parent = ToggleFrame
                ToggleDesc.Parent = ToggleFrame
                ToggleSwitch.Parent = ToggleFrame
                ToggleKnob.Parent = ToggleSwitch
                ToggleClick.Parent = ToggleFrame
                ToggleFrame.Parent = SectionContent

                ToggleClick.MouseButton1Click:Connect(function()
                    state = not state
                    if state then
                        Tween(ToggleSwitch, {BackgroundColor3 = FluentGlass.Themes[window.Theme].Primary}, 0.2)
                        Tween(ToggleKnob, {Position = UDim2.new(1, -18, 0.5, -8)}, 0.2)
                    else
                        Tween(ToggleSwitch, {BackgroundColor3 = FluentGlass.Themes[window.Theme].Secondary}, 0.2)
                        Tween(ToggleKnob, {Position = UDim2.new(0, 2, 0.5, -8)}, 0.2)
                    end
                    toggle.Callback(state)
                end)

                function toggle:SetValue(newState)
                    state = newState
                    if state then
                        Tween(ToggleSwitch, {BackgroundColor3 = FluentGlass.Themes[window.Theme].Primary}, 0.2)
                        Tween(ToggleKnob, {Position = UDim2.new(1, -18, 0.5, -8)}, 0.2)
                    else
                        Tween(ToggleSwitch, {BackgroundColor3 = FluentGlass.Themes[window.Theme].Secondary}, 0.2)
                        Tween(ToggleKnob, {Position = UDim2.new(0, 2, 0.5, -8)}, 0.2)
                    end
                    toggle.Callback(state)
                end

                function toggle:GetValue()
                    return state
                end

                return toggle
            end

            return section
        end

        if #TabContainer:GetChildren() == 1 then
            TabButton.TextColor3 = FluentGlass.Themes[window.Theme].Primary
            TabContent.Visible = true
        end

        return tab
    end

    function window:SetTheme(themeName)
        if FluentGlass.Themes[themeName] then
            window.Theme = themeName

        end
    end

    function window:ToggleAcrylic(enabled)
        window.Acrylic = enabled
        if ScreenGui:FindFirstChild("AcrylicBlur") then
            ScreenGui.AcrylicBlur.Enabled = enabled
        end
    end

    function window:Destroy()
        ScreenGui:Destroy()
    end

    return window
end

function FluentGlass:Notify(options)
    options = options or {}
    local notification = {
        Title = options.Title or "Notification",
        Content = options.Content or "This is a notification",
        Duration = options.Duration or 5
    }

    local NotifGui = Instance.new("ScreenGui")
    NotifGui.Name = "Notification"
    NotifGui.Parent = game:GetService("CoreGui")

    local MainFrame = Instance.new("Frame")
    MainFrame.Name = "MainFrame"
    MainFrame.Size = UDim2.new(0, 300, 0, 0)
    MainFrame.Position = UDim2.new(1, -320, 1, -80)
    MainFrame.AnchorPoint = Vector2.new(1, 1)
    MainFrame.BackgroundColor3 = FluentGlass.Themes["Dark"].Secondary
    MainFrame.BackgroundTransparency = 0.5
    MainFrame.BorderSizePixel = 0
    MainFrame.ClipsDescendants = true
    MainFrame.ZIndex = 10

    local UICorner = Instance.new("UICorner")
    UICorner.CornerRadius = UDim.new(0, 8)
    UICorner.Parent = MainFrame

    local UIStroke = Instance.new("UIStroke")
    UIStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    UIStroke.Color = Color3.fromRGB(255, 255, 255)
    UIStroke.Transparency = 0.9
    UIStroke.Thickness = 1
    UIStroke.Parent = MainFrame

    local TitleLabel = Instance.new("TextLabel")
    TitleLabel.Name = "TitleLabel"
    TitleLabel.Size = UDim2.new(1, -20, 0, 20)
    TitleLabel.Position = UDim2.new(0, 10, 0, 10)
    TitleLabel.BackgroundTransparency = 1
    TitleLabel.Text = notification.Title
    TitleLabel.TextColor3 = FluentGlass.Themes["Dark"].Text
    TitleLabel.TextSize = 16
    TitleLabel.TextXAlignment = Enum.TextXAlignment.Left
    TitleLabel.Font = Enum.Font.GothamSemibold
    TitleLabel.ZIndex = 11

    local ContentLabel = Instance.new("TextLabel")
    ContentLabel.Name = "ContentLabel"
    ContentLabel.Size = UDim2.new(1, -20, 0, 0)
    ContentLabel.Position = UDim2.new(0, 10, 0, 35)
    ContentLabel.AutomaticSize = Enum.AutomaticSize.Y
    ContentLabel.BackgroundTransparency = 1
    ContentLabel.Text = notification.Content
    ContentLabel.TextColor3 = FluentGlass.Themes["Dark"].SubText
    ContentLabel.TextSize = 14
    ContentLabel.TextXAlignment = Enum.TextXAlignment.Left
    ContentLabel.TextYAlignment = Enum.TextYAlignment.Top
    ContentLabel.Font = Enum.Font.Gotham
    ContentLabel.ZIndex = 11

    local ProgressBar = Instance.new("Frame")
    ProgressBar.Name = "ProgressBar"
    ProgressBar.Size = UDim2.new(1, 0, 0, 2)
    ProgressBar.Position = UDim2.new(0, 0, 1, -2)
    ProgressBar.BackgroundColor3 = FluentGlass.Themes["Dark"].Primary
    ProgressBar.BorderSizePixel = 0
    ProgressBar.ZIndex = 11

    TitleLabel.Parent = MainFrame
    ContentLabel.Parent = MainFrame
    ProgressBar.Parent = MainFrame
    MainFrame.Parent = NotifGui

    MainFrame.Size = UDim2.new(0, 300, 0, 0)
    local contentHeight = ContentLabel.TextBounds.Y + 45
    Tween(MainFrame, {Size = UDim2.new(0, 300, 0, contentHeight)}, 0.3)

    if notification.Duration then
        Tween(ProgressBar, {Size = UDim2.new(0, 0, 0, 2)}, notification.Duration)

        task.delay(notification.Duration, function()
            Tween(MainFrame, {Size = UDim2.new(0, 300, 0, 0)}, 0.3)
            wait(0.3)
            NotifGui:Destroy()
        end)
    end

    MainFrame.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            Tween(MainFrame, {Size = UDim2.new(0, 300, 0, 0)}, 0.3)
            wait(0.3)
            NotifGui:Destroy()
        end
    end)

    return notification
end

return FluentGlass
