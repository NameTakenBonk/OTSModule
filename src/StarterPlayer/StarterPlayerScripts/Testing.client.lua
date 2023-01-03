local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ContextActionService = game:GetService("ContextActionService")

local OTS = require(ReplicatedStorage.OTSModule)

local Player = game:GetService("Players").LocalPlayer
local Character = Player.Character or Player.CharacterAdded:Wait()
local Humanoid = Character:WaitForChild("Humanoid")
local Camera = workspace.CurrentCamera

local PlayerOTS = OTS.new(Player, Camera, Character, Vector3.new(2, 2, 8))

ContextActionService:BindAction("OTSEnable", function()
    if PlayerOTS.Enabled then
        PlayerOTS:Disable(true)
    else
        PlayerOTS:Enable(true)
    end
end, false, Enum.KeyCode.LeftShift)