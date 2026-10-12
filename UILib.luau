--// UILibrary | Potassium-Compatible Client-Side UI Framework
--// Supports: Tabs, Sub-Tabs, Panels, Toggles, Buttons, Inputs

local UILibrary = {}
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local LocalPlayer = game:GetService("Players").LocalPlayer
local Mouse = LocalPlayer:GetMouse()

--// Theme (Customizable)
local Theme = {
    Background = Color3.fromRGB(30, 30, 30),
    Accent = Color3.fromRGB(50, 150, 255),
    Text = Color3.fromRGB(255, 255, 255),
    TabBG = Color3.fromRGB(40, 40, 40),
    TabSelected = Color3.fromRGB(60, 60, 60),
    ToggleOn = Color3.fromRGB(0, 200, 0),
    ToggleOff = Color3.fromRGB(200, 0, 0),
    Button = Color3.fromRGB(70, 70, 70),
    ButtonHover = Color3.fromRGB(90, 90, 90),
    InputBG = Color3.fromRGB(50, 50, 50),
    Border = Color3.fromRGB(100, 100, 100)
}

--// Utility Functions
local function CreateInstance(Type, Properties)
    local Instance = Instance.new(Type)
    for i, v in pairs(Properties) do
        Instance[i] = v
    end
    return Instance
end

local function Tween(Object, Properties, Duration, Style, Direction)
    local Info = TweenInfo.new(Duration or 0.2, Style or Enum.EasingStyle.Quad, Direction or Enum.EasingDirection.Out)
    local Tween = TweenService:Create(Object, Info, Properties)
    Tween:Play()
    return Tween
end

--// UI Container
local UI = {}
UI.__index = UI

function UI.new(Name)
    local self = setmetatable({}, UI)
    self.Name = Name or "UILibrary"
    self.Tabs = {}
    self.CurrentTab = nil
    self.CurrentSubTab = nil
    self.Container = CreateInstance("ScreenGui", {
        Name = self.Name,
        Parent = game:GetService("CoreGui"),
        ZIndexBehavior = Enum.ZIndexBehavior.Sibling,
        ResetOnSpawn = false
    })

    --// Main Frame
    self.MainFrame = CreateInstance("Frame", {
        Name = "MainFrame",
        Parent = self.Container,
        BackgroundColor3 = Theme.Background,
        BorderSizePixel = 0,
        Size = UDim2.new(0, 500, 0, 350),
        Position = UDim2.new(0.5, -250, 0.5, -175),
        AnchorPoint = Vector2.new(0.5, 0.5),
        Active = true,
        Draggable = true
    })

    --// Title Bar
    self.TitleBar = CreateInstance("Frame", {
        Name = "TitleBar",
        Parent = self.MainFrame,
        BackgroundColor3 = Theme.TabSelected,
        BorderSizePixel = 0,
        Size = UDim2.new(1, 0, 0, 30),
        Position = UDim2.new(0, 0, 0, 0)
    })

    self.TitleText = CreateInstance("TextLabel", {
        Name = "TitleText",
        Parent = self.TitleBar,
        BackgroundTransparency = 1,
        Text = self.Name,
        TextColor3 = Theme.Text,
        TextSize = 16,
        Font = Enum.Font.GothamBold,
        Size = UDim2.new(1, 0, 1, 0),
        TextXAlignment = Enum.TextXAlignment.Left,
        TextPadding = UDim.new(10, 0)
    })

    --// Tab Container
    self.TabContainer = CreateInstance("Frame", {
        Name = "TabContainer",
        Parent = self.MainFrame,
        BackgroundColor3 = Theme.TabBG,
        BorderSizePixel = 0,
        Size = UDim2.new(0, 150, 1, -30),
        Position = UDim2.new(0, 0, 0, 30)
    })

    --// Tab List
    self.TabList = CreateInstance("ScrollingFrame", {
        Name = "TabList",
        Parent = self.TabContainer,
        BackgroundTransparency = 1,
        ScrollBarThickness = 0,
        CanvasSize = UDim2.new(0, 0, 0, 0),
        Size = UDim2.new(1, 0, 1, 0)
    })

    --// Sub-Tab Container
    self.SubTabContainer = CreateInstance("Frame", {
        Name = "SubTabContainer",
        Parent = self.MainFrame,
        BackgroundColor3 = Theme.TabSelected,
        BorderSizePixel = 0,
        Size = UDim2.new(1, -150, 0, 30),
        Position = UDim2.new(0, 150, 0, 30),
        Visible = false
    })

    --// Sub-Tab List
    self.SubTabList = CreateInstance("ScrollingFrame", {
        Name = "SubTabList",
        Parent = self.SubTabContainer,
        BackgroundTransparency = 1,
        ScrollBarThickness = 0,
        CanvasSize = UDim2.new(0, 0, 0, 0),
        Size = UDim2.new(1, 0, 1, 0)
    })

    --// Content Container
    self.ContentContainer = CreateInstance("Frame", {
        Name = "ContentContainer",
        Parent = self.MainFrame,
        BackgroundColor3 = Theme.Background,
        BorderSizePixel = 0,
        Size = UDim2.new(1, -150, 1, -60),
        Position = UDim2.new(0, 150, 0, 60),
        Visible = false
    })

    --// UIListLayout for Tabs
    local TabListLayout = CreateInstance("UIListLayout", {
        Parent = self.TabList,
        Padding = UDim.new(0, 5)
    })
    TabListLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        self.TabList.CanvasSize = UDim2.new(0, 0, 0, TabListLayout.AbsoluteContentSize.Y)
    end)

    --// UIListLayout for Sub-Tabs
    local SubTabListLayout = CreateInstance("UIListLayout", {
        Parent = self.SubTabList,
        FillDirection = Enum.FillDirection.Horizontal,
        Padding = UDim.new(0, 5)
    })
    SubTabListLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        self.SubTabList.CanvasSize = UDim2.new(0, SubTabListLayout.AbsoluteContentSize.X, 0, 0)
    end)

    --// Close Button
    self.CloseButton = CreateInstance("TextButton", {
        Name = "CloseButton",
        Parent = self.TitleBar,
        BackgroundTransparency = 1,
        Text = "X",
        TextColor3 = Theme.Text,
        TextSize = 14,
        Font = Enum.Font.GothamBold,
        Size = UDim2.new(0, 30, 0, 30),
        Position = UDim2.new(1, -30, 0, 0),
        TextXAlignment = Enum.TextXAlignment.Center
    })
    self.CloseButton.MouseButton1Click:Connect(function()
        self.Container:Destroy()
    end)

    return self
