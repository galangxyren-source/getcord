-- AUTO FARM UI V2 - BAGUS + FIX START
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
local runtime = 0
local pengeluaran = 0
local pendapatan = 0
local startTime = os.time()
local timerRunning = false

-- ===== FUNGSI JALAN =====
local function walkTo(pos)
    humanoid.WalkSpeed = 20
    humanoid:MoveTo(pos)
    while (root.Position - pos).Magnitude > 3 do
        task.wait(0.1)
    end
    humanoid.WalkSpeed = 16
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
        workspace.Gravity = 0
    else
        humanoid:SetStateEnabled(Enum.HumanoidStateType.Climbing, true)
        humanoid:SetStateEnabled(Enum.HumanoidStateType.FallingDown, true)
        humanoid.PlatformStand = false
        workspace.Gravity = 196.2
    end
end

-- ===== TURUN KE BAWAH =====
local function goDown(targetPos)
    local below = Vector3.new(root.Position.X, targetPos.Y - 1.5, root.Position.Z)
    root.CFrame = CFrame.new(below)
    task.wait(0.1)
end

-- ===== NAIK KE PERMUKAAN =====
local function goUp(targetPos)
    local startY = root.Position.Y
    local targetY = targetPos.Y + 2
    for i = 1, 15 do
        local t = i / 15
        root.CFrame = CFrame.new(root.Position.X, startY + (targetY - startY) * t, root.Position.Z)
        task.wait(0.03)
    end
end

-- ===== CEK PROMPT PURCHASE =====
local function getPurchasePrompt(pos)
    for _, p in pairs(workspace:GetDescendants()) do
        if p:IsA("ProximityPrompt") then
            local parent = p.Parent
            if parent and parent:IsA("BasePart") then
                if (parent.Position - pos).Magnitude < 25 then
                    local txt = p.ActionText or ""
                    if (txt:lower():find("purchase") or txt:lower():find("beli")) and p.Enabled == true then
                        return parent, p
                    end
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
            if parent and parent:IsA("BasePart") then
                if (parent.Position - root.Position).Magnitude < 10 then
                    p:Hold(0.5)
                    return true
                end
            end
        end
    end
    return false
end

-- ===== KLIK DIALOG =====
local function clickDialog()
    task.wait(0.5)
    for _, gui in pairs(player.PlayerGui:GetChildren()) do
        if gui:IsA("ScreenGui") then
            for _, btn in pairs(gui:GetDescendants()) do
                if btn:IsA("TextButton") or btn:IsA("ImageButton") then
                    local txt = btn.Text or ""
                    if txt:find("You here to buy?") then
                        btn:Click()
                        task.wait(0.5)
                        return true
                    end
                end
            end
        end
    end
    return false
end

-- ===== KLIK BELI ITEM =====
local function clickBuyItem(itemName)
    task.wait(0.3)
    for _, gui in pairs(player.PlayerGui:GetChildren()) do
        if gui:IsA("ScreenGui") then
            for _, btn in pairs(gui:GetDescendants()) do
                if btn:IsA("TextButton") or btn:IsA("ImageButton") then
                    local txt = btn.Text or ""
                    if txt:find(itemName) then
                        btn:Click()
                        task.wait(0.3)
                        return true
                    end
                end
            end
        end
    end
    return false
end

-- ===== KLIK JUMLAH =====
local function clickBuyAmount(amount)
    task.wait(0.3)
    for _, gui in pairs(player.PlayerGui:GetChildren()) do
        if gui:IsA("ScreenGui") then
            for _, btn in pairs(gui:GetDescendants()) do
                if btn:IsA("TextButton") or btn:IsA("ImageButton") then
                    local txt = btn.Text or ""
                    if txt:find(tostring(amount)) then
                        btn:Click()
                        task.wait(0.3)
                        return true
                    end
                end
            end
        end
    end
    return false
end

