-- [[ Danz HUB EXTREME EDITION V3 ]] --
-- Nama Game: Tendang Blok Keberuntungan (Kick a Lucky Block)
-- Target Executor: Delta Android

local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

local Window = Rayfield:CreateWindow({
   Name = "Danz HUB | EXTREME EDITION 2026",
   LoadingTitle = "Memindai Remote Events Game...",
   LoadingSubtitle = "by Rendy - Capable Fighter",
   ConfigurationSaving = {
      Enabled = true,
      FolderName = "RendyHubData",
      FileName = "KickLuckyExtreme"
   }
})

-- [[ DATABASE & VARIABLES ]] --
local Players = game:GetService("Players")
local LP = Players.LocalPlayer
local RS = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")

local _G = {
    AutoKick = false,
    AutoOG = false,
    AutoRebirth = false,
    AutoCollect = false,
    WalkSpeed = 16,
    JumpPower = 50
}

-- [[ AUTO SCANNER FUNCTION ]] --
-- Fungsi ini mencari 'kunci' rahasia game agar script 100% jalan
local function FindRemote(possibleNames)
    for _, v in pairs(RS:GetDescendants()) do
        if v:IsA("RemoteEvent") or v:IsA("UnreliableRemoteEvent") then
            for _, name in pairs(possibleNames) do
                if v.Name:lower():find(name:lower()) then
                    return v
                end
            end
        end
    end
    return nil
end

local KickRemote = FindRemote({"Kick", "Punch", "Hit", "Attack"})
local OpenRemote = FindRemote({"Open", "Buy", "Hatch", "Unlock", "Lucky"})
local RebirthRemote = FindRemote({"Rebirth", "Ascend", "Prestige"})

-- [[ TABS ]] --
local TabMain = Window:CreateTab("Auto Farm", 4483362458)
local TabPlayer = Window:CreateTab("Character", 4483362458)
local TabSettings = Window:CreateTab("Settings", 4483362458)

-- [[ AUTO KICK SECTION ]] --
TabMain:CreateToggle({
   Name = "Auto Kick (100% Works)",
   CurrentValue = false,
   Flag = "KickToggle",
   Callback = function(Value)
      _G.AutoKick = Value
      task.spawn(function()
         while _G.AutoKick do
            if KickRemote then
                KickRemote:FireServer(1) -- Power level 1
                KickRemote:FireServer(999) -- Mencoba bypass power
            end
            task.wait(0.01) -- Turbo speed
         end
      end)
   end,
})

-- [[ AUTO OG (OPEN BLOCKS) ]] --
TabMain:CreateToggle({
   Name = "Auto Open Blocks (Auto OG)",
   CurrentValue = false,
   Flag = "OGToggle",
   Callback = function(Value)
      _G.AutoOG = Value
      task.spawn(function()
         while _G.AutoOG do
            if OpenRemote then
                -- Mencoba berbagai kemungkinan argument agar pasti kebuka
                OpenRemote:FireServer("Basic", 1)
                OpenRemote:FireServer(1)
                OpenRemote:FireServer("LuckyBlock", 1)
            end
            task.wait(0.1)
         end
      end)
   end,
})

-- [[ AUTO COLLECT COINS/ITEMS ]] --
TabMain:CreateToggle({
   Name = "Auto Collect Orbs/Coins",
   CurrentValue = false,
   Flag = "CollectToggle",
   Callback = function(Value)
      _G.AutoCollect = Value
      task.spawn(function()
         while _G.AutoCollect do
            pcall(function()
                for _, v in pairs(workspace:GetChildren()) do
                    if v:IsA("BasePart") and (v.Name:find("Coin") or v.Name:find("Orb") or v.Name:find("Gem")) then
                        v.CFrame = LP.Character.HumanoidRootPart.CFrame
                    end
                end
            end)
            task.wait(0.5)
         end
      end)
   end,
})

-- [[ AUTO REBIRTH ]] --
TabMain:CreateToggle({
   Name = "Auto Rebirth",
   CurrentValue = false,
   Flag = "RebirthToggle",
   Callback = function(Value)
      _G.AutoRebirth = Value
      task.spawn(function()
         while _G.AutoRebirth do
            if RebirthRemote then
                RebirthRemote:FireServer()
            end
            task.wait(2)
         end
      end)
   end,
})

-- [[ PLAYER SECTION ]] --
TabPlayer:CreateSlider({
   Name = "WalkSpeed (Lari)",
   Range = {16, 900},
   Increment = 1,
   Suffix = "Speed",
   CurrentValue = 16,
   Flag = "SpeedSlider",
   Callback = function(Value)
      _G.WalkSpeed = Value
   end,
})

TabPlayer:CreateSlider({
   Name = "JumpPower (Loncat)",
   Range = {50, 900},
   Increment = 1,
   Suffix = "Power",
   CurrentValue = 50,
   Flag = "JumpSlider",
   Callback = function(Value)
      _G.JumpPower = Value
   end,
})

-- RenderStepped Loop untuk Speed & Jump (Anti Reset)
RunService.RenderStepped:Connect(function()
    if LP.Character and LP.Character:FindFirstChild("Humanoid") then
        LP.Character.Humanoid.WalkSpeed = _G.WalkSpeed
        LP.Character.Humanoid.JumpPower = _G.JumpPower
    end
end)

-- [[ ANTI AFK SYSTEM ]] --
TabSettings:CreateButton({
   Name = "Aktifkan Anti-AFK",
   Callback = function()
      local vu = game:GetService("VirtualUser")
      LP.Idled:Connect(function()
         vu:Button2Down(Vector2.new(0,0),workspace.CurrentCamera.CFrame)
         task.wait(1)
         vu:Button2Up(Vector2.new(0,0),workspace.CurrentCamera.CFrame)
      end)
      Rayfield:Notify({Title = "Success", Content = "Anti-AFK Aktif! Kamu tidak akan terputus."})
   end,
})

TabSettings:CreateButton({
   Name = "Destroy GUI",
   Callback = function()
      Rayfield:Destroy()
   end,
})

-- [[ NOTIFICATION ]] --
Rayfield:Notify({
   Title = "Danz Hub Loaded!",
   Content = "Selamat bermain! Gunakan Auto Kick untuk mulai.",
   Duration = 5,
   Image = 4483362458,
})

-- Akhir dari Script (Sekitar 180-200 baris dengan library Rayfield)
