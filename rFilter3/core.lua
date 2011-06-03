
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
  
  local applySize = function(i)    
    local w = i:GetWidth()
    if w < i.minsize then w = i.minsize end    
    i:SetSize(w,w)
    i.glow:SetPoint("TOPLEFT",i,"TOPLEFT",-w*3.3/32,w*3.3/32)
    i.glow:SetPoint("BOTTOMRIGHT",i,"BOTTOMRIGHT",w*3.3/32,-w*3.3/32)  
    i.icon:SetPoint("TOPLEFT",i,"TOPLEFT",w*3/32,-w*3/32)
    i.icon:SetPoint("BOTTOMRIGHT",i,"BOTTOMRIGHT",-w*3/32,w*3/32)
    i.time:SetFont(STANDARD_TEXT_FONT, w*16/36, "THINOUTLINE")
    i.time:SetPoint("BOTTOM", 0, 0)    
    i.count:SetFont(STANDARD_TEXT_FONT, w*18/32, "OUTLINE")
    i.count:SetPoint("TOPRIGHT", 0,0)
  end
  
  --generate the frame name if a global one is needed
  local makeFrameName = function(f,type)
    if not f.move_ingame then return nil end
    local _, class = UnitClass("player")
    local spec = "None"
    if f.spec then spec = f.spec end
    return "rFilter3"..type.."Frame"..f.spellid.."Spec"..spec..class
  end
  
  --simple frame movement
  local appyMoveFunctionality = function(f,i)
    if not f.move_ingame then 
      if i:IsUserPlaced() then
        i:SetUserPlaced(false)
      end
      return
    end
    i:SetHitRectInsets(-5,-5,-5,-5)
    i:SetClampedToScreen(true)
    i:SetMovable(true)
    i:SetResizable(true)
    i:SetUserPlaced(true)
    i:EnableMouse(true)    
    --[[
    local t = i:CreateTexture(nil,"OVERLAY",nil,6)
    t:SetAllPoints(i)
    t:SetTexture(0,1,0)
    t:SetAlpha(0.3)
    i.dragtexture = t   
    ]]--
    i:RegisterForDrag("LeftButton","RightButton")
    --[[
    i:SetScript("OnEnter", function(s) 
      GameTooltip:SetOwner(s, "ANCHOR_BOTTOMRIGHT")
      GameTooltip:AddLine(s:GetName(), 0, 1, 0.5, 1, 1, 1)
      GameTooltip:AddLine("LEFT MOUSE + ALT + SHIFT to DRAG", 1, 1, 1, 1, 1, 1)
      GameTooltip:AddLine("RIGHT MOUSE + ALT + SHIFT to SIZE", 1, 1, 1, 1, 1, 1)
      GameTooltip:Show()
    end)
    i:SetScript("OnLeave", function(s) GameTooltip:Hide() end)
    ]]--
    i:SetScript("OnDragStart", function(s,b) 
      if IsAltKeyDown() and IsShiftKeyDown() and b == "LeftButton" then
        s:StartMoving()
      end
      if IsAltKeyDown() and IsShiftKeyDown() and b == "RightButton" then
        s:StartSizing()
      end
    end)
    i:SetScript("OnDragStop", function(s) 
      s:StopMovingOrSizing() 
    end)
    i:SetScript("OnSizeChanged", function(s) 
      applySize(s)
    end)
    
  end
  
  local createIcon = function(f,index,type)

    local gsi_name, gsi_rank, gsi_icon, gsi_powerCost, gsi_isFunnel, gsi_powerType, gsi_castingTime, gsi_minRange, gsi_maxRange = GetSpellInfo(f.spellid)
    
    local i = CreateFrame("FRAME",makeFrameName(f,type),UIParent)
    i:SetSize(f.size,f.size)
    i:SetPoint(f.pos.a1,f.pos.af,f.pos.a2,f.pos.x,f.pos.y)
    i.minsize = f.size
    
    local gl = i:CreateTexture(nil, "BACKGROUND",nil,-8)
    gl:SetTexture("Interface\\AddOns\\rTextures\\simplesquare_glow")
    gl:SetVertexColor(0, 0, 0, 1)

    local ba = i:CreateTexture(nil, "BACKGROUND",nil,-7)
    ba:SetAllPoints(i)
    ba:SetTexture("Interface\\AddOns\\rTextures\\d3portrait_back2")
    
    local t = i:CreateTexture(nil,"BACKGROUND",nil,-6)
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
    time:SetTextColor(1, 0.8, 0)
    
    local count = i:CreateFontString(nil, "BORDER")
    count:SetTextColor(1, 1, 1)
    count:SetJustifyH("RIGHT")
    
    i.glow = gl
    i.border = bo
    i.back = ba
    i.time = time
    i.count = count
    i.icon = t    
    applySize(i)
    appyMoveFunctionality(f,i)
    f.iconframe = i
    f.name = gsi_name
    f.rank = gsi_rank
    f.texture = gsi_icon    

  end
  
  local checkDebuff = function(f,spellid)
    if f.spec and f.spec ~= GetActiveTalentGroup() then
      f.iconframe:SetAlpha(0)
      return
    end
    if not UnitExists(f.unit) and f.validate_unit then
      f.iconframe:SetAlpha(0)
      return
    end
    if not InCombatLockdown() and f.hide_ooc then
      f.iconframe:SetAlpha(0)
      return      
    end
    local tmp_spellid = f.spellid
    if spellid then
      tmp_spellid = spellid --spellid gets overwritten for spelllists
      local gsi_name, gsi_rank, gsi_icon = GetSpellInfo(spellid)
      if gsi_name then
        f.name = gsi_name
        f.rank = gsi_rank
        f.texture_list = gsi_icon
        f.iconframe.icon:SetTexture(f.texture_list)
        --print(spellid..gsi_name)
      end
    end
    if f.name and f.rank then
      local name, rank, icon, count, dispelType, duration, expires, caster, isStealable, shouldConsolidate, spID = UnitAura(f.unit, f.name, f.rank, "HARMFUL")
      --if name and (not f.ismine or (f.ismine and caster == "player")) then
      if name and (not f.ismine or (f.ismine and caster == "player")) and (not f.match_spellid or (f.match_spellid and spID == tmp_spellid)) then
        if caster == "player" and cfg.highlightPlayerSpells then
          f.iconframe.border:SetVertexColor(0.2,0.6,0.8,1)
        elseif cfg.highlightPlayerSpells then
          f.iconframe.border:SetVertexColor(0.37,0.3,0.3,1)
        end        
        f.iconframe.icon:SetAlpha(f.alpha.found.icon)
        f.iconframe:SetAlpha(f.alpha.found.frame)
        if spellid then
          f.debufffound = true
          --break out of the debuff search loop
        end
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
        if spellid then
          f.iconframe.icon:SetTexture(f.texture)
        end
        f.iconframe.time:SetText("")
        f.iconframe.count:SetText("")
        f.iconframe.time:SetTextColor(1, 0.8, 0)
        if cfg.highlightPlayerSpells then
          f.iconframe.border:SetVertexColor(0.37,0.3,0.3,1)
        end 
        if f.desaturate then
          f.iconframe.icon:SetDesaturated(1)
        end
      end
    end
  end
  
  local checkBuff = function(f,spellid)
    if f.spec and f.spec ~= GetActiveTalentGroup() then
      f.iconframe:SetAlpha(0)
      return
    end
    if not UnitExists(f.unit) and f.validate_unit then
      f.iconframe:SetAlpha(0)
      return
    end
    if not InCombatLockdown() and f.hide_ooc then
      f.iconframe:SetAlpha(0)
      return      
    end
    local tmp_spellid = f.spellid
    if spellid then
      tmp_spellid = spellid --spellid gets overwritten for spelllists
      local gsi_name, gsi_rank, gsi_icon = GetSpellInfo(spellid)
      if gsi_name then
        f.name = gsi_name
        f.rank = gsi_rank
        f.texture_list = gsi_icon
        f.iconframe.icon:SetTexture(f.texture_list)
        --print(spellid..gsi_name)
      end
    end
    if f.name and f.rank then
      local name, rank, icon, count, dispelType, duration, expires, caster, isStealable, shouldConsolidate, spID = UnitAura(f.unit, f.name, f.rank, "HELPFUL")
      --if name and (not f.ismine or (f.ismine and caster == "player")) then
      if name and (not f.ismine or (f.ismine and caster == "player")) and (not f.match_spellid or (f.match_spellid and spID == tmp_spellid)) then
        if caster == "player" and cfg.highlightPlayerSpells then
          f.iconframe.border:SetVertexColor(0.2,0.6,0.8,1)
        elseif cfg.highlightPlayerSpells then
          f.iconframe.border:SetVertexColor(0.37,0.3,0.3,1)
        end
        if spellid then
          f.bufffound = true
          --break out of the buff search loop
        end
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
        if spellid then
          f.iconframe.icon:SetTexture(f.texture)
        end
        f.iconframe.time:SetText("")
        f.iconframe.count:SetText("")
        f.iconframe.time:SetTextColor(1, 0.8, 0)
        if cfg.highlightPlayerSpells then
          f.iconframe.border:SetVertexColor(0.37,0.3,0.3,1)
        end 
        if f.desaturate then
          f.iconframe.icon:SetDesaturated(1)
        end
      end
    end
  end
  
  local checkCooldown = function(f)
    if f.spec and f.spec ~= GetActiveTalentGroup() then
      f.iconframe:SetAlpha(0)
      return
    end
    if not InCombatLockdown() and f.hide_ooc then
      f.iconframe:SetAlpha(0)
      return      
    end
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
          f.iconframe.border:SetVertexColor(0.37,0.3,0.3,1)
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
          f.iconframe.border:SetVertexColor(0.4,0.6,0.2,1)
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
      if f.spelllist and f.spelllist[1] then
        --print('buff spelllist exists')
        f.bufffound = false
        for k,spellid in ipairs(f.spelllist) do
          if not f.bufffound then
            checkBuff(f,spellid)
          end
        end        
      else
        checkBuff(f)
      end
    end
  end

  local searchDebuffs = function()
    for i,_ in ipairs(rf3_DebuffList) do 
      local f = rf3_DebuffList[i]
      if  f.spelllist and f.spelllist[1] then
        --print('debuff spelllist exists')
        f.debufffound = false
        for k,spellid in ipairs(f.spelllist) do
          if not f.debufffound then
            checkDebuff(f,spellid)
          end
        end
      else
        checkDebuff(f)
      end
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
    if lastupdate > cfg.updatetime then
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
