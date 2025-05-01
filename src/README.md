# Soluna UI Library

A modern, elegant UI library for Roblox exploits featuring a comprehensive set of UI components and a flexible system for creating custom interfaces.

## Features

- **Window System** - Customizable title, subtitle, size, and minimization
- **Tab System** - Organize UI elements with optional Lucide icons
- **Rich Component Library** - Buttons, toggles, sliders, dropdowns, and more
- **Theme System** - Built-in themes with customization options
- **Save Manager** - Save/load configurations with game-specific profiles
- **Clean Design** - Modern, flat design with acrylic effects and animations

## Usage

```lua
-- Load the Soluna library

loadstring(game:HttpGet("https://raw.githubusercontent.com/Patheticcs/Soluna-API/refs/heads/main/src/soluna/init.lua",true))()

-- Create a window
local window = Soluna:CreateWindow({
    Title = "Soluna Example",
    Subtitle = "v1.0.0",
    Size = {X = 550, Y = 600}
})

-- Add a tab
local mainTab = window:AddTab({
    Name = "Main",
    Icon = "Home"
})

-- Add components
mainTab:AddButton({
    Name = "Click Me",
    Callback = function()
        print("Button clicked!")
    end
})

mainTab:AddToggle({
    Name = "Feature Toggle",
    Default = false,
    Callback = function(value)
        print("Toggle:", value)
    end
})

-- Show a notification
Soluna:Notify({
    Title = "Welcome",
    Content = "Thanks for using Soluna UI",
    Duration = 5
})
```

## Documentation

See `example_usage.lua` for a comprehensive demonstration of all available components and features.

## License

This project is licensed under the MIT License - see the LICENSE.md file for details.
