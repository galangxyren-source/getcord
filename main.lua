-- FULL AUTO FARM (BELI APART SEKALI, LOOP BAHAN→MASAK→JUAL)
local player = game.Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local humanoid = character:WaitForChild("Humanoid")
local root = character:WaitForChild("HumanoidRootPart")

-- ===== KONFIGURASI =====
local COOLDOWN = 2
local NPC_COORD = Vector3.new(510.56, 3.58, 598.88)   -- tempat beli bahan & jual
local BAWAH_Y = -1

-- ===== PASANGAN APARTEMEN & TEMPAT MASAK =====
local locations = {
    {apart = Vector3.new(898.89, 9.98, 75.52), cook = Vector3.new(898.62, 10.09, 38.48)},
    {apart = Vector3.new(926.92, 10.09, 74.98), cook = Vector3.new(927.05, 10.09, 39.27)},
    {apart = Vector3.new(1021.61, 9.78, 217.91), cook = Vector3.new(984.26, 10.09, 218.81)},
    {apart = Vector3.new(1020.47, 10.09, 246.09), cook = Vector3.new(985.40, 10.11, 247.28)},
    {apart = Vector3.new(1106.99, 10.11, 424.25), cook = Vector3.new(1142.26, 10.11, 423.37)},
    {apart = Vector3.new(1105.87, 10.07, 451.87), cook = Vector3.new(1142.68, 10.11, 452.00)}
}

local isRunning = false
local jumlahPaket = 1
local boughtIndex = nil   -- indeks apartemen yang sudah dibeli

-- ===== HAPUS GUI LAMA =====
for _, gui in pairs(player.PlayerGui:GetChildren()) do
    if gui:IsA("ScreenGui") then gui:Destroy() end
end

-- ===== NOTIF =====
local function notif(text)
    game.StarterGui:SetCore("SendNotification", {Title = "Auto Farm", Text = text, Duration = 4})
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

-- ===== GERAK TEMBUS =====
local function goDown()
    local targetY = BAWAH_Y
    for i = 1, 10 do
        local newY = root.Position.Y + (targetY - root.Position.Y) * (i / 10)
        root.CFrame = CFrame.new(root.Position.X, newY, root.Position.Z)
        task.wait(0.05)
    end
end

local function goUp(targetPos)
    local startY = root.Position.Y
    local targetY = targetPos.Y + 2
    for i = 1, 10 do
        local newY = startY + (targetY - startY) * (i / 10)
        root.CFrame = CFrame.new(root.Position.X, newY, root.Position.Z)
        task.wait(0.05)
    end
end

-- ===== JALAN DEFAULT (MOVETO) =====
local function walkTo(pos)
    humanoid.WalkSpeed = 16
    humanoid:MoveTo(pos)
    while (root.Position - pos).Magnitude > 5 do
        task.wait(0.2)
    end
end

local function travelTo(targetPos)
    noclip(true)
    goDown()
    walkTo(Vector3.new(targetPos.X, BAWAH_Y, targetPos.Z))
    goUp(targetPos)
    noclip(false)
end

-- ===== INVENTORY =====
local function getItemFromInventory(itemName)
    for _, v in pairs(player.Backpack:GetChildren()) do
        if v:IsA("Tool") and v.Name:lower():find(itemName:lower()) then
            return v
        end
    end
    for _, v in pairs(character:GetChildren()) do
        if v:IsA("Tool") and v.Name:lower():find(itemName:lower()) then
            return v
        end
    end
    return nil
end

local function equipItem(itemName)
    local item = getItemFromInventory(itemName)
    if item then
        if item.Parent == player.Backpack then
            humanoid:EquipTool(item)
        end
        task.wait(0.5)
        return true
    end
    return false
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

-- ===== DIALOG =====
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

-- ===== PROMPT APART =====
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

-- =====================================================
-- ===== FUNGSI FARM =====
-- =====================================================

-- 1. BELI APARTEMEN (hanya sekali)
local function buyApartment()
    for i, loc in ipairs(locations) do
        local part, prompt = getPurchasePrompt(loc.apart)
        if part and prompt then
            local target = part.Position + part.CFrame.LookVector * 3 + Vector3.new(0, 2, 0)
            travelTo(target)
            prompt:Hold(1.5)
            return i
        end
    end
    return nil
end

-- 2. BELI BAHAN
local function buyMaterials(amount)
    travelTo(NPC_COORD)
    pressE()
    clickDialog()
    clickItem("Gelatin") clickAmount(amount)
    clickItem("Sugar Block Bag") clickAmount(amount)
    clickItem("Water") clickAmount(amount)
    clickExit()
end

-- 3. MASAK (1 siklus) di cookCoord
local function cookOne(cookCoord)
    travelTo(cookCoord)
    
    if equipItem("Water") then
        pressE()
        task.wait(math.random(23, 25))
    end
    
    if equipItem("Sugar Block Bag") then
        pressE()
        task.wait(4)
    end
    
    if equipItem("Gelatin") then
        pressE()
        task.wait(math.random(47, 50))
    end
    
    if equipItem("Empty Bag") then
        pressE()
        task.wait(1)
    end
end

-- 4. JUAL MARSHMALLOW (loop sampai habis)
local function sellMarshmallows()
    travelTo(NPC_COORD)
    pressE()
    clickDialog()
    
    local marshmallows = {"Small marshmallow bag", "Medium marshmallow bag", "Large marshmallow bag"}
    local soldAny = false
    
    while true do
        local found = false
        for _, name in ipairs(marshmallows) do
            if equipItem(name) then
                pressE()
                task.wait(2)
                found = true
                soldAny = true
                break
            end
        end
        if not found then
            break
        end
    end
    
    if soldAny then
        clickExit()
    end
