local RS, Stats, Plrs, VU = game:GetService("RunService"), game:GetService("Stats"), game:GetService("Players"), game:GetService("VirtualUser")
local LP = Plrs.LocalPlayer

-- UI Chính
local gui = Instance.new("ScreenGui", LP:WaitForChild("PlayerGui"))
gui.Name, gui.ResetOnSpawn, gui.IgnoreGuiInset = "BlackScreenUI", false, true

-- Màn hình đen
local frame = Instance.new("Frame", gui)
frame.Size, frame.BackgroundColor3, frame.BorderSizePixel, frame.ZIndex = UDim2.new(1, 0, 1, 0), Color3.fromRGB(0, 0, 0), 0, 1

-- Nút Bật/Tắt
local btn = Instance.new("TextButton", gui)
btn.Size, btn.Position, btn.BackgroundColor3, btn.BorderSizePixel, btn.TextColor3, btn.Text, btn.TextSize, btn.Font, btn.ZIndex =
    UDim2.new(0, 36, 0, 36),
    UDim2.new(0, 15, 0, 110),
    Color3.fromRGB(0, 170, 100),
    0,
    Color3.fromRGB(255, 255, 255),
    "ON",
    12,
    Enum.Font.SourceSansBold,
    2

local btnCorner = Instance.new("UICorner", btn)
btnCorner.CornerRadius = UDim.new(1, 0)

-- Bảng FPS & Ping
local txt = Instance.new("TextLabel", gui)
txt.Size, txt.Position, txt.BackgroundColor3, txt.BackgroundTransparency, txt.BorderSizePixel, txt.Font, txt.TextSize, txt.ZIndex =
    UDim2.new(0, 135, 0, 30),
    UDim2.new(0, 56, 0, 113),
    Color3.fromRGB(15, 15, 15),
    0.3,
    0,
    Enum.Font.SourceSansBold,
    13,
    2

local txtCorner = Instance.new("UICorner", txt)
txtCorner.CornerRadius = UDim.new(0, 6)

-- Trạng thái Anti-AFK
local afkTxt = Instance.new("TextLabel", gui)
afkTxt.Size = UDim2.new(0, 135, 0, 25)
afkTxt.Position = UDim2.new(0, 56, 0, 145)
afkTxt.BackgroundTransparency = 1
afkTxt.Text = "Anti-AFK: ON"
afkTxt.TextColor3 = Color3.fromRGB(0, 255, 100)
afkTxt.TextSize = 12
afkTxt.Font = Enum.Font.SourceSansBold
afkTxt.ZIndex = 2

-- Toggle Màn Đen
btn.MouseButton1Click:Connect(function()
    frame.Visible = not frame.Visible
    btn.Text = frame.Visible and "OFF" or "ON"
    btn.BackgroundColor3 = frame.Visible and Color3.fromRGB(30, 30, 30) or Color3.fromRGB(0, 170, 100)
end)

-- Anti-AFK
local antiAFK = true

LP.Idled:Connect(function()
    if antiAFK then
        afkTxt.Text = "Anti-AFK: ACTIVE"
        afkTxt.TextColor3 = Color3.fromRGB(255, 255, 0)

        VU:CaptureController()
        VU:ClickButton2(Vector2.new(0, 0))

        task.delay(2, function()
            if afkTxt then
                afkTxt.Text = "Anti-AFK: ON"
                afkTxt.TextColor3 = Color3.fromRGB(0, 255, 100)
            end
        end)
    end
end)

-- Auto Jump mỗi 5 phút
task.spawn(function()
    while true do
        task.wait(300)

        local character = LP.Character
        local humanoid = character and character:FindFirstChildOfClass("Humanoid")

        if humanoid then
            humanoid.Jump = true
        end
    end
end)

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
