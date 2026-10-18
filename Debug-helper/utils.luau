local utils = {}

local Players = game:GetService("Players")
local gameRunService = game:GetService("RunService")

utils.Players = {}
utils.PlayerService = Players
utils.Players.LocalPlayer = Players.LocalPlayer
utils.Players.SelfCharacter = Players.LocalPlayer.Character
utils.Players.SelfHumanoid = Players.LocalPlayer.Character and Players.LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
utils.Players.SelfHumanoidRoot = Players.LocalPlayer.Character and Players.LocalPlayer.Character:FindFirstChild("HumanoidRootPart")

function utils.Players:GetClosestPlayer(ignore_team, max_magnitude, ignore_dead, custom_character_list, self_character)
    if not max_magnitude then max_magnitude = math.huge end
    local part_base = "HumanoidRootPart"
    local self_comparison_part

    if not self_character then self_character = Players.LocalPlayer.Character end
    if not self_character then return end

    if self_character:FindFirstChild(part_base) then
         self_comparison_part = self_character:FindFirstChild(part_base)
    elseif self_character:FindFirstChild("Head") then
        self_comparison_part = self_character:FindFirstChild("Head")
        part_base = "Head"
    end

    if not self_comparison_part then return end

    if not custom_character_list then
        local t = setrawmetatable({}, {__mode = "kv"})

        for idx, player in Players:GetPlayers() do
            t[player] = player.Character
        end

        custom_character_list = t
    end

    if ignore_team == nil then ignore_team = true end

    local lowest_found_magnitude, player_found = max_magnitude, nil

    for _, player in Players:GetPlayers() do
        if player == Players.LocalPlayer then continue end
        if ignore_team and player.Team == Players.LocalPlayer.Team then continue end

        local p_char = custom_character_list and custom_character_list[player] or player.Character

        if not p_char or not p_char:FindFirstChild(part_base) then continue end
        if ignore_dead and p_char:FindFirstChildOfClass("Humanoid") and p_char:FindFirstChildOfClass("Humanoid").Health <= 0 then continue end
        local m = (self_comparison_part.Position - p_char:FindFirstChild(part_base).Position).Magnitude

        if m < lowest_found_magnitude then
            lowest_found_magnitude = m
            player_found = player
        end
    end

    return player_found
end

function utils.Players:GetBodyLimbs(player)
    if player.Character then
        local limbs = setrawmetatable({}, {__mode = "v"})

        for _, limb in player.Character:GetChildren() do
            limbs[limb.Name] = limb
        end

        return limbs
    end
end

utils.RunService = {}
utils.RunService.RunService = gameRunService
function utils.RunService:GetRunServiceConnections()
    local connections = {}

    local SignalNames = {
        "Heartbeat",
        "Stepped",
        "RenderStepped",
        "PreRender",
        "PreAnimation",
        "PreSimulation",
        "PostSimulation",
    }

    for _, name in SignalNames do
        connections[name] = getconnections(gameRunService[name])
    end

    return connections
end

gameRunService.Stepped:Connect(function()
    local char = Players.LocalPlayer.Character

    if char then
        utils.Players.SelfCharacter = char
        utils.Players.SelfHumanoid = char:FindFirstChildOfClass("Humanoid")
        utils.Players.SelfHumanoidRoot = char:FindFirstChild("HumanoidRootPart")
    else
        utils.Players.SelfCharacter = nil
    end
end)

getgenv().Utils = utils

return utils
