
  -- rInfostrings
  -- zork - 2010

  local update_timer = 3
  local showXpRep = false  
  
  --------------------------------
  -- config end
  --------------------------------
  
  local memformat = function(number)
    if number > 1024 then
      return string.format("%.2fmb", (number / 1024))
    else
      return string.format("%.1fkb", floor(number))
    end
  end

  --number format func
  local numformat = function(v)
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

  local f1 = CreateFrame("Frame", "rInfoStringsContainer1", UIParent)
  local f2 = CreateFrame("Frame", "rInfoStringsContainer2", UIParent)
  local f3 = CreateFrame("Frame", "rInfoStringsContainer3", UIParent)

  f1:SetPoint("BOTTOM", Minimap, "BOTTOM", 0, -30)
  f2:SetPoint("TOP", f1, "BOTTOM", 0, -3)
  f3:SetPoint("TOP", f2, "BOTTOM", 0, -10)
  
  local function rsiCreateFontString(f,size)
    local t = f:CreateFontString(nil, "BACKGROUND")
    t:SetFont("Fonts\\FRIZQT__.ttf", size, "THINOUTLINE")
    t:SetPoint("CENTER", f)
    return t
  end

  f1.text = rsiCreateFontString(f1,11)
  f2.text = rsiCreateFontString(f2,11)
  f3.text = rsiCreateFontString(f3,11)

  --garbage function from Lyn
  local function rsiClearGarbage()
    UpdateAddOnMemoryUsage()
    local before = gcinfo()
    collectgarbage()
    UpdateAddOnMemoryUsage()
    local after = gcinfo()
    print("Cleaned: "..memformat(before-after))
  end

  f2:EnableMouse(true)
  f2:SetScript("OnMouseDown", function()
    rsiClearGarbage()
  end)
  
  local addoncompare = function(a, b)
  	return a.memory > b.memory
  end
  local addonlist = 50

  --tooltip function from Lyn
  local function rsiShowMemTooltip(self)
    local color = { r=156/255, g=144/255, b=125/255 }
    GameTooltip:SetOwner(self, "ANCHOR_NONE")
    GameTooltip:SetPoint("BOTTOMRIGHT", UIParent, "BOTTOMRIGHT", -90, 90)
    local blizz = collectgarbage("count")
    local addons = {}
    local enry, memory
    local total = 0
    local nr = 0
    UpdateAddOnMemoryUsage()
    GameTooltip:AddLine("Top "..addonlist.." AddOns", color.r, color.g, color.b)
    GameTooltip:AddLine(" ")
    for i=1, GetNumAddOns(), 1 do
      if (GetAddOnMemoryUsage(i) > 0 ) then
        memory = GetAddOnMemoryUsage(i)
        entry = {name = GetAddOnInfo(i), memory = memory}
        table.insert(addons, entry)
        total = total + memory
      end
    end
    table.sort(addons, addoncompare)
    for _, entry in pairs(addons) do
      if nr < addonlist then
        GameTooltip:AddDoubleLine(entry.name, memformat(entry.memory), 1, 1, 1, 1, 1, 1)
        nr = nr+1
      end
    end
    GameTooltip:AddLine(" ")
    GameTooltip:AddDoubleLine("Total", memformat(total), color.r, color.g, color.b, color.r, color.g, color.b)
    GameTooltip:AddDoubleLine("Total incl. Blizzard", memformat(blizz), color.r, color.g, color.b, color.r, color.g, color.b)
    GameTooltip:Show()
  end
  
  
  f2:SetScript("OnEnter", function() rsiShowMemTooltip(f2) end)
  f2:SetScript("OnLeave", function() GameTooltip:Hide() end)
  
  
  local function rsiExpRep()
    local xp = ""
    if (UnitLevel("player")<MAX_PLAYER_LEVEL) then
      xp = "|c00FA58F4XP: "..numformat(UnitXP("player")).."/"..numformat(UnitXPMax("player")).." | "..string.format("%.0f", (UnitXP("player")/UnitXPMax("player")*100)).."%|r"
    else
      local _, _, minimum, maximum, value = GetWatchedFactionInfo()
      if ((value-minimum)==999) and ((maximum-minimum)==1000) then
        xp = "|c0000FF00REP: FULL|r"
      else
        xp = "|c0000FF00REP: "..numformat(value-minimum).."/"..numformat(maximum-minimum).." | "..string.format("%.0f", (value-minimum)/(maximum-minimum)*100).."%|r"
      end
    end
    return xp
  end
  
  local function rsiFPS()
    return floor(GetFramerate()).."fps"
  end
  
  local function rsiLatency()
    return select(3, GetNetStats()).."ms"
  end
  
  local function rsiMemory()
    local t = 0
    UpdateAddOnMemoryUsage()
    for i=1, GetNumAddOns(), 1 do
      t = t + GetAddOnMemoryUsage(i)
    end
    return memformat(t)
  end
  
  local function rsiZoneCoords()
    local zone = ""
    local x, y = GetPlayerMapPosition("player")
    local coords
    if x and y and x ~= 0 and y ~= 0 then
      coords = format("%.2d/%.2d",x*100,y*100)
    end
    if coords then
      zone = "|c00E8B444"..GetMinimapZoneText().." [|r|c00C9BCA8"..coords.."|r|c009C907D]|r"
    else
      zone = "|c00E8B444"..GetMinimapZoneText().."|r"
    end
    return zone
  end  
  
  local function rsiMail()
    local mail = (HasNewMail() or 0)
    local mailtext = ""
    if mail>0 then
      mailtext = "|c00FF78F1New Mail!|r"
    end
    return mailtext
  end
  
  local function rsiUpdateStrings()

    f1.text:SetText(rsiZoneCoords())
    f1:SetHeight(f1.text:GetStringHeight())
    f1:SetWidth(f1.text:GetStringWidth())
    
    f2.text:SetText("|c009C907D"..rsiLatency().." "..rsiFPS().."|r")
    f2:SetHeight(f2.text:GetStringHeight())
    f2:SetWidth(f2.text:GetStringWidth())
    
    if showXpRep then
      f3.text:SetText(rsiMail()..""..rsiExpRep())
      f3:SetHeight(f3.text:GetStringHeight())
      f3:SetWidth(f3.text:GetStringWidth())
    else
      f3.text:SetText(rsiMail() or "")
      f3:SetHeight(f3.text:GetStringHeight())
      f3:SetWidth(f3.text:GetStringWidth())
    end

  end   

  local totalElapsed = 0
  local function rsiOnUpdate(self, elapsed)
    totalElapsed = totalElapsed + elapsed
    if (totalElapsed < update_timer) then 
      return 
    else
      totalElapsed = 0
      rsiUpdateStrings()
    end
  end  
  
  local a = CreateFrame("Frame")

  a:SetScript("OnEvent", function(self, event)
    if(event=="PLAYER_LOGIN") then
      a:SetScript("OnUpdate", rsiOnUpdate)
    end
  end)
  
  a:RegisterEvent("PLAYER_LOGIN")
  
