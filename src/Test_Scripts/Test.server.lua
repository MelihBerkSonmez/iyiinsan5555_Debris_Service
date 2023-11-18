--Services
local ReplicatedStorage = game:GetService("ReplicatedStorage")

--Definations
local Modules = ReplicatedStorage:WaitForChild("Modules")
local ClassicHouse = workspace:WaitForChild("ClassicHouse")
local SpawnLocation = workspace:WaitForChild("SpawnLocation")

local Debris_Module = require(Modules:WaitForChild("iyiinsan5555_Debris_Service"))

Debris_Module:Add_Item(SpawnLocation, 10, Debris_Module.Debris_Types.Rotated)

task.wait(1)


for _, thing in pairs(workspace:GetChildren()) do
    if thing:IsA("Model") then
        Debris_Module:Add_Item(thing, 5 ,Debris_Module.Debris_Types.Rotated)
    end
end


print(Debris_Module:Get_Item_Count())

Debris_Module:Get_Item_Lifetime(ClassicHouse)

task.wait(1)

Debris_Module:Get_Item_Lifetime(ClassicHouse)