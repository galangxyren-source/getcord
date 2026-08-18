-- TEST UI + START BUTTON
local player = game.Players.LocalPlayer
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "TestUI"
screenGui.Parent = player.PlayerGui

local frame = Instance.new("Frame")
frame.Size = UDim2.new(0, 320, 0, 240)
frame.Position = UDim2.new(0.5, -160, 0.5, -120)
frame.BackgroundColor3 = Color3.fromRGB(20, 20, 40)
frame.BackgroundTransparency = 0.1
frame.Active = true
frame.Draggable = true
frame.Parent = screenGui

local title = Instance.new("TextLabel")
title.Size = UDim2.new(0, 300, 0, 30)
title.Position = UDim2.new(0.5, -150, 0, 10)
title.BackgroundTransparency = 1
title.Text = "🔥 AUTO FARM (TEST)"
title.TextColor3 = Color3.fromRGB(255, 200, 50)
title.TextSize = 22
title.Font = Enum.Font.GothamBold
title.Parent = frame

local jumlahLabel = Instance.new("TextLabel")
jumlahLabel.Size = UDim2.new(0, 200, 0, 20)
jumlahLabel.Position = UDim2.new(0.5, -100, 0, 50)
jumlahLabel.BackgroundTransparency = 1
jumlahLabel.Text = "JUMLAH PAKET: 1"
jumlahLabel.TextColor3 = Color3.fromRGB(200, 200, 220)
jumlahLabel.TextSize = 14
jumlahLabel.Font = Enum.Font.GothamBold
jumlahLabel.Parent = frame

local actionBtn = Instance.new("TextButton")
actionBtn.Size = UDim2.new(0, 200, 0, 45)
actionBtn.Position = UDim2.new(0.5, -100, 0, 100)
actionBtn.BackgroundColor3 = Color3.fromRGB(0, 200, 80)
actionBtn.Text = "▶ START"
actionBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
actionBtn.TextSize = 18
actionBtn.Font = Enum.Font.GothamBold
actionBtn.BorderSizePixel = 0
actionBtn.Parent = frame

actionBtn.MouseButton1Click:Connect(function()
    print("✅ Tombol START diklik!")
    if actionBtn.Text == "▶ START" then
        actionBtn.Text = "⏳ PROSES..."
        actionBtn.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
        print("✅ State berubah jadi PROSES")
        task.wait(2)
        actionBtn.Text = "▶ START"
        actionBtn.BackgroundColor3 = Color3.fromRGB(0, 200, 80)
        print("✅ Kembali ke START")
    end
end)

print("✅ UI TEST siap! Klik tombol START buat test.")
