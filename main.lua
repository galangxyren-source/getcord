-- JALAN 15 DETIK BERTAHAP + NOCLIP + INTERACT
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

-- ===== JALAN BERTAHAP 15 DETIK =====
notif("🚀", "Menuju NPC (15 detik)...")

local startPos = root.Position
local targetPos = NPC_COORD
local steps = 30
local durasi = 0.5  -- detik per step (30 × 0.5 = 15 detik)

for i = 1, steps do
    local t = i / steps
    local pos = Vector3.new(
        startPos.X + (targetPos.X - startPos.X) * t,
        startPos.Y + (targetPos.Y - startPos.Y) * t,
        startPos.Z + (targetPos.Z - startPos.Z) * t
    )
    local tween = TweenService:Create(root, TweenInfo.new(durasi, Enum.EasingStyle.Linear), {CFrame = CFrame.new(pos)})
    tween:Play()
    tween.Completed:Wait()
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
