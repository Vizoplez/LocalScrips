# **Potassium-Compatible UI Library (Roblox LuaU)**
*Client-Side Framework for Exploit Development*
*Optimized for JailBreak AI Reference*

---

## **📌 Overview**
A lightweight, modular UI library for **Potassium Executor** written in **Roblox LuaU**. Supports:
✅ **Tabs & Sub-Tabs** (Nested UI)
✅ **Toggles, Buttons, Inputs** (Interactive Elements)
✅ **Theming** (Custom Colors)
✅ **Draggable Window** (User Movement)
✅ **Tween Animations** (Smooth Transitions)

**Environment:** Client-side (LocalScript context)
**Executor:** Potassium (Supports UNC standard + tweaks)

---

---

## **🔧 Core Structure**

### **1. Library Initialization**
```lua
local UILibrary = {}
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local LocalPlayer = game:GetService("Players").LocalPlayer
local Mouse = LocalPlayer:GetMouse()
```

### **2. Theme System (Customizable)**
```lua
local Theme = {
    Background = Color3.fromRGB(30, 30, 30),      -- Main frame background
    Accent = Color3.fromRGB(50, 150, 255),         -- Highlight color
    Text = Color3.fromRGB(255, 255, 255),          -- Default text
    TabBG = Color3.fromRGB(40, 40, 40),            -- Tab background
    TabSelected = Color3.fromRGB(60, 60, 60),       -- Selected tab
    ToggleOn = Color3.fromRGB(0, 200, 0),          -- Active toggle
    ToggleOff = Color3.fromRGB(200, 0, 0),         -- Inactive toggle
    Button = Color3.fromRGB(70, 70, 70),           -- Button color
    ButtonHover = Color3.fromRGB(90, 90, 90),      -- Hover effect
    InputBG = Color3.fromRGB(50, 50, 50),          -- Input field
    Border = Color3.fromRGB(100, 100, 100)         -- Border color
}
```
**Usage:** Modify `Theme` table before `UI.new()` to apply global styling.

---

## **⚙️ Utility Functions**

### **1. Instance Creation Helper**
```lua
local function CreateInstance(Type, Properties)
    local Instance = Instance.new(Type)
    for i, v in pairs(Properties) do
        Instance[i] = v
    end
    return Instance
end
```
**Purpose:** Dynamically creates Roblox instances with given properties.

### **2. Tween Animation Helper**
```lua
local function Tween(Object, Properties, Duration, Style, Direction)
    local Info = TweenInfo.new(
        Duration or 0.2,
        Style or Enum.EasingStyle.Quad,
        Direction or Enum.EasingDirection.Out
    )
    local Tween = TweenService:Create(Object, Info, Properties)
    Tween:Play()
    return Tween
end
```
**Arguments:**
| Arg | Type | Default | Description |
|-----|------|---------|-------------|
| `Object` | `Instance` | *Required* | Target instance to tween |
| `Properties` | `table` | *Required* | Properties to animate (e.g., `{Transparency = 0}`) |
| `Duration` | `number` | `0.2` | Animation length (seconds) |
| `Style` | `Enum.EasingStyle` | `Quad` | Easing curve (e.g., `Linear`, `Back`) |
| `Direction` | `Enum.EasingDirection` | `Out` | Easing direction (`In`, `Out`, `InOut`) |

---

## **🖥️ UI Container (`UI.new()`)**

### **Initialization**
```lua
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
        Parent = game:GetService("CoreGui"),  -- Renders in exploit UI layer
        ZIndexBehavior = Enum.ZIndexBehavior.Sibling,
        ResetOnSpawn = false  -- Persists after respawn
    })
    -- ... (See full code in Appendix)
    return self
end
```
**Returns:** `UI` object with methods for tab/sub-tab management.

### **Key Properties**
| Property | Type | Description |
|----------|------|-------------|
| `Container` | `ScreenGui` | Parent of all UI elements |
| `MainFrame` | `Frame` | Primary draggable window |
| `TabContainer` | `Frame` | Left-side tab sidebar |
| `ContentContainer` | `Frame` | Area for tab content |

---

## **📑 Tab System**

### **1. Add a Tab (`UI:AddTab()`)**
```lua
function UI:AddTab(Name, Icon)
    local Tab = {
        Name = Name,
        Icon = Icon or "",  -- Optional (e.g., "🔥" for visual)
        SubTabs = {},
        CurrentSubTab = nil,
        TabButton = nil,
        SubTabContainer = self.SubTabContainer,
        ContentContainer = self.ContentContainer
    }

    -- Create clickable tab button
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
        self:SelectTab(Tab)  -- Auto-select first tab
    end
    return Tab
end
```
**Arguments:**
| Arg | Type | Description |
|-----|------|-------------|
| `Name` | `string` | Tab display name |
| `Icon` | `string` | Optional emoji/icon (e.g., "🎮") |

