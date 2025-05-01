--[[
    Soluna UI Library
    A modern, elegant UI library for Roblox exploits
]]

-- Base URL for raw GitHub content
local GITHUB_RAW = "https://raw.githubusercontent.com/Patheticcs/Soluna-API/main/src/soluna/"

-- Import function using GitHub raw content
local function ImportFromGithub(path)
    local success, result = pcall(function()
        return loadstring(game:HttpGet(GITHUB_RAW .. path))()
    end)
    
    if not success then
        warn("Failed to import: " .. path)
        warn("Error: " .. tostring(result))
        return {}
    end
    
    return result
end

local components = {
    Window = ImportFromGithub("components/window.lua"),
    Tab = ImportFromGithub("components/tab.lua"),
    Notification = ImportFromGithub("components/notification.lua"),
    Button = ImportFromGithub("components/button.lua"),
    Toggle = ImportFromGithub("components/toggle.lua"),
    Slider = ImportFromGithub("components/slider.lua"),
    Dropdown = ImportFromGithub("components/dropdown.lua"),
    ColorPicker = ImportFromGithub("components/colorpicker.lua"),
    Keybind = ImportFromGithub("components/keybind.lua"),
    Input = ImportFromGithub("components/input.lua"),
    Paragraph = ImportFromGithub("components/paragraph.lua"),
}

local managers = {
    SaveManager = ImportFromGithub("managers/savemanager.lua"),
    InterfaceManager = ImportFromGithub("managers/interfacemanager.lua"),
}

local utils = {
    Theme = ImportFromGithub("utils/theme.lua"),
    Icons = ImportFromGithub("utils/icons.lua"),
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