end

--// Add a Tab
function UI:AddTab(Name, Icon)
    local Tab = {
        Name = Name,
        Icon = Icon or "",
        SubTabs = {},
        CurrentSubTab = nil,
        TabButton = nil,
        SubTabContainer = self.SubTabContainer,
        ContentContainer = self.ContentContainer
    }

    --// Create Tab Button
    Tab.TabButton = CreateInstance("TextButton", {
        Name = Name,
        Parent = self.TabList,
        BackgroundColor3 = Theme.TabBG,
        BorderSizePixel = 0,
        Text = (Icon ~= "" and Icon .. "  " or "") .. Name,
        TextColor3 = Theme.Text,
        TextSize = 14,
        Font = Enum.Font.Gotham,
        Size = UDim2.new(1, -10, 0, 30),
        TextXAlignment = Enum.TextXAlignment.Left,
        TextPadding = UDim.new(10, 0)
    })

    Tab.TabButton.MouseButton1Click:Connect(function()
        self:SelectTab(Tab)
    end)

    table.insert(self.Tabs, Tab)
    if not self.CurrentTab then
        self:SelectTab(Tab)
    end

    return Tab
end

--// Select a Tab
function UI:SelectTab(Tab)
    if self.CurrentTab then
        self.CurrentTab.TabButton.BackgroundColor3 = Theme.TabBG
    end
    Tab.TabButton.BackgroundColor3 = Theme.TabSelected
    self.CurrentTab = Tab
    self.CurrentSubTab = nil
    self.SubTabContainer.Visible = true
    self.ContentContainer.Visible = true

    --// Clear Sub-Tabs
    for _, v in pairs(self.SubTabList:GetChildren()) do
        if v:IsA("TextButton") then
            v:Destroy()
        end
    end

    --// Add Sub-Tabs for Selected Tab
    for _, SubTab in pairs(Tab.SubTabs) do
        local SubTabButton = CreateInstance("TextButton", {
            Name = SubTab.Name,
            Parent = self.SubTabList,
            BackgroundTransparency = 1,
            Text = SubTab.Name,
            TextColor3 = Theme.Text,
            TextSize = 14,
            Font = Enum.Font.Gotham,
            Size = UDim2.new(0, 100, 1, 0),
            TextXAlignment = Enum.TextXAlignment.Center
        })

        SubTabButton.MouseButton1Click:Connect(function()
            self:SelectSubTab(SubTab)
        end)

        SubTab.SubTabButton = SubTabButton
    end

    if #Tab.SubTabs > 0 then
        self:SelectSubTab(Tab.SubTabs[1])
    else
        self.ContentContainer.Visible = false
    end
