-- TAHAP 2: TURUN 1 STUD + JALAN DI BAWAH
local player = game.Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local humanoid = character:WaitForChild("Humanoid")
local root = character:WaitForChild("HumanoidRootPart")

local BAWAH_Y = -1
local target = Vector3.new(510.56, BAWAH_Y, 598.88)

local function notif(txt)
    game.StarterGui:SetCore("SendNotification", {Title = "TEST", Text = txt, Duration = 3})
end

local function noclip(state)
    for _, v in pairs(character:GetDescendants()) do
        if v:IsA("BasePart") then v.CanCollide = not state end
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

-- Turun 1 stud
local startY = root.Position.Y
for i = 1, 10 do
    local newY = startY + (BAWAH_Y - startY) * (i / 10)
    root.CFrame = CFrame.new(root.Position.X, newY, root.Position.Z)
    task.wait(0.05)
end

notif("Turun ke bawah!")

-- Jalan di bawah
humanoid.WalkSpeed = 12
humanoid:MoveTo(target)

while (root.Position - target).Magnitude > 5 do
    task.wait(0.2)
end

notif("Sampai di bawah target!")

-- Naik ke permukaan
local naikY = 3.58
for i = 1, 10 do
    local newY = root.Position.Y + (naikY - root.Position.Y) * (i / 10)
    root.CFrame = CFrame.new(root.Position.X, newY, root.Position.Z)
    task.wait(0.05)
end

noclip(false)
notif("Naik ke permukaan! Test selesai.")
