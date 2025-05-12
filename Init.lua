local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")

local SkyHub = {}
SkyHub.__index = SkyHub

local function createInstance(class, props)
	local inst = Instance.new(class)
	for k, v in pairs(props) do
		inst[k] = v
	end
	return inst
end

local function tween(obj, properties, duration)
	TweenService:Create(obj, TweenInfo.new(duration or 0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), properties):Play()
end

function SkyHub:Create(title)
	local self = setmetatable({}, SkyHub)
	
	-- Main GUI
	local ScreenGui = createInstance("ScreenGui", {
		Name = "SkyHubUI",
		Parent = game:GetService("CoreGui"),
		ResetOnSpawn = false,
		ZIndexBehavior = Enum.ZIndexBehavior.Global
	})

	local Main = createInstance("Frame", {
		Size = UDim2.new(0, 560, 0, 360),
		Position = UDim2.new(0.5, -280, 0.5, -180),
		AnchorPoint = Vector2.new(0.5, 0.5),
		BackgroundColor3 = Color3.fromRGB(20, 20, 20),
		Parent = ScreenGui,
		Draggable = true,
		Active = true
	})
	createInstance("UICorner", { CornerRadius = UDim.new(0, 8), Parent = Main })
	createInstance("UIStroke", { Color = Color3.fromRGB(0, 255, 140), Thickness = 1.2, Parent = Main })

	local Title = createInstance("TextLabel", {
		Size = UDim2.new(1, 0, 0, 30),
		BackgroundTransparency = 1,
		Text = title or "SkyHub UI",
		TextColor3 = Color3.fromRGB(0, 255, 140),
		TextSize = 18,
		Font = Enum.Font.GothamBold,
		Parent = Main
	})

	local TabList = createInstance("Frame", {
		Size = UDim2.new(0, 100, 1, -30),
		Position = UDim2.new(0, 0, 0, 30),
		BackgroundColor3 = Color3.fromRGB(25, 25, 25),
		Parent = Main
	})
	createInstance("UICorner", { CornerRadius = UDim.new(0, 6), Parent = TabList })

	local TabContent = createInstance("Frame", {
		Size = UDim2.new(1, -100, 1, -30),
		Position = UDim2.new(0, 100, 0, 30),
		BackgroundTransparency = 1,
		Parent = Main
	})

	local TabButtonsLayout = createInstance("UIListLayout", {
		Parent = TabList,
		SortOrder = Enum.SortOrder.LayoutOrder,
		Padding = UDim.new(0, 4)
	})

	self.Tabs = {}
	self.TabContent = TabContent
	self.CurrentTab = nil

	function self:CreateTab(name)
		local TabBtn = createInstance("TextButton", {
			Size = UDim2.new(1, -8, 0, 28),
			Text = name,
			Font = Enum.Font.Gotham,
			TextSize = 14,
			TextColor3 = Color3.fromRGB(255, 255, 255),
			BackgroundColor3 = Color3.fromRGB(35, 35, 35),
			Parent = TabList
		})
		createInstance("UICorner", { CornerRadius = UDim.new(0, 5), Parent = TabBtn })

		local Container = createInstance("Frame", {
			Visible = false,
			Size = UDim2.new(1, 0, 1, 0),
			BackgroundTransparency = 1,
			Parent = TabContent
		})
		local Layout = createInstance("UIListLayout", {
			Parent = Container,
			SortOrder = Enum.SortOrder.LayoutOrder,
			Padding = UDim.new(0, 6)
		})

		TabBtn.MouseButton1Click:Connect(function()
			if self.CurrentTab then self.CurrentTab.Visible = false end
			Container.Visible = true
			self.CurrentTab = Container
		end)

		self.Tabs[name] = Container
		if not self.CurrentTab then
			Container.Visible = true
			self.CurrentTab = Container
		end

		local Elements = {}

		function Elements:Button(text, callback)
			local Btn = createInstance("TextButton", {
				Text = text,
				Font = Enum.Font.Gotham,
				TextSize = 14,
				TextColor3 = Color3.fromRGB(0, 255, 140),
				BackgroundColor3 = Color3.fromRGB(30, 30, 30),
				Size = UDim2.new(1, -10, 0, 28),
				Parent = Container
			})
			createInstance("UICorner", { Parent = Btn })
			Btn.MouseButton1Click:Connect(function()
				pcall(callback)
			end)
		end

		function Elements:Toggle(text, default, callback)
			local Frame = createInstance("Frame", {
				Size = UDim2.new(1, -10, 0, 28),
				BackgroundTransparency = 1,
				Parent = Container
			})
			local Btn = createInstance("TextButton", {
				Size = UDim2.new(0, 28, 0, 28),
				BackgroundColor3 = default and Color3.fromRGB(0, 255, 140) or Color3.fromRGB(40, 40, 40),
				Parent = Frame,
				Text = ""
			})
			createInstance("UICorner", { Parent = Btn })
			local Label = createInstance("TextLabel", {
				Size = UDim2.new(1, -34, 1, 0),
				Position = UDim2.new(0, 34, 0, 0),
				BackgroundTransparency = 1,
				Text = text,
				TextColor3 = Color3.fromRGB(255, 255, 255),
				TextSize = 14,
				Font = Enum.Font.Gotham,
				TextXAlignment = Enum.TextXAlignment.Left,
				Parent = Frame
			})

			local state = default
			Btn.MouseButton1Click:Connect(function()
				state = not state
				tween(Btn, {
					BackgroundColor3 = state and Color3.fromRGB(0, 255, 140) or Color3.fromRGB(40, 40, 40)
				})
				pcall(callback, state)
			end)
		end

		function Elements:Label(text)
			createInstance("TextLabel", {
				Text = text,
				Font = Enum.Font.GothamSemibold,
				TextSize = 14,
				TextColor3 = Color3.fromRGB(200, 200, 200),
				BackgroundTransparency = 1,
				Size = UDim2.new(1, -10, 0, 24),
				Parent = Container,
				TextXAlignment = Enum.TextXAlignment.Left
			})
		end

		function Elements:Textbox(placeholder, callback)
			local Box = createInstance("TextBox", {
				PlaceholderText = placeholder,
				Font = Enum.Font.Gotham,
				TextSize = 14,
				TextColor3 = Color3.fromRGB(0, 255, 140),
				BackgroundColor3 = Color3.fromRGB(30, 30, 30),
				Size = UDim2.new(1, -10, 0, 28),
				ClearTextOnFocus = false,
				Parent = Container
			})
			createInstance("UICorner", { Parent = Box })

			Box.FocusLost:Connect(function()
				pcall(callback, Box.Text)
			end)
		end

		function Elements:Slider(text, min, max, default, callback)
			local Frame = createInstance("Frame", {
				Size = UDim2.new(1, -10, 0, 40),
				BackgroundTransparency = 1,
				Parent = Container
			})

			local Label = createInstance("TextLabel", {
				Text = text .. " - " .. tostring(default),
				Size = UDim2.new(1, 0, 0, 16),
				Font = Enum.Font.Gotham,
				TextSize = 13,
				TextColor3 = Color3.fromRGB(255, 255, 255),
				BackgroundTransparency = 1,
				TextXAlignment = Enum.TextXAlignment.Left,
				Parent = Frame
			})

			local Bar = createInstance("Frame", {
				Size = UDim2.new(1, 0, 0, 10),
				Position = UDim2.new(0, 0, 0, 25),
				BackgroundColor3 = Color3.fromRGB(40, 40, 40),
				Parent = Frame
			})
			createInstance("UICorner", { Parent = Bar })

			local Fill = createInstance("Frame", {
				Size = UDim2.new((default - min) / (max - min), 0, 1, 0),
				BackgroundColor3 = Color3.fromRGB(0, 255, 140),
				Parent = Bar
			})
			createInstance("UICorner", { Parent = Fill })

			local dragging = false
			Bar.InputBegan:Connect(function(input)
				if input.UserInputType == Enum.UserInputType.MouseButton1 then dragging = true end
			end)
			UserInputService.InputEnded:Connect(function(input)
				if input.UserInputType == Enum.UserInputType.MouseButton1 then dragging = false end
			end)
			UserInputService.InputChanged:Connect(function(input)
				if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
					local pos = math.clamp((input.Position.X - Bar.AbsolutePosition.X) / Bar.AbsoluteSize.X, 0, 1)
					local val = math.floor((min + (max - min) * pos) + 0.5)
					Fill.Size = UDim2.new(pos, 0, 1, 0)
					Label.Text = text .. " - " .. tostring(val)
					pcall(callback, val)
				end
			end)
		end

		function Elements:Dropdown(text, list, callback)
			local Frame = createInstance("Frame", {
				Size = UDim2.new(1, -10, 0, 28),
				BackgroundColor3 = Color3.fromRGB(30, 30, 30),
				Parent = Container,
				ClipsDescendants = true
			})
			createInstance("UICorner", { Parent = Frame })

			local Label = createInstance("TextLabel", {
				Text = text,
				Font = Enum.Font.Gotham,
				TextSize = 14,
				TextColor3 = Color3.fromRGB(0, 255, 140),
				BackgroundTransparency = 1,
				Size = UDim2.new(1, -30, 1, 0),
				TextXAlignment = Enum.TextXAlignment.Left,
				Parent = Frame
			})

			local Btn = createInstance("TextButton", {
				Text = "▼",
				Size = UDim2.new(0, 30, 1, 0),
				Position = UDim2.new(1, -30, 0, 0),
				BackgroundTransparency = 1,
				TextColor3 = Color3.fromRGB(255, 255, 255),
				Font = Enum.Font.Gotham,
				TextSize = 14,
				Parent = Frame
			})

			local isOpen = false
			local Options = {}

			local function Toggle()
				isOpen = not isOpen
				tween(Frame, { Size = UDim2.new(1, -10, 0, isOpen and (#Options * 24 + 28) or 28) })
			end

			Btn.MouseButton1Click:Connect(Toggle)

			function Elements:AddOption(option)
				local OptBtn = createInstance("TextButton", {
					Size = UDim2.new(1, 0, 0, 24),
					Position = UDim2.new(0, 0, 0, (#Options + 1) * 24),
					BackgroundColor3 = Color3.fromRGB(35, 35, 35),
					Text = option,
					TextColor3 = Color3.fromRGB(255, 255, 255),
					Font = Enum.Font.Gotham,
					TextSize = 13,
					Parent = Frame
				})
				createInstance("UICorner", { Parent = OptBtn })
				table.insert(Options, OptBtn)

				OptBtn.MouseButton1Click:Connect(function()
					Label.Text = text .. ": " .. option
					Toggle()
					pcall(callback, option)
				end)
			end

			for _, opt in ipairs(list) do
				Elements:AddOption(opt)
			end
		end

		return Elements
	end

	return self
end

return SkyHub
