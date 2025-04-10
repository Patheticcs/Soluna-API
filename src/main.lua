local ScreenGui = Instance.new("ScreenGui")
local MainFrame = Instance.new("Frame")
local UICorner = Instance.new("UICorner")
local Title = Instance.new("TextLabel")
local Subtitle = Instance.new("TextLabel")
local OldButton = Instance.new("TextButton")
local OldCorner = Instance.new("UICorner")
local OldDescription = Instance.new("TextLabel")
local NewButton = Instance.new("TextButton")
local NewCorner = Instance.new("UICorner")
local NewDescription = Instance.new("TextLabel")
local FixedButton = Instance.new("TextButton")
local FixedCorner = Instance.new("UICorner")
local FixedDescription = Instance.new("TextLabel")
local UIBlur = Instance.new("BlurEffect")
local UIStroke = Instance.new("UIStroke")
local UIGradient = Instance.new("UIGradient")

-- Screen GUI Setup
ScreenGui.Parent = game.CoreGui
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

-- Main Frame - Glassmorphic Effect
MainFrame.Name = "LoaderFrame"
MainFrame.Parent = ScreenGui
MainFrame.BackgroundColor3 = Color3.fromRGB(255, 255, 255) -- White base for tinting
MainFrame.BackgroundTransparency = 0.85 -- High transparency for glass effect
MainFrame.BorderSizePixel = 0
MainFrame.Position = UDim2.new(0.5, -225, 0.5, -200)
MainFrame.Size = UDim2.new(0, 450, 0, 400)
MainFrame.ClipsDescendants = true

-- Rounded corners
UICorner.CornerRadius = UDim.new(0, 15)
UICorner.Parent = MainFrame

-- Border glow effect (mimicking the box-shadow and border from CSS)
UIStroke.Parent = MainFrame
UIStroke.Color = Color3.fromRGB(255, 255, 255)
UIStroke.Transparency = 0.82 -- Subtle border
UIStroke.Thickness = 1.5

-- Subtle gradient for depth
UIGradient.Color = ColorSequence.new{
    ColorSequenceKeypoint.new(0, Color3.fromRGB(30, 30, 40)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(15, 15, 25))
}
UIGradient.Rotation = 45
UIGradient.Parent = MainFrame

-- Background blur (simulating backdrop-filter)
UIBlur.Parent = game:GetService("Lighting")
UIBlur.Size = 10

-- Title styling
Title.Name = "Title"
Title.Parent = MainFrame
Title.BackgroundTransparency = 1
Title.Position = UDim2.new(0, 0, 0.05, 0)
Title.Size = UDim2.new(1, 0, 0, 40)
Title.Font = Enum.Font.GothamBold
Title.Text = "Script Loader"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.TextSize = 28
Title.TextTransparency = 0.1 -- Slight transparency for glass effect

-- Subtitle styling
Subtitle.Name = "Subtitle"
Subtitle.Parent = MainFrame
Subtitle.BackgroundTransparency = 1
Subtitle.Position = UDim2.new(0, 0, 0.15, 0)
Subtitle.Size = UDim2.new(1, 0, 0, 20)
Subtitle.Font = Enum.Font.Gotham
Subtitle.Text = "Select your preferred version"
Subtitle.TextColor3 = Color3.fromRGB(220, 220, 220)
Subtitle.TextSize = 14
Subtitle.TextTransparency = 0.2

-- Old Button - Glassmorphic
OldButton.Name = "OldButton"
OldButton.Parent = MainFrame
OldButton.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
OldButton.BackgroundTransparency = 0.8
OldButton.Position = UDim2.new(0.1, 0, 0.28, 0)
OldButton.Size = UDim2.new(0.8, 0, 0, 50)
OldButton.Font = Enum.Font.GothamSemibold
OldButton.Text = "OLD"
OldButton.TextColor3 = Color3.fromRGB(255, 255, 255)
OldButton.TextSize = 18
OldButton.AutoButtonColor = false

-- Create Stroke for button
local OldStroke = Instance.new("UIStroke")
OldStroke.Parent = OldButton
OldStroke.Color = Color3.fromRGB(255, 255, 255)
OldStroke.Transparency = 0.7
OldStroke.Thickness = 1

OldCorner.CornerRadius = UDim.new(0, 10)
OldCorner.Parent = OldButton

OldDescription.Name = "OldDescription"
OldDescription.Parent = MainFrame
OldDescription.BackgroundTransparency = 1
OldDescription.Position = UDim2.new(0.1, 0, 0.28, 55)
OldDescription.Size = UDim2.new(0.8, 0, 0, 20)
OldDescription.Font = Enum.Font.Gotham
OldDescription.Text = "Old Version - Stable but fewer features"
OldDescription.TextColor3 = Color3.fromRGB(200, 200, 200)
OldDescription.TextSize = 12
OldDescription.TextTransparency = 0.2

