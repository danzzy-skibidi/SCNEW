-- ========================================================
--               INDO GLERITY REBORN PREMIUM
-- ========================================================
--  [+] Created By : @beruk
--  [+] Version    : v1.0.1-Fixed
--  [+] Features   : Auto Job, Screen GUI Toggle
-- ========================================================

local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")

local LocalPlayer = Players.LocalPlayer

-- ========================================================
-- GUI
-- ========================================================

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "IndoGlerityPremium"
ScreenGui.ResetOnSpawn = false
ScreenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")

local Frame = Instance.new("Frame")
Frame.Parent = ScreenGui
Frame.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
Frame.Position = UDim2.new(0.02, 0, 0.1, 0)
Frame.Size = UDim2.new(0, 260, 0, 180)
Frame.BorderSizePixel = 0

local UICornerFrame = Instance.new("UICorner")
UICornerFrame.CornerRadius = UDim.new(0, 8)
UICornerFrame.Parent = Frame

-- ========================================================
-- TITLE
-- ========================================================

local TitleLabel = Instance.new("TextLabel")
TitleLabel.Parent = Frame
TitleLabel.Size = UDim2.new(1, 0, 0, 30)
TitleLabel.BackgroundColor3 = Color3.fromRGB(255, 165, 0)
TitleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
TitleLabel.TextSize = 14
TitleLabel.Font = Enum.Font.SourceSansBold
TitleLabel.Text = "  INDO GLERITY AUTOMATION"
TitleLabel.TextXAlignment = Enum.TextXAlignment.Left
TitleLabel.BorderSizePixel = 0

local TitleCorner = Instance.new("UICorner")
TitleCorner.CornerRadius = UDim.new(0, 8)
TitleCorner.Parent = TitleLabel

-- ========================================================
-- INFO
-- ========================================================

local InfoLabel = Instance.new("TextLabel")
InfoLabel.Parent = Frame
InfoLabel.Position = UDim2.new(0, 10, 0, 35)
InfoLabel.Size = UDim2.new(1, -20, 0, 90)
InfoLabel.BackgroundTransparency = 1
InfoLabel.TextColor3 = Color3.fromRGB(220, 220, 220)
InfoLabel.TextSize = 13
InfoLabel.Font = Enum.Font.SourceSans
InfoLabel.TextWrapped = true
InfoLabel.TextXAlignment = Enum.TextXAlignment.Left
InfoLabel.TextYAlignment = Enum.TextYAlignment.Top
InfoLabel.RichText = true

-- ========================================================
-- BUTTON
-- ========================================================

local ToggleButton = Instance.new("TextButton")
ToggleButton.Parent = Frame
ToggleButton.Position = UDim2.new(0, 10, 0, 135)
ToggleButton.Size = UDim2.new(1, -20, 0, 35)
ToggleButton.BackgroundColor3 = Color3.fromRGB(200, 30, 30)
ToggleButton.Font = Enum.Font.SourceSansBold
ToggleButton.TextSize = 14
ToggleButton.TextColor3 = Color3.fromRGB(255, 255, 255)
ToggleButton.Text = "MULAI BOT"
ToggleButton.BorderSizePixel = 0

local UICornerButton = Instance.new("UICorner")
UICornerButton.CornerRadius = UDim.new(0, 6)
UICornerButton.Parent = ToggleButton

-- ========================================================
-- STATUS
-- ========================================================

local function updateStatus(statusBaru)
    InfoLabel.Text = string.format(
        "<b>Owner:</b> @XyzOwner\n" ..
        "<b>Version:</b> v1.0.1-Fixed\n" ..
        "<b>Features:</b> Auto Job\n\n" ..
        "<b>Status:</b> <font color='#FFA500'>%s</font>",
        tostring(statusBaru)
    )
end

_G.AutoJobGlerity = false

updateStatus("Bot Siap Digunakan!")

-- ========================================================
-- HELPER
-- ========================================================

local function getCharacter()
    return LocalPlayer.Character
        or LocalPlayer.CharacterAdded:Wait()
end

local function getRoot()
    local character = getCharacter()
    return character:FindFirstChild("HumanoidRootPart")
end

local function getHumanoid()
    local character = getCharacter()
    return character:FindFirstChildOfClass("Humanoid")
end

