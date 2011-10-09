
  ---------------------------------
  -- INIT
  ---------------------------------

  local addon, ns = ...
  ns.rBBS = {}
  local rBBS = ns.rBBS
  rBBS.movableFrames = {}
  local _G = _G
  local _DB

  ---------------------------------
  -- ANIMATION SETTINGS
  ---------------------------------

  local animtab = {
    [0] = {displayid = 17010, r = 1, g = 0, b = 0, camdistancescale = 1.1, portraitzoom = 1, x = 0, y = -0.6, rotation = 0, },          -- red fog
    [1] = {displayid = 17054, r = 1, g = 0.4, b = 1, camdistancescale = 1.1, portraitzoom = 1, x = 0, y = -0.6, rotation = 0, },      -- purple fog
    [2] = {displayid = 17055, r = 0, g = 0.5, b = 0, camdistancescale = 1.1, portraitzoom = 1, x = 0, y = -0.6, rotation = 0, },        -- green fog
    [3] = {displayid = 17286, r = 1, g = 0.9, b = 0, camdistancescale = 1.1, portraitzoom = 1, x = 0, y = -0.6, rotation = 0, },        -- yellow fog
    [4] = {displayid = 18075, r = 0, g = 0.8, b = 1, camdistancescale = 1.1, portraitzoom = 1, x = 0, y = -0.6, rotation = 0, },        -- turquoise fog
    [5] = {displayid = 23422, r = 0.4, g = 0, b = 0, camdistancescale = 2.8, portraitzoom = 1, x = 0, y = 0.1, rotation = 0, },         -- red portal
    [6] = {displayid = 27393, r = 0, g = 0.4, b = 1, camdistancescale = 3, portraitzoom = 1, x = 0, y = 0.6, rotation = 0, },           -- blue rune portal
    [7] = {displayid = 20894, r = 0.6, g = 0, b = 0, camdistancescale = 6, portraitzoom = 1, x = -0.3, y = 0.4, rotation = 0, },        -- red ghost
    [8] = {displayid = 15438, r = 0, g = 0.3, b = 0.6, camdistancescale = 6, portraitzoom = 1, x = -0.3, y = 0.4, rotation = 0, },        -- purple ghost
    [9] = {displayid = 20782, r = 0, g = 0.7, b = 1, camdistancescale = 1.2, portraitzoom = 1, x = -0.22, y = 0.18, rotation = 0, },    -- water planet
    [10] = {displayid = 23310, r = 1, g = 1, b = 1, camdistancescale = 3.5, portraitzoom = 1, x = 0, y = 3, rotation = 0, },          -- swirling cloud
    [11] = {displayid = 23343, r = 0.8, g = 0.8, b = 0.8, camdistancescale = 1.6, portraitzoom = 1, x = -0.2, y = 0, rotation = 0, },      -- white fog
    [12] = {displayid = 24813, r = 0.4, g = 0, b = 0, camdistancescale = 2.4, portraitzoom = 1.1, x = 0, y = -0.3, rotation = 0, },     -- red glowing eye
    [13] = {displayid = 25392, r = 0.4, g = 0.6, b = 0, camdistancescale = 2.6, portraitzoom = 1, x = 0, y = -0.5, rotation = 0, },     -- sandy swirl
    [14] = {displayid = 27625, r = 0.4, g = 0.6, b = 0, camdistancescale = 0.8, portraitzoom = 1, x = 0, y = 0, rotation = 0, },        -- green fire
    [15] = {displayid = 28460, r = 0.5, g = 0, b = 1, camdistancescale = 0.56, portraitzoom = 1, x = -0.4, y = 0, rotation = 0, },    -- purple swirl
    [16] = {displayid = 29286, r = 1, g = 1, b = 1, camdistancescale = 0.6, portraitzoom = 1, x = -0.6, y = -0.2, rotation = 0, },      -- white tornado
    [17] = {displayid = 29561, r = 0, g = 0.6, b = 1, camdistancescale = 2.5, portraitzoom = 1, x = 0, y = 0, rotation = -3.9, },     -- blue swirly
    [18] = {displayid = 30660, r = 1, g = 0.5, b = 0, camdistancescale = 0.12, portraitzoom = 1, x = -0.04, y = -0.08, rotation = 0, }, -- orange fog
    [19] = {displayid = 32368, r = 1, g = 1, b = 1, camdistancescale = 1.15, portraitzoom = 1, x = 0, y = 0.4, rotation = 0, },        -- pearl
    [20] = {displayid = 33853, r = 1, g = 0, b = 0, camdistancescale = 0.83, portraitzoom = 1, x = 0, y = -0.05, rotation = 0, },       -- red magnet
    [21] = {displayid = 34319, r = 0, g = 0, b = 0.4, camdistancescale = 1.55, portraitzoom = 1, x = 0, y = 0.8, rotation = 0, },       -- blue portal
    [22] = {displayid = 34645, r = 0.3, g = 0, b = 0.3, camdistancescale = 1.7, portraitzoom = 1, x = 0, y = 0.8, rotation = 0, },      -- purple portal
  }

  ---------------------------------
  -- FUNCTIONS
  ---------------------------------

  --set model values
  local setModelValues = function(self)
    self:ClearFog()
    self:ClearModel()
    --self:SetModel("interface\\buttons\\talktomequestionmark.m2") --in case setdisplayinfo fails
    self:SetDisplayInfo(self.cfg.displayid)
    self:SetPortraitZoom(self.cfg.portraitzoom)
    self:SetCamDistanceScale(self.cfg.camdistancescale)
    self:SetPosition(0,self.cfg.x,self.cfg.y)
    self:SetRotation(self.cfg.rotation)
  end

  --num format func
  local numFormat = function(v)
    local string = ""
    if v > 1E9 then
      string = (floor((v/1E9)*10)/10).."b"
    elseif v > 1E6 then
      string = (floor((v/1E6)*10)/10).."m"
    elseif v > 1E3 then
      string = (floor((v/1E3)*10)/10).."k"
    else
      string = v
    end
    return string
  end

  --so we want to move a frame that is actually hooked to the dragframe
  --do make this work we need to trick, because drag functionality ignores the parented frame and used UIParent...we don't want that, because the child would not move with the parent anymore
  local calcPoint = function(s)
    if s:GetParent():GetName() ~= "UIParent" then
      local Hx, Hy = s:GetParent():GetCenter()
      local Ox, Oy = s:GetCenter()
      if(not Ox) then return end
      local scale = s:GetScale()
      Hx, Hy = floor(Hx), floor(Hy)
      Ox, Oy = floor(Ox*scale), floor(Oy*scale)
      local Tx, Ty = (Hx-Ox)*(-1), (Hy-Oy)*(-1)
      s:ClearAllPoints()
      s:SetPoint("CENTER",s:GetParent(),Tx/scale,Ty/scale)
    end
  end

  --apply given position to frame
  local applySetPoint = function(f,pos)
    f:ClearAllPoints()
    --setpoint
    if pos then
      if pos.af and pos.a2 then
        f:SetPoint(pos.a1 or "CENTER", pos.af, pos.a2, pos.x or 0, pos.y or 0)
      elseif pos.af then
        f:SetPoint(pos.a1 or "CENTER", pos.af, pos.x or 0, pos.y or 0)
      --elseif pos.a2 then
        --f:SetPoint(pos.a1 or "CENTER", pos.a2, pos.x or 0, pos.y or 0)
      else
        f:SetPoint(pos.a1 or "CENTER", pos.x or 0, pos.y or 0)
      end
    else
      f:SetPoint("CENTER",UIParent,"CENTER",0,0)
    end
  end

  --apply given position to frame
  local applySetSize = function(f,size)
    if f.hookup then
      f.hookup:SetScale(size.w/100) --apply the size of the one frame as scale to the hookup frame
    end
    if size.ratio then
      f:SetSize(size.w,size.w*size.ratio)
    else
      f:SetSize(size.w,size.h)
    end
  end

  --fontstring func
  local createFontString = function(f, font, size, outline,layer)
    local fs = f:CreateFontString(nil, layer or "OVERLAY")
    fs:SetFont(font, size, outline)
    fs:SetShadowColor(0,0,0,1)
    return fs
  end

  --update health func
  local updateHealth = function(self, event, unit, ...)
    if unit and unit ~= self.unit then return end
    local uh, uhm, p, d = UnitHealth(self.unit) or 0, UnitHealthMax(self.unit), 0, 0
    if uhm and uhm > 0 then
      p = floor(uh/uhm*100)
      d = uh/uhm
    end
    self.filling:SetHeight(d*self.filling:GetWidth())
    self.filling:SetTexCoord(0,1,  math.abs(d-1),1)
    self.v1:SetText(p)
    self.v2:SetText(numFormat(uh))
    if self.anim and self.anim.decreaseAlpha then
      self.anim:SetAlpha(d*self.anim.multiplier or 1)
    end
    local class = select(2, UnitClass(self.unit))
    local classcolor = RAID_CLASS_COLORS[class]
    local factioncolor = FACTION_BAR_COLORS[UnitReaction(self.unit, "player")]
    if IsAddOnLoaded("rColor") then
      classcolor = rRAID_CLASS_COLORS[class]
    end
    if self.classcolored then
      --enter this condition in case the user does not want animation coloring
      if UnitIsDeadOrGhost(self.unit) or not UnitIsConnected(self.unit) then
        self.filling:SetVertexColor(0.4,0.4,0.4)
      elseif classcolor and UnitIsPlayer(self.unit) then
        self.filling:SetVertexColor(classcolor.r, classcolor.g, classcolor.b)
      elseif factioncolor then
        self.filling:SetVertexColor(factioncolor.r, factioncolor.g, factioncolor.b)
      else
        self.filling:SetVertexColor(1,0,1)
      end
    end
  end

  --update power func
  local updatePower = function(self, event, unit, ...)
    if unit and unit ~= self.unit then return end
    local uh, uhm, p, d = UnitMana(self.unit) or 0, UnitManaMax(self.unit), 0, 0
    if uhm and uhm > 0 then
      p = floor(uh/uhm*100)
      d = uh/uhm
    end
    self.filling:SetHeight(d*self.filling:GetWidth())
    self.filling:SetTexCoord(0,1,  math.abs(d-1),1)
    local powertype = select(2, UnitPowerType(self.unit))
    if powertype ~= "MANA" then
      self.v1:SetText(numFormat(uh))
      self.v2:SetText(p)
    else
      self.v1:SetText(p)
      self.v2:SetText(numFormat(uh))
    end
    local color = PowerBarColor[powertype]
    if color and self.powertypecolored then
      if powertype == "MANA" then
        --fix deep blue mana color (it sucks!)
        self.filling:SetVertexColor(0,0.2,1)
      else
        self.filling:SetVertexColor(color.r, color.g, color.b)
      end
    end
    if self.anim and self.anim.decreaseAlpha then
      self.anim:SetAlpha(d*self.anim.multiplier or 1)
    end
  end

  --set orb text strings
  local createOrbValues = function(f,cfg)
    local h = CreateFrame("FRAME", nil, f)
    h:SetAllPoints(f)
    f.vc = 135
    local v1 = createFontString(h, cfg.font or "FONTS\\FRIZQT__.ttf", f:GetWidth()*28/f.vc, "THINOUTLINE")
    v1:SetPoint("CENTER", 0, f:GetWidth()*10/f.vc)
    local v2 = createFontString(h, cfg.font or "FONTS\\FRIZQT__.ttf", f:GetWidth()*16/f.vc, "THINOUTLINE")
    v2:SetPoint("CENTER", 0, (-1)*f:GetWidth()*10/f.vc)
    v2:SetTextColor(0.8,0.8,0.8)
    f.v1 = v1
    f.v2 = v2
  end

  --save the size of the frame to the db
  local saveFrameSize = function(f)
    local n = f:GetName()
    if not _DB[n] then _DB[n] = {} end
    if not _DB[n].size then _DB[n].size = {} end
    local w, h = f:GetWidth(), f:GetHeight()
    _DB[n].size = {} --reset all values
    _DB[n].size.w = w
    _DB[n].size.h = h
    _DB[n].size.ratio = f.ratio
  end

  --save the position of the frame to db
  local saveFramePosition = function(f)
    local n = f:GetName()
    if not _DB[n] then _DB[n] = {} end
    if not _DB[n].pos then _DB[n].pos = {} end
    local a1, af, a2, x, y = f:GetPoint()
    _DB[n].pos = {} --reset all values
    _DB[n].pos.a1 = a1
    if af and af:GetName() then
      _DB[n].pos.af = af:GetName()
    end
    _DB[n].pos.a2 = a2
    _DB[n].pos.x = x
    _DB[n].pos.y = y
  end

  --apply given position to frame
  local applyVisibility = function(f,visibility)
    if visibility == "show" then
      f:Show()
    else
      f:Hide()
    end
  end

  --save the visibility status to db
  local saveVisibility = function(f,visibility)
    local n = f:GetName()
    if not _DB[n] then _DB[n] = {} end
    if visibility == "show" then
      _DB[n].visibility = "show"
    else
      _DB[n].visibility = "hide"
    end
  end

  --hide the frame
  local hideFrame = function(f)
    saveVisibility(f,"hide")
    applyVisibility(f,"hide")
  end

  --show the frame
  local showFrame = function(f)
    saveVisibility(f,"show")
    applyVisibility(f,"show")
  end

  --reset frame to default data and empty the DB
  local resetFrame = function(f)
    local n = f:GetName()
    --empty db for that frame
    if n and _DB[n] then
      _DB[n] = nil
    end
    applySetPoint(f,f.default.pos) --apply default position to frame
    applySetSize(f,f.default.size) --apply default size to frame
    applyVisibility(f,f.default.visibility)
  end

  --unlock frame func
  local unlockFrame = function(f)
    f:EnableMouse(true)
    f.locked = false
    f.dragtexture:SetAlpha(0.3)
    f:RegisterForDrag("LeftButton","RightButton")
    f:SetScript("OnEnter", function(s)
      GameTooltip:SetOwner(s, "ANCHOR_BOTTOMRIGHT")
      GameTooltip:AddLine(s:GetName(), 0, 1, 0.5, 1, 1, 1)
      GameTooltip:AddLine("LEFT MOUSE to DRAG", 1, 1, 1, 1, 1, 1)
      GameTooltip:AddLine("RIGHT MOUSE to SIZE", 1, 1, 1, 1, 1, 1)
      GameTooltip:Show()
    end)
    f:SetScript("OnLeave", function(s) GameTooltip:Hide() end)
    f:SetScript("OnDragStart", function(s,b)
      if b == "LeftButton" then
        s:StartMoving()
      end
      if b == "RightButton" then
        s:StartSizing()
      end
    end)
    f:SetScript("OnDragStop", function(s)
      s:StopMovingOrSizing()
      calcPoint(s)
      --save frame data to db
      saveFramePosition(s)
      saveFrameSize(s)
    end)
  end

  --lock frame func
  local lockFrame = function(f)
    f.locked = true
    f.dragtexture:SetAlpha(0)
    f:RegisterForDrag(nil)
    if f.unit then
      f:SetScript("OnEnter", UnitFrame_OnEnter)
      f:SetScript("OnLeave", UnitFrame_OnLeave)
    else
      f:EnableMouse(nil)
      f:SetScript("OnEnter", nil)
      f:SetScript("OnLeave", nil)
    end
    f:SetScript("OnDragStart", nil)
    f:SetScript("OnDragStop", nil)
  end

  --menu function from phanx
  local dropdown = CreateFrame("Frame", "rBBSUnitDropDownMenu", UIParent, "UIDropDownMenuTemplate")

  UIDropDownMenu_Initialize(dropdown, function(self)
    local unit = self:GetParent().unit
    if not unit then return end
    local menu, name, id
    if UnitIsUnit(unit, "player") then
      menu = "SELF"
    elseif UnitIsUnit(unit, "vehicle") then
      menu = "VEHICLE"
    elseif UnitIsUnit(unit, "pet") then
      menu = "PET"
    elseif UnitIsPlayer(unit) then
      id = UnitInRaid(unit)
      if id then
        menu = "RAID_PLAYER"
        name = GetRaidRosterInfo(id)
      elseif UnitInParty(unit) then
        menu = "PARTY"
      else
        menu = "PLAYER"
      end
    else
      menu = "TARGET"
      name = RAID_TARGET_ICON
    end
    if menu then
      UnitPopup_ShowMenu(self, menu, unit, name, id)
    end
  end, "MENU")

  local menu = function(self)
    dropdown:SetParent(self)
    ToggleDropDownMenu(1, nil, dropdown, "cursor", 0, 0)
  end

  --player frame menu and click events
  local createClickFrame = function(f)
    f:RegisterForClicks("AnyUp")
    f:SetAttribute("unit", f.unit)
    f.menu = menu
    f:SetAttribute("*type1", "target")
    f:SetAttribute("*type2", "menu")
    f:SetScript("OnEnter", UnitFrame_OnEnter)
    f:SetScript("OnLeave", UnitFrame_OnLeave)
  end

  --reset all frames to default values
  local resetAllFrames = function()
    for index,v in ipairs(rBBS.movableFrames) do
      resetFrame(_G[v])
    end
  end

  --hide all frames
  local hideAllFrames = function()
    for index,v in ipairs(rBBS.movableFrames) do
      hideFrame(_G[v])
    end
  end

  --show all frames
  local showAllFrames = function()
    for index,v in ipairs(rBBS.movableFrames) do
      showFrame(_G[v])
    end
  end

  --unlock all frames
  local unlockAllFrames = function()
    for index,v in ipairs(rBBS.movableFrames) do
      unlockFrame(_G[v])
    end
  end

  --lock all frames
  local lockAllFrames = function()
    for index,v in ipairs(rBBS.movableFrames) do
      lockFrame(_G[v])
    end
  end

  --apply size
  local applySize = function(f,w,h)
    if w < 20 then w = 20 end
    if f.hookup then
      f.hookup:SetScale(w/100) --apply the size of the one frame as scale to the hookup frame
    end
    if f.ratio then
      f:SetSize(w,w*f.ratio)
    else
      f:SetSize(w,h)
    end
    if f.type == "healthorb" then
      local uh, uhm = UnitHealth(f.unit) or 0, UnitHealthMax(f.unit)
      if uhm and uhm > 0 then
        f.filling:SetHeight((uh/uhm) * w)
      else
        f.filling:SetHeight(0)
      end
    end
    if f.type == "powerorb" then
      local uh, uhm = UnitMana(f.unit) or 0, UnitManaMax(f.unit)
      if uhm and uhm > 0 then
        f.filling:SetHeight((uh/uhm) * w)
      else
        f.filling:SetHeight(0)
      end
    end
    if f.type == "healthorb" or f.type == "powerorb" then
      local font,size,flag = f.v1:GetFont()
      f.v1:SetFont(font,w*28/f.vc,flag)
      f.v1:SetPoint("CENTER", 0, w*10/f.vc)
      local font,size,flag = f.v2:GetFont()
      f.v2:SetFont(font,w*16/f.vc,flag)
      f.v2:SetPoint("CENTER", 0, (-1)*w*10/f.vc)
    end
  end

  --apply movability
  local applyMoveFunctionality = function(f)
    if not f.movable then
      if f:IsUserPlaced() then
        f:SetUserPlaced(false)
      end
      return
    end
    f:SetHitRectInsets(-5,-5,-5,-5)
    --if f.type == "healthorb" or f.type == "powerorb" or f.type == "dragframe" then
      f:SetClampedToScreen(false)
    --else
      --f:SetClampedToScreen(true)
    --end
    f:SetMovable(true)
    f:SetResizable(true)
    f:SetUserPlaced(true)
    local t = f:CreateTexture(nil,"OVERLAY",nil,6)
    t:SetAllPoints(f)
    if f.type == "dragframe" then
      t:SetTexture(0,1,1)
    else
      t:SetTexture(0,1,0)
    end
    t:SetAlpha(0)
    f.dragtexture = t
    f:SetScript("OnSizeChanged", applySize)
    lockFrame(f) --lock frame by default
    table.insert(rBBS.movableFrames,f:GetName()) --load all the frames that can be moved into the global table
  end

  --save the default values
  local saveDefaultSettings = function(f,cfg)
    f.default             = {}
    f.default.pos         = cfg.pos
    f.default.size        = {}
    f.default.size.w      = cfg.width or 100
    f.default.size.h      = cfg.height or 100
    f.default.size.ratio  = f.ratio
    f.default.visibility  = cfg.visibility or "show" -- show/hide
  end

  --create backdrop
  local createBackdrop = function(f,cfg)
    if not cfg then return end
    local backdrop = {
      bgFile = cfg.bgFile or nil,
      edgeFile = cfg.edgeFile or nil,
      tile = cfg.tile or false,
      tileSize = cfg.tileSize or 16,
      edgeSize = cfg.edgeSize or 16,
      insets = {
        left = cfg.inset or 0,
        right = cfg.inset or 0,
        top = cfg.inset or 0,
        bottom = cfg.inset or 0,
      },
    }
    local b = CreateFrame("FRAME",nil,f.lastActiveBackdrop or f)
    b:SetPoint("TOPLEFT",f,"TOPLEFT",cfg.padding or 0,-cfg.padding or 0)
    b:SetPoint("BOTTOMRIGHT",f,"BOTTOMRIGHT",-cfg.padding or 0,cfg.padding or 0)
    b:SetBackdrop(backdrop)
    if cfg.bgColor then
      b:SetBackdropColor(cfg.bgColor.r or 1, cfg.bgColor.g or 1, cfg.bgColor.b or 1, cfg.bgColor.a or 1)
    end
    if cfg.edgeColor then
      b:SetBackdropBorderColor(cfg.edgeColor.r or 1, cfg.edgeColor.g or 1, cfg.edgeColor.b or 1, cfg.edgeColor.a or 1)
    end
    f.lastActiveBackdrop = b
  end

  --create all backdrops
  local createAllBackdrops = function(f,backdrops)
    if not backdrops then return end
    for i,v in ipairs(backdrops) do
      createBackdrop(f,v)
    end
  end

  --SPAWN DRAGFRAME FUNCTION
  function rBBS:spawnDragFrame(opener, cfg)
    --create frame based on given config settings
    local f = CreateFrame("Frame", opener.."_DragFrame", UIParent)
    --save movable and sizable to the frame object
    f.movable = cfg.movable or true
    f.type = "dragframe"
    --frame strata
    f:SetFrameStrata(cfg.strata or "BACKGROUND")
    --framelevel
    f:SetFrameLevel(cfg.level or 0)
    --size
    f:SetSize(100,100) --scale will be calculated later on size of this frame
    --save the width/height ratio in case frame gets resized
    f.ratio = 1
    --setpoint
    applySetPoint(f,cfg.pos)
    --now let's trick we want the frame above to be resizable bit that resize should affect the setscale of a second frame that is hidden
    --but anchored by all the frames that have the dragframe as parented frame, that way we can scale frames by changing the scale of the dragframe
    local hookup = CreateFrame("Frame",  opener.."_HookupFrame", f)
    hookup:SetSize(100,100)
    hookup:SetPoint("CENTER",0,0)
    f.hookup = hookup
    --add the movability function
    applyMoveFunctionality(f)
    --save default settings for reset
    saveDefaultSettings(f,cfg)
    return hookup --return the hookup to be parented by frame that parent the dragframe
  end

  --SPAWN BACKDROP FUNCTION
  function rBBS:spawnBackdropFrame(opener, cfg, parent)
    if parent then cfg.parent = parent end
    --add the name of the opener addon to the frame name
    if cfg.name then cfg.name = opener.."_"..cfg.name end
    --create frame based on given config settings
    local f = CreateFrame("Frame", cfg.name or nil, cfg.parent or UIParent, cfg.inherit or nil)
    --save movable and sizable to the frame object
    f.movable = cfg.movable or true
    f.type = "backdrop"
    --frame strata
    f:SetFrameStrata(cfg.strata or "BACKGROUND")
    --framelevel
    f:SetFrameLevel(cfg.level or 0)
    --size
    f:SetSize(cfg.width or 100, cfg.height or 100)
    --save the width/height ratio in case frame gets resized
    f.ratio = nil --ignore the ratio value for backdrops
    --alpha
    if cfg.alpha then f:SetAlpha(cfg.alpha or 1) end
    --scale
    if cfg.scale then f:SetScale(cfg.scale or 1) end
    --setpoint
    applySetPoint(f,cfg.pos)
    --backdrops
    createAllBackdrops(f,cfg.backdrops)
    --add the movability function
    applyMoveFunctionality(f)
    --save default settings for reset
    saveDefaultSettings(f,cfg)
  end

  --SPAWN FRAME FUNCTION
  function rBBS:spawnFrame(opener, cfg, parent)
    if parent then cfg.parent = parent end
    --add the name of the opener addon to the frame name
    if cfg.name then cfg.name = opener.."_"..cfg.name end
    --create frame based on given config settings
    local f = CreateFrame("Frame", cfg.name or nil, cfg.parent or UIParent, cfg.inherit or nil)
    --print(f:GetName().." loaded.")
    --save movable and sizable to the frame object
    f.movable = cfg.movable or true
    --frame strata
    f:SetFrameStrata(cfg.strata or "BACKGROUND")
    --framelevel
    f:SetFrameLevel(cfg.level or 0)
    --size
    f:SetSize(cfg.width or 100, cfg.height or 100)
    --save the width/height ratio in case frame gets resized
    f.ratio = (cfg.height or 100) / (cfg.width or 100)
    --alpha
    if cfg.alpha then f:SetAlpha(cfg.alpha or 1) end
    --scale
    if cfg.scale then f:SetScale(cfg.scale or 1) end
    --setpoint
    applySetPoint(f,cfg.pos)
    --texture
    if cfg.texture and cfg.texture.file then
      local t = f:CreateTexture(nil, cfg.texture.strata or "BACKGROUND", nil, cfg.texture.level or -8)
      t:SetTexture(cfg.texture.file)
      --setpoint
      t:SetAllPoints(f)
      --color
      if cfg.texture.color then
        t:SetVertexColor(cfg.texture.color.r or 1, cfg.texture.color.g or 1, cfg.texture.color.b or 1, cfg.texture.color.a or 1)
      end
      --blendmode
      if cfg.texture.blendmode then
        t:SetBlendMode(cfg.texture.blendmode or "BLEND")
      end
      f.texture = t
    end
    --add the movability function
    applyMoveFunctionality(f)
    --save default settings for reset
    saveDefaultSettings(f,cfg)
  end

  --SPAWN HealthOrb FUNCTION
  function rBBS:spawnHealthOrb(opener, cfg, parent)
    if parent then cfg.parent = parent end
    --add the name of the opener addon to the frame name
    if cfg.name then cfg.name = opener.."_"..cfg.name end
    --create frame based on given config settings
    local f = CreateFrame("Button", cfg.name or nil, cfg.parent or UIParent, cfg.inherit or "SecureUnitButtonTemplate")
    --print(f:GetName().." loaded.")
    --save movable and sizable to the frame object
    f.movable = cfg.movable or true
    f.type = "healthorb"
    f.classcolored = cfg.classcolored
    f.unit = cfg.unit or "player"
    if f.unit then
    --if f.unit == "player" then
      --createPlayerClickFrame(f)
      createClickFrame(f)
    end
    --frame strata
    f:SetFrameStrata(cfg.strata or "LOW")
    --framelevel
    f:SetFrameLevel(cfg.level or 1)
    --size
    cfg.width, cfg.height = cfg.size, cfg.size
    f:SetSize(cfg.width or 100, cfg.height or 100)
    --save the width/height ratio in case frame gets resized
    f.ratio = 1
    --alpha
    if cfg.alpha then f:SetAlpha(cfg.alpha or 1) end
    --scale
    if cfg.scale then f:SetScale(cfg.scale or 1) end
    --setpoint
    applySetPoint(f,cfg.pos)
    --background
    local b = f:CreateTexture(nil, "BACKGROUND", nil, -6)
    b:SetTexture(cfg.background or "Interface\\AddOns\\rBBS\\media\\orb_back")
    b:SetAllPoints(f)
    f.back = b

    --filling
    local h = f:CreateTexture(nil, "BACKGROUND", nil, -4)
    h:SetTexture(cfg.filling or "Interface\\AddOns\\rBBS\\media\\orb_filling")
    h:SetPoint("BOTTOM",0,0)
    h:SetPoint("LEFT",0,0)
    h:SetPoint("RIGHT",0,0)
    h:SetHeight(cfg.size)
    if cfg.color then
      h:SetVertexColor(cfg.color.r or 1, cfg.color.g or 0, cfg.color.b or 0, cfg.color.a or 1)
    else
      h:SetVertexColor(1,0,0,1)
    end
    f.filling = h

    --animation holder
    local m = CreateFrame("PlayerModel", nil, f)
    m:SetAllPoints(f)
    if cfg.animation and cfg.animation.enable then
      if f.classcolored then
        m.cfg = animtab[19]
      else
        m.cfg = animtab[cfg.animation.anim]
      end
      m:SetAlpha(1*cfg.animation.multiplier)
      f.filling:SetVertexColor(m.cfg.r, m.cfg.g, m.cfg.b)
      setModelValues(m)
      m:SetScript("OnShow", setModelValues)
      m:SetScript("OnSizeChanged", setModelValues)
      m.multiplier       = cfg.animation.multiplier
      m.decreaseAlpha    = cfg.animation.decreaseAlpha
    end
    f.anim = m

    local gh = CreateFrame("Frame", nil, f)
    gh:SetFrameLevel(m:GetFrameLevel()+2)
    gh:SetAllPoints()
    --gloss
    local g = gh:CreateTexture(nil, "BACKGROUND", nil, -2)
    g:SetTexture(cfg.gloss or "Interface\\AddOns\\rBBS\\media\\orb_gloss")
    g:SetAllPoints(f)
    f.gloss = b

    --add values
    createOrbValues(f,cfg)

    --add the movability function
    applyMoveFunctionality(f)
    --save default settings for reset
    saveDefaultSettings(f,cfg)

    --register events
    f:RegisterEvent("UNIT_HEALTH")
    f:RegisterEvent("PLAYER_ENTERING_WORLD")
    if f.unit == "target" then f:RegisterEvent("PLAYER_TARGET_CHANGED") end
    if f.unit == "pet" then f:RegisterEvent("UNIT_PET") end
    if parent then f:RegisterEvent("PLAYER_LOGIN") end
    --event
    f:SetScript("OnEvent", updateHealth)
  end


  --SPAWN PowerOrb FUNCTION
  function rBBS:spawnPowerOrb(opener, cfg, parent)
    if parent then cfg.parent = parent end
    --add the name of the opener addon to the frame name
    if cfg.name then cfg.name = opener.."_"..cfg.name end
    --create frame based on given config settings
    local f = CreateFrame("Frame", cfg.name or nil, cfg.parent or UIParent, cfg.inherit or nil)
    --print(f:GetName().." loaded.")
    --save movable and sizable to the frame object
    f.movable = cfg.movable or true
    f.type = "powerorb"
    f.powertypecolored = cfg.powertypecolored
    f.unit = cfg.unit or "player"
    --frame strata
    f:SetFrameStrata(cfg.strata or "LOW")
    --framelevel
    f:SetFrameLevel(cfg.level or 1)
    --size
    cfg.width, cfg.height = cfg.size, cfg.size
    f:SetSize(cfg.width or 100, cfg.height or 100)
    --save the width/height ratio in case frame gets resized
    f.ratio = 1
    --alpha
    if cfg.alpha then f:SetAlpha(cfg.alpha or 1) end
    --scale
    if cfg.scale then f:SetScale(cfg.scale or 1) end
    --setpoint
    applySetPoint(f,cfg.pos)

    --background
    local b = f:CreateTexture(nil, "BACKGROUND", nil, -6)
    b:SetTexture(cfg.background or "Interface\\AddOns\\rBBS\\media\\orb_back")
    b:SetAllPoints(f)
    f.back = b

    --filling
    local h = f:CreateTexture(nil, "BACKGROUND", nil, -4)
    h:SetTexture(cfg.filling or "Interface\\AddOns\\rBBS\\media\\orb_filling")
    h:SetPoint("BOTTOM",0,0)
    h:SetPoint("LEFT",0,0)
    h:SetPoint("RIGHT",0,0)
    h:SetHeight(cfg.size)
    if cfg.color then
      h:SetVertexColor(cfg.texture.color.r or 1, cfg.texture.color.g or 0, cfg.texture.color.b or 0, cfg.texture.color.a or 1)
    else
      h:SetVertexColor(0,0.3,1,1)
    end
    f.filling = h

    --animation holder
    local m = CreateFrame("PlayerModel", nil, f)
    m:SetAllPoints(f)
    if cfg.animation and cfg.animation.enable then
      if f.powertypecolored then
        m.cfg = animtab[19]
      else
        m.cfg = animtab[cfg.animation.anim]
      end
      m:SetAlpha(1*cfg.animation.multiplier)
      f.filling:SetVertexColor(m.cfg.r, m.cfg.g, m.cfg.b)
      setModelValues(m)
      m:SetScript("OnShow", setModelValues)
      m:SetScript("OnSizeChanged", setModelValues)
      m.multiplier       = cfg.animation.multiplier
      m.decreaseAlpha    = cfg.animation.decreaseAlpha
    end
    f.anim = m

    local gh = CreateFrame("Frame", nil, f)
    gh:SetFrameLevel(m:GetFrameLevel()+2)
    gh:SetAllPoints()

    --gloss
    local g = gh:CreateTexture(nil, "BACKGROUND", nil, -2)
    g:SetTexture(cfg.gloss or "Interface\\AddOns\\rBBS\\media\\orb_gloss")
    g:SetAllPoints(f)
    f.gloss = b

    --add values
    createOrbValues(f,cfg)

    --add the movability function
    applyMoveFunctionality(f)
    --save default settings for reset
    saveDefaultSettings(f,cfg)

    --register events
    f:RegisterEvent("UNIT_POWER")
    f:RegisterEvent("UNIT_MAXPOWER")
    f:RegisterEvent("PLAYER_ENTERING_WORLD")
    f:RegisterEvent("UPDATE_SHAPESHIFT_FORM")
    if f.unit == "target" then f:RegisterEvent("PLAYER_TARGET_CHANGED") end
    if parent then f:RegisterEvent("PLAYER_LOGIN") end
    --event
    f:SetScript("OnEvent", updatePower)
  end

  ---------------------------------
  -- THE INGAME MENU
  ---------------------------------
  local dropdown = CreateFrame("Frame", "rBBSMenuFrame", nil, "UIDropDownMenuTemplate")
  local menuTable = {}
  local line, submenu, delim = nil, {}, "~~~~~~~~~~~~~~~~~~~~~~~"

  local createMenuTitle = function(title)
    --title
    line = { text = title, isTitle = true, notCheckable = true, notClickable = true }
    table.insert(menuTable,line)
    line = { text = delim, notCheckable = true, notClickable = true }
    table.insert(menuTable,line)
  end

  local createMenuCloseButton = function(title)
    --close
    line = { text = delim, notCheckable = true, notClickable = true }
    table.insert(menuTable,line)
    line = { text = title, func = function() CloseDropDownMenus() end, notCheckable = true }
    table.insert(menuTable,line)
  end

  local createMenuGeneralSettings = function()
    local f = _G["rBBS_Menugem"]
    --menugem
    local subsubmenu = {
      { text = "Menugem", isTitle = true, notCheckable = true, notClickable = true },
      { text = delim, notCheckable = true, notClickable = true },
      { text = "Show", func = function() showFrame(f) end, notCheckable = 1, keepShownOnClick = true, },
      { text = "Hide", func = function() hideFrame(f) end, notCheckable = 1, keepShownOnClick = true, },
    }
    --table.insert(menuTable,line)
    --general
    submenu = {
      { text = "General", isTitle = true, notCheckable = true, notClickable = true },
      { text = delim, notCheckable = true, notClickable = true },
      { text = "Menugem", notCheckable = true, hasArrow = true, menuList = subsubmenu },
      { text = delim, notCheckable = true, notClickable = true },
      { text = "Unlock All", func = unlockAllFrames, notCheckable = 1, keepShownOnClick = true, },
      { text = "Lock All", func = lockAllFrames, notCheckable = 1, keepShownOnClick = true, },
      { text = "Show All", func = showAllFrames, notCheckable = 1, keepShownOnClick = true, },
      { text = "Hide All", func = hideAllFrames, notCheckable = 1, keepShownOnClick = true, },
      { text = delim, notCheckable = true, notClickable = true },
      { text = "Reset All", func = resetAllFrames, notCheckable = 1, keepShownOnClick = true, },
    }
    line = { text = "General", notCheckable = true, hasArrow = true, menuList = submenu }
    table.insert(menuTable,line)
    line = { text = delim, notCheckable = true, notClickable = true }
    table.insert(menuTable,line)
  end

  local createMenuForFrames = function(f,title)
    --general
    submenu = {
      { text = title, isTitle = true, notCheckable = true, notClickable = true },
      { text = delim, notCheckable = true, notClickable = true },
      { text = "Unlock", func = function() unlockFrame(f) end, notCheckable = 1, keepShownOnClick = true, },
      { text = "Lock", func = function() lockFrame(f) end, notCheckable = 1, keepShownOnClick = true, },
      { text = "Show", func = function() showFrame(f) end, notCheckable = 1, keepShownOnClick = true, },
      { text = "Hide", func = function() hideFrame(f) end, notCheckable = 1, keepShownOnClick = true, },
      { text = delim, notCheckable = true, notClickable = true },
      { text = "Reset", func = function() resetFrame(f) end, notCheckable = 1, keepShownOnClick = true, },
    }
    line = { text = title, notCheckable = true, hasArrow = true, menuList = submenu }
    table.insert(menuTable,line)
  end

  ---------------------------------
  -- LOAD SAVEDVARIABLES
  ---------------------------------
  do
    local f = CreateFrame("Frame")
    f:SetScript("OnEvent", function(self, event)
      return self[event](self)
    end)
    function f:VARIABLES_LOADED()
      _DB = _G["rBBS_DB"] or {}
      _G["rBBS_DB"] = _DB
      for i,v in ipairs(rBBS.movableFrames) do
        --loading data from db (overwriting the default values)
        --print(v)
        --load position from db
        if _DB[v] and _DB[v].pos then
          applySetPoint(_G[v],_DB[v].pos)
        end
        if _DB[v] and _DB[v].size then
          applySetSize(_G[v],_DB[v].size)
        end
        if _DB[v] and _DB[v].visibility then
          applyVisibility(_G[v],_DB[v].visibility)
        end
      end
      --get menugem visibility
      if _DB["rBBS_Menugem"] and _DB["rBBS_Menugem"].visibility then
        applyVisibility(_G["rBBS_Menugem"],_DB["rBBS_Menugem"].visibility)
      end
      self:UnregisterEvent("VARIABLES_LOADED")
    end
    f:RegisterEvent("VARIABLES_LOADED")

    function f:PLAYER_LOGIN()
      --fix frame position anchor (frames that are dragable loose the parented anchorframe, fix that on loadup)
      for i,v in ipairs(rBBS.movableFrames) do
        calcPoint(_G[v])
      end

      --create the ingame menu
      createMenuTitle("rBBS")
      createMenuGeneralSettings()
      for i,v in ipairs(rBBS.movableFrames) do
        createMenuForFrames(_G[v],v)
      end
      createMenuCloseButton("Close Menu")

      self:UnregisterEvent("PLAYER_LOGIN")
    end
    f:RegisterEvent("PLAYER_LOGIN")

  end

  ---------------------------------
  -- SLASH COMMAND
  ---------------------------------

  --slash command functionality
  local function SlashCmd(cmd)
    EasyMenu(menuTable, dropdown, "cursor", 10 , -15, "MENU")
  end

  SlashCmdList["rbbs"] = SlashCmd;
  SLASH_rbbs1 = "/rbbs";
  print("|c0033AAFFrBBS loaded.|r")
  print("|c0033AAFF\/rBBS|r to display the menu")

  ---------------------------------
  -- RBBS_MENUGEM ICON
  ---------------------------------
  --tooltip for icon func
  local showIconTooltip = function(f)
    local g = GameTooltip
    g:SetOwner(f, "ANCHOR_CURSOR")
    g:AddLine("rBBS Menugem", 0, 1, 0.5, 1, 1, 1)
    g:AddLine("Click the gem to open the menu.", 1, 1, 1, 1, 1, 1)
    g:AddLine("ALT+LEFT MOUSE to move the icon.", 1, 1, 1, 1, 1, 1)
    g:Show()
  end

  local swapIconTexture = function(s)
    if s.switch then
      s.switch = false
      s.t:SetTexture("Interface\\AddOns\\rBBS\\media\\chatgem_active.tga")
    else
      s.switch = true
      s.t:SetTexture("Interface\\AddOns\\rBBS\\media\\chatgem_inactive.tga")
    end
    EasyMenu(menuTable, dropdown, "cursor", 10 , -15, "MENU")
  end

  local createIcon = function(f)
    local i = CreateFrame("Frame","rBBS_Menugem",UIParent)
    i:SetSize(32,32)
    i:SetPoint("CENTER",0,0)
    i:SetScale(0.82)
    local t = i:CreateTexture(nil, "BACKGROUND",nil,-8)
    t:SetTexture("Interface\\AddOns\\rBBS\\media\\chatgem_inactive.tga")
    t:SetAllPoints(i)
    i.t = t
    i.switch = true
    i:SetMovable(true)
    i:SetUserPlaced(true)
    i:EnableMouse(true)
    i:SetClampedToScreen(true)
    i:RegisterForDrag("LeftButton","RightButton")
    i:SetScript("OnDragStart", function(s) if IsAltKeyDown() then s:StartMoving() end end)
    i:SetScript("OnDragStop", function(s) s:StopMovingOrSizing() end)
    i:SetScript("OnMouseDown", function(s)
      if not IsAltKeyDown() then
        swapIconTexture(s)
      end
    end)
    i:SetScript("OnEnter", function(s)
      showIconTooltip(s)
    end)
    i:SetScript("OnLeave", function(s)
      GameTooltip:Hide()
    end)
  end

  --call
  createIcon()

  ---------------------------------
  -- REGISTER
  ---------------------------------

  _G["rBBS"] = rBBS
