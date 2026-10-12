```markdown
# **Potassium Roblox Exploit UI Framework**
**Client-Side LuaU UI System for Potassium Executor**
*Optimized for Roblox exploit development with modular tabs, sub-tabs, and dynamic panels.*

---

## **📌 Quick Start**
1. **Load the script** in Potassium Executor.
2. **UI auto-initializes** with 3 default tabs: *Players*, *Settings*, *ESP*.
3. **All elements are client-side** and persist through respawns (`ResetOnSpawn = false`).

---

## **🗂️ Core Structure**
```
UI
├── Tabs (Vertical Stack)
│   ├── Sub-Tabs (Horizontal)
│   │   └── Panels (Scrollable Containers)
│   │       ├── Buttons
│   │       ├── Toggles
│   │       ├── Keybinds
│   │       ├── Player Dropdowns
│   │       └── Custom Elements
```

---

## **➕ Adding New Components**

### **1️⃣ Add a New Tab**
```lua
local NewTab = Window:AddTab("Tab Name")
```
- **Returns**: `Frame` (container for content).
- **Auto-positions** vertically in the tab sidebar.
- **Example**:
  ```lua
  local ExploitsTab = Window:AddTab("Exploits")
  ```

---

### **2️⃣ Add Sub-Tabs to a Tab**
*(Requires manual implementation—extend `UI` object.)*
```lua
-- Inside the UI table (after UI.new), add:
function UI:AddSubTab(ParentTab, Name)
    local SubTab = {
        Button = Create("TextButton", {
            Parent = ParentTab.SubTabContainer,  -- Requires SubTabContainer in ParentTab
            Text = Name,
            TextColor3 = Theme.Text,
            Size = UDim2.new(0, 100, 1, 0),
            BackgroundTransparency = 0.5,
            Font = Enum.Font.Gotham,
            TextSize = 14
        }),
        Frame = Create("Frame", {
            Parent = ParentTab.Frame,
            Size = UDim2.new(1, 0, 1, 0),
            BackgroundTransparency = 1,
            Visible = false
        })
    }

    SubTab.Button.MouseButton1Click:Connect(function()
        if ParentTab.CurrentSubTab then
            ParentTab.CurrentSubTab.Frame.Visible = false
        end
        SubTab.Frame.Visible = true
        ParentTab.CurrentSubTab = SubTab
    end)

    return SubTab.Frame
end

-- Usage:
local SubTab1 = Window:AddSubTab(ExploitsTab, "Aim Assist")
local SubTab2 = Window:AddSubTab(ExploitsTab, "Movement")
```

---

### **3️⃣ Add Panels to a Sub-Tab**
```lua
local Panel = UI:AddScrollFrame(SubTabFrame)
```
- **Returns**: `ScrollingFrame` with auto-adjusting canvas.
- **Example**:
  ```lua
  local AimPanel = UI:AddScrollFrame(SubTab1)
  ```

---

### **4️⃣ Add Elements to Panels**
#### **Buttons**
```lua
local Button = Create("TextButton", {
    Parent = Panel,
    Text = "Click Me",
    Size = UDim2.new(1, -10, 0, 30),
    BackgroundColor3 = Theme.Button,
    TextColor3 = Theme.Text,
    Font = Enum.Font.Gotham,
    TextSize = 14
})
Button.MouseButton1Click:Connect(function()
    print("Button clicked!")
end)
```

#### **Toggles**
```lua
UI:AddToggle(Panel, "Enable Feature", false, function(State)
    print("Toggle:", State)
end)
```

#### **Keybinds**
```lua
UI:AddKeybind(Panel, "Activate", "F5", function(Key)
    print("Keybind set to:", Key)
end)
```

#### **Player Dropdowns**
```lua
UI:AddPlayerDropdown(Panel, targetPlayer)
```

---

## **🔧 ESP System**
- **Auto-initializes** with the `ESP` tab.
- **Toggle globally**:
  ```lua
  ESP:Toggle(true)  -- Enable
  ESP:Toggle(false) -- Disable
  ```
- **Customize ESP tags**:
  - Modify `ESP:CreateTag()` to change BillboardGui appearance (e.g., colors, size, text format).
  - Update interval: `0.112` seconds (adjust in `ESP:Init()` coroutine).

---

## **🎨 Theming**
Modify the `Theme` table at the top of the script:
```lua
local Theme = {
    BG = Color3.fromRGB(30, 30, 30),      -- Main background
    Text = Color3.fromRGB(255, 255, 255), -- Text
    Button = Color3.fromRGB(70, 70, 70),  -- Buttons
    Dropdown = Color3.fromRGB(45, 45, 45),-- Dropdowns
    ESP = Color3.fromRGB(255, 50, 50)     -- ESP name color
}
```

---

## **📜 Full Example: Adding a New Tab with Sub-Tabs**
```lua
-- 1. Add a new tab
local CheatsTab = Window:AddTab("Cheats")

-- 2. Add sub-tabs (requires UI:AddSubTab implementation)
local CombatSubTab = Window:AddSubTab(CheatsTab, "Combat")
local MovementSubTab = Window:AddSubTab(CheatsTab, "Movement")

-- 3. Add panels to sub-tabs
local CombatPanel = UI:AddScrollFrame(CombatSubTab)
local MovementPanel = UI:AddScrollFrame(MovementSubTab)

-- 4. Add elements to panels
UI:AddToggle(CombatPanel, "Aimlock", false, function(State)
    print("Aimlock:", State)
end)

UI:AddToggle(MovementPanel, "Speed Hack", false, function(State)
    print("Speed Hack:", State)
end)
```

---

## **🚀 Expansion Tips**
1. **Reuse `Create()`** for all instances to maintain consistency.
2. **Anchor UI elements** properly (e.g., `AnchorPoint`, `Position`).
3. **Test in Potassium**—some Roblox API features may require executor-specific tweaks.
4. **Optimize loops**: Use `task.wait()` instead of `wait()` for better performance.
5. **Error handling**: Wrap coroutines in `pcall` for crash resistance.

---
## **🔍 Debugging**
- **Check `CoreGui`** for the UI container (`Window.Container`).
- **Verify instance paths** (e.g., `Player.Character.HumanoidRootPart`).
- **Use `print()`** to log values (e.g., `print(Player.Name)` in dropdown loops).
```