-- Mengambil posisi dari Part / Model / Decal
local function getObjectPosition(object)

    if not object then
        return nil
    end

    if object:IsA("BasePart") then
        return object.Position
    end

    if object:IsA("Attachment") then
        return object.WorldPosition
    end

    if object:IsA("Decal") then

        local parent = object.Parent

        if parent and parent:IsA("BasePart") then
            return parent.Position
        end

    end

    if object:IsA("Model") then

        local primary = object.PrimaryPart

        if primary then
            return primary.Position
        end

        local part =
            object:FindFirstChildWhichIsA(
                "BasePart",
                true
            )

        if part then
            return part.Position
        end
    end

    return nil
end

-- ========================================================
-- PENGATURAN
-- ========================================================

local KECEPATAN_TERBANG = 65
local TINGGI_TERBANG = 25

-- ========================================================
-- JALAN KE TARGET
-- ========================================================

local function jalanKeTarget(posisiTarget)

    local humanoid = getHumanoid()
    local root = getRoot()

    if not humanoid or not root then
        return false
    end

    if typeof(posisiTarget) ~= "Vector3" then
        return false
    end

    local timeout = 0

    while _G.AutoJobGlerity do

        root = getRoot()

        if not root then
            return false
        end

        local jarak =
            (root.Position - posisiTarget).Magnitude

        if jarak <= 4 then
            return true
        end

        humanoid:MoveTo(posisiTarget)

        task.wait(0.15)

        timeout += 0.15

        -- Mencegah loop selamanya
        if timeout >= 30 then
            return false
        end
    end

    return false
end

-- ========================================================
-- CARI MOBIL PLAYER
-- ========================================================

local function cariMobilPemain()

    local humanoid = getHumanoid()

    if not humanoid then
        return nil
    end

    for _, object in ipairs(
        workspace:GetDescendants()
    ) do

        if object:IsA("VehicleSeat")
        and object.Occupant == humanoid then

            return object.Parent
        end
    end

    return nil
end

-- ========================================================
-- CARI OBJEK BERDASARKAN NAMA / WARNA
-- ========================================================

local function cariObjekBerdasarkanWarna(namaWarna)

    local root = getRoot()

    if not root then
        return nil
    end

    local terdekat = nil
    local jarakTerdekat = math.huge

    for _, object in ipairs(
        workspace:GetDescendants()
    ) do

        local position =
            getObjectPosition(object)

        if position then

            local nama =
                string.lower(object.Name)

            local cocok = false

            if namaWarna == "Kuning" then

                if object:IsA("BasePart") then

                    local warna =
                        object.BrickColor.Name

                    cocok =
                        warna == "New Yeller"
                        or warna == "Bright yellow"
                        or string.find(nama, "yellow")
                        or string.find(nama, "panah")
                        or string.find(nama, "delivery")
                        or string.find(nama, "target")

                else

                    cocok =
                        string.find(nama, "yellow")
                        or string.find(nama, "panah")
                        or string.find(nama, "delivery")
                        or string.find(nama, "target")

                end

            elseif namaWarna == "Merah" then

                if object:IsA("BasePart") then

                    local warna =
                        object.BrickColor.Name

                    cocok =
                        warna == "Bright red"
                        or nama == "job"
                        or string.find(nama, "job")
                        or string.find(nama, "red")

                else

                    cocok =
                        nama == "job"
                        or string.find(nama, "job")
                        or string.find(nama, "red")

                end
            end

            if cocok then

                local jarak =
                    (root.Position - position).Magnitude

                if jarak < jarakTerdekat
                and jarak > 2 then

                    jarakTerdekat = jarak
                    terdekat = object

                end
            end
        end
    end

    return terdekat
end

-- ========================================================
-- CARI SPOT JOB
-- ========================================================

local function cariSpotJob()

    local job =
        workspace:FindFirstChild(
            "job",
            true
        )

    if job and getObjectPosition(job) then
        return job
    end

    return cariObjekBerdasarkanWarna("Merah")
end

-- ========================================================
-- PINDAH KE TARGET
-- ========================================================

