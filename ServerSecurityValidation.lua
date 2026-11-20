-- Server-side authorization & anti-abuse validation reference (ServerScriptService)
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Remotes = ReplicatedStorage:FindFirstChild("SecurityRemotes") or Instance.new("Folder")
Remotes.Name = "SecurityRemotes"
Remotes.Parent = ReplicatedStorage

local EquipItemRemote = Remotes:FindFirstChild("EquipRankItem") or Instance.new("RemoteEvent")
EquipItemRemote.Name = "EquipRankItem"
EquipItemRemote.Parent = Remotes

local RANK_TABLE = {
	["Citizen"] = 0,
	["Cadet"] = 1,
	["Officer"] = 2,
	["Sergeant"] = 3,
	["Captain"] = 4,
	["Commander"] = 5,
}

local playerCooldowns = {}

local function getPlayerRank(player: Player): number
	local rankValue = player:GetAttribute("RankLevel")
	if type(rankValue) == "number" then return rankValue end
	local teamName = player.Team and player.Team.Name or "Citizen"
	return RANK_TABLE[teamName] or 0
end

EquipItemRemote.OnServerEvent:Connect(function(player: Player, actionName: any)
	if type(actionName) ~= "string" then return end
	local now = os.clock()
	if now - (playerCooldowns[player.UserId] or 0) < 0.5 then return end
	playerCooldowns[player.UserId] = now
	local currentRank = getPlayerRank(player)
	EquipItemRemote:FireClient(player, "AUTH_CHECK", actionName, currentRank)
end)

Players.PlayerRemoving:Connect(function(player: Player)
	playerCooldowns[player.UserId] = nil
end)
