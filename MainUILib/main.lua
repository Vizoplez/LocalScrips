--[[
MainUILib — Drawing-based UI Framework
==========================================
A modular, lightweight UI library using Roblox's Drawing API.
Zero ScreenGui instances (except one hidden TextBox for keyboard input).

Features:
  - Draggable, resizable window with sidebar/tab navigation
  - Responsive element sizing — all controls scale with window width
  - Auto-title: defaults to game.Name .. " Menu" when no title given
  - Number controls: input field, confirm button, toggle-lock
  - Boolean controls: clickable checkmark, status label, toggle-lock
  - Scrollable content area with scrollbar
  - 1-second lock loop reapplies confirmed values

USAGE:
  local UI = loadstring(game:HttpGet("url/to/main.lua"))()
  local myUI = UI.new({
    title = "My Menu",           -- optional, defaults to game.Name .. " Menu"
    x = 200, y = 100,
    width = 700, height = 500,
    toggleKey = Enum.KeyCode.Home
  })

  local playerSub = myUI:Sub("Player")
  local moneyTab  = myUI:Tab("Player", "Money & Crate")

  myUI:AddNum(moneyTab,  "CrateLuck",    "CrateLuck")
  myUI:AddBool(moneyTab, "GoldenClover", "GoldenClover")

  myUI:Select("Player", "Money & Crate")
  myUI:Start()
]]

local mainUILib = {}

-- ── Internal services ──
local UIS        = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local Players    = game:GetService("Players")
local player     = Players.LocalPlayer

-- ── Utility ──
local function getAttr(k) return player:GetAttribute(k) end
local function setAttr(k, v) player:SetAttribute(k, v) end

