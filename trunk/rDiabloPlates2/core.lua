
  -- // rDiabloPlates2
  -- // zork - 2011

  -----------------------------
  -- CONFIG
  -----------------------------

  local cfg = {
    frame = {
      scale       = 0.7,
      adjust_pos  = { x = 0, y = 0, },
    },
    healthbar = {
      lowHpWarning = {
        enable = true,
        treshold = 25,
        color   = { r = 1, g = 0, b = 0 },
      },
    },
    castbar = {
      scale       = 0.7,
      adjust_pos  = { x = 0, y = -17, },
      icon = {
        size = 30,
        pos = { a1 = "LEFT", x = -50, y = 8}
      },
      color = {
        default   = { r = 1, g = 0.6, b = 0 },
        shielded  = { r = 0.8, g = 0.8, b = 0.8 },
      },
    },
    raidmark = {
      icon = {
        size = 25,
        pos = { a1 = "CENTER", x = 0, y = 35}
      },
    },
    name = {
      enable = true,
      font = STANDARD_TEXT_FONT,
      size = 10,
      outline = "THINOUTLINE",
      pos_1 = { a1 = "LEFT", x = -10, y = 0},
      pos_2 = { a1 = "RIGHT", x = 10, y = 0},
      pos_3 = { a1 = "TOP", x = 0, y = 7},
    },
    hpvalue = {
      enable = false,
      font = STANDARD_TEXT_FONT,
      size = 8,
      outline = "THINOUTLINE",
      pos_1 = { a1 = "RIGHT", x = 0, y = 0},
    },
    textures = {
      bg          = "Interface\\Addons\\rDiabloPlates2\\media\\nameplate_bg",
      bar         = "Interface\\Addons\\rDiabloPlates2\\media\\nameplate_bar",
      threat      = "Interface\\Addons\\rDiabloPlates2\\media\\nameplate_threat",
      highlight   = "Interface\\Addons\\rDiabloPlates2\\media\\nameplate_highlight",
      left        = "Interface\\Addons\\rDiabloPlates2\\media\\nameplate_left",
      right       = "Interface\\Addons\\rDiabloPlates2\\media\\nameplate_right",
      icon_border = "Interface\\Addons\\rDiabloPlates2\\media\\icon_border",
    },
  }

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

  --get healthbar color func
  local getHealthbarColor = function(f)
    local color = {}
    color.r,color.g,color.b = f.healthbar:GetStatusBarColor()
    fixColor(color)
    return color
  end

  --set txt func
  local updateText = function(f)
    if not cfg.name.enable then return end
    local cs = getDifficultyColorString(f)
    local color = getHealthbarColor(f)
    if color.r==0 and color.g==0 and color.b==1 then
      --dark blue color of members of the own faction is barely readable
      f.ns:SetTextColor(0,0.6,1)
    else
      f.ns:SetTextColor(color.r,color.g,color.b)
    end
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
    fixCastbar(cb)
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
      if p <= cfg.healthbar.lowHpWarning.treshold then
        local c = cfg.healthbar.lowHpWarning.color
        hb:SetStatusBarColor(c.r,c.g,c.b)
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
    fixCastbar(f.castbar)
    updateText(f)
    updateHealth(f.healthbar)
  end

  --init style func
  local styleNameplate = function(f)
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
    f.castbar:SetScript("OnValueChanged", fixCastbar)
    f.healthbar:SetScript("OnValueChanged", updateHealth)
    updateHealth(f.healthbar)
    --set var
    f.styled = true
  end

  --check
  local IsNamePlateFrame = function(f)
    local o = select(2,f:GetRegions())
    if not o or o:GetObjectType() ~= "Texture" or o:GetTexture() ~= "Interface\\Tooltips\\Nameplate-Border" then
      f.styled = true --don't touch this frame again
      return false
    end
    return true
  end

  --onupdate
  local lastupdate = 0
  local searchNamePlates = function(self,elapsed)
    lastupdate = lastupdate + elapsed
    if lastupdate > 0.33 then
      lastupdate = 0
      local num = select("#", WorldFrame:GetChildren())
      for i = 1, num do
        local f = select(i, WorldFrame:GetChildren())
        if not f.styled and IsNamePlateFrame(f) then
          styleNameplate(f)
        end
      end

    end
  end

  --init
  local a = CreateFrame("Frame")
  a:SetScript("OnEvent", function(self, event)
    if(event=="PLAYER_LOGIN") then
      SetCVar("ShowClassColorInNameplate",1)--1
      SetCVar("bloattest",0)--0.0
      SetCVar("bloatnameplates",0)--0.0
      SetCVar("bloatthreat",0)--1
      self:SetScript("OnUpdate", searchNamePlates)
    end
  end)
  a:RegisterEvent("PLAYER_LOGIN")
