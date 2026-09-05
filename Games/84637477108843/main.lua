--[[
    Player Settings Submodule — Rayfield UI
    Tab: Player → Section: Money & Crates
    
    Fields:
        CrateLuck    (number) — Input + Confirm button, displays current value
        InfinityPity (number) — Input + Confirm button, lockable via toggle
        GoldenClover (bool)   — Toggle
        PremiumBoost (bool)   — Toggle
        VipSmuggler  (bool)   — Toggle
]]

local PlayerSettings = {
    -- Internal state
    _state = {
        CrateLuck = 0,
        InfinityPity = 0,
        InfinityPityLocked = false,
        GoldenClover = false,
        PremiumBoost = false,
        VipSmuggler = false,
    },

    -- Callbacks the host can set
    OnCrateLuckChanged = nil,      -- function(newValue)
    OnInfinityPityChanged = nil,   -- function(newValue, isLocked)
    OnGoldenCloverChanged = nil,   -- function(newValue)
    OnPremiumBoostChanged = nil,   -- function(newValue)
    OnVipSmugglerChanged = nil,    -- function(newValue)
}

-- ─── Getters / Setters ───────────────────────────────────────────────────

function PlayerSettings:GetCrateLuck()
    return self._state.CrateLuck
end

function PlayerSettings:SetCrateLuck(value)
    value = tonumber(value) or 0
    self._state.CrateLuck = value
    if self._CrateLuckLabel then
        self._CrateLuckLabel:Set("CrateLuck: " .. tostring(value))
    end
    if self.OnCrateLuckChanged then
        self.OnCrateLuckChanged(value)
    end
end

function PlayerSettings:GetInfinityPity()
    return self._state.InfinityPity
end

function PlayerSettings:SetInfinityPity(value)
    value = tonumber(value) or 0
    self._state.InfinityPity = value
    if self._InfinityPityLabel then
        self._InfinityPityLabel:Set("InfinityPity: " .. tostring(value))
    end
    if self.OnInfinityPityChanged then
        self.OnInfinityPityChanged(value, self._state.InfinityPityLocked)
    end
end

function PlayerSettings:IsInfinityPityLocked()
    return self._state.InfinityPityLocked
end

function PlayerSettings:SetInfinityPityLocked(locked)
    self._state.InfinityPityLocked = locked
    if self._InfinityPityInput then
        self._InfinityPityInput.InputFrame.InputBox.Interactable = not locked
    end
    if self._InfinityPityButton then
        -- visually indicate disabled state (we can't fully disable the button in Rayfield,
        -- but we can skip its callback when locked)
    end
    if self.OnInfinityPityChanged then
        self.OnInfinityPityChanged(self._state.InfinityPity, locked)
    end
end

function PlayerSettings:GetGoldenClover()
    return self._state.GoldenClover
end

function PlayerSettings:SetGoldenClover(value)
    self._state.GoldenClover = value
    if self._GoldenCloverToggle then
        self._GoldenCloverToggle:Set(value)
    end
end

function PlayerSettings:GetPremiumBoost()
    return self._state.PremiumBoost
end

function PlayerSettings:SetPremiumBoost(value)
    self._state.PremiumBoost = value
    if self._PremiumBoostToggle then
        self._PremiumBoostToggle:Set(value)
    end
end

function PlayerSettings:GetVipSmuggler()
    return self._state.VipSmuggler
end

function PlayerSettings:SetVipSmuggler(value)
    self._state.VipSmuggler = value
    if self._VipSmugglerToggle then
        self._VipSmugglerToggle:Set(value)
    end
end

-- ─── UI Builder ───────────────────────────────────────────────────────────

