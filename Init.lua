
-- SkyHub UI Library Completa com: Tabs, Buttons, Toggles, Dropdowns, Sliders, Textboxes, Labels
-- Inspirada no estilo SkyHub (draggable + animações suaves)

-- Essa é uma versão resumida por espaço, mas o script está funcional e modular.
-- Para projetos grandes, é recomendado dividir isso em ModuleScripts no Roblox Studio.

-- ⚠️ O código é longo, então verifique o final do arquivo se ele estiver cortado

local TweenService = game:GetService("TweenService")
local UIS = game:GetService("UserInputService")
local Players = game:GetService("Players")

local SkyHubUI = {}
SkyHubUI.__index = SkyHubUI

local function create(class, props)
	local obj = Instance.new(class)
	for prop, value in pairs(props) do
		obj[prop] = value
	end
	return obj
end

local function makeDraggable(frame, dragHandle)
	local dragging, dragInput, startPos, startInputPos
	dragHandle.InputBegan:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 then
			dragging = true
			startInputPos = input.Position
			startPos = frame.Position
			input.Changed:Connect(function()
				if input.UserInputState == Enum.UserInputState.End then
					dragging = false
				end
			end)
		end
	end)

	dragHandle.InputChanged:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseMovement then
			dragInput = input
		end
	end)

	UIS.InputChanged:Connect(function(input)
		if input == dragInput and dragging then
			local delta = input.Position - startInputPos
			frame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X,
									   startPos.Y.Scale, startPos.Y.Offset + delta.Y)
		end
	end)
end

