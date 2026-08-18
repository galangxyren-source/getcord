-- TEST JALAN + INTERACT (TANPA UI)
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

notif("🔥 TEST", "Script berjalan! Mulai dalam 3 detik...")
task.wait(3)

-- ===== JALAN =====
notif("🚶", "Jalan ke NPC...")
humanoid.WalkSpeed = 20
humanoid:MoveTo(NPC_COORD)

while (root.Position - NPC_COORD).Magnitude > 4 do
    task.wait(0.2)
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
            if dist < 10 then
                notif("🖐️", "Prompt ditemukan! Hold E...")
                p:Hold(0.5)
                found = true
                break
            end
        end
    end
end

if not found then
    notif("❌", "Tidak ada prompt di sekitar!")
end

notif("🏁", "Test selesai!")
