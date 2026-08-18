-- TEST UI MINIMALIS + NOTIFIKASI
local player = game.Players.LocalPlayer

-- Buat ScreenGui
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "TestUI"
screenGui.Parent = player.PlayerGui

-- Frame
local frame = Instance.new("Frame")
frame.Size = UDim2.new(0, 250, 0, 100)
frame.Position = UDim2.new(0.5, -125, 0.5, -50)
frame.BackgroundColor3 = Color3.fromRGB(30, 30, 50)
frame.BackgroundTransparency = 0.2
frame.Active = true
frame.Draggable = true
frame.Parent = screenGui

-- Tombol START
local btn = Instance.new("TextButton")
btn.Size = UDim2.new(0, 180, 0, 40)
btn.Position = UDim2.new(0.5, -90, 0.5, -20)
btn.BackgroundColor3 = Color3.fromRGB(0, 200, 80)
btn.Text = "▶ START"
btn.TextColor3 = Color3.fromRGB(255, 255, 255)
btn.TextSize = 18
btn.Font = Enum.Font.GothamBold
btn.BorderSizePixel = 0
btn.Parent = frame

-- Klik tombol
btn.MouseButton1Click:Connect(function()
    -- NOTIFIKASI (pasti keliatan)
    game.StarterGui:SetCore("SendNotification", {
        Title = "✅ Tombol Diklik",
        Text = "START berhasil ditekan!",
        Duration = 5
    })
    
    -- Ganti teks
    btn.Text = "⏳ PROSES..."
    btn.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
    
    task.wait(2)
    
    btn.Text = "▶ START"
    btn.BackgroundColor3 = Color3.fromRGB(0, 200, 80)
    
    -- Notifikasi kedua
    game.StarterGui:SetCore("SendNotification", {
        Title = "🔄 Selesai",
        Text = "Kembali ke START",
        Duration = 3
    })
end)

-- Notifikasi awal
game.StarterGui:SetCore("SendNotification", {
    Title = "🔥 UI TEST",
    Text = "Klik tombol START untuk test",
    Duration = 4
})
