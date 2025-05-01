--[[
    Soluna UI Library
    A modern, elegant UI library for Roblox exploits
]]

-- Local component imports
local function ImportLocal(path)
    local success, result = pcall(function()
        return loadstring(readfile(path))()
    end)
    
    if not success then
        warn("Failed to import: " .. path)
        warn("Error: " .. tostring(result))
        return {}
    end
    
    return result
end

local components = {
    Window = ImportLocal("https://raw.githubusercontent.com/Patheticcs/Soluna-API/refs/heads/main/src/soluna/components/window.lua"),
    Tab = ImportLocal("https://raw.githubusercontent.com/Patheticcs/Soluna-API/refs/heads/main/src/soluna/components/tab.lua"),
    Notification = ImportLocal("https://raw.githubusercontent.com/Patheticcs/Soluna-API/refs/heads/main/src/soluna/components/notification.lua"),
    Button = ImportLocal("https://raw.githubusercontent.com/Patheticcs/Soluna-API/refs/heads/main/src/soluna/components/button.lua"),
    Toggle = ImportLocal("https://raw.githubusercontent.com/Patheticcs/Soluna-API/refs/heads/main/src/soluna/components/toggle.lua"),
    Slider = ImportLocal("https://raw.githubusercontent.com/Patheticcs/Soluna-API/refs/heads/main/src/soluna/components/slider.lua"),
    Dropdown = ImportLocal("https://raw.githubusercontent.com/Patheticcs/Soluna-API/refs/heads/main/src/soluna/components/dropdown.lua"),
    ColorPicker = ImportLocal("https://raw.githubusercontent.com/Patheticcs/Soluna-API/refs/heads/main/src/soluna/components/colorpicker.lua"),
    Keybind = ImportLocal("https://raw.githubusercontent.com/Patheticcs/Soluna-API/refs/heads/main/src/soluna/components/keybind.lua"),
    Input = ImportLocal("https://raw.githubusercontent.com/Patheticcs/Soluna-API/refs/heads/main/src/soluna/components/input.lua"),
    Paragraph = ImportLocal("https://raw.githubusercontent.com/Patheticcs/Soluna-API/refs/heads/main/src/soluna/components/paragraph.lua"),
}

local managers = {
    SaveManager = ImportLocal("https://raw.githubusercontent.com/Patheticcs/Soluna-API/refs/heads/main/src/soluna/managers/savemanager.lua"),
    InterfaceManager = ImportLocal("https://raw.githubusercontent.com/Patheticcs/Soluna-API/refs/heads/main/src/soluna/managers/interfacemanager.lua"),
}

local utils = {
    Theme = ImportLocal("https://raw.githubusercontent.com/Patheticcs/Soluna-API/refs/heads/main/src/soluna/utils/theme.lua"),
    Icons = ImportLocal("https://raw.githubusercontent.com/Patheticcs/Soluna-API/refs/heads/main/src/soluna/utils/icons.lua"),
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
