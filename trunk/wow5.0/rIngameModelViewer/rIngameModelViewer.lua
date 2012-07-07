
  -- rIngameModelViewer
  -- zork 2011

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

  local version = "rIngameModelViewer 1.6"

  --sounds
  local snd_swap    = "INTERFACESOUND_LOSTTARGETUNIT"
  local snd_select  = "igMainMenuOption"
  local snd_close   = "igMainMenuLogout";

  local models = {}

  -----------------------------
  -- FUNCTIONS
  -----------------------------

  --round some stuff
  local function rIMV_roundNumber(n)
    return floor((n)*10)/10
  end

  local function calcPageForDisplayID(displayid)
    local n = math.ceil(displayid/cfg.num)
    return n
  end

  local function calcFirstDisplayIdOfPage()
    local n = ((cfg.page*cfg.num)+1)-cfg.num
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
    GameTooltip:AddDoubleLine("GetModel", self.model, 1, 1, 1, 1, 1, 1)
    GameTooltip:AddLine(" ")
    if not theatre then
      GameTooltip:AddLine("Click on the model to open the theatre view!")
    end
    GameTooltip:AddLine("Hold SHIFT and click any mousebutton to reset all model values")
    GameTooltip:AddLine("Hold ALT and click model with left mousebutton to turn it LEFT")
    GameTooltip:AddLine("Hold ALT and click model with right mousebutton to turn it RIGHT")
    GameTooltip:AddLine("Use MouseWheel to change SetCamDistanceScale")
    GameTooltip:AddLine("Hold ALT+SHIFT and use MouseWheel to change SetPortraitZoom")
    GameTooltip:AddLine("Hold ALT and use MouseWheel to move model in y-Axis")
    GameTooltip:AddLine("Hold SHIFT and use MouseWheel to move model in x-Axis")
    if theatre then
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

  --tooltip for theatre func
  local function rIMV_showTheatreTooltip(self)
    GameTooltip:SetOwner(self, "ANCHOR_CURSOR")
    --GameTooltip:SetPoint("BOTTOMRIGHT", UIParent, "BOTTOMRIGHT", -90, 90)
    GameTooltip:AddLine("Close Theatre View", 0, 1, 0.5, 1, 1, 1)
    GameTooltip:AddLine("Click here to close the theatre view!")
    GameTooltip:Show()
  end

  --color tooltip func
  local function rIMV_showColorTooltip(self)
    GameTooltip:SetOwner(self, "ANCHOR_CURSOR")
    --GameTooltip:SetPoint("BOTTOMRIGHT", UIParent, "BOTTOMRIGHT", -90, 90)
    GameTooltip:AddLine("Color Select", 0, 1, 0.5, 1, 1, 1)
    GameTooltip:AddLine("Cick here to change model background color to: "..self.color)
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
    local defaultmodel = "interface\\buttons\\talktomequestionmark.m2"
    self:SetModel(defaultmodel) --in case setdisplayinfo fails
    self:SetDisplayInfo(id)
    local model = self:GetModel()
    if model == defaultmodel then
      self.model = ""
      self:EnableMouse(false)
    else
      self.model = model
      self:EnableMouse(true)
    end
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
        PlaySound(snd_select)
      elseif IsAltKeyDown() then
        rIMV_rotateModel(s,bu)
        PlaySound(snd_select)
      else
        PlaySound("UChatScrollButton")
        b.theatre:Show()
        b.theatre:EnableMouse(true)
        rIMV_setModelValues(b.theatre.m)
        b.theatre.m:ClearModel()
        b.theatre.m:SetDisplayInfo(s.id)
        b.theatre.m.model = b.theatre.m:GetModel()
        b.theatre.m.id = s.id
        b.theatre.m.p:SetText(s.id)
        b.theatre.ag1:Play()
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

    local l1,l2,l3,l4,l5,t,p,e,d,e2

    p = b:CreateFontString(nil, "BACKGROUND")
    p:SetFont("Fonts\\FRIZQT__.ttf", 20, "THINOUTLINE")
    p:SetPoint("BOTTOMLEFT", 10, 15)
    p:SetText(version)
    p:SetTextColor(0,1,0.5)

    --editbox pageid
    e = CreateFrame("EditBox", nil,b)
    e:SetSize(80,30)
    e:SetPoint("BOTTOM",47.5,10)

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
      PlaySound(snd_swap)
      local n = floor(s:GetNumber())
      if n < 1 then
        n = 1
      end
      s:SetText(n)
      if n ~= cfg.page then
        rIMV_changeModelViewerPage(n)
        e2:SetText(calcFirstDisplayIdOfPage())
      end
    end)

    --editbox displayid
    e2 = CreateFrame("EditBox", nil,b)
    e2:SetSize(80,30)
    e2:SetPoint("RIGHT",e,"LEFT",-15,0)

    d = e2:CreateTexture(nil, "BACKGROUND",nil,-8)
    d:SetTexture(0,0,0,0.2)
    d:SetAllPoints(e2)

    t = e2:CreateTexture(nil, "BACKGROUND",nil,-7)
    t:SetTexture(1,1,1,0.5)
    t:SetPoint("TOPLEFT", e2, "TOPLEFT", 2, -2)
    t:SetPoint("BOTTOMRIGHT", e2, "BOTTOMRIGHT", -2, 2)

    e2:SetFont("Fonts\\FRIZQT__.ttf", 14, "THINOUTLINE")
    e2:SetText(cfg.page)
    e2:SetJustifyH("CENTER")

    p = e2:CreateFontString(nil, "BACKGROUND")
    p:SetFont("Fonts\\FRIZQT__.ttf", 14, "THINOUTLINE")
    p:SetPoint("BOTTOM", e2, "TOP", 0, 10)
    p:SetText("DISPLAYID")

    --e:EnableMouse(true)
    e2:SetScript("OnEnterPressed", function(s,v,...)
      PlaySound(snd_swap)
      local n = floor(s:GetNumber())
      if n < 1 then
        n = 1
      end
      s:SetText(n)
      local n2 = calcPageForDisplayID(n)
      if n2 ~= cfg.page then
        e:SetText(n2)
        rIMV_changeModelViewerPage(n2)
      end
    end)

    --prev page button
    l1 = CreateFrame("FRAME", nil,b)
    l1:SetSize(80,30)
    l1:SetPoint("RIGHT",e2,"LEFT",-15,0)

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
        PlaySound(snd_swap)
        e:SetText(cfg.page-1)
        rIMV_changeModelViewerPage(cfg.page-1)
        e2:SetText(calcFirstDisplayIdOfPage())
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
      PlaySound(snd_swap)
      e:SetText(cfg.page+1)
      rIMV_changeModelViewerPage(cfg.page+1)
      e2:SetText(calcFirstDisplayIdOfPage())
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
    p:SetText("</CLOSE>")

    l3:EnableMouse(true)
    l3:SetScript("OnMouseDown", function()
      b:EnableMouse(false)
      PlaySoundFile("Sound\\Creature\\BabyMurloc\\BabyMurlocB.wav")
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
      PlaySound(snd_swap)
      cfg.size = cfg.size+20
      if cfg.size > 300 then
        cfg.size = 300
      else
        rIMV_createAllModels(b)
        e2:SetText(calcFirstDisplayIdOfPage())
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
      PlaySound(snd_swap)
      cfg.size = cfg.size-20
      if cfg.size < 60 then
        cfg.size = 60
      else
        rIMV_createAllModels(b)
        e2:SetText(calcFirstDisplayIdOfPage())
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
    t:SetTexture(244/255,242/255,229/255)
    --t:SetVertTile(true)
    --t:SetHorizTile(true)
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
      b:Hide()
    end)

    --b:SetScript("OnMouseDown", function(s,bu,...)
      --s.ag2:Play()
    --end)

    return b

  end

  --create layer that persists above the models for a special view
  local function rIMV_createTheatreFrame(f)
    local b = CreateFrame("Frame","rIMV_TheatreFrame",f)
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
      PlaySound("UChatScrollButton")
      s.ag2:Play()
    end)


    local m = CreateFrame("PlayerModel", nil,b)

    m:EnableMouse(true)
    m:SetScript("OnMouseDown", function(s,bu,...)
      PlaySound(snd_select)
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

    b:SetScript("OnEnter", function(s) rIMV_showTheatreTooltip(s) end)
    b:SetScript("OnLeave", function(s) GameTooltip:Hide() end)

    m:SetScript("OnEnter", function(s) rIMV_showModelTooltip(s,"theatre") end)
    m:SetScript("OnLeave", function(s) GameTooltip:Hide() end)

    local d = m:CreateTexture(nil, "BACKGROUND",nil,-8)
    d:SetTexture(0,0,0,0.5)
    d:SetPoint("TOPLEFT", m, "TOPLEFT", -5, 5)
    d:SetPoint("BOTTOMRIGHT", m, "BOTTOMRIGHT", 5, -5)

    m.d = d

    local t = m:CreateTexture(nil, "BACKGROUND",nil,-7)
    t:SetTexture(1,1,1,0.9)
    t:SetAllPoints(m)
    m.t = t

    local p = m:CreateFontString(nil, "BACKGROUND")
    p:SetPoint("TOP", 0, -2)
    p:SetAlpha(.5)
    m.p = p

    local colorselect1 = CreateFrame("Frame","rIMV_ColorSelectWhite",b)
    local colorselect2 = CreateFrame("Frame","rIMV_ColorSelectGrey",b)
    local colorselect3 = CreateFrame("Frame","rIMV_ColorSelectMagenta",b)
    colorselect1:SetSize(50,50)
    colorselect1:SetPoint("TOPLEFT", m, "TOPRIGHT", 10, 0)
    colorselect1:EnableMouse(true)
    colorselect1.color = "White"
    colorselect1:SetScript("OnEnter", function(s) rIMV_showColorTooltip(s) end)
    colorselect1:SetScript("OnLeave", function(s) GameTooltip:Hide() end)
    colorselect1.t = colorselect1:CreateTexture(nil, "BACKGROUND",nil,-8)
    colorselect1.t:SetTexture(1,1,1,1)
    colorselect1.t:SetAllPoints(colorselect1)
    colorselect1:SetScript("OnMouseDown", function()
      PlaySound(snd_swap)
      m.t:SetTexture(1,1,1,0.9)
    end)
    colorselect1:SetHitRectInsets(-10, -10, -10, -5);

    colorselect2:SetSize(50,50)
    colorselect2:SetPoint("TOP", colorselect1, "BOTTOM", 0, -10)
    colorselect2:EnableMouse(true)
    colorselect2.color = "Grey"
    colorselect2:SetScript("OnEnter", function(s) rIMV_showColorTooltip(s) end)
    colorselect2:SetScript("OnLeave", function(s) GameTooltip:Hide() end)
    colorselect2.t = colorselect2:CreateTexture(nil, "BACKGROUND",nil,-8)
    colorselect2.t:SetTexture(0.2,0.2,0.2,1)
    colorselect2.t:SetAllPoints(colorselect2)
    colorselect2:SetScript("OnMouseDown", function()
      PlaySound(snd_swap)
      m.t:SetTexture(0.2,0.2,0.2,0.9)
    end)
    colorselect2:SetHitRectInsets(-10, -10, -5, -5);

    colorselect3:SetSize(50,50)
    colorselect3:SetPoint("TOP", colorselect2, "BOTTOM", 0, -10)
    colorselect3:EnableMouse(true)
    colorselect3.color = "Magenta"
    colorselect3:SetScript("OnEnter", function(s) rIMV_showColorTooltip(s) end)
    colorselect3:SetScript("OnLeave", function(s) GameTooltip:Hide() end)
    colorselect3.t = colorselect3:CreateTexture(nil, "BACKGROUND",nil,-8)
    colorselect3.t:SetTexture(1,0,1,1)
    colorselect3.t:SetAllPoints(colorselect3)
    colorselect3:SetScript("OnMouseDown", function()
      PlaySound(snd_swap)
      m.t:SetTexture(1,0,1,0.9)
    end)
    colorselect3:SetHitRectInsets(-10, -10, -5, -10);

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

    f.theatre = b

  end

  --create icon func
  local function rIMV_createIcon(b)
    local i = CreateFrame("PlayerModel","rIMV_Icon",UIParent)
    i:SetSize(128,128)
    i:SetPoint("CENTER",0,0)

    i:SetPortraitZoom(0)
    i:SetCamDistanceScale(1)
    i:SetPosition(0,0,0)
    i:SetRotation(0)
    i:ClearModel()
    i:SetDisplayInfo(31)

    --[[
    local t = i:CreateTexture(nil, "BACKGROUND",nil,-8)
    t:SetTexture("Interface\\AddOns\\rIngameModelViewer\\murloc")
    t:SetAllPoints(i)
    i.t = t

    local hover = i:CreateTexture(nil, "BACKGROUND",nil,-6)
    hover:SetTexture("Interface\\AddOns\\rIngameModelViewer\\murloc_hover")
    hover:SetAllPoints(i)
    hover:SetBlendMode("ADD")
    hover:SetVertexColor(0,1,0.5,0.1)
    i.hover = hover
    i.hover:Hide()
    ]]

    i:SetMovable(true)
    i:SetUserPlaced(true)
    i:EnableMouse(true)
    i:RegisterForDrag("LeftButton","RightButton")
    i:SetScript("OnDragStart", function(s) if IsAltKeyDown() then s:StartMoving() end end)
    i:SetScript("OnDragStop", function(s) s:StopMovingOrSizing() end)
    i:SetScript("OnMouseDown", function()
      if not IsAltKeyDown() then
        b:Show()
        PlaySoundFile("Sound\\Creature\\BabyMurloc\\BabyMurlocA.wav")
        rIMV_createAllModels(b)
        b:EnableMouse(true)
        b.ag1:Play()
      end
    end)

    i:SetScript("OnEnter", function(s)
      --s.hover:Show()
      PlaySound("igCreatureAggroSelect")
      rIMV_showIconTooltip(s)
    end)
    i:SetScript("OnLeave", function(s)
      --s.hover:Hide()
      PlaySound("INTERFACESOUND_LOSTTARGETUNIT")
      GameTooltip:Hide()
    end)

  end

  -----------------------------
  -- LOADUP
  -----------------------------

  --rIMV_init func
  local function rIMV_init()

    local b = rIMV_createHolderFrame()
    rIMV_createTheatreFrame(b)
    rIMV_createIcon(b)
    rIMV_createMenu(b)
    b:Hide()
    b.theatre:Hide()
  end

  --call
  rIMV_init()