--- Builds the Player tab and Money & Crates section.
--- @param Window table — the Rayfield window returned by CreateWindow
--- @return table self
function PlayerSettings:BuildUI(Window)
    -- Create the Player tab
    local PlayerTab = Window:CreateTab("Player", "user")  -- "user" is a Lucide icon
    self._PlayerTab = PlayerTab

    -- Create the Money & Crates section
    local Section = PlayerTab:CreateSection("Money & Crates")
    self._Section = Section

    -- ── CrateLuck (number) ────────────────────────────────────────────────

    -- Label showing current value
    self._CrateLuckLabel = PlayerTab:CreateLabel(
        "CrateLuck: " .. tostring(self._state.CrateLuck),
        nil, nil, true
    )

    -- Input field for new value
    local crateLuckInput = PlayerTab:CreateInput({
        Name = "New CrateLuck Value",
        CurrentValue = tostring(self._state.CrateLuck),
        PlaceholderText = "Enter a number...",
        RemoveTextAfterFocusLost = false,
        Callback = function() end,  -- We handle via the button instead
    })
    self._CrateLuckInput = crateLuckInput

    -- Confirm button
    local crateLuckBtn = PlayerTab:CreateButton({
        Name = "Apply CrateLuck",
        Callback = function()
            local val = tonumber(crateLuckInput.CurrentValue)
            if val then
                self:SetCrateLuck(val)
            end
        end,
    })

    -- ── InfinityPity (number + lock toggle) ───────────────────────────────

    -- Label showing current value
    self._InfinityPityLabel = PlayerTab:CreateLabel(
        "InfinityPity: " .. tostring(self._state.InfinityPity),
        nil, nil, true
    )

    -- Lock toggle (checkmark)
    local infinityLockToggle = PlayerTab:CreateToggle({
        Name = "Lock InfinityPity",
        CurrentValue = self._state.InfinityPityLocked,
        Callback = function(Value)
            self:SetInfinityPityLocked(Value)
        end,
    })
    self._InfinityLockToggle = infinityLockToggle

    -- Input field for new value
    local infinityInput = PlayerTab:CreateInput({
        Name = "New InfinityPity Value",
        CurrentValue = tostring(self._state.InfinityPity),
        PlaceholderText = "Enter a number...",
        RemoveTextAfterFocusLost = false,
        Callback = function() end,
    })
    self._InfinityPityInput = infinityInput

    -- Confirm button
    local infinityBtn = PlayerTab:CreateButton({
        Name = "Apply InfinityPity",
        Callback = function()
            if self._state.InfinityPityLocked then
                return  -- Value is locked, do nothing
            end
            local val = tonumber(infinityInput.CurrentValue)
            if val then
                self:SetInfinityPity(val)
            end
        end,
    })
    self._InfinityPityButton = infinityBtn

    -- ── GoldenClover (bool) ───────────────────────────────────────────────

    self._GoldenCloverToggle = PlayerTab:CreateToggle({
        Name = "GoldenClover",
        CurrentValue = self._state.GoldenClover,
        Callback = function(Value)
            self._state.GoldenClover = Value
            if self.OnGoldenCloverChanged then
                self.OnGoldenCloverChanged(Value)
            end
        end,
    })

    -- ── PremiumBoost (bool) ───────────────────────────────────────────────

    self._PremiumBoostToggle = PlayerTab:CreateToggle({
        Name = "PremiumBoost",
        CurrentValue = self._state.PremiumBoost,
        Callback = function(Value)
            self._state.PremiumBoost = Value
            if self.OnPremiumBoostChanged then
                self.OnPremiumBoostChanged(Value)
            end
        end,
    })

    -- ── VipSmuggler (bool) ────────────────────────────────────────────────

    self._VipSmugglerToggle = PlayerTab:CreateToggle({
        Name = "VipSmuggler",
        CurrentValue = self._state.VipSmuggler,
        Callback = function(Value)
            self._state.VipSmuggler = Value
            if self.OnVipSmugglerChanged then
                self.OnVipSmugglerChanged(Value)
            end
        end,
    })

    return self
end

return PlayerSettings