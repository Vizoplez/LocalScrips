--// Minimal Player Dropdown UI for Potassium + ESP
--// Features: Player list with dropdowns showing TP, HP, Distance + Global ESP Toggle
--// + Settings menu with keybind

local TweenService = game:GetService("TweenService")
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")

local Theme = {
    BG = Color3.fromRGB(30,30,30),
    Text = Color3.fromRGB(255,255,255),
    Button = Color3.fromRGB(70,70,70),
    ButtonHover = Color3.fromRGB(90,90,90),
    Dropdown = Color3.fromRGB(45,45,45),
    ESP = Color3.fromRGB(255, 50, 50)
}

local function Create(Type, Props)
    local Inst = Instance.new(Type)
    for k,v in pairs(Props) do Inst[k] = v end
    return Inst
end

local UI = {}
UI.__index = UI

-- ESP System
local ESP = {
    Enabled = false,
    Tags = {}
}

function ESP:CreateTag(Player)
    local function UpdateTag()
        local Character = Player.Character
        if not Character then return end

        local Humanoid = Character:FindFirstChildOfClass("Humanoid")
        local Head = Character:FindFirstChild("Head")
        local HRP = Character:FindFirstChild("HumanoidRootPart")
        local LocalHRP = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")

        if not Head or not LocalHRP then return end

        local HP = Humanoid and math.floor(Humanoid.Health) or 0
        local Distance = HRP and math.floor((HRP.Position - LocalHRP.Position).Magnitude) or 0

        if not ESP.Tags[Player] then
            local BillboardGui = Create("BillboardGui", {
                Parent = Head,
                Size = UDim2.new(0, 200, 0, 50),
                StudsOffset = Vector3.new(0, 2, 0),
                Adornee = Head,
                AlwaysOnTop = true,
                Enabled = ESP.Enabled
            })

            local Frame = Create("Frame", {
                Parent = BillboardGui,
                Size = UDim2.new(1, 0, 1, 0),
                BackgroundColor3 = Color3.fromRGB(0, 0, 0),
                BackgroundTransparency = 0.3
            })

            local NameLabel = Create("TextLabel", {
                Parent = Frame,
                Text = Player.Name,
                TextColor3 = Theme.ESP,
                TextSize = 14,
                Font = Enum.Font.GothamBold,
                BackgroundTransparency = 1,
                Size = UDim2.new(1, 0, 0.4, 0),
                Position = UDim2.new(0, 0, 0, 0),
                TextStrokeTransparency = 0
            })

            local InfoLabel = Create("TextLabel", {
                Parent = Frame,
                Text = "HP: "..HP.." | Distance: "..Distance,
                TextColor3 = Theme.Text,
                TextSize = 12,
                Font = Enum.Font.Gotham,
                BackgroundTransparency = 1,
                Size = UDim2.new(1, 0, 0.6, 0),
                Position = UDim2.new(0, 0, 0.4, 0),
                TextStrokeTransparency = 0
            })

            ESP.Tags[Player] = {
                BillboardGui = BillboardGui,
                NameLabel = NameLabel,
                InfoLabel = InfoLabel
            }
        else
            local Tag = ESP.Tags[Player]
            Tag.InfoLabel.Text = "HP: "..HP.." | Distance: "..Distance
            Tag.BillboardGui.Enabled = ESP.Enabled
        end
    end

    local Connection
    Connection = RunService.Heartbeat:Connect(function()
        if ESP.Enabled then
            UpdateTag()
        else
            if ESP.Tags[Player] then
                ESP.Tags[Player].BillboardGui.Enabled = false
            end
        end
    end)

    Player.CharacterAdded:Connect(function()
        if ESP.Tags[Player] then
            ESP.Tags[Player].BillboardGui:Destroy()
            ESP.Tags[Player] = nil
        end
        UpdateTag()
    end)
end

function ESP:Toggle(State)
    ESP.Enabled = State
    for Player, Tag in pairs(ESP.Tags) do
        Tag.BillboardGui.Enabled = State
    end
end

