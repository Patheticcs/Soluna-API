--[[
    Theme Utility
    Manages UI themes and colors
]]

local Theme = {}

-- Default themes
local Themes = {
    Default = {
        -- Window elements
        Background = Color3.fromRGB(25, 25, 30),
        TitleBackground = Color3.fromRGB(35, 35, 40),
        TitleText = Color3.fromRGB(255, 255, 255),
        SubtitleText = Color3.fromRGB(190, 190, 190),
        TabBackground = Color3.fromRGB(30, 30, 35),
        ContentBackground = Color3.fromRGB(25, 25, 30),
        ScrollBar = Color3.fromRGB(100, 100, 110),
        
        -- Tab elements
        TabActive = Color3.fromRGB(56, 113, 224),
        TabInactive = Color3.fromRGB(40, 40, 45),
        TabHover = Color3.fromRGB(50, 50, 55),
        TabText = Color3.fromRGB(240, 240, 240),
        
        -- Component elements
        ComponentBackground = Color3.fromRGB(35, 35, 40),
        PrimaryText = Color3.fromRGB(255, 255, 255),
        SecondaryText = Color3.fromRGB(190, 190, 190),
        
        -- Button
        ButtonBackground = Color3.fromRGB(56, 113, 224),
        ButtonHover = Color3.fromRGB(76, 133, 244),
        ButtonPress = Color3.fromRGB(36, 93, 204),
        ButtonText = Color3.fromRGB(255, 255, 255),
        
        -- Toggle
        ToggleBackgroundOff = Color3.fromRGB(60, 60, 65),
        ToggleBackgroundOn = Color3.fromRGB(56, 113, 224),
        ToggleKnob = Color3.fromRGB(255, 255, 255),
        
        -- Slider
        SliderBackground = Color3.fromRGB(60, 60, 65),
        SliderFill = Color3.fromRGB(56, 113, 224),
        SliderKnob = Color3.fromRGB(255, 255, 255),
        
        -- Dropdown
        DropdownContentBackground = Color3.fromRGB(40, 40, 45),
        DropdownOptionBackground = Color3.fromRGB(45, 45, 50),
        DropdownOptionBackgroundHover = Color3.fromRGB(55, 55, 60),
        DropdownOptionText = Color3.fromRGB(255, 255, 255),
        
        -- Checkbox
        CheckboxBackground = Color3.fromRGB(60, 60, 65),
        CheckboxFill = Color3.fromRGB(56, 113, 224),
        
        -- Input
        InputBackground = Color3.fromRGB(40, 40, 45),
        InputBackgroundHover = Color3.fromRGB(50, 50, 55),
        InputText = Color3.fromRGB(255, 255, 255),
        PlaceholderText = Color3.fromRGB(120, 120, 120),
        
        -- Notification
        NotificationBackground = Color3.fromRGB(35, 35, 40),
        NotificationTitle = Color3.fromRGB(255, 255, 255),
        NotificationText = Color3.fromRGB(230, 230, 230),
        NotificationSubText = Color3.fromRGB(170, 170, 170),
        NotificationProgress = Color3.fromRGB(56, 113, 224),
        NotificationCloseButton = Color3.fromRGB(200, 200, 200),
        
        -- Dialog
        DialogBackground = Color3.fromRGB(35, 35, 40),
        DialogTitle = Color3.fromRGB(255, 255, 255),
        DialogText = Color3.fromRGB(230, 230, 230),
        
        -- Status colors
        SuccessBackground = Color3.fromRGB(76, 175, 80),
        SuccessBackgroundHover = Color3.fromRGB(86, 195, 90),
        WarningBackground = Color3.fromRGB(255, 152, 0),
        WarningBackgroundHover = Color3.fromRGB(255, 172, 20),
        DangerBackground = Color3.fromRGB(240, 71, 71),
        DangerBackgroundHover = Color3.fromRGB(255, 91, 91),
        
        -- Other elements
        DisabledBackground = Color3.fromRGB(60, 60, 65),
        DisabledText = Color3.fromRGB(150, 150, 150),
        AccentText = Color3.fromRGB(56, 113, 224),
        
        -- Customizable color
        AccentColor = Color3.fromRGB(56, 113, 224),
    },
    
    Dark = {
        -- Window elements
        Background = Color3.fromRGB(20, 20, 22),
        TitleBackground = Color3.fromRGB(30, 30, 35),
        TitleText = Color3.fromRGB(255, 255, 255),
        SubtitleText = Color3.fromRGB(190, 190, 190),
        TabBackground = Color3.fromRGB(25, 25, 27),
        ContentBackground = Color3.fromRGB(20, 20, 22),
        ScrollBar = Color3.fromRGB(80, 80, 85),
        
        -- Tab elements
        TabActive = Color3.fromRGB(50, 70, 200),
        TabInactive = Color3.fromRGB(35, 35, 37),
        TabHover = Color3.fromRGB(45, 45, 47),
        TabText = Color3.fromRGB(240, 240, 240),
        
        -- Component elements
        ComponentBackground = Color3.fromRGB(28, 28, 30),
        PrimaryText = Color3.fromRGB(255, 255, 255),
        SecondaryText = Color3.fromRGB(180, 180, 180),
        
        -- Button
        ButtonBackground = Color3.fromRGB(50, 70, 200),
        ButtonHover = Color3.fromRGB(70, 90, 220),
        ButtonPress = Color3.fromRGB(30, 50, 180),
        ButtonText = Color3.fromRGB(255, 255, 255),
        
        -- Toggle
        ToggleBackgroundOff = Color3.fromRGB(55, 55, 57),
        ToggleBackgroundOn = Color3.fromRGB(50, 70, 200),
        ToggleKnob = Color3.fromRGB(255, 255, 255),
        
        -- Slider
        SliderBackground = Color3.fromRGB(50, 50, 52),
        SliderFill = Color3.fromRGB(50, 70, 200),
        SliderKnob = Color3.fromRGB(255, 255, 255),
        
        -- Dropdown
        DropdownContentBackground = Color3.fromRGB(35, 35, 37),
        DropdownOptionBackground = Color3.fromRGB(40, 40, 42),
        DropdownOptionBackgroundHover = Color3.fromRGB(50, 50, 52),
        DropdownOptionText = Color3.fromRGB(255, 255, 255),
        
        -- Checkbox
        CheckboxBackground = Color3.fromRGB(50, 50, 52),
        CheckboxFill = Color3.fromRGB(50, 70, 200),
        
        -- Input
        InputBackground = Color3.fromRGB(35, 35, 37),
        InputBackgroundHover = Color3.fromRGB(45, 45, 47),
        InputText = Color3.fromRGB(255, 255, 255),
        PlaceholderText = Color3.fromRGB(120, 120, 120),
        
        -- Notification
        NotificationBackground = Color3.fromRGB(28, 28, 30),
        NotificationTitle = Color3.fromRGB(255, 255, 255),
        NotificationText = Color3.fromRGB(220, 220, 220),
        NotificationSubText = Color3.fromRGB(160, 160, 160),
        NotificationProgress = Color3.fromRGB(50, 70, 200),
        NotificationCloseButton = Color3.fromRGB(190, 190, 190),
        
        -- Dialog
        DialogBackground = Color3.fromRGB(28, 28, 30),
        DialogTitle = Color3.fromRGB(255, 255, 255),
        DialogText = Color3.fromRGB(220, 220, 220),
        
        -- Status colors
        SuccessBackground = Color3.fromRGB(56, 155, 60),
        SuccessBackgroundHover = Color3.fromRGB(66, 175, 70),
        WarningBackground = Color3.fromRGB(235, 132, 0),
        WarningBackgroundHover = Color3.fromRGB(255, 152, 0),
        DangerBackground = Color3.fromRGB(220, 51, 51),
        DangerBackgroundHover = Color3.fromRGB(240, 71, 71),
        
        -- Other elements
        DisabledBackground = Color3.fromRGB(50, 50, 52),
        DisabledText = Color3.fromRGB(130, 130, 130),
        AccentText = Color3.fromRGB(50, 70, 200),
        
        -- Customizable color
        AccentColor = Color3.fromRGB(50, 70, 200),
    },
    
    Light = {
        -- Window elements
        Background = Color3.fromRGB(245, 245, 247),
        TitleBackground = Color3.fromRGB(230, 230, 235),
        TitleText = Color3.fromRGB(30, 30, 35),
        SubtitleText = Color3.fromRGB(90, 90, 95),
        TabBackground = Color3.fromRGB(240, 240, 242),
        ContentBackground = Color3.fromRGB(245, 245, 247),
        ScrollBar = Color3.fromRGB(180, 180, 185),
        
        -- Tab elements
        TabActive = Color3.fromRGB(56, 113, 224),
        TabInactive = Color3.fromRGB(225, 225, 230),
        TabHover = Color3.fromRGB(215, 215, 220),
        TabText = Color3.fromRGB(30, 30, 35),
        
        -- Component elements
        ComponentBackground = Color3.fromRGB(235, 235, 240),
        PrimaryText = Color3.fromRGB(30, 30, 35),
        SecondaryText = Color3.fromRGB(90, 90, 95),
        
        -- Button
        ButtonBackground = Color3.fromRGB(56, 113, 224),
        ButtonHover = Color3.fromRGB(76, 133, 244),
        ButtonPress = Color3.fromRGB(36, 93, 204),
        ButtonText = Color3.fromRGB(255, 255, 255),
        
        -- Toggle
        ToggleBackgroundOff = Color3.fromRGB(180, 180, 185),
        ToggleBackgroundOn = Color3.fromRGB(56, 113, 224),
        ToggleKnob = Color3.fromRGB(255, 255, 255),
        
        -- Slider
        SliderBackground = Color3.fromRGB(180, 180, 185),
        SliderFill = Color3.fromRGB(56, 113, 224),
        SliderKnob = Color3.fromRGB(255, 255, 255),
        
        -- Dropdown
        DropdownContentBackground = Color3.fromRGB(235, 235, 240),
        DropdownOptionBackground = Color3.fromRGB(225, 225, 230),
        DropdownOptionBackgroundHover = Color3.fromRGB(215, 215, 220),
        DropdownOptionText = Color3.fromRGB(30, 30, 35),
        
        -- Checkbox
        CheckboxBackground = Color3.fromRGB(180, 180, 185),
        CheckboxFill = Color3.fromRGB(56, 113, 224),
        
        -- Input
        InputBackground = Color3.fromRGB(225, 225, 230),
        InputBackgroundHover = Color3.fromRGB(215, 215, 220),
        InputText = Color3.fromRGB(30, 30, 35),
        PlaceholderText = Color3.fromRGB(150, 150, 155),
        
        -- Notification
        NotificationBackground = Color3.fromRGB(235, 235, 240),
        NotificationTitle = Color3.fromRGB(30, 30, 35),
        NotificationText = Color3.fromRGB(60, 60, 65),
        NotificationSubText = Color3.fromRGB(120, 120, 125),
        NotificationProgress = Color3.fromRGB(56, 113, 224),
        NotificationCloseButton = Color3.fromRGB(90, 90, 95),
        
        -- Dialog
        DialogBackground = Color3.fromRGB(235, 235, 240),
        DialogTitle = Color3.fromRGB(30, 30, 35),
        DialogText = Color3.fromRGB(60, 60, 65),
        
        -- Status colors
        SuccessBackground = Color3.fromRGB(76, 175, 80),
        SuccessBackgroundHover = Color3.fromRGB(86, 195, 90),
        WarningBackground = Color3.fromRGB(255, 152, 0),
        WarningBackgroundHover = Color3.fromRGB(255, 172, 20),
        DangerBackground = Color3.fromRGB(240, 71, 71),
        DangerBackgroundHover = Color3.fromRGB(255, 91, 91),
        
        -- Other elements
        DisabledBackground = Color3.fromRGB(200, 200, 205),
        DisabledText = Color3.fromRGB(150, 150, 155),
        AccentText = Color3.fromRGB(56, 113, 224),
        
        -- Customizable color
        AccentColor = Color3.fromRGB(56, 113, 224),
    },
}

