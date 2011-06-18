
  ---------------------------------
  -- INIT
  ---------------------------------

  local addon, ns = ...
  ns.rBBS = {}
  local rBBS = ns.rBBS
  
  ---------------------------------
  -- VARIABLES
  ---------------------------------

  rBBS.movableFrames = {}
  
  local playerName, _     = UnitName("player")
  local _, playerClass    = UnitClass("player")
  local playerColor       = RAID_CLASS_COLORS[playerClass]
  
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

  --fontstring func
  local createFontString = function(f, font, size, outline,layer)
    local fs = f:CreateFontString(nil, layer or "OVERLAY")
    fs:SetFont(font, size, outline)
    fs:SetShadowColor(0,0,0,1)
    return fs
  end 

  --update power func
  local updatePower = function(self, event, unit, ...)
    if event == "UPDATE_SHAPESHIFT_FORM" or event == "PLAYER_ENTERING_WORLD" or unit == "player" then      
      local uh, uhm = UnitMana("player"), UnitManaMax("player")
      local p = floor(uh/uhm*100)
      self.filling:SetHeight((uh/uhm) * self.filling:GetWidth())
      self.filling:SetTexCoord(0,1,  math.abs(uh/uhm - 1),1)
      local powertype = select(2, UnitPowerType(unit or "player"))
      if powertype ~= "MANA" then
        self.v1:SetText(numFormat(uh))
        self.v2:SetText(p)
      else
        self.v1:SetText(p)
        self.v2:SetText(numFormat(uh))
      end
      local color = PowerBarColor[powertype]
      if color and self.powertypecolored then
        self.filling:SetVertexColor(color.r, color.g, color.b)
         if self.anim and self.anim.decreaseAlpha then
          self.anim:SetAlpha((uh/uhm)*self.anim.multiplier or 1)
        end        
      end
    end
  end

  --update health func
  local updateHealth = function(self, event, unit, ...)
    if event == "PLAYER_ENTERING_WORLD" or unit == "player" then      
      local uh, uhm = UnitHealth("player"), UnitHealthMax("player")
      local p = floor(uh/uhm*100)
      self.filling:SetHeight((uh/uhm) * self.filling:GetWidth())
      self.filling:SetTexCoord(0,1,  math.abs(uh/uhm - 1),1)
      self.v1:SetText(p)
      self.v2:SetText(numFormat(uh))
      if self.anim and self.anim.decreaseAlpha then
        self.anim:SetAlpha((uh/uhm)*self.anim.multiplier or 1)
      end
    end
  end
  
  --set orb text strings
  local createOrbValues = function(f,cfg)
    local h = CreateFrame("FRAME", nil, f)
    h:SetAllPoints(f)
    f.vc = 140
    local v1 = createFontString(h, cfg.font or "FONTS\\FRIZQT__.ttf", f:GetWidth()*28/f.vc, "THINOUTLINE")
    v1:SetPoint("CENTER", 0, f:GetWidth()*10/f.vc)
    local v2 = createFontString(h, cfg.font or "FONTS\\FRIZQT__.ttf", f:GetWidth()*16/f.vc, "THINOUTLINE")
    v2:SetPoint("CENTER", 0, (-1)*f:GetWidth()*10/f.vc)
    v2:SetTextColor(0.8,0.8,0.8)
    f.v1 = v1
    f.v2 = v2
  end

  --unlock frame func
  local unlockFrame = function(f)
    f:EnableMouse(true)
    f.locked = false
    f.dragtexture:SetAlpha(0.2)
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
    end)
  end
  
  --lock frame func
  local lockFrame = function(f)
    if f.type ~= "healthorb" then
      f:EnableMouse(nil)
      f.locked = true
    end
    f.dragtexture:SetAlpha(0)
    f:RegisterForDrag(nil)
    f:SetScript("OnEnter", nil)
    f:SetScript("OnLeave", nil)
    f:SetScript("OnDragStart", nil)
    f:SetScript("OnDragStop", nil)
  end

  local createPlayerClickFrame = function(f)
    f:RegisterForClicks("AnyUp")
    f:SetAttribute("unit", "player")
    f:SetAttribute("*type1", "target")
    local showmenu = function() 
      ToggleDropDownMenu(1, nil, PlayerFrameDropDown, "cursor", 0, 0) 
    end
    f.showmenu = showmenu
    f.unit = "player"
    f:SetAttribute("*type2", "showmenu")
    f:SetScript("OnEnter", UnitFrame_OnEnter)
    f:SetScript("OnLeave", UnitFrame_OnLeave)
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
  local applySize = function(f)
    local w = f:GetWidth()
    if w < 20 then w = 20 end
    f:SetSize(w,w*f.ratio)
    if f.type == "healthorb" then
      local uh, uhm = UnitHealth("player"), UnitHealthMax("player")
      f.filling:SetHeight((uh/uhm) * f.filling:GetWidth())
    end
    if f.type == "powerorb" then
      local uh, uhm = UnitMana("player"), UnitManaMax("player")
      f.filling:SetHeight((uh/uhm) * f.filling:GetWidth())
    end
    if f.type == "healthorb" or f.type == "powerorb" then
      local font,size,flag = f.v1:GetFont()
      f.v1:SetFont(font,f:GetWidth()*28/f.vc,flag)
      f.v1:SetPoint("CENTER", 0, f:GetWidth()*10/f.vc)
      local font,size,flag = f.v2:GetFont()
      f.v2:SetFont(font,f:GetWidth()*16/f.vc,flag)
      f.v2:SetPoint("CENTER", 0, (-1)*f:GetWidth()*10/f.vc)
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
    if f.type == "healthorb" or f.type == "powerorb" then
      f:SetClampedToScreen(false)
    else
      f:SetClampedToScreen(true)
    end
    f:SetMovable(true)
    f:SetResizable(true)
    f:SetUserPlaced(true)
    local t = f:CreateTexture(nil,"OVERLAY",nil,6)
    t:SetAllPoints(f)
    t:SetTexture(0,1,0)
    t:SetAlpha(0)
    f.dragtexture = t
    f:SetScript("OnSizeChanged", function(s) 
      applySize(s)
    end)
    lockFrame(f) --lock frame by default
    table.insert(rBBS.movableFrames,f:GetName()) --load all the frames that can be moved into the global table
  end

  --SPAWN FRAME FUNCTION
  function rBBS:spawnFrame(opener, cfg)
    --add the name of the opener addon to the frame name
    if cfg.name then cfg.name = opener.."_"..cfg.name end
    --create frame based on given config settings
    local f = CreateFrame("Frame", cfg.name or nil, cfg.parent or UIParent, cfg.inherit or nil)
    --print(f:GetName().." loaded.")
    --save movable and sizable to the frame object
    f.movable = cfg.movable or false
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
    if cfg.pos then
      f:SetPoint(cfg.pos.a1 or "CENTER", cfg.pos.af or UIParent, cfg.pos.a2 or "CENTER", cfg.pos.x or 0, cfg.pos.y or 0)
    else
      f:SetPoint("CENTER",UIParent,"CENTER",0,0)
    end
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
    applyMoveFunctionality(f,cfg)      
  end
  
  --SPAWN HealthOrb FUNCTION
  function rBBS:spawnHealthOrb(opener, cfg)
    --add the name of the opener addon to the frame name
    if cfg.name then cfg.name = opener.."_"..cfg.name end
    --create frame based on given config settings
    local f = CreateFrame("Button", cfg.name or nil, cfg.parent or UIParent, cfg.inherit or "SecureUnitButtonTemplate")
    --print(f:GetName().." loaded.")
    --save movable and sizable to the frame object
    f.movable = cfg.movable or false
    f.type = "healthorb"
    f.classcolored = cfg.classcolored
    createPlayerClickFrame(f)
    --frame strata
    f:SetFrameStrata(cfg.strata or "LOW") 
    --framelevel
    f:SetFrameLevel(cfg.level or 1) 
    --size
    f:SetSize(cfg.size or 100, cfg.size or 100)
    --save the width/height ratio in case frame gets resized
    f.ratio = 1
    --alpha
    if cfg.alpha then f:SetAlpha(cfg.alpha or 1) end
    --scale
    if cfg.scale then f:SetScale(cfg.scale or 1) end
    --setpoint
    if cfg.pos then
      f:SetPoint(cfg.pos.a1 or "CENTER", cfg.pos.af or UIParent, cfg.pos.a2 or "CENTER", cfg.pos.x or 0, cfg.pos.y or 0)
    else
      f:SetPoint("CENTER",UIParent,"CENTER",0,0)
    end
    
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
    if playerColor and f.classcolored then
      h:SetVertexColor(playerColor.r, playerColor.g, playerColor.b)
    elseif cfg.color then
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
        m.cfg.r = playerColor.r
        m.cfg.g = playerColor.g
        m.cfg.b = playerColor.b
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
    applyMoveFunctionality(f,cfg)
    
    --register events
    f:RegisterEvent("UNIT_HEALTH")
    f:RegisterEvent("PLAYER_ENTERING_WORLD")
    --event
    f:SetScript("OnEvent", updateHealth)
  end
  
  
  --SPAWN PowerOrb FUNCTION
  function rBBS:spawnPowerOrb(opener, cfg)
    --add the name of the opener addon to the frame name
    if cfg.name then cfg.name = opener.."_"..cfg.name end
    --create frame based on given config settings
    local f = CreateFrame("Frame", cfg.name or nil, cfg.parent or UIParent, cfg.inherit or nil)
    --print(f:GetName().." loaded.")
    --save movable and sizable to the frame object
    f.movable = cfg.movable or false
    f.type = "powerorb"
    f.powertypecolored = cfg.powertypecolored
    --frame strata
    f:SetFrameStrata(cfg.strata or "LOW") 
    --framelevel
    f:SetFrameLevel(cfg.level or 1) 
    --size
    f:SetSize(cfg.size or 100, cfg.size or 100)
    --save the width/height ratio in case frame gets resized
    f.ratio = 1
    --alpha
    if cfg.alpha then f:SetAlpha(cfg.alpha or 1) end
    --scale
    if cfg.scale then f:SetScale(cfg.scale or 1) end
    --setpoint
    if cfg.pos then
      f:SetPoint(cfg.pos.a1 or "CENTER", cfg.pos.af or UIParent, cfg.pos.a2 or "CENTER", cfg.pos.x or 0, cfg.pos.y or 0)
    else
      f:SetPoint("CENTER",UIParent,"CENTER",0,0)
    end
    
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
    applyMoveFunctionality(f,cfg)
    
    --register events
    f:RegisterEvent("UNIT_POWER")
    f:RegisterEvent("UNIT_MAXPOWER")
    f:RegisterEvent("PLAYER_ENTERING_WORLD")
    f:RegisterEvent("UPDATE_SHAPESHIFT_FORM")
    --event
    f:SetScript("OnEvent", updatePower)
  end
  ---------------------------------
  -- SLASH COMMAND
  ---------------------------------
  
  --slash command functionality
  local function SlashCmd(cmd)    
    if (cmd:match"unlock") then
      unlockAllFrames()
    elseif (cmd:match"lock") then
      lockAllFrames()
    else
      print("|c0033AAFFrBBS command list:|r")
      print("|c0033AAFF\/rBBS lock|r, to lock")
      print("|c0033AAFF\/rBBS unlock|r, to unlock")
    end
  end

  SlashCmdList["rbbs"] = SlashCmd;
  SLASH_rbbs1 = "/rbbs";  
  print("|c0033AAFFrBBS loaded.|r")
  print("|c0033AAFF\/rBBS|r to display the command list")
  
  ---------------------------------
  -- REGISTER
  ---------------------------------
  
  _G["rBBS"] = rBBS
  