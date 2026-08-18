-- AUTO FARM TANPA UI (GERAK ALAMI + BYPASS MINIMAL)
local player = game.Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local humanoid = character:WaitForChild("Humanoid")
local root = character:WaitForChild("HumanoidRootPart")

-- ===== KONFIGURASI =====
local COOLDOWN = 3
local NPC_COORD = Vector3.new(510.56, 3.58, 598.88)
local apartCoords = {
    Vector3.new(927.98, 10.09, 73.01),
    Vector3.new(898.88, 10.09, 73.32),
    Vector3.new(1019.57, 10.09, 218.32),
    Vector3.new(1019.48, 10.09, 246.60),
    Vector3.new(1107.78, 10.92, 423.74),
    Vector3.new(1107.68, 10.09, 452.43)
}

local isRunning = false
local jumlahPaket = 1
local siklus = 0
local pengeluaran = 0
local pendapatan = 0

-- ===== HAPUS SEMUA UI =====
for _, gui in pairs(player.PlayerGui:GetChildren()) do
    if gui:IsA("ScreenGui") then gui:Destroy() end
end

-- ===== NOTIF =====
local function notif(title, text)
    game.StarterGui:SetCore("SendNotification", {Title = title, Text = text, Duration = 4})
end

-- ===== BYPASS MINIMAL (WALKSPEED) =====
local function bypassWalkSpeed()
    local oldIndex
    oldIndex = hookmetamethod(game, "__index", function(self, key)
        if key == "WalkSpeed" and self == humanoid then
            return 16
        end
        return oldIndex(self, key)
    end)
end
task.spawn(bypassWalkSpeed)

-- ===== ANTI-AFK =====
local function antiAFK()
    local vu = game:GetService("VirtualUser")
    vu:CaptureController()
    vu:ClickButton2(Vector2.new())
    task.wait(60)
    antiAFK()
end
task.spawn(antiAFK)

-- ===== GERAK HALUS (MOVETO) =====
local function walkTo(pos)
    humanoid.WalkSpeed = 12
    humanoid:MoveTo(pos)
    while (root.Position - pos).Magnitude > 5 do
        task.wait(0.1)
    end
    humanoid.WalkSpeed = 16
end

-- ===== NOCLIP SEMENTARA (UNTUK TEMBUS) =====
local function noclipTemp()
    for _, v in pairs(character:GetDescendants()) do
        if v:IsA("BasePart") then
            v.CanCollide = false
        end
    end
    task.wait(0.2)
    for _, v in pairs(character:GetDescendants()) do
        if v:IsA("BasePart") then
            v.CanCollide = true
        end
    end
end

-- ===== CEK PROMPT =====
local function getPurchasePrompt(pos)
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

-- ===== INTERACT =====
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

-- ===== BELI APART =====
local function buyApartment()
    for _, pos in ipairs(apartCoords) do
        local part, prompt = getPurchasePrompt(pos)
        if part and prompt then
            local target = part.Position + part.CFrame.LookVector * 3 + Vector3.new(0, 2, 0)
            walkTo(target)
            noclipTemp()
            prompt:Hold(1.5)
            pengeluaran = pengeluaran + 500
            return true
        end
    end
    return false
end

-- ===== BELI BAHAN =====
local function buyMaterials(amount)
    walkTo(NPC_COORD)
    noclipTemp()
    pressE()
    clickDialog()
    clickItem("Gelatin") clickAmount(amount)
    clickItem("Sugar Block Bag") clickAmount(amount)
    clickItem("Water") clickAmount(amount)
    clickExit()
    pengeluaran = pengeluaran + amount * 190
    pendapatan = pendapatan + amount * 500
end

-- ===== MAIN LOOP =====
local function startFarm()
    if isRunning then return end
    isRunning = true
    notif("🔥", "Auto Farm dimulai!")
    while isRunning do
        siklus = siklus + 1
        buyApartment()
        task.wait(COOLDOWN)
        buyMaterials(jumlahPaket)
        task.wait(COOLDOWN)
    end
end

local function stopFarm()
    isRunning = false
    notif("⏹️", "Auto Farm dihentikan!")
end

-- ===== CHAT COMMAND =====
player.Chatted:Connect(function(msg)
    local cmd = msg:lower()
    if cmd == "!start" then
        task.spawn(startFarm)
    elseif cmd == "!stop" then
        stopFarm()
    elseif cmd:match("!set (%d+)") then
        local num = tonumber(cmd:match("!set (%d+)"))
        if num and num >= 1 and num <= 50 then
            jumlahPaket = num
            notif("📦", "Paket: " .. num)
        end
    end
end)

notif("✅", "Auto Farm siap! !start, !stop, !set 5")
