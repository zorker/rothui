
  --get the addon namespace
  local addon, ns = ...

  --get the config values
  local cfg = ns.cfg

  ---------------------------------------
  -- CONSTANTS
  ---------------------------------------

  local _G = _G

  local BuffFrame               = _G["BuffFrame"]
  local TemporaryEnchantFrame   = _G["TemporaryEnchantFrame"]
  local ConsolidatedBuffs       = _G["ConsolidatedBuffs"]
  
  --classcolor
  local classcolor = RAID_CLASS_COLORS[select(2, UnitClass("player"))]
  
  if cfg.color.classcolored then
    cfg.color.normal = classcolor
  end
  
  if cfg.background.classcolored then
    cfg.background.shadowcolor = classcolor
  end
  
  --backdrop
  local backdrop = { 
    bgFile = "", 
    edgeFile = cfg.textures.outer_shadow,
    tile = false,
    tileSize = 32, 
    edgeSize = cfg.background.inset, 
    insets = { 
      left = cfg.background.inset, 
      right = cfg.background.inset, 
      top = cfg.background.inset, 
      bottom = cfg.background.inset,
    },
  }

  ---------------------------------------
  -- FUNCTIONS
  ---------------------------------------
  
  --allows frames to become movable but frames can be locked or set to default positions
  local applyDragFunctionality = function(f,userplaced,locked)
    f:SetScript("OnDragStart", function(s) if IsAltKeyDown() and IsShiftKeyDown() then s:StartMoving() end end)
    f:SetScript("OnDragStop", function(s) s:StopMovingOrSizing() end)
    
    local t = f:CreateTexture(nil,"OVERLAY",nil,6)
    t:SetAllPoints(f)
    t:SetTexture(0,1,0)
    t:SetAlpha(0)
    f.dragtexture = t    
    f:SetHitRectInsets(-15,-15,-15,-15)
    f:SetClampedToScreen(true)
    
    if not userplaced then
      f:SetMovable(false)
    else
      f:SetMovable(true)
      f:SetUserPlaced(true)
      if not locked then
        f.dragtexture:SetAlpha(0.2)
        f:EnableMouse(true)
        f:RegisterForDrag("LeftButton")
        f:SetScript("OnEnter", function(s) 
          GameTooltip:SetOwner(s, "ANCHOR_TOP")
          GameTooltip:AddLine(s:GetName(), 0, 1, 0.5, 1, 1, 1)
          GameTooltip:AddLine("Hold down ALT+SHIFT to drag!", 1, 1, 1, 1, 1, 1)
          GameTooltip:Show()
        end)
        f:SetScript("OnLeave", function(s) GameTooltip:Hide() end)
      else
        f.dragtexture:SetAlpha(0)
        f:EnableMouse(nil)
        f:RegisterForDrag(nil)
        f:SetScript("OnEnter", nil)
        f:SetScript("OnLeave", nil)
      end
    end  
  end

  --update buff anchors
  local updateBuffAnchors = function()
    --print(BUFF_ACTUAL_DISPLAY)
    local numBuffs = 0
    local buff, previousBuff, aboveBuff
    for i = 1, BUFF_ACTUAL_DISPLAY do
      buff = _G["BuffButton"..i]
      buff:SetParent(BuffFrame)
      buff.consolidated = nil
      buff.parent = BuffFrame
      buff:ClearAllPoints()
      numBuffs = numBuffs + 1
      index = numBuffs
      if ((index > 1) and (mod(index, cfg.buffframe.buffsPerRow) == 1)) then
        buff:SetPoint("TOP", aboveBuff, "BOTTOM", 0, -cfg.buffframe.rowSpacing)
        aboveBuff = buff
      elseif (index == 1) then
        buff:SetPoint("TOPRIGHT", BuffFrame, "TOPRIGHT", 0, 0)
        aboveBuff = buff
      else
        buff:SetPoint("RIGHT", previousBuff, "LEFT", -cfg.buffframe.colSpacing, 0)
      end
      previousBuff = buff      
    end    
  end

  --update debuff anchors
  local updateDebuffAnchors = function(buttonName,index)

    local numBuffs = BUFF_ACTUAL_DISPLAY
    local rows = ceil(numBuffs/cfg.buffframe.buffsPerRow)
    local gap = cfg.buffframe.gap
    if rows == 0 then gap = 0 end
    local buff = _G[buttonName..index]
    -- Position debuffs
    if ((index > 1) and (mod(index, cfg.buffframe.buffsPerRow) == 1)) then
      buff:SetPoint("TOP", _G[buttonName..(index-cfg.buffframe.buffsPerRow)], "BOTTOM", 0, -cfg.buffframe.rowSpacing)
    elseif (index == 1) then
      buff:SetPoint("TOPRIGHT", BuffFrame, "TOPRIGHT", 0, -(rows*(cfg.buffframe.rowSpacing+buff:GetHeight())+gap))
    else
      buff:SetPoint("RIGHT", _G[buttonName..(index-1)], "LEFT", -cfg.buffframe.colSpacing, 0)
    end    
  
  end

  --update wpn enchant icon positions
  local updateTempEnchantAnchors = function()
    local previousBuff
    for i=1, NUM_TEMP_ENCHANT_FRAMES do
      local b = _G["TempEnchant"..i]
      if b then
        if (i == 1) then
          b:SetPoint("TOPRIGHT", TemporaryEnchantFrame, "TOPRIGHT", 0, 0)
        else
          b:SetPoint("RIGHT", previousBuff, "LEFT", -cfg.tempenchant.colSpacing, 0)
        end
        previousBuff = b
      end
    end
  end

  --create drag frame for temp enchant icons
  local function createTempEnchantHolder()
    local f = CreateFrame("Frame", "rBFS_TempEnchantHolder", UIParent)
    f:SetSize(50,50)
    f:SetPoint(cfg.tempenchant.pos.a1,cfg.tempenchant.pos.af,cfg.tempenchant.pos.a2,cfg.tempenchant.pos.x,cfg.tempenchant.pos.y)
    applyDragFunctionality(f,cfg.tempenchant.userplaced,cfg.tempenchant.locked)    
  end
  createTempEnchantHolder()
  
  --create drag frame for buff icons
  local function createBuffFrameHolder()
    local f = CreateFrame("Frame", "rBFS_BuffFrameHolder", UIParent)
    f:SetSize(50,50)
    f:SetPoint(cfg.buffframe.pos.a1,cfg.buffframe.pos.af,cfg.buffframe.pos.a2,cfg.buffframe.pos.x,cfg.buffframe.pos.y)
    applyDragFunctionality(f,cfg.buffframe.userplaced,cfg.buffframe.locked)    
  end
  createBuffFrameHolder()

  --move tempenchant frame
  local moveTempEnchantFrame = function()
    local f = _G["rBFS_TempEnchantHolder"]
    TemporaryEnchantFrame:SetParent(f)
    TemporaryEnchantFrame:ClearAllPoints()
    TemporaryEnchantFrame:SetPoint("TOPRIGHT",0,0)
  end
  
  --move buff frame
  local moveBuffFrame = function()
    local f = _G["rBFS_BuffFrameHolder"]
    BuffFrame:SetParent(f)
    BuffFrame:ClearAllPoints()
    BuffFrame:SetPoint("TOPRIGHT",0,0)
  end

  --check duration
  local function durationSetText(duration, arg1, arg2)
    duration:SetText(format(string.gsub(arg1, " ", ""), arg2))
  end

  --apply aura frame texture func
  local function applySkin(b,button,type)
    if b then
      
      --print(button)
      
      local border = _G[button.."Border"]      
      if border then
        border:SetTexture(cfg.textures.normal)
        border:SetTexCoord(0,1,0,1)
        border:SetDrawLayer("BACKGROUND",-7)
        if type == "wpn" then
          border:SetVertexColor(0.7,0,1)
        end
        border:ClearAllPoints()
        border:SetAllPoints(b)
        b.Border = border
      else
        --create border (for buff icons)
        local new = b:CreateTexture(nil,"BACKGROUND",nil,-7)
        new:SetAllPoints(b)
        new:SetTexture(cfg.textures.normal)
        new:SetVertexColor(cfg.color.normal.r,cfg.color.normal.g,cfg.color.normal.b)
        b.Border = border
      end
      
      --icon
      local icon = _G[button.."Icon"]
      icon:SetTexCoord(0.1,0.9,0.1,0.9)
      icon:SetPoint("TOPLEFT", b, "TOPLEFT", 2, -2)
      icon:SetPoint("BOTTOMRIGHT", b, "BOTTOMRIGHT", -2, 2)
      icon:SetDrawLayer("BACKGROUND",-8)
      
      --duration
      b.duration:SetFont(cfg.font, cfg.duration.fontsize, "THINOUTLINE")
      b.duration:ClearAllPoints()
      b.duration:SetPoint(cfg.duration.pos.a1,cfg.duration.pos.x,cfg.duration.pos.y)
      
      --hook duration settext
      hooksecurefunc(b.duration, "SetFormattedText", durationSetText)

      --count
      b.count:SetFont(cfg.font, cfg.count.fontsize, "THINOUTLINE")
      b.count:ClearAllPoints()
      b.count:SetPoint(cfg.count.pos.a1,cfg.count.pos.x,cfg.count.pos.y)
      
      --shadow
      if cfg.background.showshadow then
        local back = CreateFrame("Frame", nil, b)
        back:SetPoint("TOPLEFT", b, "TOPLEFT", -4, 4)
        back:SetPoint("BOTTOMRIGHT", b, "BOTTOMRIGHT", 4, -4)
        back:SetFrameLevel(b:GetFrameLevel()-1)        
        back:SetBackdrop(backdrop)
        back:SetBackdropBorderColor(cfg.background.shadowcolor.r,cfg.background.shadowcolor.g,cfg.background.shadowcolor.b,cfg.background.shadowcolor.a)
      end
      
      --set button styled variable
      b.styled = true
            
    end
  end

  --check auras func
  local function checkauras()
    --scan for buffs
    for i=1, BUFF_MAX_DISPLAY do    
      local b = _G["BuffButton"..i]    
      if b and not b.styled then
        applySkin(b,"BuffButton"..i,"buff")
      end
    end
    --scan for debuffs
    for i=1, DEBUFF_MAX_DISPLAY do
      local b = _G["DebuffButton"..i]
      if b and not b.styled then
        applySkin(b,"DebuffButton"..i,"debuff")
      end
    end    
  end

  --init func
  local function init()
    
    --BuffFrame scale
    BuffFrame:SetScale(cfg.buffframe.scale)
    --temp enchantframe scale
    TemporaryEnchantFrame:SetScale(cfg.tempenchant.scale)
    
    --position buff frame
    moveBuffFrame()
        
    --position temp enchant icons
    moveTempEnchantFrame()

    --skin temp enchant
    for i=1, NUM_TEMP_ENCHANT_FRAMES do
      local b = _G["TempEnchant"..i]
      if b and not b.styled then
        applySkin(b,"TempEnchant"..i, "wpn")
      end
    end
    
    --move temp enchant icons in position
    updateTempEnchantAnchors()

    --hook the consolidatedbuffs
    if ConsolidatedBuffs then
      ConsolidatedBuffs:UnregisterAllEvents()
      ConsolidatedBuffs:HookScript("OnShow", function(s)
        s:Hide()
        moveTempEnchantFrame()
      end)
      ConsolidatedBuffs:HookScript("OnHide", function(s)
        moveTempEnchantFrame()
      end)
      ConsolidatedBuffs:Hide()
    end
    
  end

  ---------------------------------------
  -- CALLS // HOOKS
  ---------------------------------------

  --hook Blizzard functions to move the buffframe
  hooksecurefunc("BuffFrame_UpdateAllBuffAnchors",    updateBuffAnchors)
  hooksecurefunc("DebuffButton_UpdateAnchors",        updateDebuffAnchors)

  --disable consolidated buffs
  SetCVar("consolidateBuffs", 0)

  local a = CreateFrame("Frame")

  a:SetScript("OnEvent", function(self, event, ...)
    local unit = ...
    if(event=="PLAYER_ENTERING_WORLD") then
      init()
      checkauras()
    end
    if (event=="UNIT_AURA") then
      if (unit == PlayerFrame.unit) then
        checkauras()
      end
    end
  end)

  a:RegisterEvent("PLAYER_ENTERING_WORLD")
  a:RegisterEvent("UNIT_AURA")