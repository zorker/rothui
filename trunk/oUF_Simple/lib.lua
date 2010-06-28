  
  -- // oUF tutorial layout
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
  
  --backdrop table
  local backdrop_tab = { 
    bgFile = cfg.backdrop_texture, 
    edgeFile = cfg.backdrop_edge_texture,
    tile = false,
    tileSize = 0, 
    edgeSize = 5, 
    insets = { 
      left = 5, 
      right = 5, 
      top = 5, 
      bottom = 5,
    },
  }
  
  --backdrop func
  lib.gen_backdrop = function(f)
    f:SetBackdrop(backdrop_tab);
    f:SetBackdropColor(0,0,0,0.7)
    f:SetBackdropBorderColor(0,0,0,1)
  end
  
  --moveme func
  lib.moveme = function(f)
    if cfg.allow_frame_movement then
      f:SetMovable(true)
      f:SetUserPlaced(true)
      if not cfg.frames_locked then
        f:EnableMouse(true)
        f:RegisterForDrag("LeftButton","RightButton")
        f:SetScript("OnDragStart", function(self) if IsAltKeyDown() and IsShiftKeyDown() then self:StartMoving() end end)
        f:SetScript("OnDragStop", function(self) self:StopMovingOrSizing() end)
      end
    else
      f:IsUserPlaced(false)
    end  
  end  
  
  --init func
  lib.init = function(f)
    f:SetAttribute("initial-height", f.height)
    f:SetAttribute("initial-width", f.width)
    f:SetAttribute("initial-scale", f.scale)
    f:SetPoint("CENTER",UIParent,"CENTER",0,0)
  end  
  
  --fontstring func
  lib.gen_fontstring = function(f, name, size, outline)
    local fs = f:CreateFontString(nil, "OVERLAY")
    fs:SetFont(name, size, outline)
    fs:SetShadowColor(0,0,0,1)
    return fs
  end  
  
  --gen healthbar func
  lib.gen_hpbar = function(f)
    --statusbar
    local s = CreateFrame("StatusBar", nil, f)
    s:SetStatusBarTexture(cfg.statusbar_texture)
    s:SetHeight(f.height)
    s:SetWidth(f.width)
    s:SetPoint("CENTER",0,0)
    --helper
    local h = CreateFrame("Frame", nil, s)
    h:SetFrameLevel(0)
    h:SetPoint("TOPLEFT",-5,5)
    h:SetPoint("BOTTOMRIGHT",5,-5)
    lib.gen_backdrop(h)
    --bg
    local b = s:CreateTexture(nil, "BACKGROUND")
    b:SetTexture(cfg.statusbar_texture)
    b:SetAllPoints(s)
    f.Health = s
    f.Health.bg = b
  end
  
  --gen hp strings func
  lib.gen_hpstrings = function(f)
    --health/name text strings
    local name = lib.gen_fontstring(f.Health, cfg.font, 13, "THINOUTLINE")
    name:SetPoint("LEFT", f.Health, "LEFT", 2, 0)
    name:SetJustifyH("LEFT")
    
    local hpval = lib.gen_fontstring(f.Health, cfg.font, 13, "THINOUTLINE")
    hpval:SetPoint("RIGHT", f.Health, "RIGHT", -2, 0)
    --this will make the name go "..." when its to long
    name:SetPoint("RIGHT", hpval, "LEFT", -5, 0)
    
    f:Tag(name, "[name]")
    f:Tag(hpval, "[curhp]/[perhp]%")
  end
  
  --gen healthbar func
  lib.gen_ppbar = function(f)
    --statusbar
    local s = CreateFrame("StatusBar", nil, f)
    s:SetStatusBarTexture(cfg.statusbar_texture)
    s:SetHeight(f.height/5)
    s:SetWidth(f.width)
    s:SetPoint("TOP",f,"BOTTOM",0,-3)
    --helper
    local h = CreateFrame("Frame", nil, s)
    h:SetFrameLevel(0)
    h:SetPoint("TOPLEFT",-5,5)
    h:SetPoint("BOTTOMRIGHT",5,-5)
    lib.gen_backdrop(h)
    --bg
    local b = s:CreateTexture(nil, "BACKGROUND")
    b:SetTexture(cfg.statusbar_texture)
    b:SetAllPoints(s)
    f.Power = s
    f.Power.bg = b
  end

  
  -----------------------------
  -- HANDOVER
  -----------------------------
  
  --hand the lib to the namespace for further usage...this is awesome because you can reuse functions in any of your layout files
  ns.lib = lib