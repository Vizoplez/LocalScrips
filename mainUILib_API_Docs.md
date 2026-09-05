# ExploitUILib — API Documentation

## Overview
Drawing-based Roblox UI framework. No ScreenGui instances (except one hidden TextBox for keyboard input). Window is draggable, resizable, scrollable, with sidebar/tab navigation. All element widths scale with the window width.

## Loading
```lua
local UILib = loadstring(game:HttpGet("https://raw.githubusercontent.com/Vizoplez/LocalScrips/refs/heads/master/MainUILib/ExploitUILib.lua"))()
```

## Creating a UI Instance
```lua
local UI = UILib.new({
    title     = "My Menu",       -- string, optional — defaults to game.Name .. " Menu"
    x         = 200,             -- number, screen X position
    y         = 100,             -- number, screen Y position
    width     = 700,             -- number, min 350
    height    = 500,             -- number, min 250
    toggleKey = Enum.KeyCode.Home -- KeyCode to show/hide
})
```

## Public API Methods

### `UI:Sub(name)` → sub object
Creates or retrieves a sidebar subcategory. Subs appear as clickable entries on the left sidebar (170px wide).
- `name`: string, display name in sidebar

### `UI:Tab(subName, tabName)` → tab object
Creates or retrieves a tab inside a subcategory. Tabs appear as buttons in the tab bar below the top header.
- `subName`: string, must match a Sub name
- `tabName`: string, display name in tab bar

### `UI:Select(subName, tabName)`
Switches the UI to show the given subcategory and tab. Resets scroll to top.
- `subName`: string
- `tabName`: string

### `UI:AddNum(tab, name, attributeName)`
Adds a number control to a tab. Renders a card with:
- Current value display
- Clickable input field (hidden TextBox)
- Confirm button
- Toggle Locked checkbox (re-applies confirmed value every 1s)

Parameters:
- `tab`: tab object from `UI:Tab()`
- `name`: string, display label
- `attributeName`: string, the player Attribute key to read/write via `player:GetAttribute/SetAttribute`

### `UI:AddBool(tab, name, attributeName)`
Adds a boolean toggle to a tab. Renders a card with:
- Clickable checkmark (green when true, gray when false)
- Status label ("Enabled"/"Disabled")
- Toggle Locked checkbox (re-applies locked state every 1s)

Parameters:
- `tab`: tab object from `UI:Tab()`
- `name`: string, display label
- `attributeName`: string, the player Attribute key

### `UI:SetVisible(bool)`
Show or hide the UI overlay.

### `UI:Destroy()`
Clean up all Drawing objects, connections, and the hidden TextBox.

### `UI:Start()`
Begin the render loop and hook input events. Must be called after setting up all subs/tabs/elements. Don't call this until we're ready to start rendering, or need to re-initialise rendering due to opening or closing the tab.

## Internal Architecture

### Layout Structure
```
┌─────────────────────────────────────────┐
│  Top Bar (30px) — title + close button  │  ← draggable
├────────┬────────────────────────────────┤
│        │  Tab Bar (26px)                │
│Sidebar ├────────────────────────────────┤
│ 170px  │  Content Area (scrollable)     │
│        │  ┌─────────────────────────┐   │
│        │  │ Num Card (110px)        │   │
│        │  │ Bool Card (70px)        │   │
│        │  └─────────────────────────┘   │
│        │  ┌─────────────────────────┐   │
│        │  │ ... more elements       │   │
│        │  └─────────────────────────┘   │
├────────┴────────────────────────────────┤
│  Resize handle (bottom-right corner)    │
└─────────────────────────────────────────┘
```

### Element Cards
- **Num Card**: 110px tall, contains title → current value → input field + confirm button → toggle locked checkbox
- **Bool Card**: 70px tall, contains title → checkmark toggle (right-aligned) → toggle locked checkbox

Both card widths are `cw - 4` where `cw = window_width - 170` (responsive to window resize).

### Input Flow
1. User clicks input field → hidden TextBox positioned over it, becomes visible
2. User types number, presses Confirm button (or Enter key)
3. Value written via `player:SetAttribute(attrName, value)`
4. TextBox hidden again

### Lock Loop
Runs every 1 second in a `task.spawn` thread. For each attribute with `_lock[attr] == true`, re-applies the confirmed value via `pcall(setAttr, attr, confValue)`. This ensures locked values persist even if the game tries to change them.

### Render Loop
Connected to `RunService.RenderStepped`. Each frame:
1. Clears all previous Drawing objects and clickable areas
2. Redraws everything from scratch based on current state
3. Clickable areas are stored as bounding-box + callback pairs
4. Input events check against these areas

### State Tables (all on UI instance)
- `_subs`: `{ [subName] = { name, tabs = { [tabName] = { name, elements = {} } }, tabOrder = {} } }`
- `_lockNum`: `{ [attributeName] = boolean }` — whether each number is locked
- `_lockBool`: `{ [attributeName] = boolean }` — whether each bool is locked
- `_confNum`: `{ [attributeName] = number }` — confirmed number value
- `_confBool`: `{ [attributeName] = boolean }` — confirmed bool value

## Adding New Element Types

To add a new control type (e.g. button, dropdown, slider):

1. Create an `AddXxx(tab, name, ...)` method that inserts an element with `type = "xxx"` into `tab.elements`
2. Create a `_drawXxxElement(elem, sx, ey, cw, ...)` method that draws the card
3. In the `_render()` loop, add an `elseif elem.type == "xxx"` branch calling your draw method
4. Element height is fixed per-card — update the `ey` offset after drawing

Example skeleton:
```lua
function self:AddButton(tab, name, callback)
    table.insert(tab.elements, {
        type = "button",
        name = name,
        cb   = callback
    })
end

function self:_drawButtonElement(elem, sx, ey, cw)
    local cardH = 40
    self:_drawRect(sx + 2, ey, cw - 4, cardH, Color3.fromRGB(25, 25, 25))
    self:_drawText(elem.name, sx + 10, ey + 10, 15, Color3.fromRGB(220, 220, 220))
    self:_addClickable(sx + 2, ey, cw - 4, cardH, elem.cb)
end
```

Then in `_render()`:
```lua
elseif elem.type == "button" then
    self:_drawButtonElement(elem, sx, ey2, cw)
    ey = ey + 40 + 10
```

## Element Data Structure
Each element in `tab.elements` is a table with at minimum:
- `type`: string ("num", "bool", or custom)
- `name`: string, display label
- `attr`: string, attribute key (for num/bool)
- Custom types can add any additional fields (e.g. `cb` for buttons)