end

--// Add a Sub-Tab to a Tab
function UI:AddSubTab(Tab, Name)
    local SubTab = {
        Name = Name,
        Panels = {},
        Tab = Tab,
        ContentFrame = nil
    }

    SubTab.ContentFrame = CreateInstance("ScrollingFrame", {
        Name = Name .. "Content",
        Parent = self.ContentContainer,
        BackgroundTransparency = 1,
        ScrollBarThickness = 5,
        CanvasSize = UDim2.new(0, 0, 0, 0),
        Size = UDim2.new(1, 0, 1, 0),
        Visible = false
    })

    local PanelLayout = CreateInstance("UIListLayout", {
        Parent = SubTab.ContentFrame,
        Padding = UDim.new(10, 10)
    })
    PanelLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        SubTab.ContentFrame.CanvasSize = UDim2.new(0, 0, 0, PanelLayout.AbsoluteContentSize.Y)
    end)

    table.insert(Tab.SubTabs, SubTab)
    if not Tab.CurrentSubTab then
        self:SelectSubTab(SubTab)
    end

    return SubTab
end

--// Select a Sub-Tab
function UI:SelectSubTab(SubTab)
    if self.CurrentSubTab then
        self.CurrentSubTab.ContentFrame.Visible = false
        self.CurrentSubTab.SubTabButton.TextColor3 = Theme.Text
    end
    SubTab.ContentFrame.Visible = true
    SubTab.SubTabButton.TextColor3 = Theme.Accent
    self.CurrentSubTab = SubTab
    SubTab.Tab.CurrentSubTab = SubTab
end

--// Add a Panel to a Sub-Tab
function UI:AddPanel(SubTab, Name, Size)
    local Panel = {
        Name = Name,
        Elements = {},
        Frame = nil
    }

    Panel.Frame = CreateInstance("Frame", {
        Name = Name,
        Parent = SubTab.ContentFrame,
        BackgroundColor3 = Theme.Background,
        BorderColor3 = Theme.Border,
        BorderMode = Enum.BorderMode.Inset,
        Size = Size or UDim2.new(1, -20, 0, 100),
        AutomaticSize = Enum.AutomaticSize.None
    })

    local PanelTitle = CreateInstance("TextLabel", {
        Name = "PanelTitle",
        Parent = Panel.Frame,
        BackgroundTransparency = 1,
        Text = Name,
        TextColor3 = Theme.Text,
        TextSize = 14,
        Font = Enum.Font.GothamBold,
        Size = UDim2.new(1, 0, 0, 20),
        Position = UDim2.new(0, 0, 0, 0),
        TextXAlignment = Enum.TextXAlignment.Left,
        TextPadding = UDim.new(10, 0)
    })

    local ElementLayout = CreateInstance("UIListLayout", {
        Parent = Panel.Frame,
        Padding = UDim.new(10, 10),
        SortOrder = Enum.SortOrder.LayoutOrder
    })

    table.insert(SubTab.Panels, Panel)
    return Panel
end

