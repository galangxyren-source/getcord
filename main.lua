-- AUTO BUY APART V8 - PAKAI TWEEN (LAMBAT & HALUS)
local player = game.Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local humanoid = character:WaitForChild("Humanoid")
local root = character:WaitForChild("HumanoidRootPart")
local TweenService = game:GetService("TweenService")

local SPEED = 1
local ALT_OFFSET = -8
local DURASI = 4  -- lama gerak per segmen (dalam detik)

local coords = {
    Vector3.new(927.98, 10.09, 73.01),
    Vector3.new(898.88, 10.09, 73.32),
    Vector3.new(1019.57, 10.09, 218.32),
    Vector3.new(1019.48, 10.09, 246.60),
    Vector3.new(1107.78, 10.92, 423.74),
    Vector3.new(1107.68, 10.09, 452.43)
}

local isRunning = false

-- ===== GERAK LAMBAT PAKAI TWEEN =====
local function tweenTo(pos, durasi)
    local tween = TweenService:Create(root, TweenInfo.new(durasi, Enum.EasingStyle.Linear), {CFrame = CFrame.new(pos)})
    tween:Play()
    tween.Completed:Wait()
end

-- ===== TURUN KE BAWAH =====
local function goBelow(targetPos)
    local below = Vector3.new(targetPos.X, targetPos.Y + ALT_OFFSET, targetPos.Z)
    tweenTo(below, DURASI * 0.3)
end

-- ===== NAIK KE PERMUKAAN =====
local function goAbove(targetPos)
    tweenTo(targetPos, DURASI * 0.3)
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

            -- 1. Jalan ke atas target
            local above = Vector3.new(targetPos.X, targetPos.Y + 5, targetPos.Z)
            tweenTo(above, DURASI * 0.3)
            task.wait(0.1)

            -- 2. Turun ke bawah permukaan
            goBelow(targetPos)
            task.wait(0.1)

            -- 3. Jalan horizontal di bawah tanah
            local bawah = Vector3.new(targetPos.X, targetPos.Y + ALT_OFFSET, targetPos.Z)
            tweenTo(bawah, DURASI * 0.5)
            task.wait(0.1)

            -- 4. Naik ke permukaan
            goAbove(targetPos)
            task.wait(0.1)

            -- 5. Posisi akhir di depan apartemen
            tweenTo(targetPos, DURASI * 0.3)
            task.wait(0.2)

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
