--[[
PlayerSubModule.lua
=====================
Submodule for MainUILib — creates a Player > Money & Crates section
with number controls (CrateLuck, InfinityPity) and bool toggles
(GoldenClover, PremiumBoost, VipSmuggler).

Usage:
    local PlayerUI = loadstring(game:HttpGet("url/to/this/file.lua"))()
    PlayerUI:Open()

Or integrate with an existing UI instance:
    local PlayerUI = loadstring(game:HttpGet("url/to/this/file.lua"))()
    PlayerUI:Init(existingUI)  -- skips creating a new UI
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

local PlayerModule = {}

-- ── Ensure all attributes exist on the player ──
local function initAttributes()
    for k, v in pairs(DEFAULTS) do
        if player:GetAttribute(k) == nil then
            player:SetAttribute(k, v)
        end
    end
end

-- ── Load the UI library ──
local function loadUILib()
    local url = "https://raw.githubusercontent.com/Vizoplez/LocalScrips/refs/heads/master/MainUILib/main.lua"
    local ok, result = pcall(game.HttpGet, game, url)
    if not ok then
        warn("[PlayerModule] Failed to load MainUILib:", result)
        return nil
    end
    local ok2, lib = pcall(loadstring, result)
    if not ok2 then
        warn("[PlayerModule] Failed to compile MainUILib:", lib)
        return nil
    end
    return lib()
end

-- ── Build the UI elements ──
local function buildUI(UI)
    initAttributes()

    local sub  = UI:Sub("Player")
    local tab  = UI:Tab("Player", "Money & Crates")

    -- Number controls
    UI:AddNum(tab, "CrateLuck",    "CrateLuck")
    UI:AddNum(tab, "InfinityPity", "InfinityPity")

    -- Bool controls
    UI:AddBool(tab, "GoldenClover", "GoldenClover")
    UI:AddBool(tab, "PremiumBoost", "PremiumBoost")
    UI:AddBool(tab, "VipSmuggler",  "VipSmuggler")

    UI:Select("Player", "Money & Crates")
end

-- ── Open: creates a fresh UI instance and starts it ──
function PlayerModule:Open(config)
    config = config or {}
    if self._ui and self._started then
        self._ui:SetVisible(true)
        return self._ui
    end

    local lib = loadUILib()
    if not lib then return nil end

    self._ui = lib.new({
        title      = config.title or (game.Name .. " Menu"),
        x          = config.x or 200,
        y          = config.y or 100,
        width      = config.width or 700,
        height     = config.height or 500,
        toggleKey  = config.toggleKey or Enum.KeyCode.Home,
    })

    buildUI(self._ui)
    self._ui:Start()
    self._started = true
    return self._ui
end

-- ── Init: attach to an already-running UI instance ──
-- Use this when you already have a MainUILib instance and just
-- want to add the Player > Money & Crates section without
-- creating a whole new window.
function PlayerModule:Init(existingUI)
    if not existingUI then
        warn("[PlayerModule] Init requires an existing MainUILib instance")
        return
    end
    self._ui = existingUI
    buildUI(self._ui)
    self._started = true
    return self._ui
end

-- ── Toggle visibility ──
function PlayerModule:Toggle()
    if self._ui then
        self._ui:SetVisible(not self._ui.visible)
    end
end

-- ── Destroy ──
function PlayerModule:Destroy()
    if self._ui then
        self._ui:Destroy()
    end
    self._ui = nil
    self._started = false
end

return PlayerModule
