--==================================================
--              DANZZY PREMIUM
--==================================================
-- Auto Farm Brewog
-- TP Brewog
-- Get Coordinate
-- Speed 16 / 50 / 500
-- Infinite Jump
-- Hide / Show
--==================================================

local Players = game:GetService("Players")
local UIS = game:GetService("UserInputService")
local Lighting = game:GetService("Lighting")

local Player = Players.LocalPlayer
local PlayerGui = Player:WaitForChild("PlayerGui")

--==================================================
-- SETTINGS
--==================================================

_G.DanzzyAutoFarm = false
local BrewogTarget = "Brewog"

--==================================================
-- GUI
--==================================================

local Gui = Instance.new("ScreenGui")
Gui.Name = "DanzzyPremium"
Gui.ResetOnSpawn = false
Gui.Parent = PlayerGui

local Main = Instance.new("Frame")
Main.Parent = Gui
Main.Size = UDim2.fromOffset(330,390)
Main.Position = UDim2.new(0.5,-165,0.5,-195)
Main.BackgroundColor3 = Color3.fromRGB(17,19,27)
Main.BorderSizePixel = 0

Instance.new("UICorner",Main).CornerRadius = UDim.new(0,12)

local Stroke = Instance.new("UIStroke")
Stroke.Parent = Main
Stroke.Color = Color3.fromRGB(75,80,100)
Stroke.Thickness = 1.5

--==================================================
-- TITLE
--==================================================

local Title = Instance.new("TextLabel")
Title.Parent = Main
Title.Size = UDim2.new(1,-80,0,45)
Title.Position = UDim2.fromOffset(15,5)
Title.BackgroundTransparency = 1
Title.Text = "DANZZY PREMIUM"
Title.TextColor3 = Color3.new(1,1,1)
Title.TextSize = 19
Title.Font = Enum.Font.GothamBold
Title.TextXAlignment = Enum.TextXAlignment.Left

local Close = Instance.new("TextButton")
Close.Parent = Main
Close.Size = UDim2.fromOffset(32,30)
Close.Position = UDim2.new(1,-42,0,10)
Close.Text = "X"
Close.TextColor3 = Color3.new(1,1,1)
Close.TextSize = 13
Close.Font = Enum.Font.GothamBold
Close.BackgroundColor3 = Color3.fromRGB(190,45,45)
Close.BorderSizePixel = 0

Instance.new("UICorner",Close).CornerRadius = UDim.new(0,6)

--==================================================
-- STATUS
--==================================================

local Status = Instance.new("TextLabel")
Status.Parent = Main
Status.Size = UDim2.new(1,-30,0,32)
Status.Position = UDim2.fromOffset(15,45)
Status.BackgroundTransparency = 1
Status.Text = "● DANZZY READY"
Status.TextColor3 = Color3.fromRGB(80,220,120)
Status.TextSize = 11
Status.Font = Enum.Font.GothamBold
Status.TextXAlignment = Enum.TextXAlignment.Left

--==================================================
-- BUTTON
--==================================================

local function Button(Text, X, Y)

    local B = Instance.new("TextButton")
    B.Parent = Main
    B.Size = UDim2.fromOffset(145,42)
    B.Position = UDim2.fromOffset(X,Y)
    B.BackgroundColor3 = Color3.fromRGB(43,47,60)
    B.BorderSizePixel = 0
    B.Text = Text
    B.TextColor3 = Color3.new(1,1,1)
    B.TextSize = 11
    B.Font = Enum.Font.GothamBold
    B.AutoButtonColor = false

    Instance.new("UICorner",B).CornerRadius = UDim.new(0,7)

    return B
end

--==================================================
-- MAIN BUTTONS
--==================================================

local AutoFarm = Button("AUTO FARM : OFF",15,85)
local TPBrewog = Button("TP BREWOG",170,85)

local Speed16 = Button("SPEED : 16",15,135)
local Speed50 = Button("SPEED : 50",170,135)

local Speed500 = Button("SPEED : 500",15,185)
local Infinite = Button("INFINITE JUMP : OFF",170,185)

