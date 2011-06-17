
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

  ---------------------------------
  -- FUNCTIONS
  ---------------------------------

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
    end
  end
  
  local createOrbValues = function(f,cfg)
    local h = CreateFrame("FRAME", nil, f)
    h:SetAllPoints(f)
    f.vc = 130
    local v1 = createFontString(h, cfg.font or "FONTS\\FRIZQT__.ttf", f:GetWidth()*32/f.vc, "THINOUTLINE")
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
    f:EnableMouse(nil)
    f.locked = true
    f.dragtexture:SetAlpha(0)
    f:RegisterForDrag(nil)
    f:SetScript("OnEnter", nil)
    f:SetScript("OnLeave", nil)
    f:SetScript("OnDragStart", nil)
    f:SetScript("OnDragStop", nil)
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
      f.v1:SetFont(font,f:GetWidth()*32/f.vc,flag)
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
    local f = CreateFrame("Frame", cfg.name or nil, cfg.parent or UIParent, cfg.inherit or nil)
    --print(f:GetName().." loaded.")
    --save movable and sizable to the frame object
    f.movable = cfg.movable or false
    f.type = "healthorb"
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
      h:SetVertexColor(1,0,0,1)
    end    
    f.filling = h
    
    --gloss
    local g = f:CreateTexture(nil, "BACKGROUND", nil, -2)
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
    
    --gloss
    local g = f:CreateTexture(nil, "BACKGROUND", nil, -2)
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
  