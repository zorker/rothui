
local an, at = ...

--updatehealth
local function UpdateHealth(self,...)
  local hmin,hmax = self:GetMinMaxValues()
  local hcur = self:GetValue()
  local hcurp = hcur/hmax or 0  
  local doomHealth = self.__owner.doomHealth  
  if hcurp == 0 then 
    doomHealth:Hide()
    return
  else
    doomHealth:Show()
  end
  local ULx,ULy, LLx,LLy, URx,URy, LRx,LRy = 0,0, 0,1, hcurp,0, hcurp,1
  if doomHealth.orientation == "LEFT" then
    doomHealth:SetTexCoord(ULx,ULy, LLx,LLy, URx,URy, LRx,LRy)
  elseif doomHealth.orientation == "RIGHT" then
    doomHealth:SetTexCoord(URx,URy, LRx,LRy, ULx,ULy, LLx,LLy)
  end
  doomHealth:SetWidth(256*hcurp)
end

--doomtemplate
local function DoomTemplate(self)
  if self.unit == "player" then
    self.templateUnit = "player"
  elseif self.unit == "target" then
    self.templateUnit = "target"
  end
  self:SetSize(256,64)  
  --fake health
  local health = CreateFrame("StatusBar",nil,self)  
  self.Health = health  
  --self.Health:HookScript("OnValueChanged", UpdateHealth)
  self.Health.PostUpdate = UpdateHealth
  --doom health
  local doomHealth = self:CreateTexture(nil,"BACKGROUND",nil,-8)
  doomHealth:SetTexture("interface/addons/ouf_doom/statusbar")
  doomHealth:SetSize(256,64)
  if self.templateUnit == "player" then
    doomHealth.orientation = "LEFT"
    doomHealth:SetPoint(doomHealth.orientation)
  elseif self.templateUnit == "target" then
    doomHealth.orientation = "RIGHT"
    doomHealth:SetPoint(doomHealth.orientation)
  end 
  self.doomHealth = doomHealth  
end

--register template can spawn the units
oUF:RegisterStyle(an.."DoomTemplate", DoomTemplate)
oUF:SetActiveStyle(an.."DoomTemplate")
local playerFrame = oUF:Spawn("player", an.."PlayerFrame")
playerFrame:SetPoint("CENTER",-200,0)
local targetFrame = oUF:Spawn("target", an.."TargetFrame")
targetFrame:SetPoint("CENTER",200,0)