end

-- ===== MAIN LOOP =====
local function startFarm()
    if isRunning then return end
    isRunning = true
    notif("🔥 Auto Farm dimulai!")
    
    -- BELI APARTEMEN SEKALI
    boughtIndex = buyApartment()
    if not boughtIndex then
        notif("⚠️ Tidak ada apartemen kosong!")
        isRunning = false
        return
    end
    notif("✅ Apartemen dibeli di indeks " .. boughtIndex)
    task.wait(COOLDOWN)
    
    -- LOOP: BELI BAHAN → MASAK → JUAL
    while isRunning do
        buyMaterials(jumlahPaket)
        task.wait(COOLDOWN)
        
        local cookCoord = locations[boughtIndex].cook
        for i = 1, jumlahPaket do
            cookOne(cookCoord)
        end
        task.wait(COOLDOWN)
        
        sellMarshmallows()
        task.wait(COOLDOWN)
    end
end

local function stopFarm()
    isRunning = false
    notif("⏹️ Auto Farm dihentikan!")
end

-- =====================================================
-- ===== UI =====
-- =====================================================
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "AF"
screenGui.Parent = player.PlayerGui

local frame = Instance.new("Frame")
frame.Size = UDim2.new(0, 220, 0, 140)
frame.Position = UDim2.new(0.5, -110, 0.5, -70)
frame.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
frame.BackgroundTransparency = 0.3
frame.BorderSizePixel = 0
frame.Active = true
frame.Draggable = true
frame.Parent = screenGui

local title = Instance.new("TextLabel")
title.Size = UDim2.new(0, 200, 0, 25)
title.Position = UDim2.new(0.5, -100, 0, 5)
title.BackgroundTransparency = 1
title.Text = "🔥 AUTO FARM"
title.TextColor3 = Color3.fromRGB(255, 200, 50)
title.TextSize = 18
title.Font = Enum.Font.GothamBold
title.Parent = frame

local label = Instance.new("TextLabel")
label.Size = UDim2.new(0, 180, 0, 18)
label.Position = UDim2.new(0.5, -90, 0, 32)
label.BackgroundTransparency = 1
label.Text = "PAKET: 1"
label.TextColor3 = Color3.fromRGB(200, 200, 255)
label.TextSize = 13
label.Font = Enum.Font.Gotham
label.Parent = frame

local minus = Instance.new("TextButton")
minus.Size = UDim2.new(0, 35, 0, 30)
minus.Position = UDim2.new(0.5, -55, 0, 55)
minus.BackgroundColor3 = Color3.fromRGB(40, 40, 70)
minus.Text = "−"
minus.TextColor3 = Color3.fromRGB(255,255,255)
minus.TextSize = 20
minus.Font = Enum.Font.GothamBold
minus.BorderSizePixel = 0
minus.Parent = frame

local angka = Instance.new("TextLabel")
angka.Size = UDim2.new(0, 40, 0, 30)
angka.Position = UDim2.new(0.5, -20, 0, 55)
angka.BackgroundColor3 = Color3.fromRGB(25, 25, 50)
angka.Text = "1"
angka.TextColor3 = Color3.fromRGB(255,255,255)
angka.TextSize = 18
angka.Font = Enum.Font.GothamBold
angka.Parent = frame

local plus = Instance.new("TextButton")
plus.Size = UDim2.new(0, 35, 0, 30)
plus.Position = UDim2.new(0.5, 20, 0, 55)
plus.BackgroundColor3 = Color3.fromRGB(40, 40, 70)
plus.Text = "+"
plus.TextColor3 = Color3.fromRGB(255,255,255)
plus.TextSize = 20
plus.Font = Enum.Font.GothamBold
plus.BorderSizePixel = 0
plus.Parent = frame

local btnStart = Instance.new("TextButton")
btnStart.Size = UDim2.new(0, 140, 0, 30)
btnStart.Position = UDim2.new(0.5, -70, 0, 95)
btnStart.BackgroundColor3 = Color3.fromRGB(0, 200, 80)
btnStart.Text = "▶ START"
btnStart.TextColor3 = Color3.fromRGB(255,255,255)
btnStart.TextSize = 14
btnStart.Font = Enum.Font.GothamBold
btnStart.BorderSizePixel = 0
btnStart.Parent = frame

-- =====================================================
-- ===== UI LOGIC =====
-- =====================================================
minus.MouseButton1Click:Connect(function()
    if isRunning then return end
    local v = tonumber(angka.Text) or 1
    if v > 1 then
        v = v - 1
        angka.Text = tostring(v)
        label.Text = "PAKET: " .. v
        jumlahPaket = v
    end
end)

plus.MouseButton1Click:Connect(function()
    if isRunning then return end
    local v = tonumber(angka.Text) or 1
    if v < 50 then
        v = v + 1
        angka.Text = tostring(v)
        label.Text = "PAKET: " .. v
        jumlahPaket = v
    end
end)

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
        if not ok then notif("❌ Error: " .. tostring(err)) end
        if not isRunning then
            btnStart.Text = "▶ START"
            btnStart.BackgroundColor3 = Color3.fromRGB(0, 200, 80)
        end
    end)
end)

-- =====================================================
-- ===== TOGGLE UI =====
-- =====================================================
game:GetService("UserInputService").InputBegan:Connect(function(input, p)
    if p then return end
    if input.KeyCode == Enum.KeyCode.Z then
        screenGui.Enabled = not screenGui.Enabled
    end
end)

notif("✅ Auto Farm FULL siap! Tekan Z toggle UI.")
