--[[
    =============================================
    Roblox FPS + Ping Display (Minecraft Style)
    + Performance Optimizer (Fix Lag + Bright)
    =============================================
    Author: YourName / Thành Nghĩa
    Version: 1.2
    Last Updated: 2026
    Description: Hiển thị FPS + Ping kiểu Minecraft + Tối ưu FPS mạnh
    =============================================
]]

local Players = game:GetService("Players")
local Lighting = game:GetService("Lighting")
local RunService = game:GetService("RunService")
local Stats = game:GetService("Stats")

local lp = Players.LocalPlayer

-- ====================== CẤU HÌNH ======================
local CONFIG = {
    UpdateInterval = 5,                    -- Giây cập nhật một lần
    Font = Enum.Font.Arcade,
    TextSize = 28,
    Position = UDim2.new(0, 10, 0, 10),   -- Góc trái trên
    Size = UDim2.new(0, 240, 0, 90),
    BackgroundTransparency = 0.35,
    MinecraftYellow = Color3.fromRGB(255, 255, 85),
}

-- ====================== FIX LAG + BRIGHT ======================
local function ApplyPerformanceOptimizations()
    -- Quality
    pcall(function()
        settings().Rendering.QualityLevel = Enum.QualityLevel.Level01
    end)

    -- Lighting
    pcall(function()
        Lighting.GlobalShadows = false
        Lighting.FogEnd = 1e10
        Lighting.Brightness = 2
        Lighting.ExposureCompensation = 0.4
        Lighting.Ambient = Color3.fromRGB(160, 160, 160)
        Lighting.OutdoorAmbient = Color3.fromRGB(160, 160, 160)
        Lighting.EnvironmentDiffuseScale = 0
        Lighting.EnvironmentSpecularScale = 0
    end)

    -- Remove unnecessary effects
    for _, v in pairs(Lighting:GetChildren()) do
        if v:IsA("PostEffect") or v:IsA("Sky") then
            v:Destroy()
        end
    end

    -- Optimize workspace
    for _, v in pairs(workspace:GetDescendants()) do
        if v:IsA("BasePart") then
            v.Material = Enum.Material.SmoothPlastic
            v.Reflectance = 0
            v.CastShadow = false
        elseif v:IsA("MeshPart") then
            v.TextureID = ""
            v.RenderFidelity = Enum.RenderFidelity.Performance
        elseif v:IsA("UnionOperation") then
            v.UsePartColor = true
        elseif v:IsA("Decal") or v:IsA("Texture") or v:IsA("SurfaceAppearance") then
            v:Destroy()
        elseif v:IsA("ParticleEmitter") or v:IsA("Trail") or v:IsA("Beam") or
               v:IsA("Fire") or v:IsA("Smoke") or v:IsA("Sparkles") then
            v.Enabled = false
        elseif v:IsA("Explosion") then
            v.Visible = false
        elseif v:IsA("Highlight") then
            v:Destroy()
        end
    end

    -- Mute sounds
    for _, v in pairs(game:GetDescendants()) do
        if v:IsA("Sound") then
            v.Volume = 0
            v.Playing = false
        end
    end
end

-- Ẩn Head & Accessories
local function HideSelf(char)
    for _, v in pairs(char:GetDescendants()) do
        if v:IsA("BasePart") and v.Name == "Head" then
            v.Transparency = 1
            if v:FindFirstChild("face") then
                v.face.Transparency = 1
            end
        elseif v:IsA("Accessory") then
            v:Destroy()
        end
    end
end

-- ====================== CREATE HUD ======================
local function CreateHUD()
    local screenGui = Instance.new("ScreenGui")
    screenGui.Name = "MinecraftFPSHUD"
    screenGui.ResetOnSpawn = false
    screenGui.Parent = lp:WaitForChild("PlayerGui")

    local fpsLabel = Instance.new("TextLabel")
    fpsLabel.Name = "FPSLabel"
    fpsLabel.Parent = screenGui
    fpsLabel.Position = CONFIG.Position
    fpsLabel.Size = CONFIG.Size
    fpsLabel.BackgroundTransparency = CONFIG.BackgroundTransparency
    fpsLabel.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    fpsLabel.TextStrokeTransparency = 0
    fpsLabel.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
    fpsLabel.TextXAlignment = Enum.TextXAlignment.Left
    fpsLabel.RichText = true
    fpsLabel.Font = CONFIG.Font
    fpsLabel.TextSize = CONFIG.TextSize
    fpsLabel.Text = "FPS: --\nPing: --ms"

    return fpsLabel
end

-- ====================== MAIN ======================
local function Main()
    ApplyPerformanceOptimizations()

    -- Hide character
    if lp.Character then HideSelf(lp.Character) end
    lp.CharacterAdded:Connect(function(c)
        task.wait(0.3)
        HideSelf(c)
    end)

    local fpsLabel = CreateHUD()

    local frames = 0
    local lastTime = tick()

    RunService.RenderStepped:Connect(function()
        frames += 1
        local currentTime = tick()

        if currentTime - lastTime >= CONFIG.UpdateInterval then
            local fps = math.floor(frames / CONFIG.UpdateInterval)

            -- Get Ping
            local ping = 0
            local pingStat = Stats.Network.ServerStatsItem("Data Ping")
            if pingStat then
                ping = math.floor(pingStat:GetValue())
            end

            -- Color
            local fpsColor = "#55FF55"
            if fps < 30 then
                fpsColor = "#FF5555"
            elseif fps < 55 then
                fpsColor = "#FFFF55"
            end

            fpsLabel.Text = string.format(
                '<font color="%s">FPS: %d</font>\n<font color="#FFAA00">Ping: %dms</font>',
                fpsColor, fps, ping
            )

            frames = 0
            lastTime = currentTime
        end
    end)
end

-- Run
Main()
