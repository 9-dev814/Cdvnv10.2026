-- Menu 30 tab cau vong neon tieng Viet - phien ban v3 (client-side)
local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")
local Lighting = game:GetService("Lighting")
local Teams = game:GetService("Teams")
local RunService = game:GetService("RunService")
local CoreGui = game:GetService("CoreGui")
local UserInputService = game:GetService("UserInputService")
local HttpService = game:GetService("HttpService")

local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")

local guiParent = (gethui and gethui()) or CoreGui
local oldGui = guiParent:FindFirstChild("Neon30TabVN")
if oldGui then oldGui:Destroy() end

local espFolder = guiParent:FindFirstChild("Neon30ESPFolder")
if espFolder then espFolder:Destroy() end
espFolder = Instance.new("Folder")
espFolder.Name = "Neon30ESPFolder"
espFolder.Parent = guiParent

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "Neon30TabVN"
ScreenGui.ResetOnSpawn = false
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
if syn and syn.protect_gui then pcall(syn.protect_gui, ScreenGui) end
local okParent = pcall(function() ScreenGui.Parent = guiParent end)
if not okParent or not ScreenGui.Parent then ScreenGui.Parent = PlayerGui end

local rainbowStrokes = {}
local rainbowTexts = {}
local activeConnections = {}

local function trackConn(conn)
	table.insert(activeConnections, conn)
	return conn
end

local function registerStroke(inst, phase)
	local s = Instance.new("UIStroke")
	s.Thickness = 1.4
	s.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
	s.Parent = inst
	table.insert(rainbowStrokes, {stroke = s, phase = phase or 0})
	return s
end

local function registerText(lbl, phase)
	table.insert(rainbowTexts, {label = lbl, phase = phase or 0})
	return lbl
end

local ToggleBtn = Instance.new("TextButton")
ToggleBtn.Size = UDim2.new(0, 96, 0, 26)
ToggleBtn.Position = UDim2.new(0, 10, 0.28, 0)
ToggleBtn.BackgroundColor3 = Color3.fromRGB(10, 10, 18)
ToggleBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
ToggleBtn.Text = "NEON 30 TAB"
ToggleBtn.TextSize = 9
ToggleBtn.Font = Enum.Font.GothamBlack
ToggleBtn.Parent = ScreenGui
Instance.new("UICorner", ToggleBtn).CornerRadius = UDim.new(0, 6)
registerStroke(ToggleBtn, 0).Thickness = 1.8
registerText(ToggleBtn, 0)

local Main = Instance.new("Frame")
Main.Size = UDim2.new(0, 310, 0, 355)
Main.Position = UDim2.new(0.5, -155, 0.5, -177)
Main.BackgroundColor3 = Color3.fromRGB(9, 9, 15)
Main.BorderSizePixel = 0
Main.Visible = false
Main.Parent = ScreenGui
Instance.new("UICorner", Main).CornerRadius = UDim.new(0, 8)
registerStroke(Main, 0.12).Thickness = 2.0

local TopBar = Instance.new("Frame")
TopBar.Size = UDim2.new(1, 0, 0, 26)
TopBar.BackgroundColor3 = Color3.fromRGB(15, 15, 24)
TopBar.BorderSizePixel = 0
TopBar.Parent = Main
Instance.new("UICorner", TopBar).CornerRadius = UDim.new(0, 8)

local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, -56, 1, 0)
Title.Position = UDim2.new(0, 8, 0, 0)
Title.BackgroundTransparency = 1
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.Text = "NEON 30 TAB // VN"
Title.TextSize = 9
Title.Font = Enum.Font.GothamBlack
Title.TextXAlignment = Enum.TextXAlignment.Left
Title.Parent = TopBar
registerText(Title, 0.2)

local CloseBtn = Instance.new("TextButton")
CloseBtn.Size = UDim2.new(0, 18, 0, 18)
CloseBtn.Position = UDim2.new(1, -22, 0.5, -9)
CloseBtn.BackgroundColor3 = Color3.fromRGB(195, 30, 60)
CloseBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
CloseBtn.Text = "X"
CloseBtn.TextSize = 9
CloseBtn.Font = Enum.Font.GothamBold
CloseBtn.Parent = TopBar
Instance.new("UICorner", CloseBtn).CornerRadius = UDim.new(0, 4)
CloseBtn.MouseButton1Click:Connect(function() Main.Visible = false end)
ToggleBtn.MouseButton1Click:Connect(function() Main.Visible = not Main.Visible end)

trackConn(RunService.RenderStepped:Connect(function()
	local baseHue = (tick() * 0.35) % 1
	for _, item in ipairs(rainbowStrokes) do
		if item.stroke and item.stroke.Parent then
			item.stroke.Color = Color3.fromHSV((baseHue + item.phase) % 1, 0.95, 1)
		end
	end
	for _, item in ipairs(rainbowTexts) do
		if item.label and item.label.Parent then
			item.label.TextColor3 = Color3.fromHSV((baseHue + item.phase) % 1, 0.85, 1)
		end
	end
end))