-- New Button - Glassmorphic
NewButton.Name = "NewButton"
NewButton.Parent = MainFrame
NewButton.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
NewButton.BackgroundTransparency = 0.8
NewButton.Position = UDim2.new(0.1, 0, 0.48, 0)
NewButton.Size = UDim2.new(0.8, 0, 0, 50)
NewButton.Font = Enum.Font.GothamSemibold
NewButton.Text = "NEW"
NewButton.TextColor3 = Color3.fromRGB(255, 255, 255)
NewButton.TextSize = 18
NewButton.AutoButtonColor = false

-- Create Stroke for button
local NewStroke = Instance.new("UIStroke")
NewStroke.Parent = NewButton
NewStroke.Color = Color3.fromRGB(255, 255, 255)
NewStroke.Transparency = 0.7
NewStroke.Thickness = 1

NewCorner.CornerRadius = UDim.new(0, 10)
NewCorner.Parent = NewButton

NewDescription.Name = "NewDescription"
NewDescription.Parent = MainFrame
NewDescription.BackgroundTransparency = 1
NewDescription.Position = UDim2.new(0.1, 0, 0.48, 55)
NewDescription.Size = UDim2.new(0.8, 0, 0, 20)
NewDescription.Font = Enum.Font.Gotham
NewDescription.Text = "New Version - More features but laggy"
NewDescription.TextColor3 = Color3.fromRGB(200, 200, 200)
NewDescription.TextSize = 12
NewDescription.TextTransparency = 0.2

-- Fixed Button - Glassmorphic
FixedButton.Name = "FixedButton"
FixedButton.Parent = MainFrame
FixedButton.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
FixedButton.BackgroundTransparency = 0.8
FixedButton.Position = UDim2.new(0.1, 0, 0.68, 0)
FixedButton.Size = UDim2.new(0.8, 0, 0, 50)
FixedButton.Font = Enum.Font.GothamSemibold
FixedButton.Text = "FIXED"
FixedButton.TextColor3 = Color3.fromRGB(255, 255, 255)
FixedButton.TextSize = 18
FixedButton.AutoButtonColor = false

-- Create Stroke for button
local FixedStroke = Instance.new("UIStroke")
FixedStroke.Parent = FixedButton
FixedStroke.Color = Color3.fromRGB(255, 255, 255)
FixedStroke.Transparency = 0.7
FixedStroke.Thickness = 1

FixedCorner.CornerRadius = UDim.new(0, 10)
FixedCorner.Parent = FixedButton

FixedDescription.Name = "FixedDescription"
FixedDescription.Parent = MainFrame
FixedDescription.BackgroundTransparency = 1
FixedDescription.Position = UDim2.new(0.1, 0, 0.68, 55)
FixedDescription.Size = UDim2.new(0.8, 0, 0, 20)
FixedDescription.Font = Enum.Font.Gotham
FixedDescription.Text = "Fixed Version - No lag but ESP/AutoShoot broken"
FixedDescription.TextColor3 = Color3.fromRGB(200, 200, 200)
FixedDescription.TextSize = 12
FixedDescription.TextTransparency = 0.2

-- Enhanced button hover effects for glassmorphic look
local function createGlassmorphicButtonEffect(button, stroke)
    button.MouseEnter:Connect(function()
        game:GetService("TweenService"):Create(button, TweenInfo.new(0.3), {
            BackgroundTransparency = 0.7, 
            BackgroundColor3 = Color3.fromRGB(255, 255, 255)
        }):Play()
        
        game:GetService("TweenService"):Create(stroke, TweenInfo.new(0.3), {
            Transparency = 0.5
        }):Play()
    end)

    button.MouseLeave:Connect(function()
        game:GetService("TweenService"):Create(button, TweenInfo.new(0.3), {
            BackgroundTransparency = 0.8, 
            BackgroundColor3 = Color3.fromRGB(255, 255, 255)
        }):Play()
        
        game:GetService("TweenService"):Create(stroke, TweenInfo.new(0.3), {
            Transparency = 0.7
        }):Play()
    end)
    
    button.MouseButton1Down:Connect(function()
        game:GetService("TweenService"):Create(button, TweenInfo.new(0.1), {
            BackgroundTransparency = 0.65,
            Size = UDim2.new(button.Size.X.Scale, button.Size.X.Offset - 4, button.Size.Y.Scale, button.Size.Y.Offset - 2),
            Position = UDim2.new(button.Position.X.Scale, button.Position.X.Offset + 2, button.Position.Y.Scale, button.Position.Y.Offset + 1)
        }):Play()
    end)
    
    button.MouseButton1Up:Connect(function()
        game:GetService("TweenService"):Create(button, TweenInfo.new(0.1), {
            BackgroundTransparency = 0.7,
            Size = UDim2.new(button.Size.X.Scale, button.Size.X.Offset + 4, button.Size.Y.Scale, button.Size.Y.Offset + 2),
            Position = UDim2.new(button.Position.X.Scale, button.Position.X.Offset - 2, button.Position.Y.Scale, button.Position.Y.Offset - 1)
        }):Play()
    end)
