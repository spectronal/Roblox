
-- VioUI Library (Completa e Draggable)
-- Inspirada na UI do Sky Hub
-- Desenvolvida por ididrunaway

local SkyHubUI = {}

local UIS = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")

function SkyHubUI:Create(title)
    local ScreenGui = Instance.new("ScreenGui", game:GetService("CoreGui"))
    ScreenGui.Name = "SkyHubUI"
    ScreenGui.ResetOnSpawn = false

    local MainFrame = Instance.new("Frame")
    MainFrame.Size = UDim2.new(0, 650, 0, 400)
    MainFrame.Position = UDim2.new(0.3, 0, 0.2, 0)
    MainFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
    MainFrame.BorderSizePixel = 0
    MainFrame.Parent = ScreenGui

    local UICorner = Instance.new("UICorner", MainFrame)
    UICorner.CornerRadius = UDim.new(0, 10)

    -- Dragging
    local dragging, dragInput, dragStart, startPos
    MainFrame.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
            dragStart = input.Position
            startPos = MainFrame.Position
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    dragging = false
                end
            end)
        end
    end)
    MainFrame.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement then
            dragInput = input
        end
    end)
    UIS.InputChanged:Connect(function(input)
        if input == dragInput and dragging then
            local delta = input.Position - dragStart
            MainFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X,
                                           startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        end
    end)

    local Sidebar = Instance.new("Frame")
    Sidebar.Size = UDim2.new(0, 160, 1, 0)
    Sidebar.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
    Sidebar.BorderSizePixel = 0
    Sidebar.Parent = MainFrame
    Instance.new("UICorner", Sidebar).CornerRadius = UDim.new(0, 10)

    local Title = Instance.new("TextLabel", Sidebar)
    Title.Size = UDim2.new(1, 0, 0, 40)
    Title.BackgroundTransparency = 1
    Title.Text = title or "SkyHub"
    Title.TextColor3 = Color3.fromRGB(255, 0, 128)
    Title.Font = Enum.Font.GothamBold
    Title.TextSize = 20

    local Content = Instance.new("Frame")
    Content.Size = UDim2.new(1, -160, 1, 0)
    Content.Position = UDim2.new(0, 160, 0, 0)
    Content.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    Content.BorderSizePixel = 0
    Content.Parent = MainFrame
    Instance.new("UICorner", Content).CornerRadius = UDim.new(0, 10)

    local UIListLayout = Instance.new("UIListLayout", Content)
    UIListLayout.Padding = UDim.new(0, 8)
    UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder

    local Elements = {}

    function Elements:Button(text, callback)
        local button = Instance.new("TextButton", Content)
        button.Size = UDim2.new(1, -20, 0, 40)
        button.Text = text
        button.TextColor3 = Color3.new(1, 1, 1)
        button.Font = Enum.Font.Gotham
        button.TextSize = 16
        button.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
        button.BorderSizePixel = 0
        Instance.new("UICorner", button).CornerRadius = UDim.new(0, 6)
        button.MouseButton1Click:Connect(function()
            pcall(callback)
        end)
    end

    function Elements:Toggle(text, default, callback)
        local toggle = Instance.new("TextButton", Content)
        toggle.Size = UDim2.new(1, -20, 0, 40)
        toggle.Text = text
        toggle.Font = Enum.Font.Gotham
        toggle.TextSize = 16
        toggle.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
        toggle.BorderSizePixel = 0
        toggle.TextColor3 = Color3.new(1, 1, 1)
        Instance.new("UICorner", toggle).CornerRadius = UDim.new(0, 6)

        local on = default or false
        local function update()
            toggle.TextColor3 = on and Color3.fromRGB(255, 0, 128) or Color3.new(1, 1, 1)
            callback(on)
        end

        toggle.MouseButton1Click:Connect(function()
            on = not on
            update()
        end)

        update()
    end

    function Elements:Dropdown(text, options, callback)
        local container = Instance.new("Frame", Content)
        container.Size = UDim2.new(1, -20, 0, 40 + (#options * 30))
        container.BackgroundTransparency = 1

        local dropdown = Instance.new("TextButton", container)
        dropdown.Size = UDim2.new(1, 0, 0, 40)
        dropdown.Text = text
        dropdown.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
        dropdown.TextColor3 = Color3.new(1, 1, 1)
        dropdown.Font = Enum.Font.Gotham
        dropdown.TextSize = 16
        Instance.new("UICorner", dropdown).CornerRadius = UDim.new(0, 6)

        for _, option in ipairs(options) do
            local opt = Instance.new("TextButton", container)
            opt.Size = UDim2.new(1, 0, 0, 30)
            opt.Position = UDim2.new(0, 0, 0, 40 + ((_ - 1) * 30))
            opt.Text = option
            opt.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
            opt.TextColor3 = Color3.new(1, 1, 1)
            opt.Font = Enum.Font.Gotham
            opt.TextSize = 14
            Instance.new("UICorner", opt).CornerRadius = UDim.new(0, 6)

            opt.MouseButton1Click:Connect(function()
                dropdown.Text = option
                callback(option)
            end)
        end
    end

    function Elements:Slider(text, min, max, callback)
        local sliderFrame = Instance.new("Frame", Content)
        sliderFrame.Size = UDim2.new(1, -20, 0, 60)
        sliderFrame.BackgroundTransparency = 1

        local label = Instance.new("TextLabel", sliderFrame)
        label.Size = UDim2.new(1, 0, 0, 20)
        label.Text = text
        label.TextColor3 = Color3.new(1, 1, 1)
        label.Font = Enum.Font.Gotham
        label.TextSize = 14
        label.BackgroundTransparency = 1

        local bar = Instance.new("Frame", sliderFrame)
        bar.Size = UDim2.new(1, 0, 0, 10)
        bar.Position = UDim2.new(0, 0, 0, 25)
        bar.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
        bar.BorderSizePixel = 0

        local fill = Instance.new("Frame", bar)
        fill.Size = UDim2.new(0, 0, 1, 0)
        fill.BackgroundColor3 = Color3.fromRGB(255, 0, 128)
        fill.BorderSizePixel = 0

        local dragging = false
        bar.InputBegan:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 then
                dragging = true
            end
        end)
        UIS.InputEnded:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 then
                dragging = false
            end
        end)
        UIS.InputChanged:Connect(function(input)
            if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
                local relX = math.clamp((input.Position.X - bar.AbsolutePosition.X) / bar.AbsoluteSize.X, 0, 1)
                fill.Size = UDim2.new(relX, 0, 1, 0)
                local value = math.floor((min + ((max - min) * relX)) + 0.5)
                callback(value)
            end
        end)
    end

    return Elements
end

return SkyHubUI
