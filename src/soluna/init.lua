--[[ 
    Soluna UI Library
    A modern, elegant UI library for Roblox exploits
]]

-- Load components using loadstring (Updated to fix nil value error)
local function LoadComponent(url)
    local success, content = pcall(function()
        return game:HttpGet(url)
    end)
    
    if not success then
        warn("Failed to HTTP GET from: " .. url)
        warn("Error: " .. tostring(content))
        return {}
    end
    
    local loadSuccess, result = pcall(function()
        return loadstring(content)()
    end)
    
    if not loadSuccess then
        warn("Failed to loadstring component from: " .. url)
        warn("Error: " .. tostring(result))
        return {}
    end
    
    return result or {}
end

-- Components initialization with error handling
local components = {}
local componentUrls = {
    Window = "https://raw.githubusercontent.com/Patheticcs/Soluna-API/main/components/window.lua",
    Tab = "https://raw.githubusercontent.com/Patheticcs/Soluna-API/main/components/tab.lua",
    Notification = "https://raw.githubusercontent.com/Patheticcs/Soluna-API/main/components/notification.lua",
    Button = "https://raw.githubusercontent.com/Patheticcs/Soluna-API/main/components/button.lua",
    Toggle = "https://raw.githubusercontent.com/Patheticcs/Soluna-API/main/components/toggle.lua",
    Slider = "https://raw.githubusercontent.com/Patheticcs/Soluna-API/main/components/slider.lua",
    Dropdown = "https://raw.githubusercontent.com/Patheticcs/Soluna-API/main/components/dropdown.lua",
    ColorPicker = "https://raw.githubusercontent.com/Patheticcs/Soluna-API/main/components/colorpicker.lua",
    Keybind = "https://raw.githubusercontent.com/Patheticcs/Soluna-API/main/components/keybind.lua",
    Input = "https://raw.githubusercontent.com/Patheticcs/Soluna-API/main/components/input.lua",
    Paragraph = "https://raw.githubusercontent.com/Patheticcs/Soluna-API/main/components/paragraph.lua"
}

for name, url in pairs(componentUrls) do
    components[name] = LoadComponent(url)
    if type(components[name]) ~= "table" then
        warn("Component " .. name .. " didn't load properly, initializing as empty table")
        components[name] = {}
    end
    
    -- Ensure each component has a 'new' function
    if not components[name].new then
        components[name].new = function()
            warn("Using fallback constructor for " .. name)
            return {}
        end
    end
end

-- Manager initialization with error handling
local managers = {}
local managerUrls = {
    SaveManager = "https://raw.githubusercontent.com/Patheticcs/Soluna-API/main/managers/savemanager.lua",
    InterfaceManager = "https://raw.githubusercontent.com/Patheticcs/Soluna-API/main/managers/interfacemanager.lua"
}

for name, url in pairs(managerUrls) do
    managers[name] = LoadComponent(url)
    if type(managers[name]) ~= "table" then
        warn("Manager " .. name .. " didn't load properly, initializing as empty table")
        managers[name] = {}
    end
    
    -- Ensure each manager has a 'new' function
    if not managers[name].new then
        managers[name].new = function()
            warn("Using fallback constructor for " .. name)
            return {}
        end
    end
end

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
    
    -- Initialize managers with error handling
    pcall(function()
        self.SaveManager = managers.SaveManager.new(self)
    end)
    
    if not self.SaveManager then
        warn("SaveManager failed to initialize, creating dummy object")
        self.SaveManager = {
            CreateConfigSection = function() return {} end,
            LoadAutoSave = function() end,
            Save = function() end,
            Load = function() end
        }
    end
    
    pcall(function()
        self.InterfaceManager = managers.InterfaceManager.new(self)
    end)
    
    if not self.InterfaceManager then
        warn("InterfaceManager failed to initialize, creating dummy object")
        self.InterfaceManager = {
            SetLibrary = function() end,
            OnToggle = function() return function() end end,
            CreateDraggable = function() end,
            Debounce = function() return false end
        }
    end
    
    -- Store active windows
    self.Windows = {}
    
    return self
end

-- Create a new window with error handling
function Soluna:CreateWindow(options)
    options = options or {}
    
    local window = nil
    local success = pcall(function()
        window = components.Window.new(self, options)
    end)
    
    if not success or not window then
        warn("Failed to create window, returning dummy window")
        window = {
            AddTab = function() 
                return {
                    AddButton = function() return {} end,
                    AddToggle = function() return {} end,
                    AddSlider = function() return {} end,
                    AddDropdown = function() return {} end,
                    AddColorPicker = function() return {} end,
                    AddKeybind = function() return {} end,
                    AddInput = function() return {} end,
                    AddParagraph = function() return {} end
                }
            end,
            SetPosition = function() end,
            SetSize = function() end,
            SetTitle = function() end,
            SetVisible = function() end,
            Destroy = function() end
        }
    end
    
    table.insert(self.Windows, window)
    return window
end

-- Display a notification with error handling
function Soluna:Notify(options)
    options = options or {}
    
    local notification = nil
    local success = pcall(function()
        notification = components.Notification.create(self, options)
    end)
    
    if not success then
        warn("Failed to create notification")
        notification = {}
    end
    
    return notification
end

-- Initialize the library and return the instance
local function Initialize()
    local instance = Soluna.new()
    return instance
end

return Initialize()
