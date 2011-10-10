
  -- // rDiabloPlates
  -- // zork - 2010

  -----------------------------
  -- CONFIG
  -----------------------------

  local cfg = {
    frame = {
      scale       = 0.7,
      adjust_pos  = { x = 0, y = 0, },
    },
    textures = {
      bg          = "Interface\\Addons\\rDiabloPlates2\\media\\nameplate_bg",
      bar         = "Interface\\Addons\\rDiabloPlates2\\media\\nameplate_bar",
      threat      = "Interface\\Addons\\rDiabloPlates2\\media\\nameplate_threat",
      highlight   = "Interface\\Addons\\rDiabloPlates2\\media\\nameplate_highlight",
      left        = "Interface\\Addons\\rDiabloPlates2\\media\\nameplate_left",
      right       = "Interface\\Addons\\rDiabloPlates2\\media\\nameplate_right",
    },
    font = {
      scale       = 0.9,
    },

  }

  -----------------------------
  -- FUNCTIONS
  -----------------------------

  local function RGBPercToHex(r, g, b)
    r = r <= 1 and r >= 0 and r or 0
    g = g <= 1 and g >= 0 and g or 0
    b = b <= 1 and b >= 0 and b or 0
    return string.format("%02x%02x%02x", r*255, g*255, b*255)
  end

  --set txt func
  local applyText = function(f,levelText,dragonTexture,bossIcon,nameText,healthBar)

    local r,g,b = levelText:GetTextColor()
    r,g,b = floor(r*100+.5)/100, floor(g*100+.5)/100, floor(b*100+.5)/100
    local colorstring = RGBPercToHex(r,g,b)

    local r,g,b = healthBar:GetStatusBarColor()
    r,g,b = floor(r*100+.5)/100, floor(g*100+.5)/100, floor(b*100+.5)/100
    if r==0 and g==0 and b==1 then
      --dark blue color of members of the own faction is barely readable
      f.na:SetTextColor(1,0,1)
    else
      f.na:SetTextColor(r,g,b)
    end

    local color = {
      r = r,
      g = g,
      b = b,
    }

    if not colorswitcher.classcolored then
      color = colorswitcher.bright
    end
    if colorswitcher.useBrightForeground then
      healthBar.new:SetVertexColor(color.r,color.g,color.b,color.a or 1)
      healthBar.bg:SetVertexColor(colorswitcher.dark.r,colorswitcher.dark.g,colorswitcher.dark.b,colorswitcher.dark.a)
    else
      healthBar.new:SetVertexColor(colorswitcher.dark.r,colorswitcher.dark.g,colorswitcher.dark.b,colorswitcher.dark.a)
      healthBar.bg:SetVertexColor(color.r,color.g,color.b,color.a or 1)
    end

    local name = nameText:GetText() or ""
    local level = levelText:GetText() or ""
    if bossIcon:IsShown() == 1 then
      level = "??"
      colorstring = "ff6600"
    elseif dragonTexture:IsShown() == 1 then
      level = level.."+"
    end

    f.na:SetText("|c00"..colorstring..""..level.."|r "..name)

  end

  --number format func
  local numFormat = function(v)
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

  --update healthbar function (only called when certain config settings are made)
  local updateHealthbar = function(healthBar,value)
    if healthBar and value then
      local min, max = healthBar:GetMinMaxValues()
      if value == 'x' then value = max end
      local p = floor(value/max*100)
      if colorswitcher then
        if p == 100 then
          healthBar.bg:SetWidth(0.01) --fix (0) makes the bar go anywhere
        elseif p < 100 then
          if p <= 25 then
            healthBar.shadow:SetVertexColor(1,0,0,1)
          else
            healthBar.shadow:SetVertexColor(0,0,0,0.7)
          end
          local w = healthBar.w
          healthBar.bg:SetWidth(w-(w*p/100)) --calc new width of bar based on size of healthbar
        end
      end
      if showhpvalue then
        if p < 100 then
          healthBar.hpval:SetText(numFormat(value).." / "..p.."%")
        elseif p == 100 and alwaysshowhp then
          healthBar.hpval:SetText(numFormat(value).." / "..p.."%")
        else
          healthBar.hpval:SetText("")
        end
      end
    end

  end

  --move raid icon func
  local moveRaidIcon = function(raidIcon,f)
    raidIcon:ClearAllPoints()
    raidIcon:SetSize(20,20)
    raidIcon:SetPoint("BOTTOM",f,"TOP",0,7)
  end

  --create castbar background func
  local createCastbarBG = function(castBar)
    local t = castBar:CreateTexture(nil,"BACKGROUND",nil,-8)
    t:SetAllPoints(castBar)
    t:SetTexture("Interface\\Addons\\rTextures\\statusbar5")
    t:SetVertexColor(0,0,0,0.4)
    t:Hide()
    castBar.bg = t
  end


  --new fontstrings for name and lvl func
  local createNewFontStrings = function(f,healthBar)
    --new name
    local na = f:CreateFontString(nil, "BORDER")
    na:SetFont(STANDARD_TEXT_FONT, 12*fontscale, "THINOUTLINE")
    na:SetPoint("BOTTOM", f.back, "TOP", 0, -9*scale)
    na:SetPoint("RIGHT", f.back, -20*scale, 0)
    na:SetPoint("LEFT", f.back, 20*scale, 0)
    na:SetJustifyH("CENTER")
    f.na = na
    if showhpvalue then
      local hp = f.helper:CreateFontString(nil, "OVERLAY")
      hp:SetFont(STANDARD_TEXT_FONT, 10*fontscale, "THINOUTLINE")
      hp:SetPoint("RIGHT",f.helper,"RIGHT",0,0)
      hp:SetJustifyH("RIGHT")
      healthBar.hpval = hp
    end
  end

  --update the castbar positioning
  local updateCastbarPosition = function(castBar)

    --local point, relativeTo, relativePoint, xOfs, yOfs = castBar:GetPoint(n)
    --xOfs = floor(xOfs+0.5)
    --yOfs = floor(yOfs+0.5)

    castBar.border:ClearAllPoints()
    castBar.border:SetPoint("CENTER",castBar:GetParent(),0,-29)

    --change castbar color to dark red if the cast is shielded
    if castBar.shield:IsShown() == 1 then
      castBar:SetStatusBarColor(0.7,0,0)
    else
      castBar:SetStatusBarColor(1,0.7,0)
    end
    castBar.shield:ClearAllPoints()
    castBar.shield:SetPoint("CENTER",castBar:GetParent(),0,-29)

    castBar:SetPoint("RIGHT",castBar.border,-1,0)
    castBar:SetPoint("TOP",castBar.border,0,-10)
    castBar:SetPoint("BOTTOM",castBar.border,0,12)
    castBar:SetPoint("LEFT",castBar.border,24,0)

    castBar.icon:ClearAllPoints()
    castBar.icon:SetPoint("LEFT",castBar.border,3,0)

  end

  --init the castbar objects
  local initCastbars = function(castBar,castborderTexture, shield, castbaricon)
    castborderTexture:SetTexture("Interface\\Tooltips\\Nameplate-CastBar")
    castborderTexture:SetSize(castBar.w+25,(castBar.w+25)/4)
    castborderTexture:SetTexCoord(0,1,0,1)
    castBar.border = castborderTexture

    shield:SetSize(castBar.w+25,(castBar.w+25)/4)
    shield:SetTexCoord(0,1,0,1)
    castBar.shield = shield

    castbaricon:SetTexCoord(0.1,0.9,0.1,0.9)
    castBar.icon = castbaricon

    castBar:SetStatusBarColor(1,0.7,0)
    createCastbarBG(castBar)

    castBar:HookScript("OnShow", function(s)
      s.bg:Show()
      updateCastbarPosition(s)
    end)

    castBar:HookScript("OnHide", function(s)
      s.bg:Hide()
    end)
  end

  local hideStuff = function(f)
    f.name:Hide()
    f.level:Hide()
    f.dragon:SetTexture("")
    f.border:SetTexture("")
    f.boss:SetTexture("")
    --f.healthbar:SetStatusBarTexture("")
    f.highlight:SetTexture("")
  end

  local fixStuff = function(f)
    f.threat:ClearAllPoints()
    f.threat:SetAllPoints(f.threat_holder)
    f.threat:SetParent(f.threat_holder)
    f.healthbar:ClearAllPoints()
    f.healthbar:SetAllPoints(f.back_holder)
    f.healthbar:SetParent(f.back_holder)
  end

  --update style func
  local updateStyle = function(f)
    hideStuff(f)
    fixStuff(f)
    --apply text
    --applyText(f,levelText,dragonTexture,bossIcon,nameText,healthBar)
  end


  --create art
  local createArt = function(f)
    f.w, f.h, f.hw, f.hh = f:GetWidth(), f:GetHeight(), f.healthbar:GetWidth(), f.healthbar:GetHeight()
    local w,h = f.w*cfg.frame.scale, f.w*cfg.frame.scale/4 --width/height ratio is 4:1
    local threat_adjust = 1.18 --threat size needs to be increased, texture is shrinked a bit to fit in
    --threat holder
    local th = CreateFrame("Frame",nil,f)
    th:SetSize(w*threat_adjust,h*threat_adjust)
    th:SetPoint("CENTER",f,"TOP",cfg.frame.adjust_pos.x,cfg.frame.adjust_pos.y) --anchor the plates to the top of the damn frame
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
    f.threat_holder = th
    f.back_holder = bf
  end

  --init style func
  local initStyle = function(f)

    f.healthbar, f.castbar = f:GetChildren()
    f.threat, f.border, f.highlight, f.name, f.level, f.boss, f.raid, f.dragon = f:GetRegions()
    f.castbar.texture, f.castbar.border, f.castbar.shield, f.castbar.icon = f.castbar:GetRegions()

    --init the size of health and castbar
    createArt(f)

    --hide stuff
    hideStuff(f)

    f:HookScript("OnShow", function(self)
      updateStyle(self)
    end)

    --[[
    --create new fontstrings
    createNewFontStrings(f,healthBar)

    --apply text
    applyText(f,levelText,dragonTexture,bossIcon,nameText,healthBar)

    --move some icons
    moveRaidIcon(raidIcon,f)

    --initialize the castbars
    initCastbars(castBar,castborderTexture, shield, castbaricon)

    ]]--

    return true

  end


  --STYLE NAMEPLATE FUNC
  local styleNamePlate = function(f)
    f.styled = initStyle(f)
  end

  local IsNamePlateFrame = function(f)
    local o = select(2,f:GetRegions())
    if not o or o:GetObjectType() ~= "Texture" or o:GetTexture() ~= "Interface\\Tooltips\\Nameplate-Border" then
      f.styled = true --don't touch this frame again
      return false
    end
    return true
  end

  local lastupdate = 0

  local searchNamePlates = function(self,elapsed)
    lastupdate = lastupdate + elapsed
    if lastupdate > 0.33 then
      lastupdate = 0
      local num = select("#", WorldFrame:GetChildren())
      for i = 1, num do
        local f = select(i, WorldFrame:GetChildren())
        if not f.styled and IsNamePlateFrame(f) then
          styleNamePlate(f)
        end
      end

    end
  end

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
