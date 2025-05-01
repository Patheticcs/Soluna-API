--[[
    Soluna UI Library - Example Usage
    
    This file demonstrates how to use the Soluna UI library in a Roblox exploit script.
    
    To use, just paste this code into your exploit's script executor.
]]

-- Load the Soluna library
local Soluna = loadstring(game:HttpGet("https://raw.githubusercontent.com/yourusername/soluna/main/src/soluna/init.lua"))()

-- Create a window
local window = Soluna:CreateWindow({
    Title = "Soluna Example",
    Subtitle = "v1.0.0",
    Size = {X = 550, Y = 600},
    MinimizeKey = Enum.KeyCode.RightShift
})

-- Create tabs
local mainTab = window:AddTab({
    Name = "Main",
    Icon = "Home"
})

local settingsTab = window:AddTab({
    Name = "Settings",
    Icon = "Settings"
})

--------------------------------------------------
-- Main Tab
--------------------------------------------------

-- Add paragraph
mainTab:AddParagraph({
    Title = "Welcome to Soluna UI",
    Content = "This is an example of the Soluna UI library. This paragraph component can be used to display information to the user."
})

-- Add button
mainTab:AddButton({
    Name = "Simple Button",
    Callback = function()
        print("Button clicked!")
    end
})

-- Add button with confirmation
mainTab:AddButton({
    Name = "Button with Confirmation",
    ConfirmPrompt = "Are you sure you want to do this?",
    Callback = function()
        print("Confirmed action!")
    end
})

-- Add toggle
local toggle = mainTab:AddToggle({
    Name = "Toggle Feature",
    Default = false,
    Callback = function(value)
        print("Toggle set to:", value)
    end
})

-- Add slider
local slider = mainTab:AddSlider({
    Name = "Speed",
    Min = 0,
    Max = 100,
    Default = 16,
    Rounding = 0,
    Callback = function(value)
        print("Slider value:", value)
    end
})

-- Add dropdown (single select)
local dropdown = mainTab:AddDropdown({
    Name = "Select Option",
    Options = {"Option 1", "Option 2", "Option 3"},
    Default = "Option 1",
    Callback = function(option)
        print("Selected option:", option)
    end
})

-- Add dropdown (multi select)
local multiDropdown = mainTab:AddMultiDropdown({
    Name = "Select Multiple",
    Options = {"Item 1", "Item 2", "Item 3", "Item 4"},
    Default = {"Item 1"},
    Callback = function(options)
        print("Selected items:")
        for _, option in ipairs(options) do
            print("  -", option)
        end
    end
})

-- Add color picker
local colorPicker = mainTab:AddColorPicker({
    Name = "UI Color",
    Default = Color3.fromRGB(56, 113, 224),
    Callback = function(color, transparency)
        print("Selected color:", color, "Transparency:", transparency)
    end
})

-- Add keybind
local keybind = mainTab:AddKeybind({
    Name = "Toggle UI",
    Default = Enum.KeyCode.RightShift,
    Mode = "Toggle",
    OnClick = function(state)
        print("Keybind activated, state:", state)
    end,
    OnChanged = function(key)
        print("Keybind changed to:", key)
    end
})

-- Add input field
local input = mainTab:AddInput({
    Name = "Player Name",
    PlaceholderText = "Enter name...",
    Default = "",
    NumericOnly = false,
    Callback = function(text)
        print("Input text:", text)
    end
})

--------------------------------------------------
-- Settings Tab
--------------------------------------------------

-- Create theme section
settingsTab:AddParagraph({
    Title = "Interface Settings",
    Content = "Customize the appearance and behavior of the interface."
})

-- Theme picker
local themes = Soluna.Theme.GetThemes()
local themeDropdown = settingsTab:AddDropdown({
    Name = "Theme",
    Options = themes,
    Default = Soluna.Theme.CurrentTheme,
    Callback = function(theme)
        Soluna.Theme.SetTheme(theme)
        
        -- Update all windows with new theme
        for _, win in ipairs(Soluna.Windows) do
            win:_updateTheme()
        end
    end
})

-- Acrylic effect toggle
local acrylicToggle = settingsTab:AddToggle({
    Name = "Acrylic Effect",
    Default = window.Acrylic,
    Callback = function(value)
        window:ToggleAcrylic(value)
    end
})

-- Show a notification
Soluna:Notify({
    Title = "Welcome!",
    Content = "Thanks for using Soluna UI Library",
    SubContent = "Created with ♥",
    Duration = 5
})

-- Set interface manager game folder (for game-specific configs)
Soluna.InterfaceManager:SetGameConfigFolder(game.PlaceId)

-- Set config options
Soluna.InterfaceManager:SetConfigOptions({
    IgnoreIndexes = {"PlayerName", "SensitiveOption"},
    IgnoreThemeSettings = false
})

-- Create settings interface (automatic config UI)
Soluna.InterfaceManager:CreateSettingsTab(window)

print("Soluna UI initialized!")
