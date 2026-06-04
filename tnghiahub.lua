# tnghia-hub
Fix Lag tnghia hub
loadstring([[ 
-- tnghia hub
for _,v in next,workspace:GetDescendants()do pcall(function()if v:IsA("BasePart")or v:IsA("MeshPart")then v.Transparency=1 end end)end
for _,v in next,getnilinstances()do pcall(function()if v:IsA("BasePart")or v:IsA("MeshPart")then v.Transparency=1 end end)end
workspace.DescendantAdded:Connect(function(v)pcall(function()if v:IsA("BasePart")or v:IsA("MeshPart")then v.Transparency=1 end end)end)

local p=game.Players.LocalPlayer
local g=Instance.new("ScreenGui")g.ResetOnSpawn=false g.Parent=p:WaitForChild("PlayerGui")

local t=Instance.new("TextLabel")t.Size=UDim2.new(0,200,0,30)t.Position=UDim2.new(0,15,0,15)t.BackgroundTransparency=0.3 t.BackgroundColor3=Color3.fromRGB(0,0,0)t.Text="tnghia hub"t.TextColor3=Color3.fromRGB(0,255,255)t.TextScaled=true t.Font=Enum.Font.GothamBold t.Active=true t.Draggable=true t.Parent=g

local l=Instance.new("TextLabel")l.Size=UDim2.new(0,200,0,70)l.Position=UDim2.new(0,15,0,45)l.BackgroundTransparency=0.35 l.BackgroundColor3=Color3.fromRGB(0,0,0)l.TextScaled=true l.Font=Enum.Font.GothamBold l.TextColor3=Color3.fromRGB(255,255,255)l.Active=true l.Draggable=true l.Parent=g

local c={255,0,0,255,165,0,255,255,0,0,255,0,0,255,255,0,0,255,128,0,128}
task.spawn(function()local i=1 while true do l.TextColor3=Color3.fromRGB(c[i],c[i+1],c[i+2])i=(i+2)%#c+1 task.wait(0.25)end end)

local s=tick()game:GetService("RunService").RenderStepped:Connect(function(dt)local e=math.floor(tick()-s)l.Text=string.format("FPS: %d\nTIME: %02d:%02d:%02d",math.floor(1/dt),e//3600,(e%3600)//60,e%60)end)

task.spawn(function()while true do task.wait(300)local h=p.Character and p.Character:FindFirstChildOfClass("Humanoid")if h and h.Health>0 then h.Jump=true end end end)

print("✅ tnghia hub")
]])()
