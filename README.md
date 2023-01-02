# OTSModule

# To Do

* Camera Collision
* Mouse Icon
* Changing Sides
* More Optionality

# Constructor 
```lua
local NewOTS = OTS.new(Player : Player, Camera : Camera, Character, Humanoid, CameraOffset : Vector3, MouseIcon)
```
You need this added to your local script before enabling it. the last to options are completetly optional.

# Functions
```lua
OTS:Enable(AllignCharacter : boolean)
```
Enables the ots system and `AllignCharacter` can be also asigned by `NewOTS.CharacterAlligned = true`.

```lua
OTS:Disable()
```
Disables the ots system.

# Example code

```lua
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ContextActionService = game:GetService("ContextActionService")

local OTS = require(ReplicatedStorage.OTSModule)

local Player = game:GetService("Players").LocalPlayer
local Character = Player.Character or Player.CharacterAdded:Wait()
local Humanoid = Character:WaitForChild("Humanoid")
local Camera = workspace.CurrentCamera

local PlayerOTS = OTS.new(Player, Camera, Character, Humanoid, Vector3.new(2, 2, 8))

ContextActionService:BindAction("OTSEnable", function()
    if PlayerOTS.Enabled then
        PlayerOTS:Disable()
    else
        PlayerOTS:Enable()
    end
end, false, Enum.KeyCode.LeftShift)
```