**Returns:** `Tab` object (for adding sub-tabs or elements).

---

### **2. Select a Tab (`UI:SelectTab()`)**
```lua
function UI:SelectTab(Tab)
    -- Deselect previous tab
    if self.CurrentTab then
        self.CurrentTab.TabButton.BackgroundColor3 = Theme.TabBG
    end

    -- Highlight selected tab
    Tab.TabButton.BackgroundColor3 = Theme.TabSelected
    self.CurrentTab = Tab
    self.CurrentSubTab = nil

    -- Show sub-tab container
    self.SubTabContainer.Visible = true
    self.ContentContainer.Visible = true

    -- Clear existing sub-tabs
    for _, v in pairs(self.SubTabList:GetChildren()) do
        if v:IsA("TextButton") then v:Destroy() end
    end

    -- Add sub-tabs for this tab
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
end
```

---

### **3. Add a Sub-Tab (`Tab:AddSubTab()`)**
*(Assumed method—extend the `Tab` object)*
```lua
function Tab:AddSubTab(Name)
    local SubTab = {
        Name = Name,
        Elements = {},
        ContentFrame = nil
    }

    SubTab.ContentFrame = CreateInstance("Frame", {
        Name = Name,
        Parent = self.ContentContainer,
        BackgroundTransparency = 1,
        Size = UDim2.new(1, 0, 1, 0),
        Visible = false  -- Hidden until selected
    })

    table.insert(self.SubTabs, SubTab)
    return SubTab
end
```

---

## **🎛️ UI Elements**

### **1. Toggle**
```lua
function SubTab:AddToggle(Name, Default, Callback)
    local Toggle = {
        Name = Name,
        Value = Default or false,
        Callback = Callback or function() end,
        ToggleButton = nil,
        ToggleFrame = nil
    }

    -- Container
    local Container = CreateInstance("Frame", {
        Parent = self.ContentFrame,
        BackgroundTransparency = 1,
        Size = UDim2.new(1, 0, 0, 30)
    })

    -- Label
    local Label = CreateInstance("TextLabel", {
        Parent = Container,
        Text = Name,
        TextColor3 = Theme.Text,
        TextSize = 14,
        Font = Enum.Font.Gotham,
        BackgroundTransparency = 1,
        Size = UDim2.new(0.7, 0, 1, 0),
        Position = UDim2.new(0, 0, 0, 0),
        TextXAlignment = Enum.TextXAlignment.Left
    })

    -- Toggle Frame
    Toggle.ToggleFrame = CreateInstance("Frame", {
        Parent = Container,
        BackgroundColor3 = Toggle.Value and Theme.ToggleOn or Theme.ToggleOff,
        BorderSizePixel = 0,
        Size = UDim2.new(0, 20, 0, 20),
        Position = UDim2.new(0.85, 0, 0.15, 0),
        AnchorPoint = Vector2.new(0.5, 0.5)
    })

    -- Click Detection (Uses TextButton overlay)
    local Hitbox = CreateInstance("TextButton", {
        Parent = Container,
        BackgroundTransparency = 1,
        Size = UDim2.new(0, 20, 0, 20),
        Position = UDim2.new(0.85, 0, 0.15, 0),
        Text = "",
        AnchorPoint = Vector2.new(0.5, 0.5)
    })

    Hitbox.MouseButton1Click:Connect(function()
        Toggle.Value = not Toggle.Value
        Toggle.ToggleFrame.BackgroundColor3 = Toggle.Value and Theme.ToggleOn or Theme.ToggleOff
        Toggle.Callback(Toggle.Value)
    end)

    table.insert(self.Elements, Toggle)
    return Toggle
end
```
**Arguments:**
| Arg | Type | Description |
|-----|------|-------------|
| `Name` | `string` | Toggle label |
| `Default` | `bool` | Initial state (`true` = on) |
| `Callback` | `function` | Triggered on toggle (receives `newValue`) |

---

### **2. Button**
```lua
function SubTab:AddButton(Name, Callback)
    local Button = CreateInstance("TextButton", {
        Parent = self.ContentFrame,
        Text = Name,
        TextColor3 = Theme.Text,
        TextSize = 14,
        Font = Enum.Font.Gotham,
        BackgroundColor3 = Theme.Button,
        BorderSizePixel = 0,
        Size = UDim2.new(1, -10, 0, 30),
        Position = UDim2.new(0, 0, #self.Elements * 35, 0),
        TextXAlignment = Enum.TextXAlignment.Center
    })

    Button.MouseButton1Click:Connect(Callback or function() end)

    -- Hover effect
    Button.MouseEnter:Connect(function()
        Tween(Button, {BackgroundColor3 = Theme.ButtonHover}, 0.1)
    end)
    Button.MouseLeave:Connect(function()
        Tween(Button, {BackgroundColor3 = Theme.Button}, 0.1)
    end)

    table.insert(self.Elements, Button)
    return Button
end
```
**Arguments:**
| Arg | Type | Description |
|-----|------|-------------|
| `Name` | `string` | Button text |
| `Callback` | `function` | Triggered on click |

