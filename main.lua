 -- AUTO BUY APART V16 - TURUN SEDIKIT (GAK KE VOID)
local player = game.Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local humanoid = character:WaitForChild("Humanoid")
local root = character:WaitForChild("HumanoidRootPart")
local TweenService = game:GetService("TweenService")

local ALT_OFFSET = -1.5        -- <-- TURUN SEDIKIT (GAK KE VOID)
local DURASI_TURUN = 2
local DURASI_JALAN = 5
local DURASI_NAIK = 2

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
    if state then
        humanoid:SetStateEnabled(Enum.HumanoidStateType.Climbing, false)
        humanoid:SetStateEnabled(Enum.HumanoidStateType.FallingDown, false)
    else
        humanoid:SetStateEnabled(Enum.HumanoidStateType.Climbing, true)
        humanoid:SetStateEnabled(Enum.HumanoidStateType.FallingDown, true)
    end
end

-- ===== DORONG PAKAI VELOCITY (BIAR TEMBUS) =====
local function pushDown(targetPos)
    local below = Vector3.new(root.Position.X, targetPos.Y + ALT_OFFSET, root.Position.Z)
    local bodyVelocity = Instance.new("BodyVelocity")
    bodyVelocity.MaxForce = Vector3.new(0, 1e6, 0)
    bodyVelocity.Velocity = Vector3.new(0, -30, 0)
    bodyVelocity.Parent = root
    
    task.wait(0.5)
    root.CFrame = CFrame.new(below)
    bodyVelocity:Destroy()
end

-- ===== GERAK PAKAI TWEEN =====
local function tweenTo(pos, durasi)
    local tween = TweenService:Create(root, TweenInfo.new(durasi, Enum.EasingStyle.Linear), {CFrame = CFrame.new(pos)})
    tween:Play()
    tween.Completed:Wait()
end

-- ===== CEK PROMPT (HANYA PURCHASE) =====
local function getPurchasePrompt(pos)
    local candidates = {}
    
    for _, p in pairs(workspace:GetDescendants()) do
        if p:IsA("ProximityPrompt") then
            local parent = p.Parent
            if parent and parent:IsA("BasePart") then
                local dist = (parent.Position - pos).Magnitude
                if dist < 25 then
                    local txt = p.ActionText or ""
                    local isPurchase = txt:lower():find("purchase") or txt:lower():find("beli")
                    local isOpen = txt:lower():find("open")
                    
                    if isPurchase and not isOpen and p.Enabled == true then
                        table.insert(candidates, {part = parent, prompt = p, dist = dist})
                    end
                end
            end
        end
    end
    
    if #candidates > 0 then
        table.sort(candidates, function(a, b) return a.dist < b.dist end)
        return candidates[1].part, candidates[1].prompt
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
            
            pushDown(targetPos)
            task.wait(0.2)

            local bawahTarget = Vector3.new(targetPos.X, targetPos.Y + ALT_OFFSET, targetPos.Z)
            tweenTo(bawahTarget, DURASI_JALAN)
            task.wait(0.2)

            tweenTo(targetPos, DURASI_NAIK)
            task.wait(0.2)

            noclip(false)

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
