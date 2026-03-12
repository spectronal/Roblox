local specAG = {}

local runService = game:GetService("RunService")
local replicatedStorage = game:GetService("ReplicatedStorage")
local players = game:GetService("Players")
local player = players.LocalPlayer

local dataRemoteEvent = replicatedStorage:WaitForChild("ffrostflame_bridgenet2@1.0.0"):WaitForChild("dataRemoteEvent")

-- Rewards
local Framework = require(replicatedStorage.Framework.Library)

local PlayerData = Framework.PlayerData
local TimeRewardData = Framework:GetData("TimeRewardData")

local weeklyFolder = replicatedStorage.Server.WeeklyRewards
local weeklyTime = weeklyFolder:GetAttribute("TimeLeft")

-- functions

function specAG.autoClicker(enabled: boolean)
    while enabled do task.wait()
        Framework.Remote:Fire("ClickSystem","Execute",Framework.Target)
end

function specAG.autoRewards(enabled: boolean)
    while enabled do task.wait(1)

        for typeName,config in pairs(TimeRewardData) do
            local data = PlayerData.TimeRewards[typeName]

            if data then
                local time = data.Time

                for index,reward in pairs(config.Rewards) do
                    if not data.Claimed[index] and reward.Time < time then
                        Framework.Remote:Fire(
                            "TimeRewardSystem",
                            "Claim",
                            typeName,
                            index
                        )
                    end
                end

                if time >= config.ResetTime then
                    Framework.Remote:Fire(
                        "TimeRewardSystem",
                        "Reset",
                        typeName
                    )
                end
            end
        end
    end
end


-- Achievements
-- local Tiers = player.PlayerGui.CenterGUI.Achievements.Main.Content.Tiers
--[[local function autoAchievements()
    for _, claim in pairs(Tiers:GetDescendants()) do
        if claim:IsA("TextLabel") and claim.Parent:IsA("ImageButton") and claim.Parent.Parent.Name ~= "Template" then
            if claim.Text == "Claim" then
                local achievementName = claim.Parent.Parent.Name --:gsub("%s","")
                
                local args = {{{"AchievementSystem","Claim",achievementName,n = 3}, "\002"}}
                dataRemoteEvent
                    :FireServer(unpack(args))            
            end
        end
    end
end]]

return specAG
