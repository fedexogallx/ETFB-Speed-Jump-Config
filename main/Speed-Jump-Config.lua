local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

-- Evitar duplicados
local oldGui = playerGui:FindFirstChild("SpeedJumpGUI")
if oldGui then
oldGui:Destroy()
end

-- Valores por defecto desde el Player
local defaultSpeed = player:GetAttribute("CurrentSpeed")
if typeof(defaultSpeed) ~= "number" then
defaultSpeed = 16
end

local defaultJump = player:GetAttribute("JumpUpgrade")
if typeof(defaultJump) ~= "number" then
defaultJump = 50
end

local function readAttrNumber(attrName, fallback)
local value = player:GetAttribute(attrName)
if typeof(value) == "number" then
return value
end
return fallback
end

local function applySpeed(value)
player:SetAttribute("CurrentSpeed", value)
end

local function applyJump(value)
player:SetAttribute("JumpUpgrade", value)
end

-- Keybind inicial
local currentKeybind = Enum.KeyCode.RightShift
local isBindingKeybind = false

local function keyCodeToText(keyCode)
if typeof(keyCode) ~= "EnumItem" then
return "RightShift"
end
return keyCode.Name
end

local function isTypingInTextBox()
return UserInputService:GetFocusedTextBox() ~= nil
end

-- GUI principal
local gui = Instance.new("ScreenGui")
gui.Name = "SpeedJumpGUI"
gui.IgnoreGuiInset = true
gui.ResetOnSpawn = false
gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
gui.Parent = playerGui

local function setGuiVisible(state)
gui.Enabled = state
end

local function toggleGuiVisible()
setGuiVisible(not gui.Enabled)
end

-- Marco exterior solo para el borde
local border = Instance.new("Frame")
border.Name = "Border"
border.AnchorPoint = Vector2.new(0, 0)
border.Position = UDim2.new(0, 28, 0, 28)
border.Size = UDim2.new(0, 446, 0, 306)
border.BackgroundTransparency = 1
border.BorderSizePixel = 0
border.Parent = gui

local borderCorner = Instance.new("UICorner")
borderCorner.CornerRadius = UDim.new(0, 20)
borderCorner.Parent = border

local borderStroke = Instance.new("UIStroke")
borderStroke.Thickness = 3
borderStroke.Transparency = 0
borderStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
borderStroke.Parent = border

local borderGradient = Instance.new("UIGradient")
borderGradient.Color = ColorSequence.new({
ColorSequenceKeypoint.new(0.00, Color3.fromRGB(255, 0, 0)),
ColorSequenceKeypoint.new(0.16, Color3.fromRGB(255, 128, 0)),
ColorSequenceKeypoint.new(0.33, Color3.fromRGB(255, 255, 0)),
ColorSequenceKeypoint.new(0.50, Color3.fromRGB(0, 255, 0)),
ColorSequenceKeypoint.new(0.66, Color3.fromRGB(0, 170, 255)),
ColorSequenceKeypoint.new(0.83, Color3.fromRGB(170, 0, 255)),
ColorSequenceKeypoint.new(1.00, Color3.fromRGB(255, 0, 0)),
})
borderGradient.Rotation = 0
borderGradient.Parent = borderStroke

-- Fondo interior
local main = Instance.new("Frame")
main.Name = "Main"
main.AnchorPoint = Vector2.new(0, 0)
main.Position = UDim2.new(0, 31, 0, 31)
main.Size = UDim2.new(0, 440, 0, 300)
main.BackgroundColor3 = Color3.fromRGB(18, 18, 24)
main.BackgroundTransparency = 0.5
main.BorderSizePixel = 0
main.Parent = gui

local mainCorner = Instance.new("UICorner")
mainCorner.CornerRadius = UDim.new(0, 18)
mainCorner.Parent = main

local mainStroke = Instance.new("UIStroke")
mainStroke.Thickness = 1
mainStroke.Transparency = 0.65
mainStroke.Color = Color3.fromRGB(255, 255, 255)
mainStroke.Parent = main

local mainPadding = Instance.new("UIPadding")
mainPadding.PaddingTop = UDim.new(0, 12)
mainPadding.PaddingBottom = UDim.new(0, 12)
mainPadding.PaddingLeft = UDim.new(0, 12)
mainPadding.PaddingRight = UDim.new(0, 12)
mainPadding.Parent = main