-- ===== KLIK EXIT =====
local function clickExit()
    task.wait(0.3)
    for _, gui in pairs(player.PlayerGui:GetChildren()) do
        if gui:IsA("ScreenGui") then
            for _, btn in pairs(gui:GetDescendants()) do
                if btn:IsA("TextButton") or btn:IsA("ImageButton") then
                    local txt = btn.Text or ""
                    if txt:lower():find("exit") or txt:lower():find("close") then
                        btn:Click()
                        task.wait(0.3)
                        return true
                    end
                end
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
            local targetPos = part.Position + (part.CFrame.LookVector * 3) + Vector3.new(0, 2, 0)
            noclip(true)
            goDown(targetPos)
            task.wait(0.2)
            local bawahTarget = Vector3.new(targetPos.X, targetPos.Y - 1.5, targetPos.Z)
            walkTo(bawahTarget)
            task.wait(0.2)
            goUp(targetPos)
            task.wait(0.2)
            noclip(false)
            prompt:Hold(1.5)
            task.wait(0.3)
            pengeluaran = pengeluaran + 500
            print("✅ Apartemen dibeli di koordinat:", pos)
            return true
        end
    end
    print("⚠️ Tidak ada apartemen kosong!")
    return false
end

-- ===== BELI BAHAN =====
local function buyMaterials(amount)
    print("🔄 Menuju NPC bahan...")
    walkTo(NPC_COORD)
    task.wait(0.3)
    pressE()
    task.wait(0.5)
    clickDialog()
    task.wait(0.5)
    
    clickBuyItem("Gelatin")
    task.wait(0.3)
    clickBuyAmount(amount)
    task.wait(0.3)
    
    clickBuyItem("Sugar Block Bag")
    task.wait(0.3)
    clickBuyAmount(amount)
    task.wait(0.3)
    
    clickBuyItem("Water")
    task.wait(0.3)
    clickBuyAmount(amount)
    task.wait(0.3)
    
    clickExit()
    task.wait(0.3)
    
    local biaya = amount * 190
    pengeluaran = pengeluaran + biaya
    pendapatan = pendapatan + (amount * 500)
    print("✅ Bahan dibeli:", amount, "paket")
end

-- ===== MAIN LOOP =====
local function startFarm()
    print("🔥 AUTO FARM DIMULAI!")
    isRunning = true
    timerRunning = true
    startTime = os.time()
    
    while isRunning do
        siklus = siklus + 1
        print("🔄 Siklus ke-" .. siklus)
        
        local aptSuccess = buyApartment()
        task.wait(COOLDOWN)
        
        buyMaterials(jumlahPaket)
        task.wait(COOLDOWN)
    end
    
    print("⏹️ AUTO FARM DIHENTIKAN")
end

-- ===== UPDATE UI RUNTIME =====
local function updateRuntime()
    while true do
        if timerRunning then
            runtime = os.time() - startTime
            local mins = math.floor(runtime / 60)
            local secs = runtime % 60
            runtimeLabel.Text = string.format("⏱️ Runtime: %d m %02d s", mins, secs)
        end
        task.wait(1)
    end
end

-- ===== UI =====
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "AutoFarmUI"
screenGui.Parent = player.PlayerGui

local frame = Instance.new("Frame")
frame.Size = UDim2.new(0, 320, 0, 240)
frame.Position = UDim2.new(0.5, -160, 0.5, -120)
frame.BackgroundColor3 = Color3.fromRGB(10, 10, 25)
frame.BackgroundTransparency = 0.05
frame.BorderSizePixel = 0
frame.Active = true
frame.Draggable = true
frame.Parent = screenGui

local frameCorner = Instance.new("UICorner")
frameCorner.CornerRadius = UDim.new(0, 16)
frameCorner.Parent = frame

-- GLOW EFFECT (shadow)
local shadow = Instance.new("ImageLabel")
shadow.Size = UDim2.new(1, 20, 1, 20)
shadow.Position = UDim2.new(0, -10, 0, -10)
shadow.Image = "rbxassetid://1316045714"
shadow.ImageTransparency = 0.7
shadow.ZIndex = 0
shadow.Parent = frame

