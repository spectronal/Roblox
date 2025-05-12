--// NovaUI - UI Library moderna e clean
--// Feito por ChatGPT, inspirado em Venyx, Orion e Rayfield

local NovaUI = {}
NovaUI.__index = NovaUI

local TweenService = game:GetService("TweenService")
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

local function create(class, props)
    local inst = Instance.new(class)
    for prop, value in pairs(props) do
        inst[prop] = value
    end
    return inst
end

function NovaUI:CreateWindow(title)
    local self = setmetatable({}, NovaUI)
    
    -- Main UI
    local ScreenGui = create("ScreenGui", {
        Name = "NovaUI",
        Parent = game.CoreGui,
        ResetOnSpawn = false
    })

    local MainFrame = create("Frame", {
        Name = "MainFrame",
        Parent = ScreenGui,
        AnchorPoint = Vector2.new(0.5, 0.5),
        Position = UDim2.new(0.5, 0, 0.5, 0),
        Size = UDim2.new(0, 500, 0, 300),
        BackgroundColor3 = Color3.fromRGB(30, 30, 30),
        BorderSizePixel = 0
    })

    local UICorner = create("UICorner", { CornerRadius = UDim.new(0, 12), Parent = MainFrame })
    local UIStroke = create("UIStroke", { Color = Color3.fromRGB(70, 70, 70), Thickness = 1.5, Parent = MainFrame })

    local Title = create("TextLabel", {
        Text = title or "NovaUI",
        Parent = MainFrame,
        Size = UDim2.new(1, 0, 0, 40),
        BackgroundTransparency = 1,
        Font = Enum.Font.GothamBold,
        TextSize = 20,
        TextColor3 = Color3.fromRGB(255, 255, 255)
    })

    local TabsHolder = create("Frame", {
        Parent = MainFrame,
        Position = UDim2.new(0, 0, 0, 40),
        Size = UDim2.new(0, 120, 1, -40),
        BackgroundColor3 = Color3.fromRGB(24, 24, 24),
        BorderSizePixel = 0
    })

    create("UICorner", { CornerRadius = UDim.new(0, 12), Parent = TabsHolder })

    local PagesHolder = create("Frame", {
        Parent = MainFrame,
        Position = UDim2.new(0, 125, 0, 45),
        Size = UDim2.new(1, -130, 1, -50),
        BackgroundTransparency = 1
    })

    local UIList = create("UIListLayout", {
        Parent = TabsHolder,
        SortOrder = Enum.SortOrder.LayoutOrder
    })

    self.Tabs = {}
    self.PagesHolder = PagesHolder
    self.TabsHolder = TabsHolder

    function self:CreateTab(tabName)
        local Button = create("TextButton", {
            Parent = TabsHolder,
            Size = UDim2.new(1, -10, 0, 35),
            BackgroundColor3 = Color3.fromRGB(40, 40, 40),
            Text = tabName,
            Font = Enum.Font.Gotham,
            TextSize = 14,
            TextColor3 = Color3.fromRGB(200, 200, 200)
        })

        local TabPage = create("ScrollingFrame", {
            Parent = PagesHolder,
            Visible = false,
            Size = UDim2.new(1, 0, 1, 0),
            CanvasSize = UDim2.new(0, 0, 0, 0),
            ScrollBarThickness = 4,
            BackgroundTransparency = 1
        })

        local UIListTab = create("UIListLayout", {
            Parent = TabPage,
            SortOrder = Enum.SortOrder.LayoutOrder,
            Padding = UDim.new(0, 6)
        })

        Button.MouseButton1Click:Connect(function()
            for _, tab in pairs(self.Tabs) do
                tab.Frame.Visible = false
            end
            TabPage.Visible = true
        end)

        local tab = {
            Frame = TabPage,
            AddLabel = function(_, text)
                local Label = create("TextLabel", {
                    Parent = TabPage,
                    Size = UDim2.new(1, -10, 0, 20),
                    BackgroundTransparency = 1,
                    Font = Enum.Font.Gotham,
                    TextSize = 14,
                    Text = text,
                    TextColor3 = Color3.fromRGB(220, 220, 220)
                })
            end,

            AddButton = function(_, text, callback)
                local Btn = create("TextButton", {
                    Parent = TabPage,
                    Size = UDim2.new(1, -10, 0, 30),
                    BackgroundColor3 = Color3.fromRGB(50, 50, 50),
                    Font = Enum.Font.Gotham,
                    TextSize = 14,
                    Text = text,
                    TextColor3 = Color3.fromRGB(255, 255, 255)
                })
                create("UICorner", { CornerRadius = UDim.new(0, 6), Parent = Btn })

                Btn.MouseButton1Click:Connect(function()
                    pcall(callback)
                end)
            end,

            AddToggle = function(_, text, default, callback)
                local ToggleFrame = create("Frame", {
                    Parent = TabPage,
                    Size = UDim2.new(1, -10, 0, 30),
                    BackgroundTransparency = 1
                })

                local ToggleBtn = create("TextButton", {
                    Parent = ToggleFrame,
                    Size = UDim2.new(0, 30, 1, 0),
                    BackgroundColor3 = default and Color3.fromRGB(0, 170, 127) or Color3.fromRGB(70, 70, 70),
                    Text = "",
                })
                create("UICorner", { CornerRadius = UDim.new(0, 6), Parent = ToggleBtn })

                local Label = create("TextLabel", {
                    Parent = ToggleFrame,
                    Position = UDim2.new(0, 40, 0, 0),
                    Size = UDim2.new(1, -40, 1, 0),
                    BackgroundTransparency = 1,
                    Font = Enum.Font.Gotham,
                    TextSize = 14,
                    Text = text,
                    TextColor3 = Color3.fromRGB(255, 255, 255),
                    TextXAlignment = Enum.TextXAlignment.Left
                })

                local toggled = default
                ToggleBtn.MouseButton1Click:Connect(function()
                    toggled = not toggled
                    TweenService:Create(ToggleBtn, TweenInfo.new(0.25), {
                        BackgroundColor3 = toggled and Color3.fromRGB(0, 170, 127) or Color3.fromRGB(70, 70, 70)
                    }):Play()
                    pcall(callback, toggled)
                end)
            end
        }

        table.insert(self.Tabs, tab)
        TabPage.Visible = #self.Tabs == 1 -- Exibe o primeiro por padrão
        return tab
    end

    return self
end

return NovaUI
