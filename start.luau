-- Get game info
local gameID = game.PlaceId
local gameName = game.Name or "Unknown Game"

-- Sanity check
if not gameID then
	warn("Failed to get game ID")
	return
end

-- Build the game module URL with the resolved game ID
local baseUrl = "https://raw.githubusercontent.com/Vizoplez/LocalScrips/refs/heads/master/Games/"
local gameUrl = baseUrl .. tostring(gameID) .. "/main.lua"

-- Load the UI library (returns the mainUILib table)
local UILib = loadstring(game:HttpGet("https://raw.githubusercontent.com/Vizoplez/LocalScrips/refs/heads/master/MainUILib/main.lua"))()

-- Create a UI instance — Sub, Tab, Start etc. live on instances, not the library
local UI = UILib.new({
	title = gameName,
	x = 200, y = 100,
	width = 700, height = 500,
	toggleKey = Enum.KeyCode.Home
})

-- Load the game-specific module
local GameModuleUILoader = loadstring(game:HttpGet(gameUrl))()
print("Loaded module for: " .. gameUrl)

-- Initialize with the UI instance (not the library table)
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
