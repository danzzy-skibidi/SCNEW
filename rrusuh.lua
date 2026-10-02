local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")
local Debris = game:GetService("Debris")
local UIS = game:GetService("UserInputService")

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

local enabled = false
local infiniteJump = false

-- GUI
local gui = Instance.new("ScreenGui")
gui.Name = "DanzzyMenu"
gui.ResetOnSpawn = false
gui.Parent = playerGui

-- MAIN MENU
local main = Instance.new("Frame")
main.Size = UDim2.fromOffset(300, 360)
main.Position = UDim2.new(0.5, -150, 0.5, -180)
main.BackgroundColor3 = Color3.fromRGB(20,20,30)
main.BorderSizePixel = 0
main.Active = true
main.Parent = gui

local mainCorner = Instance.new("UICorner")
mainCorner.CornerRadius = UDim.new(0,14)
mainCorner.Parent = main

local title = Instance.new("TextLabel")
title.Size = UDim2.new(1,-20,0,45)
title.Position = UDim2.fromOffset(10,5)
title.BackgroundTransparency = 1
title.Text = "DANZZY GANTENG"
title.TextColor3 = Color3.new(1,1,1)
title.TextSize = 21
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
	c.CornerRadius = UDim.new(0,8)
	c.Parent = b

	return b
end

-- RUSUH
local chaosButton = makeButton("RUSUH : OFF",55)

-- WALKSPEED INPUT
local speedBox = Instance.new("TextBox")
speedBox.Size = UDim2.new(1,-30,0,40)
speedBox.Position = UDim2.fromOffset(15,105)
speedBox.BackgroundColor3 = Color3.fromRGB(45,45,60)
speedBox.BorderSizePixel = 0
speedBox.PlaceholderText = "Ketik WalkSpeed"
speedBox.Text = ""
speedBox.TextColor3 = Color3.new(1,1,1)
speedBox.PlaceholderColor3 = Color3.fromRGB(170,170,170)
speedBox.TextSize = 14
speedBox.Font = Enum.Font.Gotham
speedBox.ClearTextOnFocus = false
speedBox.Parent = main

local speedCorner = Instance.new("UICorner")
speedCorner.CornerRadius = UDim.new(0,8)
speedCorner.Parent = speedBox

local speedButton = makeButton("SET WALKSPEED",155)

speedButton.MouseButton1Click:Connect(function()
	local value = tonumber(speedBox.Text)

	if not value then
		return
	end

	local character = player.Character
	local humanoid = character and character:FindFirstChildOfClass("Humanoid")

	if humanoid then
		humanoid.WalkSpeed = math.clamp(value,0,100)
	end
end)

-- INFINITE JUMP
local jumpButton = makeButton("INFINITE JUMP : OFF",205)

jumpButton.MouseButton1Click:Connect(function()
	infiniteJump = not infiniteJump

	if infiniteJump then
		jumpButton.Text = "INFINITE JUMP : ON"
	else
		jumpButton.Text = "INFINITE JUMP : OFF"
	end
end)

UIS.JumpRequest:Connect(function()
	if not infiniteJump then
		return
	end

	local character = player.Character
	local humanoid = character and character:FindFirstChildOfClass("Humanoid")

	if humanoid then
		humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
	end
end)

-- HIDE
local hideButton = makeButton("HIDE MENU",255)

-- SMALL MENU
local small = Instance.new("TextButton")
small.Size = UDim2.fromOffset(110,45)
small.Position = UDim2.fromOffset(15,15)
small.BackgroundColor3 = Color3.fromRGB(20,20,30)
small.BorderSizePixel = 0
small.Text = "DANZZY"
small.TextColor3 = Color3.new(1,1,1)
small.TextSize = 15
small.Font = Enum.Font.GothamBold
small.Visible = false
small.Active = true
small.Parent = gui

local smallCorner = Instance.new("UICorner")
smallCorner.CornerRadius = UDim.new(0,10)
smallCorner.Parent = small

hideButton.MouseButton1Click:Connect(function()
	main.Visible = false
	small.Visible = true
end)

small.MouseButton1Click:Connect(function()
	main.Visible = true
	small.Visible = false
end)

-- POSISI PEMAIN
local function getPosition()
	local character = player.Character
	local root = character and character:FindFirstChild("HumanoidRootPart")

	if root then
		return root.Position
	end

	return Vector3.new(0,10,0)