---

### **3. Text Input**
```lua
function SubTab:AddInput(Name, Default, Callback)
    local Input = {
        Name = Name,
        Value = Default or "",
        Callback = Callback or function() end,
        InputField = nil
    }

    -- Label
    local Label = CreateInstance("TextLabel", {
        Parent = self.ContentFrame,
        Text = Name,
        TextColor3 = Theme.Text,
        TextSize = 14,
        Font = Enum.Font.Gotham,
        BackgroundTransparency = 1,
        Size = UDim2.new(1, 0, 0, 20),
        Position = UDim2.new(0, 0, #self.Elements * 35, 0),
        TextXAlignment = Enum.TextXAlignment.Left
    })

    -- Input Box
    Input.InputField = CreateInstance("TextBox", {
        Parent = self.ContentFrame,
        Text = Input.Value,
        TextColor3 = Theme.Text,
        PlaceholderColor3 = Color3.fromRGB(150, 150, 150),
        PlaceholderText = "Enter text...",
        BackgroundColor3 = Theme.InputBG,
        BorderSizePixel = 0,
        Size = UDim2.new(1, -10, 0, 30),
        Position = UDim2.new(0, 0, #self.Elements * 35 + 20, 0),
        Font = Enum.Font.Gotham,
        TextSize = 14
    })

    Input.InputField:GetPropertyChangedSignal("Text"):Connect(function()
        Input.Value = Input.InputField.Text
        Input.Callback(Input.Value)
    end)

    table.insert(self.Elements, Input)
    return Input
end
```
**Arguments:**
| Arg | Type | Description |
|-----|------|-------------|
| `Name` | `string` | Input label |
| `Default` | `string` | Pre-filled text |
| `Callback` | `function` | Triggered on text change (receives `newText`) |

---

## **🗑️ Cleanup & Destruction**
The library includes a **close button** (top-right "X") that destroys the entire `ScreenGui`:
```lua
self.CloseButton.MouseButton1Click:Connect(function()
    self.Container:Destroy()
end)
```

---

## **📜 Full Code Appendix**
```lua
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

    -- Clear Sub-Tabs
    for _, v in pairs(self.SubTabList:GetChildren()) do
        if v:IsA("TextButton") then
            v:Destroy()
        end
    end

    -- Add Sub-Tabs for Selected Tab
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
end

--// Select a Sub-Tab (Assumed Implementation)
function UI:SelectSubTab(SubTab)
    if self.CurrentSubTab then
        self.CurrentSubTab.SubTabButton.BackgroundTransparency = 1
        self.CurrentSubTab.ContentFrame.Visible = false
    end
    SubTab.SubTabButton.BackgroundColor3 = Theme.Accent
    SubTab.ContentFrame.Visible = true
    self.CurrentSubTab = SubTab
end

return UILibrary
```

---

## **🚀 Usage Example**
```lua
local UI = loadstring(game:HttpGet("UI_LIBRARY_URL"))()  -- Replace with actual loader
local Window = UI.new("My Exploit UI")

-- Add a tab
local MainTab = Window:AddTab("Main", "🏠")

-- Add a sub-tab
local AimTab = MainTab:AddSubTab("Aim Assist")

-- Add a toggle
AimTab:AddToggle("Enabled", false, function(Value)
    print("Aim Assist:", Value)
end)

-- Add a button
AimTab:AddButton("Test Fire", function()
    print("Firing test shot!")
end)

-- Add an input
AimTab:AddInput("FOV", "120", function(Value)
    print("FOV set to:", Value)
end)
```

---

## **🔍 Key Notes for Exploit Development**
1. **Client-Side Only**: All code runs in the **LocalScript** context.
2. **Potassium Compatibility**:
   - Supports `game:GetService("CoreGui")` for UI injection.
   - Uses `TweenService` for animations (available in Roblox client).
3. **No Remote Dependencies**: Pure client-side; no server communication.
4. **Error Handling**: Add `pcall` wrappers for critical functions if needed.
5. **Performance**: Avoid frequent `GetPropertyChangedSignal` calls in loops.

---
**Last Updated:** October 12, 2026
**Optimized for:** JailBreak AI Connector Reference