local function terbangKeTarget(targetObject)

    if not targetObject
    or not _G.AutoJobGlerity then
        return false
    end

    local mobil =
        cariMobilPemain()

    if not mobil then
        return false
    end

    local targetPos =
        getObjectPosition(targetObject)

    if not targetPos then
        return false
    end

    local mainPart =
        mobil:FindFirstChild("DriveSeat")
        or mobil:FindFirstChild("VehicleSeat")
        or mobil.PrimaryPart
        or mobil:FindFirstChildWhichIsA(
            "BasePart",
            true
        )

    if not mainPart then
        return false
    end

    -- Naik ke posisi atas
    local posisiAtas =
        mainPart.Position
        + Vector3.new(
            0,
            TINGGI_TERBANG,
            0
        )

    local naik =
        TweenService:Create(
            mainPart,
            TweenInfo.new(1.2),
            {
                CFrame =
                    CFrame.new(posisiAtas)
            }
        )

    naik:Play()
    naik.Completed:Wait()

    if not _G.AutoJobGlerity then
        return false
    end

    -- Bergerak horizontal
    local jarak =
        (
            mainPart.Position
            - targetPos
        ).Magnitude

    local durasi =
        math.max(
            jarak / KECEPATAN_TERBANG,
            0.1
        )

    local targetCFrame =
        CFrame.new(
            targetPos.X,
            posisiAtas.Y,
            targetPos.Z
        )

    local perjalanan =
        TweenService:Create(
            mainPart,
            TweenInfo.new(
                durasi,
                Enum.EasingStyle.Linear
            ),
            {
                CFrame = targetCFrame
            }
        )

    perjalanan:Play()
    perjalanan.Completed:Wait()

    if not _G.AutoJobGlerity then
        return false
    end

    -- Turun ke target
    local turun =
        TweenService:Create(
            mainPart,
            TweenInfo.new(1.2),
            {
                CFrame =
                    CFrame.new(targetPos)
            }
        )

    turun:Play()
    turun.Completed:Wait()

    return true
end

-- ========================================================
-- LOOP UTAMA
-- ========================================================

local function startLoop()

    task.spawn(function()

        while _G.AutoJobGlerity do

            -- STEP 1
            updateStatus(
                "Mencari Spot Job..."
            )

            local spotJob =
                cariSpotJob()

            if not spotJob then

                updateStatus(
                    "Spot Job tidak ditemukan..."
                )

                task.wait(2)
                continue
            end

            local posisiJob =
                getObjectPosition(spotJob)

            if not posisiJob then

                task.wait(1)
                continue
            end

            -- STEP 2
            updateStatus(
                "Jalan ke Spot Job..."
            )

            local sampai =
                jalanKeTarget(posisiJob)

            if not sampai then

                task.wait(1)
                continue
            end

            if not _G.AutoJobGlerity then
                break
            end

            task.wait(2)

            -- STEP 3
            updateStatus(
                "Menunggu Kendaraan..."
            )

            local kendaraan = nil
            local waktu = 0

            repeat

                kendaraan =
                    cariMobilPemain()

                task.wait(0.5)

                waktu += 0.5

                if waktu >= 30 then
                    break
                end

            until kendaraan
            or not _G.AutoJobGlerity

            if not _G.AutoJobGlerity then
                break
            end

            if not kendaraan then

                updateStatus(
                    "Kendaraan tidak ditemukan."
                )

                task.wait(2)
                continue
            end

            -- STEP 4
            updateStatus(
                "Mencari Tujuan..."
            )

            local target =
                cariObjekBerdasarkanWarna(
                    "Kuning"
                )

            if not target then

                updateStatus(
                    "Target kuning tidak ditemukan."
                )

                task.wait(2)
                continue
            end

            -- STEP 5
            updateStatus(
                "Menuju Target..."
            )

            terbangKeTarget(target)

            if not _G.AutoJobGlerity then
                break
            end

            -- STEP 6
            updateStatus(
                "Menunggu Proses Job..."
            )

            task.wait(5)

            if not _G.AutoJobGlerity then
                break
            end

            -- STEP 7
            updateStatus(
                "Mencari Target Berikutnya..."
            )

            task.wait(1)
        end

        updateStatus(
            "Bot Dinonaktifkan!"
        )

    end)
end

-- ========================================================
-- ON / OFF
-- ========================================================

ToggleButton.MouseButton1Click:Connect(
    function()

        if not _G.AutoJobGlerity then

            _G.AutoJobGlerity = true

            ToggleButton.BackgroundColor3 =
                Color3.fromRGB(
                    30,
                    150,
                    30
                )

            ToggleButton.Text =
                "STOP BOT"

            updateStatus(
                "Bot Aktif..."
            )

            startLoop()

        else

            _G.AutoJobGlerity = false

            ToggleButton.BackgroundColor3 =
                Color3.fromRGB(
                    200,
                    30,
                    30
                )

            ToggleButton.Text =
                "MULAI BOT"

            updateStatus(
                "Bot Dinonaktifkan!"
            )

        end
    end
)

-- ========================================================
-- RESET SAAT RESPAWN
-- ========================================================

LocalPlayer.CharacterAdded:Connect(
    function()
        if _G.AutoJobGlerity then
            task.wait(2)
            updateStatus(
                "Character respawn, bot aktif..."
            )
        end
    end
)

print(
    "[INDO GLERITY] Script berhasil dimuat."
)