function ESP:Init()
    for _, Player in pairs(Players:GetPlayers()) do
        if Player ~= LocalPlayer then
            ESP:CreateTag(Player)
        end
    end

    Players.PlayerAdded:Connect(function(Player)
        if Player ~= LocalPlayer then
            ESP:CreateTag(Player)
        end
    end)

    Players.PlayerRemoving:Connect(function(Player)
        if ESP.Tags[Player] then
            ESP.Tags[Player].BillboardGui:Destroy()
            ESP.Tags[Player] = nil
        end
    end)

    coroutine.wrap(function()
        while true do
            task.wait(0.112)
            if ESP.Enabled then
                for _, Player in pairs(Players:GetPlayers()) do
                    if Player ~= LocalPlayer and Player.Character then
                        local Humanoid = Player.Character:FindFirstChildOfClass("Humanoid")
                        local HRP = Player.Character:FindFirstChild("HumanoidRootPart")
                        local LocalHRP = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")

                        if ESP.Tags[Player] and HRP and LocalHRP then
                            local HP = Humanoid and math.floor(Humanoid.Health) or 0
                            local Distance = math.floor((HRP.Position - LocalHRP.Position).Magnitude)
                            ESP.Tags[Player].InfoLabel.Text = "HP: "..HP.." | Distance: "..Distance
                        end
                    end
                end
            end
        end
    end)()
end

function UI.new()
    local self = setmetatable({}, UI)
    self.Container = Create("ScreenGui", {
        Parent = game.CoreGui,
        ResetOnSpawn = false
    })

    self.Main = Create("Frame", {
        Parent = self.Container,
        Size = UDim2.new(0,400,0,500),
        Position = UDim2.new(0.5,-200,0.5,-250),
        AnchorPoint = Vector2.new(0.5,0.5),
        BackgroundColor3 = Theme.BG,
        Draggable = true,
        Active = true
    })

    self.TabContainer = Create("Frame", {
        Parent = self.Main,
        Size = UDim2.new(0,100,1,0),
        BackgroundColor3 = Color3.fromRGB(40,40,40)
    })

    self.Content = Create("Frame", {
        Parent = self.Main,
        Size = UDim2.new(1,-100,1,0),
        Position = UDim2.new(0,100,0,0),
        BackgroundTransparency = 1
    })

    self.Tabs = {}
    self.CurrentTab = nil

    local TabListLayout = Create("UIListLayout", {
        Parent = self.TabContainer,
        FillDirection = Enum.FillDirection.Vertical,
        SortOrder = Enum.SortOrder.LayoutOrder,
        Padding = UDim.new(0, 0)
    })

    function self:AddTab(Name)
        local Tab = {
            Button = Create("TextButton", {
                Parent = self.TabContainer,
                Text = Name,
                TextColor3 = Theme.Text,
                Size = UDim2.new(1, 0, 0, 30),
                BackgroundColor3 = Color3.fromRGB(40, 40, 40),
                Font = Enum.Font.Gotham,
                TextSize = 14,
                LayoutOrder = #self.Tabs + 1
            }),
            Frame = Create("Frame", {
                Parent = self.Content,
                Size = UDim2.new(1, 0, 1, 0),
                BackgroundTransparency = 1,
                Visible = false
            })
        }

        Tab.Button.MouseButton1Click:Connect(function()
            if self.CurrentTab then
                self.CurrentTab.Button.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
                self.CurrentTab.Frame.Visible = false
            end
            Tab.Button.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
            Tab.Frame.Visible = true
            self.CurrentTab = Tab
        end)

        table.insert(self.Tabs, Tab)
        if not self.CurrentTab then
            Tab.Button.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
            Tab.Frame.Visible = true
            self.CurrentTab = Tab
        end
        return Tab.Frame
    end

    return self
end

function UI:AddScrollFrame(Parent)
    local Frame = Create("ScrollingFrame", {
        Parent = Parent,
        Size = UDim2.new(1, 0, 1, 0),
        BackgroundTransparency = 1,
        ScrollBarThickness = 5
    })
    local Layout = Create("UIListLayout", {
        Parent = Frame,
        Padding = UDim.new(0, 5)
    })
    Layout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        Frame.CanvasSize = UDim2.new(0, 0, 0, Layout.AbsoluteContentSize.Y)
    end)
    return Frame
