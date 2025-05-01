--[[
    Soluna UI Library
    A modern, elegant UI library for Roblox exploits
]]

-- Local imports
local function ImportLocal(path)
    local success, result = pcall(function()
        return require(path)
    end)
    
    if not success then
        warn("Failed to import: " .. path)
        warn("Error: " .. tostring(result))
        return {}
    end
    
    return result
end

local components = {
    Window = ImportLocal("soluna/components/window"),
    Tab = ImportLocal("soluna/components/tab"),
    Notification = ImportLocal("soluna/components/notification"),
    Button = ImportLocal("soluna/components/button"),
    Toggle = ImportLocal("soluna/components/toggle"),
    Slider = ImportLocal("soluna/components/slider"),
    Dropdown = ImportLocal("soluna/components/dropdown"),
    ColorPicker = ImportLocal("soluna/components/colorpicker"),
    Keybind = ImportLocal("soluna/components/keybind"),
    Input = ImportLocal("soluna/components/input"),
    Paragraph = ImportLocal("soluna/components/paragraph"),
}

local managers = {
    SaveManager = ImportLocal("soluna/managers/savemanager"),
    InterfaceManager = ImportLocal("soluna/managers/interfacemanager"),
}

local utils = {
    Theme = ImportLocal("soluna/utils/theme"),
    Icons = ImportLocal("soluna/utils/icons"),
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
