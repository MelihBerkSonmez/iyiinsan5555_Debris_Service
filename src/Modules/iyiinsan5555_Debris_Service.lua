----What Should I do?
--[[

    Get all Instances with function
    After getting them apply function for each class (only available classes)


    Debris_Types:
    -Fade_In 👍
    -Get_Smaller 👍
    -Get_Away_Randomly 👍
    -Delete_Directly 👍
    -Rotated👍
    -Patlamali👍
    -Parçalara_Ayirma 👍
    -Aşaği_inme👍
    

]]



--Services
local TweenService = game:GetService("TweenService")

--Definations
local Debris_Service = {}
Debris_Service.__index = Debris_Service
Debris_Service.Items = {}
Debris_Service.Items_Lifetimes = {}

local Item_Count = 0

--Settings
Debris_Service.Settings = {
    Fade_In = {
        TweenInfo = TweenInfo.new(1, Enum.EasingStyle.Linear, Enum.EasingDirection.In, 0, false, 0) -- The tween info that will edit fade in debris type (Fade_In)
    },

    Get_Smaller = {
        TweenInfo = TweenInfo.new(1.5, Enum.EasingStyle.Linear, Enum.EasingDirection.In, 0, false, 0) -- The tween info that will edit tween in debris type (Get_Smaller)
    },

    Get_Away_Randomly = {
        TweenInfo = TweenInfo.new(1, Enum.EasingStyle.Quad, Enum.EasingDirection.Out, 0, false, 0) -- The tween info that will edit tween in debris type (Get_Away_Randomly)
    },

    Patlamali = {
        Smaller_Tween_TweenInfo = TweenInfo.new(1.5, Enum.EasingStyle.Back, Enum.EasingDirection.In, 0, false, 0),
        Patlamali_Tween_TweenInfo = TweenInfo.new(1, Enum.EasingStyle.Quart, Enum.EasingDirection.InOut, 0, false, 0)
    },

    Parcalara_Ayirma = {
        Min_Size_Item_X = 0.5,
        Min_Size_Item_Y = 0.5,
        Min_Size_Item_Z = 0.5,
    },

    Rotated = {
        TweenInfo = TweenInfo.new(1, Enum.EasingStyle.Back, Enum.EasingDirection.InOut, 0, false, 0),
        Defualt_Y_Axis_Drop = 10
    },

    Defualt_Lifetime = 10, -- The default number of seconds before an item is removed
    Min_Lifetime = 0.05, -- The minimum number of seconds before an item is removed
    Max_Items = 10000, -- The maximum number of items that can be added to the module
    Fast_Mode  = false, -- I highly don't suggest opening this. It could cause bugs. And weird movements but it's still a choice. It works faster for models if you open it.
    
    
}

--Debris Types
Debris_Service.Debris_Types = {
    Fade_In = "Fade_In",
    Get_Smaller = "Get_Smaller", --Change name later
    Get_Away_Randomly = "Get_Away_Randomly",
    Delete_Directly = "Delete_Directly",
    Rotated = "Rotated",
    Patlamali = "Patlamali", --Change name later (Patlama[Beyaz neonlu])
    Parcalara_Ayirma = "Parcalara_Ayirma"
}

--Functions
local function Create_Sorted_Table(Model :Model)  --Call this function always model or folder or whetver doesn't matter. Just call it every single time.

    local Table = {
        BaseParts = {},
    }

    for _, Thing in pairs(Model:GetDescendants()) do
        if Thing:IsA("BasePart") then
           table.insert(Table.BaseParts, Thing)
        end
    end

    table.sort(Table.BaseParts, function(a, b)
        return a.Position.Y > b.Position.Y
    end)

    return Table

end

local function Find_The_Top_Ancestor_Model(BasePart: BasePart)
    local Last_Ancestor = BasePart:FindFirstAncestorWhichIsA("Model")

    while Last_Ancestor and Last_Ancestor.Parent ~= workspace do
        Last_Ancestor = Last_Ancestor:FindFirstAncestorWhichIsA("Model")
    end

    return Last_Ancestor
end

Find_The_Top_Ancestor_Model(workspace.ClassicHouse.House["Smooth Block Model"])


