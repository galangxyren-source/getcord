-- TURUN LEBIH DALAM + KUNCI POSISI Y
local player = game.Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local humanoid = character:WaitForChild("Humanoid")
local root = character:WaitForChild("HumanoidRootPart")

local TARGET_Y = -5  -- turun 5 stud di bawah permukaan (cukup dalam)

-- ===== NOTIF =====
local function notif(title, text)
    game.StarterGui:SetCore("SendNotification", {
        Title = title,
        Text = text,
        Duration = 4
    })
end

-- ===== NOCLIP + PLATFORMSTAND =====
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

notif("🌀", "Noclip aktif! Turun ke bawah...")
noclip(true)

-- ===== TURUN BERTAHAP =====
local startY = root.Position.Y
local steps = 30

for i = 1, steps do
    local t = i / steps
    local newY = startY + (TARGET_Y - startY) * t
    root.CFrame = CFrame.new(root.Position.X, newY, root.Position.Z)
    task.wait(0.02)
end

-- ===== KUNCI POSISI Y (CEGAH NAIK) =====
notif("🔒", "Posisi terkunci di Y = " .. TARGET_Y)

-- Loop kecil buat jaga posisi
task.spawn(function()
    while true do
        task.wait(0.1)
        if root.Position.Y > TARGET_Y + 0.5 then
            root.CFrame = CFrame.new(root.Position.X, TARGET_Y, root.Position.Z)
        end
    end
end)

notif("✅", "Berhasil turun ke bawah! Coba jalan...")

-- ===== TEST JALAN DI BAWAH =====
notif("🚶", "Jalan di bawah tanah selama 5 detik...")
local startPos = root.Position
for i = 1, 50 do
    local pos = Vector3.new(
        startPos.X + i * 0.5,
        TARGET_Y,
        startPos.Z + math.sin(i * 0.1) * 0.5
    )
    root.CFrame = CFrame.new(pos)
    task.wait(0.1)
end

notif("🏁", "Test selesai!")

-- ===== NOCLIP OFF =====
noclip(false)
notif("🔒", "Noclip mati!")
