-- AUTO BUY APART V6 - JALAN HALUS + SPEED 12
local player = game.Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local humanoid = character:WaitForChild("Humanoid")
local root = character:WaitForChild("HumanoidRootPart")

local SPEED = 12  -- kecepatan normal
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

-- ===== GERAK HALUS KE BAWAH PERMUKAAN =====
local function goTo(pos)
    local start = root.Position
    local bawah = Vector3.new(pos.X, pos.Y - 2, pos.Z)
    local targetBawah = Vector3.new(pos.X, pos.Y + ALT_OFFSET, pos.Z)
    local akhir = Vector3.new(pos.X, pos.Y + 2, pos.Z)

    -- Turun perlahan ke bawah permukaan
    humanoid.WalkSpeed = SPEED
    for i = 1, 15 do
        local t = i / 15
        local lerp = Vector3.new(
            start.X + (bawah.X - start.X) * t,
            start.Y + (bawah.Y - start.Y) * t,
            start.Z + (bawah.Z - start.Z) * t
        )
        root.CFrame = CFrame.new(lerp)
        task.wait(0.05)
    end

    -- Jalan cepat di bawah tanah menuju target
    for i = 1, 25 do
        local t = i / 25
        local lerp = Vector3.new(
            bawah.X + (targetBawah.X - bawah.X) * t,
            bawah.Y + (targetBawah.Y - bawah.Y) * t,
            bawah.Z + (targetBawah.Z - bawah.Z) * t
        )
        root.CFrame = CFrame.new(lerp)
        task.wait(0.04)
    end

    -- Naik perlahan ke permukaan
    for i = 1, 15 do
        local t = i / 15
        local lerp = Vector3.new(
            targetBawah.X + (akhir.X - targetBawah.X) * t,
            targetBawah.Y + (akhir.Y - targetBawah.Y) * t,
            targetBawah.Z + (akhir.Z - targetBawah.Z) * t
        )
        root.CFrame = CFrame.new(lerp)
        task.wait(0.05)
    end

    -- Posisi akhir di depan part
    root.CFrame = CFrame.new(pos)
    humanoid.WalkSpeed = 16
end

-- ===== CEK PROMPT =====
local function getPrompt(pos)
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
    for i, pos in ipairs(coords) do
        local part, prompt = getPrompt(pos)

        if part and prompt then
            local targetPos = part.Position + (part.CFrame.LookVector * 3) + Vector3.new(0, 2, 0)
            goTo(targetPos)
            task.wait(0.3)
            prompt:Hold(1.5)
            task.wait(0.3)
        end
        -- kalau tidak ada prompt, lewati
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
    pcall(buy)
end)
