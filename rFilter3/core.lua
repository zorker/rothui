
  -- // rFilter3
  -- // zork - 2010

  local player_name, _ = UnitName("player")
  local _, player_class = UnitClass("player")
  rFilter3 = rFilter3 or {}
  local framesLocked = false
  
  --get the addon namespace
  local addon, ns = ...  
  
  --get the config
  local cfg = ns.cfg  
  
  local rf3_BuffList, rf3_DebuffList = cfg.rf3_BuffList, cfg.rf3_DebuffList
  
  -----------------------------
  -- FUNCTIONS
  -----------------------------
  
  local function load_defaults()
    if(not rFilter3["locked"]) then 
      rFilter3["locked"] = framesLocked
    end
  end
  
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


  local updateIcon = function(f)
    local w = f:GetWidth()
    local gl = f.glow
    local i = f
    local t = f.icon
    local time = f.time
    local count = f.count
    
    if w < 20 then
      w = 20
      i:SetWidth(w)
    end

    i:SetHeight(w)    
    gl:SetPoint("TOPLEFT",i,"TOPLEFT",-w*3/32,w*3/32)
    gl:SetPoint("BOTTOMRIGHT",i,"BOTTOMRIGHT",w*3/32,-w*3/32)
    t:SetPoint("TOPLEFT",i,"TOPLEFT",w*3/32,-w*3/32)
    t:SetPoint("BOTTOMRIGHT",i,"BOTTOMRIGHT",-w*3/32,w*3/32)
    time:SetFont(STANDARD_TEXT_FONT, w*13/32, "THINOUTLINE")
    time:SetShadowOffset(w*1/32, -w*1/32)
    count:SetFont(STANDARD_TEXT_FONT, w*15/32, "THINOUTLINE")
    count:SetShadowOffset(-w*1/32, -w*1/32)
    
  end
  
  local applyDragFunctionality = function(f)
    if not rFilter3["locked"] then
      f:EnableMouse(true)
      f:RegisterForDrag("LeftButton","RightButton")
      f:SetScript("OnDragStart", function(s) 
        if IsShiftKeyDown() then s:StartMoving() end
        if IsAltKeyDown() then s:StartSizing() end 
      end)
      f:SetScript("OnDragStop", function(s) 
        updateIcon(s)
        s:StopMovingOrSizing() 
      end)
    else
      f:EnableMouse(false)
    end
  end
  
  local createIcon = function(f)
    
    local gsi_name, gsi_rank, gsi_icon, gsi_powerCost, gsi_isFunnel, gsi_powerType, gsi_castingTime, gsi_minRange, gsi_maxRange = GetSpellInfo(f.spellid)
    
    local framename = "rf3_"..player_class..player_name..f.spellid
    
    local i = CreateFrame("FRAME",framename,UIParent)
    i:SetSize(f.size,f.size)
    i:SetPoint("CENTER",0,0)
    i:SetMovable(true)
    i:SetResizable(true)
    i:SetUserPlaced(true)
    
    local w = i:GetWidth()
    
    local gl = i:CreateTexture(nil, "BACKGROUND",nil,-8)
    gl:SetPoint("TOPLEFT",i,"TOPLEFT",-w*3/32,w*3/32)
    gl:SetPoint("BOTTOMRIGHT",i,"BOTTOMRIGHT",w*3/32,-w*3/32)
    gl:SetTexture("Interface\\AddOns\\rTextures\\simplesquare_glow")
    gl:SetVertexColor(0, 0, 0, 1)

    local ba = i:CreateTexture(nil, "BACKGROUND",nil,-7)
    ba:SetAllPoints(i)
    ba:SetTexture("Interface\\AddOns\\rTextures\\d3portrait_back2")
    
    local t = i:CreateTexture(nil,"BACKGROUND",nil,-6)
    t:SetPoint("TOPLEFT",i,"TOPLEFT",w*3/32,-w*3/32)
    t:SetPoint("BOTTOMRIGHT",i,"BOTTOMRIGHT",-w*3/32,w*3/32)
    t:SetTexture(gsi_icon)
    t:SetTexCoord(0.1,0.9,0.1,0.9)
    if f.desaturate then
      t:SetDesaturated(1)
    end

    local bo = i:CreateTexture(nil,"BACKGROUND",nil,-4)
    bo:SetTexture("Interface\\AddOns\\rTextures\\simplesquare_roth")
    bo:SetVertexColor(0.37,0.3,0.3,1)
    bo:SetAllPoints(i)
    
    local time = i:CreateFontString(nil, "BORDER")
    time:SetFont(STANDARD_TEXT_FONT, w*13/32, "THINOUTLINE")
    time:SetPoint("BOTTOM", 0, 0)
    time:SetTextColor(1, 0.8, 0)
    time:SetShadowColor(0,0,0,1)
    time:SetShadowOffset(w*1/32, -w*1/32)
    
    local count = i:CreateFontString(nil, "BORDER")
    count:SetFont(STANDARD_TEXT_FONT, w*15/32, "OUTLINE")
    count:SetPoint("TOPRIGHT", 0,0)
    count:SetShadowColor(0,0,0,1)
    count:SetShadowOffset(-w*1/32, -w*1/32)
    count:SetTextColor(1, 1, 1)
    count:SetJustifyH("RIGHT")
    
    i.glow = gl
    i.border = bo
    i.back = ba
    i.time = time
    i.count = count
    i.icon = t
    f.iconframe = i

    f.name = gsi_name
    f.rank = gsi_rank
    f.texture = gsi_icon    

    f.iconframe:SetAlpha(f.alpha.not_found.frame)
    f.iconframe.icon:SetAlpha(f.alpha.not_found.icon)
  
  end
  
  local checkDebuff = function(f)
    if f.name and f.rank then
      local name, rank, icon, count, dispelType, duration, expires, caster, isStealable, shouldConsolidate, spellID = UnitAura(f.unit, f.name, f.rank, "HARMFUL")
      if name then
        f.iconframe.icon:SetAlpha(f.alpha.found.icon)
        f.iconframe:SetAlpha(f.alpha.found.frame)
        if f.desaturate then
          f.iconframe.icon:SetDesaturated(nil)
        end
        --local value = floor((expires-GetTime())*10+0.5)/10
        if count and count > 1 then
          f.iconframe.count:SetText(count)
        else
          f.iconframe.count:SetText("")
        end
        local value = expires-GetTime()
        if value < 10 then
          f.iconframe.time:SetTextColor(0.8, 0, 0)
        else
          f.iconframe.time:SetTextColor(1, 0.8, 0)
        end
        f.iconframe.time:SetText(GetFormattedTime(value))
      else
        f.iconframe:SetAlpha(f.alpha.not_found.frame)
        f.iconframe.icon:SetAlpha(f.alpha.not_found.icon)
        f.iconframe.time:SetText("")
        f.iconframe.count:SetText("")
        f.iconframe.time:SetTextColor(1, 0.8, 0)
        if f.desaturate then
          f.iconframe.icon:SetDesaturated(1)
        end
      end
    end
  end
  
  local checkBuff = function(f)
    if f.name and f.rank then
      local name, rank, icon, count, dispelType, duration, expires, caster, isStealable, shouldConsolidate, spellID = UnitAura(f.unit, f.name, f.rank, "HELPFUL")
      if name then
        f.iconframe.icon:SetAlpha(f.alpha.found.icon)
        f.iconframe:SetAlpha(f.alpha.found.frame)
        if f.desaturate then
          f.iconframe.icon:SetDesaturated(nil)
        end
        --local value = floor((expires-GetTime())*10+0.5)/10
        if count and count > 1 then
          f.iconframe.count:SetText(count)
        else
          f.iconframe.count:SetText("")
        end
        local value = expires-GetTime()
        if value < 10 then
          f.iconframe.time:SetTextColor(0.8, 0, 0)
        else
          f.iconframe.time:SetTextColor(1, 0.8, 0)
        end
        f.iconframe.time:SetText(GetFormattedTime(value))
      else
        f.iconframe:SetAlpha(f.alpha.not_found.frame)
        f.iconframe.icon:SetAlpha(f.alpha.not_found.icon)
        f.iconframe.time:SetText("")
        f.iconframe.count:SetText("")
        f.iconframe.time:SetTextColor(1, 0.8, 0)
        if f.desaturate then
          f.iconframe.icon:SetDesaturated(1)
        end
      end
    end
  end
  
  local searchBuffs = function()
    for i,_ in ipairs(rf3_BuffList) do 
      local f = rf3_BuffList[i]
      if not f.updateicons then
        updateIcon(f.iconframe)
        applyDragFunctionality(f.iconframe)
        f.updateicons = true
      end
      checkBuff(f)
    end
  end

  local searchDebuffs = function()
    for i,_ in ipairs(rf3_DebuffList) do 
      local f = rf3_DebuffList[i]
      if not f.updateicons then
        updateIcon(f.iconframe)
        applyDragFunctionality(f.iconframe)
        f.updateicons = true
      end
      checkDebuff(f)
    end
  end

  local lastupdate = 0
  local rFilterOnUpdate = function(self,elapsed)
    lastupdate = lastupdate + elapsed    
    if lastupdate > 1 then
      lastupdate = 0
      searchBuffs()
      searchDebuffs()
    end
  end  
  
  
  ------------------------------------------------------
  -- SLASH FUNC
  ------------------------------------------------------
  
  local function SlashCmd(cmd)    
    if (cmd:match"lock") then
      local a,b = strfind(cmd, " ");
      if b then
        local c = strsub(cmd, b+1)
        if tonumber(c) and tonumber(c) == 1 then
          print("Icons locked.")
          rFilter3["locked"] = true          
        else
          print("Icons unlocked.")
          rFilter3["locked"] = false
        end
        for i,_ in ipairs(rf3_BuffList) do 
          local f = rf3_BuffList[i]
          applyDragFunctionality(f.iconframe)
        end
        for i,_ in ipairs(rf3_DebuffList) do 
          local f = rf3_DebuffList[i]
          applyDragFunctionality(f.iconframe)
        end
      else
        print("No value found.")
      end  
    else
      print("rFilter3 command line:")
      print("\/rf3 lock NUMBER (Value of 1 locks everything, 0 unlocks everything)")
    end    
  end
  
  -----------------------------
  -- CALL
  -----------------------------

  for i,_ in ipairs(rf3_BuffList) do 
    local f = rf3_BuffList[i]
    if not f.icon then 
      createIcon(f)
    end
  end
  
  for i,_ in ipairs(rf3_DebuffList) do 
    local f = rf3_DebuffList[i]
    if not f.icon then 
      createIcon(f)
    end
  end
  
  local a = CreateFrame("Frame")

  a:SetScript("OnEvent", function(self, event)
    if(event=="PLAYER_LOGIN") then
      SlashCmdList["rfilter"] = SlashCmd;
      SLASH_rfilter1 = "/rf3";
      load_defaults()
      self:SetScript("OnUpdate", rFilterOnUpdate)
    end
  end)
  
  a:RegisterEvent("PLAYER_LOGIN")
  
