--[[
PlayerSubModule.lua — RAYFIELD MODULE
========================================
Submodule for the Rayfield-based start.luau loader.
Creates a "Player" tab with "Money & Crates" section containing:
  - CrateLuck    (number input + confirm)
  - InfinityPity (number input + confirm + lock toggle)
  - GoldenClover (boolean toggle)
  - PremiumBoost (boolean toggle)
  - VipSmuggler  (boolean toggle)

Module contract — receives (Window, Rayfield):
    return function(Window, Rayfield)
        -- add your UI elements here
    end
--]]

local Players = game:GetService("Players")
local player = Players.LocalPlayer

-- ── Default attribute values ──
local DEFAULTS = {
    CrateLuck    = 0,
    InfinityPity = 0,
    GoldenClover = false,
    PremiumBoost = false,
    VipSmuggler  = false,
}

-- ── State ──
local confirmedValues = {
    CrateLuck    = 0,
    InfinityPity = 0,
}
local lockedFlags = {
    InfinityPity = false,
}
local inputTexts = {
    CrateLuck    = "",
    InfinityPity = "",
}

-- ── Ensure all attributes exist ──
local function initAttributes()
    for k, v in pairs(DEFAULTS) do
        if player:GetAttribute(k) == nil then
            player:SetAttribute(k, v)
        end
    end
end

-- ── Lock loop: re-applies locked values every 1s ──
local function startLockLoop()
    task.spawn(function()
        while task.wait(1) do
            for attr, locked in pairs(lockedFlags) do
                if locked and confirmedValues[attr] ~= nil then
                    pcall(player.SetAttribute, player, attr, confirmedValues[attr])
                end
            end
        end
    end)
end

-- ── Apply a number value to attribute and confirmed state ──
local function applyNumber(attr, value)
    local num = tonumber(value)
    if num == nil then return end
    confirmedValues[attr] = num
    pcall(player.SetAttribute, player, attr, num)
end