-- Barra superior
local topBar = Instance.new("Frame")
topBar.Name = "TopBar"
topBar.Size = UDim2.new(1, 0, 0, 42)
topBar.BackgroundTransparency = 1
topBar.BorderSizePixel = 0
topBar.Parent = main

local title = Instance.new("TextLabel")
title.Name = "Title"
title.BackgroundTransparency = 1
title.Size = UDim2.new(1, -210, 1, 0)
title.Position = UDim2.new(0, 8, 0, 0)
title.Font = Enum.Font.GothamBold
title.Text = "ETFB Speed & Jump Settings"
title.TextSize = 24
title.TextColor3 = Color3.fromRGB(255, 255, 255)
title.TextXAlignment = Enum.TextXAlignment.Left
title.Parent = topBar

local keybindBtn = Instance.new("TextButton")
keybindBtn.Name = "Keybind"
keybindBtn.Size = UDim2.new(0, 84, 0, 28)
keybindBtn.Position = UDim2.new(1, -160, 0, 7)
keybindBtn.BackgroundColor3 = Color3.fromRGB(40, 40, 50)
keybindBtn.BackgroundTransparency = 0.15
keybindBtn.BorderSizePixel = 0
keybindBtn.Text = keyCodeToText(currentKeybind)
keybindBtn.Font = Enum.Font.GothamBold
keybindBtn.TextSize = 13
keybindBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
keybindBtn.AutoButtonColor = true
keybindBtn.Parent = topBar

local keybindCorner = Instance.new("UICorner")
keybindCorner.CornerRadius = UDim.new(0, 8)
keybindCorner.Parent = keybindBtn

local keybindStroke = Instance.new("UIStroke")
keybindStroke.Thickness = 1
keybindStroke.Transparency = 0.75
keybindStroke.Color = Color3.fromRGB(255, 255, 255)
keybindStroke.Parent = keybindBtn

local minimizeBtn = Instance.new("TextButton")
minimizeBtn.Name = "Minimize"
minimizeBtn.Size = UDim2.new(0, 34, 0, 28)
minimizeBtn.Position = UDim2.new(1, -72, 0, 7)
minimizeBtn.BackgroundColor3 = Color3.fromRGB(40, 40, 50)
minimizeBtn.BackgroundTransparency = 0.15
minimizeBtn.BorderSizePixel = 0
minimizeBtn.Text = "—"
minimizeBtn.Font = Enum.Font.GothamBold
minimizeBtn.TextSize = 26
minimizeBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
minimizeBtn.AutoButtonColor = true
minimizeBtn.Parent = topBar

local closeBtn = Instance.new("TextButton")
closeBtn.Name = "Close"
closeBtn.Size = UDim2.new(0, 34, 0, 28)
closeBtn.Position = UDim2.new(1, -36, 0, 7)
closeBtn.BackgroundColor3 = Color3.fromRGB(180, 40, 50)
closeBtn.BackgroundTransparency = 0.05
closeBtn.BorderSizePixel = 0
closeBtn.Text = "X"
closeBtn.Font = Enum.Font.GothamBold
closeBtn.TextSize = 18
closeBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
closeBtn.AutoButtonColor = true
closeBtn.Parent = topBar

for _, obj in ipairs({ keybindBtn, minimizeBtn, closeBtn }) do
local c = Instance.new("UICorner")
c.CornerRadius = UDim.new(0, 8)
c.Parent = obj
end

-- Contenido
local content = Instance.new("Frame")
content.Name = "Content"
content.BackgroundTransparency = 1
content.Position = UDim2.new(0, 0, 0, 54)
content.Size = UDim2.new(1, 0, 1, -66)
content.Parent = main

local layout = Instance.new("UIListLayout")
layout.FillDirection = Enum.FillDirection.Vertical
layout.SortOrder = Enum.SortOrder.LayoutOrder
layout.Padding = UDim.new(0, 12)
layout.Parent = content

local function makeRow(labelText, boxPlaceholder, applyText)
local row = Instance.new("Frame")
row.Name = labelText .. "Row"
row.BackgroundTransparency = 1
row.Size = UDim2.new(1, 0, 0, 58)

local label = Instance.new("TextLabel")
label.Name = "Label"
label.BackgroundTransparency = 1
label.Size = UDim2.new(0, 90, 1, 0)
label.Position = UDim2.new(0, 0, 0, 0)
label.Font = Enum.Font.GothamSemibold
label.Text = labelText .. ":"
label.TextSize = 20
label.TextColor3 = Color3.fromRGB(245, 245, 245)
label.TextXAlignment = Enum.TextXAlignment.Left
label.Parent = row

