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
local UIGradient = Instance.new("UIGradient")

ScreenGui.Parent = game.CoreGui
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

MainFrame.Name = "LoaderFrame"
MainFrame.Parent = ScreenGui
MainFrame.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
MainFrame.BackgroundTransparency = 0.4
MainFrame.BorderSizePixel = 0
MainFrame.Position = UDim2.new(0.5, -225, 0.5, -200) 
MainFrame.Size = UDim2.new(0, 450, 0, 400) 
MainFrame.ClipsDescendants = true

UICorner.CornerRadius = UDim.new(0, 15)
UICorner.Parent = MainFrame

UIGradient.Color = ColorSequence.new{
    ColorSequenceKeypoint.new(0, Color3.fromRGB(40, 40, 40)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(20, 20, 20))
}
UIGradient.Rotation = 45
UIGradient.Parent = MainFrame

UIBlur.Parent = game:GetService("Lighting")
UIBlur.Size = 15

Title.Name = "Title"
Title.Parent = MainFrame
Title.BackgroundTransparency = 1
Title.Position = UDim2.new(0, 0, 0.05, 0)
Title.Size = UDim2.new(1, 0, 0, 40)
Title.Font = Enum.Font.GothamBold
Title.Text = "Script Loader"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.TextSize = 28

Subtitle.Name = "Subtitle"
Subtitle.Parent = MainFrame
Subtitle.BackgroundTransparency = 1
Subtitle.Position = UDim2.new(0, 0, 0.15, 0) 
Subtitle.Size = UDim2.new(1, 0, 0, 20)
Subtitle.Font = Enum.Font.Gotham
Subtitle.Text = "Select your preferred version"
Subtitle.TextColor3 = Color3.fromRGB(200, 200, 200)
Subtitle.TextSize = 14

OldButton.Name = "OldButton"
OldButton.Parent = MainFrame
OldButton.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
OldButton.BackgroundTransparency = 0.3
OldButton.Position = UDim2.new(0.1, 0, 0.28, 0) 
OldButton.Size = UDim2.new(0.8, 0, 0, 50)
OldButton.Font = Enum.Font.GothamSemibold
OldButton.Text = "OLD"
OldButton.TextColor3 = Color3.fromRGB(255, 255, 255)
OldButton.TextSize = 18
OldButton.AutoButtonColor = false

OldCorner.CornerRadius = UDim.new(0, 10)
OldCorner.Parent = OldButton

OldDescription.Name = "OldDescription"
OldDescription.Parent = MainFrame
OldDescription.BackgroundTransparency = 1
OldDescription.Position = UDim2.new(0.1, 0, 0.28, 55) 
OldDescription.Size = UDim2.new(0.8, 0, 0, 20)
OldDescription.Font = Enum.Font.Gotham
OldDescription.Text = "Old Version - Stable but fewer features"
OldDescription.TextColor3 = Color3.fromRGB(180, 180, 180)
OldDescription.TextSize = 12

NewButton.Name = "NewButton"
NewButton.Parent = MainFrame
NewButton.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
NewButton.BackgroundTransparency = 0.3
NewButton.Position = UDim2.new(0.1, 0, 0.48, 0) 
NewButton.Size = UDim2.new(0.8, 0, 0, 50)
NewButton.Font = Enum.Font.GothamSemibold
NewButton.Text = "NEW"
NewButton.TextColor3 = Color3.fromRGB(255, 255, 255)
NewButton.TextSize = 18
NewButton.AutoButtonColor = false

NewCorner.CornerRadius = UDim.new(0, 10)
NewCorner.Parent = NewButton

NewDescription.Name = "NewDescription"
NewDescription.Parent = MainFrame
NewDescription.BackgroundTransparency = 1
NewDescription.Position = UDim2.new(0.1, 0, 0.48, 55) 
NewDescription.Size = UDim2.new(0.8, 0, 0, 20)
NewDescription.Font = Enum.Font.Gotham
NewDescription.Text = "New Version - More features but laggy"
NewDescription.TextColor3 = Color3.fromRGB(180, 180, 180)
NewDescription.TextSize = 12

FixedButton.Name = "FixedButton"
FixedButton.Parent = MainFrame
FixedButton.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
FixedButton.BackgroundTransparency = 0.3
FixedButton.Position = UDim2.new(0.1, 0, 0.68, 0) 
FixedButton.Size = UDim2.new(0.8, 0, 0, 50)
FixedButton.Font = Enum.Font.GothamSemibold
FixedButton.Text = "FIXED"
FixedButton.TextColor3 = Color3.fromRGB(255, 255, 255)
FixedButton.TextSize = 18
FixedButton.AutoButtonColor = false

FixedCorner.CornerRadius = UDim.new(0, 10)
FixedCorner.Parent = FixedButton

FixedDescription.Name = "FixedDescription"
FixedDescription.Parent = MainFrame
FixedDescription.BackgroundTransparency = 1
FixedDescription.Position = UDim2.new(0.1, 0, 0.68, 55) 
FixedDescription.Size = UDim2.new(0.8, 0, 0, 20)
FixedDescription.Font = Enum.Font.Gotham
FixedDescription.Text = "Fixed Version - No lag but ESP/AutoShoot broken"
FixedDescription.TextColor3 = Color3.fromRGB(180, 180, 180)
FixedDescription.TextSize = 12

local function createButtonEffect(button)
    button.MouseEnter:Connect(function()
        game:GetService("TweenService"):Create(button, TweenInfo.new(0.3), {BackgroundTransparency = 0.1, BackgroundColor3 = Color3.fromRGB(60, 60, 60)}):Play()
    end)

    button.MouseLeave:Connect(function()
        game:GetService("TweenService"):Create(button, TweenInfo.new(0.3), {BackgroundTransparency = 0.3, BackgroundColor3 = Color3.fromRGB(40, 40, 40)}):Play()
    end)
end

createButtonEffect(OldButton)
createButtonEffect(NewButton)
createButtonEffect(FixedButton)

local function closeLoader()
    game:GetService("TweenService"):Create(MainFrame, TweenInfo.new(0.5, Enum.EasingStyle.Back, Enum.EasingDirection.In), {Position = UDim2.new(0.5, -225, 1.5, 0)}):Play()
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

MainFrame.Position = UDim2.new(0.5, -225, 1.5, 0)
game:GetService("TweenService"):Create(MainFrame, TweenInfo.new(0.7, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {Position = UDim2.new(0.5, -225, 0.5, -200)}):Play()
