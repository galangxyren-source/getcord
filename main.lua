-- AUTO BUY APART V3 - RINGAN + TANPA NOTIF
local player = game.Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local humanoid = character:WaitForChild("Humanoid")
local root = character:WaitForChild("HumanoidRootPart")

-- ===== KONFIGURASI =====
local SPEED = 120
local ALT_OFFSET = -8

local coords = {
    Vector3.new(927.98, 10.09, 73.01),
    Vector3.new(898.88, 10.09, 73.32),
    Vector3.new(1019.57, 10.09, 218.32),
    Vector3.new(1019.48, 10.09, 246.60),
    Vector3.new(1107.78, 10.92, 423.74),
    Vector3.new(1107.68, 10.09, 452.43)
}

local isRunning = false

-- ===== GERAK CEPAT KE KOORDINAT =====
local function goTo(pos)
    local start = root.Position
    local bawah = Vector3.new(pos.X, pos.Y - 1, pos.Z)
    local targetBawah = Vector3.new(pos.X, pos.Y + ALT_OFFSET, pos.Z)
    
    -- Turun dulu
    root.CFrame = CFrame.new(bawah)
    task.wait(0.05)
    
    -- Pindah cepat ke bawah tanah
    humanoid.WalkSpeed = SPEED
    for i = 1, 20 do
        local t = i / 20
        root.CFrame = CFrame.new(start:Lerp(targetBawah, t))
        task.wait(0.02)
    end
    
    -- Naik ke posisi sebenarnya
    for i = 1, 8 do
        local t = i / 8
        local naik = Vector3.new(pos.X, targetBawah.Y + (pos.Y - targetBawah.Y) * t, pos.Z)
        root.CFrame = CFrame.new(naik)
        task.wait(0.02)
    end
    
    root.CFrame = CFrame.new(pos)
    humanoid.WalkSpeed = 16
end

-- ===== CEK APART KOSONG =====
local function getAvailable(pos)
    for _, p in pairs(workspace:GetDescendants()) do
        if p:IsA("ProximityPrompt") then
            local parent = p.Parent
            if parent and parent:IsA("BasePart") then
                if (parent.Position - pos).Magnitude < 15 then
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

-- ===== PROSES BELI =====
local function buy()
    for _, pos in ipairs(coords) do
        local part, prompt = getAvailable(pos)
        if part and prompt then
            goTo(part.Position + Vector3.new(0, 2, 0))
            task.wait(0.3)
            prompt:Hold(1)
            task.wait(0.5)
        end
    end
    isRunning = false
end

-- ===== UI =====
local gui = Instance.new("ScreenGui")
gui.Parent = player.PlayerGui

local frame = Instance.new("Frame")
frame.Size = UDim2.new(0, 200, 0, 50)
frame.Position = UDim2.new(0.5, -100, 0.85, 0)
frame.BackgroundColor3 = Color3.fromRGB(20, 20, 30)
frame.BackgroundTransparency = 0.1
frame.Active = true
frame.Draggable = true
frame.Parent = gui

local btn = Instance.new("TextButton")
btn.Size = UDim2.new(0, 170, 0, 35)
btn.Position = UDim2.new(0.5, -85, 0.5, -17.5)
btn.BackgroundColor3 = Color3.fromRGB(0, 200, 80)
btn.Text = "🚀 START BUY APART"
btn.TextColor3 = Color3.fromRGB(255,255,255)
btn.TextSize = 14
btn.Font = Enum.Font.GothamBold
btn.BorderSizePixel = 0
btn.Parent = frame

btn.MouseButton1Click:Connect(function()
    if isRunning then return end
    isRunning = true
    buy()
end)
