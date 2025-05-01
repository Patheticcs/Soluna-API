--[[
    SaveManager
    Save, load, and manage configurations
]]

local SaveManager = {}
SaveManager.__index = SaveManager

function SaveManager.new(library)
    local self = setmetatable({}, SaveManager)
    
    self.Library = library
    self.Folder = "soluna"
    self.ConfigFolder = "soluna/configs"
    self.GameConfigFolder = nil
    self.IgnoreIndexes = {}
    self.IgnoreThemeSettings = false
    self.AutoloadConfigName = nil
    
    -- Create folders if they don't exist
    self:_ensureFolders()
    
    -- Check for autoload config
    self:_loadAutoloadConfig()
    
    return self
end

-- Ensure necessary folders exist
function SaveManager:_ensureFolders()
    -- Create main folder
    if not isfolder(self.Folder) then
        makefolder(self.Folder)
    end
    
    -- Create configs folder
    if not isfolder(self.ConfigFolder) then
        makefolder(self.ConfigFolder)
    end
end

-- Set a game-specific config folder
function SaveManager:SetGameConfigFolder(gameName)
    if not gameName then return end
    
    -- Create game-specific folder path
    self.GameConfigFolder = self.ConfigFolder .. "/" .. gameName
    
    -- Create the folder if it doesn't exist
    if not isfolder(self.GameConfigFolder) then
        makefolder(self.GameConfigFolder)
    end
end

-- Get the active config folder path
function SaveManager:_getConfigFolder()
    return self.GameConfigFolder or self.ConfigFolder
end

-- Set indexes to ignore when saving/loading
function SaveManager:SetIgnoreIndexes(indexes)
    self.IgnoreIndexes = indexes or {}
end

-- Set whether to ignore theme settings
function SaveManager:SetIgnoreThemeSettings(ignore)
    self.IgnoreThemeSettings = ignore
end

-- Check if an index should be ignored
function SaveManager:_shouldIgnore(index)
    for _, ignoredIndex in ipairs(self.IgnoreIndexes) do
        if ignoredIndex == index then
            return true
        end
    end
    return false
end

-- Save the current configuration
function SaveManager:SaveConfig(configName)
    if not configName then return false, "No config name provided" end
    
    -- Ensure folders exist
    self:_ensureFolders()
    
    -- Build configuration table
    local config = self:_buildConfigTable()
    
    -- Create config file path
    local configPath = self:_getConfigFolder() .. "/" .. configName .. ".json"
    
    -- Save configuration to file
    local success, result = pcall(function()
        writefile(configPath, game:GetService("HttpService"):JSONEncode(config))
    end)
    
    if success then
        self.Library:Notify({
            Title = "Config Saved",
            Content = "Successfully saved config: " .. configName,
            Duration = 3
        })
        return true
    else
        self.Library:Notify({
            Title = "Save Failed",
            Content = "Failed to save config: " .. tostring(result),
            Duration = 5
        })
        return false, result
    end
end

-- Build configuration table from UI elements
function SaveManager:_buildConfigTable()
    local config = {
        _Metadata = {
            Version = self.Library.Version,
            SavedAt = os.time()
        }
    }
    
    -- Save theme if not ignored
    if not self.IgnoreThemeSettings then
        config.Theme = self.Library.Theme.CurrentTheme
    end
    
    -- Iterate through all UI elements to save their values
    for _, window in ipairs(self.Library.Windows) do
        for _, tab in ipairs(window.Tabs) do
            for _, component in ipairs(tab.Components) do
                -- Get component type and name
                local componentType = getmetatable(component).__index
                local componentName = component.Name
                
                -- Skip ignored components
                if self:_shouldIgnore(componentName) then
                    continue
                end
                
                -- Save component value based on type
                if componentType == require("soluna/components/toggle") then
                    config[componentName] = component:GetValue()
                elseif componentType == require("soluna/components/slider") then
                    config[componentName] = component:GetValue()
                elseif componentType == require("soluna/components/dropdown") then
                    config[componentName] = component:GetValue()
                elseif componentType == require("soluna/components/colorpicker") then
                    local color, transparency = component:GetColor()
                    config[componentName] = {
                        Color = {color.R, color.G, color.B},
                        Transparency = transparency
                    }
                elseif componentType == require("soluna/components/keybind") then
                    config[componentName] = {
                        Value = tostring(component:GetKeybind()),
                        Mode = component.Mode,
                        State = component:GetState()
                    }
                elseif componentType == require("soluna/components/input") then
                    config[componentName] = component:GetValue()
                end
            end
        end
    end
    
    return config
