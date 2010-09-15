  
  -- // oUF D3Orbs 4.0
  -- // zork - 2010
  
  -----------------------------
  -- INIT
  -----------------------------
  
  --get the addon namespace
  local addon, ns = ...
  
  --get the config values
  local cfg = ns.cfg
  
  --holder for some lib functions
  local lib = CreateFrame("Frame")  
    
  -----------------------------
  -- FUNCTIONS
  -----------------------------
  
  --the menu when clicking on a unit
  lib.createUnitMenu = function(f)
    local unit = f.unit:sub(1, -2)
    local cunit = f.unit:gsub("(.)", string.upper, 1)
    if(unit == "party" or unit == "partypet") then
      ToggleDropDownMenu(1, nil, _G["PartyMemberFrame"..f.id.."DropDown"], "cursor", 0, 0)
    elseif(_G[cunit.."FrameDropDown"]) then
      ToggleDropDownMenu(1, nil, _G[cunit.."FrameDropDown"], "cursor", 0, 0)
    end
  end

  
  --initialize the unit paramters
  lib.initUnitParameters = function(f)
    f:SetAttribute("initial-height", f.config.height)
    f:SetAttribute("initial-width", f.config.width)
    f:SetAttribute("initial-scale", f.config.scale)
    f:SetPoint(f.config.pos.a1,f.config.pos.af,f.config.pos.a2,f.config.pos.x,f.config.pos.y)
    f.menu = lib.createUnitMenu(f)
    f:RegisterForClicks("AnyUp")
    f:SetAttribute("*type2", "menu")
    f:SetScript("OnEnter", UnitFrame_OnEnter)
    f:SetScript("OnLeave", UnitFrame_OnLeave)
    --lib.createBackdrop(f)
  end
  
  --number format func
  lib.numFormat = function(v)
    local string = ""
    if v > 1E6 then
      string = (floor((v/1E6)*10)/10).."m"
    elseif v > 1E3 then
      string = (floor((v/1E3)*10)/10).."k"
    else
      string = v
    end  
    return string
  end
  
  --fontstring func
  lib.createFontString = function(f, font, size, outline)
    local fs = f:CreateFontString(nil, "OVERLAY")
    fs:SetFont(font, size, outline)
    fs:SetShadowColor(0,0,0,1)
    return fs
  end  
  
  --create galaxy func
  lib.createGalaxy = function(f,x,y,size,duration,texture,sublevel)
  
    local t = f:CreateTexture(nil, "BACKGROUND", nil, sublevel)
    t:SetSize(size,size)
    t:SetPoint("CENTER",x,y)
    t:SetTexture("Interface\\AddOns\\rTextures\\"..texture)
    if f.type == "power" then
      t:SetVertexColor(0,0.3,1,1)
    else
      t:SetVertexColor(1,0,0,1)
    end
    t:SetBlendMode("ADD")
    
    local ag = t:CreateAnimationGroup()    
    local anim = ag:CreateAnimation("Rotation")
    anim:SetDegrees(360)
    anim:SetDuration(duration)    
    ag:Play()
    ag:SetLooping("REPEAT")
    
    return t
  
  end
  
  
  --create orb func
  lib.createOrb = function (f,type)
    local orb
    if type == "power" then
      orb = CreateFrame("StatusBar", "oUF_D3Orbs4PowerOrb", f)
    else
      orb = CreateFrame("StatusBar", "oUF_D3Orbs4HealthOrb", f)
    end
    orb.type = type
    --need to be transparent just need it for the math
    orb:SetStatusBarTexture("Interface\\AddOns\\rTextures\\orb_transparent")
    orb:SetHeight(f.config.height)
    orb:SetWidth(f.config.width)
    
    --actionbarbackground is at -8, make it be above that
    orb.back = orb:CreateTexture(nil, "BACKGROUND", nil, -7)
    orb.back:SetTexture("Interface\\AddOns\\rTextures\\orb_back2")
    orb.back:SetAllPoints(orb)
    --orb.back:SetBlendMode("BLEND")
    
    orb.Filling = orb:CreateTexture(nil, "BACKGROUND", nil, -6)
    orb.Filling:SetTexture("Interface\\AddOns\\rTextures\\orb_filling1")
    orb.Filling:SetAllPoints(orb)
    --orb.Filling:SetBlendMode("ADD")
    
    orb.galaxy = {}
    if type == "power" then
      orb.Filling:SetVertexColor(0,0.3,1,1)
      orb.galaxy[1] = lib.createGalaxy(orb,0,-10,f.config.width-0,60,"galaxy2",-5)
      orb.galaxy[2] = lib.createGalaxy(orb,-2,-10,f.config.width-20,32,"galaxy",-5)
      orb.galaxy[3] = lib.createGalaxy(orb,-4,-10,f.config.width-10,20,"galaxy3",-5)
    else
      orb.Filling:SetVertexColor(1,0,0,1)
      orb.galaxy[1] = lib.createGalaxy(orb,0,-10,f.config.width-0,60,"galaxy2",-5)
      orb.galaxy[2] = lib.createGalaxy(orb,2,-10,f.config.width-20,30,"galaxy",-5)
      orb.galaxy[3] = lib.createGalaxy(orb,4,-10,f.config.width-10,18,"galaxy3",-5)
    end
    
    orb.Gloss = orb:CreateTexture(nil, "BACKGROUND", nil, -4)
    orb.Gloss:SetTexture("Interface\\AddOns\\rTextures\\orb_gloss")
    orb.Gloss:SetAllPoints(orb)
    orb.Gloss:SetAlpha(1)
    --orb.Gloss:SetBlendMode("ADD")

    if type == "power" then
      --reset the power to be on the opposite side of the health orb
      orb:SetPoint(f.config.pos.a1,f.config.pos.af,f.config.pos.a2,f.config.pos.x*(-1),f.config.pos.y)
    else
      --position it in the center of the frame
      orb:SetPoint("CENTER",f,"CENTER",0,0)
    end
    
    return orb
    
  end
  
  --allows frames to become movable but frames can be locked or set to default positions
  lib.applyDragFunctionality = function(f)
    if not cfg.framesUserplaced then
      f:IsUserPlaced(false)
      return
    else
      f:SetMovable(true)
      f:SetUserPlaced(true)
      if not cfg.framesLocked then
        f:EnableMouse(true)
        f:RegisterForDrag("LeftButton","RightButton")
        f:SetScript("OnDragStart", function(s) if IsAltKeyDown() and IsShiftKeyDown() then s:StartMoving() end end)
        f:SetScript("OnDragStop", function(s) s:StopMovingOrSizing() end)
      end
    end  
  end
  
  --allows frames to become movable in any case
  lib.applyDragFunctionalityNoRestrict = function(f)
    f:SetMovable(true)
    f:SetUserPlaced(true)
    f:EnableMouse(true)
    f:RegisterForDrag("LeftButton","RightButton")
    f:SetScript("OnDragStart", function(s) if IsAltKeyDown() and IsShiftKeyDown() then s:StartMoving() end end)
    f:SetScript("OnDragStop", function(s) s:StopMovingOrSizing() end)
  end

  
  --background art behind buttons
  lib.createActionBarBackground = function(p)
  
    if not cfg.actionbarbackground.show then return end

    local f = CreateFrame("Frame","oUF_D3Orbs4_ActionBarBackground",p)
    f:SetWidth(512)
    f:SetHeight(256)
    f:SetPoint(cfg.actionbarbackground.pos.a1, cfg.actionbarbackground.pos.af, cfg.actionbarbackground.pos.a2, cfg.actionbarbackground.pos.x, cfg.actionbarbackground.pos.y)
    f:SetScale(cfg.actionbarbackground.scale)
    lib.applyDragFunctionality(f)
    local t = f:CreateTexture(nil,"BACKGROUND",nil,-8)
    t:SetAllPoints(f)    
    if cfg.usebar == 12 then
      t:SetTexture("Interface\\AddOns\\rTextures\\bar1")
    elseif cfg.usebar == 24 then
      t:SetTexture("Interface\\AddOns\\rTextures\\bar2")
    elseif cfg.usebar == 36 then
      t:SetTexture("Interface\\AddOns\\rTextures\\bar3")
    else
      if MultiBarBottomRight:IsShown() then
        t:SetTexture("Interface\\AddOns\\rTextures\\bar3")
      elseif MultiBarBottomLeft:IsShown() then
        t:SetTexture("Interface\\AddOns\\rTextures\\bar2")
      else
        t:SetTexture("Interface\\AddOns\\rTextures\\bar1")
      end
      MultiBarBottomRight:HookScript("OnShow", function() t:SetTexture("Interface\\AddOns\\rTextures\\bar3") end)
      MultiBarBottomRight:HookScript("OnHide", function() t:SetTexture("Interface\\AddOns\\rTextures\\bar2") end)
      MultiBarBottomLeft:HookScript("OnShow", function() t:SetTexture("Interface\\AddOns\\rTextures\\bar2") end)
      MultiBarBottomLeft:HookScript("OnHide", function() t:SetTexture("Interface\\AddOns\\rTextures\\bar1") end)
    end
  end

  --create the angel
  lib.createAngelFrame = function(p)
    if not cfg.angel.show then return end
    local f = CreateFrame("Frame","oUF_D3Orbs4_AngelFrame",p)
    f:SetWidth(320)
    f:SetHeight(160)
    f:SetPoint(cfg.angel.pos.a1, cfg.angel.pos.af, cfg.angel.pos.a2, cfg.angel.pos.x, cfg.angel.pos.y)
    f:SetScale(cfg.angel.scale)
    lib.applyDragFunctionality(f)
    local t = f:CreateTexture(nil,"BACKGROUND",nil,-3)
    t:SetAllPoints(f)
    t:SetTexture("Interface\\AddOns\\rTextures\\d3_angel2")
  end

  --create the demon
  lib.createDemonFrame = function(p)
    if not cfg.demon.show then return end
    local f = CreateFrame("Frame","oUF_D3Orbs4_DemonFrame",p)
    f:SetWidth(320)
    f:SetHeight(160)
    f:SetPoint(cfg.demon.pos.a1, cfg.demon.pos.af, cfg.demon.pos.a2, cfg.demon.pos.x, cfg.demon.pos.y)
    f:SetScale(cfg.demon.scale)
    lib.applyDragFunctionality(f)
    local t = f:CreateTexture(nil,"BACKGROUND",nil,-3)
    t:SetAllPoints(f)
    t:SetTexture("Interface\\AddOns\\rTextures\\d3_demon2")
  end

  --create the bottomline
  lib.createBottomLine = function(p)
    if not cfg.bottomline.show then return end
    local f = CreateFrame("Frame","oUF_D3Orbs4_BottomLine",p)
    f:SetWidth(500)
    f:SetHeight(112)
    f:SetPoint(cfg.bottomline.pos.a1, cfg.bottomline.pos.af, cfg.bottomline.pos.a2, cfg.bottomline.pos.x, cfg.bottomline.pos.y)
    f:SetScale(cfg.bottomline.scale)
    lib.applyDragFunctionality(f)
    local t = f:CreateTexture(nil,"BACKGROUND",nil,-2)
    t:SetAllPoints(f)
    t:SetTexture("Interface\\AddOns\\rTextures\\d3_bottom")
  end

  --backdrop func
  lib.createBackdrop = function(f)
    f:SetBackdrop(cfg.backdrop);
    f:SetBackdropColor(0,0,0,0.7)
    f:SetBackdropBorderColor(0,0,0,1)
  end
  
  -----------------------------
  -- HANDOVER
  -----------------------------
  
  --hand the lib to the namespace for further usage...this is awesome because you can reuse functions in any of your layout files
  ns.lib = lib