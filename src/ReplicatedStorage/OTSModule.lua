--[[
    Unfinished

    Mouse Icon
    Camera Collsion
]]

local UserInputService = game:GetService("UserInputService")
local ContextActionService = game:GetService("ContextActionService")
local RunService = game:GetService("RunService")

local OTS = { }
OTS.__index = OTS

-- // Constructor 
function OTS.new(Player : Player, Camera : Camera, Character, Humanoid, CameraOffset : Vector3, MouseIcon)
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

-- // Enable Function
function OTS:Enable()
    -- // Checking if ots is already enabled
    if self.Enabled then return warn("OTS is already enabled!") end
    self.Enabled = true -- // Changing it to enabled

    -- // Setting up the camera and mouse
    self.Camera.CameraType = Enum.CameraType.Scriptable

    UserInputService.MouseBehavior = Enum.MouseBehavior.LockCenter
    UserInputService.MouseIconEnabled = false

    -- // Changing the CameraAngleX and CameraAngleY when the mouse moves
    local function PlayerInput(ActionName, InputState, InputObject)
        if InputState == Enum.UserInputState.Change then
            self.CameraAngleX -= InputObject.Delta.X
            self.CameraAngleY -= math.clamp(InputObject.Delta.Y * 0.4, -70, 70) -- // Clamping the Y rotation(Currently needs fixing)
        end
    end

    -- // Binding the PlayerInput when the mouse moves
    ContextActionService:BindAction("PlayerInput", PlayerInput, false, Enum.UserInputType.MouseMovement, Enum.UserInputType.Touch)

    -- // Alligning the HumanoidRootPart and Setting the camera position
    self.RenderStepped = RunService.RenderStepped:Connect(function()
        local StartCFrame = CFrame.new(self.HumanoidRootPart.CFrame.Position) * CFrame.Angles(0, math.rad(self.CameraAngleX), 0) * CFrame.Angles(math.rad(self.CameraAngleY), 0, 0) -- // Making the starting CFrame
        local CameraCFrame = StartCFrame:PointToWorldSpace(self.CameraOffset) -- // Making the camera position
        local CameraFocus = StartCFrame:PointToWorldSpace(Vector3.new(self.CameraOffset.X, self.CameraOffset.Y, -100000)) -- // Making the camera dirction

		self.Camera.CFrame = CFrame.lookAt(CameraCFrame, CameraFocus)
		
		local LookCFrame = CFrame.lookAt(self.HumanoidRootPart.Position, self.Camera.CFrame:PointToWorldSpace(Vector3.new(0, 0, -100000))) -- // the general direction where the camera is looking at
        self.HumanoidRootPart.CFrame = CFrame.fromMatrix(self.HumanoidRootPart.Position, LookCFrame.XVector, self.HumanoidRootPart.CFrame.YVector) -- // Setting the humanoid rotation to the camera
    end)
end

function OTS:Disable()
    -- // Checking if ots is already disabled
    if not self.Enabled then return warn("OTS is already disabled!") end
    self.Enabled = false -- // Setting the ots to disabled

    -- // Changing the camera back to defualt
    self.Camera.CameraType = Enum.CameraType.Custom

    UserInputService.MouseBehavior = Enum.MouseBehavior.Default
    UserInputService.MouseIconEnabled = true

    -- // Disconnecting the Allignment and positioning
    self.RenderStepped:Disconnect()
end

return OTS