-- ===== JUDUL =====
local title = Instance.new("TextLabel")
title.Size = UDim2.new(0, 300, 0, 35)
title.Position = UDim2.new(0.5, -150, 0, 5)
title.BackgroundTransparency = 1
title.Text = "🔥 AUTO FARM"
title.TextColor3 = Color3.fromRGB(255, 200, 50)
title.TextSize = 24
title.Font = Enum.Font.GothamBold
title.TextStrokeTransparency = 0.5
title.Parent = frame

-- ===== JUMLAH PAKET =====
local jumlahLabel = Instance.new("TextLabel")
jumlahLabel.Size = UDim2.new(0, 200, 0, 20)
jumlahLabel.Position = UDim2.new(0.5, -100, 0, 48)
jumlahLabel.BackgroundTransparency = 1
jumlahLabel.Text = "📦 JUMLAH PAKET (1 - 50)"
jumlahLabel.TextColor3 = Color3.fromRGB(200, 200, 220)
jumlahLabel.TextSize = 13
jumlahLabel.Font = Enum.Font.GothamBold
jumlahLabel.Parent = frame

-- ===== TOMBOL - =====
local minusBtn = Instance.new("TextButton")
minusBtn.Size = UDim2.new(0, 40, 0, 36)
minusBtn.Position = UDim2.new(0.5, -65, 0, 72)
minusBtn.BackgroundColor3 = Color3.fromRGB(30, 30, 55)
minusBtn.Text = "−"
minusBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
minusBtn.TextSize = 24
minusBtn.Font = Enum.Font.GothamBold
minusBtn.BorderSizePixel = 0
minusBtn.Parent = frame

local minusCorner = Instance.new("UICorner")
minusCorner.CornerRadius = UDim.new(0, 8)
minusCorner.Parent = minusBtn

minusBtn.MouseButton1Click:Connect(function()
    if isRunning then return end
    local val = tonumber(angkaLabel.Text) or 1
    if val > 1 then
        val = val - 1
        angkaLabel.Text = tostring(val)
        jumlahPaket = val
    end
end)

-- ===== ANGKA JUMLAH =====
local angkaLabel = Instance.new("TextLabel")
angkaLabel.Size = UDim2.new(0, 60, 0, 36)
angkaLabel.Position = UDim2.new(0.5, -30, 0, 72)
angkaLabel.BackgroundColor3 = Color3.fromRGB(20, 20, 40)
angkaLabel.Text = "1"
angkaLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
angkaLabel.TextSize = 22
angkaLabel.Font = Enum.Font.GothamBold
angkaLabel.Parent = frame

local angkaCorner = Instance.new("UICorner")
angkaCorner.CornerRadius = UDim.new(0, 8)
angkaCorner.Parent = angkaLabel

-- ===== TOMBOL + =====
local plusBtn = Instance.new("TextButton")
plusBtn.Size = UDim2.new(0, 40, 0, 36)
plusBtn.Position = UDim2.new(0.5, 25, 0, 72)
plusBtn.BackgroundColor3 = Color3.fromRGB(30, 30, 55)
plusBtn.Text = "+"
plusBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
plusBtn.TextSize = 24
plusBtn.Font = Enum.Font.GothamBold
plusBtn.BorderSizePixel = 0
plusBtn.Parent = frame

local plusCorner = Instance.new("UICorner")
plusCorner.CornerRadius = UDim.new(0, 8)
plusCorner.Parent = plusBtn

plusBtn.MouseButton1Click:Connect(function()
    if isRunning then return end
    local val = tonumber(angkaLabel.Text) or 1
    if val < 50 then
        val = val + 1
        angkaLabel.Text = tostring(val)
        jumlahPaket = val
    end
end)

-- ===== TOMBOL START / PROSES =====
local actionBtn = Instance.new("TextButton")
actionBtn.Size = UDim2.new(0, 220, 0, 42)
actionBtn.Position = UDim2.new(0.5, -110, 0, 125)
actionBtn.BackgroundColor3 = Color3.fromRGB(0, 200, 80)
actionBtn.Text = "▶ START"
actionBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
actionBtn.TextSize = 18
actionBtn.Font = Enum.Font.GothamBold
actionBtn.BorderSizePixel = 0
actionBtn.Parent = frame