local GetCoord = Button("GET COORD",15,235)
local Fullbright = Button("FULLBRIGHT : OFF",170,235)

local Hide = Button("HIDE MENU",15,285)

--==================================================
-- HUMANOID
--==================================================

local function GetCharacter()

    local Character = Player.Character

    if not Character then
        Character = Player.CharacterAdded:Wait()
    end

    return Character
end

local function GetRoot()

    local Character = GetCharacter()

    return Character:FindFirstChild("HumanoidRootPart")
end

local function GetHumanoid()

    local Character = GetCharacter()

    return Character:FindFirstChildOfClass("Humanoid")
end

--==================================================
-- FIND BREWOG
--==================================================

local function FindBrewog()

    return workspace:FindFirstChild(BrewogTarget,true)

end

--==================================================
-- TELEPORT BREWOG
--==================================================

local function TeleportBrewog()

    local Root = GetRoot()
    local Target = FindBrewog()

    if not Root then
        Status.Text = "● CHARACTER BELUM SIAP"
        return
    end

    if not Target then
        Status.Text = "● BREWOG TIDAK DITEMUKAN"
        return
    end

    local Part

    if Target:IsA("BasePart") then

        Part = Target

    elseif Target:IsA("Model") then

        Part =
            Target.PrimaryPart
            or Target:FindFirstChildWhichIsA("BasePart",true)

    end

    if not Part then
        Status.Text = "● PART BREWOG TIDAK ADA"
        return
    end

    Root.CFrame = Part.CFrame + Vector3.new(0,3,0)

    Status.Text = "● TP : BREWOG"

end

TPBrewog.MouseButton1Click:Connect(TeleportBrewog)

--==================================================
-- AUTO FARM
--==================================================

local function ActivatePrompt()

    local Target = FindBrewog()

    if not Target then
        return false
    end

    local Prompt = Target:FindFirstChildWhichIsA(
        "ProximityPrompt",
        true
    )

    if Prompt then

        pcall(function()
            fireproximityprompt(Prompt)
        end)

        return true
    end

    return false
end

local function AutoFarmLoop()

    task.spawn(function()

        while _G.DanzzyAutoFarm do

            local Target = FindBrewog()

            if not Target then

                Status.Text = "● MENCARI BREWOG..."

                task.wait(2)

                continue
            end

            Status.Text = "● MENUJU BREWOG..."

            TeleportBrewog()

            task.wait(1)

            if not _G.DanzzyAutoFarm then
                break
            end

            Status.Text = "● FARM BREWOG..."

            ActivatePrompt()

            task.wait(1)

        end

        Status.Text = "● AUTO FARM : OFF"

    end)

end

AutoFarm.MouseButton1Click:Connect(function()

    _G.DanzzyAutoFarm = not _G.DanzzyAutoFarm

    if _G.DanzzyAutoFarm then

        AutoFarm.Text = "AUTO FARM : ON"
        AutoFarm.BackgroundColor3 =
            Color3.fromRGB(35,150,75)

        Status.Text = "● AUTO FARM BREWOG : ON"

        AutoFarmLoop()

    else

        AutoFarm.Text = "AUTO FARM : OFF"
        AutoFarm.BackgroundColor3 =
            Color3.fromRGB(43,47,60)

        Status.Text = "● AUTO FARM : OFF"

    end

end)

--==================================================
-- SPEED
--==================================================

Speed16.MouseButton1Click:Connect(function()

    local Humanoid = GetHumanoid()

    if Humanoid then

        Humanoid.WalkSpeed = 16
        Status.Text = "● SPEED : 16"

    end

end)

Speed50.MouseButton1Click:Connect(function()

    local Humanoid = GetHumanoid()

    if Humanoid then

        Humanoid.WalkSpeed = 50
        Status.Text = "● SPEED : 50"

    end

end)

Speed500.MouseButton1Click:Connect(function()

    local Humanoid = GetHumanoid()

    if Humanoid then

        Humanoid.WalkSpeed = 500
        Status.Text = "● SPEED : 500"

    end

end)

