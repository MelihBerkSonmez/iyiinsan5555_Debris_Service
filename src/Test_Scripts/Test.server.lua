--Services
local ReplicatedStorage = game:GetService("ReplicatedStorage")

--Definations
local Modules = ReplicatedStorage:WaitForChild("Modules")
local ClassicHouse = workspace:WaitForChild("ClassicHouse")

local Debris_Module = require(Modules:WaitForChild("iyiinsan5555_Debris_Service"))

Debris_Module.Settings.Fade_In.TweenInfo = TweenInfo.new(1, Enum.EasingStyle.Linear, Enum.EasingDirection.In, 0, false, 0)

Debris_Module:Add_Item(workspace.SpawnLocation,5,Debris_Module.Debris_Types.Rotated)


local Part = Instance.new("Part")
Part.Parent = workspace

task.wait(1)


for i, thing in pairs(workspace:GetChildren()) do
    if thing:IsA("Model") then
        Debris_Module:Add_Item(thing, 5 ,Debris_Module.Debris_Types.Rotated)
    end
end