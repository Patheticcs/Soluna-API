local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local HttpService = game:GetService("HttpService")
local UserInputService = game:GetService("UserInputService")
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local Mouse = LocalPlayer:GetMouse()

local DefaultSettings = {
    AutoLoadEnabled = false,
    TeleportLoadEnabled = false,
    DisableScriptLoader = false,
    SelectedVersion = nil,
    SelectedTab = "Soluna",
    ScriptToggles = {
        Soluna_Classic = false,
        Soluna_Modern = false,
        Rivals_Classic = false,
        Rivals_Modern = false,
        Arsenal = false,
        Universal = false,
        BigPaintball2 = false,
        AimbotFFA = false
    }
}

local Settings = table.clone(DefaultSettings)

local function loadSettings()
    local success, savedSettings = pcall(function()
        return HttpService:JSONDecode(readfile("SolunaLoaderSettings.json"))
    end)

    if success and savedSettings then

        for key, value in pairs(DefaultSettings) do
            if savedSettings[key] == nil then
                savedSettings[key] = value
            end
        end

        if not savedSettings.ScriptToggles then
            savedSettings.ScriptToggles = DefaultSettings.ScriptToggles
        else
            for key, value in pairs(DefaultSettings.ScriptToggles) do
                if savedSettings.ScriptToggles[key] == nil then
                    savedSettings.ScriptToggles[key] = value
                end
            end
        end

        Settings = savedSettings
    end
end

local function saveSettings()
    writefile("SolunaLoaderSettings.json", HttpService:JSONEncode(Settings))
end

pcall(loadSettings)

if Settings.DisableScriptLoader then
    return
end

if Settings.AutoLoadEnabled then
    local function autoLoadSelectedScripts()
        if Settings.ScriptToggles.Soluna_Classic then
            loadstring(game:HttpGet("https://raw.githubusercontent.com/Patheticcs/Soluna-API/refs/heads/main/src/v1.lua"))()
        end
        if Settings.ScriptToggles.Soluna_Modern then
            loadstring(game:HttpGet("https://raw.githubusercontent.com/Patheticcs/Soluna-API/refs/heads/main/src/api/main.lua"))()
        end
        if Settings.ScriptToggles.Rivals_Classic then
            loadstring(game:HttpGet("https://raw.githubusercontent.com/Patheticcs/Soluna-API/refs/heads/main/src/v1.lua"))()
        end
        if Settings.ScriptToggles.Rivals_Modern then
            loadstring(game:HttpGet("https://raw.githubusercontent.com/Patheticcs/Soluna-API/refs/heads/main/src/api/main.lua"))()
        end
        if Settings.ScriptToggles.Arsenal then
            loadstring(game:HttpGet("https://soluna-script.vercel.app/arsenal.lua", true))()
        end
        if Settings.ScriptToggles.Universal then
            loadstring(game:HttpGet("https://soluna-script.vercel.app/universal.lua", true))()
        end
        if Settings.ScriptToggles.BigPaintball2 then
            loadstring(game:HttpGet("https://soluna-script.vercel.app/big-paintball-2.lua", true))()
        end
        if Settings.ScriptToggles.AimbotFFA then
            loadstring(game:HttpGet("https://soluna-script.vercel.app/Aimbot-FFA.lua", true))()
        end
    end

    autoLoadSelectedScripts()

    for _, enabled in pairs(Settings.ScriptToggles) do
        if enabled then
            return
        end
    end
end

if Settings.TeleportLoadEnabled then
    queue_on_teleport([[
        spawn(function()
            local Players = game:GetService("Players")
            local LocalPlayer = Players.LocalPlayer

            local function isGameLoaded()
                return game:IsLoaded() and LocalPlayer and LocalPlayer.Character and 
                       LocalPlayer.Character:FindFirstChild("HumanoidRootPart") and
                       workspace.CurrentCamera
            end

            if not LocalPlayer then
                LocalPlayer = Players:GetPropertyChangedSignal("LocalPlayer"):Wait()
                LocalPlayer = Players.LocalPlayer
            end

            if not LocalPlayer.Character or not LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
                LocalPlayer.CharacterAdded:Wait()

                while not LocalPlayer.Character:FindFirstChild("HumanoidRootPart") do
                    task.wait(0.1)
                end
            end

            if not isGameLoaded() then
                repeat task.wait(0.1) until isGameLoaded()
            end

            task.wait(1)

            pcall(function()
                loadstring(game:HttpGet("https://soluna-script.vercel.app/main.lua", true))()
            end)
        end)
    ]])
end

local Fluent = loadstring(game:HttpGet("https://github.com/dawid-scripts/Fluent/releases/latest/download/main.lua"))()
local SaveManager = loadstring(game:HttpGet("https://raw.githubusercontent.com/dawid-scripts/Fluent/master/Addons/SaveManager.lua"))()
local InterfaceManager = loadstring(game:HttpGet("https://raw.githubusercontent.com/dawid-scripts/Fluent/master/Addons/InterfaceManager.lua"))()

SaveManager:SetLibrary(Fluent)
InterfaceManager:SetLibrary(Fluent)

