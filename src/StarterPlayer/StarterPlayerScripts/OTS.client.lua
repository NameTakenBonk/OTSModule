--disable
--[[
    With the tutorial from B ricey  
    https://www.youtube.com/watch?v=UsahcBf18jE
]]

local Players = game:GetService("Players")
local ContextActionService = game:GetService("ContextActionService")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")

local Camera = workspace.CurrentCamera
local Player = Players.LocalPlayer

local CameraOffset = Vector3.new (2, 2, 8)

Player.CharacterAdded:Connect(function(Character)
    local Humanoid = Character:WaitForChild("Humanoid")
    local HumanoidRootPart = Character:WaitForChild("HumanoidRootPart")

    local CameraAngleX = 0
    local CameraAngleY = 0

    Humanoid.AutoRotate = false

    local function PlayerInput(ActionName, InputState, InputObject)
        if InputState == Enum.UserInputState.Change then
            CameraAngleX  -= InputObject.Delta.X
            CameraAngleY  -= math.clamp(CameraAngleY - InputObject.Delta.Y * 0.4, -90, 90) -- Prevents 360 degrees movenet for the Y axis
        end
    end

    ContextActionService:BindAction("PlayerInput", PlayerInput, false, Enum.UserInputType.MouseMovement, Enum.UserInputType.Touch)

    RunService:BindToRenderStep("CameraUpdate", Enum.RenderPriority.Camera.Value, function()
        local StartCFrame = CFrame.new(HumanoidRootPart.CFrame.Position) * CFrame.Angles(0, math.rad(CameraAngleX), 0) * CFrame.Angles(0, math.rad(CameraAngleY), 0)
        local CameraCFrame = StartCFrame:PointToWorldSpace(CameraOffset)
        local CameraFocus = StartCFrame:PointToWorldSpace(Vector3.new(CameraOffset.X, CameraOffset.Y, -100000))

		Camera.CFrame = CFrame.lookAt(CameraCFrame, CameraFocus)
		
		local LookCFrame = CFrame.lookAt(HumanoidRootPart.Position, Camera.CFrame:PointToWorldSpace(Vector3.new(0, 0, -100000)))
        HumanoidRootPart.CFrame = CFrame.fromMatrix(HumanoidRootPart.Position, LookCFrame.XVector, HumanoidRootPart.CFrame.YVector)
    end)
end)

local function MouseLock(ActionName, InputState, InputObject)
    if InputState == Enum.UserInputState.Begin then
        Camera.CameraType = Enum.CameraType.Scriptable

        UserInputService.MouseBehavior = Enum.MouseBehavior.LockCenter
        UserInputService.MouseIconEnabled = false -- Optional

        ContextActionService:UnbindAction("FocusControl")
    end
end

ContextActionService:BindAction("MouseLock", MouseLock, false, Enum.UserInputType.MouseButton1, Enum.UserInputType.Touch, Enum.UserInputType.Focus)