-- Current theme
Theme.CurrentTheme = "Default"

-- Get a color from the current theme
function Theme.GetColor(colorName)
    local currentThemeColors = Themes[Theme.CurrentTheme]
    
    if currentThemeColors and currentThemeColors[colorName] then
        return currentThemeColors[colorName]
    end
    
    -- Fallback to default theme
    if Themes.Default and Themes.Default[colorName] then
        return Themes.Default[colorName]
    end
    
    -- Last resort fallback
    return Color3.fromRGB(255, 255, 255)
end

-- Set the current theme
function Theme.SetTheme(themeName)
    if Themes[themeName] then
        Theme.CurrentTheme = themeName
    end
end

-- Get list of available themes
function Theme.GetThemes()
    local themeList = {}
    
    for themeName, _ in pairs(Themes) do
        table.insert(themeList, themeName)
    end
    
    return themeList
end

-- Add a custom theme
function Theme.AddTheme(name, themeColors)
    if name and type(themeColors) == "table" then
        Themes[name] = themeColors
    end
end

-- Set a custom color in the current theme
function Theme.SetCustomColor(colorName, color)
    if colorName and color then
        if not Themes[Theme.CurrentTheme] then
            Themes[Theme.CurrentTheme] = table.clone(Themes.Default)
        end
        
        Themes[Theme.CurrentTheme][colorName] = color
        
        -- If setting accent color, update related colors
        if colorName == "AccentColor" then
            -- Get color components
            local h, s, v = color:ToHSV()
            
            -- Create variations
            local hover = Color3.fromHSV(h, math.min(s * 0.8, 1), math.min(v * 1.2, 1))
            local press = Color3.fromHSV(h, math.min(s * 1.1, 1), math.min(v * 0.8, 1))
            
            -- Update accent-based colors
            Themes[Theme.CurrentTheme].TabActive = color
            Themes[Theme.CurrentTheme].ButtonBackground = color
            Themes[Theme.CurrentTheme].ButtonHover = hover
            Themes[Theme.CurrentTheme].ButtonPress = press
            Themes[Theme.CurrentTheme].ToggleBackgroundOn = color
            Themes[Theme.CurrentTheme].SliderFill = color
            Themes[Theme.CurrentTheme].CheckboxFill = color
            Themes[Theme.CurrentTheme].NotificationProgress = color
            Themes[Theme.CurrentTheme].AccentText = color
        end
    end
end

return Theme
