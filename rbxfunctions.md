```markdown
---

## **Core LuaU Functions**
*(Global LuaU functions extended by Roblox)*

### **Debug**
- `debug.debug()` – Enters interactive debugging mode
- `debug.getfenv(fn)` – Returns function environment
- `debug.gethook([thread])` – Returns current hook settings
- `debug.getinfo([thread,] f [, what])` – Returns function information
- `debug.getlocal([thread,] f, local)` – Gets local variable
- `debug.getmetatable(obj)` – Returns metatable
- `debug.getregistry()` – Returns registry table
- `debug.getupvalue(f, up)` – Gets upvalue
- `debug.setfenv(fn, table)` – Sets function environment
- `debug.sethook([thread,] hook, mask [, count])` – Sets hook
- `debug.setlocal([thread,] f, local, value)` – Sets local variable
- `debug.setmetatable(table, metatable)` – Sets metatable
- `debug.setupvalue(f, up, value)` – Sets upvalue
- `debug.traceback([thread [, message [, level]])` – Returns stack trace

### **Math**
- `math.abs(x)` – Absolute value
- `math.acos(x)` – Arc cosine
- `math.asin(x)` – Arc sine
- `math.atan(x)` – Arc tangent
- `math.atan2(y, x)` – Arc tangent (2-arg)
- `math.ceil(x)` – Ceiling
- `math.clamp(x, min, max)` – Clamps value between min/max
- `math.cos(x)` – Cosine
- `math.cosh(x)` – Hyperbolic cosine
- `math.deg(x)` – Degrees from radians
- `math.exp(x)` – Exponential
- `math.floor(x)` – Floor
- `math.fmod(x, y)` – Floating-point remainder
- `math.frexp(x)` – Normalized fraction and exponent
- `math.huge` – Positive infinity
- `math.ldexp(x, exp)` – Multiplies by 2^exp
- `math.log(x [, base])` – Logarithm
- `math.log10(x)` – Base-10 logarithm
- `math.max(x, ...)` – Maximum value
- `math.min(x, ...)` – Minimum value
- `math.modf(x)` – Fractional and integer parts
- `math.noise(x [, y [, z]])` – Perlin noise
- `math.pow(x, y)` – Exponentiation
- `math.rad(x)` – Radians from degrees
- `math.random([m [, n]])` – Random number
- `math.randomseed(x)` – Sets random seed
- `math.sin(x)` – Sine
- `math.sinh(x)` – Hyperbolic sine
- `math.sqrt(x)` – Square root
- `math.tan(x)` – Tangent
- `math.tanh(x)` – Hyperbolic tangent

### **Bitwise (Bit32)**
- `bit32.arshift(x, n)` – Arithmetic right shift
- `bit32.band(x, ...)` – Bitwise AND
- `bit32.bnot(x)` – Bitwise NOT
- `bit32.bor(x, ...)` – Bitwise OR
- `bit32.btest(x, ...)` – Bitwise test
- `bit32.bxor(x, ...)` – Bitwise XOR
- `bit32.extract(n, field [, width])` – Extracts bits
- `bit32.lrotate(x, n)` – Left rotate
- `bit32.lshift(x, n)` – Left shift
- `bit32.replace(n, v, field [, width])` – Replaces bits
- `bit32.rrotate(x, n)` – Right rotate
- `bit32.rshift(x, n)` – Right shift

### **String**
- `string.byte(s [, i [, j]])` – Gets byte values
- `string.char(n, ...)` – Creates string from byte values
- `string.dump(fn)` – Dumps function to binary string
- `string.find(s, pattern [, init [, plain]])` – Finds substring
- `string.format(format, ...)` – Formats string
- `string.gmatch(s, pattern)` – Global match iterator
- `string.gsub(s, pattern, repl [, n])` – Global substitution
- `string.len(s)` – String length
- `string.lower(s)` – Lowercase
- `string.match(s, pattern [, init])` – Pattern match
- `string.pack(format, v1, v2, ...)` – Packs values into binary string
- `string.packsize(format)` – Size of packed format
- `string.rep(s, n)` – Repeats string
- `string.reverse(s)` – Reverses string
- `string.split(s, pattern)` – Splits string
- `string.sub(s, i [, j])` – Substring
- `string.unpack(format, s [, pos])` – Unpacks binary string
- `string.upper(s)` – Uppercase

### **Table**
- `table.clear(t)` – Clears table
- `table.clone(t)` – Deep copies table
- `table.concat(t [, sep [, i [, j]]])` – Concatenates array
- `table.find(t, value)` – Finds value in table
- `table.foreach(t, f)` – Iterates over table
- `table.foreachi(t, f)` – Iterates over integer keys
- `table.getn(t)` – Gets array length
- `table.insert(t [, pos], value)` – Inserts value
- `table.isfrozen(t)` – Checks if table is frozen
- `table.move(a1, f, e, t [, a2])` – Moves elements
- `table.remove(t [, pos])` – Removes value
- `table.sort(t [, comp])` – Sorts table
- `table.freeze(t)` – Freezes table (immutable)
- `table.isfrozen(t)` – Checks if table is frozen

### **Coroutine**
- `coroutine.create(f)` – Creates coroutine
- `coroutine.isyieldable()` – Checks if yieldable
- `coroutine.resume(co [, val1, ...])` – Resumes coroutine
- `coroutine.running()` – Gets running coroutine
- `coroutine.status(co)` – Gets coroutine status
- `coroutine.wrap(f)` – Wraps coroutine
- `coroutine.yield(...)` – Yields coroutine

### **Metatable & OOP**
- `setmetatable(t, mt)` – Sets metatable
- `getmetatable(t)` – Gets metatable
- `rawset(t, k, v)` – Raw set (bypasses metatable)
- `rawget(t, k)` – Raw get (bypasses metatable)
- `rawequal(v1, v2)` – Raw equality check
- `type(v)` – Gets type
- `next(t [, k])` – Iterates table
- `pairs(t)` – Iterates all key-value pairs
- `ipairs(t)` – Iterates array indices
- `load(chunk [, chunkname [, mode [, env]]])` – Loads Lua chunk
- `loadstring(s [, chunkname])` – Loads Lua string (deprecated, use `load`)

---

## **Roblox Global Functions**

### **Instance Manipulation**
- `Instance.new(className)` – Creates new Instance
- `Instance.Destroy(instance)` – Destroys Instance
- `Instance.Clone(instance)` – Clones Instance
- `Instance.IsA(instance, className)` – Checks class
- `Instance.FindFirstChild(instance, name [, recursive])` – Finds child
- `Instance.FindFirstChildOfClass(instance, className [, recursive])` – Finds child by class
- `Instance.GetChildren(instance)` – Gets children
- `Instance.GetDescendants(instance)` – Gets descendants
- `Instance.WaitForChild(instance, name [, timeout])` – Waits for child
- `Instance.GetFullName(instance)` – Gets full path
- `Instance.IsDescendantOf(instance, ancestor)` – Checks ancestry
- `Instance.GetViewport(instance)` – Gets viewport

### **Service Access**
- `game` – Root DataModel
  - `game.GetService(serviceName)` – Gets service
  - `game.Loaded` – Fires when game loads
  - `game.Started` – Fires when game starts
  - `game.Shutdown` – Fires when game ends
- `workspace` – 3D world container
- `replicatedStorage` – Shared storage
- `serverScriptService` – Server scripts
- `serverStorage` – Server-side storage
- `starterPack` – Default tools
- `starterPlayer` – Default player settings
- `starterGui` – Default GUI
- `lighting` – Lighting settings
- `soundService` – Audio control
- `tweenService` – Animation tweening
- `runService` – Game loop control
- `userInputService` – Input handling
- `virtualInputService` – Simulated input
- `physicsService` – Physics control
- `debris` – Automatic cleanup
- `pathfindingService` – AI pathfinding
- `httpService` – HTTP requests
- `marketplaceService` – Asset marketplace
- `insertService` – Model insertion
- `plugin` – Plugin API
- `testService` – Testing framework
- `changeHistoryService` – Undo/redo
- `selection` – Editor selection
- `commandBarService` – Command bar
- `logService` – Output logging
- `pluginActionService` – Plugin actions
- `pluginDragService` – Plugin dragging
- `pluginGuiService` – Plugin GUIs
- `pluginManagementService` – Plugin management
- `pluginWidgetService` – Plugin widgets
- `scriptEditorService` – Script editor
- `scriptAnalysisService` – Code analysis
- `textService` – Text rendering
- `virtualUser` – Simulated player
- `coreGui` – Roblox GUI system
- `players` – Player management
- `teleportService` – Server teleporting
- `badgesService` – Badge awarding
- `friendService` – Friend system
- `groupService` – Group system
- `leaderboardService` – Leaderboards
- `socialService` – Social features
- `teams` – Team management
- `chat` – Chat system
- `filteringService` – Chat filtering
- `localizationService` – Localization
- `analyticsService` – Analytics
- `adService` – Ad system
- `purchaseService` – In-game purchases
- `developerProducts` – Developer products
- `gamePassService` – Game passes
- `avatarEditorService` – Avatar customization
- `customizationService` – Character customization
- `outfitService` – Outfit system

---
## **Class-Specific Functions**

### **BasePart (Physics & Positioning)**
- `BasePart.Anchor` – Toggles anchoring
- `BasePart.CanCollide` – Toggles collisions
- `BasePart.CFrame` – Position & rotation
- `BasePart.Position` – World position
- `BasePart.Size` – Size
- `BasePart.Transparency` – Transparency
- `BasePart.BrickColor` – Color
- `BasePart.Material` – Surface material
- `BasePart.Mass` – Physics mass
- `BasePart.Velocity` – Linear velocity
- `BasePart.RotVelocity` – Angular velocity
- `BasePart.BodyVelocity` – Applies force
- `BasePart.BodyGyro` – Applies torque
- `BasePart.BodyPosition` – Moves to position
- `BasePart:ApplyImpulse(impulse)` – Applies impulse
- `BasePart:ApplyForce(force)` – Applies force
- `BasePart:ApplyAngularImpulse(impulse)` – Applies angular impulse
- `BasePart:BreakJoints()` – Breaks all joints
- `BasePart:Clone()` – Clones part
- `BasePart:Destroy()` – Destroys part
- `BasePart:FindFirstChild(name [, recursive])` – Finds child
- `BasePart:GetChildren()` – Gets children
- `BasePart:GetDescendants()` – Gets descendants
- `BasePart:GetTouchingParts()` – Gets touching parts
- `BasePart:GetPivot()` – Gets pivot CFrame
- `BasePart:PivotTo(CFrame)` – Moves to CFrame
- `BasePart:IsA(className)` – Checks class
- `BasePart:IsDescendantOf(ancestor)` – Checks ancestry
- `BasePart:WaitForChild(name [, timeout])` – Waits for child

### **Model**
- `Model.PrimaryPart` – Defines model pivot
- `Model:GetPivot()` – Gets pivot CFrame
- `Model:PivotTo(CFrame)` – Moves model
- `Model:GetParts()` – Gets all parts
- `Model:BreakJoints()` – Breaks all joints
- `Model:Clone()` – Clones model

### **Humanoid**
- `Humanoid.WalkSpeed` – Movement speed
- `Humanoid.JumpPower` – Jump height
- `Humanoid.Health` – Current health
- `Humanoid.MaxHealth` – Max health
- `Humanoid.Sit` – Toggles sitting
- `Humanoid:TakeDamage(damage)` – Applies damage
- `Humanoid:EquipTool(tool)` – Equips tool
- `Humanoid:UnequipTools()` – Unequips all tools
- `Humanoid:AddAccessory(accessory)` – Adds accessory
- `Humanoid:RemoveAccessories()` – Removes accessories
- `Humanoid:ChangeState(state)` – Changes state (e.g., `Enum.HumanoidStateType.Running`)
- `Humanoid:GetState()` – Gets current state
- `Humanoid:Move(direction)` – Moves character
- `Humanoid:MoveTo(position)` – Moves to position

### **Player**
- `Player.Name` – Player name
- `Player.UserId` – Player ID
- `Player.Character` – Character model
- `Player:LoadCharacter()` – Respawns character
- `Player:Kick(reason)` – Kicks player
- `Player:IsFriendsWith(player)` – Checks friendship
- `Player:GetRankInGroup(groupId)` – Gets group rank
- `Player:GetRoleInGroup(groupId)` – Gets group role
- `Player:RequestFriends(player)` – Sends friend request
- `Player:IsInGroup(groupId)` – Checks group membership

### **Tool**
- `Tool.Parent` – Parent instance
- `Tool.Equipped:Connect(function())` – Fires when equipped
- `Tool.Unequipped:Connect(function())` – Fires when unequipped
- `Tool.Activated:Connect(function())` – Fires when activated
- `Tool:Activate()` – Activates tool
- `Tool:Destroy()` – Destroys tool

### **GuiObject (UI Elements)**
- `GuiObject.Visible` – Toggles visibility
- `GuiObject.Active` – Toggles interactivity
- `GuiObject.Draggable` – Toggles draggability
- `GuiObject.Position` – UI position
- `GuiObject.Size` – UI size
- `GuiObject.AnchorPoint` – Anchor point
- `GuiObject.BackgroundColor3` – Background color
- `GuiObject.BackgroundTransparency` – Background transparency
- `GuiObject.Text` – Text content
- `GuiObject.TextColor3` – Text color
- `GuiObject.TextSize` – Text size
- `GuiObject.Font` – Text font
- `GuiObject:Destroy()` – Destroys GUI
- `GuiObject:Clone()` – Clones GUI

### **TextLabel / TextButton / TextBox**
- `TextLabel.Text` – Display text
- `TextLabel.TextScaled` – Auto-scales text
- `TextLabel.TextWrapped` – Wraps text
- `TextLabel.RichText` – Enables rich text
- `TextButton.Activated:Connect(function())` – Button click event
- `TextBox.PlaceholderText` – Placeholder text
- `TextBox.TextEditable` – Toggles editability
- `TextBox.FocusLost:Connect(function(enterPressed, inputObject))` – Input submission
- `TextBox.Focused:Connect(function())` – Focus event

### **Frame / ScrollingFrame / ImageLabel**
- `Frame.BackgroundColor3` – Background color
- `Frame.BorderColor3` – Border color
- `Frame.BorderSizePixel` – Border thickness
- `ScrollingFrame.ScrollingDirection` – Scroll direction
- `ScrollingFrame.ScrollBarThickness` – Scrollbar thickness
- `ScrollingFrame.CanvasSize` – Scrollable area size
- `ScrollingFrame:ScrollTo(position)` – Scrolls to position
- `ImageLabel.Image` – Image path (e.g., `"rbxassetid://123456789"`)
- `ImageLabel.ImageTransparency` – Image transparency
- `ImageLabel.ImageColor3` – Image tint

### **ViewportFrame**
- `ViewportFrame.CurrentCamera` – Camera for viewport
- `ViewportFrame.Size` – Viewport size
- `ViewportFrame.BackgroundTransparency` – Background transparency

### **TweenService**
- `TweenService:Create(instance, info, properties)` – Creates tween
  - `TweenInfo.new(time, easingStyle, easingDirection, repeatCount, reverses, delay)` – Tween settings
- `Tween:Play()` – Starts tween
- `Tween:Pause()` – Pauses tween
- `Tween:Cancel()` – Cancels tween
- `Tween.Completed:Connect(function())` – Fires when complete

### **RunService**
- `RunService.Heartbeat:Connect(function(deltaTime))` – Fires every frame
- `RunService.Stepped:Connect(function(time, deltaTime))` – Fires every physics step
- `RunService.RenderStepped:Connect(function())` – Fires before rendering
- `RunService.PreSimulation:Connect(function())` – Fires before physics
- `RunService.PostSimulation:Connect(function())` – Fires after physics
- `RunService.IsRunning` – Checks if game is running
- `RunService.IsStudio` – Checks if in Studio

### **UserInputService**
- `UserInputService.InputBegan:Connect(function(input, gameProcessed))` – Input press
- `UserInputService.InputEnded:Connect(function(input, gameProcessed))` – Input release
- `UserInputService.InputChanged:Connect(function(input, gameProcessed))` – Input change
- `UserInputService:GetMouse()` – Gets mouse object
- `UserInputService:GetKeyboard()` – Gets keyboard input
- `UserInputService:GetGamepad()` – Gets gamepad input
- `UserInputService:GetTouch()` – Gets touch input
- `UserInputService:IsKeyDown(keyCode)` – Checks key press
- `UserInputService:IsMouseButtonPressed(button)` – Checks mouse button

### **Mouse (Client-Side)**
- `Mouse.Target` – Mouse target (BasePart or nil)
- `Mouse.Hit` – Raycast hit position
- `Mouse.UnitRay` – Mouse ray direction
- `Mouse.X` – Mouse X position
- `Mouse.Y` – Mouse Y position
- `Mouse.Button1Down:Connect(function())` – Left click
- `Mouse.Button1Up:Connect(function())` – Left click release
- `Mouse.Button2Down:Connect(function())` – Right click
- `Mouse.Button2Up:Connect(function())` – Right click release
- `Mouse.Move:Connect(function())` – Mouse movement
- `Mouse.WheelForward:Connect(function())` – Scroll up
- `Mouse.WheelBackward:Connect(function())` – Scroll down

### **Keyboard (Client-Side)**
- `Keyboard.KeyDown:Connect(function(keyCode, gameProcessed))` – Key press
- `Keyboard.KeyUp:Connect(function(keyCode, gameProcessed))` – Key release

### **TouchInput (Mobile)**
- `TouchInput.TouchStarted:Connect(function(touch, gameProcessed))` – Touch begin
- `TouchInput.TouchEnded:Connect(function(touch, gameProcessed))` – Touch end
- `TouchInput.TouchMoved:Connect(function(touch, gameProcessed))` – Touch move

### **Camera**
- `Camera.CFrame` – Camera position & rotation
- `Camera.Focus` – Focus point
- `Camera.FieldOfView` – FOV angle
- `Camera:GetMouseRay()` – Gets mouse ray
- `Camera:ScreenPointToRay(x, y)` – Converts screen point to ray
- `Camera:WorldToViewportPoint(worldPos)` – Converts world to screen
- `Camera:ViewportPointToRay(x, y)` – Converts viewport to ray

### **Lighting**
- `Lighting.ClockTime` – Day/night cycle (0-24)
- `Lighting.FogStart` – Fog start distance
- `Lighting.FogEnd` – Fog end distance
- `Lighting.FogColor` – Fog color
- `Lighting.Ambient` – Ambient light color
- `Lighting.ColorShift_Bottom` – Bottom color shift
- `Lighting.ColorShift_Top` – Top color shift
- `Lighting.OutdoorAmbient` – Outdoor ambient light
- `Lighting.ShadowSoftness` – Shadow softness
- `Lighting.Technology` – Rendering tech (e.g., `"Future"`)

### **Workspace**
- `Workspace.Gravity` – Gravity vector
- `Workspace.CurrentCamera` – Active camera
- `Workspace:FindPartOnRay(ray, ignoreList, terrainOnly, ignoreWater)` – Raycast
- `Workspace:FindPartOnRayWithIgnoreList(ray, ignoreList)` – Raycast (ignore list)
- `Workspace:FindPartsInRegion3(region3, ignoreList, maxParts)` – Parts in region
- `Workspace:FindPartsInRadius(position, radius, ignoreList)` – Parts in radius
- `Workspace:GetRealPhysicsFPS()` – Physics FPS
- `Workspace:IsAABBInWorld(region3)` – Checks if AABB is in world

### **HttpService**
- `HttpService:RequestInternal(url, method, headers, body)` – HTTP request (server)
- `HttpService:JSONEncode(data)` – Encodes JSON
- `HttpService:JSONDecode(json)` – Decodes JSON
- `HttpService:URLEncode(str)` – URL-encodes string
- `HttpService:URLDecode(str)` – URL-decodes string
- `HttpService:GenerateGUID(false)` – Generates UUID

### **MarketplaceService**
- `MarketplaceService:GetProductInfo(productId)` – Gets asset info
- `MarketplaceService:PromptPurchase(player, assetId)` – Prompts purchase
- `MarketplaceService:PromptGamePassPurchase(player, gamePassId)` – Prompts game pass purchase
- `MarketplaceService:PromptProductPurchase(player, productId)` – Prompts product purchase
- `MarketplaceService:PlayerOwnsAsset(player, assetId)` – Checks ownership

### **TeleportService**
- `TeleportService:Teleport(gameId, player)` – Teleports player
- `TeleportService:TeleportToPlace(gameId, player)` – Teleports to place
- `TeleportService:TeleportToServer(serverId, player)` – Teleports to server
- `TeleportService:GetArrivingTeleportData(player)` – Gets teleport data
- `TeleportService:SetTeleportSetting(setting, value)` – Configures teleport

### **Players**
- `Players:GetPlayerByUserId(userId)` – Gets player by ID
- `Players:GetPlayers()` – Gets all players
- `Players:GetChildren()` – Gets players (same as `GetPlayers()`)
- `Players.PlayerAdded:Connect(function(player))` – Player join event
- `Players.PlayerRemoving:Connect(function(player))` – Player leave event
- `Players:FindFirstChild(name)` – Finds player by name
- `Players:FindFirstChildOfClass(className)` – Finds player by class
- `Players:GetPlayerFromCharacter(character)` – Gets player from character

### **Teams**
- `Teams:GetTeams()` – Gets all teams
- `Teams:FindFirstChild(name)` – Finds team by name
- `Teams:GetPlayerTeam(player)` – Gets player's team
- `Teams:GetTeamPlayers(team)` – Gets players in team

### **Chat & Filtering**
- `Chat:Chat(player, message)` – Sends chat message
- `FilteringService:FilterStringAsync(text, fromPlayer, toPlayer)` – Filters text

### **AnalyticsService**
- `AnalyticsService:TrackEvent(eventName, properties)` – Logs custom event
- `AnalyticsService:FireTrackingEvent(eventName, data)` – Fires tracking event

### **DataStoreService**
- `DataStoreService:GetDataStore(name)` – Gets DataStore
- `DataStore:GetAsync(key)` – Gets data
- `DataStore:SetAsync(key, value)` – Sets data
- `DataStore:UpdateAsync(key, transformFunction)` – Updates data
- `DataStore:RemoveAsync(key)` – Removes data
- `DataStore:IncrementAsync(key, delta)` – Increments value
- `DataStore:OnUpdate(key, callback)` – Listens for updates

### **OrderedDataStore**
- `OrderedDataStore:GetSortedAsync(ascending, limit)` – Gets sorted data
- `OrderedDataStore:GetRangeAsync(minValue, maxValue, ascending, limit)` – Gets range

### **MessagingService**
- `MessagingService:PublishAsync(topic, message)` – Publishes message
- `MessagingService:SubscribeAsync(topic, callback)` – Subscribes to topic
- `MessagingService:UnsubscribeAsync(subscription)` – Unsubscribes

### **Plugin & Studio APIs**
- `plugin:CreatePluginGui(type, title)` – Creates plugin GUI
- `plugin:CreateToolbar(name)` – Creates toolbar
- `plugin:CreateButton(toolbar, name, description, icon)` – Creates toolbar button
- `plugin:OpenScript(script)` – Opens script in editor
- `selection:Get()` – Gets selected instances
- `changeHistoryService:RecordChange(change)` – Records change
- `changeHistoryService:Undo()` – Undoes last action
- `changeHistoryService:Redo()` – Redoes last action

---

## **Enums (Commonly Used)**
### **Enum.HumanoidStateType**
- `Running`
- `Jumping`
- `Climbing`
- `Swimming`
- `Flying`
- `Sitting`
- `Ragdoll`
- `Dead`
- `FallingDown`
- `GettingUp`
- `Freefall`

### **Enum.KeyCode**
- `A` to `Z` (Letters)
- `Zero` to `Nine` (Numbers)
- `Space`
- `Return`
- `Tab`
- `Escape`
- `LeftShift` / `RightShift`
- `LeftControl` / `RightControl`
- `LeftAlt` / `RightAlt`
- `CapsLock`
- `MouseButton1` (Left click)
- `MouseButton2` (Right click)
- `MouseButton3` (Middle click)
- `Thumbstick1` / `Thumbstick2` (Gamepad)
- `ButtonA` / `ButtonB` / `ButtonX` / `ButtonY` (Gamepad)
- `DPadUp` / `DPadDown` / `DPadLeft` / `DPadRight`

### **Enum.EasingStyle**
- `Linear`
- `Quad`
- `Cubic`
- `Quart`
- `Quint`
- `Sine`
- `Back`
- `Bounce`
- `Elastic`
- `Exponential`
- `Circular`

### **Enum.EasingDirection**
- `In`
- `Out`
- `InOut`

### **Enum.Material**
- `Plastic`
- `Wood`
- `Metal`
- `Grass`
- `Ice`
- `Concrete`
- `Glass`
- `Neon`
- `ForceField`
- `Water`
- `Lava`
- `Slate`
- `Fabric`
- `Sand`
- `Leaves`
- `Granite`
- `Brick`
- `Pebble`
- `WoodPlanks`
- `Marble`
- `Basalt`
- `Ground`
- `Cobblestone`

### **Enum.PartType**
- `Ball`
- `Block`
- `Cylinder`

### **Enum.SurfaceType**
- `Smooth`
- `Studs`
- `Inlet`
- `Outlet`
- `StudsInverted`
- `Glue`
- `Weld`
- `Hinge`
- `Motor`
- `Stepping`
- `Universal`

### **Enum.BodyPart**
- `Head`
- `Torso`
- `LeftArm`
- `RightArm`
- `LeftLeg`
- `RightLeg`

---
## **Metamethods (__index, __newindex, etc.)**
- `__index` – Called when accessing a missing field
- `__newindex` – Called when assigning to a missing field
- `__call` – Called when object is called like a function
- `__tostring` – Called when converting to string
- `__metatable` – Protects metatable from `getmetatable`
- `__add` – Addition (`+`)
- `__sub` – Subtraction (`-`)
- `__mul` – Multiplication (`*`)
- `__div` – Division (`/`)
- `__mod` – Modulo (`%`)
- `__pow` – Exponentiation (`^`)
- `__unm` – Negation (`-`)
- `__concat` – Concatenation (`..`)
- `__len` – Length (`#`)
- `__eq` – Equality (`==`)
- `__lt` – Less than (`<`)
- `__le` – Less than or equal (`<=`)

---
## **Common Patterns & Snippets**

### **Raycasting**
```lua
local origin = Vector3.new(0, 10, 0)
local direction = Vector3.new(0, -1, 0).Unit
local ray = Ray.new(origin, direction * 100)
local hit, position, normal = workspace:FindPartOnRay(ray, workspace)
```

### **Tweening**
```lua
local tweenInfo = TweenInfo.new(1, Enum.EasingStyle.Linear)
local tween = TweenService:Create(part, tweenInfo, {Position = Vector3.new(0, 10, 0)})
tween:Play()
```

### **Player Joined/Left**
```lua
game.Players.PlayerAdded:Connect(function(player)
    print(player.Name .. " joined!")
end)

game.Players.PlayerRemoving:Connect(function(player)
    print(player.Name .. " left!")
end)
```

### **Tool Equipped**
```lua
tool.Equipped:Connect(function()
    print("Tool equipped!")
end)
```

### **Click Detector**
```lua
local clickDetector = Instance.new("ClickDetector", part)
clickDetector.MouseClick:Connect(function(player)
    print(player.Name .. " clicked the part!")
end)
```

### **HTTP Request (Server)**
```lua
local success, response = pcall(function()
    return game:GetService("HttpService"):RequestInternal({
        Url = "https://example.com/api",
        Method = "GET",
        Headers = {
            ["Content-Type"] = "application/json"
        }
    })
end)
if success then
    print(response.Body)
end
```

### **DataStore Example**
```lua
local DataStoreService = game:GetService("DataStoreService")
local dataStore = DataStoreService:GetDataStore("MyData")

game.Players.PlayerAdded:Connect(function(player)
    local success, value = pcall(function()
        return dataStore:GetAsync(player.UserId)
    end)
    if success then
        player.leaderstats.Coins.Value = value or 0
    end
end)
```

### **Leaderboard Setup**
```lua
local leaderstats = Instance.new("Folder", player)
leaderstats.Name = "leaderstats"

local coins = Instance.new("IntValue", leaderstats)
coins.Name = "Coins"
coins.Value = 0
```

### **Custom GUI Button**
```lua
local screenGui = Instance.new("ScreenGui", game.Players.LocalPlayer:WaitForChild("PlayerGui"))
local button = Instance.new("TextButton", screenGui)
button.Size = UDim2.new(0, 200, 0, 50)
button.Position = UDim2.new(0.5, -100, 0, 10)
button.Text = "Click Me!"
button.MouseButton1Click:Connect(function()
    print("Button clicked!")
end)
```

### **Character Movement**
```lua
local humanoid = player.Character:WaitForChild("Humanoid")
humanoid:Move(Vector3.new(1, 0, 0), false) -- Moves right
humanoid.Jump = true -- Makes character jump
```

### **Creating a Part**
```lua
local part = Instance.new("Part", workspace)
part.Size = Vector3.new(4, 1, 4)
part.Position = Vector3.new(0, 10, 0)
part.Anchored = true
part.BrickColor = BrickColor.new("Bright red")
```

### **Teleporting Players**
```lua
game:GetService("TeleportService"):Teleport(123456789, game.Players:FindFirstChild("PlayerName"))
```

### **Finding Parts in Radius**
```lua
local parts = workspace:FindPartsInRadius(Vector3.new(0, 0, 0), 100)
for _, part in ipairs(parts) do
    print(part.Name)
end
```

---
## **Roblox LuaU Differences from Standard Lua**
1. **1-based indexing** (LuaU uses 1, standard Lua often uses 1 but allows 0).
2. **`ipairs` stops at `nil`** (unlike some Lua variants).
3. **No `goto`** (LuaU disallows `goto`).
4. **Strict type checks** (e.g., `nil` vs. `false` in conditions).
5. **`//` for floor division** (e.g., `5 // 2 = 2`).
6. **Bitwise operations** (`bit32` module).
7. **No floating-point modulo** (`math.fmod` instead of `%` for floats).
8. **`continue` is supported** (in loops).
9. **`::` for labels** (used with `goto` in other Lua variants, but not in LuaU).
10. **No global-by-default variables** (must declare with `local` or assign to `_G`).

---
## **Performance Tips**
- **Use `ipairs` for arrays** (faster than `pairs`).
- **Avoid `pairs` on large tables** (use `next` in loops for speed).
- **Cache frequently accessed values** (e.g., `local player = game.Players.LocalPlayer`).
- **Use `table.clear` instead of reassigning `{}`** (more efficient).
- **Avoid `FindFirstChild` in loops** (store references).
- **Use `ObjectValue` for references** (better than string-based lookups).
- **Debounce rapid events** (e.g., `if not debounce then debounce = true ... debounce = false end`).
```
