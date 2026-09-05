-- Get game info
local gameInfo = get_game_info()
local gameID = gameInfo.GameID or gameInfo.gameId or gameInfo.id or gameInfo.PlaceID
local gameName = gameInfo.GameName or gameInfo.name or gameInfo.Name or "Unknown Game"

-- Sanity check
if not gameID then
	warn("Failed to get game ID from get_game_info()")
	return
end

-- Build the game module URL with the resolved game ID
local baseUrl = "https://raw.githubusercontent.com/Vizoplez/LocalScrips/refs/heads/master/Games/"
local gameUrl = baseUrl .. tostring(gameID) .. "/main.lua"

-- Load the UI library
local UI = loadstring(game:HttpGet("https://raw.githubusercontent.com/Vizoplez/LocalScrips/refs/heads/master/MainUILib/ExploitUILib.lua"))()

-- Load the game-specific module
local GameModuleUILoader = loadstring(game:HttpGet(gameUrl))()

-- Initialize and start
GameModuleUILoader.Init(UI)
UI:Start()

-- Notification
local notification = Drawing.new("Text")
notification.Text = "Loaded " .. gameName .. " | made by Vizoplez"
notification.Size = 18
notification.Font = Drawing.Fonts.UI
notification.Color = Color3.fromRGB(0, 255, 0)
notification.Outline = true
notification.Position = Vector2.new(
	(game:GetService("Workspace").CurrentCamera.ViewportSize.X / 2) - 120,
	game:GetService("Workspace").CurrentCamera.ViewportSize.Y / 2
)
notification.Center = true
notification.Visible = true

task.delay(3, function()
	notification:Remove()
end)