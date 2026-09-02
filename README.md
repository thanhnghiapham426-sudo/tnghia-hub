local RS, Stats, Plrs, VU = game:GetService("RunService"), game:GetService("Stats"), game:GetService("Players"), game:GetService("VirtualUser")
local LP = Plrs.LocalPlayer

-- UI Chính
local gui = Instance.new("ScreenGui", LP:WaitForChild("PlayerGui"))
gui.Name, gui.ResetOnSpawn, gui.IgnoreGuiInset = "BlackScreenUI", false, true

-- Màn hình đen
local frame = Instance.new("Frame", gui)
frame.Size, frame.BackgroundColor3, frame.BorderSizePixel, frame.ZIndex = UDim2.new(1, 0, 1, 0), Color3.fromRGB(0, 0, 0), 0, 1

-- Nút Bật/Tắt (Hình tròn) - Hạ Y xuống 110 để tránh vướng menu
local btn = Instance.new("TextButton", gui)
btn.Size, btn.Position, btn.BackgroundColor3, btn.BorderSizePixel, btn.TextColor3, btn.Text, btn.TextSize, btn.Font, btn.ZIndex = UDim2.new(0, 36, 0, 36), UDim2.new(0, 15, 0, 110), Color3.fromRGB(0, 170, 100), 0, Color3.fromRGB(255, 255, 255), "ON", 12, Enum.Font.SourceSansBold, 2

local btnCorner = Instance.new("UICorner", btn)
btnCorner.CornerRadius = UDim.new(1, 0)

-- Bảng FPS & Ping - Hạ Y xuống 113 để căn hàng ngang với nút
local txt = Instance.new("TextLabel", gui)
txt.Size, txt.Position, txt.BackgroundColor3, txt.BackgroundTransparency, txt.BorderSizePixel, txt.Font, txt.TextSize, txt.ZIndex = UDim2.new(0, 135, 0, 30), UDim2.new(0, 56, 0, 113), Color3.fromRGB(15, 15, 15), 0.3, 0, Enum.Font.SourceSansBold, 13, 2

local txtCorner = Instance.new("UICorner", txt)
txtCorner.CornerRadius = UDim.new(0, 6)

-- Toggle Màn Đen
btn.MouseButton1Click:Connect(function()
    frame.Visible = not frame.Visible
    btn.Text = frame.Visible and "OFF" or "ON"
    btn.BackgroundColor3 = frame.Visible and Color3.fromRGB(30, 30, 30) or Color3.fromRGB(0, 170, 100)
end)

-- Anti-AFK
LP.Idled:Connect(function() VU:CaptureController() VU:ClickButton2(Vector2.zero) end)

-- Loop FPS, Ping & RGB 7 màu
local hue, frames, last = 0, 0, os.clock()
RS.RenderStepped:Connect(function(dt)
    hue = (hue + dt * 0.2) % 1
    txt.TextColor3 = Color3.fromHSV(hue, 1, 1)
    
    frames = frames + 1
    local now = os.clock()
    if now - last >= 0.5 then
        local fps = math.floor(frames / (now - last))
        local ping = math.floor(Stats.Network.ServerStatsItem["Data Ping"]:GetValue())
        txt.Text = string.format("FPS: %d | Ping: %d ms", fps, ping)
        frames, last = 0, now
    end
end)
