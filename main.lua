-- AUTO FARM + BYPASS SUPER (Tahan Anti-Cheat)
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
local startTime = 0

-- ===== HAPUS GUI LAMA =====
for _, gui in pairs(player.PlayerGui:GetChildren()) do
    if gui:IsA("ScreenGui") then gui:Destroy() end
end

-- ===== NOTIF =====
local function notif(title, text)
    game.StarterGui:SetCore("SendNotification", {Title = title, Text = text, Duration = 4})
end

-- ===== BYPASS SUPER =====
local function bypassSuper()
    -- Bypass deteksi CFrame & WalkSpeed
    local oldIndex
    oldIndex = hookmetamethod(game, "__index", function(self, key)
        if key == "WalkSpeed" and self == humanoid then
            return 16
        end
        return oldIndex(self, key)
    end)
    
    -- Bypass deteksi Health (biar mati ga dicurigai)
    local oldHealth
    oldHealth = hookmetamethod(humanoid, "__newindex", function(self, key, value)
        if key == "Health" and value == 0 then
            return
        end
        return oldHealth(self, key, value)
    end)
    
    -- Bypass RemoteEvent (spam sinyal normal)
    local rs = game:GetService("ReplicatedStorage")
    for _, v in pairs(rs:GetDescendants()) do
        if v:IsA("RemoteEvent") then
            local oldFire
            oldFire = hookmetamethod(v, "FireServer", function(self, ...)
                return oldFire(self, ...)
            end)
        end
    end
end
task.spawn(bypassSuper)

-- ===== ANTI-AFK =====
local function antiAFK()
    local vu = game:GetService("VirtualUser")
    vu:CaptureController()
    vu:ClickButton2(Vector2.new())
    task.wait(60)
    antiAFK()
end
task.spawn(antiAFK)

-- ===== RESPAWN HALUS (TANPA MATI PAKSA) =====
local function smoothRespawn(targetPos)
    -- Mati alami (dengan delay acak biar ga ketahuan)
    local delayTime = math.random(3, 7)
    task.wait(delayTime)
    
    humanoid.Health = 0
    
    -- Tunggu respawn alami
    local newChar = player.CharacterAdded:Wait()
    character = newChar
    humanoid = character:WaitForChild("Humanoid")
    root = character:WaitForChild("HumanoidRootPart")
    
    -- Pindah ke target setelah respawn (dengan delay kecil)
    task.wait(0.5)
    root.CFrame = CFrame.new(targetPos)
    
    -- Noclip sementara
    for _, v in pairs(character:GetDescendants()) do
        if v:IsA("BasePart") then
            v.CanCollide = false
        end
    end
    task.wait(0.3)
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
            smoothRespawn(target)
            prompt:Hold(1.5)
            pengeluaran = pengeluaran + 500
            return true
        end
    end
    return false
end

-- ===== BELI BAHAN =====
local function buyMaterials(amount)
    smoothRespawn(NPC_COORD)
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
    startTime = os.time()
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

-- ===== UI SIMPLE =====
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "AF"
screenGui.Parent = player.PlayerGui

local frame = Instance.new("Frame")
frame.Size = UDim2.new(0, 200, 0, 120)
frame.Position = UDim2.new(0.5, -100, 0.5, -60)
frame.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
frame.BackgroundTransparency = 0.3
frame.BorderSizePixel = 0
frame.Active = true
frame.Draggable = true
frame.Parent = screenGui

local title = Instance.new("TextLabel")
title.Size = UDim2.new(0, 180, 0, 25)
title.Position = UDim2.new(0.5, -90, 0, 5)
title.BackgroundTransparency = 1
title.Text = "🔥 AUTO FARM"
title.TextColor3 = Color3.fromRGB(255, 200, 50)
title.TextSize = 18
title.Font = Enum.Font.GothamBold
title.Parent = frame

local paketLabel = Instance.new("TextLabel")
paketLabel.Size = UDim2.new(0, 180, 0, 18)
paketLabel.Position = UDim2.new(0.5, -90, 0, 32)
paketLabel.BackgroundTransparency = 1
paketLabel.Text = "PAKET: 1"
paketLabel.TextColor3 = Color3.fromRGB(200, 200, 255)
paketLabel.TextSize = 13
paketLabel.Font = Enum.Font.Gotham
paketLabel.Parent = frame

local btnStart = Instance.new("TextButton")
btnStart.Size = UDim2.new(0, 120, 0, 30)
btnStart.Position = UDim2.new(0.5, -60, 0, 55)
btnStart.BackgroundColor3 = Color3.fromRGB(0, 200, 80)
btnStart.Text = "▶ START"
btnStart.TextColor3 = Color3.fromRGB(255,255,255)
btnStart.TextSize = 14
btnStart.Font = Enum.Font.GothamBold
btnStart.BorderSizePixel = 0
btnStart.Parent = frame

local runtimeLabel = Instance.new("TextLabel")
runtimeLabel.Size = UDim2.new(0, 180, 0, 15)
runtimeLabel.Position = UDim2.new(0.5, -90, 0, 92)
runtimeLabel.BackgroundTransparency = 1
runtimeLabel.Text = "⏱️ 0m"
runtimeLabel.TextColor3 = Color3.fromRGB(150, 150, 200)
runtimeLabel.TextSize = 11
runtimeLabel.Font = Enum.Font.Gotham
runtimeLabel.Parent = frame

-- ===== UI LOGIC =====
btnStart.MouseButton1Click:Connect(function()
    if isRunning then
        stopFarm()
        btnStart.Text = "▶ START"
        btnStart.BackgroundColor3 = Color3.fromRGB(0, 200, 80)
        return
    end
    btnStart.Text = "⏳ PROSES"
    btnStart.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
    task.spawn(function()
        local ok, err = pcall(startFarm)
        if not ok then notif("❌", "Error: " .. tostring(err)) end
        if not isRunning then
            btnStart.Text = "▶ START"
            btnStart.BackgroundColor3 = Color3.fromRGB(0, 200, 80)
        end
    end)
end)

-- ===== UPDATE RUNTIME =====
task.spawn(function()
    while true do
        if isRunning then
            local runtime = os.time() - startTime
            local m = math.floor(runtime / 60)
            local s = runtime % 60
            runtimeLabel.Text = string.format("⏱️ %dm %02ds", m, s)
        end
        task.wait(1)
    end
end)

-- ===== TOGGLE UI =====
game:GetService("UserInputService").InputBegan:Connect(function(input, p)
    if p then return end
    if input.KeyCode == Enum.KeyCode.Z then
        screenGui.Enabled = not screenGui.Enabled
    end
end)

notif("✅", "Bypass Super aktif! Tekan Z untuk toggle UI.")