local box = Instance.new("TextBox")
box.Name = "Box"
box.Size = UDim2.new(0, 145, 0, 42)
box.Position = UDim2.new(0, 96, 0.5, -21)
box.BackgroundColor3 = Color3.fromRGB(30, 34, 44)
box.BackgroundTransparency = 0.12
box.BorderSizePixel = 0
box.ClearTextOnFocus = false
box.PlaceholderText = boxPlaceholder
box.Text = ""
box.Font = Enum.Font.GothamSemibold
box.TextSize = 20
box.TextColor3 = Color3.fromRGB(255, 255, 255)
box.PlaceholderColor3 = Color3.fromRGB(160, 160, 160)
box.Parent = row

local boxCorner = Instance.new("UICorner")
boxCorner.CornerRadius = UDim.new(0, 10)
boxCorner.Parent = box

local boxStroke = Instance.new("UIStroke")
boxStroke.Thickness = 1
boxStroke.Transparency = 0.7
boxStroke.Color = Color3.fromRGB(255, 255, 255)
boxStroke.Parent = box

local apply = Instance.new("TextButton")
apply.Name = "Apply"
apply.Size = UDim2.new(0, 168, 0, 42)
apply.Position = UDim2.new(1, -168, 0.5, -21)
apply.BackgroundColor3 = Color3.fromRGB(34, 145, 255)
apply.BackgroundTransparency = 0.08
apply.BorderSizePixel = 0
apply.Text = applyText
apply.Font = Enum.Font.GothamBold
apply.TextSize = 20
apply.TextColor3 = Color3.fromRGB(255, 255, 255)
apply.AutoButtonColor = true
apply.Parent = row

local applyCorner = Instance.new("UICorner")
applyCorner.CornerRadius = UDim.new(0, 10)
applyCorner.Parent = apply

local applyStroke = Instance.new("UIStroke")
applyStroke.Thickness = 1
applyStroke.Transparency = 0.75
applyStroke.Color = Color3.fromRGB(255, 255, 255)
applyStroke.Parent = apply

return row, box, apply

end

local speedRow, speedBox, speedApply = makeRow("Speed", "Ej: 50", "Apply Speed")
speedRow.LayoutOrder = 1
speedRow.Parent = content

local jumpRow, jumpBox, jumpApply = makeRow("Jump", "Ej: 100", "Apply Jump")
jumpRow.LayoutOrder = 2
jumpRow.Parent = content

local bottomRow = Instance.new("Frame")
bottomRow.Name = "BottomRow"
bottomRow.BackgroundTransparency = 1
bottomRow.Size = UDim2.new(1, 0, 0, 48)
bottomRow.LayoutOrder = 3
bottomRow.Parent = content

local resetBtn = Instance.new("TextButton")
resetBtn.Name = "Reset"
resetBtn.Size = UDim2.new(0.48, -6, 1, 0)
resetBtn.Position = UDim2.new(0, 0, 0, 0)
resetBtn.BackgroundColor3 = Color3.fromRGB(55, 60, 70)
resetBtn.BackgroundTransparency = 0.12
resetBtn.BorderSizePixel = 0
resetBtn.Text = "Reset"
resetBtn.Font = Enum.Font.GothamBold
resetBtn.TextSize = 20
resetBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
resetBtn.Parent = bottomRow

local resetCorner = Instance.new("UICorner")
resetCorner.CornerRadius = UDim.new(0, 10)
resetCorner.Parent = resetBtn

local resetStroke = Instance.new("UIStroke")
resetStroke.Thickness = 1
resetStroke.Transparency = 0.75
resetStroke.Color = Color3.fromRGB(255, 255, 255)
resetStroke.Parent = resetBtn

local hint = Instance.new("TextLabel")
hint.Name = "Hint"
hint.BackgroundTransparency = 1
hint.Size = UDim2.new(0.48, -6, 1, 0)
hint.Position = UDim2.new(0.52, 6, 0, 0)
hint.Font = Enum.Font.Gotham
hint.Text = "Usa números solamente"
hint.TextSize = 14
hint.TextColor3 = Color3.fromRGB(200, 200, 200)
hint.TextWrapped = true
hint.Parent = bottomRow

-- Animación del borde arcoíris
task.spawn(function()
while gui.Parent do
local tween = TweenService:Create(
borderGradient,
TweenInfo.new(8, Enum.EasingStyle.Linear, Enum.EasingDirection.InOut),
{ Rotation = 360 }
)
tween:Play()
tween.Completed:Wait()
borderGradient.Rotation = 0
end
end)