end

-- Load a saved configuration
function SaveManager:LoadConfig(configName)
    if not configName then return false, "No config name provided" end
    
    -- Create config file path
    local configPath = self:_getConfigFolder() .. "/" .. configName .. ".json"
    
    -- Check if config exists
    if not isfile(configPath) then
        self.Library:Notify({
            Title = "Config Not Found",
            Content = "Config file does not exist: " .. configName,
            Duration = 3
        })
        return false, "Config file not found"
    end
    
    -- Load configuration from file
    local success, config = pcall(function()
        return game:GetService("HttpService"):JSONDecode(readfile(configPath))
    end)
    
    if not success then
        self.Library:Notify({
            Title = "Load Failed",
            Content = "Failed to parse config file: " .. tostring(config),
            Duration = 5
        })
        return false, config
    end
    
    -- Apply configuration to UI elements
    self:_applyConfig(config)
    
    self.Library:Notify({
        Title = "Config Loaded",
        Content = "Successfully loaded config: " .. configName,
        Duration = 3
    })
    
    return true
end

-- Apply loaded configuration to UI elements
function SaveManager:_applyConfig(config)
    -- Apply theme if not ignored and included in config
    if not self.IgnoreThemeSettings and config.Theme then
        self.Library.Theme.SetTheme(config.Theme)
        
        -- Update all windows with new theme
        for _, window in ipairs(self.Library.Windows) do
            window:_updateTheme()
        end
    end
    
    -- Iterate through all UI elements to apply saved values
    for _, window in ipairs(self.Library.Windows) do
        for _, tab in ipairs(window.Tabs) do
            for _, component in ipairs(tab.Components) do
                -- Get component type and name
                local componentType = getmetatable(component).__index
                local componentName = component.Name
                
                -- Skip ignored components
                if self:_shouldIgnore(componentName) or not config[componentName] then
                    continue
                end
                
                -- Apply component value based on type
                if componentType == require("soluna/components/toggle") then
                    component:SetValue(config[componentName])
                elseif componentType == require("soluna/components/slider") then
                    component:SetValue(config[componentName])
                elseif componentType == require("soluna/components/dropdown") then
                    component:SetValue(config[componentName])
                elseif componentType == require("soluna/components/colorpicker") then
                    local colorData = config[componentName]
                    if colorData and colorData.Color then
                        local color = Color3.new(colorData.Color[1], colorData.Color[2], colorData.Color[3])
                        component:SetColor(color, colorData.Transparency)
                    end
                elseif componentType == require("soluna/components/keybind") then
                    local keybindData = config[componentName]
                    if keybindData then
                        -- Convert string back to KeyCode
                        local keyCodeString = keybindData.Value:gsub("Enum.KeyCode.", "")
                        local keyCode = Enum.KeyCode[keyCodeString]
                        
                        if keyCode then
                            component:SetKeybind(keyCode)
                        end
                        
                        -- Set mode and state if available
                        if keybindData.Mode then
                            component:SetMode(keybindData.Mode)
                        end
                        
                        if keybindData.State ~= nil then
                            component:SetState(keybindData.State)
                        end
                    end
                elseif componentType == require("soluna/components/input") then
                    component:SetValue(config[componentName])
                end
            end
        end
    end
end