end

function UI:AddToggle(Parent, Text, Default, Callback)
    local Frame = Create("Frame", {
        Parent = Parent,
        Size = UDim2.new(1, 0, 0, 30),
        BackgroundTransparency = 1
    })

    Create("TextLabel", {
        Parent = Frame,
        Text = Text,
        TextColor3 = Theme.Text,
        Size = UDim2.new(0.7, 0, 1, 0),
        BackgroundTransparency = 1,
        Font = Enum.Font.Gotham,
        TextSize = 14,
        TextXAlignment = Enum.TextXAlignment.Left
    })

    local ToggleFrame = Create("TextButton", {
        Parent = Frame,
        Text = Default and "ON" or "OFF",
        TextColor3 = Default and Theme.Text or Color3.fromRGB(150, 150, 150),
        Size = UDim2.new(0.3, 0, 1, 0),
        Position = UDim2.new(0.7, 0, 0, 0),
        BackgroundColor3 = Default and Theme.Button or Theme.Dropdown,
        Font = Enum.Font.Gotham,
        TextSize = 14
    })

    local Toggled = Default or false
    ToggleFrame.MouseButton1Click:Connect(function()
        Toggled = not Toggled
        ToggleFrame.Text = Toggled and "ON" or "OFF"
        ToggleFrame.TextColor3 = Toggled and Theme.Text or Color3.fromRGB(150, 150, 150)
        ToggleFrame.BackgroundColor3 = Toggled and Theme.Button or Theme.Dropdown
        Callback(Toggled)
    end)

    return ToggleFrame
end

function UI:AddPlayerDropdown(Parent, Player)
    local Open = false
    local Dropdown = Create("Frame", {
        Parent = Parent,
        Size = UDim2.new(1, -10, 0, 30),
        BackgroundColor3 = Theme.Dropdown,
        Name = Player.Name
    })

    local Header = Create("TextButton", {
        Parent = Dropdown,
        Size = UDim2.new(1, 0, 0, 30),
        BackgroundTransparency = 1,
        Text = "",
        TextTransparency = 1
    })

    Create("TextLabel", {
        Parent = Header,
        Text = Player.Name,
        TextColor3 = Theme.Text,
        Size = UDim2.new(0.7, 0, 1, 0),
        BackgroundTransparency = 1,
        Font = Enum.Font.GothamBold,
        TextSize = 14,
        TextXAlignment = Enum.TextXAlignment.Left
    })

    local Toggle = Create("TextButton", {
        Parent = Header,
        Text = "▶",
        TextColor3 = Theme.Text,
        Size = UDim2.new(0.3, 0, 1, 0),
        Position = UDim2.new(0.7, 0, 0, 0),
        BackgroundTransparency = 1,
        Font = Enum.Font.GothamBold,
        TextSize = 14
    })

    local Content = Create("Frame", {
        Parent = Dropdown,
        Size = UDim2.new(1, 0, 0, 0),
        Position = UDim2.new(0, 0, 0, 30),
        BackgroundColor3 = Theme.Dropdown,
        Visible = false
    })

    local Info = Create("TextLabel", {
        Parent = Content,
        Text = "HP: 100 | Distance: 0",
        TextColor3 = Theme.Text,
        Size = UDim2.new(1, 0, 0, 20),
        BackgroundTransparency = 1,
        Font = Enum.Font.Gotham,
        TextSize = 12
    })

    local TPButton = Create("TextButton", {
        Parent = Content,
        Text = "Teleport",
        TextColor3 = Theme.Text,
        Size = UDim2.new(1, -10, 0, 30),
        Position = UDim2.new(0, 5, 0, 25),
        BackgroundColor3 = Theme.Button,
        Font = Enum.Font.Gotham,
        TextSize = 12
    })

    local function ToggleDropdown()
        Open = not Open
        Toggle.Text = Open and "▼" or "▶"
        Content.Visible = Open
        Dropdown.Size = UDim2.new(1, -10, 0, Open and 80 or 30)
    end

    Header.MouseButton1Click:Connect(ToggleDropdown)
    Toggle.MouseButton1Click:Connect(ToggleDropdown)

    TPButton.MouseButton1Click:Connect(function()
        local Char = Player.Character
        if Char and Char:FindFirstChild("HumanoidRootPart") and
           LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
            LocalPlayer.Character.HumanoidRootPart.CFrame = Char.HumanoidRootPart.CFrame
        end
    end)

    coroutine.wrap(function()
        while true do
            task.wait(0.5)
            local Char = Player.Character
            if Char then
                local Hum = Char:FindFirstChildOfClass("Humanoid")
                local HRP = Char:FindFirstChild("HumanoidRootPart")
                local LocalHRP = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")

                local HP = Hum and math.floor(Hum.Health) or "N/A"
                local Dist = HRP and LocalHRP and math.floor((HRP.Position - LocalHRP.Position).Magnitude) or "N/A"
                Info.Text = "HP: "..HP.." | Distance: "..Dist
            end
        end
    end)()

    return Dropdown