-- Funciones de aplicación
local function safeNumber(text)
return tonumber(text)
end

local function refreshTextBoxes()
speedBox.Text = tostring(readAttrNumber("CurrentSpeed", defaultSpeed))
jumpBox.Text = tostring(readAttrNumber("JumpUpgrade", defaultJump))
end

speedApply.MouseButton1Click:Connect(function()
local n = safeNumber(speedBox.Text)
if n then
applySpeed(n)
speedBox.Text = tostring(n)
else
speedBox.Text = tostring(readAttrNumber("CurrentSpeed", defaultSpeed))
end
end)

jumpApply.MouseButton1Click:Connect(function()
local n = safeNumber(jumpBox.Text)
if n then
applyJump(n)
jumpBox.Text = tostring(n)
else
jumpBox.Text = tostring(readAttrNumber("JumpUpgrade", defaultJump))
end
end)

resetBtn.MouseButton1Click:Connect(function()
applySpeed(defaultSpeed)
applyJump(defaultJump)
refreshTextBoxes()
end)

-- Minimizar / restaurar
local minimized = false
local expandedSize = UDim2.new(0, 440, 0, 300)
local minimizedSize = UDim2.new(0, 440, 0, 52)

local function setMinimized(state)
minimized = state
local goalSize = state and minimizedSize or expandedSize
local goalBorderSize = state and UDim2.new(0, 446, 0, 58) or UDim2.new(0, 446, 0, 306)

TweenService:Create(main, TweenInfo.new(0.22, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
	Size = goalSize
}):Play()

TweenService:Create(border, TweenInfo.new(0.22, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
	Size = goalBorderSize
}):Play()

content.Visible = not state

end

minimizeBtn.MouseButton1Click:Connect(function()
setMinimized(not minimized)
end)

closeBtn.MouseButton1Click:Connect(function()
gui:Destroy()
end)

-- Drag
do
local dragging = false
local dragStart
local startPos

local function update(input)
	local delta = input.Position - dragStart
	local newBorderPos = UDim2.new(
		startPos.X.Scale,
		startPos.X.Offset + delta.X,
		startPos.Y.Scale,
		startPos.Y.Offset + delta.Y
	)

	border.Position = newBorderPos
	main.Position = UDim2.new(newBorderPos.X.Scale, newBorderPos.X.Offset + 3, newBorderPos.Y.Scale, newBorderPos.Y.Offset + 3)
end

topBar.InputBegan:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
		dragging = true
		dragStart = input.Position
		startPos = border.Position

		input.Changed:Connect(function()
			if input.UserInputState == Enum.UserInputState.End then
				dragging = false
			end
		end)
	end
end)

topBar.InputChanged:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
		if dragging then
			update(input)
		end
	end
end)

UserInputService.InputChanged:Connect(function(input)
	if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
		update(input)
	end
end)

end

-- Keybind editable
local function updateKeybindButton()
keybindBtn.Text = keyCodeToText(currentKeybind)
end

keybindBtn.MouseButton1Click:Connect(function()
isBindingKeybind = true
keybindBtn.Text = "Press key..."
end)

UserInputService.InputBegan:Connect(function(input, gameProcessed)
if input.UserInputType == Enum.UserInputType.Keyboard then
if isBindingKeybind then
if input.KeyCode ~= Enum.KeyCode.Unknown then
currentKeybind = input.KeyCode
isBindingKeybind = false
updateKeybindButton()
end
return
end

	if not isTypingInTextBox() and input.KeyCode == currentKeybind then
		toggleGuiVisible()
	end
end

end)

-- Mantener texto sincronizado si otro script cambia los atributos
player:GetAttributeChangedSignal("CurrentSpeed"):Connect(function()
speedBox.Text = tostring(readAttrNumber("CurrentSpeed", defaultSpeed))
end)

player:GetAttributeChangedSignal("JumpUpgrade"):Connect(function()
jumpBox.Text = tostring(readAttrNumber("JumpUpgrade", defaultJump))
end)

-- Inicializar atributos si aún no existen
if player:GetAttribute("CurrentSpeed") == nil then
player:SetAttribute("CurrentSpeed", defaultSpeed)
end

if player:GetAttribute("JumpUpgrade") == nil then
player:SetAttribute("JumpUpgrade", defaultJump)
end

refreshTextBoxes()
setMinimized(false)
setGuiVisible(true)
updateKeybindButton()
