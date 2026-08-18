-- AUTO BUY APART V7 - JALAN NORMAL ROBLOX (MoveTo)
local player = game.Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local humanoid = character:WaitForChild("Humanoid")
local root = character:WaitForChild("HumanoidRootPart")

local SPEED = 6  -- kecepatan normal Roblox
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

-- ===== JALAN NORMAL KE KOORDINAT (MoveTo) =====
local function walkTo(pos)
    humanoid.WalkSpeed = SPEED
    humanoid:MoveTo(pos)
    
    -- Tunggu sampai sampai (dengan timeout)
    local timeout = os.clock() + 30
    while (root.Position - pos).Magnitude > 3 and os.clock() < timeout do
        task.wait(0.1)
    end
end

-- ===== TURUN KE BAWAH PERMUKAAN (HALUS) =====
local function goBelowSurface(targetPos)
    local below = Vector3.new(targetPos.X, targetPos.Y + ALT_OFFSET, targetPos.Z)
    
    -- Turun perlahan pakai CFrame bertahap (agar tidak "swing")
    local start = root.Position
    for i = 1, 20 do
        local t = i / 20
        local lerp = Vector3.new(
            start.X + (below.X - start.X) * t,
            start.Y + (below.Y - start.Y) * t,
            start.Z + (below.Z - start.Z) * t
        )
        root.CFrame = CFrame.new(lerp)
        task.wait(0.03)
    end
end

-- ===== NAIK KE PERMUKAAN (HALUS) =====
local function goAboveSurface(targetPos)
    local start = root.Position
    for i = 1, 20 do
        local t = i / 20
        local lerp = Vector3.new(
            start.X + (targetPos.X - start.X) * t,
            start.Y + (targetPos.Y - start.Y) * t,
            start.Z + (targetPos.Z - start.Z) * t
        )
        root.CFrame = CFrame.new(lerp)
        task.wait(0.03)
    end
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

            -- 1. Jalan normal ke bawah permukaan (di atas koordinat)
            local abovePos = Vector3.new(targetPos.X, targetPos.Y + 5, targetPos.Z)
            walkTo(abovePos)
            task.wait(0.3)

            -- 2. Turun perlahan ke bawah permukaan
            goBelowSurface(targetPos)
            task.wait(0.2)

            -- 3. Jalan normal di bawah tanah menuju target (horizontal)
            walkTo(Vector3.new(targetPos.X, targetPos.Y + ALT_OFFSET, targetPos.Z))
            task.wait(0.3)

            -- 4. Naik perlahan ke permukaan
            goAboveSurface(targetPos)
            task.wait(0.2)

            -- 5. Jalan normal ke posisi akhir
            walkTo(targetPos)
            task.wait(0.3)

            -- 6. Hold E
            prompt:Hold(1.5)
            task.wait(0.3)
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
    pcall(buy)
end)
