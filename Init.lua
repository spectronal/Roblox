-- SkyHubUI - UI Library Completa e Draggable
-- Inspirada no estilo Sky Hub

local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")

local SkyHubUI = {}

function makeDraggable(frame)
	local dragging, dragInput, dragStart, startPos
	frame.InputBegan:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 then
			dragging = true
			dragStart = input.Position
			startPos = frame.Position
		
			input.Changed:Connect(function()
				if input.UserInputState == Enum.UserInputState.End then dragging = false end
			end)
		end
	end)

	frame.InputChanged:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseMovement then dragInput = input end
	end)

	UserInputService.InputChanged:Connect(function(input)
		if input == dragInput and dragging then
			local delta = input.Position - dragStart
			frame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X,
				startPos.Y.Scale, startPos.Y.Offset + delta.Y)
		end
	end)
end

function SkyHubUI:CreateWindow(config)
	config = config or {}
	local title = config.Title or "SkyHub UI"

	local screenGui = Instance.new("ScreenGui")
	screenGui.Name = "SkyHubUI"
	screenGui.Parent = game.Players.LocalPlayer:WaitForChild("PlayerGui")

	local main = Instance.new("Frame")
	main.Size = UDim2.new(0, 500, 0, 300)
	main.Position = UDim2.new(0.5, -250, 0.5, -150)
	main.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
	main.BorderSizePixel = 0
	main.Parent = screenGui
	main.Active = true
	main.Draggable = true

	makeDraggable(main)

	local titleLabel = Instance.new("TextLabel")
	titleLabel.Size = UDim2.new(1, 0, 0, 40)
	titleLabel.BackgroundTransparency = 1
	titleLabel.Text = title
	titleLabel.Font = Enum.Font.GothamBold
	titleLabel.TextSize = 22
	titleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
	titleLabel.Parent = main

	local tabHolder = Instance.new("Frame")
	tabHolder.Size = UDim2.new(0, 120, 1, -40)
	tabHolder.Position = UDim2.new(0, 0, 0, 40)
	tabHolder.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
	tabHolder.BorderSizePixel = 0
	tabHolder.Parent = main

	local tabList = Instance.new("UIListLayout")
	tabList.Parent = tabHolder
	tabList.SortOrder = Enum.SortOrder.LayoutOrder

	local contentHolder = Instance.new("Frame")
	contentHolder.Size = UDim2.new(1, -120, 1, -40)
	contentHolder.Position = UDim2.new(0, 120, 0, 40)
	contentHolder.BackgroundTransparency = 1
	contentHolder.Parent = main

	function createTab(name)
		local tabButton = Instance.new("TextButton")
		tabButton.Size = UDim2.new(1, 0, 0, 30)
		tabButton.Text = name
		tabButton.Font = Enum.Font.Gotham
		tabButton.TextSize = 14
		tabButton.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
		tabButton.TextColor3 = Color3.fromRGB(255, 255, 255)
		tabButton.Parent = tabHolder

		local tabPage = Instance.new("Frame")
		tabPage.Size = UDim2.new(1, 0, 1, 0)
		tabPage.BackgroundTransparency = 1
		tabPage.Visible = false
		tabPage.Parent = contentHolder

		local layout = Instance.new("UIListLayout")
		layout.Parent = tabPage
		layout.SortOrder = Enum.SortOrder.LayoutOrder
		layout.Padding = UDim.new(0, 6)

		tabButton.MouseButton1Click:Connect(function()
			for _, v in pairs(contentHolder:GetChildren()) do
				if v:IsA("Frame") then v.Visible = false end
			end
			tabPage.Visible = true
		end)

		return {
			AddToggle = function(self, text, callback)
				local toggle = Instance.new("TextButton")
				toggle.Size = UDim2.new(1, -10, 0, 30)
				toggle.Text = text
				toggle.BackgroundColor3 = Color3.fromRGB(70, 70, 70)
				toggle.TextColor3 = Color3.fromRGB(255, 255, 255)
				toggle.Font = Enum.Font.Gotham
				toggle.TextSize = 14
				toggle.Parent = tabPage

				local state = false
				toggle.MouseButton1Click:Connect(function()
					state = not state
					toggle.BackgroundColor3 = state and Color3.fromRGB(255, 80, 200) or Color3.fromRGB(70, 70, 70)
					callback(state)
				end)
			end,

			AddLabel = function(self, text)
				local label = Instance.new("TextLabel")
				label.Size = UDim2.new(1, -10, 0, 25)
				label.Text = text
				label.TextColor3 = Color3.fromRGB(255, 255, 255)
				label.BackgroundTransparency = 1
				label.Font = Enum.Font.Gotham
				label.TextSize = 14
				label.Parent = tabPage
			end
		}
	end

	return {
		AddTab = createTab
	}
end

return SkyHubUI
