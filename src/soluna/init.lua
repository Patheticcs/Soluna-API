--[[
    Soluna UI Library
    A modern, customizable UI library for Roblox exploits
]]

local Soluna = {}
Soluna.__index = Soluna

-- Import components and managers
local components = {
    Window = require("soluna/components/window"),
    Tab = require("soluna/components/tab"),
    Notification = require("soluna/components/notification"),
    Button = require("soluna/components/button"),
    Toggle = require("soluna/components/toggle"),
    Slider = require("soluna/components/slider"),
    Dropdown = require("soluna/components/dropdown"),
    ColorPicker = require("soluna/components/colorpicker"),
    Keybind = require("soluna/components/keybind"),
    Input = require("soluna/components/input"),
    Paragraph = require("soluna/components/paragraph"),
}

local managers = {
    SaveManager = require("soluna/managers/savemanager"),
    InterfaceManager = require("soluna/managers/interfacemanager"),
}

local utils = {
    Theme = require("soluna/utils/theme"),
    Icons = require("soluna/utils/icons"),
}

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
