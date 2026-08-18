-- AUTO FARM VIA RESPAWN (AMAN DARI ANTI-CHEAT)
local player = game.Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local humanoid = character:WaitForChild("Humanoid")
local root = character:WaitForChild("HumanoidRootPart")

-- ===== KONFIGURASI =====
local COOLDOWN = 2
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
    game.StarterGui:SetCore("SendNotification", {
        Title = title,
        Text = text,
        Duration = 4
    })
end

-- ===== ANTI-AFK =====
local function antiAFK()
    local vu = game:GetService("VirtualUser")
    vu:CaptureController()
    vu:ClickButton2(Vector2.new())
    task.wait(60)
    antiAFK()
end
task.spawn(antiAFK)

-- ===== BYPASS =====
local function bypass()
    local oldIndex
    oldIndex = hookmetamethod(game, "__index", function(self, key)
        if key == "WalkSpeed" and self == humanoid then
            return 16
        end
        return oldIndex(self, key)
    end)
end
task.spawn(bypass)

-- ===== TELEPORT VIA RESPAWN =====
local function teleportViaDeath(targetPos)
    -- Matikan karakter
    humanoid.Health = 0
    
    -- Tunggu respawn
    local newChar = player.CharacterAdded:Wait()
    character = newChar
    humanoid = character:WaitForChild("Humanoid")
    root = character:WaitForChild("HumanoidRootPart")
    
    -- Set posisi spawn ke target
    root.CFrame = CFrame.new(targetPos)
    
    -- Noclip sementara biar ga nyangkut
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

-- ===== CEK PROMPT PURCHASE =====
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

-- ===== INTERACT E =====
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

-- ===== KLIK DIALOG =====
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

-- ===== KLIK BELI ITEM =====
local function clickBuyItem(name)
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

-- ===== KLIK JUMLAH =====
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

-- ===== KLIK EXIT =====
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

-- ===== BELI APARTEMEN =====
local function buyApartment()
    for _, pos in ipairs(apartCoords) do
        local part, prompt = getPurchasePrompt(pos)
        if part and prompt then
            local targetPos = part.Position + part.CFrame.LookVector * 3 + Vector3.new(0, 2, 0)
            teleportViaDeath(targetPos)
            prompt:Hold(1.5)
            pengeluaran = pengeluaran + 500
            return true
        end
    end
    return false
end

-- ===== BELI BAHAN =====
local function buyMaterials(amount)
    teleportViaDeath(NPC_COORD)
    pressE()
    clickDialog()
    clickBuyItem("Gelatin") clickAmount(amount)
    clickBuyItem("Sugar Block Bag") clickAmount(amount)
    clickBuyItem("Water") clickAmount(amount)
    clickExit()
    pengeluaran = pengeluaran + amount * 190
    pendapatan = pendapatan + amount * 500
end

-- ===== MAIN LOOP =====
local function startFarm()
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

-- ===== UI SIMPEL =====
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "AutoFarm"
screenGui.Parent = player.PlayerGui

local frame = Instance.new("Frame")
frame.Size = UDim2.new(0, 280, 0, 180)
frame.Position = UDim2.new(0.5, -140, 0.5, -90)
frame.BackgroundColor3 = Color3.fromRGB(15, 15, 35)
frame.BackgroundTransparency = 0.2
frame.BorderSizePixel = 0
frame.Active = true
frame.Draggable = true
frame.Parent = screenGui
Instance.new("UICorner").CornerRadius = UDim.new(0, 12); frame.Parent = frame

local title = Instance.new("TextLabel")
title.Size = UDim2.new(0, 260, 0, 30)
title.Position = UDim2.new(0.5, -130, 0, 5)
title.BackgroundTransparency = 1
title.Text = "🔥 AUTO FARM"
title.TextColor3 = Color3.fromRGB(255, 200, 50)
title.TextSize = 22
title.Font = Enum.Font.GothamBold
title.Parent = frame

local paketLabel = Instance.new("TextLabel")
paketLabel.Size = UDim2.new(0, 200, 0, 20)
paketLabel.Position = UDim2.new(0.5, -100, 0, 40)
paketLabel.BackgroundTransparency = 1
paketLabel.Text = "📦 PAKET: 1"
paketLabel.TextColor3 = Color3.fromRGB(220, 220, 255)
paketLabel.TextSize = 14
paketLabel.Font = Enum.Font.GothamBold
paketLabel.Parent = frame

