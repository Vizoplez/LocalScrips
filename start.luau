--[[
=========================================
  RAYFIELD UI LOADER — Main Menu + Settings
  Features:
    - Auto-loads game-specific script from GitHub by PlaceId
    - Main menu tab with player info and quick actions
    - Settings tab with theme, keybind, and about
    - Floating settings button (bottom-left) via Drawing API
    - Configuration saving
=========================================
]]

-- ── Optional: Anti-detection (uncomment & set your own asset ID) ──
-- getgenv().RAYFIELD_SECURE = true
-- getgenv().RAYFIELD_ASSET_ID = 123456789

-- ── Load Rayfield ──
local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

-- ── Services ──
local Players = game:GetService("Players")
local Player = Players.LocalPlayer
local UserInputService = game:GetService("UserInputService")

-- ==========================================================
--  GAME-SPECIFIC SCRIPT LOADER (by PlaceId)
-- ==========================================================
local PlaceId = game.PlaceId
local GitHubURL = "https://raw.githubusercontent.com/Vizoplez/LocalScrips/refs/heads/master/Games/"
local ScriptURL = GitHubURL .. tostring(PlaceId) .. "/main.lua"

local GameScriptLoaded = false

-- Attempt to load the game-specific script
local function LoadGameScript()
    local success, result = pcall(function()
        return game:HttpGet(ScriptURL)
    end)

    if success and result and #result > 0 then
        local loadSuccess, loadErr = pcall(function()
            loadstring(result)()
        end)

        if loadSuccess then
            GameScriptLoaded = true
            return true, "Game script loaded successfully"
        else
            return false, "Script error: " .. tostring(loadErr)
        end
    else
        return false, "No game script found for PlaceId " .. tostring(PlaceId)
    end
end

-- ==========================================================
--  CREATE WINDOW
-- ==========================================================
local Window = Rayfield:CreateWindow({
    Name = "Main Menu",
    LoadingTitle = "Loading...",
    LoadingSubtitle = "by You",
    ConfigurationSaving = {
        Enabled = true,
        FileName = "MainMenuConfig"
    },
    ToggleUIKeybind = "K",
    DisableRayfieldPrompts = false,
    DisableBuildWarnings = false,
    Theme = "Default",
})

-- ==========================================================
--  MAIN TAB
-- ==========================================================
local MainTab = Window:CreateTab("Main", "home")

MainTab:CreateSection("Player Info")

local PlayerLabel = MainTab:CreateLabel(
    "Player: " .. Player.DisplayName,
    "user",
    Color3.fromRGB(200, 200, 200),
    false
)

local HealthLabel = MainTab:CreateLabel(
    "Health: " .. math.floor(Player.Health or 100),
    "heart",
    Color3.fromRGB(220, 120, 120),
    false
)

spawn(function()
    while task.wait(1) do
        pcall(function()
            HealthLabel:Set(
                "Health: " .. math.floor(Player.Health),
                "heart",
                Color3.fromRGB(220, 120, 120),
                false
            )
        end)
    end
end)

MainTab:CreateSection("Game Script")

-- Status label for the game script loader
local ScriptStatus = MainTab:CreateLabel(
    "Checking game script...",
    "loader",
    Color3.fromRGB(200, 200, 100),
    false
)

-- PlaceId display
local PlaceIdLabel = MainTab:CreateLabel(
    "Place ID: " .. tostring(PlaceId),
    "hash",
    Color3.fromRGB(180, 180, 180),
    false
)

-- Button to manually reload the game script
local ReloadScriptBtn = MainTab:CreateButton({
    Name = "Reload Game Script",
    Callback = function()
        local ok, msg = LoadGameScript()
        if ok then
            ScriptStatus:Set("Game script loaded!", "check-circle", Color3.fromRGB(120, 220, 120), false)
            Rayfield:Notify({
                Title = "Game Script",
                Content = "Loaded for PlaceId " .. tostring(PlaceId),
                Duration = 4,
                Image = "check-circle",
            })
        else
            ScriptStatus:Set("No script available", "x-circle", Color3.fromRGB(220, 120, 120), false)
            Rayfield:Notify({
                Title = "Game Script",
                Content = msg,
                Duration = 4,
                Image = "x-circle",
            })
        end
    end,
})

MainTab:CreateSection("Quick Actions")

local ToggleAutoFarm = MainTab:CreateToggle({
    Name = "Auto Farm",
    CurrentValue = false,
    Flag = "AutoFarm",
    Callback = function(Value)
        print("Auto Farm:", Value)
    end,
})

local ButtonExecute = MainTab:CreateButton({
    Name = "Execute Script",
    Callback = function()
        Rayfield:Notify({
            Title = "Script",
            Content = "Executed successfully!",
            Duration = 3,
            Image = "check-circle",
        })
    end,
})

MainTab:CreateSection("Status")

local StatusLabel = MainTab:CreateLabel(
    "Status: Connected",
    "activity",
    Color3.fromRGB(120, 220, 120),
    false
)

-- ==========================================================
--  SETTINGS TAB
-- ==========================================================
local SettingsTab = Window:CreateTab("Settings", "settings")

SettingsTab:CreateSection("UI Settings")

local ThemeDropdown = SettingsTab:CreateDropdown({
    Name = "Theme",
    Options = {"Default", "AmberGlow", "Amethyst", "Bloom", "DarkBlue", "Green", "Light", "Ocean", "Serenity"},
    CurrentOption = {"Default"},
    Flag = "ThemeSelector",
    Callback = function(Options)
        Window.ModifyTheme(Options[1])
    end,
})

