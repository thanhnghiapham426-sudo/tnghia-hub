--[[
    Minecraft FPS + Ping + Ultra Fix Lag
    Version: 1.2
    Tối ưu cho GitHub
]]

local Players = game:GetService("Players")
local Lighting = game:GetService("Lighting")
local RunService = game:GetService("RunService")
local Stats = game:GetService("Stats")

local lp = Players.LocalPlayer

-- ====================== CONFIG ======================
local CONFIG = {
    UpdateInterval = 5,
    Position = UDim2.new(0, 15, 0, 15),
    Size = UDim2.new(0, 240, 0, 90),
}

-- ====================== FIX LAG + BRIGHT ======================
pcall(function()
    settings().Rendering.QualityLevel = Enum.QualityLevel.Level01
end)

pcall(function()
    Lighting.GlobalShadows = false
    Lighting.FogEnd = 1e10
    Lighting.Brightness = 2
    Lighting.ExposureCompensation = 0.4
    Lighting.Ambient = Color3.fromRGB(160,160,160)
    Lighting.OutdoorAmbient = Color3.fromRGB(160,160,160)
end)

-- Xóa hiệu ứng thừa
for _, v in pairs(Lighting:GetChildren()) do
    if v:IsA("PostEffect") or v:IsA("Sky") then
        v:Destroy()
    end
end

for _, v in pairs(workspace:GetDescendants()) do
    if v:IsA("BasePart") then
        v.Material = Enum.Material.SmoothPlastic
        v.Reflectance = 0
        v.CastShadow = false
    elseif v:IsA("MeshPart") then
        v.TextureID = ""
        v.RenderFidelity = Enum.RenderFidelity.Performance
    elseif v:IsA("Decal") or v:IsA("Texture") or v:IsA("SurfaceAppearance") then
        v:Destroy()
    elseif v:IsA("ParticleEmitter") or v:IsA("Trail") or v:IsA("Beam") or
           v:IsA("Fire") or v:IsA("Smoke") or v:IsA("Sparkles") then
        v.Enabled = false
    end
end

-- ====================== MINECRAFT FPS + PING ======================
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "MinecraftFPS"
screenGui.ResetOnSpawn = false
screenGui.Parent = lp:WaitForChild("PlayerGui")

local fpsLabel = Instance.new("TextLabel")
fpsLabel.Name = "FPSLabel"
fpsLabel.Parent = screenGui
fpsLabel.Position = CONFIG.Position
fpsLabel.Size = CONFIG.Size
fpsLabel.BackgroundTransparency = 0.35
fpsLabel.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
fpsLabel.TextStrokeTransparency = 0
fpsLabel.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
fpsLabel.TextXAlignment = Enum.TextXAlignment.Left
fpsLabel.RichText = true
fpsLabel.Font = Enum.Font.Arcade
fpsLabel.TextSize = 28
fpsLabel.Text = "FPS: --\nPing: --ms"

local frames = 0
local lastTime = tick()

RunService.RenderStepped:Connect(function()
    frames += 1
    if tick() - lastTime >= CONFIG.UpdateInterval then
        local fps = math.floor(frames / CONFIG.UpdateInterval)
        
        local ping = 0
        local pingStat = Stats.Network.ServerStatsItem("Data Ping")
        if pingStat then
            ping = math.floor(pingStat:GetValue())
        end

        local fpsColor = fps >= 55 and "#55FF55" or (fps >= 30 and "#FFFF55" or "#FF5555")

        fpsLabel.Text = string.format(
            '<font color="%s">FPS: %d</font>\n<font color="#FFAA00">Ping: %dms</font>',
            fpsColor, fps, ping
        )

        frames = 0
        lastTime = tick()
    end
end)

-- Ẩn Head
local function HideHead(char)
    task.wait(0.3)
    for _, v in pairs(char:GetDescendants()) do
        if v.Name == "Head" and v:IsA("BasePart") then
            v.Transparency = 1
            if v:FindFirstChild("face") then v.face.Transparency = 1 end
        end
    end
end

if lp.Character then HideHead(lp.Character) end
lp.CharacterAdded:Connect(HideHead)

print("✅ Minecraft FPS + Fix Lag Loaded!")