function Debris_Service:Add_Item(Item :Instance, Lifetime :number, Debris_Type :string)

    assert(typeof(Item) == "Instance", "Invalid argument #1 (Instance expected)")
    assert(Lifetime == nil or typeof(Lifetime) == "number", "Invalid argument #2 (number or nil expected)")

    if Debris_Service.Items[Item] then
        warn("This item is already in debris ("..Item.Name..")")
        return
    end

    if Item_Count >= Debris_Service.Settings.Max_Items then
        warn("iyiinsan5555's_Debris_Service: Item limit reached, cannot add more items")
        return
    end

    Lifetime = Lifetime or Debris_Service.Settings.Min_Lifetime
    Lifetime = math.max(Lifetime, Debris_Service.Settings.Min_Lifetime)

    Debris_Service.Items[Item] = Lifetime
    Debris_Service.Items_Lifetimes[Item] = time()
    Item_Count = Item_Count + 1

    task.spawn(function()
        --Checking if it's a model
        if Item:IsA("Model") then -- I don't suggest to use models that has big amount of parts. That can break game. // Fixed

            local Table = Create_Sorted_Table(Item)

            for _, BasePart in pairs(Table.BaseParts) do
                if not Debris_Service.Settings.Fast_Mode  then
                    task.wait()
                end
                task.delay(Lifetime,function()
                    self:Remove_Item(BasePart, Debris_Type)
                end)
            end

            return
            
        end
    end)

    if Item:IsA("Model") then
        return
    end

    task.delay(Lifetime, function()
        self:Remove_Item(Item , Debris_Type)
    end)
                
    

end

function Debris_Service:Remove_Item(Item :Instance, Debris_Type :string )

    assert(typeof(Item) == "Instance", "Invalid argument #1 (Instance expected)")

    Debris_Service.Items[Item] = nil
    Debris_Service.Items_Lifetimes[Item] = nil
    Item_Count = Item_Count - 1

    Debris_Service[Debris_Type](Debris_Service,Item)

end

function Debris_Service:Get_Item_Count()

    print("Item count: "..Item_Count)

    return Item_Count
end

function Debris_Service:Get_Item_Lifetime(Item :Instance)

    assert(typeof(Item) == "Instance", "Invalid argument #1 (Instance expected)")

    local Item_Lifetime = Debris_Service.Items[Item]

    if not Debris_Service.Items_Lifetimes[Item] then
        warn("Can not find item's ("..Item..") lifetime. Probably item got deleted")
        return
    end

    local Item_Current_Lifetime = time() - Debris_Service.Items_Lifetimes[Item] -- The time that passed
    local Remaining_Time = Item_Lifetime - Item_Current_Lifetime
    
    local Time_Table = {
        Item_Lifetime = Item_Lifetime,
        Item_Current_Lifetime = Item_Current_Lifetime,
        Remaining_Time = Remaining_Time
    }

    print("Item's lifetime: "..Item_Lifetime.."s. The time that passed: "..Item_Current_Lifetime.."s. The remaining time: "..Remaining_Time.."s.")

    return Time_Table
end


function Debris_Service:Fade_In(Item :Instance)

    local CurrentTweenInfo = Debris_Service.Settings.Fade_In.TweenInfo

    if Item:IsA("BasePart") then

        Item.CanCollide = false
        Item.CanQuery = false
        Item.CanTouch = false

        local FadeInTween = TweenService:Create(Item, CurrentTweenInfo, {Transparency = 1})

        FadeInTween:Play()

    end

    task.delay(CurrentTweenInfo.Time + 0.1,function()
        Item:Destroy()
    end)

end


function Debris_Service:Get_Smaller(Item :Instance)

    if not Item:IsA("BasePart") then 
        warn("Get_Smaller debris type only works with BaseParts. It's "..Item.ClassName)
        Item:Destroy()
        return
    end

    local CurrentTweenInfo = Debris_Service.Settings.Get_Smaller.TweenInfo

    local Get_Smaller_Tween = TweenService:Create(Item, CurrentTweenInfo, {Size = Vector3.new(0.05, 0.05, 0.05)})

    Get_Smaller_Tween:Play()

    task.delay(CurrentTweenInfo.Time + 0.1,function()
        Item:Destroy()
    end)

end


function Debris_Service:Get_Away_Randomly(Item :Instance)

    if not Item:IsA("BasePart") then 
        warn("Get_Smaller debris type only works with BaseParts. It's "..Item.ClassName)
        Item:Destroy()
        return
    end

    local CurrentTweenInfo = Debris_Service.Settings.Get_Away_Randomly.TweenInfo

    local GoalPosition = Item.CFrame:PointToWorldSpace(Vector3.new(math.random(-10,10), math.random(225,250), math.random(-10,10))) --Don't really remember check it when you get connection

    local Get_Smaller_Tween = TweenService:Create(Item, CurrentTweenInfo, {Size = Vector3.new(0.05, 0.05, 0.05), Position = GoalPosition})

    Get_Smaller_Tween:Play()

    task.delay(CurrentTweenInfo.Time + 0.1,function()
        Item:Destroy()
    end)
    
end


function Debris_Service:Delete_Directly(Item :Instance)

    Item:Destroy()
    
end

