
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
  local function rIMV_roundNumber(n)
    return floor((n)*10)/10
  end

   
  --change portraitZoom func
  local function rIMV_changeModelPortraitZoom(self, delta)
    local maxzoom = 1
    local minzoom = -0.5
    self.zoomLevel = self.zoomLevel + delta*0.15
    if (self.zoomLevel > maxzoom) then
        self.zoomLevel = maxzoom
    end
    if (minzoom > self.zoomLevel) then
        self.zoomLevel = minzoom
    end
    self.zoomLeve = rIMV_roundNumber(self.zoomLevel)
    self:SetPortraitZoom(self.zoomLevel)
  end
    
  --change camDistanceScale func
  local function rIMV_changeModelDistanceScale(self, delta)
    local maxscale = 10
    local minscale = 0.1
    self.scaleLevel = self.scaleLevel + delta*0.15
    if (self.scaleLevel > maxscale) then
        self.scaleLevel = maxscale
    end
    if (minscale > self.scaleLevel) then
        self.scaleLevel = minscale
    end
    self.scaleLevel = rIMV_roundNumber(self.scaleLevel)
    self:SetCamDistanceScale(self.scaleLevel)
  end
  
  --move model left right func
  local function rIMV_moveModelLeftRight(self, delta)
    local max = 10
    local min = -10
    self.posX = self.posX + delta*0.15
    if (self.posX > max) then
        self.posX = max
    end
    if (min > self.posX) then
        self.posX = min
    end
    self.posX = rIMV_roundNumber(self.posX)
    self:SetPosition(0,self.posX,self.posY)
  end
  
  --move model top bottom func
  local function rIMV_moveModelTopBottom(self, delta)
    local max = 10
    local min = -10
    self.posY = self.posY + delta*0.15
    if (self.posY > max) then
        self.posY = max
    end
    if (min > self.posY) then
        self.posY = min
    end
    self.posY = rIMV_roundNumber(self.posY)
    self:SetPosition(0,self.posX,self.posY)
  end
  
  --model rotation func
  local function rIMV_rotateModel(self,button)
    local rotationIncrement = 0.2
    if button == "LeftButton" then
      self.rotation = self.rotation - rotationIncrement
    else
      self.rotation = self.rotation + rotationIncrement
    end
    self.rotation = rIMV_roundNumber(self.rotation)
    self:SetRotation(self.rotation)
  end
  
  --tooltip for model func
  local function rIMV_showModelTooltip(self,theatre)
    GameTooltip:SetOwner(self, "ANCHOR_CURSOR")
    --GameTooltip:SetPoint("BOTTOMRIGHT", UIParent, "BOTTOMRIGHT", -90, 90)
    if not theatre then
      GameTooltip:AddLine("Model View", 0, 1, 0.5, 1, 1, 1)
    else
      GameTooltip:AddLine("Theatre View", 0, 1, 0.5, 1, 1, 1)
    end
    local r,g,b = self:GetParent().fill:GetVertexColor()
    r = math.floor(r*100)/100
    g = math.floor(g*100)/100
    b = math.floor(b*100)/100
    local colorStr = "R "..r.." G "..g.." B "..b

    GameTooltip:AddLine("~ model ~~~~~")
    GameTooltip:AddDoubleLine("DisplayID", self.id, 1, 1, 1, 1, 1, 1)
    GameTooltip:AddDoubleLine("SetCamDistanceScale", self.scaleLevel, 1, 1, 1, 1, 1, 1)
    GameTooltip:AddDoubleLine("SetPortraitZoom", self.zoomLevel, 1, 1, 1, 1, 1, 1)    
    GameTooltip:AddDoubleLine("SetPosition", "(0,"..self.posX..","..self.posY..")", 1, 1, 1, 1, 1, 1)
    GameTooltip:AddDoubleLine("SetRotation", self.rotation, 1, 1, 1, 1, 1, 1)
    GameTooltip:AddDoubleLine("GetModel", self:GetModel(), 1, 1, 1, 1, 1, 1)
    GameTooltip:AddLine("~ texture ~~~~~")
    GameTooltip:AddDoubleLine("FillingColor", colorStr, 1, 1, 1, 1, 1, 1)
    GameTooltip:AddDoubleLine("FillingTexture", self:GetParent().fill:GetTexture(), 1, 1, 1, 1, 1, 1)
    GameTooltip:AddLine("~ left mouse ~~~~~")
    GameTooltip:AddLine("LeftMouse = NEW COLOR")
    GameTooltip:AddLine("SHIFT + LeftMouse = RESET")
    GameTooltip:AddLine("ALT + LeftMouse = ROTATE MODEL LEFT")
    GameTooltip:AddLine("~ right mouse ~~~~~")
    GameTooltip:AddLine("RightMouse = CYCLE FILLING TEXTURES")
    GameTooltip:AddLine("SHIFT + RightMouse + DRAG = MOVE")
    GameTooltip:AddLine("ALT + RightMouse + DRAG = RESIZE")
    GameTooltip:AddLine("~ buttons ~~~~~")
    GameTooltip:AddLine("MouseButton4 = NEXT MODEL ANIMATION")
    GameTooltip:AddLine("MouseButton5 = PREVIOUS MODEL ANIMATION")
    GameTooltip:AddLine("~ wheel ~~~~~")
    GameTooltip:AddLine("MouseWheel = SetCamDistanceScale")
    GameTooltip:AddLine("ALT + MouseWheel Y-AXIS")
    GameTooltip:AddLine("SHIFT + MouseWheel = X-AXIS")
    GameTooltip:AddLine("ALT + SHIFT + MouseWheel = SetPortraitZoom")
    GameTooltip:Show()
  end
  
  local function rIMV_setModelValues(self)
  
    self.scaleLevel = 1
    self.zoomLevel = 1
    self.posX = 0
    self.posY = 0
    self.rotation = 0
    
    self:SetPortraitZoom(self.zoomLevel)
    self:SetCamDistanceScale(self.scaleLevel)
    self:SetPosition(0,self.posX,self.posY)
    self:SetRotation(self.rotation)
    self:ClearModel()
    self:SetDisplayInfo(self.id)
  end

  local function rIMV_setFillingTexture(self)
    self.fill:SetTexture(texList[self.texIndex])
  end

  local function rIMV_changeModel(self)  
    --local f = self.fill
    --f:SetVertexColor(listentry.color.r,listentry.color.g,listentry.color.b)    
    local m = self.m
    
    m:SetModel("interface\\buttons\\talktomequestionmark.m2") --in case setdisplayinfo fails 
    local listentry = list[self.index]
    print("changing model displayid to: "..listentry)
    --m:SetDisplayInfo(listentry)
    m.id = listentry
    rIMV_setModelValues(m)  
  end

  function ShowColorPicker(r, g, b, a, changedCallback)
    ColorPickerFrame:SetColorRGB(r,g,b);
    ColorPickerFrame.hasOpacity, ColorPickerFrame.opacity = (a ~= nil), a;
    ColorPickerFrame.previousValues = {r,g,b,a};
    ColorPickerFrame.func, ColorPickerFrame.opacityFunc, ColorPickerFrame.cancelFunc = 
    changedCallback, changedCallback, changedCallback;
    ColorPickerFrame:Hide(); -- Need to run the OnShow handler.
    ColorPickerFrame:Show();
  end

  local createOrb = function(listentry, index)
    
    local f = CreateFrame("FRAME",nil,UIParent)
    f:SetFrameLevel(1)
    f:SetSize(150,150)
    f:SetPoint("CENTER",0,0)
    
    f.index = index
    
    local bg = f:CreateTexture(nil,"BACKGROUND",nil,-8)
    bg:SetAllPoints(f)
    bg:SetTexture("Interface\\AddOns\\DiscoKugel\\media\\orb_back")
    
    local fill = f:CreateTexture(nil,"BACKGROUND",nil,-7)
    fill:SetAllPoints(f)
    f.texIndex = 1
    fill:SetTexture(texList[f.texIndex])
    fill:SetVertexColor(1,0,0)
    
    f.fill = fill

    local function myColorCallback(restore)
      --local newR, newG, newB, newA;
      local color = {}
      if restore then
        -- The user bailed, we extract the old color from the table created by ShowColorPicker.
        color.r, color.g, color.b, color.a = unpack(restore)
      else
        -- Something changed
        color.a, color.r, color.g, color.b = OpacitySliderFrame:GetValue(), ColorPickerFrame:GetColorRGB()
      end     
      f.fill:SetVertexColor(color.r, color.g, color.b)
    end
    
    local m = CreateFrame("PlayerModel", nil,f)
    m:SetAllPoints(f)
    m:SetModel("interface\\buttons\\talktomequestionmark.m2") --in case setdisplayinfo fails 
    m:SetDisplayInfo(listentry)
    m.id = listentry
    rIMV_setModelValues(m)

    f.m = m
    
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
        rIMV_changeModel(s)
      end
      if bu == "Button5" then
        s.index = s.index - 1
        if not list[s.index] then
          s.index = numList
        end
        rIMV_changeModel(s)
      end
      if bu == "RightButton" then
        if IsAltKeyDown() or IsShiftKeyDown() then return end
        --rIMV_changeModel(s)
        --change Texture func
        s.texIndex = s.texIndex + 1
        if not texList[s.texIndex] then
          s.texIndex = 1
        end
        rIMV_setFillingTexture(s)
      end
      if bu == "LeftButton" then
        if IsShiftKeyDown() then
          rIMV_setModelValues(s.m)
        elseif IsAltKeyDown() then
          rIMV_rotateModel(s.m,bu)
        else
          local color = {}
          color.r, color.g, color.b = s.fill:GetVertexColor()
          ShowColorPicker(color.r, color.g, color.b, 1, myColorCallback);
          --rIMV_changeModel(s)
        end
      end
    end)    
    f:SetScript("OnMouseWheel", function(s,d,...)
      if IsShiftKeyDown() and IsAltKeyDown() then
        rIMV_changeModelPortraitZoom(s.m,d)        
      elseif IsAltKeyDown() then
        rIMV_moveModelTopBottom(s.m,d)
      elseif IsShiftKeyDown() then
        rIMV_moveModelLeftRight(s.m,d)
      else
        rIMV_changeModelDistanceScale(s.m,d)
      end
    end)
    
    f:SetScript("OnEnter", function(s) rIMV_showModelTooltip(s.m) end)
    f:SetScript("OnLeave", function(s) GameTooltip:Hide() end)
  
  end

  
  
  -----------------------------
  -- CALL
  ----------------------------- 

  if list[1] then
    createOrb(list[1],1)
  end

  
