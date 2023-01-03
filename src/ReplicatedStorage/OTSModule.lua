--[[
	To Do:

    Mouse Icon
    Settings
    Events
]]

local UserInputService = game:GetService("UserInputService")
local ContextActionService = game:GetService("ContextActionService")
local RunService = game:GetService("RunService")

local OTS = { }
OTS.__index = OTS

-- // Constructor 
function OTS.new(Player : Player, Camera : Camera, Character, CameraOffset : Vector3, MouseIcon)
    local NewOTS = { }
    local self = setmetatable(NewOTS, OTS)

    local UpdatedEvent = Instance.new("BindableEvent")
    local EnabledEvent = Instance.new("BindableEvent")
    local DisabledEvent = Instance.new("BindableEvent")

    self.OnUpdated = UpdatedEvent.Event
    self.OnEnabled = EnabledEvent.Event
    self.OnDisabled = DisabledEvent.Event

    self.Player = Player
    self.Camera = Camera
    self.Character = Character
    self.Humanoid = NewOTS.Character:WaitForChild("Humanoid")
    self.HumanoidRootPart = Character.HumanoidRootPart

    self.CameraOffset = CameraOffset or Vector3.new(2, 2, 8)
    self.CameraAngleX = 0
    self.CameraAngleY = 0

    self.CharacterAlligned = false
    self.Enabled = false

    self.RenderStepped = nil

    return NewOTS
end

-- // Enable Function
function OTS:Enable(AllignCharacter : boolean)
    self.OnEnabled:Fire()
    -- // Checking if ots is already enabled
    if self.Enabled then return warn("OTS is already enabled!") end
    self.Enabled = true -- // Changing it to enabled

    -- // Seeing if the request wants the character alligned
    if AllignCharacter == true then self.CharacterAlligned = true end

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
        local NewCameraCFrame = CFrame.lookAt(CameraCFrame, CameraFocus)

        local NewRaycastParams = RaycastParams.new()
        NewRaycastParams.FilterDescendantsInstances = self.Character:GetChildren()
        NewRaycastParams.FilterType = Enum.RaycastFilterType.Blacklist

        local RaycastResult = workspace:Raycast(
            self.HumanoidRootPart.Position,
            NewCameraCFrame.Position - self.HumanoidRootPart.Position,
            NewRaycastParams
        )

        if RaycastResult ~= nil then
            local CollsionDisplacment = (RaycastResult.Position - self.HumanoidRootPart.Position)
            local CollsionPosition = self.HumanoidRootPart.Position + (CollsionDisplacment.Unit * (CollsionDisplacment.Magnitude - 0.3))
            local X, Y, Z, R00, R01, R02, R10, R11, R12, R20, R21, R22 = NewCameraCFrame:GetComponents()
            NewCameraCFrame = CFrame.new(CollsionPosition.x, CollsionPosition.y, CollsionPosition.z, R00, R01, R02, R10, R11, R12, R20, R21, R22)
        end

		self.Camera.CFrame = NewCameraCFrame
		
        -- // Only if the character alligned is set to tru
        if self.CharacterAlligned then
            local LookCFrame = CFrame.lookAt(self.HumanoidRootPart.Position, self.Camera.CFrame:PointToWorldSpace(Vector3.new(0, 0, -100000))) -- // the general direction where the camera is looking at
            self.HumanoidRootPart.CFrame = CFrame.fromMatrix(self.HumanoidRootPart.Position, LookCFrame.XVector, self.HumanoidRootPart.CFrame.YVector) -- // Setting the humanoid rotation to the camera
        end

        self.OnUpdated:Fire()
    end)
end

function OTS:Disable(ResetAllignment : boolean)
    -- // Checking if ots is already disabled
    if not self.Enabled then return warn("OTS is already disabled!") end
    self.Enabled = false -- // Setting the ots to disabled
    if ResetAllignment then
        self.CharacterAlligned = false -- // Sets it back to false Might remove it
    end

    -- // Changing the camera back to defualt
    self.Camera.CameraType = Enum.CameraType.Custom

    UserInputService.MouseBehavior = Enum.MouseBehavior.Default
    UserInputService.MouseIconEnabled = true

    -- // Disconnecting the Allignment and positioning
    self.RenderStepped:Disconnect()
    self.OnDisabled:Fire()
end

function OTS:SwitchSide()
    if self.CameraOffset.X > 0 then
        self.CameraOffset.X = math.abs(self.CameraOffset.X) * -1
    else
        self.CameraOffset.X = math.abs(self.CameraOffset.X) * 1
    end
end

return OTS
