
  -- // rNamePlaters
  -- // zork - 2010
  
  -----------------------------
  -- FUNCTIONS
  -----------------------------

  --set unit name func
  local applyNameText = function(f,nameText)
    local txt = nameText:GetText()
    f.na:SetText(txt)
  end
  
  --set lvl txt func
  local applyLvlText = function(f,levelText,dragonTexture,bossIcon)
    local elite = ""
    if dragonTexture:IsShown() == 1 then 
      elite = "+" 
    end   
    if bossIcon:IsShown() ~= 1 then
      f.lvl:SetText(levelText:GetText()..elite)
    else
      f.lvl:SetText("")
    end
  end

  --apply difficultycolor func
  local applyDifficultyColor = function(f,levelText)
    local r,g,b = levelText:GetTextColor()
    r,g,b = floor(r*100+.5)/100, floor(g*100+.5)/100, floor(b*100+.5)/100
    f.lvl:SetTextColor(r,g,b)
  end

  --apply enemycolor func
  local applyEnemyColor = function(f,healthBar)
    local r,g,b = healthBar:GetStatusBarColor()
    r,g,b = floor(r*100+.5)/100, floor(g*100+.5)/100, floor(b*100+.5)/100
    if r==0 and g==0 and b==1 then
      --dark blue color of members of the own faction is barely readable
      f.na:SetTextColor(0.7,0.7,0.7)
    else
      f.na:SetTextColor(r,g,b)
    end
  end
  
  --move raid icon func
  local moveRaidIcon = function(raidIcon,healthBar)
    raidIcon:ClearAllPoints()
    raidIcon:SetSize(20,20)
    raidIcon:SetPoint("BOTTOM",healthBar,"TOP",0,17)
  end
  
  --move boss icon func
  local moveBossIcon = function(f, bossIcon)
    bossIcon:ClearAllPoints()
    bossIcon:SetPoint("RIGHT", f.na, "LEFT", 0, 0)
  end
  
  --create castbar background func
  local createCastbarBG = function(castBar)
    local t = castBar:CreateTexture(nil,"BACKGROUND",-8)
    t:SetAllPoints(castBar)
    t:SetTexture("Interface\\TargetingFrame\\UI-TargetingFrame-BarFill")
    t:SetVertexColor(0,0,0,0.4)
    t:Hide()
    castBar.bg = t
  end
  
  --create healthbar background func
  local createHealthbarBG = function(healthBar)
    --hp bg
    local t = healthBar:CreateTexture(nil,"BACKGROUND",-8)
    t:SetAllPoints(healthBar)
    t:SetTexture("Interface\\TargetingFrame\\UI-TargetingFrame-BarFill")
    t:SetVertexColor(0,0,0,0.4)
    healthBar.bg = t
  end

  --new fontstrings for name and lvl func
  local createNewFontStrings = function(f,healthBar)
    --new name
    local na = f:CreateFontString(nil, "BORDER")
    na:SetFont(STANDARD_TEXT_FONT, 12, "THINOUTLINE")
    na:SetPoint("BOTTOM", healthBar, "TOP", 0, 4)
    na:SetPoint("RIGHT", healthBar, 5, 0)
    na:SetJustifyH("LEFT")        
    --new lvl txt
    local lvl = f:CreateFontString(nil, "BORDER")
    lvl:SetFont(STANDARD_TEXT_FONT, 12, "THINOUTLINE")
    lvl:SetPoint("BOTTOM", healthBar, "TOP", 0, 4)
    lvl:SetPoint("LEFT", healthBar, 0, 0)
    lvl:SetJustifyH("LEFT")    
    na:SetPoint("LEFT", lvl, "RIGHT", 0, 0) --left point of name will be right point of level
    f.na = na
    f.lvl = lvl    
  end
  
  --update the castbar positioning
  local updateCastbarPosition = function(castBar)
    castBar:ClearAllPoints()
    castBar:SetPoint("CENTER",-10,-29)
    castBar.border:ClearAllPoints()
    castBar.border:SetPoint("CENTER",-19,-29)
    castBar.shield:ClearAllPoints()
    castBar.shield:SetPoint("CENTER",-19,-29)
    castBar.icon:ClearAllPoints()
    castBar.icon:SetPoint("LEFT",castBar,-20,0)
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

    createCastbarBG(castBar)    
    updateCastbarPosition(castBar)
    
    castBar:HookScript("OnShow", function(s)
      s.bg:Show()
      updateCastbarPosition(s)
    end)
    
    castBar:HookScript("OnHide", function(s)
      s.bg:Hide()
    end)    
  end
  
  --init the size parameters
  local initHealthCastbarSize = function(healthBar, castBar)
    local w,h = healthBar:GetWidth(), healthBar:GetHeight()
    healthBar.w = w
    healthBar.h = h
    castBar.w = w
    castBar.h = h
  end
  
  --hide blizz
  local hideBlizz = function(nameText,levelText,dragonTexture)
    nameText:Hide()
    levelText:Hide()
    dragonTexture:SetTexture("")
  end
  

  --update style func
  local updateStyle = function(f)
    --get the value
    local healthBar, castBar = f:GetChildren()
    local threatTexture, borderTexture, castborderTexture, shield, castbaricon, highlightTexture, nameText, levelText, bossIcon, raidIcon, dragonTexture = f:GetRegions()

    --apply color
    applyEnemyColor(f,healthBar)
    applyDifficultyColor(f,levelText)      
    
    --apply text
    applyNameText(f,nameText)
    applyLvlText(f,levelText,dragonTexture,bossIcon)
    
    --disable some stuff
    hideBlizz(nameText,levelText,dragonTexture)
  end

  --init style func
  local initStyle = function(f)
    --get the value
    local healthBar, castBar = f:GetChildren()
    local threatTexture, borderTexture, castborderTexture, shield, castbaricon, highlightTexture, nameText, levelText, bossIcon, raidIcon, dragonTexture = f:GetRegions()
    
    --init the size of health and castbar
    initHealthCastbarSize(healthBar,castBar)
    
    --create new fontstrings
    createNewFontStrings(f,healthBar)
    
    --apply color
    applyEnemyColor(f,healthBar)
    applyDifficultyColor(f,levelText)
    
    --apply text
    applyNameText(f,nameText)
    applyLvlText(f,levelText,dragonTexture,bossIcon)

    --move some icons
    moveBossIcon(f, bossIcon)
    moveRaidIcon(raidIcon,healthBar)

    --creaate healthbar bg
    createHealthbarBG(healthBar)
    
    --initialize the castbars
    initCastbars(castBar,castborderTexture, shield, castbaricon)
    
    --disable some stuff
    hideBlizz(nameText,levelText,dragonTexture)
    
    f:HookScript("OnShow", function(s)
      updateStyle(s)      
    end)
    
    return true

  end


  --STYLE NAMEPLATE FUNC
  local styleNamePlate = function(f)
    
    f.styled = initStyle(f)
  end

  local IsNamePlateFrame = function(f)
    if f:GetName() then return false end    
    local o = select(2,f:GetRegions())
    if not o or o:GetObjectType() ~= "Texture" or o:GetTexture() ~= "Interface\\Tooltips\\Nameplate-Border" then return false end    
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
      SetCVar("bloattest",1)--0.0
      SetCVar("bloatnameplates",0.0)--0.0
      SetCVar("spreadnameplates",0)--1
      SetCVar("bloatthreat",0)--1
      self:SetScript("OnUpdate", searchNamePlates)
    end
  end)
  
  a:RegisterEvent("PLAYER_LOGIN")
  
