  
  -- // rRaidFlare
  -- // zork - 2011
  
  -----------------------------
  -- INIT
  -----------------------------
  
  --get the addon namespace
  local addon, ns = ...
  
  --generate the config table object
  local cfg = {}
  
  -----------------------------
  -- CONSTANTS
  -----------------------------
  
  local raidIconPath =  "interface\\targetingframe\\ui-raidtargetingicons"
  local clearIconPath = "interface\\glues\\loadingscreens\\dynamicelements"
  
  -----------------------------
  -- CONFIG
  -----------------------------
  
  --bar settings
  cfg.bar = {
    scale     = 1,
    pos       = { a1 = "CENTER", a2 = "CENTER", af = "UIParent", x = 0, y = 0 }, 
    partyonly = true,
  }
  
  --general button settings
  cfg.buttons = {
    size      = 20,
    margin    = 5,   
  }
  
  --flare buttons
  cfg.button = {}  
  cfg.button[1] = {
    coord     = { l=0.25, r=0.5, t=0.25, b=0.5 }, --settexcoord: left, right, top, bottom
    texture   = raidIconPath,
    name      = "Blue",
  }
  cfg.button[2] = {
    coord     = { l=0.75, r=1, t=0, b=0.25 },
    texture   = raidIconPath,
    name      = "Green",
  }
  cfg.button[3] = {
    coord     = { l=0.5, r=0.75, t=0, b=0.25 },
    texture   = raidIconPath,
    name      = "Purple",
  }
  cfg.button[4] = {
    coord     = { l=0.5, r=0.75, t=0.25, b=0.5 },
    texture   = raidIconPath,
    name      = "Red",
  }
  cfg.button[5] = {
    coord     = { l=0, r=0.25, t=0, b=0.25 },
    texture   = raidIconPath,
    name      = "White",
  }
  cfg.button[6] = {
    coord     = { l=0, r=0.5, t=0, b=0.5 },
    texture   = clearIconPath,
    name      = "Clear",
  }
  
  -----------------------------
  -- FUNCTIONS
  -----------------------------

  --create button func  
  local createFlareButton = function(id,bar)
    
    --button config
    local bc = cfg.button[id]
    
    --button
    local b = CreateFrame("Button", nil, bar, "SecureActionButtonTemplate")
    b:SetSize(cfg.buttons.size,cfg.buttons.size)
	  b:SetNormalTexture(bc.texture)
	  b:GetNormalTexture():SetTexCoord(bc.coord.l,bc.coord.r,bc.coord.t,bc.coord.b)
	  b.name = bc.name
	  b.id = id
    
    --macro attribute
	  b:SetAttribute("type", "macro")
	  b:SetAttribute("macrotext1", "/click CompactRaidFrameManagerDisplayFrameLeaderOptionsRaidWorldMarkerButton\n/click DropDownList1Button"..id)
	  
	  --background
	  local bg = b:CreateTexture(nil,"BACKGROUND",nil,-8)
    bg:SetTexture(0,0,0,0.5)
    bg:SetAllPoints(b)
    b.bg = bg
	  
	  --tooltip
    b:SetScript("OnEnter", function(s) 
      GameTooltip:SetOwner(s, "ANCHOR_TOP")
      if s.id == 6 then
        GameTooltip:AddLine("ClearButton", 0, 1, 0.5, 1, 1, 1)
        GameTooltip:AddLine("Click to clear the raid flares.", 1, 1, 1, 1, 1, 1)
      else
        GameTooltip:AddLine(s.name.."Flare", 0, 1, 0.5, 1, 1, 1)
        GameTooltip:AddLine("Click to create a "..s.name.." flare on the ground.", 1, 1, 1, 1, 1, 1)      
      end
      GameTooltip:Show()
    end)
    b:SetScript("OnLeave", function(s) GameTooltip:Hide() end)
  
    return b
  
  end

  --create bar frame func
  local createFlareBar = function()
  
    --variables
    local numRaidMarkerButtons = 6
  
    --create the holder frame
    local bar = CreateFrame("Frame","rRaidWorldMarkerBar",UIParent, "SecureHandlerStateTemplate")
    bar:SetSize(numRaidMarkerButtons*cfg.buttons.margin+numRaidMarkerButtons*cfg.buttons.size+cfg.buttons.margin,cfg.buttons.size+cfg.buttons.margin*2)
    bar:SetPoint(cfg.bar.pos.a1,cfg.bar.pos.af,cfg.bar.pos.a2,cfg.bar.pos.x,cfg.bar.pos.y)
    bar:SetScale(cfg.bar.scale)
      
    --background
	  local bg = bar:CreateTexture(nil,"BACKGROUND",nil,-8)
    bg:SetTexture(0,0,0,0.5)
    bg:SetAllPoints(bar)
    bar.bg = bg

    local button = {}
    local i  
    --create all the buttons
    for i=1,numRaidMarkerButtons do
      button[i] = createFlareButton(i,bar)
      if i = 1 then
        button[i]:SetPoint("LEFT",cfg.buttons.margin,0)
      else
        button[i]:SetPoint("LEFT",button[i-1],"RIGHT",cfg.buttons.margin,0)
      end
    end
    
    return bar
    
  end  

  --apply drag functionality func
  local function applyDragFunctionality (f,userplaced,locked)
    --green overlay texture
    local t = f:CreateTexture(nil,"OVERLAY",nil,6)
    t:SetAllPoints(f)
    t:SetTexture(0,1,0)
    f.dragtexture = t    
    --stuff
    f.unlocked = false
    f:SetHitRectInsets(-15,-15,-15,-15)
    f:SetClampedToScreen(true)
    f:SetMovable(true)
    f:SetUserPlaced(true)
    f.dragtexture:SetAlpha(0)
    f:EnableMouse(nil)
    f:RegisterForDrag(nil)
    f:SetScript("OnEnter", nil)
    f:SetScript("OnLeave", nil)
    f:SetScript("OnDragStart", function(s) if IsAltKeyDown() and IsShiftKeyDown() then s:StartMoving() end end)
    f:SetScript("OnDragStop", function(s) s:StopMovingOrSizing() end)
  end
  
  --unlock frame func
  local function unlockFrame(f)
    if f and f:IsUserPlaced() then
      f.dragtexture:SetAlpha(0.5)
      f:EnableMouse(true)
      f:RegisterForDrag("LeftButton")
      f:SetScript("OnEnter", function(s)
        GameTooltip:SetOwner(s, "ANCHOR_TOP")
        GameTooltip:AddLine(s:GetName(), 0, 1, 0.5, 1, 1, 1)
        GameTooltip:AddLine("Hold down ALT+SHIFT to drag!", 1, 1, 1, 1, 1, 1)
        GameTooltip:Show()
      end)
      f:SetScript("OnLeave", function(s) GameTooltip:Hide() end)
      f.unlocked = true
      f.checkStatus(f)
    end
  end
 
  --lock frame func
  local function lockFrame(f)
    if f and f:IsUserPlaced() then
      f.dragtexture:SetAlpha(0)
      f:EnableMouse(nil)
      f:RegisterForDrag(nil)
      f:SetScript("OnEnter", nil)
      f:SetScript("OnLeave", nil)
      f.unlocked = false
      f.checkStatus(f)
    end
  end
  
  --checkstatus func
  local checkStatus = function(self)
    if self.unlocked then
      self:Show()
      return
    end
    if cfg.bar.partyonly and (GetNumRaidMembers() + GetNumPartyMembers() == 0) then
      --hide bar out of party/raid
      self:Hide()
      return
    end 
    if InCombatLockdown() then
      --hide bar in combat
      self:Hide()
      return    
    end
    self:Show()
  end
  
  --init func
  local init = function()
  
    --in case some events should be traced
    local bar = createFlareBar()
    
    --apply the drag functionality
    applyDragFunctionality(bar,true,true)
    
    --hook the unlock and lock functions to make it available in the slash command function
    bar.lockFrame   = lockFrame
    bar.unlockFrame = unlockFrame
    bar.checkStatus = checkStatus
    
    --hook events
    bar:RegisterEvent("PLAYER_ENTERING_WORLD")
    bar:RegisterEvent("PLAYER_REGEN_DISABLED")
    bar:RegisterEvent("PLAYER_REGEN_ENABLED")
    bar:RegisterEvent("PARTY_MEMBERS_CHANGED")
    bar:SetScript("OnEvent", checkStatus)  
  
  end
  
  
  -----------------------------
  -- CALL
  -----------------------------
  
  init()

  -----------------------------
  -- SLASH COMMAND FUNCTION
  -----------------------------

  -- the slash command function to handle the /rflare slash command
  local function SlashCmd(cmd)    
    local f = _G["rRaidWorldMarkerBar"]
    if (cmd:match"unlock") then
      if f then f.unlockFrame(f) end
    elseif (cmd:match"lock") then
      if f then f.lockFrame(f) end
    else
      print("|c00FFAA00Command list:|r")
      print("|c00FFAA00\/rflare lock|r, to lock")
      print("|c00FFAA00\/rflare unlock|r, to unlock")
    end
  end
 
  SlashCmdList["/rflare"] = SlashCmd;
  SLASH_/rflare1 = "/rflare";
 
  print("|c00FFAA00rFlare loaded.|r")
  print("|c00FFAA00\/rflare|r to display the command list")