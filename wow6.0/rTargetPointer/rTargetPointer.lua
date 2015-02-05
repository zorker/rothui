
  -- // rTargetPointer
  -- // zork - 2015

  -----------------------------
  -- VARIABLES
  -----------------------------

  local an, at = ...

  local WorldFrame, math, string = WorldFrame, math, string
  local hasTarget = false
  local lastPoint = {}

  local timer = CreateFrame("Frame")
  local addon = CreateFrame("Frame", nil, UIParent)
  local sizer = CreateFrame("Frame", nil, WorldFrame)

  -----------------------------
  -- FUNCTIONS
  -----------------------------

  --local t = sizer:CreateTexture()
  --t:SetAllPoints()
  --t:SetTexture(1,1,1)
  --t:SetVertexColor(0,1,1,0.3)

  local arrow = addon:CreateTexture(nil,"BACKGROUND",nil,-8)
  arrow:SetTexture("Interface\\AddOns\\"..an.."\\media\\pointer")
  arrow:SetSize(sqrt(2)*256,sqrt(2)*256)
  arrow:SetPoint("CENTER")
  arrow:SetVertexColor(1,0,0)
  arrow:SetBlendMode("ADD") --"ADD" or "BLEND"
  arrow:SetRotation(math.rad(0))

  local function rTP_RotateArrow()
    local x2,y2 = WorldFrame:GetCenter()
    local x3 = math.floor(lastPoint.x-x2)
    local y3 = math.floor(lastPoint.y-y2)
    local d = math.floor(math.deg(math.atan(x3/y3)))
    --print("x",x3,"y",y3,"@",d)
    if x3 >= 0 and y3 >= 0 then
      d = d*(-1)
    elseif x3 >= 0 and y3 <= 0 then
      d = (-180-d)
    elseif x3 <= 0 and y3 >= 0 then
      d = d*(-1)
    elseif x3 <= 0 and y3 <= 0 then
      d = (180-d)
    end
    arrow:SetRotation(math.rad(d))
  end

  local function rTP_SizerOnSizeChanged(self, x, y)
    if self:IsShown() then
      lastPoint.x,lastPoint.y = x,y
      rTP_RotateArrow()
    end
  end

  local function rTP_ScanNamePlates()
    --print("rTP_ScanNamePlates")
    sizer:Hide()
    for _, frame in next, {WorldFrame:GetChildren()} do
      if hasTarget and frame:IsShown() and frame:GetAlpha() == 1 and frame:GetName() and string.match(frame:GetName(), "^NamePlate%d+$") then
        sizer:ClearAllPoints()
        sizer:SetPoint("TOPRIGHT", frame, "CENTER")
        sizer:SetPoint("BOTTOMLEFT", WorldFrame)
        lastPoint.x,lastPoint.y = frame:GetCenter()
        rTP_RotateArrow()
        sizer:Show()
        arrow:Show()
        break
      end
    end
  end

  local timeElapsed = 0.0
  local interval = 0.1

  local function rTP_TimerOnUpdate(self,elapsed)
    timeElapsed = timeElapsed+elapsed
    if timeElapsed > interval then
      rTP_ScanNamePlates()
      timeElapsed = 0
    end
  end

  local function rTP_PlayerTargetChanged(...)
    --print("rTP_PlayerTargetChanged")
    sizer:Hide()
    arrow:Hide()
    if UnitExists("target") and not UnitIsUnit("target","player") and not UnitIsDead("target") then
      frameDelayCounter = 0
      hasTarget = true
      timer:Show()
    else
      hasTarget = false
      timer:Hide()
    end
  end

  -----------------------------
  -- INIT
  -----------------------------

  timer:SetScript("OnUpdate",rTP_TimerOnUpdate)
  timer:Hide()

  addon:RegisterEvent("PLAYER_TARGET_CHANGED")
  addon:SetScript("OnEvent",rTP_PlayerTargetChanged)
  addon:SetSize(32,32)
  addon:SetPoint("CENTER")
  arrow:Hide()

  sizer:SetScript("OnSizeChanged", rTP_SizerOnSizeChanged)
  sizer:Hide()