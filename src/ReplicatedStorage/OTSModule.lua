--[[
    Unfinished
]]

local UserInputService = game:GetService("UserInputService")
local ContextActionService = game:GetService("ContextActionService")
local RunService = game:GetService("RunService")

local OTS = { }
OTS.__index = OTS

function OTS.new(Player : Player, Camera : Camera, Character : "Player Character", CameraOffset : Vector3)
    local NewOTS = { }
    setmetatable(NewOTS, OTS)

    NewOTS.Player = Player
    NewOTS.Camera = Camera
    NewOTS.Character = Character
    NewOTS.Humanoid = Character.Humanoid
    NewOTS.HumanoidRootPart = Character.HumanoidRootPart
    
    NewOTS.CameraOffset = Vector3.new(2, 2, 8)
    NewOTS.CameraAngleX = 0
    NewOTS.CameraAngleY = 0

    NewOTS.CharacterAlligned = false
    NewOTS.Enabled = false

    NewOTS.RenderStepped = nil

    return NewOTS
end

function OTS:Enable()
    if self.Enabled then return warn("OTS is already enabled!") end

    local function PlayerInput()
        
    end

    self.RenderStepped = RunService.RenderStepped:Connect(function()
        
    end)
end

function OTS:Disable()
    self.RenderStepped:Disconnect()
end

return OTS