local actionCorner = Instance.new("UICorner")
actionCorner.CornerRadius = UDim.new(0, 10)
actionCorner.Parent = actionBtn

-- Hover + click animasi
actionBtn.MouseEnter:Connect(function()
    if not isRunning then
        actionBtn.BackgroundColor3 = Color3.fromRGB(0, 220, 100)
    end
end)
actionBtn.MouseLeave:Connect(function()
    if not isRunning then
        actionBtn.BackgroundColor3 = Color3.fromRGB(0, 200, 80)
    end
end)

-- ===== RUNTIME =====
local runtimeLabel = Instance.new("TextLabel")
runtimeLabel.Size = UDim2.new(0, 300, 0, 20)
runtimeLabel.Position = UDim2.new(0.5, -150, 0, 178)
runtimeLabel.BackgroundTransparency = 1
runtimeLabel.Text = "⏱️ Runtime: 0 m 00 s"
runtimeLabel.TextColor3 = Color3.fromRGB(180, 180, 210)
runtimeLabel.TextSize = 13
runtimeLabel.Font = Enum.Font.Gotham
runtimeLabel.Parent = frame

-- ===== PENGELUARAN =====
local pengeluaranLabel = Instance.new("TextLabel")
pengeluaranLabel.Size = UDim2.new(0, 140, 0, 20)
pengeluaranLabel.Position = UDim2.new(0.08, 0, 0, 205)
pengeluaranLabel.BackgroundTransparency = 1
pengeluaranLabel.Text = "💸 Pengeluaran: $0"
pengeluaranLabel.TextColor3 = Color3.fromRGB(255, 100, 100)
pengeluaranLabel.TextSize = 13
pengeluaranLabel.Font = Enum.Font.Gotham
pengeluaranLabel.Parent = frame

-- ===== PENDAPATAN =====
local pendapatanLabel = Instance.new("TextLabel")
pendapatanLabel.Size = UDim2.new(0, 140, 0, 20)
pendapatanLabel.Position = UDim2.new(0.55, 0, 0, 205)
pendapatanLabel.BackgroundTransparency = 1
pendapatanLabel.Text = "💰 Pendapatan: $0"
pendapatanLabel.TextColor3 = Color3.fromRGB(100, 255, 100)
pendapatanLabel.TextSize = 13
pendapatanLabel.Font = Enum.Font.Gotham
pendapatanLabel.Parent = frame

-- ===== TOMBOL START LOGIC =====
actionBtn.MouseButton1Click:Connect(function()
    if isRunning then
        -- STOP
        isRunning = false
        timerRunning = false
        actionBtn.Text = "▶ START"
        actionBtn.BackgroundColor3 = Color3.fromRGB(0, 200, 80)
        print("⏹️ Dihentikan oleh user")
        return
    end
    
    -- START
    actionBtn.Text = "⏳ PROSES..."
    actionBtn.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
    
    task.spawn(function()
        local success, err = pcall(startFarm)
        if not success then
            print("❌ ERROR:", err)
        end
        if not isRunning then
            actionBtn.Text = "▶ START"
            actionBtn.BackgroundColor3 = Color3.fromRGB(0, 200, 80)
        end
    end)
end)

-- ===== UPDATE UI =====
task.spawn(function()
    while true do
        pengeluaranLabel.Text = "💸 Pengeluaran: $" .. pengeluaran
        pendapatanLabel.Text = "💰 Pendapatan: $" .. pendapatan
        task.wait(0.5)
    end
end)

task.spawn(updateRuntime)

-- ===== TOGGLE UI (Z) =====
game:GetService("UserInputService").InputBegan:Connect(function(input, processed)
    if processed then return end
    if input.KeyCode == Enum.KeyCode.Z then
        screenGui.Enabled = not screenGui.Enabled
    end
end)

print("🔥 AUTO FARM UI V2 siap! Tekan Z untuk toggle UI.")
