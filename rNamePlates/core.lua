
  -- // rNamePlaters
  -- // zork - 2010
  
  -----------------------------
  -- FUNCTIONS
  -----------------------------

  local styleNamePlate = function(f)
    
    local healthBar, castBar = f:GetChildren()
    local threatTexture, borderTexture, castborderTexture, shield, castbaricon, highlightTexture, nameText, levelText, bossIcon, raidIcon, dragonTexture = f:GetRegions()
    local r, g, b, a
    
    --enemycolor
    f.enemycolor = {}    
    r,g,b = healthBar:GetStatusBarColor()
    f.enemycolor.r, f.enemycolor.g, f.enemycolor.b = floor(r*100+.5)/100, floor(g*100+.5)/100, floor(b*100+.5)/100
    
    --difficultycolor
    f.difficultycolor = {}
    r,g,b = levelText:GetTextColor()
    f.difficultycolor.r,f.difficultycolor.g,f.difficultycolor.b = floor(r*100+.5)/100, floor(g*100+.5)/100, floor(b*100+.5)/100
    
    f.unitname = nameText:GetText()
    f.unitlvl = levelText:GetText()

    local elite = ""
    if dragonTexture:IsShown() == 1 then
      elite = "+"
    end

    --hp bg
    local t = healthBar:CreateTexture(nil,"BACKGROUND",-8)
    t:SetAllPoints(healthBar)
    t:SetTexture("Interface\\TargetingFrame\\UI-TargetingFrame-BarFill")
    t:SetVertexColor(0,0,0,0.4)
    healthBar.bg = t
    
    --new name
    local na = f:CreateFontString(nil, "BORDER")
    na:SetFont(STANDARD_TEXT_FONT, 12, "THINOUTLINE")
    na:SetPoint("BOTTOM", healthBar, "TOP", 0, 4)
    na:SetPoint("RIGHT", healthBar, 5, 0)
    if f.enemycolor.r == 0 and f.enemycolor.g == 0 and f.enemycolor.b == 1 then
      na:SetTextColor(0,0.7,1)
    else
      na:SetTextColor(f.enemycolor.r,f.enemycolor.g,f.enemycolor.b)
    end
    na:SetText(f.unitname)
    na:SetJustifyH("LEFT")    
    
    --new lvl txt
    local lvl = f:CreateFontString(nil, "BORDER")
    lvl:SetFont(STANDARD_TEXT_FONT, 12, "THINOUTLINE")
    lvl:SetPoint("BOTTOM", healthBar, "TOP", 0, 4)
    lvl:SetPoint("LEFT", healthBar, 0, 0)
    lvl:SetTextColor(f.difficultycolor.r,f.difficultycolor.g,f.difficultycolor.b)
    lvl:SetText(f.unitlvl..elite)
    lvl:SetJustifyH("LEFT")
    
    na:SetPoint("LEFT", lvl, "RIGHT", 0, 0)
    
    f.na = na
    f.lvl = lvl
    
    --boss icon
    bossIcon:ClearAllPoints()
    bossIcon:SetPoint("RIGHT", na, "LEFT", 0, 0)
    
    --castbars
    local w,h = healthBar:GetWidth(), healthBar:GetHeight()
    castBar:SetSize(w,h)
    castBar:ClearAllPoints()
    castBar:SetPoint("BOTTOM",healthBar,0,-20)

    castborderTexture:SetTexture("Interface\\Tooltips\\Nameplate-CastBar")
    castborderTexture:SetSize(w+25,(w+25)/4)
    castborderTexture:ClearAllPoints()
    castborderTexture:SetPoint("CENTER",-19,-29)
    castborderTexture:SetTexCoord(0,1,0,1)
    
    shield:SetSize(w+25,(w+25)/4)
    shield:ClearAllPoints()
    shield:SetPoint("CENTER",-19,-29)    
    shield:SetTexCoord(0,1,0,1)
    
    castbaricon:ClearAllPoints()
    castbaricon:SetPoint("LEFT",castBar,-20,0)
    castbaricon:SetTexCoord(0.1,0.9,0.1,0.9)
    
    --castbar bg
    local t2 = castBar:CreateTexture(nil,"BACKGROUND",-8)
    t2:SetAllPoints(castBar)
    t2:SetTexture("Interface\\TargetingFrame\\UI-TargetingFrame-BarFill")
    t2:SetVertexColor(0,0,0,0.4)
    t2:Hide()
    
    castBar.bg = t2    
    castBar.border = castborderTexture
    castBar.shield = shield
    castBar.icon = castbaricon
    
    --raidicon
    raidIcon:ClearAllPoints()
    raidIcon:SetSize(20,20)
    raidIcon:SetPoint("BOTTOM",healthBar,"TOP",0,17)
    
    --disable some stuff
    nameText:Hide()
    levelText:Hide()
    dragonTexture:SetTexture("") --just plain ugly!

    --make castbar stuff get into position on castbar load
    castBar:HookScript("OnShow", function(s)
      --print("nameplate casting")
      s:ClearAllPoints()
      s:SetPoint("BOTTOM",healthBar,0,-20)
      s.bg:Show()
      s.bg:SetAllPoints(castBar)
      s.border:ClearAllPoints()
      s.border:SetPoint("CENTER",-19,-29)
      s.shield:ClearAllPoints()
      s.shield:SetPoint("CENTER",-19,-29)
      s.icon:ClearAllPoints()
      s.icon:SetPoint("LEFT",castBar,-20,0)
    end)
    
    castBar:HookScript("OnHide", function(s)
      s.bg:Hide()
    end)
    
    f:HookScript("OnShow", function(s) 
      local healthBar, castBar = s:GetChildren()
      local threatTexture, borderTexture, castborderTexture, shield, castbaricon, highlightTexture, nameText, levelText, bossIcon, raidIcon, dragonTexture = s:GetRegions()
      s.na:SetText(nameText:GetText())
      local r,g,b = healthBar:GetStatusBarColor()
      r,g,b = floor(r*100+.5)/100, floor(g*100+.5)/100, floor(b*100+.5)/100
      if r == 0 and g == 0 and b == 1 then
        s.na:SetTextColor(0,0.7,1)
      else
        s.na:SetTextColor(r,g,b)
      end
      local elite = ""
      if dragonTexture:IsShown() == 1 then
        elite = "+"
      end
      if bossIcon:IsShown() ~= 1 then
        s.lvl:SetText(levelText:GetText()..elite)
        s.lvl:SetTextColor(levelText:GetTextColor())
      else
        s.lvl:SetText("")
      end
      levelText:Hide()
      nameText:Hide()
    end)
        
    f.styled = true
      
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
  
