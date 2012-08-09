
  -- // DiscoKugel
  -- // zork - 2010

  --get the addon namespace
  local addon, ns = ...

  --get the config
  local cfg = ns.cfg

  local list = cfg.displayIdList
  local numList = # list

  local texList = cfg.textureList
  local numTexList = # texList

  -----------------------------
  -- FUNCTIONS
  -----------------------------

  --round some stuff
  local function roundNumber(v)
    return floor((v)*1000)/1000
  end

  --change portraitZoom func
  local function changeModelPortraitZoom(self, delta)
    local maxzoom = 1
    local minzoom = -0.5
    self.zoomLevel = self.zoomLevel + delta*0.15
    if (self.zoomLevel > maxzoom) then
        self.zoomLevel = maxzoom
    end
    if (minzoom > self.zoomLevel) then
        self.zoomLevel = minzoom
    end
    self.zoomLevel = roundNumber(self.zoomLevel)
    self:SetPortraitZoom(self.zoomLevel)
  end

  --change camDistanceScale func
  local function changeModelDistanceScale(self, delta)
    local maxscale = 20
    local minscale = 0.1
    self.scaleLevel = self.scaleLevel + delta*0.05
    if (self.scaleLevel > maxscale) then
        self.scaleLevel = maxscale
    end
    if (minscale > self.scaleLevel) then
        self.scaleLevel = minscale
    end
    self.scaleLevel = roundNumber(self.scaleLevel)
    self:SetCamDistanceScale(self.scaleLevel)
  end

  --move model left right func
  local function moveModelLeftRight(self, delta)
    local max = 20
    local min = -20
    self.posX = self.posX + delta*0.05
    if (self.posX > max) then
        self.posX = max
    end
    if (min > self.posX) then
        self.posX = min
    end
    self.posX = roundNumber(self.posX)
    self:SetPosition(0,self.posX,self.posY)
  end

  --move model top bottom func
  local function moveModelTopBottom(self, delta)
    local max = 20
    local min = -20
    self.posY = self.posY + delta*0.05
    if (self.posY > max) then
        self.posY = max
    end
    if (min > self.posY) then
        self.posY = min
    end
    self.posY = roundNumber(self.posY)
    self:SetPosition(0,self.posX,self.posY)
  end

  --model rotation func
  local function rotateModel(self,button)
    local rotationIncrement = 0.2
    if button == "LeftButton" then
      self.rotation = self.rotation - rotationIncrement
    else
      self.rotation = self.rotation + rotationIncrement
    end
    self.rotation = roundNumber(self.rotation)
    self:SetRotation(self.rotation)
  end

  --tooltip for model func
  local function showModelTooltip(self,theatre)
    GameTooltip:SetOwner(self, "ANCHOR_CURSOR")
    --GameTooltip:SetPoint("BOTTOMRIGHT", UIParent, "BOTTOMRIGHT", -90, 90)
    if not theatre then
      GameTooltip:AddLine("Model View", 0, 1, 0.5, 1, 1, 1)
    else
      GameTooltip:AddLine("Theatre View", 0, 1, 0.5, 1, 1, 1)
    end
    local r,g,b = self:GetParent().fill:GetVertexColor()
    local colorStr = "R "..roundNumber(r).." G "..roundNumber(g).." B "..roundNumber(b)

    GameTooltip:AddLine("-- MODEL --------------------------------------------")
    GameTooltip:AddDoubleLine("DisplayID", self.id, 1, 1, 1, 1, 1, 1)
    GameTooltip:AddDoubleLine("SetCamDistanceScale", self.scaleLevel, 1, 1, 1, 1, 1, 1)
    GameTooltip:AddDoubleLine("SetPortraitZoom", self.zoomLevel, 1, 1, 1, 1, 1, 1)
    GameTooltip:AddDoubleLine("SetPosition", "(0,"..self.posX..","..self.posY..")", 1, 1, 1, 1, 1, 1)
    GameTooltip:AddDoubleLine("SetRotation", self.rotation, 1, 1, 1, 1, 1, 1)
    GameTooltip:AddDoubleLine("GetModel", self:GetModel(), 1, 1, 1, 1, 1, 1)
    GameTooltip:AddLine("-- FILLING TEXTURE ----------------------------------")
    GameTooltip:AddDoubleLine("FillingColor", colorStr, 1, 1, 1, 1, 1, 1)
    GameTooltip:AddDoubleLine("FillingTexture", self:GetParent().fill:GetTexture(), 1, 1, 1, 1, 1, 1)
    GameTooltip:AddLine("-- LEFT MOUSE ---------------------------------------")
    GameTooltip:AddLine("LeftMouse                  = COLOR PICKER -----------")
    GameTooltip:AddLine("SHIFT + LeftMouse          = RESET ------------------")
    GameTooltip:AddLine("ALT + LeftMouse            = ROTATE MODEL LEFT ------")
    GameTooltip:AddLine("-- RIGHT MOUSE --------------------------------------")
    GameTooltip:AddLine("RightMouse                 = CYCLE FILLING TEXTURES -")
    GameTooltip:AddLine("SHIFT + RightMouse + DRAG  = MOVE -------------------")
    GameTooltip:AddLine("ALT + RightMouse + DRAG    = RESIZE -----------------")
    GameTooltip:AddLine("-- OTHER BUTTONS ------------------------------------")
    GameTooltip:AddLine("MouseButton4               = NEXT MODEL ANIMATION ---")
    GameTooltip:AddLine("MouseButton5               = PREVIOUS MODEL ANIMATION")
    GameTooltip:AddLine("-- MOUSE WHEEL --------------------------------------")
    GameTooltip:AddLine("MouseWheel                 = SetCamDistanceScale ----")
    GameTooltip:AddLine("ALT + MouseWheel           = Y-AXIS -----------------")
    GameTooltip:AddLine("SHIFT + MouseWheel         = X-AXIS -----------------")
    GameTooltip:AddLine("ALT + SHIFT + MouseWheel   = SetPortraitZoom --------")
    GameTooltip:Show()
  end

  local function loadDefaultModelValues(self)
    self.scaleLevel = 1
    self.zoomLevel = 1
    self.posX = 0
    self.posY = 0
    self.rotation = 0
    self:SetPortraitZoom(self.zoomLevel)
    self:SetCamDistanceScale(self.scaleLevel)
    self:SetPosition(0,self.posX,self.posY)
    self:SetRotation(self.rotation)
    self:ClearModel() --clearmodel to make sure model values reset correctly
    self:SetModel("interface\\buttons\\talktomequestionmark.m2") --in case setdisplayinfo fails
    self:SetDisplayInfo(self.id)
  end

  local function setFillingTexture(self)
    self.fill:SetTexture(texList[self.texIndex])
  end

  local function changeModel(self)
    local m = self.m
    local listentry = list[self.index]
    m.id = listentry
    loadDefaultModelValues(m)
  end

  function showColorPicker(r, g, b, a, callback)
    ColorPickerFrame:SetColorRGB(r,g,b)
    ColorPickerFrame.hasOpacity, ColorPickerFrame.opacity = (a ~= nil), a
    ColorPickerFrame.previousValues = {r,g,b,a}
    ColorPickerFrame.func, ColorPickerFrame.opacityFunc, ColorPickerFrame.cancelFunc = callback, callback, callback
    ColorPickerFrame:Hide()
    ColorPickerFrame:Show()
  end

  local createOrb = function(listentry, index)

    local f = CreateFrame("FRAME",nil,UIParent)
    f:SetFrameLevel(1)
    f:SetSize(150,150)
    f:SetPoint("CENTER",0,0)

    f.index = index
    f.texIndex = index

    local bg = f:CreateTexture(nil,"BACKGROUND",nil,-8)
    bg:SetAllPoints(f)
    bg:SetTexture("Interface\\AddOns\\DiscoKugel\\media\\orb_back")

    local fill = f:CreateTexture(nil,"BACKGROUND",nil,-7)
    fill:SetAllPoints(f)
    fill:SetTexture(texList[f.texIndex])
    fill:SetVertexColor(1,0,0)
    f.fill = fill

    local m = CreateFrame("PlayerModel", nil,f)
    m:SetAllPoints(f)
    m:SetModel("interface\\buttons\\talktomequestionmark.m2") --in case setdisplayinfo fails
    m:SetDisplayInfo(listentry)
    m.id = listentry
    loadDefaultModelValues(m)
    f.m = m

    f.recolorFillingTexture = function(color)
      local r,g,b,a
      if color then
        r,g,b,a = unpack(color)
      else
        r,g,b = ColorPickerFrame:GetColorRGB()
        a = OpacitySliderFrame:GetValue()
      end
      f.fill:SetVertexColor(r,g,b)
      f.m:SetAlpha(a)
    end

    local g = CreateFrame("Frame",nil,m)
    g:SetAllPoints(f)

    local gloss = g:CreateTexture(nil,"BACKGROUND",nil,-6)
    gloss:SetAllPoints(f)
    gloss:SetTexture("Interface\\AddOns\\DiscoKugel\\media\\orb_gloss")

    f:SetMovable(true)
    f:SetResizable(true)
    f:SetUserPlaced(true)
    f:EnableMouse(true)
    f:RegisterForDrag("RightButton")
    f:SetScript("OnDragStart", function(s)
      if IsAltKeyDown() then
        s:StartSizing()
      elseif IsShiftKeyDown() then
        s:StartMoving()
      end
    end)
    f:SetScript("OnSizeChanged", function(s)
      if s:GetWidth() < 50 then
        s:SetWidth(50)
        s:SetHeight(50)
      end
      s:SetHeight(s:GetWidth())
    end)
    f:SetScript("OnDragStop", function(s)
      if s:GetWidth() < 50 then
        s:SetWidth(50)
      end
      s:SetHeight(s:GetWidth())
      s:StopMovingOrSizing()
    end)
    f:SetScript("OnMouseDown", function(s,bu,...)
      if bu == "Button4" then
        s.index = s.index + 1
        if not list[s.index] then
          s.index = 1
        end
        changeModel(s)
      end
      if bu == "Button5" then
        s.index = s.index - 1
        if not list[s.index] then
          s.index = numList
        end
        changeModel(s)
      end
      if bu == "RightButton" then
        if IsAltKeyDown() or IsShiftKeyDown() then return end
        --changeModel(s)
        --change Texture func
        s.texIndex = s.texIndex + 1
        if not texList[s.texIndex] then
          s.texIndex = 1
        end
        setFillingTexture(s)
      end
      if bu == "LeftButton" then
        if IsShiftKeyDown() then
          loadDefaultModelValues(s.m)
        elseif IsAltKeyDown() then
          rotateModel(s.m,bu)
        else
          local r,g,b = s.fill:GetVertexColor()
          local a = s.m:GetAlpha()
          showColorPicker(r,g,b,a,s.recolorFillingTexture)
        end
      end
    end)
    f:SetScript("OnMouseWheel", function(s,d,...)
      if IsShiftKeyDown() and IsAltKeyDown() then
        changeModelPortraitZoom(s.m,d)
      elseif IsAltKeyDown() then
        moveModelTopBottom(s.m,d)
      elseif IsShiftKeyDown() then
        moveModelLeftRight(s.m,d)
      else
        changeModelDistanceScale(s.m,d)
      end
    end)
    f:SetScript("OnEnter", function(s) showModelTooltip(s.m) end)
    f:SetScript("OnLeave", function(s) GameTooltip:Hide() end)
  end



  -----------------------------
  -- CALL
  -----------------------------

  if list[1] then
    createOrb(list[1],1)
  end


