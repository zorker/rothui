
  ---------------------------------------
  -- INIT
  ---------------------------------------

  --get the addon namespace
  local addon, ns = ...
  --get the config values
  local cfg = ns.cfg
  local dragFrameList = ns.dragFrameList

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

  local applySizeChange = function(i)
    local w = i:GetWidth()
    local h = i:GetHeight()
    if w < i.minsize then w = i.minsize end
    if h < i.minsize then w = i.minsize end
    if not InCombatLockdown() then
      i:SetSize(w,w) --readjusting is impossible in combat
    end
    i.shadow:SetSize(w*1.3,w*1.3)
    i.border:SetSize(w*1.1,w*1.1)
    i.time:SetFont(STANDARD_TEXT_FONT, w*cfg.timeFontSize/36, "THINOUTLINE")
    i.count:SetFont(STANDARD_TEXT_FONT, w*cfg.countFontSize/32, "OUTLINE")
  end

  --generate the frame name if a global one is needed
  local makeFrameName = function(f,type)
    if not f.move_ingame then return nil end
    local _, class = UnitClass("player")
    local spec = 0
    if f.spec then spec = f.spec end
    return "rFilter3"..type.."Frame"..f.spellid.."Spec"..spec..class
  end

  local createIcon = function(f,index,type)

    local gsi_name, gsi_rank, gsi_icon, gsi_powerCost, gsi_isFunnel, gsi_powerType, gsi_castingTime, gsi_minRange, gsi_maxRange = GetSpellInfo(f.spellid)

    local i = CreateFrame("FRAME",makeFrameName(f,type),UIParent, "SecureHandlerStateTemplate")
    i:SetSize(f.size,f.size)
    i:SetPoint(f.pos.a1,f.pos.af,f.pos.a2,f.pos.x,f.pos.y)
    i:SetAlpha(0)
    i.minsize = f.size

    local sh = i:CreateTexture(nil, "BACKGROUND",nil,-8)
    sh:SetPoint("CENTER")
    sh:SetTexture("Interface\\AddOns\\rFilter3\\media\\outer_shadow")
    sh:SetVertexColor(0, 0, 0, 1)

    local ba = i:CreateTexture(nil, "BACKGROUND",nil,-7)
    ba:SetAllPoints(i)
    ba:SetTexture(0.15,0.15,0.15,0.9)

    local t = i:CreateTexture(nil,"BACKGROUND",nil,-6)
    t:SetAllPoints(i)
    t:SetTexture(gsi_icon)
    t:SetTexCoord(0.1,0.9,0.1,0.9)
    if f.desaturate then
      t:SetDesaturated(1)
    end

    local bo = i:CreateTexture(nil,"BACKGROUND",nil,-4)
    bo:SetPoint("CENTER")
    bo:SetTexture("Interface\\AddOns\\rFilter3\\media\\border")
    bo:SetVertexColor(0.37,0.3,0.3,1)

    local time = i:CreateFontString(nil, "BORDER")
    time:SetPoint("BOTTOM", 0, 0)
    time:SetTextColor(1, 0.8, 0)

    local count = i:CreateFontString(nil, "BORDER")
    count:SetPoint("TOPRIGHT", 0,0)
    count:SetTextColor(1, 1, 1)
    count:SetJustifyH("RIGHT")

    i.shadow = sh
    i.border = bo
    i.back = ba
    i.time = time
    i.count = count
    i.icon = t
    i.spec = f.spec --save the spec to the icon

    --add drag+resize function
    rCreateDragResizeFrame(i, dragFrameList, -2 , true) --frame, dragFrameList, inset, clamp
    --apply size change
    i:SetScript("OnSizeChanged", function() applySizeChange(i) end)
    applySizeChange(i)

    --visibility state
    if f.visibility_state then RegisterStateDriver(i, "visibility", f.visibility_state) end
    f.iconframe = i
    f.name = gsi_name
    f.rank = gsi_rank
    f.texture = gsi_icon

  end

  local checkDebuff = function(f,spellid)
    if not f.iconframe:IsShown() then return end
    if f.iconframe.dragFrame:IsShown() then --make the icon visible in case we want to move it
      f.iconframe.icon:SetAlpha(1)
      f.iconframe:SetAlpha(1)
      f.iconframe.icon:SetDesaturated(nil)
      f.iconframe.time:SetText("30m")
      f.iconframe.count:SetText("3")
      return
    end
    if f.spec and f.spec ~= GetActiveSpecGroup() then
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
    if not f.iconframe:IsShown() then return end
    if f.iconframe.dragFrame:IsShown() then --make the icon visible in case we want to move it
      f.iconframe.icon:SetAlpha(1)
      f.iconframe:SetAlpha(1)
      f.iconframe.icon:SetDesaturated(nil)
      f.iconframe.time:SetText("30m")
      f.iconframe.count:SetText("3")
      return
    end
    if f.spec and f.spec ~= GetActiveSpecGroup() then
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
    if not f.iconframe:IsShown() then return end
    if f.iconframe.dragFrame:IsShown() then --make the icon visible in case we want to move it
      f.iconframe.icon:SetAlpha(1)
      f.iconframe:SetAlpha(1)
      f.iconframe.icon:SetDesaturated(nil)
      f.iconframe.time:SetText("30m")
      f.iconframe.count:SetText("3")
      return
    end
    if f.spec and f.spec ~= GetActiveSpecGroup() then
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
    local ag = a:CreateAnimationGroup()
    local anim = ag:CreateAnimation()
    anim:SetDuration(cfg.updatetime)
    ag:SetLooping("REPEAT")
    ag:SetScript("OnLoop", function(self, event, ...)
      searchBuffs()
      searchDebuffs()
      searchCooldowns()
    end)
    ag:Play()
  end
