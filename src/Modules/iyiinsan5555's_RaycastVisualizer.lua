--Services
local Debris = game:GetService("Debris")
local TweenService = game:GetService("TweenService")

--Definations
local Assets = script:WaitForChild("Assets")
local RaycastInfoBillboardGui = Assets:WaitForChild("RaycastInfoBillboardGui")

--Functions


local RaycastVisualizer = {}
RaycastVisualizer.__index = RaycastVisualizer

RaycastVisualizer.Settings = {
	BeamWidth = 0.2,
	BeamColor = Color3.fromRGB(255,0,0),
	InstancesTransparency = 0.5,
	InstancesColor = Color3.fromRGB(100,100,100),
	InstancesFolderName = "iyiinsan5555's_RaycastVisualizer",
	VisualizationLifeTime = 10,
    HitPartEffectTransparency = 0.75,
	CreateBillboard = true,
	BillboardMaxDistance = 30,
}


function RaycastVisualizer:VisualizeRaycast(Origin :Vector3, Direction :Vector3)
	print("Visualization has started!")
	--Visualizing Raycast

	local InstancesFolder = Instance.new("Folder")
	InstancesFolder.Parent = workspace
	InstancesFolder.Name = RaycastVisualizer.Settings.InstancesFolderName

	local BeamStartPart = Instance.new("Part")
	BeamStartPart.Name = "BeamStartPart"
	BeamStartPart.Anchored = true
	BeamStartPart.Size = Vector3.new(1,1,1)
	BeamStartPart.CanCollide = false
	BeamStartPart.Transparency = RaycastVisualizer.Settings.InstancesTransparency

	local BeamEndPart = Instance.new("Part")
	BeamEndPart.Name = "BeamEndPart"
	BeamEndPart.Anchored = true
	BeamEndPart.Size = Vector3.new(1,1,1)
	BeamEndPart.CanCollide = false
	BeamEndPart.Transparency = RaycastVisualizer.Settings.InstancesTransparency

	BeamStartPart.Position = Origin
	BeamEndPart.Position = Origin + Direction

    BeamStartPart.Parent = InstancesFolder
    BeamEndPart.Parent = InstancesFolder

	local Beam = Instance.new("Beam") 
	Beam.Parent = BeamStartPart
	Beam.FaceCamera = true 
	Beam.Color = ColorSequence.new(RaycastVisualizer.Settings.BeamColor)

	local StartAttachment = Instance.new("Attachment")
	StartAttachment.Parent = BeamStartPart
	local EndAttachment = Instance.new("Attachment")
	EndAttachment.Parent = BeamEndPart

	Beam.Attachment0 = StartAttachment 
	Beam.Attachment1 = EndAttachment

	Beam.Width0 = RaycastVisualizer.Settings.BeamWidth
	Beam.Width1 = RaycastVisualizer.Settings.BeamWidth


	--Visualizing Hits

	-- I have to send rays to that position.
	-- If it hits something then add it to ignore list and add a part to there that has bigger shape and green transparent color
	-- and do it until it doesn't hit anything

	local DidntHitAnything = false
    local AlreadyHit = false
	local NumberOfObstacles = 0

	local HitRaycastParams = RaycastParams.new()
	HitRaycastParams.FilterType = Enum.RaycastFilterType.Exclude
	HitRaycastParams.FilterDescendantsInstances = {BeamStartPart,BeamEndPart}

	repeat

		local HitRaycast = workspace:Raycast(Origin, Direction, HitRaycastParams)

		if HitRaycast then

			local RaycastHitPartEffect = HitRaycast.Instance:Clone()
			RaycastHitPartEffect.Anchored = true
			RaycastHitPartEffect.CanCollide = false
			RaycastHitPartEffect.CanTouch = false
			RaycastHitPartEffect.CanQuery = false
      		RaycastHitPartEffect.Material = Enum.Material.SmoothPlastic
			RaycastHitPartEffect.Transparency = RaycastVisualizer.Settings.HitPartEffectTransparency
            RaycastHitPartEffect.Parent = InstancesFolder

			if RaycastHitPartEffect:FindFirstChildOfClass("Decal") or RaycastHitPartEffect:FindFirstChildOfClass("Texture") then
				for _, TextureOrDecal in pairs(RaycastHitPartEffect:GetChildren()) do
					TextureOrDecal:Destroy()
				end
			end

            if not AlreadyHit then
                RaycastHitPartEffect.Color = Color3.fromRGB(0,255,0)
            else
                RaycastHitPartEffect.Color = Color3.fromRGB(255,0,0)
            end

			local PartRaycastHit = HitRaycast.Instance

			local GoalSize = PartRaycastHit.Size * 1.2
			local StartSize = Vector3.new(GoalSize.X / 5, GoalSize.Y / 5, GoalSize.Z / 5)

			RaycastHitPartEffect.Size = StartSize
            RaycastHitPartEffect.CFrame = PartRaycastHit.CFrame

			local SizeTween = TweenService:Create(RaycastHitPartEffect,
				TweenInfo.new(0.5, Enum.EasingStyle.Bounce, Enum.EasingDirection.Out, 0,false, 0),
				{Size = GoalSize }
			)

			SizeTween:Play()

			HitRaycastParams:AddToFilter({PartRaycastHit,RaycastHitPartEffect})

			if AlreadyHit == true then
				NumberOfObstacles += 1
			end

            if AlreadyHit == false then
                AlreadyHit = true
			end

			--Billboard Things

			if RaycastVisualizer.Settings.CreateBillboard then

				local InfoBillboard = RaycastInfoBillboardGui:Clone()
				InfoBillboard.Parent = RaycastHitPartEffect
				InfoBillboard.StudsOffset = Vector3.new(0, RaycastHitPartEffect.Size.Y * 3, 0)
				InfoBillboard.MaxDistance = RaycastVisualizer.Settings.BillboardMaxDistance
				local HolderFrame = InfoBillboard.HolderFrame
				HolderFrame.BasePartNameTextLabel.Text = HitRaycast.Instance.Name
				HolderFrame.NumberOfObstaclesTextLabel.Text = tostring(NumberOfObstacles).." Obstacles"
				HolderFrame.RaycastPositionsTextLabel.Text = "Raycast  Start: "..tostring(Origin).." End: "..tostring(Origin + Direction)
				HolderFrame.RaycastTypeTextLabel.Text = "Raycast"
				
			end
			

		else  ---Raycast Doesn't Hit Anything

			DidntHitAnything = true

		end

		task.wait()

	until DidntHitAnything == true

	Debris:AddItem(InstancesFolder, RaycastVisualizer.Settings.VisualizationLifeTime)

	--Infos that i could add
	--[[
		1. Raycast Created with (script.Name)  --Cannot get this info
		2. Parts Name  --DONE
		3. Raycast Started at (start position) and (end position)  --DONE
		4. Raycast type (Raycast, Spherecast, Blockcast)  --DONE
		5. Number of obstacles in front of part (that raycast didn't hit)  --DONE
	]]

	--[[
		Billboard Infos
		1. StudsOffset = Size of parts y axis * 3 --DONE
		2. Max distance 30  --DONE
	]]

end


function RaycastVisualizer:VisualizeSpherecast(Origin :Vector3, Direction :Vector3, Radius :number)

	local CurrentDistance = 0

	local InstancesFolder = Instance.new("Folder")
	InstancesFolder.Parent = workspace
	InstancesFolder.Name = RaycastVisualizer.Settings.InstancesFolderName

	local SphereEffectPartsTable = {}

	repeat
		
		--Visualizing Spherecast

		local SphereEffectPart = Instance.new("Part")
		SphereEffectPart.Name = "SpherePart"
		SphereEffectPart.Anchored = true
		SphereEffectPart.Shape = Enum.PartType.Ball
		SphereEffectPart.Size = Vector3.new(Radius, Radius, Radius)
		SphereEffectPart.CanCollide = false
		SphereEffectPart.CanTouch = false
		SphereEffectPart.CanQuery = false
		SphereEffectPart.Position = Origin + Direction.Unit * CurrentDistance
		SphereEffectPart.Transparency = RaycastVisualizer.Settings.InstancesTransparency
		SphereEffectPart.Color = RaycastVisualizer.Settings.InstancesColor
		SphereEffectPart.Material = Enum.Material.SmoothPlastic
		SphereEffectPart.Parent = InstancesFolder

		CurrentDistance = CurrentDistance + Radius / 3

		table.insert(SphereEffectPartsTable,SphereEffectPart)

	until CurrentDistance > Direction.Magnitude

	local DidntHitAnything = false
    local AlreadyHit = false
	local NumberOfObstacles = 0

	local HitSpherecastParams = RaycastParams.new()
	HitSpherecastParams.FilterType = Enum.RaycastFilterType.Exclude
	HitSpherecastParams.FilterDescendantsInstances = SphereEffectPartsTable

	repeat

		local HitSpherecast = workspace:Spherecast(Origin, Radius, Direction, HitSpherecastParams)

		if HitSpherecast then

			local SpherecastHitPartEffect = HitSpherecast.Instance:Clone()
			SpherecastHitPartEffect.Anchored = true
			SpherecastHitPartEffect.CanCollide = false
			SpherecastHitPartEffect.CanTouch = false
			SpherecastHitPartEffect.CanQuery = false
      		SpherecastHitPartEffect.Material = Enum.Material.SmoothPlastic
			SpherecastHitPartEffect.Transparency = RaycastVisualizer.Settings.HitPartEffectTransparency
            SpherecastHitPartEffect.Parent = InstancesFolder

			if SpherecastHitPartEffect:FindFirstChildOfClass("Decal") or SpherecastHitPartEffect:FindFirstChildOfClass("Texture") then
				for _, TextureOrDecal in pairs(SpherecastHitPartEffect:GetChildren()) do
					TextureOrDecal:Destroy()
				end
			end

            if not AlreadyHit then
                SpherecastHitPartEffect.Color = Color3.fromRGB(0,255,0)
            else
                SpherecastHitPartEffect.Color = Color3.fromRGB(255,0,0)
            end

			local PartSpherecastHit = HitSpherecast.Instance

			local GoalSize = PartSpherecastHit.Size * 1.2
			local StartSize = Vector3.new(GoalSize.X / 5, GoalSize.Y / 5, GoalSize.Z / 5)

			SpherecastHitPartEffect.Size = StartSize
            SpherecastHitPartEffect.CFrame = PartSpherecastHit.CFrame

			local SizeTween = TweenService:Create(SpherecastHitPartEffect,
				TweenInfo.new(0.5, Enum.EasingStyle.Bounce, Enum.EasingDirection.Out, 0,false, 0),
				{Size = GoalSize }
			)

			SizeTween:Play()

			HitSpherecastParams:AddToFilter({PartSpherecastHit,SpherecastHitPartEffect})

			if AlreadyHit == true then
				NumberOfObstacles += 1
			end

            if AlreadyHit == false then
                AlreadyHit = true
			end

			--Billboard Things

			if RaycastVisualizer.Settings.CreateBillboard then

				local InfoBillboard = RaycastInfoBillboardGui:Clone()
				InfoBillboard.Parent = SpherecastHitPartEffect
				InfoBillboard.StudsOffset = Vector3.new(0, SpherecastHitPartEffect.Size.Y * 3, 0)
				InfoBillboard.MaxDistance = RaycastVisualizer.Settings.BillboardMaxDistance
				local HolderFrame = InfoBillboard.HolderFrame
				HolderFrame.BasePartNameTextLabel.Text = HitSpherecast.Instance.Name
				HolderFrame.NumberOfObstaclesTextLabel.Text = tostring(NumberOfObstacles).." Obstacles"
				HolderFrame.RaycastPositionsTextLabel.Text = "Raycast  Start: "..tostring(Origin).." End: "..tostring(Origin + Direction)
				HolderFrame.RaycastTypeTextLabel.Text = "Raycast"
				
			end
			

		else  ---Raycast Doesn't Hit Anything

			DidntHitAnything = true

		end

		task.wait()

	until DidntHitAnything == true

	Debris:AddItem(InstancesFolder, RaycastVisualizer.Settings.VisualizationLifeTime)

end








return RaycastVisualizer