
  --get the addon namespace
  local addon, ns = ...
  --get the config values
  local cfg = ns.cfg

  --make the color tables local
  local RAID_CLASS_COLORS = RAID_CLASS_COLORS
  local FACTION_BAR_COLORS = FACTION_BAR_COLORS

  -----------------------------
  -- FUNCTIONS
  -----------------------------

  --calc hex color from rgb
  local function RGBPercToHex(r, g, b)
    r = r <= 1 and r >= 0 and r or 0
    g = g <= 1 and g >= 0 and g or 0
    b = b <= 1 and b >= 0 and b or 0
    return string.format("%02x%02x%02x", r*255, g*255, b*255)
  end

  --i dont like that
  local hideStuff = function(f)
    f.name:Hide()
    f.level:Hide()
    f.dragon:SetTexture("")
    f.border:SetTexture("")
    f.boss:SetTexture("")
    f.highlight:SetTexture("")
    f.castbar.border:SetTexture("")
    f.castbar.shield:SetTexture("")
  end

  --fix some more stuff
  local fixStuff = function(f)
    f.threat:ClearAllPoints()
    f.threat:SetAllPoints(f.threat_holder)
    f.threat:SetParent(f.threat_holder)
    f.healthbar:ClearAllPoints()
    f.healthbar:SetAllPoints(f.back_holder)
    f.healthbar:SetParent(f.back_holder)
  end

  --fix the damn castbar hopping
  local fixCastbar = function(cb)
    --print("fix castbar")
    cb:ClearAllPoints()
    cb:SetAllPoints(cb.parent)
    cb:SetParent(cb.parent)
  end

  --get the actual color
  local fixColor = function(color)
    color.r,color.g,color.b = floor(color.r*100+.5)/100, floor(color.g*100+.5)/100, floor(color.b*100+.5)/100
  end

  --get colorstring for level color
  local getDifficultyColorString = function(f)
    local color = {}
    color.r,color.g,color.b = f.level:GetTextColor()
    fixColor(color)
    return RGBPercToHex(color.r,color.g,color.b)
  end

  --adjust faction color
  local fixFactionColor = function(color)
    for class, _ in pairs(RAID_CLASS_COLORS) do
      if RAID_CLASS_COLORS[class].r == color.r and RAID_CLASS_COLORS[class].g == color.g and RAID_CLASS_COLORS[class].b == color.b then
        return --no color change needed, bar is in class color
      end
    end
    if color.g+color.b == 0 then -- hostile
      color.r,color.g,color.b = FACTION_BAR_COLORS[2].r, FACTION_BAR_COLORS[2].g, FACTION_BAR_COLORS[2].b
      return
    elseif color.r+color.b == 0 then -- friendly npc
      color.r,color.g,color.b = FACTION_BAR_COLORS[6].r, FACTION_BAR_COLORS[6].g, FACTION_BAR_COLORS[6].b
      return
    elseif color.r+color.g > 1.95 then -- neutral
      color.r,color.g,color.b = FACTION_BAR_COLORS[4].r, FACTION_BAR_COLORS[4].g, FACTION_BAR_COLORS[4].b
      return
    elseif color.r+color.g == 0 then -- friendly player, we don't like 0,0,1 so we change it to a more likable color
      color.r,color.g,color.b = 0/255, 100/255, 230/255
      return
    else -- enemy player
      --whatever is left
      return
    end
  end

  --get healthbar color func
  local getHealthbarColor = function(f)
    local color = {}
    color.r,color.g,color.b = f.healthbar:GetStatusBarColor()
    fixColor(color)
    --now that we have the color make sure we match it to the new faction/class colors
    fixFactionColor(color)
    f.healthbar:SetStatusBarColor(color.r,color.g,color.b)
    f.healthbar.defaultColor = color
    f.healthbar.lowhealthColor = cfg.healthbar.lowHpWarning.color
    f.healthbar.colorApplied = "default"
    return color
  end

  --set txt func
  local updateText = function(f)
    if not cfg.name.enable then return end
    local cs = getDifficultyColorString(f)
    local color = getHealthbarColor(f)
    f.ns:SetTextColor(color.r,color.g,color.b)
    local name = f.name:GetText() or "Nobody"
    local level = f.level:GetText() or "-1"
    if f.boss:IsShown() == 1 then
      level = "??"
      cs = "ff6600"
    elseif f.dragon:IsShown() == 1 then
      level = level.."+"
    end
    f.ns:SetText("|c00"..cs..""..level.."|r "..name)
  end

  --update castbar
  local updateCastbar = function(cb)
    if cb.shield:IsShown() then
      cb:SetStatusBarColor(cfg.castbar.color.shielded.r,cfg.castbar.color.shielded.g,cfg.castbar.color.shielded.b)
    else
      cb:SetStatusBarColor(cfg.castbar.color.default.r,cfg.castbar.color.default.g,cfg.castbar.color.default.b)
    end
  end

  --number format func
  local numFormat = function(v)
    if v > 1E10 then
      return (floor(v/1E9)).."b"
    elseif v > 1E9 then
      return (floor((v/1E9)*10)/10).."b"
    elseif v > 1E7 then
      return (floor(v/1E6)).."m"
    elseif v > 1E6 then
      return (floor((v/1E6)*10)/10).."m"
    elseif v > 1E4 then
      return (floor(v/1E3)).."k"
    elseif v > 1E3 then
      return (floor((v/1E3)*10)/10).."k"
    else
      return v
    end
  end

  --update health
  local updateHealth = function(hb,v)
    if not hb then return end
    local min, max = hb:GetMinMaxValues()
    local val = v or hb:GetValue()
    local p = floor(val/max*100)
    if cfg.healthbar.lowHpWarning.enable then
      if p <= cfg.healthbar.lowHpWarning.treshold and hb.colorApplied == "default" then
        local color = hb.lowhealthColor
        hb:SetStatusBarColor(color.r,color.g,color.b)
        hb.colorApplied == "lowhealth"
      elseif p > cfg.healthbar.lowHpWarning.treshold and hb.colorApplied == "lowhealth" then
        --in case the target got healed reset the color
        local color = hb.defaultColor
        hb:SetStatusBarColor(color.r,color.g,color.b)
        hb.colorApplied == "default"
      end
    end
    if cfg.hpvalue.enable then
      hb.hpvalue:SetText(numFormat(val).." / "..p.."%")
    end
  end

  --health value string
  local createHpValueString = function(f)
    if not cfg.hpvalue.enable then return end
    local n = f.gloss_holder:CreateFontString(nil, "BORDER")
    n:SetFont(cfg.hpvalue.font, cfg.hpvalue.size, cfg.hpvalue.outline)
    n:SetPoint(cfg.hpvalue.pos_1.a1, f.healthbar, cfg.hpvalue.pos_1.x, cfg.hpvalue.pos_1.y)
    f.healthbar.hpvalue = n
  end

  --new fontstrings for name and lvl func
  local createNameString = function(f)
    if not cfg.name.enable then return end
    local n = f:CreateFontString(nil, "BORDER")
    n:SetFont(cfg.name.font, cfg.name.size, cfg.name.outline)
    n:SetPoint(cfg.name.pos_1.a1, f.back_holder, cfg.name.pos_1.x, cfg.name.pos_1.y)
    n:SetPoint(cfg.name.pos_2.a1, f.back_holder, cfg.name.pos_2.x, cfg.name.pos_2.y)
    n:SetPoint(cfg.name.pos_3.a1, f.back_holder, cfg.name.pos_3.x, cfg.name.pos_3.y)
    n:SetJustifyH("CENTER")
    f.ns = n
  end

  --create art
  local createArt = function(f)
    f.w, f.h, f.hw, f.hh = f:GetWidth(), f:GetHeight(), f.healthbar:GetWidth(), f.healthbar:GetHeight()
    local w,h = f.w*cfg.frame.scale, f.w*cfg.frame.scale/4 --width/height ratio is 4:1
    local threat_adjust = 1.18 --threat size needs to be increased, texture is shrinked a bit to fit in
    --threat holder
    local th = CreateFrame("Frame",nil,f)
    th:SetSize(w*threat_adjust,h*threat_adjust)
    th:SetPoint("CENTER",cfg.frame.adjust_pos.x,cfg.frame.adjust_pos.y)
    --th:SetPoint("CENTER",f,"CENTER",cfg.frame.adjust_pos.x,cfg.frame.adjust_pos.y) --anchor the plates to the top of the damn frame
    --threat glow
    f.threat:SetTexCoord(0,1,0,1)
    f.threat:SetTexture(cfg.textures.threat)
    f.threat:ClearAllPoints()
    f.threat:SetAllPoints(th)
    f.threat:SetParent(th)
    --background frame
    local bf = CreateFrame("Frame",nil,th)
    bf:SetSize(w,h)
    bf:SetPoint("CENTER",0,0)
    --bg texture
    local bg = bf:CreateTexture(nil,"BACKGROUND",nil,1)
    bg:SetAllPoints(bf)
    bg:SetTexture(cfg.textures.bg)
    --left texture
    local left = bf:CreateTexture(nil,"BACKGROUND",nil,2)
    left:SetPoint("RIGHT",bf,"LEFT",0,0)
    left:SetSize(h,h)
    left:SetTexture(cfg.textures.left)
    --right texture
    local right = bf:CreateTexture(nil,"BACKGROUND",nil,2)
    right:SetPoint("LEFT",bf,"RIGHT",0,0)
    right:SetSize(h,h)
    right:SetTexture(cfg.textures.right)
    --position healthbar
    f.healthbar:SetStatusBarTexture(cfg.textures.bar)
    f.healthbar:ClearAllPoints()
    f.healthbar:SetAllPoints(bf)
    f.healthbar:SetParent(bf)
    --highlight frame
    local hl = CreateFrame("Frame",nil,f.healthbar)
    hl:SetAllPoints(bf)
    --highlight texture
    local gl = hl:CreateTexture(nil,"BACKGROUND",nil,3)
    gl:SetAllPoints(hl)
    gl:SetTexture(cfg.textures.highlight)
    --raid icon
    f.raid:ClearAllPoints()
    f.raid:SetSize(cfg.raidmark.icon.size,cfg.raidmark.icon.size)
    f.raid:SetPoint(cfg.raidmark.icon.pos.a1,cfg.raidmark.icon.pos.x,cfg.raidmark.icon.pos.y)
    f.raid:SetParent(hl)
    --parent frames
    f.threat_holder = th
    f.back_holder = bf
    f.gloss_holder = hl
  end

  --create castbar art
  local createCastbarArt = function(f)
    f.w, f.h = f:GetWidth(), f:GetHeight()
    local w,h = f.w*cfg.castbar.scale, f.w*cfg.castbar.scale/4 --width/height ratio is 4:1
    --background frame
    local bf = CreateFrame("Frame",nil,f)
    bf:SetSize(w,h)
    bf:SetPoint("CENTER",cfg.castbar.adjust_pos.x,cfg.castbar.adjust_pos.y)
    --bg texture
    local bg = bf:CreateTexture(nil,"BACKGROUND",nil,1)
    bg:SetAllPoints(bf)
    bg:SetTexture(cfg.textures.bg)
    --left texture
    local left = bf:CreateTexture(nil,"BACKGROUND",nil,2)
    left:SetPoint("RIGHT",bf,"LEFT",0,0)
    left:SetSize(h,h)
    left:SetTexture(cfg.textures.left)
    --right texture
    local right = bf:CreateTexture(nil,"BACKGROUND",nil,2)
    right:SetPoint("LEFT",bf,"RIGHT",0,0)
    right:SetSize(h,h)
    right:SetTexture(cfg.textures.right)
    --position castbar
    f.castbar:SetStatusBarTexture(cfg.textures.bar)
    f.castbar:ClearAllPoints()
    f.castbar:SetAllPoints(bf)
    f.castbar:SetParent(bf)
    --reparent textures to make them fade out with castbar
    right:SetParent(f.castbar)
    left:SetParent(f.castbar)
    bg:SetParent(f.castbar)
    --highlight frame
    local hl = CreateFrame("Frame",nil,f.castbar)
    hl:SetAllPoints(bf)
    --highlight texture
    local gl = hl:CreateTexture(nil,"BACKGROUND",nil,3)
    gl:SetAllPoints(hl)
    gl:SetTexture(cfg.textures.highlight)
    --move icon to gloss frame
    local ic = CreateFrame("Frame",nil,hl)
    ic:SetSize(cfg.castbar.icon.size,cfg.castbar.icon.size)
    ic:SetPoint(cfg.castbar.icon.pos.a1,cfg.castbar.icon.pos.x,cfg.castbar.icon.pos.y)
    --castbar icon adjust
    f.castbar.icon:SetTexCoord(0.1,0.9,0.1,0.9)
    f.castbar.icon:ClearAllPoints()
    f.castbar.icon:SetAllPoints(ic)
    f.castbar.icon:SetParent(ic)
    f.castbar.icon:SetDrawLayer("BACKGROUND",3)
    local ib = ic:CreateTexture(nil,"BACKGROUND",nil,5)
    ib:SetTexture(cfg.textures.icon_border)
    ib:SetPoint("TOPLEFT", ic, "TOPLEFT", -2, 2)
    ib:SetPoint("BOTTOMRIGHT", ic, "BOTTOMRIGHT", 2, -2)
    f.castbar.parent = bf --keep reference to parent element for later
    f.castbar_holder = bf
  end

  --update style func
  local updateStyle = function(f)
    hideStuff(f)
    fixStuff(f)
    updateText(f)
    updateHealth(f.healthbar)
  end

  --init style func
  local styleNameplate = function(f)
    if not f then return end
    if f and f.rDB_styled then return end
    --print(f:GetName())
    --make objects available for later
    f.healthbar, f.castbar = f:GetChildren()
    f.threat, f.border, f.highlight, f.name, f.level, f.boss, f.raid, f.dragon = f:GetRegions()
    f.castbar.texture, f.castbar.border, f.castbar.shield, f.castbar.icon = f.castbar:GetRegions()
    f.unit = {}
    --create stuff
    createArt(f)
    createCastbarArt(f)
    createNameString(f)
    createHpValueString(f)
    updateText(f)
    --hide stuff
    hideStuff(f)
    --hook stuff
    f:HookScript("OnShow", updateStyle)
    f.castbar:HookScript("OnShow", updateCastbar)
    --fix castbar
    f.castbar:SetScript("OnValueChanged", fixCastbar)
    --f.castbar:SetScript("OnMinMaxChanged", fixCastbar)
    --f.castbar:SetScript("OnSizeChanged", fixCastbar)
    --update health
    f.healthbar:SetScript("OnValueChanged", updateHealth)
    updateHealth(f.healthbar)
    --set var
    f.rDP_styled = true
  end

  --check
  local IsNamePlateFrame = function(f)
    local name = f:GetName()
    if name and name:find("NamePlate") then
      return true
    end
    f.rDP_styled = true --don't touch this frame again
    return false
  end

  local startSearch = function(self)
    --timer
    local ag = self:CreateAnimationGroup()
    ag.anim = ag:CreateAnimation()
    ag.anim:SetDuration(0.33)
    ag:SetLooping("REPEAT")
    ag:SetScript("OnLoop", function(self, event, ...)
      local num = select("#", WorldFrame:GetChildren())
      for i = 1, num do
        local f = select(i, WorldFrame:GetChildren())
        if not f.rDP_styled and IsNamePlateFrame(f) then
          styleNameplate(f)
        end
      end
    end)
    ag:Play()
  end

  --init
  local a = CreateFrame("Frame")
  a:RegisterEvent("PLAYER_LOGIN")
  a:SetScript("OnEvent", function(self,event,...)
    if event == "PLAYER_LOGIN" then
      SetCVar("bloattest",0)--0.0
      SetCVar("bloatnameplates",0)--0.0
      SetCVar("bloatthreat",0)--1
      startSearch(self)
    end
  end)