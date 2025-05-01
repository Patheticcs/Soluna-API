--[[ 
    Soluna UI Library
    A modern, elegant UI library for Roblox exploits
]]

-- Load components using loadstring
local function LoadComponent(url)
    local success, result = pcall(function()
        return loadstring(game:HttpGet(url))()
    end)
    
    if not success then
        warn("Failed to load component from: " .. url)
        warn("Error: " .. tostring(result))
        return {}
    end
    
    return result
end

local components = {
    Window = LoadComponent("https://raw.githubusercontent.com/Patheticcs/Soluna-API/main/components/window.lua"),
    Tab = LoadComponent("https://raw.githubusercontent.com/Patheticcs/Soluna-API/main/components/tab.lua"),
    Notification = LoadComponent("https://raw.githubusercontent.com/Patheticcs/Soluna-API/main/components/notification.lua"),
    Button = LoadComponent("https://raw.githubusercontent.com/Patheticcs/Soluna-API/main/components/button.lua"),
    Toggle = LoadComponent("https://raw.githubusercontent.com/Patheticcs/Soluna-API/main/components/toggle.lua"),
    Slider = LoadComponent("https://raw.githubusercontent.com/Patheticcs/Soluna-API/main/components/slider.lua"),
    Dropdown = LoadComponent("https://raw.githubusercontent.com/Patheticcs/Soluna-API/main/components/dropdown.lua"),
    ColorPicker = LoadComponent("https://raw.githubusercontent.com/Patheticcs/Soluna-API/main/components/colorpicker.lua"),
    Keybind = LoadComponent("https://raw.githubusercontent.com/Patheticcs/Soluna-API/main/components/keybind.lua"),
    Input = LoadComponent("https://raw.githubusercontent.com/Patheticcs/Soluna-API/main/components/input.lua"),
    Paragraph = LoadComponent("https://raw.githubusercontent.com/Patheticcs/Soluna-API/main/components/paragraph.lua")
}

local managers = {
    SaveManager = LoadComponent("https://raw.githubusercontent.com/Patheticcs/Soluna-API/main/managers/savemanager.lua"),
    InterfaceManager = LoadComponent("https://raw.githubusercontent.com/Patheticcs/Soluna-API/main/managers/interfacemanager.lua")
}

local utils = {
    Theme = {
        -- Define your theme constants here
        Background = Color3.fromRGB(30, 30, 30),
        Foreground = Color3.fromRGB(40, 40, 40),
        Text = Color3.fromRGB(255, 255, 255),
        Accent = Color3.fromRGB(0, 120, 255)
    },
    Icons = {
        -- Define your icons here
        Close = "rbxassetid://...",
        Minimize = "rbxassetid://..."
    }
}

-- Create Soluna object
local Soluna = {}
Soluna.__index = Soluna

-- Version info
Soluna.Version = "1.0.0"
Soluna.Theme = utils.Theme
Soluna.Icons = utils.Icons

-- Create a new Soluna instance
function Soluna.new()
    local self = setmetatable({}, Soluna)
    
    -- Initialize managers
    self.SaveManager = managers.SaveManager.new(self)
    self.InterfaceManager = managers.InterfaceManager.new(self)
    
    -- Store active windows
    self.Windows = {}
    
    return self
end

-- Create a new window
function Soluna:CreateWindow(options)
    options = options or {}
    local window = components.Window.new(self, options)
    table.insert(self.Windows, window)
    return window
end

-- Display a notification
function Soluna:Notify(options)
    return components.Notification.create(self, options)
end

-- Initialize the library and return the instance
local function Initialize()
    local instance = Soluna.new()
    return instance
end

return Initialize()
