
  -- // rWeaponEnchant
  -- // zork - 2010

  --get the addon namespace
  local addon, ns = ...  
  
  --get the config
  local cfg = ns.cfg  
  
  local tempEnchantList = cfg.tempEnchantList
  
  local mainhand, offhand, throw
  
  -----------------------------
  -- FUNCTIONS
  -----------------------------
  
  --format time func
  local GetFormattedTime = function(time)
    local hr, m, s, text
    if time <= 0 then text = ""
    elseif(time < 3600 and time > 60) then
      hr = floor(time / 3600)
      m = floor(mod(time, 3600) / 60 + 1)
      text = format("%dm", m)
    elseif time < 60 then
      m = floor(time / 60)
      s = mod(time, 60)
      text = (m == 0 and format("%ds", s))
    else
      hr = floor(time / 3600 + 1)
      text = format("%dh", hr)
    end
    return text
  end

  --allows frames to become movable
  local applyDragFunctionality = function(f)
    if not cfg.framesUserplaced then
      f:IsUserPlaced(false)
      return
    else
      f:SetMovable(true)
      f:SetUserPlaced(true)
      f:EnableMouse(true)
      if not cfg.framesLocked then
        f:RegisterForDrag("LeftButton")
        f:SetScript("OnDragStart", function(s) 
          --if IsShiftKeyDown() then 
            s:StartMoving() 
          --end
        end)
        f:SetScript("OnDragStop", function(s) 
          s:StopMovingOrSizing() 
        end)
      end
      f:SetScript("OnEnter", function(s) 
        if s.state then
          GameTooltip:SetOwner(s, "ANCHOR_BOTTOMLEFT")
          GameTooltip:SetInventoryItem("player", s.slotid)
          GameTooltip:Show()
        end
      end)
      f:SetScript("OnLeave", function(s) 
        GameTooltip:Hide() 
      end)
      --[[
      --keep this in case canceling temp enchants is possible in future
      f:SetScript("onMouseDown", function(s) 
        if not IsShiftKeyDown() then 
          if s.state and s.slotid == 16 then
            CancelItemTempEnchantment(1)
            print('click '..s.slotid)
          elseif s.state and s.slotid == 17 then
            CancelItemTempEnchantment(2)
          elseif s.state and s.slotid == 18 then
            CancelItemTempEnchantment(3)
          end
        end
      end)
      ]]--
    end  
  end
  
  
  local createIcon = function(listentry,type)
  
    local f = CreateFrame("FRAME","rWpnEnch"..type.."Icon",UIParent)
    f:SetSize(listentry.size,listentry.size)
    f:SetPoint(listentry.pos.a1,listentry.pos.af,listentry.pos.a2,listentry.pos.x,listentry.pos.y)

    if type == "Mainhand" then
		  f.slotid = GetInventorySlotInfo("MainHandSlot")
    elseif type == "Offhand" then
      f.slotid = GetInventorySlotInfo("SecondaryHandSlot")
    else
      f.slotid = GetInventorySlotInfo("RangedSlot")
    end
    
    applyDragFunctionality(f)
    
    local w = listentry.size
    
    local gl = f:CreateTexture(nil, "BACKGROUND",nil,-8)
    gl:SetPoint("TOPLEFT",f,"TOPLEFT",-w*3/32,w*3/32)
    gl:SetPoint("BOTTOMRIGHT",f,"BOTTOMRIGHT",w*3/32,-w*3/32)
    gl:SetTexture("Interface\\AddOns\\rTextures\\simplesquare_glow")
    gl:SetVertexColor(0, 0, 0, 1)

    local ba = f:CreateTexture(nil, "BACKGROUND",nil,-7)
    ba:SetAllPoints(f)
    ba:SetTexture("Interface\\AddOns\\rTextures\\d3portrait_back2")
    
    local t = f:CreateTexture(nil,"BACKGROUND",nil,-6)
    t:SetPoint("TOPLEFT",f,"TOPLEFT",w*3/32,-w*3/32)
    t:SetPoint("BOTTOMRIGHT",f,"BOTTOMRIGHT",-w*3/32,w*3/32)
    t:SetTexCoord(0.1,0.9,0.1,0.9)

    local bo = f:CreateTexture(nil,"BACKGROUND",nil,-4)
    bo:SetTexture("Interface\\AddOns\\rTextures\\simplesquare_roth")
    bo:SetVertexColor(0.37,0.3,0.3,1)
    bo:SetAllPoints(f)
    
    local time = f:CreateFontString(nil, "BORDER")
    time:SetFont(STANDARD_TEXT_FONT, w*14/32, "THINOUTLINE")
    time:SetPoint("BOTTOM", 0, 0)
    time:SetTextColor(1, 0.8, 0)
    
    local count = f:CreateFontString(nil, "BORDER")
    count:SetFont(STANDARD_TEXT_FONT, w*18/32, "OUTLINE")
    count:SetPoint("TOPRIGHT", 0,0)
    count:SetTextColor(1, 1, 1)
    count:SetJustifyH("RIGHT")
    
    f.glow = gl
    f.border = bo
    f.back = ba
    f.time = time
    f.count = count
    f.icon = t
    f.state = -1 --init the state with -1, so it has to update at least 1x at startup
    f.desaturate = listentry.desaturate
    f.alpha = listentry.alpha

    return f   

  end

  --update icon func
  local clearIcon = function(f)
    f:SetAlpha(f.alpha.not_found.frame)
    f.icon:SetAlpha(f.alpha.not_found.icon)
    f.border:SetVertexColor(0.5,0,0.5,1)
    f.time:SetText("")
    f.count:SetText("")
    f.time:SetTextColor(1, 0.8, 0)
    if f.desaturate then
      f.icon:SetDesaturated(1)
    end
  end
  
  --update icon func
  local updateIcon = function(f,e,t,c)
  
    local now = GetTime()        
    local value = t/1000
    --print(now)
    --print(value)
    if(value > 0) and e then
      f.icon:SetAlpha(f.alpha.found.icon)
      f:SetAlpha(f.alpha.found.frame)      
      f.border:SetVertexColor(0.8,0,0.8,1)
      if c and c > 1 then
        f.count:SetText(c)
      else
        f.count:SetText("")
      end
      if f.desaturate then
        f.icon:SetDesaturated(nil)
      end
      
      if value < 10 then
        f.time:SetTextColor(1, 0.4, 0)
      else
        f.time:SetTextColor(1, 0.8, 0)
      end
      f.time:SetText(GetFormattedTime(value))
    end
  end
  
  local checkWpnEnchants = function()
    if mainhand or offhand or throw then    
    
      local mhEnchant, mhTime, mhCount,  ohEnchant, ohTime, ohCount, thEnchant, thTime, thCount  = GetWeaponEnchantInfo()
  
      if mainhand and mhEnchant then 
		    local icon = GetInventoryItemTexture("player", mainhand.slotid) or ""
		    mainhand.icon:SetTexture(icon)
        updateIcon(mainhand,mhEnchant,mhTime,mhCount)
        mainhand.state = mhEnchant
      elseif mainhand and mainhand.state then
        local _, _, icon = GetSpellInfo(88163)
        mainhand.icon:SetTexture(icon)
        clearIcon(mainhand)
        mainhand.state = mhEnchant
      end
      
      if offhand and ohEnchant then         
		    local icon = GetInventoryItemTexture("player", offhand.slotid) or ""
		    offhand.icon:SetTexture(icon)
        updateIcon(offhand,ohEnchant,ohTime,ohCount) 
        offhand.state = ohEnchant
      elseif offhand and offhand.state then
        local _, _, icon = GetSpellInfo(45205)
        offhand.icon:SetTexture(icon)
        clearIcon(offhand)
        offhand.state = ohEnchant
      end
      
      if throw and thEnchant then 
		    local icon = GetInventoryItemTexture("player", throw.slotid) or ""
		    throw.icon:SetTexture(icon)
        updateIcon(throw,thEnchant,thTime,thCount)
        throw.state = thEnchant
      elseif throw and throw.state then
        local _, _, icon = GetSpellInfo(20558)
        throw.icon:SetTexture(icon)
        clearIcon(throw)
        throw.state = thEnchant
      end
      
    end --mainhand, offhand, throw
  end
  
  local lastupdate = 0
  local rWpnEnchantsOnUpdate = function(self,elapsed)
    lastupdate = lastupdate + elapsed    
    if lastupdate > 1 then
      lastupdate = 0
      checkWpnEnchants()
    end
  end  
  

  
  -----------------------------
  -- CALL
  -----------------------------

  local count = 0

  if tempEnchantList.mainhand and tempEnchantList.mainhand.show then
    mainhand = createIcon(tempEnchantList.mainhand,"Mainhand")
    count = count+1
  end

  if tempEnchantList.offhand and tempEnchantList.offhand.show then
    offhand = createIcon(tempEnchantList.offhand,"Offhand")
    count = count+1
  end
  
  if tempEnchantList.throw and tempEnchantList.throw.show then
    throw = createIcon(tempEnchantList.throw,"Throw")
    count = count+1
  end
  
  if count > 0 then
    
    local a = CreateFrame("Frame")
  
    a:SetScript("OnEvent", function(self, event)
      if(event=="PLAYER_LOGIN") then
        self:SetScript("OnUpdate", rWpnEnchantsOnUpdate)
      end
    end)
    
    a:RegisterEvent("PLAYER_LOGIN")
  
  end
