local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local UIS = game:GetService("UserInputService")

local player = Players.LocalPlayer
local gui = Instance.new("ScreenGui")
gui.Name = "DanzzyGanteng"
gui.ResetOnSpawn = false
gui.Parent = player:WaitForChild("PlayerGui")

local frame = Instance.new("Frame")
frame.Size = UDim2.fromOffset(280, 300)
frame.Position = UDim2.new(0.5, -140, 0.5, -150)
frame.BackgroundColor3 = Color3.fromRGB(25,25,35)
frame.Active = true
frame.Parent = gui

Instance.new("UICorner", frame).CornerRadius = UDim.new(0,12)

local title = Instance.new("TextLabel")
title.Size = UDim2.new(1,0,0,45)
title.BackgroundTransparency = 1
title.Text = "DANZZY GANTENG"
title.TextColor3 = Color3.new(1,1,1)
title.TextSize = 20
title.Font = Enum.Font.GothamBold
title.Parent = frame

local function button(text, y)
	local b = Instance.new("TextButton")
	b.Size = UDim2.new(1,-30,0,40)
	b.Position = UDim2.fromOffset(15,y)
	b.BackgroundColor3 = Color3.fromRGB(50,50,65)
	b.Text = text
	b.TextColor3 = Color3.new(1,1,1)
	b.Font = Enum.Font.GothamBold
	b.TextSize = 14
	b.Parent = frame
	Instance.new("UICorner",b).CornerRadius = UDim.new(0,8)
	return b
end

-- Infinite Jump
local jump = false
local jumpBtn = button("INFINITE JUMP : OFF",55)

jumpBtn.MouseButton1Click:Connect(function()
	jump = not jump
	jumpBtn.Text = jump and "INFINITE JUMP : ON" or "INFINITE JUMP : OFF"
end)

UIS.JumpRequest:Connect(function()
	if jump then
		local char = player.Character
		local hum = char and char:FindFirstChildOfClass("Humanoid")

		if hum then
			hum:ChangeState(Enum.HumanoidStateType.Jumping)
		end
	end
end)

-- WalkSpeed
local speed = Instance.new("TextBox")
speed.Size = UDim2.new(1,-30,0,40)
speed.Position = UDim2.fromOffset(15,105)
speed.PlaceholderText = "WalkSpeed"
speed.Text = ""
speed.TextColor3 = Color3.new(1,1,1)
speed.BackgroundColor3 = Color3.fromRGB(50,50,65)
speed.Parent = frame
Instance.new("UICorner",speed).CornerRadius = UDim.new(0,8)

local speedBtn = button("SET WALKSPEED",155)

speedBtn.MouseButton1Click:Connect(function()
	local value = tonumber(speed.Text)
	local char = player.Character
	local hum = char and char:FindFirstChildOfClass("Humanoid")

	if value and hum then
		hum.WalkSpeed = math.clamp(value,0,100)
	end
end)

-- Kill Player
local target = Instance.new("TextBox")
target.Size = UDim2.new(1,-30,0,40)
target.Position = UDim2.fromOffset(15,205)
target.PlaceholderText = "Username pemain"
target.Text = ""
target.TextColor3 = Color3.new(1,1,1)
target.BackgroundColor3 = Color3.fromRGB(50,50,65)
target.Parent = frame
Instance.new("UICorner",target).CornerRadius = UDim.new(0,8)

local killBtn = button("KILL PLAYER",255)

killBtn.MouseButton1Click:Connect(function()
	if target.Text == "" then return end

	local event = ReplicatedStorage:FindFirstChild("DanzzyKillTarget")

	if event then
		event:FireServer(target.Text)
	end
end)
