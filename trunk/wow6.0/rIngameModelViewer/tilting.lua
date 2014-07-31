
  --model tilting
  --credits to Resike and Vrul
  --http://www.wowinterface.com/forums/showthread.php?t=48394

  -------------------------------------
  -- ADDON TABLES
  -------------------------------------

  local an, at = ...

  -------------------------------------
  -- VARIABLES
  -------------------------------------

  local format, math, pi, halfpi = format, math, math.pi, math.pi / 2
  local x, y, z, px, py, pz, rot

  -------------------------------------
  -- FUNCTIONS
  -------------------------------------

  -- is number func
  local function IsNumber(n)
    if tonumber(n) then
      return true
    else
      return false
    end
  end

  local function OnDragStart(self)
    self:SetMovable(true)
    self:StartMoving()
  end

  local function OnDragStop(self)
    self:StopMovingOrSizing()
    self:SetMovable(false)
    local x = math.floor(self:GetLeft() + (self:GetWidth() - UIParent:GetWidth()) / 2 + 0.5)
    local y = math.floor(self:GetTop() - (self:GetHeight() + UIParent:GetHeight()) / 2 + 0.5)
    self:ClearAllPoints()
    self:SetPoint("CENTER", x, y)
  end

  local function OnUpdate(self, elapsed)
    local x, y = GetCursorPosition()
    local pitch = self.pitch + (y - self.y) * pi / 256
    local limit = false
    if pitch > halfpi - 0.05 or pitch < - halfpi + 0.05 then
      limit = true
    end
    if limit then
      local rotation = format("%.0f", math.abs(math.deg(((x - self.x) / 64 + self:GetFacing())) % 360))
      if rotation ~= format("%.0f", math.abs(math.deg(self:GetFacing()) % 360)) then
        self:SetRotation(math.rad(rotation))
      end
    else
      local yaw = self.yaw + (x - self.x) * pi / 256
      self:SetOrientation(self.distance, yaw, pitch)
    end
    self.x, self.y = x, y
  end

  local function RightButtonOnUpdate(self, elapsed)
    local x, y = GetCursorPosition()
    local px, py, pz = self:GetPosition()
    if IsAltKeyDown() then
      local mx = format("%.2f", (px + (y - self.y) / 64))
      if format("%.2f", px) ~= mx then
        self:SetPosition(mx, py, pz)
      end
    else
      local my = format("%.2f", (py + (x - self.x) / 64))
      local mz = format("%.2f", (pz + (y - self.y) / 64))
      if format("%.2f", py) ~= my or format("%.2f", pz) ~= mz then
        self:SetPosition(px, my, mz)
      end
    end
    self.x, self.y = x, y
  end

  local function MiddleButtonOnUpdate(self, elapsed)
    local x, y = GetCursorPosition()
    local rotation = format("%.0f", math.abs(math.deg(((x - self.x) / 84 + self:GetFacing())) % 360))
    if rotation ~= format("%.0f", math.abs(math.deg(self:GetFacing()) % 360)) then
      self:SetRotation(math.rad(rotation))
    end
    self.x, self.y = x, y
  end

  local function OnMouseDown(self, button)
    if button == "LeftButton" then
      if IsAltKeyDown() then
        OnDragStart(self:GetParent())
      else
        self.x, self.y = GetCursorPosition()
        self:SetScript("OnUpdate", OnUpdate)
      end
    elseif button == "RightButton" then
      self.x, self.y = GetCursorPosition()
      self:SetScript("OnUpdate", RightButtonOnUpdate)
    elseif button == "MiddleButton" then
      if IsAltKeyDown() then
        self:Reset()
      else
        self.x, self.x = GetCursorPosition()
        self:SetScript("OnUpdate", MiddleButtonOnUpdate)
      end
    end
  end

  local function OnMouseUp(self, button)
    OnDragStop(self:GetParent())
    self:SetScript("OnUpdate", nil)
  end

  local function OnMouseWheel(self, delta)
    local zoom = 0.1
    if IsControlKeyDown() then
      zoom = 0.5
    elseif IsAltKeyDown() then
      zoom = 1
    end
    local distance = self.distance - delta * zoom
    if distance > 40 then
      distance = 40
    elseif distance < zoom then
      distance = zoom
    end
    self:SetOrientation(distance, self.yaw, self.pitch)
  end

  local function CreateModelFrame(model)
    local f = CreateFrame("Frame", nil, UIParent)
    f:SetPoint("CENTER")
    f:SetSize(512, 512)
    f:SetBackdrop({bgFile = "interface\\tooltips\\ui-tooltip-background", insets = {left = 0, top = 0, right = 0, bottom = 0}, tile = true,})
    f:SetBackdropColor(0, 1, 0, 0.5)
    f:SetMovable(false)
    function f:CreateModel(model)
      local m = CreateFrame("PlayerModel", nil, self)
      if UnitExists(model) then
        m:SetUnit(model)
      elseif IsNumber(model) then
        m:SetDisplayInfo(model)
      else
        m:SetModel(model)
      end
      m:SetAllPoints()
      m:SetSize(512, 512)
      m:SetMovable(false)
      m:EnableMouse(true)
      m:EnableMouseWheel(true)
      function m:SetOrientation(distance, yaw, pitch)
        if self:HasCustomCamera() then
          self.distance, self.yaw, self.pitch = distance, yaw, pitch
          local x = distance * math.cos(yaw) * math.cos(pitch)
          local y = distance * math.sin(- yaw) * math.cos(pitch)
          local z = (distance * math.sin(- pitch))
          self:SetCameraPosition(x, y, z)
        end
      end
      function m:Reset()
        self:SetCustomCamera(1)
        self:SetCameraPosition(x, y, z)
        self:SetPosition(px, py, pz)
        self:SetRotation(rot)
        self:SetCameraTarget(0, 0, pi / 5)
        self:SetOrientation(math.sqrt(x * x + y * y + z * z), - math.atan(y / x), - math.atan(z / x))
      end
      function m:Initialize()
        self:SetCustomCamera(1)
        x, y, z = self:GetCameraPosition()
        px, py, pz = self:GetPosition()
        rot = self:GetFacing()
        self:SetCameraTarget(0, 0, pi / 5)
        self:SetOrientation(math.sqrt(x * x + y * y + z * z), - math.atan(y / x), - math.atan(z / x))
      end
      m:SetScript("OnKeyUp", OnKeyUp)
      m:SetScript("OnDragStart", OnDragStart)
      m:SetScript("OnDragStop", OnDragStop)
      m:SetScript("OnMouseDown", OnMouseDown)
      m:SetScript("OnMouseUp", OnMouseUp)
      m:SetScript("OnMouseWheel", OnMouseWheel)
      m:Initialize()
      return m
    end
    f.model = f:CreateModel(model)
    return f
  end

  --models defined on loadup are not rendered properly. model display needs to be delayed.
  local addonCallAfterLogin = CreateFrame("Frame")
  addonCallAfterLogin:HookScript("OnEvent", function(self)
    local m1 = CreateModelFrame("Creature\\Alexstrasza\\LadyAlexstrasa.m2")
    local m2 = CreateModelFrame(21723)
    if UnitExists("player") then
      local m3 = CreateModelFrame("player")
    end
    self:UnregisterEvent("PLAYER_ENTERING_WORLD")
  end)
  addonCallAfterLogin:RegisterEvent("PLAYER_ENTERING_WORLD")