end

-- RANDOM PART
local function spawnPart()
	local part = Instance.new("Part")

	part.Size = Vector3.new(
		math.random(2,5),
		math.random(2,5),
		math.random(2,5)
	)

	part.Position = getPosition() + Vector3.new(
		math.random(-20,20),
		10,
		math.random(-20,20)
	)

	part.Color = Color3.fromRGB(
		math.random(0,255),
		math.random(0,255),
		math.random(0,255)
	)

	part.Anchored = false
	part.CanCollide = true
	part.Parent = Workspace

	part.AssemblyLinearVelocity = Vector3.new(
		math.random(-50,50),
		math.random(20,50),
		math.random(-50,50)
	)

	Debris:AddItem(part,10)
end

-- TRUK
local function spawnTruck()
	local pos = getPosition() + Vector3.new(
		math.random(-25,25),
		8,
		math.random(-25,25)
	)

	local model = Instance.new("Model")
	model.Name = "DanzzyTruck"
	model.Parent = Workspace

	local body = Instance.new("Part")
	body.Size = Vector3.new(8,3,14)
	body.Position = pos
	body.Anchored = false
	body.Color = Color3.fromRGB(35,35,40)
	body.Parent = model

	local cabin = Instance.new("Part")
	cabin.Size = Vector3.new(7,4,5)
	cabin.Position = pos + Vector3.new(0,3.5,4)
	cabin.Anchored = false
	cabin.Color = Color3.fromRGB(70,70,80)
	cabin.Parent = model

	local function wheel(offset)
		local w = Instance.new("Part")
		w.Size = Vector3.new(2,2,1)
		w.Shape = Enum.PartType.Cylinder
		w.Position = pos + offset
		w.Orientation = Vector3.new(0,0,90)
		w.Anchored = false
		w.Color = Color3.fromRGB(5,5,5)
		w.Parent = model
	end

	wheel(Vector3.new(4,-1.5,4))
	wheel(Vector3.new(-4,-1.5,4))
	wheel(Vector3.new(4,-1.5,-4))
	wheel(Vector3.new(-4,-1.5,-4))

	for _,obj in ipairs(model:GetChildren()) do
		if obj:IsA("BasePart") then
			obj.AssemblyLinearVelocity = Vector3.new(
				math.random(-30,30),
				10,
				math.random(-30,30)
			)
		end
	end

	Debris:AddItem(model,15)
end

-- LEDAKAN
local function spawnExplosion()
	local explosion = Instance.new("Explosion")

	explosion.Position = getPosition() + Vector3.new(
		math.random(-20,20),
		0,
		math.random(-20,20)
	)

	explosion.BlastRadius = 10
	explosion.BlastPressure = 0
	explosion.DestroyJointRadiusPercent = 0
	explosion.Parent = Workspace

	Debris:AddItem(explosion,2)
end

-- RUSUH LOOP
task.spawn(function()
	while true do
		if enabled then
			spawnPart()
			spawnTruck()
			spawnExplosion()
		end

		task.wait(1)
	end
end)

chaosButton.MouseButton1Click:Connect(function()
	enabled = not enabled

	if enabled then
		chaosButton.Text = "RUSUH : ON"
	else
		chaosButton.Text = "RUSUH : OFF"
	end
end)

-- DRAG FUNCTION
local function makeDraggable(object)
	local dragging = false
	local dragStart
	local startPos

	object.InputBegan:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1
		or input.UserInputType == Enum.UserInputType.Touch then

			dragging = true
			dragStart = input.Position
			startPos = object.Position
		end
	end)

	object.InputEnded:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1
		or input.UserInputType == Enum.UserInputType.Touch then

			dragging = false
		end
	end)

	UIS.InputChanged:Connect(function(input)
		if not dragging then
			return
		end

		if input.UserInputType == Enum.UserInputType.MouseMovement
		or input.UserInputType == Enum.UserInputType.Touch then

			local delta = input.Position - dragStart

			object.Position = UDim2.new(
				startPos.X.Scale,
				startPos.X.Offset + delta.X,
				startPos.Y.Scale,
				startPos.Y.Offset + delta.Y
			)
		end
	end)
end

-- MAIN DAN MENU KECIL SAMA-SAMA BISA DIGESER
makeDraggable(main)
makeDraggable(small)
