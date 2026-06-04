loadstring([[ 
-- tnghia hub v4.2 - Nút Toggle là Logo 1
local p = game.Players.LocalPlayer
local gui = Instance.new("ScreenGui") gui.ResetOnSpawn = false gui.Parent = p:WaitForChild("PlayerGui")

local settings = getgenv().tnghiaHub or {}
getgenv().tnghiaHub = settings

local hide = settings.Hide or true
local black = settings.Black or false
local perf = settings.Perf or false
local menuVisible = true

-- Black Screen
local bs = Instance.new("Frame", gui)
bs.Size = UDim2.new(1,0,1,0)
bs.BackgroundColor3 = Color3.new(0,0,0)
bs.BackgroundTransparency = black and 0 or 1
bs.Visible = black
bs.ZIndex = -1

-- Main Hub Frame
local f = Instance.new("Frame", gui)
f.Size = UDim2.new(0, 290, 0, 320)
f.Position = UDim2.new(0, 25, 0.5, -160)
f.BackgroundColor3 = Color3.fromRGB(15,15,20)
f.Active = true
f.Draggable = true

Instance.new("UICorner", f).CornerRadius = UDim.new(0,14)
local grad = Instance.new("UIGradient", f)
grad.Color = ColorSequence.new{ColorSequenceKeypoint.new(0, Color3.fromRGB(30,30,45)), ColorSequenceKeypoint.new(1, Color3.fromRGB(15,15,25))}
Instance.new("UIStroke", f).Thickness = 1.5; Instance.new("UIStroke", f).Color = Color3.fromRGB(0,255,200)

-- Logo trong Hub
local logoHub = Instance.new("ImageLabel", f)
logoHub.Size = UDim2.new(0,85,0,85)
logoHub.Position = UDim2.new(0,20,0,15)
logoHub.BackgroundTransparency = 1
logoHub.Image = "rbxassetid://16597012603"
logoHub.ImageColor3 = Color3.fromRGB(0,255,220)

-- Title
local title = Instance.new("TextLabel", f)
title.Size = UDim2.new(1,-120,0,50)
title.Position = UDim2.new(0,115,0,25)
title.BackgroundTransparency = 1
title.Text = "tnghia hub"
title.TextColor3 = Color3.fromRGB(0,255,200)
title.TextScaled = true
title.Font = Enum.Font.ArcaneBold

local acc = Instance.new("TextLabel", f)
acc.Size = UDim2.new(1,-120,0,22)
acc.Position = UDim2.new(0,115,0,70)
acc.BackgroundTransparency = 1
acc.Text = "👤 " .. p.Name
acc.TextColor3 = Color3.fromRGB(170,170,255)
acc.TextScaled = true
acc.Font = Enum.Font.GothamSemibold

-- Nút Toggle = Logo 1
local toggleBtn = Instance.new("ImageButton", gui)
toggleBtn.Size = UDim2.new(0, 60, 0, 60)
toggleBtn.Position = UDim2.new(0, 30, 0, 30)
toggleBtn.BackgroundTransparency = 1
toggleBtn.Image = "rbxassetid://16597012603"
toggleBtn.ImageColor3 = Color3.fromRGB(0, 255, 200)

Instance.new("UICorner", toggleBtn).CornerRadius = UDim.new(0, 30)
Instance.new("UIStroke", toggleBtn).Thickness = 2
Instance.new("UIStroke", toggleBtn).Color = Color3.fromRGB(0, 255, 255)

toggleBtn.MouseButton1Click:Connect(function()
    menuVisible = not menuVisible
    f.Visible = menuVisible
    toggleBtn.ImageColor3 = menuVisible and Color3.fromRGB(0, 255, 200) or Color3.fromRGB(100, 100, 100)
end)

-- Create Button
local function createBtn(y, text, colorOn)
    local btn = Instance.new("TextButton", f)
    btn.Size = UDim2.new(0.88,0,0,42)
    btn.Position = UDim2.new(0.06,0,y,0)
    btn.BackgroundColor3 = colorOn
    btn.Text = text
    btn.TextColor3 = Color3.new(1,1,1)
    btn.TextScaled = true
    btn.Font = Enum.Font.GothamBold
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0,10)
    return btn
end

local bHide = createBtn(105, "🗺️ Hide Map: " .. (hide and "ON" or "OFF"), hide and Color3.fromRGB(0,200,100) or Color3.fromRGB(200,50,50))
local bBlack = createBtn(155, "🌑 Black Screen: " .. (black and "ON" or "OFF"), black and Color3.fromRGB(0,170,100) or Color3.fromRGB(170,50,50))
local bPerf = createBtn(205, "⚡ Tăng FPS: " .. (perf and "ON" or "OFF"), perf and Color3.fromRGB(0,170,100) or Color3.fromRGB(170,50,50))

bHide.MouseButton1Click:Connect(function()
    hide = not hide
    bHide.Text = "🗺️ Hide Map: " .. (hide and "ON" or "OFF")
    bHide.BackgroundColor3 = hide and Color3.fromRGB(0,200,100) or Color3.fromRGB(200,50,50)
    settings.Hide = hide
    for _,v in workspace:GetDescendants() do pcall(function() if v:IsA("BasePart") or v:IsA("MeshPart") then v.Transparency = hide and 1 or 0 end end) end
end)

bBlack.MouseButton1Click:Connect(function()
    black = not black
    bBlack.Text = "🌑 Black Screen: " .. (black and "ON" or "OFF")
    bBlack.BackgroundColor3 = black and Color3.fromRGB(0,170,100) or Color3.fromRGB(170,50,50)
    bs.Visible = black
    bs.BackgroundTransparency = black and 0 or 1
    settings.Black = black
end)

bPerf.MouseButton1Click:Connect(function()
    perf = not perf
    bPerf.Text = "⚡ Tăng FPS: " .. (perf and "ON" or "OFF")
    bPerf.BackgroundColor3 = perf and Color3.fromRGB(0,170,100) or Color3.fromRGB(170,50,50)
    settings.Perf = perf
    if perf then pcall(function() settings().Rendering.QualityLevel = Enum.QualityLevel.Level01 game.Lighting.GlobalShadows = false game.Lighting.FogEnd = 999999 end) end
end)

-- FPS + Time
local fps = Instance.new("TextLabel", f)
fps.Size = UDim2.new(0.88,0,0,48)
fps.Position = UDim2.new(0.06,0,0,255)
fps.BackgroundTransparency = 0.8
fps.BackgroundColor3 = Color3.fromRGB(10,10,15)
fps.TextScaled = true
fps.Font = Enum.Font.GothamBold
fps.TextColor3 = Color3.fromRGB(255,255,255)
Instance.new("UICorner", fps).CornerRadius = UDim.new(0,10)

local colors = {255,0,0,255,165,0,255,255,0,0,255,0,0,255,255,0,0,255}
task.spawn(function()
    local i=1 while true do fps.TextColor3 = Color3.fromRGB(colors[i],colors[i+1],colors[i+2]) i=(i+2)%#colors+1 task.wait(0.17) end
end)

local st = tick()
game:GetService("RunService").RenderStepped:Connect(function(dt)
    local e = math.floor(tick()-st)
    fps.Text = string.format("FPS: %d\nTIME: %02d:%02d:%02d", math.floor(1/dt), e//3600, (e%3600)//60, e%60)
end)

-- Auto Jump
task.spawn(function() while true do task.wait(300) local h = p.Character and p.Character:FindFirstChildOfClass("Humanoid") if h and h.Health > 0 then h.Jump = true end end end)

-- Initial Apply
for _,v in workspace:GetDescendants() do pcall(function() if v:IsA("BasePart") or v:IsA("MeshPart") then v.Transparency = hide and 1 or 0 end end) end

game.StarterGui:SetCore("SendNotification", {Title="tnghia hub v4.2"; Text="Nút toggle là Logo 1!\nNhấn logo để ẩn/hiện menu."; Duration=7;})
print("✅ tnghia hub v4.2 Loaded!")
]])()