local SliderOpacity = SettingsTab:CreateSlider({
    Name = "UI Opacity",
    Range = {0, 100},
    Increment = 10,
    Suffix = "%",
    CurrentValue = 100,
    Flag = "UIOpacity",
    Callback = function(Value)
    end,
})

SettingsTab:CreateSection("Keybinds")

local KeybindToggle = SettingsTab:CreateKeybind({
    Name = "Toggle UI",
    CurrentKeybind = "K",
    HoldToInteract = false,
    Flag = "ToggleKeybind",
    Callback = function()
    end,
})

SettingsTab:CreateSection("About")

SettingsTab:CreateParagraph({
    Title = "About",
    Content = "Rayfield UI Loader\nVersion 1.0\nAuto-loads game scripts by PlaceId"
})

-- ==========================================================
--  FLOATING SETTINGS BUTTON (Bottom-Left)
-- ==========================================================
local SettingsBtn = Drawing.new("Square")
local SettingsBtnText = Drawing.new("Text")
local SettingsBtnHover = Drawing.new("Square")

local BtnSize = 36
local BtnPadding = 12
local BtnX = BtnPadding
local BtnY = 0

local BtnColor = Color3.fromRGB(35, 35, 35)
local BtnHoverColor = Color3.fromRGB(55, 55, 55)
local BtnIconColor = Color3.fromRGB(150, 150, 150)

local SettingsBtnVisible = true
local isHovering = false

SettingsBtn.Filled = true
SettingsBtn.Thickness = 1
SettingsBtn.Color = BtnColor

SettingsBtnHover.Filled = true
SettingsBtnHover.Thickness = 0
SettingsBtnHover.Color = BtnHoverColor
SettingsBtnHover.Visible = false

SettingsBtnText.Font = Drawing.Fonts.UI
SettingsBtnText.Size = 18
SettingsBtnText.Outline = true
SettingsBtnText.Color = Color3.fromRGB(200, 200, 200)

local GearIcon = "⚙"

spawn(function()
    while task.wait() do
        if not SettingsBtnVisible then
            SettingsBtn.Visible = false
            SettingsBtnText.Visible = false
            SettingsBtnHover.Visible = false
            continue
        end

        local ViewportSize = workspace.CurrentCamera.ViewportSize
        local screenH = ViewportSize.Y

        BtnY = screenH - BtnSize - BtnPadding

        SettingsBtn.Position = Vector2.new(BtnX, BtnY)
        SettingsBtn.Size = Vector2.new(BtnSize, BtnSize)
        SettingsBtn.Visible = true
        SettingsBtn.Color = isHovering and BtnHoverColor or BtnColor

        if isHovering then
            SettingsBtnHover.Position = Vector2.new(BtnX, BtnY)
            SettingsBtnHover.Size = Vector2.new(BtnSize, BtnSize)
            SettingsBtnHover.Visible = true
        else
            SettingsBtnHover.Visible = false
        end

        SettingsBtnText.Position = Vector2.new(BtnX + 8, BtnY + 6)
        SettingsBtnText.Text = GearIcon
        SettingsBtnText.Visible = true
        SettingsBtnText.Color = isHovering and Color3.fromRGB(255, 255, 255) or BtnIconColor
    end
end)

local connSettings = UserInputService.InputBegan:Connect(function(input, processed)
    if processed then return end
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        local mx, my = input.Position.X, input.Position.Y
        if mx >= BtnX and mx <= BtnX + BtnSize
        and my >= BtnY and my <= BtnY + BtnSize then
            local isVisible = Rayfield:IsVisible()
            Rayfield:SetVisibility(not isVisible)
        end
    end
end)

local connHover = UserInputService.InputChanged:Connect(function(input, processed)
    if processed then return end
    if input.UserInputType == Enum.UserInputType.MouseMovement then
        local mx, my = input.Position.X, input.Position.Y
        isHovering = mx >= BtnX and mx <= BtnX + BtnSize
                and my >= BtnY and my <= BtnY + BtnSize
    end
end)

-- ==========================================================
--  LOAD CONFIGURATION
-- ==========================================================
Rayfield:LoadConfiguration()

-- ==========================================================
--  WELCOME NOTIFICATION
-- ==========================================================
Rayfield:Notify({
    Title = "Welcome",
    Content = "Press " .. (Window.ToggleUIKeybind or "K") .. " to toggle the UI",
    Duration = 5,
    Image = "bell",
})

-- ==========================================================
--  TRY LOADING GAME SCRIPT
-- ==========================================================
spawn(function()
    task.wait(1.5)
    local ok, msg = LoadGameScript()
    if ok then
        ScriptStatus:Set("Game script loaded!", "check-circle", Color3.fromRGB(120, 220, 120), false)
        Rayfield:Notify({
            Title = "Game Script Loaded",
            Content = "Script loaded for PlaceId " .. tostring(PlaceId),
            Duration = 5,
            Image = "check-circle",
        })
    else
        ScriptStatus:Set("No script available", "x-circle", Color3.fromRGB(220, 120, 120), false)
        Rayfield:Notify({
            Title = "Game Script",
            Content = msg,
            Duration = 5,
            Image = "x-circle",
        })
    end
end)

print("UI Loader loaded successfully!")
print("PlaceId:", PlaceId)
print("Script URL:", ScriptURL)