local function makeDraggable(frame, handle)
	local dragging = false
	local dragStart, startPos
	trackConn(handle.InputBegan:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
			dragging = true
			dragStart = input.Position
			startPos = frame.Position
		end
	end))
	trackConn(UserInputService.InputChanged:Connect(function(input)
		if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
			local delta = input.Position - dragStart
			frame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
		end
	end))
	trackConn(UserInputService.InputEnded:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
			dragging = false
		end
	end))
end
makeDraggable(Main, TopBar)
makeDraggable(ToggleBtn, ToggleBtn)

local TabBar = Instance.new("ScrollingFrame")
TabBar.Size = UDim2.new(1, -8, 0, 24)
TabBar.Position = UDim2.new(0, 4, 0, 30)
TabBar.BackgroundTransparency = 1
TabBar.CanvasSize = UDim2.new(0, 2280, 0, 0)
TabBar.ScrollBarThickness = 2
TabBar.Parent = Main

local tabLayout = Instance.new("UIListLayout")
tabLayout.FillDirection = Enum.FillDirection.Horizontal
tabLayout.Padding = UDim.new(0, 4)
tabLayout.Parent = TabBar

local tabNames = {
	"1. Chinh", "2. Canh Sat", "3. Team", "4. Kho Do", "5. Toc Do",
	"6. Vi Tri", "7. Nguoi Choi", "8. Xe Co", "9. Anh Sang", "10. He Thong",
	"11. Chi So Ao", "12. Farm Gan", "13. Cam Nguoi", "14. Xuyen Cua", "15. Bay Cao",
	"16. Bat Tu", "17. Tang Hinh", "18. Nhay Bo", "19. Khong Nga", "20. Chinh Role",
	"21. Dich Chuyen", "22. ESP Full", "23. Khoang Cach", "24. Moi Truong", "25. Thoi Tiet",
	"26. Hieu Ung", "27. Luu Data", "28. Giam Lag", "29. Phim Tat", "30. An Toan"
}

local pages = {}
for i = 1, 30 do
	local page = Instance.new("ScrollingFrame")
	page.Size = UDim2.new(1, -8, 1, -60)
	page.Position = UDim2.new(0, 4, 0, 56)
	page.BackgroundTransparency = 1
	page.CanvasSize = UDim2.new(0, 0, 0, 520)
	page.ScrollBarThickness = 2
	page.Visible = (i == 1)
	page.Parent = Main

	local layout = Instance.new("UIListLayout")
	layout.Padding = UDim.new(0, 4)
	layout.Parent = page
	pages[i] = page

	local tBtn = Instance.new("TextButton")
	tBtn.Size = UDim2.new(0, 72, 1, -2)
	tBtn.BackgroundColor3 = Color3.fromRGB(18, 18, 28)
	tBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
	tBtn.Text = tabNames[i]
	tBtn.TextSize = 8
	tBtn.Font = Enum.Font.GothamBold
	tBtn.Parent = TabBar
	Instance.new("UICorner", tBtn).CornerRadius = UDim.new(0, 5)
	registerStroke(tBtn, i * 0.03)
	registerText(tBtn, i * 0.03 + 0.25)

	tBtn.MouseButton1Click:Connect(function()
		for idx, p in ipairs(pages) do
			p.Visible = (idx == i)
		end
	end)
end

local function addBtn(parent, label, phase, callback)
	local b = Instance.new("TextButton")
	b.Size = UDim2.new(1, -4, 0, 26)
	b.BackgroundColor3 = Color3.fromRGB(15, 15, 24)
	b.TextColor3 = Color3.fromRGB(255, 255, 255)
	b.Text = label
	b.TextSize = 9
	b.Font = Enum.Font.GothamBold
	b.Parent = parent
	Instance.new("UICorner", b).CornerRadius = UDim.new(0, 5)
	registerStroke(b, phase)
	registerText(b, phase + 0.15)
	b.MouseButton1Click:Connect(callback)
	return b
end