-- Get list of available configs
function SaveManager:GetConfigs()
    -- Ensure folders exist
    self:_ensureFolders()
    
    -- Get files in config folder
    local configFiles = listfiles(self:_getConfigFolder())
    local configs = {}
    
    -- Filter for .json files and extract names
    for _, filePath in ipairs(configFiles) do
        if filePath:sub(-5) == ".json" then
            local fileName = filePath:match("[^/\\]+$")
            local configName = fileName:sub(1, -6) -- Remove .json extension
            table.insert(configs, configName)
        end
    end
    
    return configs
end

-- Delete a configuration
function SaveManager:DeleteConfig(configName)
    if not configName then return false, "No config name provided" end
    
    -- Create config file path
    local configPath = self:_getConfigFolder() .. "/" .. configName .. ".json"
    
    -- Check if config exists
    if not isfile(configPath) then
        self.Library:Notify({
            Title = "Config Not Found",
            Content = "Config file does not exist: " .. configName,
            Duration = 3
        })
        return false, "Config file not found"
    end
    
    -- Delete the file
    local success, result = pcall(function()
        delfile(configPath)
    end)
    
    if success then
        -- If deleted config was the autoload config, remove autoload setting
        if self.AutoloadConfigName == configName then
            self:SetAutoloadConfig(nil)
        end
        
        self.Library:Notify({
            Title = "Config Deleted",
            Content = "Successfully deleted config: " .. configName,
            Duration = 3
        })
        return true
    else
        self.Library:Notify({
            Title = "Delete Failed",
            Content = "Failed to delete config: " .. tostring(result),
            Duration = 5
        })
        return false, result
    end
end

-- Set a config to autoload
function SaveManager:SetAutoloadConfig(configName)
    -- If nil, remove autoload
    if not configName then
        self.AutoloadConfigName = nil
        
        -- Remove autoload file if it exists
        if isfile(self.Folder .. "/autoload.txt") then
            delfile(self.Folder .. "/autoload.txt")
        end
        
        return true
    end
    
    -- Check if config exists
    local configPath = self:_getConfigFolder() .. "/" .. configName .. ".json"
    if not isfile(configPath) then
        self.Library:Notify({
            Title = "Config Not Found",
            Content = "Cannot set autoload: Config file does not exist",
            Duration = 3
        })
        return false, "Config file not found"
    end
    
    -- Save autoload setting
    local autoloadData = {
        ConfigName = configName,
        FolderPath = self:_getConfigFolder()
    }
    
    -- Save to file
    local success, result = pcall(function()
        writefile(self.Folder .. "/autoload.txt", game:GetService("HttpService"):JSONEncode(autoloadData))
    end)
    
    if success then
        self.AutoloadConfigName = configName
        self.Library:Notify({
            Title = "Autoload Set",
            Content = "Config will autoload: " .. configName,
            Duration = 3
        })
        return true
    else
        self.Library:Notify({
            Title = "Autoload Failed",
            Content = "Failed to set autoload config: " .. tostring(result),
            Duration = 5
        })
        return false, result
    end
end

-- Load autoload config if available
function SaveManager:_loadAutoloadConfig()
    -- Check if autoload file exists
    if not isfile(self.Folder .. "/autoload.txt") then
        return
    end
    
    -- Load autoload data
    local success, autoloadData = pcall(function()
        return game:GetService("HttpService"):JSONDecode(readfile(self.Folder .. "/autoload.txt"))
    end)
    
    if not success or not autoloadData or not autoloadData.ConfigName then
        return
    end
    
    -- Set current autoload config name
    self.AutoloadConfigName = autoloadData.ConfigName
    
    -- Check if folder path matches current game folder
    if autoloadData.FolderPath == self:_getConfigFolder() then
        -- Load the config
        delay(1, function() -- Delay to ensure UI is fully initialized
            self:LoadConfig(autoloadData.ConfigName)
        end)
    end
end

-- Get current autoload config name
function SaveManager:GetAutoloadConfig()
    return self.AutoloadConfigName
end

return SaveManager
