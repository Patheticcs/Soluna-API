--[[
    InterfaceManager
    Manages interface settings and provides a settings tab
]]

local InterfaceManager = {}
InterfaceManager.__index = InterfaceManager

function InterfaceManager.new(library)
    local self = setmetatable({}, InterfaceManager)
    
    self.Library = library
    self.SettingsTab = nil
    
    return self
end

-- Create settings tab in a window
function InterfaceManager:CreateSettingsTab(window)
    if not window then
        -- Use first window if none provided
        if #self.Library.Windows > 0 then
            window = self.Library.Windows[1]
        else
            return
        end
    end
    
    -- Create the settings tab
    self.SettingsTab = window:AddTab({
        Name = "Settings",
        Icon = "Settings"
    })
    
    -- Add theme section
    self:_createThemeSection()
    
    -- Add configuration section
    self:_createConfigSection()
    
    return self.SettingsTab
end

-- Create theme section in settings tab
function InterfaceManager:_createThemeSection()
    -- Theme title
    self.SettingsTab:AddParagraph({
        Title = "Interface Theme",
        Content = "Customize the appearance of the interface."
    })
    
    -- Theme selector
    local themes = self.Library.Theme.GetThemes()
    self.ThemeDropdown = self.SettingsTab:AddDropdown({
        Name = "Theme",
        Options = themes,
        Default = self.Library.Theme.CurrentTheme,
        Callback = function(theme)
            self.Library.Theme.SetTheme(theme)
            
            -- Update all windows with new theme
            for _, window in ipairs(self.Library.Windows) do
                window:_updateTheme()
            end
        end
    })
    
    -- Acrylic toggle
    self.AcrylicToggle = self.SettingsTab:AddToggle({
        Name = "Acrylic Effect",
        Default = self.Library.Windows[1].Acrylic,
        Callback = function(value)
            for _, window in ipairs(self.Library.Windows) do
                window:ToggleAcrylic(value)
            end
        end
    })
    
    -- Color customization
    if #themes > 0 then
        self.CustomColorPicker = self.SettingsTab:AddColorPicker({
            Name = "Accent Color",
            Default = self.Library.Theme.GetColor("AccentColor"),
            Callback = function(color)
                self.Library.Theme.SetCustomColor("AccentColor", color)
                
                -- Update all windows with custom color
                for _, window in ipairs(self.Library.Windows) do
                    window:_updateTheme()
                end
            end
        })
    end
end

-- Create configuration section in settings tab
function InterfaceManager:_createConfigSection()
    -- Configuration title
    self.SettingsTab:AddParagraph({
        Title = "Configuration",
        Content = "Save, load, and manage your configurations."
    })
    
    -- Config name input
    self.ConfigNameInput = self.SettingsTab:AddInput({
        Name = "Config Name",
        PlaceholderText = "Enter config name...",
        Default = "config",
        CallbackOnlyOnEnter = true
    })
    
    -- Save config button
    self.SaveConfigButton = self.SettingsTab:AddButton({
        Name = "Save Configuration",
        Callback = function()
            local configName = self.ConfigNameInput:GetValue()
            
            if configName and configName ~= "" then
                self.Library.SaveManager:SaveConfig(configName)
                self:_refreshConfigList()
            else
                self.Library:Notify({
                    Title = "Error",
                    Content = "Please enter a configuration name",
                    Duration = 3
                })
            end
        end
    })
    
    -- Config list dropdown
    self.ConfigListDropdown = self.SettingsTab:AddDropdown({
        Name = "Saved Configurations",
        Options = self.Library.SaveManager:GetConfigs(),
        Callback = function(selected)
            if selected and selected ~= "" then
                self.SelectedConfig = selected
                self.ConfigNameInput:SetValue(selected)
            end
        end
    })
    
    -- Load config button
    self.LoadConfigButton = self.SettingsTab:AddButton({
        Name = "Load Configuration",
        Callback = function()
            local selected = self.SelectedConfig or self.ConfigListDropdown:GetValue()
            
            if selected and selected ~= "" then
                self.Library.SaveManager:LoadConfig(selected)
            else
                self.Library:Notify({
                    Title = "Error",
                    Content = "Please select a configuration first",
                    Duration = 3
                })
            end
        end
    })
    
    -- Delete config button
    self.DeleteConfigButton = self.SettingsTab:AddButton({
        Name = "Delete Configuration",
        ConfirmPrompt = "Are you sure you want to delete this configuration?",
        Callback = function()
            local selected = self.SelectedConfig or self.ConfigListDropdown:GetValue()
            
            if selected and selected ~= "" then
                self.Library.SaveManager:DeleteConfig(selected)
                self:_refreshConfigList()
            else
                self.Library:Notify({
                    Title = "Error",
                    Content = "Please select a configuration first",
                    Duration = 3
                })
            end
        end
    })
    
    -- Set autoload toggle
    self.AutoloadToggle = self.SettingsTab:AddToggle({
        Name = "Autoload Selected Config",
        Default = false,
        Callback = function(value)
            if value then
                local selected = self.SelectedConfig or self.ConfigListDropdown:GetValue()
                
                if selected and selected ~= "" then
                    self.Library.SaveManager:SetAutoloadConfig(selected)
                else
                    self.Library:Notify({
                        Title = "Error",
                        Content = "Please select a configuration first",
                        Duration = 3
                    })
                    self.AutoloadToggle:SetValue(false, true)
                end
            else
                self.Library.SaveManager:SetAutoloadConfig(nil)
            end
        end
    })
    
    -- Initialize autoload state based on current setting
    local currentAutoload = self.Library.SaveManager:GetAutoloadConfig()
    if currentAutoload then
        self.AutoloadToggle:SetValue(true, true)
        -- Select the autoload config in the dropdown
        self.ConfigListDropdown:SetValue(currentAutoload, true)
        self.SelectedConfig = currentAutoload
        self.ConfigNameInput:SetValue(currentAutoload)
    end
    
    -- Refresh button
    self.RefreshButton = self.SettingsTab:AddButton({
        Name = "Refresh Config List",
        Callback = function()
            self:_refreshConfigList()
        end
    })
}

-- Refresh the config list dropdown
function InterfaceManager:_refreshConfigList()
    -- Get updated config list
    local configs = self.Library.SaveManager:GetConfigs()
    
    -- Update dropdown options
    self.ConfigListDropdown:SetOptions(configs)
}

-- Set game-specific configuration folder
function InterfaceManager:SetGameConfigFolder(gameName)
    self.Library.SaveManager:SetGameConfigFolder(gameName)
    
    -- Refresh config list if it exists
    if self.ConfigListDropdown then
        self:_refreshConfigList()
    end
end

-- Set configuration options
function InterfaceManager:SetConfigOptions(options)
    options = options or {}
    
    -- Set ignore indexes
    if options.IgnoreIndexes then
        self.Library.SaveManager:SetIgnoreIndexes(options.IgnoreIndexes)
    end
    
    -- Set ignore theme settings
    if options.IgnoreThemeSettings ~= nil then
        self.Library.SaveManager:SetIgnoreThemeSettings(options.IgnoreThemeSettings)
    end
}

return InterfaceManager
