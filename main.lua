-- AUTO BUY APART V18 - MOVETO PELAN + DELAY (ANTI CRASH)
local player = game.Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local humanoid = character:WaitForChild("Humanoid")
local root = character:WaitForChild("HumanoidRootPart")

local SPEED = 8
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

-- ===== NOCLIP =====
local function noclip(state)
    for _, v in pairs(character:GetDescendants()) do
        if v:IsA("BasePart") then
            v.CanCollide = not state
        end
    end
end

-- ===== JALAN PELAN PAKAI MOVETO =====
local function walkTo(pos)
    humanoid.WalkSpeed = SPEED
    humanoid:MoveTo(pos)
    -- Tunggu sampai jarak < 3
    while (root.Position - pos).Magnitude > 3 do
        task.wait(0.1)
    end
end

-- ===== TURUN PELAN (CFRAME BERTAHAP) =====
local function goDown(targetPos)
    local below = Vector3.new(root.Position.X, targetPos.Y + ALT_OFFSET, root.Position.Z)
    for i = 1, 20 do
        local t = i / 20
        root.CFrame = CFrame.new(root.Position:Lerp(below, 0.05))
        task.wait(0.05)
    end
end

-- ===== NAIK PELAN (CFRAME BERTAHAP) =====
local function goUp(targetPos)
    for i = 1, 20 do
        local t = i / 20
        root.CFrame = CFrame.new(root.Position:Lerp(targetPos, 0.05))
        task.wait(0.05)
    end
end

-- ===== CEK PROMPT (PURCHASE SAJA) =====
local function getPurchasePrompt(pos)
    for _, p in pairs(workspace:GetDescendants()) do
        if p:IsA("ProximityPrompt") then
            local parent = p.Parent
            if parent and parent:IsA("BasePart") then
                if (parent.Position - pos).Magnitude < 20 then
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
        local part, prompt = getPurchasePrompt(pos)

        if part and prompt then
            local targetPos = part.Position + (part.CFrame.LookVector * 3) + Vector3.new(0, 2, 0)

            noclip(true)
            
            -- 1. Turun pelan
            goDown(targetPos)
            task.wait(0.3)

            -- 2. Jalan di bawah tanah
            local bawahTarget = Vector3.new(targetPos.X, targetPos.Y + ALT_OFFSET, targetPos.Z)
            walkTo(bawahTarget)
            task.wait(0.3)

            -- 3. Naik pelan
            goUp(targetPos)
            task.wait(0.3)

            noclip(false)

            -- 4. Hold E
            prompt:Hold(1.5)
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
    pcall(buy)
end)
