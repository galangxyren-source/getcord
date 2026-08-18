-- TAHAP 3: BELI APARTEMEN (1 KOORDINAT)
local player = game.Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local humanoid = character:WaitForChild("Humanoid")
local root = character:WaitForChild("HumanoidRootPart")

local APART_COORD = Vector3.new(927.98, 10.09, 73.01)
local BAWAH_Y = -1

local function notif(txt)
    game.StarterGui:SetCore("SendNotification", {Title = "APART", Text = txt, Duration = 3})
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

local function getPrompt(pos)
    for _, p in pairs(workspace:GetDescendants()) do
        if p:IsA("ProximityPrompt") and p.Enabled == true then
            local parent = p.Parent
            if parent and parent:IsA("BasePart") and (parent.Position - pos).Magnitude < 25 then
                local txt = p.ActionText or ""
                if txt:lower():find("purchase") or txt:lower():find("beli") then
                    return parent, p
                end
            end
        end
    end
    return nil, nil
end

notif("Cari apartemen...")
local part, prompt = getPrompt(APART_COORD)

if part and prompt then
    notif("Apart ditemukan! Beli...")
    local target = part.Position + part.CFrame.LookVector * 3 + Vector3.new(0, 2, 0)
    noclip(true)
    root.CFrame = CFrame.new(target.X, BAWAH_Y, target.Z)
    task.wait(0.2)
    for i = 1, 10 do
        local newY = BAWAH_Y + (target.Y - BAWAH_Y) * (i / 10)
        root.CFrame = CFrame.new(target.X, newY, target.Z)
        task.wait(0.03)
    end
    noclip(false)
    prompt:Hold(1.5)
    notif("Apartemen berhasil dibeli!")
else
    notif("Tidak ada apartemen kosong!")
end
