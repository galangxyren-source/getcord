-- JALAN NORMAL MOVETO (LAMBAT & AMAN)
local player = game.Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local humanoid = character:WaitForChild("Humanoid")
local root = character:WaitForChild("HumanoidRootPart")

local NPC_COORD = Vector3.new(510.56, 3.58, 598.88)

-- ===== NOTIF =====
local function notif(title, text)
    game.StarterGui:SetCore("SendNotification", {
        Title = title,
        Text = text,
        Duration = 4
    })
end

-- ===== NOCLIP (TAPI TIDAK PAKAI GRAVITASI 0) =====
local function noclip(state)
    for _, v in pairs(character:GetDescendants()) do
        if v:IsA("BasePart") then
            v.CanCollide = not state
        end
    end
    if state then
        humanoid:SetStateEnabled(Enum.HumanoidStateType.Climbing, false)
        humanoid:SetStateEnabled(Enum.HumanoidStateType.FallingDown, false)
        humanoid.PlatformStand = true
    else
        humanoid:SetStateEnabled(Enum.HumanoidStateType.Climbing, true)
        humanoid:SetStateEnabled(Enum.HumanoidStateType.FallingDown, true)
        humanoid.PlatformStand = false
    end
end

notif("🔥 TEST", "Script berjalan! Mulai dalam 2 detik...")
task.wait(2)

-- ===== NOCLIP ON =====
noclip(true)
notif("🌀", "Noclip aktif!")

-- ===== JALAN NORMAL PAKAI MOVETO =====
notif("🚶", "Jalan ke NPC (kira-kira 60 detik)...")

-- Hitung jarak dan estimasi waktu
local distance = (root.Position - NPC_COORD).Magnitude
local speed = 16  -- kecepatan normal Roblox
local estimatedTime = distance / speed
notif("⏱️", "Estimasi: " .. math.floor(estimatedTime) .. " detik")

humanoid.WalkSpeed = speed
humanoid:MoveTo(NPC_COORD)

-- Tunggu sampai sampai
while (root.Position - NPC_COORD).Magnitude > 4 do
    task.wait(0.1)
end

notif("✅", "Sampai di NPC!")

-- ===== INTERACT E =====
notif("🖐️", "Mencari ProximityPrompt...")
local found = false

for _, p in pairs(workspace:GetDescendants()) do
    if p:IsA("ProximityPrompt") and p.Enabled == true then
        local parent = p.Parent
        if parent and parent:IsA("BasePart") then
            local dist = (parent.Position - root.Position).Magnitude
            if dist < 15 then
                notif("🖐️", "Prompt ditemukan! Hold E...")
                p:Hold(1)
                found = true
                break
            end
        end
    end
end

if not found then
    notif("❌", "Tidak ada prompt di sekitar!")
end

-- ===== NOCLIP OFF =====
noclip(false)
notif("🔒", "Noclip mati!")

notif("🏁", "Test selesai!")
