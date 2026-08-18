-- AUTO FARM FULL - BELI APART + BAHAN + JALAN 60 DETIK
local player = game.Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local humanoid = character:WaitForChild("Humanoid")
local root = character:WaitForChild("HumanoidRootPart")

-- ===== KONFIGURASI =====
local COOLDOWN = 2
local NPC_COORD = Vector3.new(510.56, 3.58, 598.88)
local BAWAH_Y = -1  -- turun 1 stud

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
    else
        humanoid:SetStateEnabled(Enum.HumanoidStateType.Climbing, true)
        humanoid:SetStateEnabled(Enum.HumanoidStateType.FallingDown, true)
        humanoid.PlatformStand = false
    end
end

-- ===== TURUN 1 STUD =====
local function goDown()
    local targetY = BAWAH_Y
    for i = 1, 10 do
        local t = i / 10
        local newY = root.Position.Y + (targetY - root.Position.Y) * t
        root.CFrame = CFrame.new(root.Position.X, newY, root.Position.Z)
        task.wait(0.03)
    end
end

-- ===== NAIK KE PERMUKAAN =====
local function goUp(targetPos)
    local startY = root.Position.Y
    local targetY = targetPos.Y + 2
    for i = 1, 10 do
        local t = i / 10
        local newY = startY + (targetY - startY) * t
        root.CFrame = CFrame.new(root.Position.X, newY, root.Position.Z)
        task.wait(0.03)
    end
end

-- ===== JALAN PAKAI MOVETO (60 DETIK) =====
local function walkSlow(pos)
    humanoid.WalkSpeed = 10
    humanoid:MoveTo(pos)
    local startTime = os.time()
    while (root.Position - pos).Magnitude > 4 and os.time() - startTime < 70 do
        task.wait(0.1)
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
    noclip(true)
    goDown()
    
    for _, pos in ipairs(apartCoords) do
        local part, prompt = getPurchasePrompt(pos)
        if part and prompt then
            local target = part.Position + part.CFrame.LookVector * 3 + Vector3.new(0, 2, 0)
            walkSlow(Vector3.new(target.X, BAWAH_Y, target.Z))
            goUp(target)
            noclip(false)
            prompt:Hold(1.5)
            pengeluaran = pengeluaran + 500
            return true
        end
    end
    
    noclip(false)
    return false
end

-- ===== BELI BAHAN =====
local function buyMaterials(amount)
    noclip(true)
    goDown()
    walkSlow(Vector3.new(NPC_COORD.X, BAWAH_Y, NPC_COORD.Z))
    goUp(NPC_COORD)
    noclip(false)
    
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
    notif("🔥", "Auto Farm dimulai!")
    
    while isRunning do
        siklus = siklus + 1
        buyApartment()
        task.wait(COOLDOWN)
        buyMaterials(jumlahPaket)
        task.wait(COOLDOWN)
    end
end

-- ===== UI MODERN =====
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "AutoFarm"
screenGui.Parent = player.PlayerGui

local frame = Instance.new("Frame")
frame.Size = UDim2.new(0, 320, 0, 240)
frame.Position = UDim2.new(0.5, -160, 0.5, -120)
frame.BackgroundColor3 = Color3.fromRGB(10, 10, 30)
frame.BackgroundTransparency = 0.1
frame.Active = true
frame.Draggable = true
frame.Parent = screenGui
Instance.new("UICorner").CornerRadius = UDim.new(0, 16); frame.Parent = frame

-- ===== JUDUL =====
local title = Instance.new("TextLabel")
title.Size = UDim2.new(0, 300, 0, 35)
title.Position = UDim2.new(0.5, -150, 0, 5)
title.BackgroundTransparency = 1
title.Text = "🔥 AUTO FARM"
title.TextColor3 = Color3.fromRGB(255, 200, 50)
title.TextSize = 24
title.Font = Enum.Font.GothamBold
title.Parent = frame

-- ===== SLIDER =====
local sliderLabel = Instance.new("TextLabel")
sliderLabel.Size = UDim2.new(0, 200, 0, 20)
sliderLabel.Position = UDim2.new(0.5, -100, 0, 48)
sliderLabel.BackgroundTransparency = 1
sliderLabel.Text = "📦 PAKET (1-50)"
sliderLabel.TextColor3 = Color3.fromRGB(200, 200, 230)
sliderLabel.TextSize = 14
sliderLabel.Font = Enum.Font.GothamBold
sliderLabel.Parent = frame

local minus = Instance.new("TextButton")
minus.Size = UDim2.new(0, 40, 0, 36)
minus.Position = UDim2.new(0.5, -65, 0, 72)
minus.BackgroundColor3 = Color3.fromRGB(30, 30, 60)
minus.Text = "−"
minus.TextColor3 = Color3.fromRGB(255,255,255)
minus.TextSize = 24
minus.Font = Enum.Font.GothamBold
minus.BorderSizePixel = 0
minus.Parent = frame
Instance.new("UICorner").CornerRadius = UDim.new(0, 8); minus.Parent = frame

