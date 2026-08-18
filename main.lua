-- AUTO BUY APARTMENT + SMOOTH TELEPORT
-- UI Dragable + Tombol START BUY APART

local player = game.Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local humanoid = character:WaitForChild("Humanoid")
local root = character:WaitForChild("HumanoidRootPart")

-- ===== KONFIGURASI =====
local SPEED = 120
local ALTITUDE_OFFSET = -8
local TELEPORT_DELAY = 2
local BUY_HOLD_TIME = 1

-- ===== DAFTAR KOORDINAT APARTEMEN =====
local apartmentCoords = {
    Vector3.new(927.98, 10.09, 73.01),
    Vector3.new(898.88, 10.09, 73.32),
    Vector3.new(1019.57, 10.09, 218.32),
    Vector3.new(1019.48, 10.09, 246.60),
    Vector3.new(1107.78, 10.92, 423.74),
    Vector3.new(1107.68, 10.09, 452.43)
}

local boughtCount = 0
local isRunning = false

-- ===== FUNGSI SMOOTH TELEPORT =====
local function smoothTeleport(targetPosition)
    if not targetPosition then return end
    
    local startPos = root.Position
    local endPos = Vector3.new(targetPosition.X, targetPosition.Y + ALTITUDE_OFFSET, targetPosition.Z)
    local surfacePos = Vector3.new(targetPosition.X, targetPosition.Y, targetPosition.Z)
    
    local originalSpeed = humanoid.WalkSpeed
    humanoid.WalkSpeed = SPEED
    humanoid.AutoRotate = true
    
    -- Turun ke bawah jalan
    local bawah = Vector3.new(startPos.X, targetPosition.Y - 1, startPos.Z)
    root.CFrame = CFrame.new(bawah)
    
    -- Gerak cepat di bawah tanah menuju target
    local steps = 30
    for i = 1, steps do
        local t = i / steps
        local lerpPos = startPos:Lerp(endPos, t)
        root.CFrame = CFrame.new(lerpPos)
        task.wait(0.05)
    end
    
    -- Naik ke permukaan
    for i = 1, 10 do
        local t = i / 10
        local naikPos = Vector3.new(
            endPos.X,
            endPos.Y + (targetPosition.Y - endPos.Y) * t,
            endPos.Z
        )
        root.CFrame = CFrame.new(naikPos)
        task.wait(0.05)
    end
    
    root.CFrame = CFrame.new(targetPosition)
    humanoid.WalkSpeed = originalSpeed
end

-- ===== FUNGSI CEK APARTEMEN KOSONG =====
local function isApartmentAvailable(pos)
    -- Cari ProximityPrompt terdekat dari posisi
    for _, prompt in pairs(workspace:GetDescendants()) do
        if prompt:IsA("ProximityPrompt") then
            local parent = prompt.Parent
            if parent and parent:IsA("BasePart") then
                local dist = (parent.Position - pos).Magnitude
                if dist < 10 then
                    local text = prompt.ActionText or ""
                    if text:lower():find("purchase") or text:lower():find("beli") or text:lower():find("buy") then
                        if prompt.Enabled == true then
                            return true, parent, prompt
                        end
                    end
                end
            end
        end
    end
    return false, nil, nil
end

-- ===== FUNGSI BELI =====
local function buyApartment(parentPart, prompt)
    if not parentPart or not prompt then return false end
    
    smoothTeleport(parentPart.Position + Vector3.new(0, 2, 0))
    task.wait(0.5)
    prompt:Hold(BUY_HOLD_TIME)
    task.wait(1)
    
    -- Cek apakah masih ada prompt (kalau hilang berarti berhasil)
    if not prompt.Enabled or not prompt.Parent then
        return true
    end
    return false
end

-- ===== AUTO BUY LOOP =====
local function startAutoBuy()
    if isRunning then return end
    isRunning = true
    boughtCount = 0
    
    game.StarterGui:SetCore("SendNotification", {
        Title = "🔄 AUTO BUY START",
        Text = "Mencari apartemen kosong...",
        Duration = 3
    })
    
    for i, coord in ipairs(apartmentCoords) do
        if not isRunning then break end
        
        local available, part, prompt = isApartmentAvailable(coord)
        
        if available then
            game.StarterGui:SetCore("SendNotification", {
                Title = "🏠 Apartemen Ditemukan",
                Text = "Koordinat " .. i .. " masih kosong, membeli...",
                Duration = 3
            })
            
            local success = buyApartment(part, prompt)
            if success then
                boughtCount = boughtCount + 1
                game.StarterGui:SetCore("SendNotification", {
                    Title = "✅ Berhasil",
                    Text = "Apartemen " .. i .. " berhasil dibeli!",
                    Duration = 3
                })
            else
                game.StarterGui:SetCore("SendNotification", {
                    Title = "⚠️ Gagal",
                    Text = "Apartemen " .. i .. " mungkin sudah dibeli orang lain",
                    Duration = 3
                })
            end
        else
            game.StarterGui:SetCore("SendNotification", {
                Title = "⏭️ Lewati",
                Text = "Koordinat " .. i .. " sudah dibeli / tidak ada prompt",
                Duration = 2
            })
        end
        
        task.wait(TELEPORT_DELAY)
    end
    
    isRunning = false
    game.StarterGui:SetCore("SendNotification", {
        Title = "🏁 Selesai",
        Text = "Total apartemen dibeli: " .. boughtCount,
        Duration = 5
    })
end

-- ===== UI DRAGABLE =====
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "AutoBuyUI"
screenGui.Parent = player.PlayerGui

local frame = Instance.new("Frame")
frame.Size = UDim2.new(0, 220, 0, 60)
frame.Position = UDim2.new(0.5, -110, 0.8, 0)
frame.BackgroundColor3 = Color3.fromRGB(20, 20, 30)
frame.BackgroundTransparency = 0.15
frame.BorderSizePixel = 0
frame.Active = true
frame.Draggable = true
frame.Parent = screenGui

local corner = Instance.new("UICorner")
corner.CornerRadius = UDim.new(0, 12)
corner.Parent = frame

local button = Instance.new("TextButton")
button.Size = UDim2.new(0, 180, 0, 40)
button.Position = UDim2.new(0.5, -90, 0.5, -20)
button.BackgroundColor3 = Color3.fromRGB(0, 180, 80)
button.BackgroundTransparency = 0.1
button.Text = "🚀 START BUY APART"
button.TextColor3 = Color3.fromRGB(255, 255, 255)
button.TextSize = 16
button.Font = Enum.Font.GothamBold
button.BorderSizePixel = 0
button.Parent = frame

local btnCorner = Instance.new("UICorner")
btnCorner.CornerRadius = UDim.new(0, 8)
btnCorner.Parent = button

button.MouseEnter:Connect(function()
    button.BackgroundColor3 = Color3.fromRGB(0, 220, 100)
end)
button.MouseLeave:Connect(function()
    button.BackgroundColor3 = Color3.fromRGB(0, 180, 80)
end)

button.MouseButton1Click:Connect(function()
    if isRunning then
        game.StarterGui:SetCore("SendNotification", {
            Title = "⏳ Sedang Berjalan",
            Text = "Tunggu sampai selesai!",
            Duration = 2
        })
        return
    end
    startAutoBuy()
end)

game.StarterGui:SetCore("SendNotification", {
    Title = "✅ UI Siap",
    Text = "Klik START BUY APART untuk memulai",
    Duration = 4
})

print("✅ Auto Buy Apartment siap. Klik tombol START BUY APART.")