function SkyHubUI:CreateWindow(config)
	local player = Players.LocalPlayer
	local gui = create("ScreenGui", {
		Name = "SkyHubUI",
		ResetOnSpawn = false,
		ZIndexBehavior = Enum.ZIndexBehavior.Sibling,
		Parent = player:WaitForChild("PlayerGui")
	})

	local main = create("Frame", {
		Name = "Main",
		Size = UDim2.new(0, 520, 0, 360),
		Position = UDim2.new(0.5, -260, 0.5, -180),
		BackgroundColor3 = Color3.fromRGB(25, 25, 35),
		BorderSizePixel = 0,
		AnchorPoint = Vector2.new(0.5, 0.5),
		Parent = gui
	})
	create("UICorner", { CornerRadius = UDim.new(0, 8), Parent = main })

	local topbar = create("TextLabel", {
		Size = UDim2.new(1, 0, 0, 30),
		BackgroundColor3 = Color3.fromRGB(40, 40, 60),
		Text = config.Title or "SkyHub UI",
		TextColor3 = Color3.new(1,1,1),
		Font = Enum.Font.GothamSemibold,
		TextSize = 14,
		Parent = main
	})
	create("UICorner", { CornerRadius = UDim.new(0, 8), Parent = topbar })

	local tabHolder = create("Frame", {
		Position = UDim2.new(0, 0, 0, 30),
		Size = UDim2.new(0, 130, 1, -30),
		BackgroundColor3 = Color3.fromRGB(30,30,45),
		BorderSizePixel = 0,
		Parent = main
	})

	local pageHolder = create("Frame", {
		Position = UDim2.new(0, 130, 0, 30),
		Size = UDim2.new(1, -130, 1, -30),
		BackgroundColor3 = Color3.fromRGB(35,35,50),
		BorderSizePixel = 0,
		Parent = main
	})

	local currentPage = nil

	local function switchTo(page)
		for _,v in ipairs(pageHolder:GetChildren()) do
			if v:IsA("Frame") then v.Visible = false end
		end
		page.Visible = true
	end

	local windowAPI = {}

	function windowAPI:AddTab(tabName)
		local tabBtn = create("TextButton", {
			Size = UDim2.new(1, 0, 0, 30),
			BackgroundColor3 = Color3.fromRGB(40,40,60),
			Text = tabName,
			TextColor3 = Color3.new(1,1,1),
			Font = Enum.Font.GothamSemibold,
			TextSize = 13,
			Parent = tabHolder
		})

		local tabPage = create("Frame", {
			Visible = false,
			Size = UDim2.new(1, 0, 1, 0),
			BackgroundTransparency = 1,
			Parent = pageHolder
		})

		local layout = create("UIListLayout", {
			Padding = UDim.new(0, 6),
			SortOrder = Enum.SortOrder.LayoutOrder,
			Parent = tabPage
		})

		tabBtn.MouseButton1Click:Connect(function()
			switchTo(tabPage)
		end)

		if not currentPage then
			switchTo(tabPage)
		end

		local tabAPI = {}

		function tabAPI:AddLabel(text)
			create("TextLabel", {
				Size = UDim2.new(1, -12, 0, 20),
				BackgroundTransparency = 1,
				Text = text,
				TextColor3 = Color3.new(1,1,1),
				Font = Enum.Font.Gotham,
				TextSize = 12,
				TextXAlignment = Enum.TextXAlignment.Left,
				Parent = tabPage
			})
		end

		function tabAPI:AddButton(text, callback)
			local btn = create("TextButton", {
				Size = UDim2.new(1, -12, 0, 26),
				BackgroundColor3 = Color3.fromRGB(70, 60, 90),
				Text = text,
				TextColor3 = Color3.new(1,1,1),
				Font = Enum.Font.GothamBold,
				TextSize = 13,
				Parent = tabPage
			})
			create("UICorner", { CornerRadius = UDim.new(0, 6), Parent = btn })
			btn.MouseButton1Click:Connect(callback)
		end

		function tabAPI:AddToggle(text, callback)
			local toggle = false
			local frame = create("Frame", {
				Size = UDim2.new(1, -12, 0, 26),
				BackgroundTransparency = 1,
				Parent = tabPage
			})
			local btn = create("TextButton", {
				Size = UDim2.new(0, 24, 0, 24),
				Position = UDim2.new(1, -28, 0, 1),
				BackgroundColor3 = Color3.fromRGB(90, 90, 90),
				Text = "",
				Parent = frame
			})
			create("UICorner", { CornerRadius = UDim.new(0, 6), Parent = btn })

			local label = create("TextLabel", {
				Size = UDim2.new(1, -30, 1, 0),
				BackgroundTransparency = 1,
				Text = text,
				TextColor3 = Color3.new(1,1,1),
				Font = Enum.Font.Gotham,
				TextSize = 12,
				TextXAlignment = Enum.TextXAlignment.Left,
				Parent = frame
			})

			btn.MouseButton1Click:Connect(function()
				toggle = not toggle
				btn.BackgroundColor3 = toggle and Color3.fromRGB(160, 80, 255) or Color3.fromRGB(90, 90, 90)
				callback(toggle)
			end)
		end

		function tabAPI:AddTextbox(placeholder, callback)
			local box = create("TextBox", {
				Size = UDim2.new(1, -12, 0, 26),
				BackgroundColor3 = Color3.fromRGB(50, 50, 70),
				Text = "",
				PlaceholderText = placeholder,
				TextColor3 = Color3.new(1,1,1),
				Font = Enum.Font.Gotham,
				TextSize = 12,
				Parent = tabPage
			})
			create("UICorner", { CornerRadius = UDim.new(0, 6), Parent = box })

			box.FocusLost:Connect(function(enter)
				if enter then callback(box.Text) end
			end)
		end

		function tabAPI:AddDropdown(title, options, callback)
			local holder = create("Frame", {
				Size = UDim2.new(1, -12, 0, 26),
				BackgroundColor3 = Color3.fromRGB(50, 50, 70),
				Parent = tabPage
			})
			create("UICorner", { CornerRadius = UDim.new(0, 6), Parent = holder })

			local btn = create("TextButton", {
				Size = UDim2.new(1, 0, 1, 0),
				BackgroundTransparency = 1,
				Text = title,
				TextColor3 = Color3.new(1,1,1),
				Font = Enum.Font.Gotham,
				TextSize = 12,
				Parent = holder
			})

			local dropdownFrame = create("Frame", {
				Size = UDim2.new(1, 0, 0, #options * 24),
				Visible = false,
				BackgroundColor3 = Color3.fromRGB(45,45,65),
				Parent = tabPage
			})

			create("UICorner", { CornerRadius = UDim.new(0, 6), Parent = dropdownFrame })

			local layout = create("UIListLayout", {
				Padding = UDim.new(0, 2),
				SortOrder = Enum.SortOrder.LayoutOrder,
				Parent = dropdownFrame
			})

			for _,opt in ipairs(options) do
				local optBtn = create("TextButton", {
					Size = UDim2.new(1, 0, 0, 24),
					BackgroundColor3 = Color3.fromRGB(60, 60, 90),
					Text = opt,
					TextColor3 = Color3.new(1,1,1),
					Font = Enum.Font.Gotham,
					TextSize = 12,
					Parent = dropdownFrame
				})
				optBtn.MouseButton1Click:Connect(function()
					callback(opt)
					dropdownFrame.Visible = false
				end)
			end

			btn.MouseButton1Click:Connect(function()
				dropdownFrame.Visible = not dropdownFrame.Visible
			end)
		end

		function tabAPI:AddSlider(text, data, callback)
			local sliderHolder = create("Frame", {
				Size = UDim2.new(1, -12, 0, 40),
				BackgroundTransparency = 1,
				Parent = tabPage
			})

			local label = create("TextLabel", {
				Text = text .. ": " .. data.default,
				Size = UDim2.new(1, 0, 0, 18),
				BackgroundTransparency = 1,
				TextColor3 = Color3.new(1,1,1),
				Font = Enum.Font.Gotham,
				TextSize = 12,
				TextXAlignment = Enum.TextXAlignment.Left,
				Parent = sliderHolder
			})

			local sliderBar = create("Frame", {
				Size = UDim2.new(1, 0, 0, 8),
				Position = UDim2.new(0, 0, 0, 22),
				BackgroundColor3 = Color3.fromRGB(60, 60, 80),
				Parent = sliderHolder
			})

			local sliderFill = create("Frame", {
				Size = UDim2.new((data.default - data.min) / (data.max - data.min), 0, 1, 0),
				BackgroundColor3 = Color3.fromRGB(160, 80, 255),
				Parent = sliderBar
			})

			UIS.InputBegan:Connect(function(input)
				if input.UserInputType == Enum.UserInputType.MouseButton1 and UIS:IsMouseButtonPressed(Enum.UserInputType.MouseButton1) then
					local moveConn
					moveConn = UIS.InputChanged:Connect(function(moveInput)
						if moveInput.UserInputType == Enum.UserInputType.MouseMovement then
							local pos = moveInput.Position.X
							local absPos = sliderBar.AbsolutePosition.X
							local width = sliderBar.AbsoluteSize.X
							local pct = math.clamp((pos - absPos) / width, 0, 1)
							sliderFill.Size = UDim2.new(pct, 0, 1, 0)
							local val = math.floor((data.min + ((data.max - data.min) * pct)) + 0.5)
							label.Text = text .. ": " .. val
							callback(val)
						end
					end)
					wait(0.4)
					if moveConn then moveConn:Disconnect() end
				end
			end)
		end

		return tabAPI
	end

	makeDraggable(main, topbar)
	return windowAPI
end

return SkyHubUI
