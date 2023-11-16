--Services
local ReplicatedStorage = game:GetService("ReplicatedStorage")

--Definations
local Modules = ReplicatedStorage:WaitForChild("Modules")
local ClassicHouse = workspace:WaitForChild("ClassicHouse")

local Debris_Module = require(Modules:WaitForChild("iyiinsan5555_Debris_Service"))


local Part = Instance.new("Part")
Part.Parent = workspace

Debris_Module:Add_Item(ClassicHouse,3,Debris_Module.Debris_Types.Get_Smaller)
task.wait(1)
Debris_Module:Get_Item_Count()
Debris_Module:Get_Item_Lifetime(ClassicHouse)
task.wait(1)
Debris_Module:Get_Item_Lifetime(ClassicHouse)


for i, thing in pairs(workspace:GetChildren()) do
    if thing:IsA("Model") then
        Debris_Module:Add_Item(thing,5 + i *2,Debris_Module.Debris_Types.Get_Smaller)
    end
end