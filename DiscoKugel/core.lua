
  -- // DiscoKugel
  -- // zork - 2010

  --get the addon namespace
  local addon, ns = ...  
  
  --get the config
  local cfg = ns.cfg
  
  local list = cfg.orbList
  
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
    GameTooltip:AddLine(" ")
    GameTooltip:AddDoubleLine("DisplayID", self.id, 1, 1, 1, 1, 1, 1)
    GameTooltip:AddDoubleLine("SetCamDistanceScale", self.scaleLevel, 1, 1, 1, 1, 1, 1)
    GameTooltip:AddDoubleLine("SetPortraitZoom", self.zoomLevel, 1, 1, 1, 1, 1, 1)    
    GameTooltip:AddDoubleLine("SetPosition", "(0,"..self.posX..","..self.posY..")", 1, 1, 1, 1, 1, 1)
    GameTooltip:AddDoubleLine("SetRotation", self.rotation, 1, 1, 1, 1, 1, 1)
    GameTooltip:AddDoubleLine("GetModel", self:GetModel(), 1, 1, 1, 1, 1, 1)
    GameTooltip:AddLine(" ")
    if not theatre then
      GameTooltip:AddLine("Click on the model to open the theatre view!")
    end
    GameTooltip:AddLine("Hold SHIFT and click LEFT mousebutton to reset all model values")
    GameTooltip:AddLine("Hold ALT and click model with left mousebutton to turn it LEFT")
    GameTooltip:AddLine("Click model with LEFT mousebutton to go to next orb color")
    GameTooltip:AddLine("Use MouseWheel to change SetCamDistanceScale")
    GameTooltip:AddLine("Hold ALT+SHIFT and use MouseWheel to change SetPortraitZoom")
    GameTooltip:AddLine("Hold ALT and use MouseWheel to move model in y-Axis")
    GameTooltip:AddLine("Hold SHIFT and use MouseWheel to move model in x-Axis")
    GameTooltip:AddLine("Use RIGHT MouseButton to drag the model around")
    GameTooltip:AddLine("Use ALT + RIGHT MouseButton change the size of the orb")
    if theatre then
      GameTooltip:AddLine(" ")
      GameTooltip:AddLine("Click on the black area to get back!", 1, 0, 1, 1, 1, 1)
    end
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

  end
  
  local function rIMV_changeModel(self)  
    local index = self.index+1
    local m = self.m
    local filling = self.fill
    local listentry = list[index] or list[1]
    if list[index] then
      self.index = index
    else
      self.index = 1
    end    
    filling:SetVertexColor(listentry.color.r,listentry.color.g,listentry.color.b)    
    --m:ClearModel()
    m:SetModel("interface\\buttons\\talktomequestionmark.m2") --in case setdisplayinfo fails 
    m:SetDisplayInfo(listentry.displayid)
    m.id = listentry.displayid
    rIMV_setModelValues(m)  
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
    fill:SetTexture("Interface\\AddOns\\DiscoKugel\\media\\orb_filling")
    fill:SetVertexColor(listentry.color.r,listentry.color.g,listentry.color.b)
    
    f.fill = fill
    
    local m = CreateFrame("PlayerModel", nil,f)
    m:SetAllPoints(f)
    m:SetModel("interface\\buttons\\talktomequestionmark.m2") --in case setdisplayinfo fails 
    m:SetDisplayInfo(listentry.displayid)
    m.id = listentry.displayid
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
      else
        s:StartMoving()
      end 
    end)
    f:SetScript("OnDragStop", function(s) 
      s:SetHeight(s:GetWidth())
      s:StopMovingOrSizing() 
    end)
    f:SetScript("OnMouseDown", function(s,bu,...)
      if bu == "LeftButton" then
        if IsShiftKeyDown() then
          rIMV_setModelValues(s.m)
        elseif IsAltKeyDown() then
          rIMV_rotateModel(s.m,bu)
        else
          rIMV_changeModel(s)
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
    

    
    listentry.orb = f
  
  end

  
  
  -----------------------------
  -- CALL
  ----------------------------- 

  if list[1] then
    createOrb(list[1],1)
  end

  
