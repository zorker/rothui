
  --rdy up for wotlk

  BUFF_FLASH_TIME_ON = 0.8;
  BUFF_FLASH_TIME_OFF = 0.8;
  BUFF_MIN_ALPHA = 0.70;

  local addon = CreateFrame("Frame")
  local _G = getfenv(0)
  
  addon:SetScript("OnEvent", function(self, event, ...)
    local unit = ...;
    if(event=="PLAYER_ENTERING_WORLD") 
    then
      TemporaryEnchantFrame:ClearAllPoints()
      TemporaryEnchantFrame:SetPoint("TOPRIGHT", UIParent, "TOPRIGHT", -190, -20)
      TemporaryEnchantFrame.SetPoint = function() end
      addon:runthroughicons()
    end
    if ( event == "UNIT_AURA" ) then
      if ( unit == PlayerFrame.unit ) then
        addon:runthroughicons()
      end
    end
  end)
  
  function addon:runthroughicons()
    local i = 1
    while _G["BuffButton"..i] 
    do 
      addon:checkgloss("BuffButton"..i) 
      i = i + 1 
    end
    i = 1
    while _G["DebuffButton"..i] 
    do 
      addon:checkgloss("DebuffButton"..i) 
      i = i + 1 
    end
    i = 1
    while _G["TempEnchant"..i] 
    do 
      addon:checkgloss("TempEnchant"..i) 
      i = i + 1 
    end
  end

  function addon:checkgloss(name)
    local b = _G[name.."Border"]
    local i = _G[name.."Icon"]
    local f = _G[name]
    local c = _G[name.."Gloss"]
    local ff = _G[name.."Duration"]
    ff:SetFont(NAMEPLATE_FONT, 14, "THINOUTLINE")
    ff:ClearAllPoints()
    ff:SetPoint("TOP",f,"BOTTOM",0,0)

    if not c then

      local fg = CreateFrame("Frame", name.."Gloss", f)
      fg:SetAllPoints(f)

      local t = f:CreateTexture(nil,"ARTWORK")
      t:SetTexture("Interface\\AddOns\\rTextures\\gloss")
      t:SetPoint("TOPLEFT", fg, "TOPLEFT", -0, 0)
      t:SetPoint("BOTTOMRIGHT", fg, "BOTTOMRIGHT", 0, -0)
      fg.texture = t
      
      i:SetTexCoord(0.1,0.9,0.1,0.9)
      i:SetPoint("TOPLEFT", fg, "TOPLEFT", 2, -2)
      i:SetPoint("BOTTOMRIGHT", fg, "BOTTOMRIGHT", -2, 2)
        
    end

    if b then b:Hide() end
  
  end

  
  addon:RegisterEvent("UNIT_AURA");
  addon:RegisterEvent("PLAYER_ENTERING_WORLD");