
  -- TEMPLATE LAYOUT - roth 2009
  
  -----------------------------------------------------------------
  -- CONFIG AREA
  -----------------------------------------------------------------
  
  --statusbar
  local mytexture = "Interface\\TargetingFrame\\UI-StatusBar"
  --font
  local myfont = "FONTS\\FRIZQT__.ttf" 
  
  -----------------------------------------------------------------
  -- FUNCTIONS
  -----------------------------------------------------------------

  --chat output func for debugg
  local function am(text)
    DEFAULT_CHAT_FRAME:AddMessage(text)
  end
    
  local function setConfigValues(w,h,hh,s)
    self.width = w
    self.height = h
    self.healthheight = hh
    self.scale = s
  end
    
  --initSelf func
  local function initSelf(self)
    self:SetAttribute("initial-height", self.height)
    self:SetAttribute("initial-width", self.width)
    self:SetAttribute("initial-scale", self.scale)
    self:SetPoint("CENTER",UIParent,"CENTER",0,0)
  end  
  
  --set fontstring
  local function setFontString(parent, name, size, outline)
    local fs = parent:CreateFontString(nil, "OVERLAY")
    fs:SetFont(name, size, outline)
    fs:SetShadowColor(0,0,0,1)
    return fs
  end
  
  --create health bar
  local function createHealthFrames(self,unit)
    local f = CreateFrame("StatusBar", nil, self)
    f:SetStatusBarTexture(mytexture)
    f:SetHeight(self.height*2/3)
    f:SetWidth(self.width)
    f:SetPoint("TOP",0,0)
    self.Health = f
    --bg
    local bg = self.Health:CreateTexture(nil, "BACKGROUND")
    bg:SetTexture(mytexture)
    bg:ClearAllPoints()
    bg:SetAllPoints(self.Health)
    self.Health.bg = bg
  end
  
  --create power bar
  local function createPowerFrames(self,unit)
    local f = CreateFrame("StatusBar", nil, self)
    f:SetStatusBarTexture(mytexture)
    f:SetWidth(self.width)
    --this will make the power frame be under the healthbar, height is calculated automatically
    f:SetPoint("TOP", self.Health, "BOTTOM", 0, -3)
    f:SetPoint("BOTTOM",0,0)
    self.Power = f
    --bg
    local bg = self.Power:CreateTexture(nil, "BACKGROUND")
    bg:SetTexture(mytexture)
    bg:SetAllPoints(self.Power)
    self.Power.bg = bg
  end
  
  --create portraits func
  local function createPortraits(self,unit)    
    local ph = CreateFrame("Frame",nil,self)
    ph:SetPoint("RIGHT", self, "LEFT", -5, 0)
    ph:SetWidth(self.height)
    ph:SetHeight(self.height)
    self.Portrait = CreateFrame("PlayerModel", nil, ph)
    self.Portrait:SetAllPoints(ph)
  end
  
  --function to make stuff movable with SHIFT+ALT+DRAG
  local function moveFunc(f)
    if allow_frame_movement == 0 then
      f:IsUserPlaced(false)
    else
      f:SetMovable(true)
      f:SetUserPlaced(true)
      if lock_all_frames == 0 then
        f:EnableMouse(true)
        f:RegisterForDrag("LeftButton","RightButton")
        f:SetScript("OnDragStart", function(self) if IsAltKeyDown() and IsShiftKeyDown() then self:StartMoving() end end)
        f:SetScript("OnDragStop", function(self) self:StopMovingOrSizing() end)
      end
    end  
  end
  
  
  local function createTextStrings(self,unit)
    --health/name text strings
    local name = setFontString(self.Health, myfont, 14, "THINOUTLINE")
    name:SetPoint("LEFT", self.Health, "LEFT", 2, 0)
    name:SetJustifyH("LEFT")
    
    local hpval = setFontString(self.Health, myfont, 14, "THINOUTLINE")
    hpval:SetPoint("RIGHT", self.Health, "RIGHT", -2, 0)
    --this will make the name go "..." when its to long
    name:SetPoint("RIGHT", hpval, "LEFT", -5, 0)
    
    self:Tag(name, "[name]")
    self:Tag(hpval, "[curhp]/[maxhp]|[perhp]%")
    
    --power/class text strings
    if self.Power then
      local classtext = setFontString(self.Power, myfont, 13, "THINOUTLINE")
      classtext:SetPoint("LEFT", self.Power, "LEFT", 2, 0)
      classtext:SetJustifyH("LEFT")
      
      local ppval = setFontString(self.Power, myfont, 13, "THINOUTLINE")
      ppval:SetPoint("RIGHT", self.Power, "RIGHT", -2, 0)
      --this will make the class go "..." when its to long
      classtext:SetPoint("RIGHT", ppval, "LEFT", -5, 0)
      
      self:Tag(classtext, "[level] [class]")
      self:Tag(ppval, "[curpp]/[maxpp]|[perpp]%")
    end
  end
  
  -----------------------------------------------------------------
  -- CUSTOM TAGS
  -----------------------------------------------------------------
  
  -- nothing yet
    
  -----------------------------------------------------------------
  -- CREATE STYLES
  -----------------------------------------------------------------
  
  --create the player style
  local function CreatePlayerStyle(self, unit)
    --width,height,healthheight,scale
    setConfigValues(250,50,35,1)
    initSelf(self)
    moveFunc(self)
    createHealthFrames(self,unit)
    self.Health.colorHealth = true
    createPowerFrames(self,unit)
    self.Power.colorPower = true
    createPortraits(self,unit)
    createTextStrings(self,unit)
  end  
    
  --create the target style
  local function CreateTargetStyle(self, unit)
    --width,height,healthheight,scale
    setConfigValues(250,50,35,1)
    initSelf(self)
    moveFunc(self)
    createHealthFrames(self,unit)
    self.Health.colorHealth = true
    createPowerFrames(self,unit)
    self.Power.colorPower = true
    createPortraits(self,unit)
    createTextStrings(self,unit)
  end  
  
  --create the focus and pet style
  local function CreateFocusStyle(self, unit)
    --width,height,healthheight,scale
    setConfigValues(200,50,35,1)
    initSelf(self)
    moveFunc(self)
    createHealthFrames(self,unit)
    self.Health.colorHealth = true
    createPowerFrames(self,unit)
    self.Power.colorPower = true
    createPortraits(self,unit)
    createTextStrings(self,unit)
  end  
  
  --create the tot style
  local function CreateToTStyle(self, unit)
    --width,height,healthheight,scale
    setConfigValues(150,50,35,1)
    initSelf(self)
    moveFunc(self)
    createHealthFrames(self,unit)
    self.Health.colorHealth = true
    createTextStrings(self,unit)
  end  

  -----------------------------------------------------------------
  -- REGISTER STYLES TO MATCH SPECIFIC FUNCTIONS
  -----------------------------------------------------------------

  oUF:RegisterStyle("oUF_Template_player",  CreatePlayerStyle)
  oUF:RegisterStyle("oUF_Template_target",  CreateTargetStyle)
  oUF:RegisterStyle("oUF_Template_focus",   CreateFocusStyle)
  oUF:RegisterStyle("oUF_Template_tot",     CreateToTStyle)
  oUF:RegisterStyle("oUF_Template_party",   CreatePartyStyle)
  
  -----------------------------------------------------------------
  -- SPAWN UNITS and ACTIVATE SPECIFIC STYLES
  -----------------------------------------------------------------
  
  oUF:SetActiveStyle("oUF_Template_target")
  oUF:Spawn("target","oUF_Template_TargetFrame")
  
  oUF:SetActiveStyle("oUF_Template_player")
  oUF:Spawn("player", "oUF_Template_PlayerFrame")
  
  oUF:SetActiveStyle("oUF_Template_focus")
  oUF:Spawn("focus", "oUF_Template_FocusFrame")
  oUF:Spawn("pet", "oUF_Template_PetFrame")
  
  oUF:SetActiveStyle("oUF_Template_tot")
  oUF:Spawn("targettarget", "oUF_Template_ToTFrame")
  oUF:Spawn("focustarget", "oUF_Template_FocusTargetFrame")
