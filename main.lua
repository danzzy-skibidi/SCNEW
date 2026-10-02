local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")
local Debris = game:GetService("Debris")
local UserInputService = game:GetService("UserInputService")

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

local chaos = false
local infiniteJump = false

local gui = Instance.new("ScreenGui")
gui.Name = "DanzzyChaosGUI"
gui.ResetOnSpawn = false
gui.Parent = playerGui

local main = Instance.new("Frame")
main.Size = UDim2.fromOffset(270, 250)
main.Position = UDim2.new(0.5, -135, 0.5, -125)
main.BackgroundColor3 = Color3.fromRGB(20, 20, 30)
main.BorderSizePixel = 0
main.Parent = gui

local corner = Instance.new("UICorner")
corner.CornerRadius = UDim.new(0, 12)
corner.Parent = main

local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, -20, 0, 40)
title.Position = UDim2.fromOffset(10, 5)
title.BackgroundTransparency = 1
title.Text = "DANZZY CHAOS"
title.TextColor3 = Color3.new(1, 1, 1)
title.TextSize = 21
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

local chaosButton = createButton("CHAOS : OFF", 50)

local speedBox = Instance.new("TextBox")
speedBox.Size = UDim2.new(1, -30, 0, 40)
speedBox.Position = UDim2.fromOffset(15, 100)
speedBox.BackgroundColor3 = Color3.fromRGB(45, 45, 60)
speedBox.BorderSizePixel = 0
speedBox.PlaceholderText = "Ketik WalkSpeed, contoh 50"
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

local speedButton = createButton("SET WALKSPEED", 150)

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

local jumpButton = createButton("INFINITE JUMP : OFF", 200)

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
