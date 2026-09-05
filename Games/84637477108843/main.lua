--[[
	PlayerTab.lua — Player subcategory with Money & Crate controls
	===============================================================
	Requires: ExploitUILib.lua (load it first or alongside this)

	This script imports the UI library and builds:
	- Subcategory: "Player"
	- Tab: "Money & Crate"
	- Controls:
		- CrateLuck (number) — input + confirm + lock
		- InfinityPity (number) — input + confirm + lock
		- GoldenClover (bool) — toggle + lock
		- PremiumBoost (bool) — toggle + lock
		- VipSmuggler (bool) — toggle + lock

	USAGE:
		-- Option A: If both files are local
		local UI = loadstring(game:HttpGet("http://pastebin.com/raw/..."))()

		-- Option B: If you merged them, just do:
		local UI = loadstring(game:HttpGet("url/to/ExploitUILib.lua"))()
		local playerTab = loadstring(game:HttpGet("url/to/PlayerTab.lua"))()
		playerTab:Init(UI)

		-- Then start:
		UI:Start()
]]

local PlayerTab = {}

--[[
	Init(ui)
	Takes an ExploitUILib instance and registers the Player > Money & Crate tab.
	Call this before ui:Start().
]]
function PlayerTab.Init(ui)
	-- Create the subcategory and tab
	local playerSub = ui:Sub("Player")
	local mcTab = ui:Tab("Player", "Money & Crate")

	-- Add controls
	ui:AddNum(mcTab, "CrateLuck", "CrateLuck")
	ui:AddNum(mcTab, "InfinityPity", "InfinityPity")
	ui:AddBool(mcTab, "GoldenClover", "GoldenClover")
	ui:AddBool(mcTab, "PremiumBoost", "PremiumBoost")
	ui:AddBool(mcTab, "VipSmuggler", "VipSmuggler")

	-- Select it as the active tab
	ui:Select("Player", "Money & Crate")

	print("PlayerTab initialized — Money & Crate controls ready")
end

return PlayerTab