-- ============================================================
--  UI INSTANCE
-- ============================================================
function mainUILib.new(config)
  config = config or {}
  local self = {}

  -- ── Settings ──
  -- Auto-title: game.Name .. " Menu" when no title provided
  self.title     = config.title or (game.Name .. " Menu")
  self.x         = config.x or 200
  self.y         = config.y or 100
  self.w         = config.width or 700
  self.h         = config.height or 500
  self.toggleKey = config.toggleKey or Enum.KeyCode.Home
  self.visible   = true

  -- ── Internal state ──
  self._scrollY        = 0
  self._scrollMax      = 0
  self._selectingInput = false
  self._dragging       = false
  self._resizing       = false
  self._dragOffX       = 0
  self._dragOffY       = 0
  self._subs           = {}
  self._currentSub     = nil
  self._currentTab     = nil
  self._clickables     = {}
  self._drawObjs       = {}
  self._started        = false

  -- Lock & confirm state
  self._lockNum  = {}
  self._lockBool = {}
  self._confNum  = {}
  self._confBool = {}

  -- ── Hidden TextBox for keyboard input ──
  self._inputBox = Instance.new("TextBox")
  self._inputBox.Size                = UDim2.new(0, 1, 0, 1)
  self._inputBox.Position            = UDim2.new(0, -200, 0, -200)
  self._inputBox.Visible             = false
  self._inputBox.BackgroundTransparency = 1
  self._inputBox.Text                = ""
  self._inputBox.ClearTextOnFocus    = false
  self._inputBox.Parent              = game:GetService("CoreGui")

  -- ── Connections ──
  self._conns = {}

  -- ============================================================
  --  PUBLIC API
  -- ============================================================

  --- Sub(name) → sub object
  --- Creates or retrieves a sidebar subcategory.
  function self:Sub(name)
    if self._subs[name] then return self._subs[name] end
    local s = { name = name, tabs = {}, tabOrder = {} }
    self._subs[name] = s
    return s
  end

  --- Tab(subName, tabName) → tab object
  --- Creates or retrieves a tab inside a subcategory.
  function self:Tab(subName, tabName)
    local s = self:Sub(subName)
    if s.tabs[tabName] then return s.tabs[tabName] end
    local t = { name = tabName, elements = {} }
    s.tabs[tabName] = t
    table.insert(s.tabOrder, tabName)
    return t
  end

  --- Select(subName, tabName)
  --- Switches view to the given subcategory + tab, resets scroll.
  function self:Select(subName, tabName)
    local s = self._subs[subName]
    if not s or not s.tabs[tabName] then return end
    self._currentSub = s
    self._currentTab = s.tabs[tabName]
    self._scrollY = 0
  end

  --- AddNum(tab, name, attributeName)
  --- Adds a number control: value display, input box, Confirm, Toggle Locked.
  function self:AddNum(tab, name, attributeName)
    table.insert(tab.elements, {
      type = "num",
      name = name,
      attr = attributeName
    })
    self._lockNum[attributeName]  = false
    self._confNum[attributeName]  = getAttr(attributeName) or 0
  end

  --- AddBool(tab, name, attributeName)
  --- Adds a boolean toggle: clickable checkmark, status label, Toggle Locked.
  function self:AddBool(tab, name, attributeName)
    table.insert(tab.elements, {
      type = "bool",
      name = name,
      attr = attributeName
    })
    self._lockBool[attributeName]  = false
    self._confBool[attributeName]  = getAttr(attributeName) == true
  end

  --- SetVisible(bool)
  function self:SetVisible(v)
    self.visible = v
  end

  --- Destroy()
  --- Cleans all Drawing objects, connections, and the hidden TextBox.
  function self:Destroy()
    self.visible = false
    self:_cleanDraws()
    for _, conn in ipairs(self._conns) do
      conn:Disconnect()
    end
    self._conns = {}
    pcall(function() self._inputBox:Destroy() end)
    self._started = false
  end

  --- Start()
  --- Begins render loop + input hooks. Call after all subs/tabs/elements.
  function self:Start()
    if self._started then return end
    self._started = true
    self:_hookInput()
    self:_startLockLoop()
    self:_startRenderLoop()
  end

  -- ============================================================
  --  INTERNAL: Drawing helpers
  -- ============================================================
  function self:_cleanDraws()
    for _, d in ipairs(self._drawObjs) do
      pcall(function() d:Remove() end)
    end
    self._drawObjs = {}
  end

  function self:_drawRect(x, y, w, h, color)
    local d = Drawing.new("Square")
    d.Position = Vector2.new(x, y)
    d.Size     = Vector2.new(w, h)
    d.Color    = color
    d.Filled   = true
    d.Thickness = 1
    d.Visible  = true
    table.insert(self._drawObjs, d)
  end

  function self:_drawText(str, x, y, size, color)
    local d = Drawing.new("Text")
    d.Position = Vector2.new(x, y)
    d.Text     = str
    d.Size     = size
    d.Font     = Drawing.Fonts.UI
    d.Color    = color
    d.Center   = false
    d.Outline  = true
    d.Visible  = true
    table.insert(self._drawObjs, d)
  end

  function self:_addClickable(x, y, w, h, callback)
    table.insert(self._clickables, {
      x = x, y = y, w = w, h = h, cb = callback
    })
  end

  -- ============================================================
  --  INTERNAL: Render
  -- ============================================================
  function self:_render()
    self:_cleanDraws()
    self._clickables = {}

    if not self.visible then
      self._inputBox.Visible = false
      return
    end

    local x, y, w, h = self.x, self.y, self.w, self.h
    local sx, cw = x + 170, w - 170   -- sidebar = 170px, content width = remaining
    local vh = h - 56                  -- viewport height for scrolling
    local sy = self._scrollY

    -- Main background
    self:_drawRect(x, y, w, h, Color3.fromRGB(15, 15, 15))

    -- ── Top bar ──
    self:_drawRect(x, y, w, 30, Color3.fromRGB(25, 25, 25))
    self:_drawText(
      self.title .. " (" .. (self._currentSub and self._currentSub.name or "") .. ")",
      x + 10, y + 5, 16, Color3.fromRGB(200, 200, 200)
    )
    -- Close button
    self:_drawRect(x + w - 28, y + 3, 24, 24, Color3.fromRGB(25, 25, 25))
    self:_drawText("X", x + w - 23, y + 5, 14, Color3.fromRGB(200, 60, 60))
    self:_addClickable(x + w - 28, y + 3, 24, 24, function()
      self.visible = false
    end)

    -- ── Sidebar ──
    self:_drawRect(x, y + 30, 170, h - 30, Color3.fromRGB(20, 20, 20))
    local syo = 0
    for _, s in pairs(self._subs) do
      local sel      = s == self._currentSub
      local by       = y + 32 + syo
      local bgColor  = sel and Color3.fromRGB(35, 35, 35) or Color3.fromRGB(20, 20, 20)
      local textColor = sel and Color3.fromRGB(255, 255, 255) or Color3.fromRGB(160, 160, 160)

      self:_drawRect(x + 2, by, 166, 28, bgColor)
      self:_drawText("  " .. s.name, x + 8, by + 4, 14, textColor)
      self:_addClickable(x + 2, by, 166, 28, function()
        for _, tn in ipairs(s.tabOrder) do
          self:Select(s.name, tn)
          break
        end
      end)
      syo = syo + 30
    end

    -- ── Tab bar ──
    self:_drawRect(sx, y + 30, cw, 26, Color3.fromRGB(20, 20, 20))
    if self._currentSub then
      local tx = sx + 4
      for _, tn in ipairs(self._currentSub.tabOrder) do
        local sel       = self._currentTab and self._currentTab.name == tn
        local tw        = #tn * 9 + 20
        local bgColor   = sel and Color3.fromRGB(55, 55, 55) or Color3.fromRGB(35, 35, 35)
        local textColor = sel and Color3.fromRGB(255, 255, 255) or Color3.fromRGB(180, 180, 180)

        self:_drawRect(tx, y + 33, tw, 20, bgColor)
        self:_drawText(tn, tx + 6, y + 34, 13, textColor)
        self:_addClickable(tx, y + 33, tw, 20, function()
          self:Select(self._currentSub.name, tn)
        end)
        tx = tx + tw + 4
      end
    end

    -- ── Content area ──
    self:_drawRect(sx, y + 56, cw, vh, Color3.fromRGB(15, 15, 15))

    -- ── Draw tab elements ──
    if self._currentTab then
      local ey = 10   -- running Y offset from top of content area

      for _, elem in ipairs(self._currentTab.elements) do
        local ey2 = y + 56 + ey - sy
        local an  = elem.attr

        if elem.type == "num" then
          self:_drawNumElement(elem, sx, ey2, cw, an)
          ey = ey + 110 + 10
        elseif elem.type == "bool" then
          self:_drawBoolElement(elem, sx, ey2, cw, an)
          ey = ey + 70 + 10
        end
      end

      -- ── Scrollbar ──
      local totalH = ey + 10
      self._scrollMax = math.max(0, totalH - vh)
      if self._scrollMax > 0 then
        local barH = math.max(30, vh * (vh / totalH))
        local barY = y + 56 + (self._scrollY / self._scrollMax) * (vh - barH)
        self:_drawRect(x + w - 6, barY, 4, barH, Color3.fromRGB(60, 60, 60))
      end
    end
  end

  -- ── Draw a number element card (responsive) ──
  function self:_drawNumElement(elem, sx, ey, cw, an)
    local cv = getAttr(an) or 0
    local cn = self._confNum[an] or cv

    -- Card background — width adapts to content area
    self:_drawRect(sx + 2, ey, cw - 4, 110, Color3.fromRGB(25, 25, 25))

    -- Title
    self:_drawText(elem.name, sx + 10, ey + 4, 15, Color3.fromRGB(220, 220, 220))

    -- Current value
    self:_drawText("Current: " .. tostring(cv), sx + 10, ey + 24, 13, Color3.fromRGB(140, 140, 140))

    -- Responsive input field — scales with content width
    local inputW  = math.max(80, math.min(150, cw * 0.4))
    local confW   = math.max(50, math.min(70, cw * 0.2))

    local typing = (self._selectingInput == an)
    self:_drawRect(sx + 10, ey + 46, inputW, 26, Color3.fromRGB(35, 35, 35))

    local inputText = "Click to type..."
    if typing then
      inputText = (self._inputBox.Text ~= "" and self._inputBox.Text) or "|"
    end
    self:_drawText(inputText, sx + 14, ey + 48, 13, Color3.fromRGB(180, 180, 180))

    self:_addClickable(sx + 10, ey + 46, inputW, 26, function()
      self._selectingInput = an
      self._inputBox.Text  = ""
      self._inputBox.Visible = true
      self._inputBox.Position = UDim2.new(0, sx + 10, 0, ey + 46)
      self._inputBox.Size = UDim2.new(0, inputW, 0, 26)
    end)

    -- Confirm button — placed right after input
    local btnX = sx + 10 + inputW + 6
    self:_drawRect(btnX, ey + 46, confW, 26, Color3.fromRGB(40, 120, 40))
    self:_drawText("Confirm", btnX + 6, ey + 48, 13, Color3.new(1, 1, 1))
    self:_addClickable(btnX, ey + 46, confW, 26, function()
      local v = tonumber(self._inputBox.Text)
      if v then
        self._confNum[an] = v
        setAttr(an, v)
        self._inputBox.Text = ""
        self._selectingInput = nil
        self._inputBox.Visible = false
      end
    end)

    -- Toggle Locked checkbox
    local lx, ly  = sx + 10, ey + 78
    local lk      = self._lockNum[an] or false
    local chkColor = lk and Color3.fromRGB(60, 200, 60) or Color3.fromRGB(40, 40, 40)
    local txtColor = lk and Color3.fromRGB(180, 220, 180) or Color3.fromRGB(120, 120, 120)

    self:_drawRect(lx, ly, 16, 16, chkColor)
    self:_drawText(lk and "✓" or "", lx + 2, ly - 1, 12, Color3.new(1, 1, 1))
    self:_drawText("Toggle Locked", lx + 20, ly, 13, txtColor)
    self:_addClickable(lx, ly, 130, 16, function()
      self._lockNum[an] = not self._lockNum[an]
    end)
  end

  -- ── Draw a boolean element card (responsive) ──
  function self:_drawBoolElement(elem, sx, ey, cw, an)
    local cv = getAttr(an) == true
    if self._lockBool[an] then cv = self._confBool[an] end

    -- Card background — width adapts to content area
    self:_drawRect(sx + 2, ey, cw - 4, 70, Color3.fromRGB(25, 25, 25))

    -- Title
    self:_drawText(elem.name, sx + 10, ey + 4, 15, Color3.fromRGB(220, 220, 220))

    -- Checkmark toggle — right-aligned within card
    local ckx     = sx + cw - 44
    local cky     = ey + 4
    local chkColor = cv and Color3.fromRGB(60, 200, 60) or Color3.fromRGB(40, 40, 40)
    self:_drawRect(ckx, cky, 20, 20, chkColor)
    self:_drawText(cv and "✓" or "", ckx + 3, cky - 1, 14, Color3.new(1, 1, 1))
    self:_drawText(
      cv and "Enabled" or "Disabled",
      ckx - 54, cky + 1, 13,
      cv and Color3.fromRGB(180, 220, 180) or Color3.fromRGB(140, 140, 140)
    )
    self:_addClickable(ckx, cky, 20, 20, function()
      local nv = not (getAttr(an) == true)
      self._confBool[an] = nv
      setAttr(an, nv)
    end)

    -- Toggle Locked checkbox
    local lx, ly  = sx + 10, ey + 30
    local lk      = self._lockBool[an] or false
    local lkChk   = lk and Color3.fromRGB(60, 200, 60) or Color3.fromRGB(40, 40, 40)
    local lkTxt   = lk and Color3.fromRGB(180, 220, 180) or Color3.fromRGB(120, 120, 120)

    self:_drawRect(lx, ly, 16, 16, lkChk)
    self:_drawText(lk and "✓" or "", lx + 2, ly - 1, 12, Color3.new(1, 1, 1))
    self:_drawText("Toggle Locked", lx + 20, ly, 13, lkTxt)
    self:_addClickable(lx, ly, 130, 16, function()
      self._lockBool[an] = not self._lockBool[an]
      if self._lockBool[an] then
        self._confBool[an] = getAttr(an) == true
      end
    end)
  end

  -- ============================================================
  --  INTERNAL: Input handling
  -- ============================================================
  function self:_hookInput()
    -- InputBegan
    local conn1 = UIS.InputBegan:Connect(function(i, p)
      if p and i.UserInputType ~= Enum.UserInputType.Keyboard then return end

      if i.UserInputType == Enum.UserInputType.MouseButton1 then
        local mx, my = i.Position.X, i.Position.Y

        -- Check clickable areas
        for _, c in ipairs(self._clickables) do
          if mx >= c.x and mx <= c.x + c.w and my >= c.y and my <= c.y + c.h then
            c.cb()
            return
          end
        end

        -- Start dragging (top bar)
        if mx >= self.x and mx <= self.x + self.w
          and my >= self.y and my <= self.y + 30 then
          self._dragging = true
          self._dragOffX = mx - self.x
          self._dragOffY = my - self.y
        end

        -- Start resizing (bottom-right corner)
        if mx >= self.x + self.w - 14 and mx <= self.x + self.w
          and my >= self.y + self.h - 14 and my <= self.y + self.h then
          self._resizing = true
          self._dragOffX = mx
          self._dragOffY = my
        end

      elseif i.UserInputType == Enum.UserInputType.Keyboard then
        if i.KeyCode == self.toggleKey then
          self.visible = not self.visible
        elseif i.KeyCode == Enum.KeyCode.Return and self._selectingInput then
          local v = tonumber(self._inputBox.Text)
          if v then
            self._confNum[self._selectingInput] = v
            setAttr(self._selectingInput, v)
          end
          self._inputBox.Text = ""
          self._selectingInput = nil
          self._inputBox.Visible = false
        end
      end
    end)
    table.insert(self._conns, conn1)

    -- InputChanged (drag, resize, scroll)
    local conn2 = UIS.InputChanged:Connect(function(i, p)
      if p then return end

      if i.UserInputType == Enum.UserInputType.MouseMovement then
        local mx, my = i.Position.X, i.Position.Y
        if self._dragging and not self._resizing then
          self.x = mx - self._dragOffX
          self.y = my - self._dragOffY
        elseif self._resizing then
          self.w = math.max(350, mx - self.x)
          self.h = math.max(250, my - self.y)
        end

      elseif i.UserInputType == Enum.UserInputType.MouseButton1 then
        self._dragging = false
        self._resizing = false

      elseif i.UserInputType == Enum.UserInputType.MouseWheel then
        if self.visible then
          local mx, my = i.Position.X, i.Position.Y
          if mx >= self.x + 170 and mx <= self.x + self.w
            and my >= self.y + 30 and my <= self.y + self.h then
            self._scrollY = math.clamp(
              self._scrollY - i.Position.Z * 30,
              0, self._scrollMax
            )
          end
        end
      end
    end)
    table.insert(self._conns, conn2)
  end

  -- ============================================================
  --  INTERNAL: Lock loop
  -- ============================================================
  function self:_startLockLoop()
    task.spawn(function()
      while self._started do
        task.wait(1)
        for an, lk in pairs(self._lockNum) do
          if lk and self._confNum[an] then
            pcall(setAttr, an, self._confNum[an])
          end
        end
        for an, lk in pairs(self._lockBool) do
          if lk then
            pcall(setAttr, an, self._confBool[an])
          end
        end
      end
    end)
  end

  -- ============================================================
  --  INTERNAL: Render loop
  -- ============================================================
  function self:_startRenderLoop()
    local conn = RunService.RenderStepped:Connect(function()
      self:_render()
    end)
    table.insert(self._conns, conn)
  end

  return self
end

return mainUILib