function Debris_Service:Patlamali(Item :Instance)

    if not Item:IsA("BasePart") then
        warn("Patlamali debris type only works with BaseParts. It's "..Item.ClassName)
        Item:Destroy()
        return
    end

    for _, Thing in pairs(Item:GetDescendants()) do
       
        if Thing:IsA("Texture") or Thing:IsA("Decal") then
            Thing:Destroy()
        end
        
    end

    Item.Material = Enum.Material.Neon

    local Smaller_Size = Vector3.new(Item.Size.X / 3, Item.Size.Y / 3, Item.Size.Z / 3)
    local Patlamali_Size = Vector3.new(Item.Size.X * 3, Item.Size.Y * 3, Item.Size.Z * 3)

    local Smaller_Tween = TweenService:Create(Item, Debris_Service.Settings.Patlamali.Smaller_Tween_TweenInfo, {Size = Smaller_Size, Color = Color3.fromRGB(255, 255, 255)})
    Smaller_Tween:Play()

    Smaller_Tween.Completed:Wait()

    local Patlamali_Tween = TweenService:Create(Item, Debris_Service.Settings.Patlamali.Patlamali_Tween_TweenInfo, {Size = Patlamali_Size, Transparency = 1})
    Patlamali_Tween:Play()
    
    Patlamali_Tween.Completed:Once(function()
        Item:Destroy()
    end)

end


function Debris_Service:Parcalara_Ayirma(Item :Instance)

    local Size_of_Item = Item.Size
    local Settings_Parcalara_Ayirma = Debris_Service.Settings.Parcalara_Ayirma

    if not Item:IsA("BasePart") then
        warn("Parcalara_Ayirma debris type only works with BaseParts. It's "..Item.ClassName)
        Item:Destroy()
        return
    end

    if Size_of_Item.X < Settings_Parcalara_Ayirma.Min_Size_Item_X or Size_of_Item.Y < Settings_Parcalara_Ayirma.Min_Size_Item_Y or Size_of_Item.Z < Settings_Parcalara_Ayirma.Min_Size_Item_Z then
        warn("This item is not big enough to use this debris type")
        Item:Destroy()
        return
    end

    local Number_Pieces = math.random(2, 5)

    for i = 1, Number_Pieces do

        local New_Part = Item:Clone()
        New_Part.Parent = workspace

        New_Part.Name = Item.Name .. "_piece_" .. i
        New_Part.Anchored = false

        New_Part.Size = Vector3.new(
            math.random(Settings_Parcalara_Ayirma.Min_Size_Item_X, Size_of_Item.X) / math.round((Number_Pieces / 2)),
            math.random(Settings_Parcalara_Ayirma.Min_Size_Item_Y, Size_of_Item.Y) / math.round((Number_Pieces / 2)),
            math.random(Settings_Parcalara_Ayirma.Min_Size_Item_Z, Size_of_Item.Z) / math.round((Number_Pieces / 2))
        )
        New_Part.Position = Item.Position


        New_Part.Velocity = Vector3.new(math.random(-15, 15), math.random(10, 25), math.random(-15, 15))

        self:Add_Item(New_Part, Number_Pieces, Debris_Service.Debris_Types.Delete_Directly)

    end

    Item:Destroy()

end


function Debris_Service:Rotated(Item :Instance)

    if not Item:IsA("BasePart") then
        warn("Rotated debris type only works with BaseParts. It's "..Item.ClassName)
        Item:Destroy()
        return
    end

    task.spawn(function()

        for _ = 1, 2 do
            for _ = 1, 360 do
                Item.CFrame = Item.CFrame * CFrame.Angles(0, math.rad(5), 0)
                task.wait()
            end
        end

    end)

    task.wait(1.5)

    local Raycast_Params = RaycastParams.new()
    Raycast_Params.FilterType = Enum.RaycastFilterType.Exclude

    local Top_Ancestor_Model = Find_The_Top_Ancestor_Model(Item)

    if Top_Ancestor_Model then
        Raycast_Params.FilterDescendantsInstances = {Top_Ancestor_Model}
    end

    local Raycast = workspace:Raycast(Item.Position, Vector3.new(0, -100, 0), Raycast_Params)
    local Tween_Goal_Position

    if Raycast then
        Tween_Goal_Position = Item.Position - (Vector3.new(0, Raycast.Position.Y + Raycast.Instance.Size.Y, 0))
    else
        Tween_Goal_Position = Item.Position - Vector3.new(0, Debris_Service.Settings.Rotated.Defualt_Y_Axis_Drop, 0)
    end

    local Current_Tween_Info = Debris_Service.Settings.Rotated.TweenInfo
    local Tween = TweenService:Create(Item, Current_Tween_Info, {Position = Tween_Goal_Position} )

    Tween:Play()

    Tween.Completed:Wait()
    
    Item:Destroy()
end




return Debris_Service