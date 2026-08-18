-- UI GetCord - Save Coordinates to cord1.txt, cord2.txt, ...
-- Untuk executor support writefile (Synapse/Krnl/Fluxus)

local player = game.Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local root = character:WaitForChild("HumanoidRootPart")

-- Buat ScreenGui
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "GetCordUI"
screenGui.Parent = player.PlayerGui

-- Buat Frame utama
local frame = Instance.new("Frame")
frame.Size = UDim2.new(0, 200, 0, 80)
frame.Position = UDim2.new(0.5, -100, 0.85, 0)
frame.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
frame.BackgroundTransparency = 0.15
frame.BorderSizePixel = 0
frame.Active = true
frame.Draggable = true
frame.Parent = screenGui

-- Efek glass
local corner = Instance.new("UICorner")
corner.CornerRadius = UDim.new(0, 12)
corner.Parent = frame

-- Tombol GetCord
local button = Instance.new("TextButton")
button.Size = UDim2.new(0, 160, 0, 40)
button.Position = UDim2.new(0.5, -80, 0.5, -20)
button.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
button.BackgroundTransparency = 0.1
button.Text = "📌 GetCord"
button.TextColor3 = Color3.fromRGB(255, 255, 255)
button.TextSize = 20
button.Font = Enum.Font.GothamBold
button.BorderSizePixel = 0
button.Parent = frame

local btnCorner = Instance.new("UICorner")
btnCorner.CornerRadius = UDim.new(0, 8)
btnCorner.Parent = button

-- Efek hover
button.MouseEnter:Connect(function()
    button.BackgroundColor3 = Color3.fromRGB(255, 80, 80)
end)
button.MouseLeave:Connect(function()
    button.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
end)

-- Fungsi dapatkan nomor file selanjutnya
local function getNextFileName()
    local i = 1
    while true do
        local name = "cord" .. i .. ".txt"
        if not isfile(name) then
            return name, i
        end
        i = i + 1
    end
end

-- Fungsi simpan koordinat
local function saveCoordinates()
    if not root then
        game.StarterGui:SetCore("SendNotification", {
            Title = "Error",
            Text = "Karakter tidak ditemukan!",
            Duration = 3
        })
        return
    end
    
    local pos = root.Position
    local coordText = string.format("X: %.2f | Y: %.2f | Z: %.2f", pos.X, pos.Y, pos.Z)
    
    local fileName, index = getNextFileName()
    writefile(fileName, coordText)
    
    -- Notifikasi
    game.StarterGui:SetCore("SendNotification", {
        Title = "✅ Koordinat Tersimpan",
        Text = fileName .. " → " .. coordText,
        Duration = 4
    })
    
    print("[SAVED] " .. fileName .. " → " .. coordText)
end

-- Event klik tombol
button.MouseButton1Click:Connect(saveCoordinates)

-- Notifikasi awal
game.StarterGui:SetCore("SendNotification", {
    Title = "UI GetCord Aktif",
    Text = "Klik tombol di pojok kanan bawah",
    Duration = 4
})

print("UI GetCord siap. Klik tombol untuk simpan koordinat ke cord*.txt")
