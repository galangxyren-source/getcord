-- TAHAP 1: TEST GERAK + NOCLIP
local player = game.Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local humanoid = character:WaitForChild("Humanoid")
local root = character:WaitForChild("HumanoidRootPart")

local function notif(txt)
    game.StarterGui:SetCore("SendNotification", {
        Title = "TEST",
        Text = txt,
        Duration = 3
    })
end

notif("Noclip aktif...")

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

noclip(true)
notif("Noclip ON! Jalan ke koordinat...")

local target = Vector3.new(510.56, 3.58, 598.88)
humanoid.WalkSpeed = 16
humanoid:MoveTo(target)

while (root.Position - target).Magnitude > 5 do
    task.wait(0.2)
end

notif("Sampai target!")
noclip(false)
notif("Noclip OFF. Test selesai.")