local angka = Instance.new("TextLabel")
angka.Size = UDim2.new(0, 60, 0, 36)
angka.Position = UDim2.new(0.5, -30, 0, 72)
angka.BackgroundColor3 = Color3.fromRGB(20, 20, 45)
angka.Text = "1"
angka.TextColor3 = Color3.fromRGB(255,255,255)
angka.TextSize = 22
angka.Font = Enum.Font.GothamBold
angka.Parent = frame
Instance.new("UICorner").CornerRadius = UDim.new(0, 8); angka.Parent = frame

local plus = Instance.new("TextButton")
plus.Size = UDim2.new(0, 40, 0, 36)
plus.Position = UDim2.new(0.5, 25, 0, 72)
plus.BackgroundColor3 = Color3.fromRGB(30, 30, 60)
plus.Text = "+"
plus.TextColor3 = Color3.fromRGB(255,255,255)
plus.TextSize = 24
plus.Font = Enum.Font.GothamBold
plus.BorderSizePixel = 0
plus.Parent = frame
Instance.new("UICorner").CornerRadius = UDim.new(0, 8); plus.Parent = frame

-- ===== TOMBOL START =====
local startBtn = Instance.new("TextButton")
startBtn.Size = UDim2.new(0, 220, 0, 42)
startBtn.Position = UDim2.new(0.5, -110, 0, 125)
startBtn.BackgroundColor3 = Color3.fromRGB(0, 200, 80)
startBtn.Text = "▶ START"
startBtn.TextColor3 = Color3.fromRGB(255,255,255)
startBtn.TextSize = 18
startBtn.Font = Enum.Font.GothamBold
startBtn.BorderSizePixel = 0
startBtn.Parent = frame
Instance.new("UICorner").CornerRadius = UDim.new(0, 10); startBtn.Parent = frame

-- ===== RUNTIME =====
local runtimeLabel = Instance.new("TextLabel")
runtimeLabel.Size = UDim2.new(0, 300, 0, 20)
runtimeLabel.Position = UDim2.new(0.5, -150, 0, 178)
runtimeLabel.BackgroundTransparency = 1
runtimeLabel.Text = "⏱️ 0 m 00 s"
runtimeLabel.TextColor3 = Color3.fromRGB(180, 180, 210)
runtimeLabel.TextSize = 14
runtimeLabel.Font = Enum.Font.Gotham
runtimeLabel.Parent = frame

local pengeluaranLabel = Instance.new("TextLabel")
pengeluaranLabel.Size = UDim2.new(0, 140, 0, 20)
pengeluaranLabel.Position = UDim2.new(0.08, 0, 0, 205)
pengeluaranLabel.BackgroundTransparency = 1
pengeluaranLabel.Text = "💸 $0"
pengeluaranLabel.TextColor3 = Color3.fromRGB(255, 100, 100)
pengeluaranLabel.TextSize = 14
pengeluaranLabel.Font = Enum.Font.Gotham
pengeluaranLabel.Parent = frame

local pendapatanLabel = Instance.new("TextLabel")
pendapatanLabel.Size = UDim2.new(0, 140, 0, 20)
pendapatanLabel.Position = UDim2.new(0.55, 0, 0, 205)
pendapatanLabel.BackgroundTransparency = 1
pendapatanLabel.Text = "💰 $0"
pendapatanLabel.TextColor3 = Color3.fromRGB(100, 255, 100)
pendapatanLabel.TextSize = 14
pendapatanLabel.Font = Enum.Font.Gotham
pendapatanLabel.Parent = frame

-- ===== UI LOGIC =====
minus.MouseButton1Click:Connect(function()
    if isRunning then return end
    local v = tonumber(angka.Text) or 1
    if v > 1 then v = v - 1; angka.Text = tostring(v); jumlahPaket = v end
end)

plus.MouseButton1Click:Connect(function()
    if isRunning then return end
    local v = tonumber(angka.Text) or 1
    if v < 50 then v = v + 1; angka.Text = tostring(v); jumlahPaket = v end
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
    local startTime = os.time()
    while true do
        if isRunning then
            local runtime = os.time() - startTime
            local m = math.floor(runtime / 60)
            local s = runtime % 60
            runtimeLabel.Text = string.format("⏱️ %d m %02d s", m, s)
        end
        pengeluaranLabel.Text = "💸 $" .. pengeluaran
        pendapatanLabel.Text = "💰 $" .. pendapatan
        task.wait(0.5)
    end
end)

-- ===== TOGGLE UI =====
game:GetService("UserInputService").InputBegan:Connect(function(input, p)
    if p then return end
    if input.KeyCode == Enum.KeyCode.Z then
        screenGui.Enabled = not screenGui.Enabled
    end
end)

notif("✅", "Auto Farm FULL siap! Tekan Z untuk toggle UI.")