end

createGlassmorphicButtonEffect(OldButton, OldStroke)
createGlassmorphicButtonEffect(NewButton, NewStroke)
createGlassmorphicButtonEffect(FixedButton, FixedStroke)

-- Add particle effects for glass-like reflections
local function createGlassReflection(parent)
    local reflection = Instance.new("Frame")
    reflection.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    reflection.BackgroundTransparency = 0.8
    reflection.BorderSizePixel = 0
    reflection.Size = UDim2.new(0, 100, 0, 2)
    reflection.Position = UDim2.new(0, -100, 0.5, 0)
    reflection.Parent = parent
    
    -- Animation for the reflection
    spawn(function()
        while reflection.Parent do
            game:GetService("TweenService"):Create(reflection, TweenInfo.new(2), {
                Position = UDim2.new(1, 50, 0.5, 0)
            }):Play()
            wait(3)
            reflection.Position = UDim2.new(0, -100, 0.5, 0)
            wait(2)
        end
    end)
end

createGlassReflection(MainFrame)

-- Window close animation
local function closeLoader()
    -- Fade out and slide animation
    local fadeTween = game:GetService("TweenService"):Create(
        MainFrame, 
        TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.In), 
        {
            BackgroundTransparency = 1,
            Position = UDim2.new(0.5, -225, 1.2, 0)
        }
    )
    fadeTween:Play()
    
    -- Fade out all text elements
    for _, v in pairs(MainFrame:GetDescendants()) do
        if v:IsA("TextLabel") or v:IsA("TextButton") then
            game:GetService("TweenService"):Create(
                v, 
                TweenInfo.new(0.5), 
                {TextTransparency = 1}
            ):Play()
        end
        if v:IsA("UIStroke") then
            game:GetService("TweenService"):Create(
                v, 
                TweenInfo.new(0.5), 
                {Transparency = 1}
            ):Play()
        end
    end
    
    wait(0.5)
    UIBlur:Destroy()
    wait(0.1)
    ScreenGui:Destroy()
end

OldButton.MouseButton1Click:Connect(function()
    closeLoader()
    loadstring(game:HttpGet("https://raw.githubusercontent.com/Patheticcs/Soluna-API/refs/heads/main/src/v1.lua"))()
end)

NewButton.MouseButton1Click:Connect(function()
    closeLoader()
    loadstring(game:HttpGet("https://raw.githubusercontent.com/Patheticcs/Soluna-API/refs/heads/main/src/api/main.lua"))()
end)

FixedButton.MouseButton1Click:Connect(function()
    closeLoader()
    loadstring(game:HttpGet("https://raw.githubusercontent.com/Patheticcs/Soluna-API/refs/heads/main/src/api/fixed.lua"))()
end)

-- Fancy entrance animation
MainFrame.Position = UDim2.new(0.5, -225, 1.5, 0)
MainFrame.BackgroundTransparency = 1
UIStroke.Transparency = 1

-- Fade in elements
for _, v in pairs(MainFrame:GetDescendants()) do
    if v:IsA("TextLabel") or v:IsA("TextButton") then
        v.TextTransparency = 1
    end
    if v:IsA("UIStroke") and v ~= UIStroke then
        v.Transparency = 1
    end
end

-- Animate entrance
game:GetService("TweenService"):Create(
    MainFrame, 
    TweenInfo.new(0.7, Enum.EasingStyle.Back, Enum.EasingDirection.Out), 
    {
        Position = UDim2.new(0.5, -225, 0.5, -200),
        BackgroundTransparency = 0.85
    }
):Play()

game:GetService("TweenService"):Create(
    UIStroke, 
    TweenInfo.new(1, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), 
    {Transparency = 0.82}
):Play()

-- Fade in text elements with delay
wait(0.3)
for _, v in pairs(MainFrame:GetDescendants()) do
    if v:IsA("TextLabel") or v:IsA("TextButton") then
        game:GetService("TweenService"):Create(
            v, 
            TweenInfo.new(0.5), 
            {TextTransparency = v:IsA("TextLabel") and 0.2 or 0}
        ):Play()
    end
    if v:IsA("UIStroke") and v ~= UIStroke then
        game:GetService("TweenService"):Create(
            v, 
            TweenInfo.new(0.5), 
            {Transparency = 0.7}
        ):Play()
    end
end
