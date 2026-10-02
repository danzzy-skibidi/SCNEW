-- DANZZY MENU v1
-- LocalScript
-- Truck | Ledakan | Clear | WalkSpeed | Infinite Jump | Volume | Hide

local Players = game:GetService("Players")
local UIS = game:GetService("UserInputService")
local Debris = game:GetService("Debris")
local TweenService = game:GetService("TweenService")

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

local truckOn = false
local boomOn = false
local infiniteJump = false

local objects = Instance.new("Folder")
objects.Name = "DanzzyObjects"
objects.Parent = workspace

local gui = Instance.new("ScreenGui")
gui.Name = "DanzzyMenu"
gui.ResetOnSpawn = false
gui.Parent = playerGui

local main = Instance.new("Frame")
main.Size = UDim2.fromOffset(290, 490)
main.Position = UDim2.new(.5, -145, .5, -245)
main.BackgroundColor3 = Color3.fromRGB(20,20,30)
main.BorderSizePixel = 0
main.Active = true
main.Parent = gui

local mainCorner = Instance.new("UICorner")
mainCorner.CornerRadius = UDim.new(0,14)
mainCorner.Parent = main

-- DRAG
local dragging = false
local dragStart
local startPosition

main.InputBegan:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseButton1
	or input.UserInputType == Enum.UserInputType.Touch then
		dragging = true
		dragStart = input.Position
		startPosition = main.Position
	end
end)

main.InputEnded:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseButton1
	or input.UserInputType == Enum.UserInputType.Touch then
		dragging = false
	end
end)

UIS.InputChanged:Connect(function(input)
	if dragging and (
		input.UserInputType == Enum.UserInputType.MouseMovement
		or input.UserInputType == Enum.UserInputType.Touch
	) then
		local delta = input.Position - dragStart

		main.Position = UDim2.new(
			startPosition.X.Scale,
			startPosition.X.Offset + delta.X,
			startPosition.Y.Scale,
			startPosition.Y.Offset + delta.Y
		)
	end
end)

local title = Instance.new("TextLabel")
title.Size = UDim2.new(1,-20,0,45)
title.Position = UDim2.fromOffset(10,5)
title.BackgroundTransparency = 1
title.Text = "DANZZY MENU"
title.TextColor3 = Color3.new(1,1,1)
title.TextSize = 22
title.Font = Enum.Font.GothamBold
title.Parent = main

local function makeButton(text,y)
	local b = Instance.new("TextButton")
	b.Size = UDim2.new(1,-30,0,40)
	b.Position = UDim2.fromOffset(15,y)
	b.BackgroundColor3 = Color3.fromRGB(45,45,60)
	b.BorderSizePixel = 0
	b.Text = text
	b.TextColor3 = Color3.new(1,1,1)
	b.TextSize = 14
	b.Font = Enum.Font.GothamBold
	b.Parent = main

	local c = Instance.new("UICorner")
	c.CornerRadius = UDim.new(0,9)
	c.Parent = b

	return b
end

-- TRUCK
local truckButton = makeButton("🚛 TRUCK : OFF",55)

local function spawnTruck()
	local pos = Vector3.new(
		math.random(-50,50),
		50 + math.random(0,20),
		math.random(-50,50)
	)

	local model = Instance.new("Model")
	model.Name = "DanzzyTruck"
	model.Parent = objects

	local body = Instance.new("Part")
	body.Size = Vector3.new(8,3,14)
	body.Position = pos
	body.Material = Enum.Material.Metal
	body.Parent = model

	local cabin = Instance.new("Part")
	cabin.Size = Vector3.new(7,4,5)
	cabin.Position = pos + Vector3.new(0,3.5,-4)
	cabin.Material = Enum.Material.Metal
	cabin.Parent = model

	for _,offset in ipairs({
		Vector3.new(-4,-2,-4),
		Vector3.new(4,-2,-4),
		Vector3.new(-4,-2,4),
		Vector3.new(4,-2,4)
	}) do
		local wheel = Instance.new("Part")
		wheel.Shape = Enum.PartType.Cylinder
		wheel.Size = Vector3.new(2,2,2)
		wheel.Position = pos + offset
		wheel.Material = Enum.Material.Rubber
		wheel.Parent = model
	end

	for _,part in ipairs(model:GetChildren()) do
		if part:IsA("BasePart") then
			part.Anchored = false
			part.AssemblyLinearVelocity = Vector3.new(
				math.random(-20,20),
				-20,
				math.random(-20,20)
			)
	
