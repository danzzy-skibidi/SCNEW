local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")
local Debris = game:GetService("Debris")
local UserInputService = game:GetService("UserInputService")

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

local chaos = false
local infiniteJump = false
local dragging = false
local dragStart
local startPosition

local gui = Instance.new("ScreenGui")
gui.Name = "DanzzyGanteng"
gui.ResetOnSpawn = false
gui.Parent = playerGui

local main = Instance.new("Frame")
main.Size = UDim2.fromOffset(280, 300)
main.Position = UDim2.new(0.5, -140, 0.5, -150)
main.BackgroundColor3 = Color3.fromRGB(20, 20, 30)
main.BorderSizePixel = 0
main.Active = true
main.Parent = gui

local corner = Instance.new("UICorner")
corner.CornerRadius = UDim.new(0, 14)
corner.Parent = main

local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, -20, 0, 45)
title.Position = UDim2.fromOffset(10, 5)
title.BackgroundTransparency = 1
title.Text = "Danzzy ganteng"
title.TextColor3 = Color3.new(1, 1, 1)
title.TextSize = 22
title.Font = Enum.Font.GothamBold
title.Parent = main

local function createButton(text, y)
	local b = Instance.new("TextButton")
	b.Size = UDim2.new(1, -30, 0, 40)
	b.Position = UDim2.fromOffset(15, y)
	b.BackgroundColor3 = Color3.fromRGB(45, 45, 60)
	b.BorderSizePixel = 0
	b.Text = text
	b.TextColor3 = Color3.new(1, 1, 1)
	b.TextSize = 14
	b.Font = Enum.Font.GothamBold
	b.Parent = main

	local c = Instance.new("UICorner")
	c.CornerRadius = UDim.new(0, 8)
	c.Parent = b

	return b
end

local chaosButton = createButton("CHAOS : OFF", 55)

local speedBox = Instance.new("TextBox")
speedBox.Size = UDim2.new(1, -30, 0, 40)
speedBox.Position = UDim2.fromOffset(15, 105)
speedBox.BackgroundColor3 = Color3.fromRGB(45, 45, 60)
speedBox.BorderSizePixel = 0
speedBox.PlaceholderText = "Ketik WalkSpeed"
speedBox.Text = ""
speedBox.TextColor3 = Color3.new(1, 1, 1)
speedBox.PlaceholderColor3 = Color3.fromRGB(170, 170, 170)
speedBox.TextSize = 14
speedBox.Font = Enum.Font.Gotham
speedBox.ClearTextOnFocus = false
speedBox.Parent = main

local speedCorner = Instance.new("UICorner")
speedCorner.CornerRadius = UDim.new(0, 8)
speedCorner.Parent = speedBox

local speedButton = createButton("SET WALKSPEED", 155)

speedButton.MouseButton1Click:Connect(function()
	local value = tonumber(speedBox.Text)

	if not value then
		return
	end

	local character = player.Character
	local humanoid = character and character:FindFirstChildOfClass("Humanoid")

	if humanoid then
		humanoid.WalkSpeed = math.clamp(value, 0, 100)
	end
end)

local jumpButton = createButton("INFINITE JUMP : OFF", 205)

jumpButton.MouseButton1Click:Connect(function()
	infiniteJump = not infiniteJump

	if infiniteJump then
		jumpButton.Text = "INFINITE JUMP : ON"
	else
		jumpButton.Text = "INFINITE JUMP : OFF"
	end
end)

UserInputService.JumpRequest:Connect(function()
	if not infiniteJump then
		return
	end

	local character = player.Character
	local humanoid = character and character:FindFirstChildOfClass("Humanoid")

	if humanoid then
		humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
	end
end)

local function getPosition()
	local character = player.Character
	local root = character and character:FindFirstChild("HumanoidRootPart")

	if root then
		return root.Position
	end

	return Vector3.new(0, 10, 0)
end

local function spawnPart()
	local part = Instance.new("Part")

	part.Size = Vector3.new(
		math.random(2, 5),
		math.random(2, 5),
		math.random(2, 5)
	)

	part.Position = getPosition() + Vector3.new(
		math.random(-20, 20),
		10,
		math.random(-20, 20)
	)

	part.Color = Color3.fromRGB(
		math.random(0, 255),
		math.random(0, 255),
		math.random(0, 255)
	)

	part.Anchored = false
	part.CanCollide = true
	part.Parent = Workspace

	part.AssemblyLinearVelocity = Vector3.new(
		math.random(-50, 50),
		math.random(20, 50),
		math.random(-50, 50)
	)

	Debris:AddItem(part, 10)
end

local function spawnExplosion()
	local explosion = Instance.new("Explosion")

	explosion.Position = getPosition() + Vector3.new(
		math.random(-20, 20),
		0,
		math.random(-20, 20)
	)

	explosion.BlastRadius = 10
	explosion.BlastPressure = 0
	explosion.DestroyJointRadiusPercent = 0
	explosion.Parent = Workspace

	Debris:AddItem(explosion, 2)
end

chaosButton.MouseButton1Click:Connect(function()
	chaos = not chaos

	if chaos then
		chaosButton.Text = "CHAOS : ON"

		task.spawn(function()
			while chaos do
				spawnPart()
				spawnExplosion()
				task.wait(0.5)
			end
		end)
	else
		chaosButton.Text = "CHAOS : OFF"
	end
end)

local hideButton = createButton("HIDE MENU", 255)

local showButton = Instance.new("TextButton")
showButton.Size = UDim2.fromOffset(100, 40)
showButton.Position = UDim2.fromOffset(15, 15)
showButton.BackgroundColor3 = Color3.fromRGB(20, 20, 30)
showButton.BorderSizePixel = 0
showButton.Text = "DANZZY"
showButton.TextColor3 = Color3.new(1, 1, 1)
showButton.TextSize = 14
showButton.Font = Enum.Font.GothamBold
showButton.Visible = false
showButton.Parent = gui

local showCorner = Instance.new("UICorner")
showCorner.CornerRadius = UDim.new(0, 10)
showCorner.Parent = showButton

hideButton.MouseButton1Click:Connect(function()
	main.Visible = false
	showButton.Visible = true
end)

showButton.MouseButton1Click:Connect(function()
	main.Visible = true
	showButton.Visible = false
end)

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

UserInputService.InputChanged:Connect(function(input)
	if not dragging then
		return
	end

	if input.UserInputType == Enum.UserInputType.MouseMovement
	or input.UserInputType == Enum.UserInputType.Touch then

		local delta = input.Position - dragStart

		main.Position = UDim2.new(
			startPosition.X.Scale,
			startPosition.X.Offset + delta.X,
			startPosition.Y.Scale,
			startPosition.Y.Offset + delta.Y
		)
	end
end)
