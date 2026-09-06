# Rayfield (2022) — Complete API Reference

> **Source:** [docs.sirius.menu/rayfield](https://docs.sirius.menu/rayfield)  
> **GitHub:** [github.com/SiriusSoftwareLtd/Rayfield](https://github.com/SiriusSoftwareLtd/Rayfield)  
> **LLMs.txt:** [docs.sirius.menu/llms.txt](https://docs.sirius.menu/llms.txt)

---

## Table of Contents

1. [Loading the Library](#1-loading-the-library)
2. [CreateWindow](#2-createwindow)
3. [CreateTab](#3-createtab)
4. [Sections & Dividers](#4-sections--dividers)
5. [Interactive Elements](#5-interactive-elements)
6. [Keybinds](#6-keybinds)
7. [Text Elements](#7-text-elements)
8. [Notifications](#8-notifications)
9. [Themes](#9-themes)
10. [Anti-Detection](#10-anti-detection)
11. [Secure Mode](#11-secure-mode)
12. [Configuration Saving](#12-configuration-saving)
13. [Utility Methods](#13-utility-methods)
14. [Element Value Reading](#14-element-value-reading)

---

## 1. Loading the Library

```lua
local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()
```

**Optional:** Set a custom asset ID before loading (see [Anti-Detection](#10-anti-detection)):
```lua
getgenv().RAYFIELD_ASSET_ID = 123456789  -- your re-uploaded model ID
```

**Optional:** Enable Secure Mode before loading (see [Secure Mode](#11-secure-mode)):
```lua
getgenv().RAYFIELD_SECURE = true
getgenv().RAYFIELD_ASSET_ID = 123456789
```

---

## 2. CreateWindow

`Rayfield:CreateWindow()` is the entry point. Call once after loading.

```lua
local Window = Rayfield:CreateWindow({
    Name = "Rayfield Example Window",
    Icon = 0,                          -- Lucide icon (string) or Roblox Image ID (number). 0 = no icon.
    LoadingTitle = "Rayfield Interface Suite",
    LoadingSubtitle = "by Sirius",
    ShowText = "Rayfield",             -- Mobile unhide text
    Theme = "Default",                 -- See Themes section
    ToggleUIKeybind = "K",             -- Key to toggle UI visibility

    DisableRayfieldPrompts = false,
    DisableBuildWarnings = false,

    -- ScriptID = "sid_xxxxxxxxxxxx",  -- From developer.sirius.menu for analytics/managed keys

    ConfigurationSaving = {
        Enabled = true,
        FolderName = nil,              -- Custom folder or nil for default
        FileName = "Big Hub"
    },

    Discord = {
        Enabled = false,
        Invite = "noinvitelink",       -- Discord invite code (no discord.gg/)
        RememberJoins = true
    },

    KeySystem = false,
    KeySettings = {
        Title = "Untitled",
        Subtitle = "Key System",
        Note = "No method of obtaining the key is provided",
        FileName = "Key",
        SaveKey = true,
        GrabKeyFromSite = false,
        Key = {"Hello"}                -- List of accepted keys or RAW file URLs
    }
})
```

### CreateWindow Options

| Field | Type | Description |
|-------|------|-------------|
| `Name` | string | **Required.** Window header title |
| `Icon` | number \| string | Topbar icon. Roblox ID (number), Lucide name (string), or 0 |
| `LoadingTitle` | string | Loading screen title |
| `LoadingSubtitle` | string | Loading screen subtitle |
| `ShowText` | string | Text for mobile users to unhide UI |
| `Theme` | string \| table | Theme identifier or custom theme table |
| `ToggleUIKeybind` | string \| Enum.KeyCode | Key to toggle visibility |
| `DisableRayfieldPrompts` | boolean | Suppress built-in prompts |
| `DisableBuildWarnings` | boolean | Suppress version mismatch warnings |
| `ScriptID` | string | Script ID from developer.sirius.menu |
| `ConfigurationSaving` | object | Config persistence settings |
| `Discord` | object | Discord join prompt settings |
| `KeySystem` | boolean | Enable key system |
| `KeySettings` | object | Key system configuration |

### ConfigurationSaving Options

| Field | Type | Description |
|-------|------|-------------|
| `Enabled` | boolean | Enable config saving |
| `FolderName` | string \| nil | Custom folder name (nil = default) |
| `FileName` | string | Config file name |

### Discord Options

| Field | Type | Description |
|-------|------|-------------|
| `Enabled` | boolean | Enable Discord join prompt |
| `Invite` | string | Invite code (without discord.gg/) |
| `RememberJoins` | boolean | Prompt once (true) or every load (false) |

### KeySettings Options

| Field | Type | Description |
|-------|------|-------------|
| `Title` | string | Key prompt title |
| `Subtitle` | string | Key prompt subtitle |
| `Note` | string | Instructions for obtaining key |
| `FileName` | string | Local key file name (use unique value) |
| `SaveKey` | boolean | Save key across sessions |
| `GrabKeyFromSite` | boolean | Fetch key from URL |
| `Key` | table | List of accepted keys or RAW file URLs |

---

## 3. CreateTab

```lua
local Tab = Window:CreateTab("Tab Example", 4483362458)  -- Title, Image ID
```

**Lucide icon support:**
```lua
local Tab = Window:CreateTab("Tab Example", "rewind")
```

> **Security note:** Lucide icons and Roblox image IDs are detectable by anti-cheats. Use `getcustomasset()` for undetectable icons (see Secure Mode).

---

## 4. Sections & Dividers

### CreateSection

```lua
local Section = Tab:CreateSection("Section Example")
Section:Set("Updated Section Name")
```

### CreateDivider

```lua
local Divider = Tab:CreateDivider()
Divider:Set(false)  -- false = visible, true = hidden
```

---

## 5. Interactive Elements

### Button

```lua
local Button = Tab:CreateButton({
    Name = "Button Example",
    Callback = function()
        -- Runs when button is pressed
    end,
})

Button:Set("New Button Name")
```

### Toggle

```lua
local Toggle = Tab:CreateToggle({
    Name = "Toggle Example",
    CurrentValue = false,
    Flag = "Toggle1",                 -- Unique flag for config saving
    Callback = function(Value)
        -- Value is boolean
    end,
})

Toggle:Set(false)
```

### Color Picker

```lua
local ColorPicker = Tab:CreateColorPicker({
    Name = "Color Picker",
    Color = Color3.fromRGB(255, 255, 255),
    Flag = "ColorPicker1",
    Callback = function(Value)
        -- Value is Color3
    end,
})

ColorPicker:Set(Color3.fromRGB(255, 0, 0))
```

### Slider

```lua
local Slider = Tab:CreateSlider({
    Name = "Slider Example",
    Range = {0, 100},
    Increment = 10,
    Suffix = "Bananas",
    CurrentValue = 10,
    Flag = "Slider1",
    Callback = function(Value)
        -- Value is number
    end,
})

Slider:Set(50)
```

### Input

```lua
local Input = Tab:CreateInput({
    Name = "Input Example",
    CurrentValue = "",
    PlaceholderText = "Input Placeholder",
    RemoveTextAfterFocusLost = false,
    Flag = "Input1",
    Callback = function(Text)
        -- Text is string
    end,
})

Input:Set("New Text")
```

### Dropdown

```lua
local Dropdown = Tab:CreateDropdown({
    Name = "Dropdown Example",
    Options = {"Option 1", "Option 2"},
    CurrentOption = {"Option 1"},
    MultipleOptions = false,
    Flag = "Dropdown1",
    Callback = function(Options)
        -- Options is table of strings
    end,
})

Dropdown:Refresh({"New Option 1", "New Option 2"})  -- Replace options
Dropdown:Set({"Option 2"})                           -- Set selected (triggers callback)
```

---

## 6. Keybinds

```lua
local Keybind = Tab:CreateKeybind({
    Name = "Keybind Example",
    CurrentKeybind = "Q",
    HoldToInteract = false,
    Flag = "Keybind1",
    Callback = function(Keybind)
        -- Keybind is boolean (held state when HoldToInteract=true)
    end,
})

Keybind:Set("RightCtrl")
```

**Reading current keybind:**
```lua
KeybindName.CurrentKeybind
```

---

## 7. Text Elements

### Label

```lua
local Label = Tab:CreateLabel(
    "Label Example",                -- Title
    4483362458,                     -- Icon (number or string)
    Color3.fromRGB(255, 255, 255),  -- Color
    false                           -- IgnoreTheme
)

Label:Set("New Label", 4483362458, Color3.fromRGB(255, 255, 255), false)
```

**With Lucide icon:**
```lua
local Label = Tab:CreateLabel("Label Example", "rewind")
```

### Paragraph

```lua
local Paragraph = Tab:CreateParagraph({
    Title = "Paragraph Example",
    Content = "Paragraph body text here"
})

Paragraph:Set({Title = "New Title", Content = "New content"})
```

---

## 8. Notifications

```lua
Rayfield:Notify({
    Title = "Notification Title",
    Content = "Notification Content",
    Duration = 6.5,                  -- Seconds (optional)
    Image = 4483362458,              -- Icon (number or string, optional)
})
```

**With Lucide icon:**
```lua
Rayfield:Notify({
    Title = "Loaded",
    Content = "Script is ready",
    Image = "check-circle",
    Duration = 5,
})
```

---

## 9. Themes

### Built-in Themes

| Name | Identifier |
|------|------------|
| Default | `Default` |
| Amber Glow | `AmberGlow` |
| Amethyst | `Amethyst` |
| Bloom | `Bloom` |
| Dark Blue | `DarkBlue` |
| Green | `Green` |
| Light | `Light` |
| Ocean | `Ocean` |
| Serenity | `Serenity` |

### Apply Theme

At window creation:
```lua
local Window = Rayfield:CreateWindow({
    Theme = "Ocean",
    -- ...
})
```

At runtime:
```lua
Window.ModifyTheme('AmberGlow')
```

### Custom Theme Table (v1.53+)

```lua
Window.ModifyTheme({
    TextColor = Color3.fromRGB(240, 240, 240),

    Background = Color3.fromRGB(25, 25, 25),
    Topbar = Color3.fromRGB(34, 34, 34),
    Shadow = Color3.fromRGB(20, 20, 20),

    NotificationBackground = Color3.fromRGB(20, 20, 20),
    NotificationActionsBackground = Color3.fromRGB(230, 230, 230),

    TabBackground = Color3.fromRGB(80, 80, 80),
    TabStroke = Color3.fromRGB(85, 85, 85),
    TabBackgroundSelected = Color3.fromRGB(210, 210, 210),
    TabTextColor = Color3.fromRGB(240, 240, 240),
    SelectedTabTextColor = Color3.fromRGB(50, 50, 50),

    ElementBackground = Color3.fromRGB(35, 35, 35),
    ElementBackgroundHover = Color3.fromRGB(40, 40, 40),
    SecondaryElementBackground = Color3.fromRGB(25, 25, 25),
    ElementStroke = Color3.fromRGB(50, 50, 50),
    SecondaryElementStroke = Color3.fromRGB(40, 40, 40),

    SliderBackground = Color3.fromRGB(50, 138, 220),
    SliderProgress = Color3.fromRGB(50, 138, 220),
    SliderStroke = Color3.fromRGB(58, 163, 255),

    ToggleBackground = Color3.fromRGB(30, 30, 30),
    ToggleEnabled = Color3.fromRGB(0, 146, 214),
    ToggleDisabled = Color3.fromRGB(100, 100, 100),
    ToggleEnabledStroke = Color3.fromRGB(0, 170, 255),
    ToggleDisabledStroke = Color3.fromRGB(125, 125, 125),
    ToggleEnabledOuterStroke = Color3.fromRGB(100, 100, 100),
    ToggleDisabledOuterStroke = Color3.fromRGB(65, 65, 65),

    DropdownSelected = Color3.fromRGB(40, 40, 40),
    DropdownUnselected = Color3.fromRGB(30, 30, 30),

    InputBackground = Color3.fromRGB(30, 30, 30),
    InputStroke = Color3.fromRGB(65, 65, 65),
    PlaceholderColor = Color3.fromRGB(178, 178, 178)
})
```

---

## 10. Anti-Detection

Rayfield loads UI via `game:GetObjects` with a known asset ID (`10804731440`). Most anti-cheats block this.

### Fix: Re-upload the UI Model

1. **Get the model in Studio:**
   ```lua
   game:GetObjects("rbxassetid://10804731440")[1].Parent = workspace
   ```
   Or use the [Creator Store](https://create.roblox.com/store/asset/10804731440).

2. **Upload to your account:** Right-click → Save to Roblox.

3. **Enable distribution:** Asset Configure page → toggle "Distribute on Creator Store".

4. **Copy the new asset ID** from the URL or Asset Manager.

### Set Custom Asset ID

```lua
getgenv().RAYFIELD_ASSET_ID = 123456789  -- Your ID here, BEFORE loading Rayfield

local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()
```

> **Important:** Don't modify the model structure. Re-upload when Rayfield updates. Keep your asset ID private.

---

## 11. Secure Mode

Starting with Build 1.74, blocks all detectable Roblox asset references at runtime.

### Enable

```lua
getgenv().RAYFIELD_SECURE = true
getgenv().RAYFIELD_ASSET_ID = 123456789  -- Required for full protection

local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()
```

### What Secure Mode Blocks

| Feature | Normal (1.74+) | Secure Mode |
|---------|---------------|-------------|
| Internal UI images | External cache | External cache |
| Lucide icons | Supported | **Blocked** |
| Roblox image ID icons | Supported | **Blocked** |
| `getcustomasset()` icons | Supported | Supported |
| Key system | Full UI | **Saved key only** |
| Default model ID warning | No | Yes |

### Icons in Secure Mode

Use `getcustomasset()` instead of Roblox IDs or Lucide names:
```lua
Tab:CreateLabel("Hello", getcustomasset("my-icons/alert.png"))
```

Applies to: `CreateWindow({ Icon = ... })`, `CreateTab(Name, Icon)`, `CreateLabel(Text, Icon)`, `Label:Set(Text, Icon)`, `Rayfield:Notify({ Image = ... })`.

### Key System in Secure Mode

- Saved key from previous session → works normally
- No saved key → **blocked**, key prompt cannot show

### Executor Requirements

Requires: `getcustomasset`, `writefile`, `isfile`, `makefolder`, `isfolder`

### Flags

| Flag | Type | Description |
|------|------|-------------|
| `RAYFIELD_SECURE` | boolean | Enables secure mode |
| `RAYFIELD_ASSET_ID` | number | Custom asset ID for your Rayfield model |

---

## 12. Configuration Saving

Three steps:

1. **Enable in CreateWindow:**
   ```lua
   ConfigurationSaving = { Enabled = true, FileName = "MyConfig" }
   ```

2. **Set unique `Flag` on each element** (Toggle, Slider, Input, Dropdown, Keybind, ColorPicker).

3. **Call at end of script:**
   ```lua
   Rayfield:LoadConfiguration()
   ```

---

## 13. Utility Methods

```lua
Rayfield:SetVisibility(false)         -- Hide/show UI
Rayfield:IsVisible()                  -- Returns boolean
Rayfield:Destroy()                    -- Destroy interface entirely
```

---

## 14. Element Value Reading

```lua
ElementName.CurrentValue              -- Most elements
KeybindName.CurrentKeybind            -- Keybinds
DropdownName.CurrentOption            -- Dropdowns
Rayfield.Flags                        -- All flag values table
```

---

## Quick-Start Template

```lua
local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

local Window = Rayfield:CreateWindow({
    Name = "My Script",
    LoadingTitle = "My Script",
    LoadingSubtitle = "by Me",
    ConfigurationSaving = { Enabled = true, FileName = "MyScript" },
    ToggleUIKeybind = "K",
})

local Tab = Window:CreateTab("Main", "home")
local Section = Tab:CreateSection("Controls")

local Toggle = Tab:CreateToggle({
    Name = "Auto Farm",
    CurrentValue = false,
    Flag = "AutoFarm",
    Callback = function(v)
        print("Auto Farm:", v)
    end,
})

Rayfield:LoadConfiguration()
```
