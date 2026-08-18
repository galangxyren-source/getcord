-- JALAN 60 DETIK BERTAHAP + NOCLIP + INTERACT
local player = game.Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local humanoid = character:WaitForChild("Humanoid")
local root = character:WaitForChild("HumanoidRootPart")
local TweenService = game:GetService("TweenService")

local NPC_COORD = Vector3.new(510.56, 3.58, 598.88)

-- ===== NOTIF =====
local function notif(title, text)
    game.StarterGui:SetCore("SendNotification", {
        Title = title,
        Text = text,
        Duration = 4
    })
end

-- ===== NOCLIP =====
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
        workspace.Gravity = 0
    else
        humanoid:SetStateEnabled(Enum.HumanoidStateType.Climbing, true)
        humanoid:SetStateEnabled(Enum.HumanoidStateType.FallingDown, true)
        humanoid.PlatformStand = false
        workspace.Gravity = 196.2
    end
end

notif("🔥 TEST", "Script berjalan! Mulai dalam 2 detik...")
task.wait(2)

-- ===== NOCLIP ON =====
noclip(true)
notif("🌀", "Noclip aktif!")

-- ===== JALAN BERTAHAP 60 DETIK =====
notif("🚀", "Menuju NPC (60 detik)...")

local startPos = root.Position
local targetPos = NPC_COORD
local steps = 60
local durasi = 1.0  -- 60 × 1.0 = 60 detik

for i = 1, steps do
    local t = i / steps
    local pos = Vector3.new(
        startPos.X + (targetPos.X - startPos.X) * t,
        startPos.Y + (targetPos.Y - startPos.Y) * t,
        startPos.Z + (targetPos.Z - startPos.Z) * t
    )
    
    -- Animasi jalan (gerakkan kaki sedikit)
    if i % 2 == 0 then
        root.CFrame = CFrame.new(pos) * CFrame.Angles(0, 0, 0.02)
    else
        root.CFrame = CFrame.new(pos) * CFrame.Angles(0, 0, -0.02)
    end
    
    -- Efek bayangan/jejak (opsional)
    -- local trail = Instance.new("Part")
    -- trail.Size = Vector3.new(1, 0.1, 1)
    -- trail.Position = pos - Vector3.new(0, 1, 0)
    -- trail.Anchored = true
    -- trail.CanCollide = false
    -- trail.Parent = workspace
    
    task.wait(durasi)
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
