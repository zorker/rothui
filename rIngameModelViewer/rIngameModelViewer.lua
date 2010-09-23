  
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
  local function rIMV_showModelTooltip(self)
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
    GameTooltip:AddLine("Hold SHIFT and click any mousebutton to reset all model values")
    GameTooltip:AddLine("Click Model with left mousebutton to turn it LEFT")
    GameTooltip:AddLine("Click Model with right mousebutton to turn it RIGHT")
    GameTooltip:AddLine("Use MouseWheel to change SetCamDistanceScale")
    GameTooltip:AddLine("Hold ALT+SHIFT and use MouseWheel to change SetPortraitZoom")
    GameTooltip:AddLine("Hold ALT and use MouseWheel to move model in y-Axis")
    GameTooltip:AddLine("Hold SHIFT and use MouseWheel to move model in x-Axis")
    GameTooltip:Show()
  end
    
  --tooltip for icon func
  local function rIMV_showIconTooltip(self)
    GameTooltip:SetOwner(self, "ANCHOR_CURSOR")
    --GameTooltip:SetPoint("BOTTOMRIGHT", UIParent, "BOTTOMRIGHT", -90, 90)
    GameTooltip:AddLine("rIngameModelViewer", 0, 1, 0.5, 1, 1, 1)
    GameTooltip:AddLine(" ")
    GameTooltip:AddLine("Click the icon to open the model viewer.", 1, 1, 1, 1, 1, 1)
    GameTooltip:AddLine("Hold ALT and any mousebutton to move the icon.", 1, 1, 1, 1, 1, 1)
    GameTooltip:AddLine(" ")
    GameTooltip:Show()
  end
    
  --set some default values to work with
  local function rIMV_rIMV_setModelValues(self)
  
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
    --m:rIMV_setModel("Interface\\Buttons\\talktomequestionmark.mdx") --in case setdisplayinfo fails 
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
    m:SetScript("OnMouseDown", function(s,b,...)
      if IsShiftKeyDown() then
        rIMV_rIMV_setModelValues(s)
      else
        rIMV_rotateModel(s,b)
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
        rIMV_rIMV_setModelValues(models[id])
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
          print("[IMV DEBUG] Creating model: "..id) --debugging, only new numbers should be printed
        end
        rIMV_adjustModelPosition(models[id],k-1,i-1)
        rIMV_rIMV_setModelValues(models[id])
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
    e:SetSize(200,30)
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
    l1:SetSize(150,30)
    l1:SetPoint("RIGHT",e,"LEFT",-15,0)

    t = l1:CreateTexture(nil, "BACKGROUND",nil,-8)
    t:SetTexture(0.2,0.2,0.2,0.5)
    t:SetAllPoints(l1)
    l1.t = t

    p = l1:CreateFontString(nil, "BACKGROUND")
    p:SetFont("Fonts\\FRIZQT__.ttf", 14, "THINOUTLINE")
    p:SetPoint("CENTER", 0, 0)
    p:SetText("PREVIOUS PAGE")
    
    l1:EnableMouse(true)
    l1:SetScript("OnMouseDown", function(...)
      if cfg.page-1 >= 1 then
        e:SetText(cfg.page-1)
        rIMV_changeModelViewerPage(cfg.page-1)
      end
    end)

    --next page button
    l2 = CreateFrame("FRAME", nil,b)
    l2:SetSize(150,30)
    l2:SetPoint("LEFT",e,"RIGHT",15,0)

    t = l2:CreateTexture(nil, "BACKGROUND",nil,-8)
    t:SetTexture(0.2,0.2,0.2,0.5)
    t:SetAllPoints(l2)
    l2.t = t

    p = l2:CreateFontString(nil, "BACKGROUND")
    p:SetFont("Fonts\\FRIZQT__.ttf", 14, "THINOUTLINE")
    p:SetPoint("CENTER", 0, 0)
    p:SetText("NEXT PAGE")
    
    l2:EnableMouse(true)
    l2:SetScript("OnMouseDown", function(...)
      e:SetText(cfg.page+1)
      rIMV_changeModelViewerPage(cfg.page+1)
    end)
    
    --close button
    l3 = CreateFrame("FRAME", nil,b)
    l3:SetSize(100,30)
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
      b:Hide()
    end)
    
    --size + button
    l4 = CreateFrame("FRAME", nil,b)
    l4:SetSize(100,30)
    l4:SetPoint("LEFT",l2,"RIGHT",15,0)

    t = l4:CreateTexture(nil, "BACKGROUND",nil,-8)
    t:SetTexture(0.2,0.2,0.2,0.5)
    t:SetAllPoints(l4)
    l4.t = t

    p = l4:CreateFontString(nil, "BACKGROUND")
    p:SetFont("Fonts\\FRIZQT__.ttf", 14, "THINOUTLINE")
    p:SetPoint("CENTER", 0, 0)
    p:SetText("SIZE [+]")
    
    l4:EnableMouse(true)
    l4:SetScript("OnMouseDown", function()
      cfg.size = cfg.size+20
      if cfg.size > 600 then
        cfg.size = 600
      else
        rIMV_createAllModels(b)
      end
    end)

    --size - button
    l5 = CreateFrame("FRAME", nil,b)
    l5:SetSize(100,30)
    l5:SetPoint("RIGHT",l1,"LEFT",-15,0)

    t = l5:CreateTexture(nil, "BACKGROUND",nil,-8)
    t:SetTexture(0.2,0.2,0.2,0.5)
    t:SetAllPoints(l5)
    l5.t = t

    p = l5:CreateFontString(nil, "BACKGROUND")
    p:SetFont("Fonts\\FRIZQT__.ttf", 14, "THINOUTLINE")
    p:SetPoint("CENTER", 0, 0)
    p:SetText("SIZE [-]")
    
    l5:EnableMouse(true)
    l5:SetScript("OnMouseDown", function()
      cfg.size = cfg.size-20
      if cfg.size < 60 then
        cfg.size = 60
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
    
    b:EnableMouse(true)
    
    return b
    
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
    rIMV_createIcon(b)
    rIMV_createMenu(b)
    b:Hide()    
  end
  
  --PLAYER_LOGIN EVENT HOOK  
  local a = CreateFrame("Frame")
  
  a:SetScript("OnEvent", function (s,e,...)
    if(e=="PLAYER_LOGIN") then
      rIMV_init()
    end 
  end)
  
  a:RegisterEvent("PLAYER_LOGIN")