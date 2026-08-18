-- TAHAP 4: BELI BAHAN (1 PAKET)
local player = game.Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local humanoid = character:WaitForChild("Humanoid")
local root = character:WaitForChild("HumanoidRootPart")

local NPC_COORD = Vector3.new(510.56, 3.58, 598.88)
local BAWAH_Y = -1

local function notif(txt)
    game.StarterGui:SetCore("SendNotification", {Title = "BAHAN", Text = txt, Duration = 3})
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

local function pressE()
    for _, p in pairs(workspace:GetDescendants()) do
        if p:IsA("ProximityPrompt") and p.Enabled == true then
            local parent = p.Parent
            if parent and parent:IsA("BasePart") and (parent.Position - root.Position).Magnitude < 10 then
                p:Hold(0.5)
                return true
            end
        end
    end
    return false
end

local function clickDialog()
    task.wait(0.5)
    for _, gui in pairs(player.PlayerGui:GetChildren()) do
        for _, btn in pairs(gui:GetDescendants()) do
            if (btn:IsA("TextButton") or btn:IsA("ImageButton")) and (btn.Text or ""):find("You here to buy?") then
                btn:Click()
                task.wait(0.5)
                return true
            end
        end
    end
    return false
end

local function clickItem(name)
    task.wait(0.3)
    for _, gui in pairs(player.PlayerGui:GetChildren()) do
        for _, btn in pairs(gui:GetDescendants()) do
            if (btn:IsA("TextButton") or btn:IsA("ImageButton")) and (btn.Text or ""):find(name) then
                btn:Click()
                task.wait(0.3)
                return true
            end
        end
    end
    return false
end

local function clickAmount(amount)
    task.wait(0.3)
    for _, gui in pairs(player.PlayerGui:GetChildren()) do
        for _, btn in pairs(gui:GetDescendants()) do
            if (btn:IsA("TextButton") or btn:IsA("ImageButton")) and (btn.Text or ""):find(tostring(amount)) then
                btn:Click()
                task.wait(0.3)
                return true
            end
        end
    end
    return false
end

local function clickExit()
    task.wait(0.3)
    for _, gui in pairs(player.PlayerGui:GetChildren()) do
        for _, btn in pairs(gui:GetDescendants()) do
            if (btn:IsA("TextButton") or btn:IsA("ImageButton")) and (btn.Text or ""):lower():find("exit") then
                btn:Click()
                task.wait(0.3)
                return true
            end
        end
    end
    return false
end

notif("Menuju NPC...")
noclip(true)
root.CFrame = CFrame.new(NPC_COORD.X, BAWAH_Y, NPC_COORD.Z)
task.wait(0.2)
for i = 1, 10 do
    local newY = BAWAH_Y + (NPC_COORD.Y - BAWAH_Y) * (i / 10)
    root.CFrame = CFrame.new(NPC_COORD.X, newY, NPC_COORD.Z)
    task.wait(0.03)
end
noclip(false)

pressE()
clickDialog()
clickItem("Gelatin") clickAmount(1)
clickItem("Sugar Block Bag") clickAmount(1)
clickItem("Water") clickAmount(1)
clickExit()

notif("Bahan 1 paket selesai dibeli!")