local minus = Instance.new("TextButton")
minus.Size = UDim2.new(0, 35, 0, 30)
minus.Position = UDim2.new(0.5, -55, 0, 65)
minus.BackgroundColor3 = Color3.fromRGB(40, 40, 70)
minus.Text = "−"
minus.TextColor3 = Color3.fromRGB(255,255,255)
minus.TextSize = 20
minus.Font = Enum.Font.GothamBold
minus.BorderSizePixel = 0
minus.Parent = frame
Instance.new("UICorner").CornerRadius = UDim.new(0, 6); minus.Parent = frame

local angka = Instance.new("TextLabel")
angka.Size = UDim2.new(0, 40, 0, 30)
angka.Position = UDim2.new(0.5, -20, 0, 65)
angka.BackgroundColor3 = Color3.fromRGB(25, 25, 50)
angka.Text = "1"
angka.TextColor3 = Color3.fromRGB(255,255,255)
angka.TextSize = 18
angka.Font = Enum.Font.GothamBold
angka.Parent = frame
Instance.new("UICorner").CornerRadius = UDim.new(0, 6); angka.Parent = frame

local plus = Instance.new("TextButton")
plus.Size = UDim2.new(0, 35, 0, 30)
plus.Position = UDim2.new(0.5, 20, 0, 65)
plus.BackgroundColor3 = Color3.fromRGB(40, 40, 70)
plus.Text = "+"
plus.TextColor3 = Color3.fromRGB(255,255,255)
plus.TextSize = 20
plus.Font = Enum.Font.GothamBold
plus.BorderSizePixel = 0
plus.Parent = frame
Instance.new("UICorner").CornerRadius = UDim.new(0, 6); plus.Parent = frame

local startBtn = Instance.new("TextButton")
startBtn.Size = UDim2.new(0, 200, 0, 35)
startBtn.Position = UDim2.new(0.5, -100, 0, 110)
startBtn.BackgroundColor3 = Color3.fromRGB(0, 200, 80)
startBtn.Text = "▶ START"
startBtn.TextColor3 = Color3.fromRGB(255,255,255)
startBtn.TextSize = 16
startBtn.Font = Enum.Font.GothamBold
startBtn.BorderSizePixel = 0
startBtn.Parent = frame
Instance.new("UICorner").CornerRadius = UDim.new(0, 8); startBtn.Parent = frame

local runtimeLabel = Instance.new("TextLabel")
runtimeLabel.Size = UDim2.new(0, 260, 0, 18)
runtimeLabel.Position = UDim2.new(0.5, -130, 0, 155)
runtimeLabel.BackgroundTransparency = 1
runtimeLabel.Text = "⏱️ 0 m 00 s"
runtimeLabel.TextColor3 = Color3.fromRGB(180, 180, 210)
runtimeLabel.TextSize = 12
runtimeLabel.Font = Enum.Font.Gotham
runtimeLabel.Parent = frame

-- ===== UI LOGIC =====
minus.MouseButton1Click:Connect(function()
    if isRunning then return end
    local v = tonumber(angka.Text) or 1
    if v > 1 then v = v - 1; angka.Text = tostring(v); paketLabel.Text = "📦 PAKET: " .. v; jumlahPaket = v end
end)

plus.MouseButton1Click:Connect(function()
    if isRunning then return end
    local v = tonumber(angka.Text) or 1
    if v < 50 then v = v + 1; angka.Text = tostring(v); paketLabel.Text = "📦 PAKET: " .. v; jumlahPaket = v end
end)

startBtn.MouseButton1Click:Connect(function()
    if isRunning then
        isRunning = false
        startBtn.Text = "▶ START"
        startBtn.BackgroundColor3 = Color3.fromRGB(0, 200, 80)
        notif("⏹️", "Auto Farm dihentikan!")
        return
    end
    startBtn.Text = "⏳ PROSES..."
    startBtn.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
    task.spawn(function()
        local ok, err = pcall(startFarm)
        if not ok then notif("❌", "Error: " .. tostring(err)) end
        if not isRunning then
            startBtn.Text = "▶ START"
            startBtn.BackgroundColor3 = Color3.fromRGB(0, 200, 80)
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
            runtimeLabel.Text = string.format("⏱️ %d m %02d s", m, s)
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

notif("✅", "Auto Farm + Respawn Teleport siap!")
