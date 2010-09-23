  
  -- rIngameModelViewer
  -- zork 2010

  ---------------------------------------------------------------------
  -- DO NOT TOUCH ANYTHING HERE
  ---------------------------------------------------------------------
  
  local cfg = {
    size = 200,
    page = 1,
    num = 0,
    rows = 0,
    cols = 0,
    backdrop = { 
      bgFile = "", 
      edgeFile = "Interface\\Tooltips\\UI-Tooltip-Border",
      tile = false,
      tileSize = 0, 
      edgeSize = 16, 
      insets = { 
        left = 0, 
        right = 0, 
        top = 0, 
        bottom = 0,
      },
    },
  }
  
  local models = {}

  -----------------------------
  -- FUNCTIONS
  -----------------------------

  --round some stuff
  local function rIMV_roundNumber(n)
    return floor((n)*10)/10
  end
  
  local calcPageForDisplayID(displayid)
    local n = math.ceil(displayid/cfg.num)  
    return n
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
    local max = 5
    local min = -5
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
    local max = 5
    local min = -5
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
  local function rIMV_showModelTooltip(self,theater)
    GameTooltip:SetOwner(self, "ANCHOR_CURSOR")
    --GameTooltip:SetPoint("BOTTOMRIGHT", UIParent, "BOTTOMRIGHT", -90, 90)
    GameTooltip:AddLine("rIngameModelViewer", 0, 1, 0.5, 1, 1, 1)
    GameTooltip:AddLine(" ")
    GameTooltip:AddDoubleLine("DisplayID", self.id, 1, 1, 1, 1, 1, 1)
    GameTooltip:AddDoubleLine("SetCamDistanceScale", self.scaleLevel, 1, 1, 1, 1, 1, 1)
    GameTooltip:AddDoubleLine("SetPortraitZoom", self.zoomLevel, 1, 1, 1, 1, 1, 1)    
    GameTooltip:AddDoubleLine("SetPosition", "(0,"..self.posX..","..self.posY..")", 1, 1, 1, 1, 1, 1)
    GameTooltip:AddDoubleLine("SetRotation", self.rotation, 1, 1, 1, 1, 1, 1)
    GameTooltip:AddLine(" ")
    if not theater then
      GameTooltip:AddLine("Click on the model to open the theater view!")
    end
    GameTooltip:AddLine("Hold SHIFT and click any mousebutton to reset all model values")
    GameTooltip:AddLine("Hold ALT and click model with left mousebutton to turn it LEFT")
    GameTooltip:AddLine("Hold ALT and click model with right mousebutton to turn it RIGHT")
    GameTooltip:AddLine("Use MouseWheel to change SetCamDistanceScale")
    GameTooltip:AddLine("Hold ALT+SHIFT and use MouseWheel to change SetPortraitZoom")
    GameTooltip:AddLine("Hold ALT and use MouseWheel to move model in y-Axis")
    GameTooltip:AddLine("Hold SHIFT and use MouseWheel to move model in x-Axis")
    if theater then
      GameTooltip:AddLine(" ")
      GameTooltip:AddLine("Click on the black area to get back!", 1, 0, 1, 1, 1, 1)
    end
    GameTooltip:Show()
  end
    
  --tooltip for icon func
  local function rIMV_showIconTooltip(self)
    GameTooltip:SetOwner(self, "ANCHOR_CURSOR")
    --GameTooltip:SetPoint("BOTTOMRIGHT", UIParent, "BOTTOMRIGHT", -90, 90)
    GameTooltip:AddLine("rIngameModelViewer", 0, 1, 0.5, 1, 1, 1)
    GameTooltip:AddLine("Click the icon to open the model viewer.", 1, 1, 1, 1, 1, 1)
    GameTooltip:AddLine("Hold ALT and any mousebutton to move the icon.", 1, 1, 1, 1, 1, 1)
    GameTooltip:Show()
  end
    
  --tooltip for icon func
  local function rIMV_showTheaterTooltip(self)
    GameTooltip:SetOwner(self, "ANCHOR_CURSOR")
    --GameTooltip:SetPoint("BOTTOMRIGHT", UIParent, "BOTTOMRIGHT", -90, 90)
    GameTooltip:AddLine("rIngameModelViewer", 0, 1, 0.5, 1, 1, 1)
    GameTooltip:AddLine("Click here to close the theater view!")
    GameTooltip:Show()
  end
    
  --set some default values to work with
  local function rIMV_setModelValues(self)
  
    self.scaleLevel = 1
    self.zoomLevel = 0
    self.posX = 0
    self.posY = 0
    self.rotation = 0
    
    self:SetPortraitZoom(self.zoomLevel)
    self:SetCamDistanceScale(self.scaleLevel)
    self:SetPosition(0,self.posX,self.posY)
    self:SetRotation(self.rotation)

  end
  
  --bring the model to life and set the displayID
  local function rIMV_setModel(self,id)
  
    self:ClearModel()
    --m:SetModel("Interface\\Buttons\\talktomequestionmark.mdx") --in case setdisplayinfo fails 
    self:SetDisplayInfo(id)
    self.id = id
    self.p:SetText(id)

  end
    
  --move model into position func and adjust some values based on model size
  local function rIMV_adjustModelPosition(self,row,col)
    self:SetSize(cfg.size,cfg.size)
    self:SetPoint("TOPLEFT",cfg.size*row,cfg.size*col*(-1))
    local fs = cfg.size*10/100
    if fs < 8 then 
      fs = 8
    end    
    self.p:SetFont("Fonts\\FRIZQT__.ttf", fs, "THINOUTLINE")    
    self:Show()
  end
  
  --create a new model func
  local function rIMV_createModel(b,id)
    local m = CreateFrame("PlayerModel", nil,b)
   
    m:EnableMouse(true)
    m:SetScript("OnMouseDown", function(s,bu,...)
      if IsShiftKeyDown() then
        rIMV_setModelValues(s)
      elseif IsAltKeyDown() then
        rIMV_rotateModel(s,bu)
      else
        b.theater:Show()
        b.theater:EnableMouse(true)
        b.theater.m:ClearModel()
        b.theater.m:SetDisplayInfo(s.id)
        b.theater.m.id = s.id
        b.theater.m.p:SetText(s.id)
        rIMV_setModelValues(b.theater.m)
        
        b.theater.ag1:Play()
      end
    end)
    
    m:SetScript("OnMouseWheel", function(s,d,...)
      if IsShiftKeyDown() and IsAltKeyDown() then
        rIMV_changeModelPortraitZoom(s,d)        
      elseif IsAltKeyDown() then
        rIMV_moveModelTopBottom(s,d)
      elseif IsShiftKeyDown() then
        rIMV_moveModelLeftRight(s,d)
      else
        rIMV_changeModelDistanceScale(s,d)
      end
    end)

    m:SetScript("OnEnter", function(s) rIMV_showModelTooltip(s) end)
    m:SetScript("OnLeave", function(s) GameTooltip:Hide() end)

    local d = m:CreateTexture(nil, "BACKGROUND",nil,-8)
    d:SetTexture(0,0,0,0.2)
    d:SetAllPoints(m)
    m.d = d

    local t = m:CreateTexture(nil, "BACKGROUND",nil,-7)
    t:SetTexture(1,1,1,0.5)
    t:SetPoint("TOPLEFT", m, "TOPLEFT", 2, -2)
    t:SetPoint("BOTTOMRIGHT", m, "BOTTOMRIGHT", -2, 2)
    m.t = t

    local p = m:CreateFontString(nil, "BACKGROUND")
    p:SetPoint("TOP", 0, -2)
    p:SetAlpha(.5)
    m.p = p
    
    return m

  end
  
  --change models on page swap
  local function rIMV_changeModelViewerPage(pageid)    
    cfg.page = pageid    
    local displayid = 1 + ((cfg.page-1)*cfg.num) 
    local id = 1    
    for i=1, cfg.num do
      if models[id] then
        rIMV_setModelValues(models[id])
        rIMV_setModel(models[id],displayid)
      end
      displayid = displayid+1
      id=id+1
    end  
  end
  
  --hide all the models
  local function rIMV_hideAllModels()
    local id = 1
    --hide all models first until we are sure which models need to be shown at all
    for i=1, cfg.num do
      if models[id] and models[id]:IsShown() then
        models[id]:ClearAllPoints()
        models[id]:Hide()
      end
      id=id+1
    end
  end
  
  --create all the models
  local function rIMV_createAllModels(b)
    
    --cleanup first, make sure all models get hidden first
    rIMV_hideAllModels()
    
    --calc the new page values
    local w = floor(b:GetWidth())
    local h = floor(b:GetHeight())-70 --remove 70px for the bottom bar
    cfg.rows = floor(h/cfg.size)
    cfg.cols = floor(w/cfg.size)
    cfg.num = cfg.rows*cfg.cols
    
    local displayid = 1 + ((cfg.page-1)*cfg.num)    
    local id = 1
    
    for i=1, cfg.rows do
      for k=1, cfg.cols do
        --if the model does not exist yet create it, otherwise reset it
        if not models[id] then
          --make sure rIMV_createModel is only used when needed
          models[id] = rIMV_createModel(b,displayid)
          --print("[IMV DEBUG] Creating model: "..id) --debugging, only new numbers should be printed
        end
        rIMV_adjustModelPosition(models[id],k-1,i-1)
        rIMV_setModelValues(models[id])
        rIMV_setModel(models[id],displayid)
        displayid = displayid+1
        id=id+1
      end    
    end
  
  end
  
  --create menu buttons func
  local function rIMV_createMenu(b)
    
    local l1,l2,l3,l4,l5,t,p,e,d

    p = b:CreateFontString(nil, "BACKGROUND")
    p:SetFont("Fonts\\FRIZQT__.ttf", 20, "THINOUTLINE")
    p:SetPoint("BOTTOMLEFT", 10, 15)
    p:SetText("rIngameModelViewer 1.1")
    p:SetTextColor(0,1,0.5)

    --editbox
    e = CreateFrame("EditBox", nil,b)
    e:SetSize(80,30)
    e:SetPoint("BOTTOM",0,10)

    d = e:CreateTexture(nil, "BACKGROUND",nil,-8)
    d:SetTexture(0,0,0,0.2)
    d:SetAllPoints(e)

    t = e:CreateTexture(nil, "BACKGROUND",nil,-7)
    t:SetTexture(1,1,1,0.5)
    t:SetPoint("TOPLEFT", e, "TOPLEFT", 2, -2)
    t:SetPoint("BOTTOMRIGHT", e, "BOTTOMRIGHT", -2, 2)

    e:SetFont("Fonts\\FRIZQT__.ttf", 14, "THINOUTLINE")
    e:SetText(cfg.page)
    e:SetJustifyH("CENTER")
    
    p = e:CreateFontString(nil, "BACKGROUND")
    p:SetFont("Fonts\\FRIZQT__.ttf", 14, "THINOUTLINE")
    p:SetPoint("BOTTOM", e, "TOP", 0, 10)
    p:SetText("PAGE")
    
    --e:EnableMouse(true)
    e:SetScript("OnEnterPressed", function(s,v,...)
      local n = floor(s:GetNumber())
      if n < 1 then
        n = 1
      end
      s:SetText(n)
      if n ~= cfg.page then
        rIMV_changeModelViewerPage(n)
      end
    end)    

    --prev page button
    l1 = CreateFrame("FRAME", nil,b)
    l1:SetSize(80,30)
    l1:SetPoint("RIGHT",e,"LEFT",-15,0)

    t = l1:CreateTexture(nil, "BACKGROUND",nil,-8)
    t:SetTexture(0.2,0.2,0.2,0.5)
    t:SetAllPoints(l1)
    l1.t = t

    p = l1:CreateFontString(nil, "BACKGROUND")
    p:SetFont("Fonts\\FRIZQT__.ttf", 14, "THINOUTLINE")
    p:SetPoint("CENTER", 0, 0)
    p:SetText("< PAGE")
    
    l1:EnableMouse(true)
    l1:SetScript("OnMouseDown", function(...)
      if cfg.page-1 >= 1 then
        e:SetText(cfg.page-1)
        rIMV_changeModelViewerPage(cfg.page-1)
      end
    end)

    --next page button
    l2 = CreateFrame("FRAME", nil,b)
    l2:SetSize(80,30)
    l2:SetPoint("LEFT",e,"RIGHT",15,0)

    t = l2:CreateTexture(nil, "BACKGROUND",nil,-8)
    t:SetTexture(0.2,0.2,0.2,0.5)
    t:SetAllPoints(l2)
    l2.t = t

    p = l2:CreateFontString(nil, "BACKGROUND")
    p:SetFont("Fonts\\FRIZQT__.ttf", 14, "THINOUTLINE")
    p:SetPoint("CENTER", 0, 0)
    p:SetText("PAGE >")
    
    l2:EnableMouse(true)
    l2:SetScript("OnMouseDown", function(...)
      e:SetText(cfg.page+1)
      rIMV_changeModelViewerPage(cfg.page+1)
    end)
    
    --close button
    l3 = CreateFrame("FRAME", nil,b)
    l3:SetSize(80,30)
    l3:SetPoint("BOTTOMRIGHT",-10,10)

    t = l3:CreateTexture(nil, "BACKGROUND",nil,-8)
    t:SetTexture(0.2,0.2,0.2,0.5)
    t:SetAllPoints(l3)
    l3.t = t

    p = l3:CreateFontString(nil, "BACKGROUND")
    p:SetFont("Fonts\\FRIZQT__.ttf", 14, "THINOUTLINE")
    p:SetPoint("CENTER", 0, 0)
    p:SetText("CLOSE")
    
    l3:EnableMouse(true)
    l3:SetScript("OnMouseDown", function()
      b.ag2:Play()
    end)
    
    --size + button
    l4 = CreateFrame("FRAME", nil,b)
    l4:SetSize(80,30)
    l4:SetPoint("LEFT",l2,"RIGHT",15,0)

    t = l4:CreateTexture(nil, "BACKGROUND",nil,-8)
    t:SetTexture(0.2,0.2,0.2,0.5)
    t:SetAllPoints(l4)
    l4.t = t

    p = l4:CreateFontString(nil, "BACKGROUND")
    p:SetFont("Fonts\\FRIZQT__.ttf", 14, "THINOUTLINE")
    p:SetPoint("CENTER", 0, 0)
    p:SetText("SIZE ++")
    
    l4:EnableMouse(true)
    l4:SetScript("OnMouseDown", function()
      cfg.size = cfg.size+20
      if cfg.size > 300 then
        cfg.size = 300
      else
        rIMV_createAllModels(b)
      end
    end)

    --size - button
    l5 = CreateFrame("FRAME", nil,b)
    l5:SetSize(80,30)
    l5:SetPoint("RIGHT",l1,"LEFT",-15,0)

    t = l5:CreateTexture(nil, "BACKGROUND",nil,-8)
    t:SetTexture(0.2,0.2,0.2,0.5)
    t:SetAllPoints(l5)
    l5.t = t

    p = l5:CreateFontString(nil, "BACKGROUND")
    p:SetFont("Fonts\\FRIZQT__.ttf", 14, "THINOUTLINE")
    p:SetPoint("CENTER", 0, 0)
    p:SetText("SIZE --")
    
    l5:EnableMouse(true)
    l5:SetScript("OnMouseDown", function()
      cfg.size = cfg.size-20
      if cfg.size < 100 then
        cfg.size = 100
      else
        rIMV_createAllModels(b)
      end
    end)
    
    l1:SetScript("OnEnter", function(s)
      s.t:SetTexture(0.2,0.2,0.2,0.8)
    end)
    l1:SetScript("OnLeave", function(s)
      s.t:SetTexture(0.2,0.2,0.2,0.5)
    end)

    l2:SetScript("OnEnter", function(s)
      s.t:SetTexture(0.2,0.2,0.2,0.8)
    end)
    l2:SetScript("OnLeave", function(s)
      s.t:SetTexture(0.2,0.2,0.2,0.5)
    end)

    l3:SetScript("OnEnter", function(s)
      s.t:SetTexture(0.2,0.2,0.2,0.8)
    end)
    l3:SetScript("OnLeave", function(s)
      s.t:SetTexture(0.2,0.2,0.2,0.5)
    end)
    
    l4:SetScript("OnEnter", function(s)
      s.t:SetTexture(0.2,0.2,0.2,0.8)
    end)
    l4:SetScript("OnLeave", function(s)
      s.t:SetTexture(0.2,0.2,0.2,0.5)
    end)
    
    l5:SetScript("OnEnter", function(s)
      s.t:SetTexture(0.2,0.2,0.2,0.8)
    end)
    l5:SetScript("OnLeave", function(s)
      s.t:SetTexture(0.2,0.2,0.2,0.5)
    end)

  
  end
  
  --create fullscreen background frame func
  local function rIMV_createHolderFrame()
    local b = CreateFrame("Frame","rIMV_HolderFrame",UIParent)
    b:SetFrameStrata("FULLSCREEN")
    b:SetAllPoints(UIParent)
    --b:SetPoint("CENTER",0,0)
    --b:SetSize(500,400)
    --b:SetBackdrop(cfg.backdrop)
    --b:SetBackdropBorderColor(0.4,0.3,0.3,1)
  
    local t = b:CreateTexture(nil, "BACKGROUND",nil,-8)
    --t:SetTexture(1,0.95,0.65,1)
    t:SetAllPoints(b)
    t:SetTexture("Interface\\AddOns\\rIngameModelViewer\\leinwand",true,true)
    t:SetVertTile(true)
    t:SetHorizTile(true)
    b.t = t
    
    b:EnableMouse(false)
    b:SetAlpha(0)    
    
    local ag1, ag2, a1, a2
    
    --fade in anim
    ag1 = b:CreateAnimationGroup()
    a1 = ag1:CreateAnimation("Alpha")
    a1:SetDuration(0.8)
    a1:SetSmoothing("IN")  
    a1:SetChange(1)
    b.ag1 = ag1
    b.ag1.a1 = a1
    
    --fade out anim
    ag2 = b:CreateAnimationGroup()
    a2 = ag2:CreateAnimation("Alpha")
    a2:SetDuration(0.8)
    a2:SetSmoothing("OUT")  
    a2:SetChange(-1)
    b.ag2 = ag2
    b.ag2.a2 = a2
    
    b.ag1:SetScript("OnFinished", function(ag)
      b:SetAlpha(1)
    end)
    
    b.ag2:SetScript("OnFinished", function(ag)
      b:SetAlpha(0)
      b:EnableMouse(false)
      b:Hide()
    end)
    
    --b:SetScript("OnMouseDown", function(s,bu,...)
      --s.ag2:Play()
    --end)
    
    return b
    
  end
  
  --create layer that persists above the models for a special view
  local function rIMV_createTheaterFrame(f)
    local b = CreateFrame("Frame","rIMV_TheaterFrame",f)
    b:SetFrameStrata("FULLSCREEN_DIALOG")
    b:SetAllPoints(f)
    --b:SetPoint("CENTER",0,0)
    --b:SetSize(500,400)
    --b:SetBackdrop(cfg.backdrop)
    --b:SetBackdropBorderColor(0.4,0.3,0.3,1)
  
    local t = b:CreateTexture(nil, "BACKGROUND",nil,-8)
    t:SetTexture(0,0,0,0.9)
    t:SetAllPoints(b)
    t:SetVertTile(true)
    t:SetHorizTile(true)
    b.t = t
    b:EnableMouse(false)
    b:SetAlpha(0)
    
    local ag1, ag2, a1, a2
    
    --fade in anim
    ag1 = b:CreateAnimationGroup()
    a1 = ag1:CreateAnimation("Alpha")
    a1:SetDuration(1)
    a1:SetSmoothing("OUT")  
    a1:SetChange(1)
    b.ag1 = ag1
    b.ag1.a1 = a1
    
    --fade out anim
    ag2 = b:CreateAnimationGroup()
    a2 = ag2:CreateAnimation("Alpha")
    a2:SetDuration(1)
    a2:SetSmoothing("IN")  
    a2:SetChange(-1)
    b.ag2 = ag2
    b.ag2.a2 = a2
    
    b.ag1:SetScript("OnFinished", function(ag)
      local s = ag:GetParent()
      s:SetAlpha(1)
    end)
    
    b.ag2:SetScript("OnFinished", function(ag)
      local s = ag:GetParent()
      s:SetAlpha(0)
      s:EnableMouse(false)
      s:Hide()
    end)
    
    b:SetScript("OnMouseDown", function(s,bu,...)
      s.ag2:Play()
    end)
    
    
    local m = CreateFrame("PlayerModel", nil,b)
   
    m:EnableMouse(true)
    m:SetScript("OnMouseDown", function(s,bu,...)
      if IsShiftKeyDown() then
        rIMV_setModelValues(s)
      elseif IsAltKeyDown() then
        rIMV_rotateModel(s,bu)
      else
        rIMV_rotateModel(s,bu)
      end
    end)
    
    m:SetScript("OnMouseWheel", function(s,d,...)
      if IsShiftKeyDown() and IsAltKeyDown() then
        rIMV_changeModelPortraitZoom(s,d)        
      elseif IsAltKeyDown() then
        rIMV_moveModelTopBottom(s,d)
      elseif IsShiftKeyDown() then
        rIMV_moveModelLeftRight(s,d)
      else
        rIMV_changeModelDistanceScale(s,d)
      end
    end)

    b:SetScript("OnEnter", function(s) rIMV_showTheaterTooltip(s) end)
    b:SetScript("OnLeave", function(s) GameTooltip:Hide() end)
    
    m:SetScript("OnEnter", function(s) rIMV_showModelTooltip(s,"theater") end)
    m:SetScript("OnLeave", function(s) GameTooltip:Hide() end)

    local d = m:CreateTexture(nil, "BACKGROUND",nil,-8)
    d:SetTexture(0,0,0,0.2)
    d:SetPoint("TOPLEFT", m, "TOPLEFT", -2, 2)
    d:SetPoint("BOTTOMRIGHT", m, "BOTTOMRIGHT", 2, -2)

    m.d = d

    local t = m:CreateTexture(nil, "BACKGROUND",nil,-7)
    t:SetTexture(1,1,1,0.9)
    t:SetAllPoints(m)
    m.t = t

    local p = m:CreateFontString(nil, "BACKGROUND")
    p:SetPoint("TOP", 0, -2)
    p:SetAlpha(.5)
    m.p = p
    
    m.scaleLevel = 1
    m.zoomLevel = 0
    m.posX = 0
    m.posY = 0
    m.rotation = 0
    
    m:SetPortraitZoom(m.zoomLevel)
    m:SetCamDistanceScale(m.scaleLevel)
    m:SetPosition(0,m.posX,m.posY)
    m:SetRotation(m.rotation)

    local size = floor(b:GetHeight())-40
    m:SetSize(size,size)
    m:SetPoint("CENTER",0,0)
    m.p:SetFont("Fonts\\FRIZQT__.ttf", 30, "THINOUTLINE")    
    m:Show() 
    
    b.m = m
   
    f.theater = b
    
  end
  
  --create icon func
  local function rIMV_createIcon(b)
    local i = CreateFrame("Frame","rIMV_Icon",UIParent)
    i:SetSize(64,64)
    i:SetPoint("CENTER",0,0)
    
    local t = i:CreateTexture(nil, "BACKGROUND",nil,-8)
    t:SetTexture("Interface\\AddOns\\rIngameModelViewer\\icon")
    t:SetAllPoints(i)
    i.t = t
  
    i:SetMovable(true)
    i:SetUserPlaced(true)
    i:EnableMouse(true)
    i:RegisterForDrag("LeftButton","RightButton")
    i:SetScript("OnDragStart", function(s) if IsAltKeyDown() then s:StartMoving() end end)
    i:SetScript("OnDragStop", function(s) s:StopMovingOrSizing() end)
    i:SetScript("OnMouseDown", function()
      if not IsAltKeyDown() then

        b:Show()
        rIMV_createAllModels(b)
        b:EnableMouse(true)
        b.ag1:Play()

      end
    end)
  
    i:SetScript("OnEnter", function(s) rIMV_showIconTooltip(s) end)
    i:SetScript("OnLeave", function(s) GameTooltip:Hide() end)
  
  end
  
  -----------------------------
  -- LOADUP
  -----------------------------

  --rIMV_init func
  local function rIMV_init()
    
    local b = rIMV_createHolderFrame()
    rIMV_createTheaterFrame(b)
    rIMV_createIcon(b)
    rIMV_createMenu(b)
    b:Hide()
    b.theater:Hide()
  end
  
  --PLAYER_LOGIN EVENT HOOK  
  local a = CreateFrame("Frame")
  
  a:SetScript("OnEvent", function (s,e,...)
    if(e=="PLAYER_LOGIN") then
      rIMV_init()
    end 
  end)
  
  a:RegisterEvent("PLAYER_LOGIN")