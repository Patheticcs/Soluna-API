--[[
    Utility Functions
    Common utilities used across the UI library
]]

local Utils = {}

-- Make a frame draggable
function Utils.MakeDraggable(frame, dragArea)
    dragArea = dragArea or frame
    
    local dragging
    local dragInput
    local dragStart
    local startPos
    
    local function update(input)
        local delta = input.Position - dragStart
        frame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
    end
    
    dragArea.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
            dragStart = input.Position
            startPos = frame.Position
            
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    dragging = false
                end
            end)
        end
    end)
    
    dragArea.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement then
            dragInput = input
        end
    end)
    
    game:GetService("UserInputService").InputChanged:Connect(function(input)
        if input == dragInput and dragging then
            update(input)
        end
    end)
end

-- Create ripple effect
function Utils.CreateRipple(parent)
    local ripple = Instance.new("Frame")
    ripple.Name = "Ripple"
    ripple.AnchorPoint = Vector2.new(0.5, 0.5)
    ripple.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    ripple.BackgroundTransparency = 0.7
    ripple.Position = UDim2.new(0.5, 0, 0.5, 0)
    ripple.Size = UDim2.new(0, 0, 0, 0)
    
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(1, 0)
    corner.Parent = ripple
    
    ripple.Parent = parent
    
    -- Animate ripple
    local size = math.max(parent.AbsoluteSize.X, parent.AbsoluteSize.Y) * 1.5
    local animation = game:GetService("TweenService"):Create(
        ripple,
        TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
        {
            Size = UDim2.new(0, size, 0, size),
            BackgroundTransparency = 1
        }
    )
    
    animation:Play()
    animation.Completed:Connect(function()
        ripple:Destroy()
    end)
    
    return ripple
end

-- Format number with commas
function Utils.FormatNumber(number)
    local formatted = tostring(number)
    local k
    
    while true do
        formatted, k = string.gsub(formatted, "^(-?%d+)(%d%d%d)", '%1,%2')
        if k == 0 then break end
    end
    
    return formatted
end

-- Deep copy a table
function Utils.DeepCopy(original)
    local copy = {}
    for k, v in pairs(original) do
        if type(v) == "table" then
            v = Utils.DeepCopy(v)
        end
        copy[k] = v
    end
    return copy
end

-- Check if a point is inside a frame
function Utils.IsPointInFrame(frame, pointX, pointY)
    local framePos = frame.AbsolutePosition
    local frameSize = frame.AbsoluteSize
    
    if pointX >= framePos.X and pointX <= framePos.X + frameSize.X and
       pointY >= framePos.Y and pointY <= framePos.Y + frameSize.Y then
        return true
    end
    
    return false
end

-- Create a shadow effect for a frame
function Utils.AddShadow(frame, shadowDistance, transparency)
    shadowDistance = shadowDistance or 4
    transparency = transparency or 0.5
    
    local shadow = Instance.new("ImageLabel")
    shadow.Name = "Shadow"
    shadow.Size = UDim2.new(1, shadowDistance * 2, 1, shadowDistance * 2)
    shadow.Position = UDim2.new(0.5, 0, 0.5, 0)
    shadow.AnchorPoint = Vector2.new(0.5, 0.5)
    shadow.BackgroundTransparency = 1
    shadow.Image = "rbxassetid://5553946656"
    shadow.ImageColor3 = Color3.fromRGB(0, 0, 0)
    shadow.ImageTransparency = transparency
    shadow.ZIndex = frame.ZIndex - 1
    shadow.Parent = frame
    
    return shadow
end

return Utils
