local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer
local Mouse = LocalPlayer:GetMouse()
local Camera = workspace.CurrentCamera
getgenv().SilentAimEnabled = true

local originalCFrame
local safeZoneCFrame = CFrame.new(-119.64421099999998, -677.249939, 1139.98853)
local safeZoneDistance = 350

local function isTeammate(player)
    return player.Character and player.Character:FindFirstChild("HumanoidRootPart") and 
           player.Character.HumanoidRootPart:FindFirstChild("TeammateLabel")
end

local function isInSafeZone()
    if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
        local playerPosition = LocalPlayer.Character.HumanoidRootPart.Position
        local distance = (playerPosition - safeZoneCFrame.Position).Magnitude
        return distance < safeZoneDistance
    end
    return false
end

local function isTargetVisible(player)
    if not player or not player.Character or not player.Character:FindFirstChild("Head") then
        return false
    end
    local head = player.Character.Head
    local origin = Camera.CFrame.Position
    local direction = (head.Position - origin).Unit * 1000
    local ray = Ray.new(origin, direction)
    local hitPart, hitPosition = workspace:FindPartOnRayWithIgnoreList(ray, {
        LocalPlayer.Character
    }, false, true)
    return hitPart and hitPart:IsDescendantOf(player.Character)
end

local function getClosestPlayerToMouse()
    local target
    local closestDistance = math.huge
    for _, player in pairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and 
           player.Character and 
           player.Character:FindFirstChild("Head") and
           player.Character:FindFirstChildOfClass("Humanoid").Health > 0 and
           not isTeammate(player) then
            local head = player.Character.Head
            local distance = (head.Position - Camera.CFrame.Position).Magnitude
            if distance < closestDistance and isTargetVisible(player) then
                target = player
                closestDistance = distance
            end
        end
    end
    return target
end

Mouse.Button1Down:Connect(function()
    if getgenv().SilentAimEnabled and not isInSafeZone() then
        local target = getClosestPlayerToMouse()
        if target and target.Character and target.Character:FindFirstChild("Head") then
            local head = target.Character.Head
            originalCFrame = Camera.CFrame
            Camera.CFrame = CFrame.new(Camera.CFrame.Position, head.Position)
        end
    end
end)

Mouse.Button1Up:Connect(function()
    if getgenv().SilentAimEnabled and originalCFrame then
        Camera.CFrame = originalCFrame
    end
end)