local Window = Fluent:CreateWindow({
    Title = "Soluna Script Loader",
    SubTitle = "Expanded Edition",
    TabWidth = 160,
    Size = UDim2.fromOffset(580, 460),
    Acrylic = true,
    Theme = "Dark",
    MinimizeKey = Enum.KeyCode.RightControl
})

local Tabs = {
    Soluna = Window:AddTab({ Title = "Soluna", Icon = "code" }),
    Rivals = Window:AddTab({ Title = "Rivals", Icon = "swords" }),
    Universal = Window:AddTab({ Title = "Universal", Icon = "globe" }),
    Other = Window:AddTab({ Title = "Other", Icon = "more-horizontal" }),
    Settings = Window:AddTab({ Title = "Settings", Icon = "settings" })
}

if Settings.SelectedTab and Tabs[Settings.SelectedTab] then
    for i, tab in pairs(Tabs) do
        if i == Settings.SelectedTab then
            Window:SelectTab(tab)
            break
        end
    end
else
    Window:SelectTab(1)
end

local Options = Fluent.Options

local SolunaMainSection = Tabs.Soluna:AddSection("Soluna Versions")

SolunaMainSection:AddParagraph({
    Title = "Welcome to Soluna",
    Content = "Toggle your preferred version of the Soluna script below, then click Load Selected."
})

local solunaClassicToggle = Tabs.Soluna:AddToggle("SolunaClassicToggle", {
    Title = "Soluna Classic",
    Default = Settings.ScriptToggles.Soluna_Classic,
    Callback = function(Value)
        Settings.ScriptToggles.Soluna_Classic = Value
        saveSettings()
    end
})

local solunaModernToggle = Tabs.Soluna:AddToggle("SolunaModernToggle", {
    Title = "Soluna Modern",
    Default = Settings.ScriptToggles.Soluna_Modern,
    Callback = function(Value)
        Settings.ScriptToggles.Soluna_Modern = Value
        saveSettings()
    end
})

Tabs.Soluna:AddButton({
    Title = "Load Selected Soluna Scripts",
    Description = "Load all toggled Soluna scripts",
    Callback = function()
        if Settings.ScriptToggles.Soluna_Classic then
            Fluent:Notify({
                Title = "Soluna",
                Content = "Loading Classic...",
                Duration = 3
            })
            loadstring(game:HttpGet("https://raw.githubusercontent.com/Patheticcs/Soluna-API/refs/heads/main/src/v1.lua"))()
        end

        if Settings.ScriptToggles.Soluna_Modern then
            Fluent:Notify({
                Title = "Soluna",
                Content = "Loading Modern...",
                Duration = 3
            })
            loadstring(game:HttpGet("https://raw.githubusercontent.com/Patheticcs/Soluna-API/refs/heads/main/src/api/main.lua"))()
        end

        if not Settings.ScriptToggles.Soluna_Classic and not Settings.ScriptToggles.Soluna_Modern then
            Fluent:Notify({
                Title = "Soluna",
                Content = "No scripts selected to load",
                Duration = 3
            })
        end
    end
})

local RivalsSection = Tabs.Rivals:AddSection("Rival Scripts")

local rivalsClassicToggle = Tabs.Rivals:AddToggle("RivalsClassicToggle", {
    Title = "Rivals Classic",
    Default = Settings.ScriptToggles.Rivals_Classic,
    Callback = function(Value)
        Settings.ScriptToggles.Rivals_Classic = Value
        saveSettings()
    end
})

local rivalsModernToggle = Tabs.Rivals:AddToggle("RivalsModernToggle", {
    Title = "Rivals Modern",
    Default = Settings.ScriptToggles.Rivals_Modern,
    Callback = function(Value)
        Settings.ScriptToggles.Rivals_Modern = Value
        saveSettings()
    end
})

Tabs.Rivals:AddButton({
    Title = "Load Selected Rivals Scripts",
    Description = "Load all toggled Rivals scripts",
    Callback = function()
        if Settings.ScriptToggles.Rivals_Classic then
            Fluent:Notify({
                Title = "Rivals",
                Content = "Loading Classic...",
                Duration = 3
            })
            loadstring(game:HttpGet("https://raw.githubusercontent.com/Patheticcs/Soluna-API/refs/heads/main/src/v1.lua"))()
        end

        if Settings.ScriptToggles.Rivals_Modern then
            Fluent:Notify({
                Title = "Rivals",
                Content = "Loading Modern...",
                Duration = 3
            })
            loadstring(game:HttpGet("https://raw.githubusercontent.com/Patheticcs/Soluna-API/refs/heads/main/src/api/main.lua"))()
        end

        if not Settings.ScriptToggles.Rivals_Classic and not Settings.ScriptToggles.Rivals_Modern then
            Fluent:Notify({
                Title = "Rivals",
                Content = "No scripts selected to load",
                Duration = 3
            })
        end
    end
})

local universalToggle = Tabs.Universal:AddToggle("UniversalToggle", {
    Title = "Universal Script",
    Default = Settings.ScriptToggles.Universal,
    Callback = function(Value)
        Settings.ScriptToggles.Universal = Value
        saveSettings()
    end
})