--==================================================
-- INFINITE JUMP
--==================================================

local InfiniteOn = false

Infinite.MouseButton1Click:Connect(function()

    InfiniteOn = not InfiniteOn

    if InfiniteOn then

        Infinite.Text = "INFINITE JUMP : ON"
        Infinite.BackgroundColor3 =
            Color3.fromRGB(35,150,75)

    else

        Infinite.Text = "INFINITE JUMP : OFF"
        Infinite.BackgroundColor3 =
            Color3.fromRGB(43,47,60)

    end

end)

UIS.JumpRequest:Connect(function()

    if not InfiniteOn then
        return
    end

    local Humanoid = GetHumanoid()

    if Humanoid then

        Humanoid:ChangeState(
            Enum.HumanoidStateType.Jumping
        )

    end

end)

--==================================================
-- GET COORD
--==================================================

GetCoord.MouseButton1Click:Connect(function()

    local Root = GetRoot()

    if not Root then
        Status.Text = "● ROOT TIDAK DITEMUKAN"
        return
    end

    local P = Root.Position

    print("========== DANZZY COORD ==========")
    print("X =",P.X)
    print("Y =",P.Y)
    print("Z =",P.Z)
    print("==================================")

    Status.Text = string.format(
        "X %.1f | Y %.1f | Z %.1f",
        P.X,P.Y,P.Z
    )

end)

--==================================================
-- FULLBRIGHT
--==================================================

local BrightOn = false

Fullbright.MouseButton1Click:Connect(function()

    BrightOn = not BrightOn

    if BrightOn then

        Lighting.Brightness = 3
        Lighting.ClockTime = 14
        Lighting.FogEnd = 100000

        Fullbright.Text = "FULLBRIGHT : ON"

    else

        Lighting.Brightness = 1
        Lighting.FogEnd = 1000

        Fullbright.Text = "FULLBRIGHT : OFF"

    end

end)

--==================================================
-- HIDE / SHOW
--==================================================

local Show = Instance.new("TextButton")
Show.Parent = Gui
Show.Size = UDim2.fromOffset(55,55)
Show.Position = UDim2.new(0,20,0.5,-25)
Show.Text = "D"
Show.TextSize = 21
Show.Font = Enum.Font.GothamBold
Show.TextColor3 = Color3.new(1,1,1)
Show.BackgroundColor3 = Color3.fromRGB(25,28,38)
Show.BorderSizePixel = 0
Show.Visible = false

Instance.new("UICorner",Show).CornerRadius =
    UDim.new(1,0)

Hide.MouseButton1Click:Connect(function()

    Main.Visible = false
    Show.Visible = true

end)

Show.MouseButton1Click:Connect(function()

    Main.Visible = true
    Show.Visible = false

end)

--==================================================
-- CLOSE
--==================================================

Close.MouseButton1Click:Connect(function()

    _G.DanzzyAutoFarm = false
    Gui:Destroy()

end)

--==================================================
-- DRAG
--==================================================

local Dragging = false
local DragStart
local StartPos

Title.InputBegan:Connect(function(Input)

    if Input.UserInputType == Enum.UserInputType.MouseButton1
    or Input.UserInputType == Enum.UserInputType.Touch then

        Dragging = true
        DragStart = Input.Position
        StartPos = Main.Position

    end

end)

UIS.InputChanged:Connect(function(Input)

    if not Dragging then
        return
    end

    if Input.UserInputType == Enum.UserInputType.MouseMovement
    or Input.UserInputType == Enum.UserInputType.Touch then

        local Delta = Input.Position - DragStart

        Main.Position = UDim2.new(
            StartPos.X.Scale,
            StartPos.X.Offset + Delta.X,
            StartPos.Y.Scale,
            StartPos.Y.Offset + Delta.Y
        )

    end

end)

UIS.InputEnded:Connect(function(Input)

    if Input.UserInputType == Enum.UserInputType.MouseButton1
    or Input.UserInputType == Enum.UserInputType.Touch then

        Dragging = false

    end

end)

print("DANZZY PREMIUM READY")