end

function UI:AddKeybind(Parent, Text, Default, Callback)
    local Frame = Create("Frame", {
        Parent = Parent,
        Size = UDim2.new(1, 0, 0, 30),
        BackgroundTransparency = 1
    })

    Create("TextLabel", {
        Parent = Frame,
        Text = Text,
        TextColor3 = Theme.Text,
        Size = UDim2.new(0.5, 0, 1, 0),
        BackgroundTransparency = 1,
        Font = Enum.Font.Gotham,
        TextSize = 14
    })

    local Button = Create("TextButton", {
        Parent = Frame,
        Text = Default or "NONE",
        TextColor3 = Theme.Text,
        Size = UDim2.new(0.5, -10, 1, -10),
        Position = UDim2.new(0.5, 5, 0, 5),
        BackgroundColor3 = Theme.Button,
        Font = Enum.Font.Gotham,
        TextSize = 14
    })

    local Binding = false
    Button.MouseButton1Click:Connect(function()
        Binding = true
        Button.Text = "[...]"
    end)

    UserInputService.InputBegan:Connect(function(Input, Processed)
        if not Binding or Processed then return end
        Binding = false
        Button.Text = Input.KeyCode.Name
        Callback(Input.KeyCode.Name)
    end)
end

--// Initialize UI and ESP
local Window = UI.new()
local PlayersTab = Window:AddTab("Players")
local SettingsTab = Window:AddTab("Settings")
local ESPTab = Window:AddTab("ESP")

--// Players Tab
local PlayerScroll = UI:AddScrollFrame(PlayersTab)

--// Add all players
for _, P in pairs(Players:GetPlayers()) do
    if P ~= LocalPlayer then
        UI:AddPlayerDropdown(PlayerScroll, P)
    end
end

--// Update players
Players.PlayerAdded:Connect(function(P)
    if P ~= LocalPlayer then
        UI:AddPlayerDropdown(PlayerScroll, P)
    end
end)

Players.PlayerRemoving:Connect(function(P)
    for _, C in pairs(PlayerScroll:GetChildren()) do
        if C:IsA("Frame") and C.Name == P.Name then
            C:Destroy()
        end
    end
end)

--// Settings Tab
local SettingsScroll = UI:AddScrollFrame(SettingsTab)
UI:AddKeybind(SettingsScroll, "Toggle Menu", "F3", function(Key)
    local KeybindConnection
    KeybindConnection = UserInputService.InputBegan:Connect(function(Input)
        if Input.KeyCode.Name == Key then
            Window.Main.Visible = not Window.Main.Visible
        end
    end)
end)

--// ESP Tab
local ESPScroll = UI:AddScrollFrame(ESPTab)
UI:AddToggle(ESPScroll, "Global Player ESP", false, function(State)
    ESP:Toggle(State)
end)

-- Initialize ESP system
ESP:Init()