Tabs.Universal:AddButton({
    Title = "Load Universal Script",
    Description = "Load Universal script that works across many games",
    Callback = function()
        if Settings.ScriptToggles.Universal then
            Fluent:Notify({
                Title = "Universal",
                Content = "Loading Universal script...",
                Duration = 3
            })
            loadstring(game:HttpGet("https://soluna-script.vercel.app/universal.lua", true))()
        else
            Fluent:Notify({
                Title = "Universal",
                Content = "Universal script is not toggled on",
                Duration = 3
            })
        end
    end
})

local OtherSection = Tabs.Other:AddSection("Game-Specific Scripts")

local arsenalToggle = Tabs.Other:AddToggle("ArsenalToggle", {
    Title = "Arsenal",
    Default = Settings.ScriptToggles.Arsenal,
    Callback = function(Value)
        Settings.ScriptToggles.Arsenal = Value
        saveSettings()
    end
})

local bigPaintball2Toggle = Tabs.Other:AddToggle("BigPaintball2Toggle", {
    Title = "Big Paintball 2",
    Default = Settings.ScriptToggles.BigPaintball2,
    Callback = function(Value)
        Settings.ScriptToggles.BigPaintball2 = Value
        saveSettings()
    end
})

local aimbotFFAToggle = Tabs.Other:AddToggle("AimbotFFAToggle", {
    Title = "[🐰] Aimbot FFA 🎯",
    Default = Settings.ScriptToggles.AimbotFFA,
    Callback = function(Value)
        Settings.ScriptToggles.AimbotFFA = Value
        saveSettings()
    end
})

Tabs.Other:AddButton({
    Title = "Load Selected Game Scripts",
    Description = "Load all toggled game-specific scripts",
    Callback = function()
        local scriptsLoaded = false

        if Settings.ScriptToggles.Arsenal then
            Fluent:Notify({
                Title = "Arsenal",
                Content = "Loading Arsenal script...",
                Duration = 3
            })
            loadstring(game:HttpGet("https://soluna-script.vercel.app/arsenal.lua", true))()
            scriptsLoaded = true
        end

        if Settings.ScriptToggles.BigPaintball2 then
            Fluent:Notify({
                Title = "Big Paintball 2",
                Content = "Loading script...",
                Duration = 3
            })
            loadstring(game:HttpGet("https://soluna-script.vercel.app/big-paintball-2.lua", true))()
            scriptsLoaded = true
        end

        if Settings.ScriptToggles.AimbotFFA then
            Fluent:Notify({
                Title = "Aimbot FFA",
                Content = "Loading script...",
                Duration = 3
            })
            loadstring(game:HttpGet("https://soluna-script.vercel.app/Aimbot-FFA.lua", true))()
            scriptsLoaded = true
        end

        if not scriptsLoaded then
            Fluent:Notify({
                Title = "Game Scripts",
                Content = "No scripts selected to load",
                Duration = 3
            })
        end
    end
})

local SettingsSection = Tabs.Settings:AddSection("Loader Settings")

local autoLoadToggle = Tabs.Settings:AddToggle("AutoLoadToggle", {
    Title = "Auto-Load Selected Scripts",
    Default = Settings.AutoLoadEnabled,
    Callback = function(Value)
        Settings.AutoLoadEnabled = Value
        saveSettings()
    end
})

local teleportLoadToggle = Tabs.Settings:AddToggle("TeleportLoadToggle", {
    Title = "Load on Teleport",
    Default = Settings.TeleportLoadEnabled,
    Callback = function(Value)
        Settings.TeleportLoadEnabled = Value
        saveSettings()
    end
})

local disableScriptLoaderToggle = Tabs.Settings:AddToggle("DisableScriptLoaderToggle", {
    Title = "Disable Script Loader",
    Description = "Completely disables the script loader on next execution",
    Default = Settings.DisableScriptLoader,
    Callback = function(Value)
        Settings.DisableScriptLoader = Value
        saveSettings()

        if Value then
            Fluent:Notify({
                Title = "Script Loader",
                Content = "Script Loader will be disabled on next execution",
                Duration = 5
            })
        else
            Fluent:Notify({
                Title = "Script Loader",
                Content = "Script Loader will be enabled on next execution",
                Duration = 5
            })
        end
    end
})

Tabs.Settings:AddButton({
    Title = "Reload Script Loader",
    Description = "Reloads the script loader with the latest settings",
    Callback = function()
        Fluent:Notify({
            Title = "Script Loader",
            Content = "Reloading Script Loader...",
            Duration = 3
        })

        task.wait(1)
        loadstring(game:HttpGet("https://soluna-script.vercel.app/main.lua", true))()
    end
})

InterfaceManager:BuildInterfaceSection(Tabs.Settings)
SaveManager:BuildConfigSection(Tabs.Settings)

Fluent:Notify({
    Title = "Soluna Script Loader",
    Content = "Enhanced UI loaded successfully!",
    Duration = 5
})