-- ── Module entry point ──
return function(Window, Rayfield)
    initAttributes()
    startLockLoop()

    local Tab = Window:CreateTab("Player", "user")

    Tab:CreateSection("Money & Crates")

    -- ── CrateLuck ──
    local CrateLuckInput = Tab:CreateInput({
        Name = "CrateLuck",
        CurrentValue = tostring(player:GetAttribute("CrateLuck") or 0),
        PlaceholderText = "Enter value...",
        RemoveTextAfterFocusLost = false,
        Callback = function(text)
            inputTexts.CrateLuck = text
        end,
    })

    Tab:CreateButton({
        Name = "Confirm CrateLuck",
        Callback = function()
            local val = inputTexts.CrateLuck
            if val and #val > 0 then
                applyNumber("CrateLuck", val)
                local num = tonumber(val)
                CrateLuckInput:Set(tostring(num or 0))
                Rayfield:Notify({
                    Title = "CrateLuck",
                    Content = "Set to " .. tostring(num or 0),
                    Duration = 3,
                    Image = "check-circle",
                })
            end
        end,
    })

    -- ── InfinityPity ──
    Tab:CreateSection("InfinityPity")

    local InfinityPityInput = Tab:CreateInput({
        Name = "InfinityPity Value",
        CurrentValue = tostring(player:GetAttribute("InfinityPity") or 0),
        PlaceholderText = "Enter value...",
        RemoveTextAfterFocusLost = false,
        Callback = function(text)
            inputTexts.InfinityPity = text
        end,
    })

    Tab:CreateButton({
        Name = "Confirm InfinityPity",
        Callback = function()
            local val = inputTexts.InfinityPity
            if val and #val > 0 then
                applyNumber("InfinityPity", val)
                local num = tonumber(val)
                InfinityPityInput:Set(tostring(num or 0))
                Rayfield:Notify({
                    Title = "InfinityPity",
                    Content = "Set to " .. tostring(num or 0),
                    Duration = 3,
                    Image = "check-circle",
                })
            end
        end,
    })

    Tab:CreateToggle({
        Name = "Lock InfinityPity",
        CurrentValue = false,
        Flag = "LockInfinityPity",
        Callback = function(Value)
            lockedFlags.InfinityPity = Value
            if Value then
                -- Re-apply the confirmed value immediately
                if confirmedValues.InfinityPity ~= nil then
                    pcall(player.SetAttribute, player, "InfinityPity", confirmedValues.InfinityPity)
                end
                Rayfield:Notify({
                    Title = "InfinityPity",
                    Content = "Value locked!",
                    Duration = 3,
                    Image = "lock",
                })
            else
                Rayfield:Notify({
                    Title = "InfinityPity",
                    Content = "Value unlocked",
                    Duration = 3,
                    Image = "unlock",
                })
            end
        end,
    })

    -- ── Bool toggles ──
    Tab:CreateSection("Boosts")

    Tab:CreateToggle({
        Name = "GoldenClover",
        CurrentValue = player:GetAttribute("GoldenClover") or false,
        Flag = "GoldenClover",
        Callback = function(Value)
            pcall(player.SetAttribute, player, "GoldenClover", Value)
        end,
    })

    Tab:CreateToggle({
        Name = "PremiumBoost",
        CurrentValue = player:GetAttribute("PremiumBoost") or false,
        Flag = "PremiumBoost",
        Callback = function(Value)
            pcall(player.SetAttribute, player, "PremiumBoost", Value)
        end,
    })

    Tab:CreateToggle({
        Name = "VipSmuggler",
        CurrentValue = player:GetAttribute("VipSmuggler") or false,
        Flag = "VipSmuggler",
        Callback = function(Value)
            pcall(player.SetAttribute, player, "VipSmuggler", Value)
        end,
    })

    -- ── Current values display ──
    Tab:CreateSection("Current Values")

    local CrateLuckLabel = Tab:CreateLabel(
        "CrateLuck: " .. tostring(player:GetAttribute("CrateLuck") or 0),
        "hash",
        Color3.fromRGB(200, 200, 200),
        false
    )
    local InfinityPityLabel = Tab:CreateLabel(
        "InfinityPity: " .. tostring(player:GetAttribute("InfinityPity") or 0),
        "hash",
        Color3.fromRGB(200, 200, 200),
        false
    )
    local GoldenCloverLabel = Tab:CreateLabel(
        "GoldenClover: " .. tostring(player:GetAttribute("GoldenClover") or false),
        "toggle-left",
        Color3.fromRGB(200, 200, 200),
        false
    )
    local PremiumBoostLabel = Tab:CreateLabel(
        "PremiumBoost: " .. tostring(player:GetAttribute("PremiumBoost") or false),
        "toggle-left",
        Color3.fromRGB(200, 200, 200),
        false
    )
    local VipSmugglerLabel = Tab:CreateLabel(
        "VipSmuggler: " .. tostring(player:GetAttribute("VipSmuggler") or false),
        "toggle-left",
        Color3.fromRGB(200, 200, 200),
        false
    )

    -- ── Live-update labels ──
    task.spawn(function()
        while task.wait(0.5) do
            pcall(function()
                CrateLuckLabel:Set(
                    "CrateLuck: " .. tostring(player:GetAttribute("CrateLuck") or 0),
                    "hash",
                    Color3.fromRGB(200, 200, 200),
                    false
                )
                InfinityPityLabel:Set(
                    "InfinityPity: " .. tostring(player:GetAttribute("InfinityPity") or 0),
                    "hash",
                    Color3.fromRGB(200, 200, 200),
                    false
                )
                GoldenCloverLabel:Set(
                    "GoldenClover: " .. tostring(player:GetAttribute("GoldenClover") or false),
                    "toggle-left",
                    Color3.fromRGB(200, 200, 200),
                    false
                )
                PremiumBoostLabel:Set(
                    "PremiumBoost: " .. tostring(player:GetAttribute("PremiumBoost") or false),
                    "toggle-left",
                    Color3.fromRGB(200, 200, 200),
                    false
                )
                VipSmugglerLabel:Set(
                    "VipSmuggler: " .. tostring(player:GetAttribute("VipSmuggler") or false),
                    "toggle-left",
                    Color3.fromRGB(200, 200, 200),
                    false
                )
            end)
        end
    end)

    print("[PlayerModule] Loaded into Rayfield successfully")
end
