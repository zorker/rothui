
  -- // rFilter3
  -- // zork - 2010
  
  --get the addon namespace
  local addon, ns = ...  
  
  --get the config
  local cfg = ns.cfg  
  
  local rf3_BuffList, rf3_DebuffList, rf3_CooldownList = cfg.rf3_BuffList, cfg.rf3_DebuffList, cfg.rf3_CooldownList
  
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

  
  local createIcon = function(f,index,type)
    
    local gsi_name, gsi_rank, gsi_icon, gsi_powerCost, gsi_isFunnel, gsi_powerType, gsi_castingTime, gsi_minRange, gsi_maxRange = GetSpellInfo(f.spellid)
    
    local i = CreateFrame("FRAME",nil,UIParent)
    i:SetSize(f.size,f.size)
    i:SetPoint(f.pos.a1,f.pos.af,f.pos.a2,f.pos.x,f.pos.y)
    
    local w = f.size
    
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
    time:SetFont(STANDARD_TEXT_FONT, w*14/32, "THINOUTLINE")
    time:SetPoint("BOTTOM", 0, 0)
    time:SetTextColor(1, 0.8, 0)
    --time:SetShadowColor(0,0,0,1)
    --time:SetShadowOffset(w*1/32, -w*1/32)
    
    local count = i:CreateFontString(nil, "BORDER")
    count:SetFont(STANDARD_TEXT_FONT, w*18/32, "OUTLINE")
    count:SetPoint("TOPRIGHT", 0,0)
    --count:SetShadowColor(0,0,0,1)
    --count:SetShadowOffset(-w*1/32, -w*1/32)
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
          f.iconframe.time:SetTextColor(1, 0.4, 0)
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
          f.iconframe.time:SetTextColor(1, 0.4, 0)
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
  
  local checkCooldown = function(f)
    if f.name and f.spellid then
      local start, duration, enable = GetSpellCooldown(f.spellid)
      if start and duration then
        local now = GetTime()        
        local value = start+duration-now
        if(value > 0) and duration > 2 then
          --item is on cooldown show time
          f.iconframe.icon:SetAlpha(f.alpha.cooldown.icon)
          f.iconframe:SetAlpha(f.alpha.cooldown.frame)
          f.iconframe.count:SetText("")
          if f.desaturate then
            f.iconframe.icon:SetDesaturated(1)
          end
          if value < 10 then
            f.iconframe.time:SetTextColor(1, 0.4, 0)
          else
            f.iconframe.time:SetTextColor(1, 0.8, 0)
          end
          f.iconframe.time:SetText(GetFormattedTime(value))
        else
          f.iconframe:SetAlpha(f.alpha.no_cooldown.frame)
          f.iconframe.icon:SetAlpha(f.alpha.no_cooldown.icon)
          f.iconframe.time:SetText("RDY")
          f.iconframe.count:SetText("")
          f.iconframe.time:SetTextColor(0, 0.8, 0)
          if f.desaturate then
            f.iconframe.icon:SetDesaturated(nil)
          end
        end
      end
    end
  end
  
  local searchBuffs = function()
    for i,_ in ipairs(rf3_BuffList) do 
      local f = rf3_BuffList[i]
      checkBuff(f)
    end
  end

  local searchDebuffs = function()
    for i,_ in ipairs(rf3_DebuffList) do 
      local f = rf3_DebuffList[i]
      checkDebuff(f)
    end
  end

  local searchCooldowns = function()
    for i,_ in ipairs(rf3_CooldownList) do 
      local f = rf3_CooldownList[i]
      checkCooldown(f)
    end
  end

  local lastupdate = 0
  local rFilterOnUpdate = function(self,elapsed)
    lastupdate = lastupdate + elapsed    
    if lastupdate > 1 then
      lastupdate = 0
      searchBuffs()
      searchDebuffs()
      searchCooldowns()
    end
  end  
  

  
  -----------------------------
  -- CALL
  -----------------------------

  local count = 0

  for i,_ in ipairs(rf3_BuffList) do 
    local f = rf3_BuffList[i]
    if not f.icon then 
      createIcon(f,i,"Buff")
    end
    count=count+1
  end
  
  for i,_ in ipairs(rf3_DebuffList) do 
    local f = rf3_DebuffList[i]
    if not f.icon then 
      createIcon(f,i,"Debuff")
    end
    count=count+1
  end
  
  for i,_ in ipairs(rf3_CooldownList) do 
    local f = rf3_CooldownList[i]
    if not f.icon then 
      createIcon(f,i,"Cooldown")
    end
    count=count+1
  end
  
  if count > 0 then
    
    local a = CreateFrame("Frame")
  
    a:SetScript("OnEvent", function(self, event)
      if(event=="PLAYER_LOGIN") then
        self:SetScript("OnUpdate", rFilterOnUpdate)
      end
    end)
    
    a:RegisterEvent("PLAYER_LOGIN")
  
  end