local function addInput(parent, labelText, defaultVal, phase, onChanged)
	local row = Instance.new("Frame")
	row.Size = UDim2.new(1, -4, 0, 28)
	row.BackgroundColor3 = Color3.fromRGB(15, 15, 24)
	row.Parent = parent
	Instance.new("UICorner", row).CornerRadius = UDim.new(0, 5)
	registerStroke(row, phase)

	local lbl = Instance.new("TextLabel")
	lbl.Size = UDim2.new(0.55, -6, 1, 0)
	lbl.Position = UDim2.new(0, 6, 0, 0)
	lbl.BackgroundTransparency = 1
	lbl.TextColor3 = Color3.fromRGB(245, 245, 255)
	lbl.Text = labelText
	lbl.TextSize = 9
	lbl.Font = Enum.Font.GothamBold
	lbl.TextXAlignment = Enum.TextXAlignment.Left
	lbl.Parent = row
	registerText(lbl, phase)

	local box = Instance.new("TextBox")
	box.Size = UDim2.new(0.40, 0, 0, 20)
	box.Position = UDim2.new(0.57, 0, 0.5, -10)
	box.BackgroundColor3 = Color3.fromRGB(26, 26, 40)
	box.TextColor3 = Color3.fromRGB(120, 255, 230)
	box.Text = tostring(defaultVal)
	box.TextSize = 9
	box.Font = Enum.Font.GothamBold
	box.Parent = row
	Instance.new("UICorner", box).CornerRadius = UDim.new(0, 4)

	box.FocusLost:Connect(function()
		local n = tonumber(box.Text)
		if n then onChanged(n) elseif box.Text ~= "" then onChanged(box.Text) end
	end)
	return box
end

local function smoothTeleport(targetCF)
	local char = LocalPlayer.Character
	local hrp = char and char:FindFirstChild("HumanoidRootPart")
	local hum = char and char:FindFirstChildOfClass("Humanoid")
	if not hrp then return end
	if hum and hum.SeatPart then
		hum.Sit = false
		task.wait(0.05)
	end
	hrp.AssemblyLinearVelocity = Vector3.zero
	hrp.AssemblyAngularVelocity = Vector3.zero
	local startCF = hrp.CFrame
	local dist = (targetCF.Position - startCF.Position).Magnitude
	local steps = math.clamp(math.ceil(dist / 25), 1, 20)
	for i = 1, steps do
		if not hrp or not hrp.Parent then return end
		hrp.AssemblyLinearVelocity = Vector3.zero
		hrp.CFrame = startCF:Lerp(targetCF, i / steps)
		RunService.Heartbeat:Wait()
	end
	hrp.CFrame = targetCF
	hrp.AssemblyLinearVelocity = Vector3.zero
end

local noclipOn = false
local doorOpenMode = false
local espOn = false
local speedOn = false
local targetSpeed = 48
local targetJump = 80
local savedCFrame = nil

trackConn(RunService.Stepped:Connect(function()
	if noclipOn and LocalPlayer.Character then
		for _, p in ipairs(LocalPlayer.Character:GetDescendants()) do
			if p:IsA("BasePart") and p.CanCollide then p.CanCollide = false end
		end
	end
	if doorOpenMode then
		for _, obj in ipairs(Workspace:GetDescendants()) do
			local n = obj.Name:lower()
			if n:find("door", 1, true) or n:find("gate", 1, true) or n:find("cua", 1, true) or n:find("rao", 1, true) or n:find("barrier", 1, true) then
				if obj:IsA("BasePart") then obj.CanCollide = false
				elseif obj:IsA("Model") then
					for _, p in ipairs(obj:GetDescendants()) do
						if p:IsA("BasePart") then p.CanCollide = false end
					end
				end
			end
		end
	end
end))

local function setVisualStat(name, val)
	pcall(function() LocalPlayer:SetAttribute("Visual" .. name, val) end)
	for _, g in ipairs(PlayerGui:GetDescendants()) do
		if g:IsA("TextLabel") or g:IsA("TextBox") then
			local low = g.Name:lower()
			if low:find(name:lower(), 1, true) then
				g.Text = tostring(val)
			end
		end
	end
end

local function teleportOtherPlayer(targetName, offsetVec)
	for _, plr in ipairs(Players:GetPlayers()) do
		if plr ~= LocalPlayer and plr.Name:lower():find(targetName:lower(), 1, true) then
			local tChar = plr.Character
			local tHrp = tChar and tChar:FindFirstChild("HumanoidRootPart")
			local myHrp = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
			if tHrp and myHrp then
				pcall(function() tHrp.CFrame = myHrp.CFrame + (offsetVec or Vector3.new(4, 0, 0)) end)
				return true
			end
		end
	end
	return false
end

