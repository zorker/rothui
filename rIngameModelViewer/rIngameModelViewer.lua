  
  -- rIngameModelViewer 0.1
  -- zork 2010


  -----------------------------
  -- ALL SETTINGS ARE NOW AVAILABLE IN GAME, DO NOT TOUCH ANYTHING HERE
  -----------------------------
  
  local cfg = {
    size = 100,
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

  local a = CreateFrame("Frame")
 
  a:RegisterEvent("PLAYER_LOGIN")
  
  a:SetScript("OnEvent", function (s,e,...)
    if(e=="PLAYER_LOGIN") then
      a:init()
    end 
  end)
  
  local models = {}


  -----------------------------
  -- FUNCTIONS
  -----------------------------

  local function floorNumber(n)
    return floor((n)*10)/10
  end
   
  local function changeModelZoom(self, delta)
    local maxzoom = 1
    local minzoom = -0.5
    self.zoomLevel = self.zoomLevel + delta*0.15
    if (self.zoomLevel > maxzoom) then
        self.zoomLevel = maxzoom
    end
    if (minzoom > self.zoomLevel) then
        self.zoomLevel = minzoom
    end
    self.zoomLeve = floorNumber(self.zoomLevel)
    self:SetPortraitZoom(self.zoomLevel)
  end
    
  local function changeModelDistanceScale(self, delta)
    local maxscale = 10
    local minscale = 0.1
    self.scaleLevel = self.scaleLevel + delta*0.15
    if (self.scaleLevel > maxscale) then
        self.scaleLevel = maxscale
    end
    if (minscale > self.scaleLevel) then
        self.scaleLevel = minscale
    end
    self.scaleLevel = floorNumber(self.scaleLevel)
    self:SetCamDistanceScale(self.scaleLevel)
  end
  
  local function moveModelLeftRight(self, delta)
    local max = 5
    local min = -5
    self.posX = self.posX + delta*0.15
    if (self.posX > max) then
        self.posX = max
    end
    if (min > self.posX) then
        self.posX = min
    end
    self.posX = floorNumber(self.posX)
    self:SetPosition(0,self.posX,self.posY)
  end
  
  local function moveModelTopBottom(self, delta)
    local max = 5
    local min = -5
    self.posY = self.posY + delta*0.15
    if (self.posY > max) then
        self.posY = max
    end
    if (min > self.posY) then
        self.posY = min
    end
    self.posY = floorNumber(self.posY)
    self:SetPosition(0,self.posX,self.posY)
  end
  
  local function rotateModel(self,button)
    local rotationIncrement = 0.2
    if button == "LeftButton" then
      self.rotation = self.rotation - rotationIncrement
    else
      self.rotation = self.rotation + rotationIncrement
    end
    self.rotation = floorNumber(self.rotation)
    self:SetRotation(self.rotation)
  end
  
  local function resetModel(self)
  
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
  
  --tooltip function from Lyn
  local function showModelTooltip(self)
    GameTooltip:SetOwner(self, "ANCHOR_CURSOR")
    --GameTooltip:SetPoint("BOTTOMRIGHT", WorldFrame, "BOTTOMRIGHT", -90, 90)
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
    
  local function showIconTooltip(self)
    GameTooltip:SetOwner(self, "ANCHOR_CURSOR")
    --GameTooltip:SetPoint("BOTTOMRIGHT", WorldFrame, "BOTTOMRIGHT", -90, 90)
    GameTooltip:AddLine("rIngameModelViewer", 0, 1, 0.5, 1, 1, 1)
    GameTooltip:AddLine(" ")
    GameTooltip:AddLine("Click the icon to open the model viewer.", 1, 1, 1, 1, 1, 1)
    GameTooltip:AddLine("Hold ALT and any mousebutton to move the icon.", 1, 1, 1, 1, 1, 1)
    GameTooltip:AddLine(" ")
    GameTooltip:Show()
  end
    
  local createModel = function(b,id,row,col)
    local m = CreateFrame("PlayerModel", nil,b)
    m:SetSize(cfg.size,cfg.size)
    m:SetPoint("TOPLEFT",cfg.size*row,cfg.size*col*(-1))
    --m:SetFacing(math.pi) --math.pi = 180° 
    m:SetModel("Interface\\Buttons\\talktomequestionmark.mdx") --in case setdisplayinfo fails 
    --m:SetCreature(id)
    m:SetDisplayInfo(id)
    m.id = id
    m.scaleLevel = 1
    m.zoomLevel = 0
    m.posX = 0
    m.posY = 0
    m.rotation = 0
    
    m:EnableMouse(true)
    m:SetScript("OnMouseDown", function(s,b,...)
      if IsShiftKeyDown() then
        resetModel(s)
      else
        rotateModel(s,b)
      end
    end)
    
    m:SetScript("OnMouseWheel", function(s,d,...)
      if IsShiftKeyDown() and IsAltKeyDown() then
        changeModelZoom(s,d)        
      elseif IsAltKeyDown() then
        moveModelTopBottom(s,d)
      elseif IsShiftKeyDown() then
        moveModelLeftRight(s,d)
      else
        changeModelDistanceScale(s,d)
      end
    end)

    m:SetScript("OnEnter", function() showModelTooltip(m) end)
    m:SetScript("OnLeave", function() GameTooltip:Hide() end)

    local d = m:CreateTexture(nil, "BACKGROUND",nil,-8)
    d:SetTexture(0,0,0,0.2)
    d:SetAllPoints(m)

    local t = m:CreateTexture(nil, "BACKGROUND",nil,-7)
    t:SetTexture(1,1,1,0.5)
    t:SetPoint("TOPLEFT", m, "TOPLEFT", 2, -2)
    t:SetPoint("BOTTOMRIGHT", m, "BOTTOMRIGHT", -2, 2)
    m.t = t

    local p = m:CreateFontString(nil, "BACKGROUND")
    local fs = cfg.size*10/100
    if fs < 8 then 
      fs = 8
    end    
    p:SetFont("Fonts\\FRIZQT__.ttf", fs, "THINOUTLINE")
    p:SetPoint("TOP", 0, -2)
    p:SetText(id)
    p:SetAlpha(.5)
    m.p = p
    
    return m

  end  
  
  local function changeModelViewerPage(pageid)
    local cfg = cfg
    cfg.page = pageid
    local models = models
    local modelid = 1 + ((pageid-1)*cfg.num) 
    local id = 1
    
    for i=1, cfg.rows do
      for k=1, cfg.cols do
        resetModel(models[id])
        models[id]:SetModel("Interface\\Buttons\\talktomequestionmark.mdx") --in case setdisplayinfo fails 
        --models[id]:SetCreature(modelid)
        models[id]:SetDisplayInfo(modelid)
        models[id].id = modelid
        models[id].p:SetText(modelid)
        modelid = modelid+1
        id=id+1
      end    
    end
  
  end
  
  local function createAllModels(b)
    --remove old models
    local id
    
    id = 1
    
    for i=1, cfg.rows do
      for k=1, cfg.cols do
        if models[id] then
          models[id]:ClearAllPoints()
          models[id]:Hide()
          models[id] = nil
          id=id+1  
        end
      end    
    end
    
    models = {}

    local w = floor(b:GetWidth())
    local h = floor(b:GetHeight())-70 --remove 70px for the bottom bar
    cfg.rows = floor(h/cfg.size)
    cfg.cols = floor(w/cfg.size)
    cfg.num = cfg.rows*cfg.cols
    
    local modelid = 1 + ((cfg.page-1)*cfg.num)    
    id = 1
    
    for i=1, cfg.rows do
      for k=1, cfg.cols do
        models[id] = createModel(b,modelid,k-1,i-1)
        --print(models[id].id)
        modelid = modelid+1
        id=id+1        
      end    
    end
  
  end
  
  local createArrows = function(b)
    
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
        changeModelViewerPage(n)
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
        changeModelViewerPage(cfg.page-1)
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
      changeModelViewerPage(cfg.page+1)
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
      if cfg.size > 500 then
        cfg.size = 500
      else
        createAllModels(b)
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
        createAllModels(b)
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
  

  local function createHolderFrame()
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
  
  local function createTheIcon(b)
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
      end
    end)
  
    i:SetScript("OnEnter", function() showIconTooltip(i) end)
    i:SetScript("OnLeave", function() GameTooltip:Hide() end)
  
  end
  

  function a:init()
    
    local b = createHolderFrame()
    createTheIcon(b)
    createArrows(b)
    createAllModels(b)    
    b:Hide()
    
  end