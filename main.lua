-- AUTO BUY APART V12 - TURUN DULU + LAMBAT BANGET
local player = game.Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local humanoid = character:WaitForChild("Humanoid")
local root = character:WaitForChild("HumanoidRootPart")
local TweenService = game:GetService("TweenService")

local ALT_OFFSET = -8

-- ===== DURASI GERAK (semakin besar, semakin lambat) =====
local DURASI_TURUN = 6        -- turun ke bawah permukaan
local DURASI_JALAN = 14       -- jalan horizontal di bawah tanah
local DURASI_NAIK = 6         -- naik ke permukaan

local coords = {
    Vector3.new(927.98, 10.09, 73.01),
    Vector3.new(898.88, 10.09, 73.32),
    Vector3.new(1019.57, 10.09, 218.32),
    Vector3.new(1019.48, 10.09, 246.60),
    Vector3.new(1107.78, 10.92, 423.74),
    Vector3.new(1107.68, 10.09, 452.43)
}

local isRunning = false

-- ===== GERAK PAKAI TWEEN =====
local function tweenTo(pos, durasi)
    local tween = TweenService:Create(root, TweenInfo.new(durasi, Enum.EasingStyle.Linear), {CFrame = CFrame.new(pos)})
    tween:Play()
    tween.Completed:Wait()
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

            -- 1. TURUN DULU ke bawah permukaan (tanpa naik dulu)
            local below = Vector3.new(root.Position.X, targetPos.Y + ALT_OFFSET, root.Position.Z)
            tweenTo(below, DURASI_TURUN)
            task.wait(0.2)

            -- 2. Jalan horizontal di bawah tanah menuju target
            local bawahTarget = Vector3.new(targetPos.X, targetPos.Y + ALT_OFFSET, targetPos.Z)
            tweenTo(bawahTarget, DURASI_JALAN)
            task.wait(0.2)

            -- 3. NAIK ke permukaan
            tweenTo(targetPos, DURASI_NAIK)
            task.wait(0.2)

            -- 4. Hold E
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