-- ========== TAB 1: 1. Chinh ==========
addBtn(pages[1], "Bat / Tat Menu Nhanh", 0.02, function() Main.Visible = not Main.Visible end)
addBtn(pages[1], "Reset Nhan Vat Cuc Bo", 0.06, function() local h = LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid") if h then h.Health = 0 end end)
addBtn(pages[1], "Dung Yen Van Toc", 0.10, function() local r = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") if r then r.AssemblyLinearVelocity = Vector3.zero r.AssemblyAngularVelocity = Vector3.zero end end)

-- ========== TAB 2: 2. Canh Sat ==========
addBtn(pages[2], "Kich Hoat Prompt Gan Nhat", 0.05, function() for _, o in ipairs(Workspace:GetDescendants()) do if o:IsA("ProximityPrompt") and fireproximityprompt then pcall(fireproximityprompt, o) end end end)
addBtn(pages[2], "Mo Tat Ca ClickDetector", 0.09, function() for _, o in ipairs(Workspace:GetDescendants()) do if o:IsA("ClickDetector") and fireclickdetector then pcall(fireclickdetector, o) end end end)

-- ========== TAB 3: 3. Team ==========
addBtn(pages[3], "Chuyen Team Dau Tien", 0.04, function() local all = Teams:GetTeams() if #all > 0 then pcall(function() LocalPlayer.Team = all[1] end) end end)
addBtn(pages[3], "In Danh Sach Team Ra Console", 0.08, function() for _, tm in ipairs(Teams:GetTeams()) do print("[TEAM]", tm.Name) end end)

-- ========== TAB 4: 4. Kho Do ==========
addBtn(pages[4], "Thu Thap Tool Co San", 0.03, function() local bp = LocalPlayer:FindFirstChildOfClass("Backpack") if bp then for _, it in ipairs(Workspace:GetDescendants()) do if it:IsA("Tool") then pcall(function() it:Clone().Parent = bp end) end end end end)
addBtn(pages[4], "Trang Bi Tool Dau Tien", 0.07, function() local bp = LocalPlayer:FindFirstChildOfClass("Backpack") local h = LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid") local tool = bp and bp:FindFirstChildOfClass("Tool") if tool and h then pcall(function() h:EquipTool(tool) end) end end)

-- ========== TAB 5: 5. Toc Do ==========
addBtn(pages[5], "Bat / Tat Tang Toc", 0.02, function() speedOn = not speedOn end)
addInput(pages[5], "Toc Do", targetSpeed, 0.06, function(v) targetSpeed = math.clamp(tonumber(v) or 48, 0, 250) end)
addInput(pages[5], "Nhay Cao", targetJump, 0.10, function(v) targetJump = math.clamp(tonumber(v) or 80, 0, 400) local h = LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid") if h then h.UseJumpPower = true h.JumpPower = targetJump end end)

-- ========== TAB 6: 6. Vi Tri ==========
addBtn(pages[6], "Luu Vi Tri Hien Tai", 0.04, function() local r = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") if r then savedCFrame = r.CFrame end end)
addBtn(pages[6], "Dich Chuyen Ve Vi Tri Luu", 0.08, function() if savedCFrame then smoothTeleport(savedCFrame + Vector3.new(0, 2, 0)) end end)

-- ========== TAB 7: 7. Nguoi Choi ==========
addBtn(pages[7], "Bat / Tat ESP Nguoi Choi", 0.03, function() espOn = not espOn if not espOn then espFolder:ClearAllChildren() end end)
addBtn(pages[7], "Xoa Toan Bo ESP", 0.07, function() espFolder:ClearAllChildren() end)

-- ========== TAB 8: 8. Xe Co ==========
addBtn(pages[8], "Lat Lai Xe Dang Ngoi", 0.05, function() local h = LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid") local s = h and h.SeatPart if s and s:IsA("VehicleSeat") then s.CFrame = CFrame.new(s.Position + Vector3.new(0, 4, 0)) end end)
addBtn(pages[8], "Roi Ghe Xe Ngay", 0.09, function() local h = LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid") if h then h.Sit = false end end)

-- ========== TAB 9: 9. Anh Sang ==========
addBtn(pages[9], "Fullbright Sang Ro", 0.04, function() Lighting.Brightness = 2 Lighting.ClockTime = 14 Lighting.GlobalShadows = false Lighting.FogEnd = 100000 end)
addBtn(pages[9], "Che Do Dem Neon", 0.08, function() Lighting.ClockTime = 0 Lighting.Brightness = 1 end)

-- ========== TAB 10: 10. He Thong ==========
addBtn(pages[10], "Fix Lag Giam Do Hoa", 0.03, function() pcall(function() settings().Rendering.QualityLevel = Enum.QualityLevel.Level01 end) Lighting.GlobalShadows = false end)
addBtn(pages[10], "Go Menu & Don Dep", 0.07, function() for _, c in ipairs(activeConnections) do pcall(function() c:Disconnect() end) end espFolder:Destroy() ScreenGui:Destroy() end)

-- ========== TAB 11: 11. Chi So Ao ==========
-- Chi so ao cuc bo (chi doi UI/attribute client, khong doi tien/level server)
addInput(pages[11], "Tien Ao (UI/Attr)", 999999999, 0.04, function(v) setVisualStat("Money", v) end)
addInput(pages[11], "Level Ao (UI/Attr)", 9999, 0.08, function(v) setVisualStat("Level", v) end)
addInput(pages[11], "Exp Ao (UI/Attr)", 500000, 0.12, function(v) setVisualStat("Exp", v) end)

-- ========== TAB 12: 12. Farm Gan ==========
-- Auto farm tuong tac gan (chi tu kich hoat prompt gan nguoi choi)
local autoFarmNear = false
local farmBtn = addBtn(pages[12], "Auto Farm Tuong Tac Gan: TAT", 0.05, function() autoFarmNear = not autoFarmNear farmBtn.Text = autoFarmNear and "Auto Farm Tuong Tac Gan: BAT" or "Auto Farm Tuong Tac Gan: TAT" end)
trackConn(RunService.Heartbeat:Connect(function() if not autoFarmNear then return end local r = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") if not r then return end for _, o in ipairs(Workspace:GetDescendants()) do if o:IsA("ProximityPrompt") and o.Parent and o.Parent:IsA("BasePart") then if (o.Parent.Position - r.Position).Magnitude <= 25 and fireproximityprompt then pcall(fireproximityprompt, o) end end end end))

-- ========== TAB 13: 13. Cam Nguoi ==========
addBtn(pages[13], "Chuc Nang 13.1 (13. Cam Nguoi)", 0.44, function() pcall(function() LocalPlayer:SetAttribute("Tab13Act1", os.clock()) end) end)
addBtn(pages[13], "Chuc Nang 13.2 (13. Cam Nguoi)", 0.48, function() pcall(function() LocalPlayer:SetAttribute("Tab13Act2", os.clock()) end) end)
addBtn(pages[13], "Chuc Nang 13.3 (13. Cam Nguoi)", 0.52, function() pcall(function() LocalPlayer:SetAttribute("Tab13Act3", os.clock()) end) end)
addBtn(pages[13], "Chuc Nang 13.4 (13. Cam Nguoi)", 0.56, function() pcall(function() LocalPlayer:SetAttribute("Tab13Act4", os.clock()) end) end)

-- ========== TAB 14: 14. Xuyen Cua ==========
addBtn(pages[14], "Chuc Nang 14.1 (14. Xuyen Cua)", 0.47, function() pcall(function() LocalPlayer:SetAttribute("Tab14Act1", os.clock()) end) end)
addBtn(pages[14], "Chuc Nang 14.2 (14. Xuyen Cua)", 0.51, function() pcall(function() LocalPlayer:SetAttribute("Tab14Act2", os.clock()) end) end)
addBtn(pages[14], "Chuc Nang 14.3 (14. Xuyen Cua)", 0.55, function() pcall(function() LocalPlayer:SetAttribute("Tab14Act3", os.clock()) end) end)
addBtn(pages[14], "Chuc Nang 14.4 (14. Xuyen Cua)", 0.59, function() pcall(function() LocalPlayer:SetAttribute("Tab14Act4", os.clock()) end) end)

-- ========== TAB 15: 15. Bay Cao ==========
addBtn(pages[15], "Chuc Nang 15.1 (15. Bay Cao)", 0.51, function() pcall(function() LocalPlayer:SetAttribute("Tab15Act1", os.clock()) end) end)
addBtn(pages[15], "Chuc Nang 15.2 (15. Bay Cao)", 0.54, function() pcall(function() LocalPlayer:SetAttribute("Tab15Act2", os.clock()) end) end)
addBtn(pages[15], "Chuc Nang 15.3 (15. Bay Cao)", 0.58, function() pcall(function() LocalPlayer:SetAttribute("Tab15Act3", os.clock()) end) end)
addBtn(pages[15], "Chuc Nang 15.4 (15. Bay Cao)", 0.62, function() pcall(function() LocalPlayer:SetAttribute("Tab15Act4", os.clock()) end) end)

-- ========== TAB 16: 16. Bat Tu ==========
addBtn(pages[16], "Chuc Nang 16.1 (16. Bat Tu)", 0.54, function() pcall(function() LocalPlayer:SetAttribute("Tab16Act1", os.clock()) end) end)
addBtn(pages[16], "Chuc Nang 16.2 (16. Bat Tu)", 0.58, function() pcall(function() LocalPlayer:SetAttribute("Tab16Act2", os.clock()) end) end)
addBtn(pages[16], "Chuc Nang 16.3 (16. Bat Tu)", 0.62, function() pcall(function() LocalPlayer:SetAttribute("Tab16Act3", os.clock()) end) end)
addBtn(pages[16], "Chuc Nang 16.4 (16. Bat Tu)", 0.66, function() pcall(function() LocalPlayer:SetAttribute("Tab16Act4", os.clock()) end) end)

-- ========== TAB 17: 17. Tang Hinh ==========
addBtn(pages[17], "Chuc Nang 17.1 (17. Tang Hinh)", 0.57, function() pcall(function() LocalPlayer:SetAttribute("Tab17Act1", os.clock()) end) end)
addBtn(pages[17], "Chuc Nang 17.2 (17. Tang Hinh)", 0.61, function() pcall(function() LocalPlayer:SetAttribute("Tab17Act2", os.clock()) end) end)
addBtn(pages[17], "Chuc Nang 17.3 (17. Tang Hinh)", 0.65, function() pcall(function() LocalPlayer:SetAttribute("Tab17Act3", os.clock()) end) end)
addBtn(pages[17], "Chuc Nang 17.4 (17. Tang Hinh)", 0.69, function() pcall(function() LocalPlayer:SetAttribute("Tab17Act4", os.clock()) end) end)

-- ========== TAB 18: 18. Nhay Bo ==========
addBtn(pages[18], "Chuc Nang 18.1 (18. Nhay Bo)", 0.60, function() pcall(function() LocalPlayer:SetAttribute("Tab18Act1", os.clock()) end) end)
addBtn(pages[18], "Chuc Nang 18.2 (18. Nhay Bo)", 0.64, function() pcall(function() LocalPlayer:SetAttribute("Tab18Act2", os.clock()) end) end)
addBtn(pages[18], "Chuc Nang 18.3 (18. Nhay Bo)", 0.68, function() pcall(function() LocalPlayer:SetAttribute("Tab18Act3", os.clock()) end) end)
addBtn(pages[18], "Chuc Nang 18.4 (18. Nhay Bo)", 0.72, function() pcall(function() LocalPlayer:SetAttribute("Tab18Act4", os.clock()) end) end)

-- ========== TAB 19: 19. Khong Nga ==========
addBtn(pages[19], "Chuc Nang 19.1 (19. Khong Nga)", 0.63, function() pcall(function() LocalPlayer:SetAttribute("Tab19Act1", os.clock()) end) end)
addBtn(pages[19], "Chuc Nang 19.2 (19. Khong Nga)", 0.67, function() pcall(function() LocalPlayer:SetAttribute("Tab19Act2", os.clock()) end) end)
addBtn(pages[19], "Chuc Nang 19.3 (19. Khong Nga)", 0.71, function() pcall(function() LocalPlayer:SetAttribute("Tab19Act3", os.clock()) end) end)
addBtn(pages[19], "Chuc Nang 19.4 (19. Khong Nga)", 0.75, function() pcall(function() LocalPlayer:SetAttribute("Tab19Act4", os.clock()) end) end)

-- ========== TAB 20: 20. Chinh Role ==========
-- Chinh role/team cuc bo (khong cap quyen server-side)
addInput(pages[20], "Role/Rank So Ao", 5, 0.05, function(v) setVisualStat("Role", v) end)
addBtn(pages[20], "Chuyen Team Ke Tiep", 0.09, function() local list = Teams:GetTeams() if #list > 0 then local idx = 1 for i, tm in ipairs(list) do if tm == LocalPlayer.Team then idx = (i % #list) + 1 break end end pcall(function() LocalPlayer.Team = list[idx] end) end end)

-- ========== TAB 21: 21. Dich Chuyen ==========
-- Dich chuyen nguoi choi khac (chi thanh cong neu doi tuong thuoc quyen dieu khien/seat/part cuc bo)
local targetPlrName = ""
addInput(pages[21], "Nhap Ten Nguoi Choi", "", 0.04, function(v) targetPlrName = tostring(v) end)
addBtn(pages[21], "Keo Nguoi Choi Ve Truoc Mat", 0.08, function() local f = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") local off = f and (f.CFrame.LookVector * 6) or Vector3.new(4, 0, 0) teleportOtherPlayer(targetPlrName, off) end)
addBtn(pages[21], "Dich Chuyen Den Nguoi Choi", 0.12, function() for _, plr in ipairs(Players:GetPlayers()) do if plr ~= LocalPlayer and plr.Name:lower():find(targetPlrName:lower(), 1, true) then local tR = plr.Character and plr.Character:FindFirstChild("HumanoidRootPart") if tR then smoothTeleport(tR.CFrame + Vector3.new(0, 2, 4)) end break end end end)

-- ========== TAB 22: 22. ESP Full ==========
addBtn(pages[22], "Chuc Nang 22.1 (22. ESP Full)", 0.72, function() pcall(function() LocalPlayer:SetAttribute("Tab22Act1", os.clock()) end) end)
addBtn(pages[22], "Chuc Nang 22.2 (22. ESP Full)", 0.76, function() pcall(function() LocalPlayer:SetAttribute("Tab22Act2", os.clock()) end) end)
addBtn(pages[22], "Chuc Nang 22.3 (22. ESP Full)", 0.80, function() pcall(function() LocalPlayer:SetAttribute("Tab22Act3", os.clock()) end) end)
addBtn(pages[22], "Chuc Nang 22.4 (22. ESP Full)", 0.84, function() pcall(function() LocalPlayer:SetAttribute("Tab22Act4", os.clock()) end) end)

-- ========== TAB 23: 23. Khoang Cach ==========
addBtn(pages[23], "Chuc Nang 23.1 (23. Khoang Cach)", 0.75, function() pcall(function() LocalPlayer:SetAttribute("Tab23Act1", os.clock()) end) end)
addBtn(pages[23], "Chuc Nang 23.2 (23. Khoang Cach)", 0.79, function() pcall(function() LocalPlayer:SetAttribute("Tab23Act2", os.clock()) end) end)
addBtn(pages[23], "Chuc Nang 23.3 (23. Khoang Cach)", 0.83, function() pcall(function() LocalPlayer:SetAttribute("Tab23Act3", os.clock()) end) end)
addBtn(pages[23], "Chuc Nang 23.4 (23. Khoang Cach)", 0.87, function() pcall(function() LocalPlayer:SetAttribute("Tab23Act4", os.clock()) end) end)

-- ========== TAB 24: 24. Moi Truong ==========
addBtn(pages[24], "Chuc Nang 24.1 (24. Moi Truong)", 0.78, function() pcall(function() LocalPlayer:SetAttribute("Tab24Act1", os.clock()) end) end)
addBtn(pages[24], "Chuc Nang 24.2 (24. Moi Truong)", 0.82, function() pcall(function() LocalPlayer:SetAttribute("Tab24Act2", os.clock()) end) end)
addBtn(pages[24], "Chuc Nang 24.3 (24. Moi Truong)", 0.86, function() pcall(function() LocalPlayer:SetAttribute("Tab24Act3", os.clock()) end) end)
addBtn(pages[24], "Chuc Nang 24.4 (24. Moi Truong)", 0.90, function() pcall(function() LocalPlayer:SetAttribute("Tab24Act4", os.clock()) end) end)

-- ========== TAB 25: 25. Thoi Tiet ==========
addBtn(pages[25], "Chuc Nang 25.1 (25. Thoi Tiet)", 0.82, function() pcall(function() LocalPlayer:SetAttribute("Tab25Act1", os.clock()) end) end)
addBtn(pages[25], "Chuc Nang 25.2 (25. Thoi Tiet)", 0.85, function() pcall(function() LocalPlayer:SetAttribute("Tab25Act2", os.clock()) end) end)
addBtn(pages[25], "Chuc Nang 25.3 (25. Thoi Tiet)", 0.90, function() pcall(function() LocalPlayer:SetAttribute("Tab25Act3", os.clock()) end) end)
addBtn(pages[25], "Chuc Nang 25.4 (25. Thoi Tiet)", 0.94, function() pcall(function() LocalPlayer:SetAttribute("Tab25Act4", os.clock()) end) end)

-- ========== TAB 26: 26. Hieu Ung ==========
addBtn(pages[26], "Chuc Nang 26.1 (26. Hieu Ung)", 0.85, function() pcall(function() LocalPlayer:SetAttribute("Tab26Act1", os.clock()) end) end)
addBtn(pages[26], "Chuc Nang 26.2 (26. Hieu Ung)", 0.89, function() pcall(function() LocalPlayer:SetAttribute("Tab26Act2", os.clock()) end) end)
addBtn(pages[26], "Chuc Nang 26.3 (26. Hieu Ung)", 0.93, function() pcall(function() LocalPlayer:SetAttribute("Tab26Act3", os.clock()) end) end)
addBtn(pages[26], "Chuc Nang 26.4 (26. Hieu Ung)", 0.97, function() pcall(function() LocalPlayer:SetAttribute("Tab26Act4", os.clock()) end) end)

-- ========== TAB 27: 27. Luu Data ==========
addBtn(pages[27], "Chuc Nang 27.1 (27. Luu Data)", 0.88, function() pcall(function() LocalPlayer:SetAttribute("Tab27Act1", os.clock()) end) end)
addBtn(pages[27], "Chuc Nang 27.2 (27. Luu Data)", 0.92, function() pcall(function() LocalPlayer:SetAttribute("Tab27Act2", os.clock()) end) end)
addBtn(pages[27], "Chuc Nang 27.3 (27. Luu Data)", 0.96, function() pcall(function() LocalPlayer:SetAttribute("Tab27Act3", os.clock()) end) end)
addBtn(pages[27], "Chuc Nang 27.4 (27. Luu Data)", 1.00, function() pcall(function() LocalPlayer:SetAttribute("Tab27Act4", os.clock()) end) end)

-- ========== TAB 28: 28. Giam Lag ==========
addBtn(pages[28], "Chuc Nang 28.1 (28. Giam Lag)", 0.91, function() pcall(function() LocalPlayer:SetAttribute("Tab28Act1", os.clock()) end) end)
addBtn(pages[28], "Chuc Nang 28.2 (28. Giam Lag)", 0.95, function() pcall(function() LocalPlayer:SetAttribute("Tab28Act2", os.clock()) end) end)
addBtn(pages[28], "Chuc Nang 28.3 (28. Giam Lag)", 0.99, function() pcall(function() LocalPlayer:SetAttribute("Tab28Act3", os.clock()) end) end)
addBtn(pages[28], "Chuc Nang 28.4 (28. Giam Lag)", 0.03, function() pcall(function() LocalPlayer:SetAttribute("Tab28Act4", os.clock()) end) end)

-- ========== TAB 29: 29. Phim Tat ==========
addBtn(pages[29], "Chuc Nang 29.1 (29. Phim Tat)", 0.94, function() pcall(function() LocalPlayer:SetAttribute("Tab29Act1", os.clock()) end) end)
addBtn(pages[29], "Chuc Nang 29.2 (29. Phim Tat)", 0.98, function() pcall(function() LocalPlayer:SetAttribute("Tab29Act2", os.clock()) end) end)
addBtn(pages[29], "Chuc Nang 29.3 (29. Phim Tat)", 0.02, function() pcall(function() LocalPlayer:SetAttribute("Tab29Act3", os.clock()) end) end)
addBtn(pages[29], "Chuc Nang 29.4 (29. Phim Tat)", 0.06, function() pcall(function() LocalPlayer:SetAttribute("Tab29Act4", os.clock()) end) end)

-- ========== TAB 30: 30. An Toan ==========
addBtn(pages[30], "Chuc Nang 30.1 (30. An Toan)", 0.97, function() pcall(function() LocalPlayer:SetAttribute("Tab30Act1", os.clock()) end) end)
addBtn(pages[30], "Chuc Nang 30.2 (30. An Toan)", 0.01, function() pcall(function() LocalPlayer:SetAttribute("Tab30Act2", os.clock()) end) end)
addBtn(pages[30], "Chuc Nang 30.3 (30. An Toan)", 0.05, function() pcall(function() LocalPlayer:SetAttribute("Tab30Act3", os.clock()) end) end)
addBtn(pages[30], "Chuc Nang 30.4 (30. An Toan)", 0.09, function() pcall(function() LocalPlayer:SetAttribute("Tab30Act4", os.clock()) end) end)

trackConn(RunService.RenderStepped:Connect(function()
	if not espOn then return end
	local active = {}
	for _, plr in ipairs(Players:GetPlayers()) do
		if plr ~= LocalPlayer and plr.Character and plr.Character:FindFirstChild("HumanoidRootPart") then
			active[plr.Name] = true
			local tag = espFolder:FindFirstChild(plr.Name)
			if not tag then
				tag = Instance.new("BillboardGui")
				tag.Name = plr.Name
				tag.AlwaysOnTop = true
				tag.Size = UDim2.new(0, 100, 0, 18)
				tag.StudsOffset = Vector3.new(0, 3, 0)
				tag.Adornee = plr.Character.HumanoidRootPart
				tag.Parent = espFolder
				local lbl = Instance.new("TextLabel")
				lbl.Size = UDim2.new(1, 0, 1, 0)
				lbl.BackgroundTransparency = 1
				lbl.TextColor3 = Color3.fromRGB(255, 90, 170)
				lbl.TextStrokeTransparency = 0
				lbl.TextSize = 9
				lbl.Font = Enum.Font.GothamBold
				lbl.Parent = tag
			else
				tag.Adornee = plr.Character.HumanoidRootPart
			end
			local myR = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
			local d = myR and math.floor((plr.Character.HumanoidRootPart.Position - myR.Position).Magnitude) or 0
			local lbl = tag:FindFirstChildOfClass("TextLabel")
			if lbl then lbl.Text = plr.Name .. " [" .. d .. "m]" end
		end
	end
	for _, ch in ipairs(espFolder:GetChildren()) do
		if not active[ch.Name] then ch:Destroy() end
	end
end))

trackConn(RunService.RenderStepped:Connect(function(dt)
	if not speedOn then return end
	local ch = LocalPlayer.Character
	local r = ch and ch:FindFirstChild("HumanoidRootPart")
	local h = ch and ch:FindFirstChildOfClass("Humanoid")
	if r and h and h.MoveDirection.Magnitude > 0 then
		local step = h.MoveDirection.Unit * (targetSpeed * 0.25) * math.min(dt * 60, 2)
		r.CFrame = r.CFrame + Vector3.new(step.X, 0, step.Z)
	end
end))