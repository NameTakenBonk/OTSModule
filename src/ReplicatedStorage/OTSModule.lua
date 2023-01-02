--[[
    Unfinished
]]

local UserInputService = game:GetService("UserInputService")
local ContextActionService = game:GetService("ContextActionService")
local RunService = game:GetService("RunService")

local OTS = { }
OTS.__index = OTS

function OTS.new(Player : Player, Camera : Camera, Character, Humanoid, CameraOffset : Vector3)
    local NewOTS = { }
    setmetatable(NewOTS, OTS)

    NewOTS.Player = Player
    NewOTS.Camera = Camera
    NewOTS.Character = Character
    NewOTS.Humanoid = Humanoid
    NewOTS.HumanoidRootPart = Character.HumanoidRootPart
    
    NewOTS.CameraOffset = CameraOffset or Vector3.new(2, 2, 8)
    NewOTS.CameraAngleX = 0
    NewOTS.CameraAngleY = 0

    NewOTS.CharacterAlligned = false
    NewOTS.Enabled = false

    NewOTS.RenderStepped = nil

    return NewOTS
end

function OTS:Enable()
    if self.Enabled then return warn("OTS is already enabled!") end
    self.Enabled = true

    self.Camera.CameraType = Enum.CameraType.Scriptable

    UserInputService.MouseBehavior = Enum.MouseBehavior.LockCenter
    UserInputService.MouseIconEnabled = false

    local function PlayerInput(ActionName, InputState, InputObject)
        if InputState == Enum.UserInputState.Change then
            self.CameraAngleX -= InputObject.Delta.X
            self.CameraAngleY -= math.clamp(self.CameraAngleY - InputObject.Delta.Y * 0.4, -90, 90)
        end
    end

    ContextActionService:BindAction("PlayerInput", PlayerInput, false, Enum.UserInputType.MouseMovement, Enum.UserInputType.Touch)

    self.RenderStepped = RunService.RenderStepped:Connect(function()
        local StartCFrame = CFrame.new(self.HumanoidRootPart.CFrame.Position) * CFrame.Angles(0, math.rad(self.CameraAngleX), 0) * CFrame.Angles(0, math.rad(self.CameraAngleY), 0)
        local CameraCFrame = StartCFrame:PointToWorldSpace(self.CameraOffset)
        local CameraFocus = StartCFrame:PointToWorldSpace(Vector3.new(self.CameraOffset.X, self.CameraOffset.Y, -100000))

		self.Camera.CFrame = CFrame.lookAt(CameraCFrame, CameraFocus)
		
		local LookCFrame = CFrame.lookAt(self.HumanoidRootPart.Position, self.Camera.CFrame:PointToWorldSpace(Vector3.new(0, 0, -100000)))
        self.HumanoidRootPart.CFrame = CFrame.fromMatrix(self.HumanoidRootPart.Position, LookCFrame.XVector, self.HumanoidRootPart.CFrame.YVector)
    end)
end

function OTS:Disable()
    if not self.Enabled then return warn("OTS is already disabled!") end

    self.Camera.CameraType = Enum.CameraType.Custom

    UserInputService.MouseBehavior = Enum.MouseBehavior.Default
    UserInputService.MouseIconEnabled = true

    self.RenderStepped:Disconnect()
end

return OTS
