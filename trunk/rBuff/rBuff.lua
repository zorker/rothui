  
  ---------------------------
  -- based on p3lim pbuffs --
  ---------------------------

  local addon = CreateFrame"Frame"
  local _G = getfenv(0)
  
  addon:SetScript("OnEvent", function()
    
    if(event=="PLAYER_LOGIN") then
      TemporaryEnchantFrame:ClearAllPoints()
      TemporaryEnchantFrame:SetPoint("TOPRIGHT", Minimap, "TOPLEFT", -12, 3)
      TemporaryEnchantFrame.SetPoint = function() end
      TicketStatusFrame:Hide()
      TicketStatusFrame.Show = function() end
    elseif(event=="PLAYER_AURAS_CHANGED") then
      local i
      i = 1
      while _G["BuffButton"..i] do addon:Update("BuffButton"..i) i = i + 1 end
      i = 1
      while _G["DebuffButton"..i] do addon:Update("DebuffButton"..i, true) i = i + 1 end
      i = 1
      while _G["TempEnchant"..i] do addon:Update("TempEnchant"..i, true) i = i + 1 end
    end
    
  end)
  
  function addon:Update(name, isDebuff)
  
    local b = _G[name.."Border"]
    local i = _G[name.."Icon"]
    local fp = _G[name]
    
    f = CreateFrame("Frame", nil, fp)
    f:SetAllPoints(fp)
   
    local t = f:CreateTexture(nil,"Overlay")
    t:SetTexture("Interface\\AddOns\\rTextures\\rGloss")
    t:SetPoint("TOPLEFT", f, "TOPLEFT", -4, 4)
    t:SetPoint("BOTTOMRIGHT", f, "BOTTOMRIGHT", 4, -4)
    f.texture = t

    if b then b:Hide() end
      
  end
  
  SecondsToTimeAbbrev = function(time)
    local hr, m, s, text
    if time <= 0 then text = ""
    elseif(time < 3600 and time > 40) then
      m = floor(time / 60)
      s = mod(time, 60)
      text = (m == 0 and format("|cffffffff%d|r", s)) or format("|cffffffff%d:%02d|r", m, s)
    elseif time < 40 then
      m = floor(time / 60)
      s = mod(time, 60)
      text = (m == 0 and format("|cffffffff%d|r", s))
    else
      hr = floor(time / 3600)
      m = floor(mod(time, 3600) / 60)
      text = format("%d:%2d", hr, m)
    end
    return text
  end
  
  addon:RegisterEvent"PLAYER_AURAS_CHANGED"
  addon:RegisterEvent"PLAYER_LOGIN"