--// Add a Toggle to a Panel
function UI:AddToggle(Panel, Name, Default, Callback)
    local Toggle = {
        Name = Name,
        State = Default or false,
        Callback = Callback or function() end,
        Button = nil,
        Indicator = nil
    }

    local ToggleContainer = CreateInstance("Frame", {
        Name = Name .. "Toggle",
        Parent = Panel.Frame,
        BackgroundTransparency = 1,
        Size = UDim2.new(1, 0, 0, 30)
    })

    Toggle.Button = CreateInstance("TextButton", {
        Name = "ToggleButton",
        Parent = ToggleContainer,
        BackgroundColor3 = Theme.Button,
        BorderSizePixel = 0,
        Text = Name,
        TextColor3 = Theme.Text,
        TextSize = 14,
        Font = Enum.Font.Gotham,
        Size = UDim2.new(0.6, 0, 1, 0),
        TextXAlignment = Enum.TextXAlignment.Left,
        TextPadding = UDim.new(10, 0)
    })

    local IndicatorContainer = CreateInstance("Frame", {
        Name = "IndicatorContainer",
        Parent = ToggleContainer,
        BackgroundColor3 = Theme.ToggleOff,
        BorderSizePixel = 0,
        Size = UDim2.new(0, 50, 1, -6),
        Position = UDim2.new(0.65, 10, 0, 3)
    })

    local Indicator = CreateInstance("Frame", {
        Name = "Indicator",
        Parent = IndicatorContainer,
        BackgroundColor3 = Theme.Text,
        BorderSizePixel = 0,
        Size = UDim2.new(0, 20, 1, 0),
        Position = UDim2.new(0, 0, 0, 0)
    })

    Toggle.Indicator = Indicator
    Toggle.IndicatorContainer = IndicatorContainer

    Toggle.Button.MouseButton1Click:Connect(function()
        Toggle.State = not Toggle.State
        if Toggle.State then
            IndicatorContainer.BackgroundColor3 = Theme.ToggleOn
            Tween(Indicator, {Position = UDim2.new(1, -20, 0, 0)}, 0.2)
        else
            IndicatorContainer.BackgroundColor3 = Theme.ToggleOff
            Tween(Indicator, {Position = UDim2.new(0, 0, 0, 0)}, 0.2)
        end
        Toggle.Callback(Toggle.State)
    end)

    if Toggle.State then
        IndicatorContainer.BackgroundColor3 = Theme.ToggleOn
        Indicator.Position = UDim2.new(1, -20, 0, 0)
    end

    table.insert(Panel.Elements, Toggle)
    return Toggle
end

--// Add a Button to a Panel
function UI:AddButton(Panel, Name, Callback)
    local Button = {
        Name = Name,
        Callback = Callback or function() end,
        Button = nil
    }

    Button.Button = CreateInstance("TextButton", {
        Name = Name .. "Button",
        Parent = Panel.Frame,
        BackgroundColor3 = Theme.Button,
        BorderSizePixel = 0,
        Text = Name,
        TextColor3 = Theme.Text,
        TextSize = 14,
        Font = Enum.Font.Gotham,
        Size = UDim2.new(1, -20, 0, 30),
        TextXAlignment = Enum.TextXAlignment.Center
    })

    Button.Button.MouseButton1Click:Connect(function()
        Button.Callback()
    end)

    Button.Button.MouseEnter:Connect(function()
        Button.Button.BackgroundColor3 = Theme.ButtonHover
    end)
    Button.Button.MouseLeave:Connect(function()
        Button.Button.BackgroundColor3 = Theme.Button
    end)

    table.insert(Panel.Elements, Button)
    return Button
end

--// Add an Input Box to a Panel
function UI:AddInput(Panel, Name, Placeholder, Default, Callback)
    local Input = {
        Name = Name,
        Placeholder = Placeholder or "",
        Default = Default or "",
        Callback = Callback or function() end,
        Box = nil,
        Button = nil
    }

    local InputContainer = CreateInstance("Frame", {
        Name = Name .. "Input",
        Parent = Panel.Frame,
        BackgroundTransparency = 1,
        Size = UDim2.new(1, 0, 0, 30)
    })

    Input.Box = CreateInstance("TextBox", {
        Name = "InputBox",
        Parent = InputContainer,
        BackgroundColor3 = Theme.InputBG,
        BorderSizePixel = 0,
        Text = Default,
        PlaceholderText = Placeholder,
        TextColor3 = Theme.Text,
        TextSize = 14,
        Font = Enum.Font.Gotham,
        Size = UDim2.new(0.7, 0, 1, 0),
        Position = UDim2.new(0, 0, 0, 0),
        TextXAlignment = Enum.TextXAlignment.Left,
        TextPadding = UDim.new(10, 0)
    })

    Input.Button = CreateInstance("TextButton", {
        Name = "SubmitButton",
        Parent = InputContainer,
        BackgroundColor3 = Theme.Button,
        BorderSizePixel = 0,
        Text = "Submit",
        TextColor3 = Theme.Text,
        TextSize = 14,
        Font = Enum.Font.Gotham,
        Size = UDim2.new(0.25, 0, 1, 0),
        Position = UDim2.new(0.72, 0, 0, 0),
        TextXAlignment = Enum.TextXAlignment.Center
    })

    Input.Button.MouseButton1Click:Connect(function()
        Input.Callback(Input.Box.Text)
    end)

    table.insert(Panel.Elements, Input)
    return Input
end

return UILibrary