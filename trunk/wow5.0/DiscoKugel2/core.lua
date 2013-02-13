
  -- // DiscoKugel2
  -- // zork - 2013

  --get the addon namespace
  local addon, ns = ...

  local unpack = unpack
  local _G = _G
  local CF = CreateFrame
  local UIP = UIParent
  
  local backdrop = {
    bgFile = "Interface\\Tooltips\\UI-Tooltip-Background", 
    edgeFile = "Interface\\Tooltips\\UI-Tooltip-Border", 
    tile = true, 
    tileSize = 16, 
    edgeSize = 16, 
    insets = { left = 4, right = 4, top = 4, bottom = 4 },
  }
  
  -----------------------------
  -- FUNCTIONS
  -----------------------------
  
  local calculateOffsetFromPercent = function(orb,value)
    if not value or value and value < 0 then value = 0 end
    if value > 100 then value = 100 end
    return orb.size-value*orb.size/100
  end
  
  local updateHealth = function(orb,value)
    --print(value)
    orb.health:SetValue(value)
    
    local offset = calculateOffsetFromPercent(orb,value)
    print(offset)
    orb.scrollFrameHealth:SetPoint(orb.scrollFrameHealth:GetPoint(),0,-offset)
    orb.scrollFrameHealth:SetVerticalScroll(offset)
  end
  
  local updatePower = function(orb,value)
    --print(value)
    orb.power:SetValue(value)
    
    local offset = calculateOffsetFromPercent(orb,value)
    print(offset)
    orb.scrollFramePower:SetPoint(orb.scrollFramePower:GetPoint(),0,-offset)
    orb.scrollFramePower:SetVerticalScroll(offset)
  end
  
  local createHealthOrb = function()

    local orb = CF("FRAME","OrbBase",UIP)
    orb:SetSize(150,150)
    orb.size = orb:GetHeight()
    orb.type = "health"
    orb:SetScale(0.82)
    orb:SetPoint("CENTER",0,0)

    local bg = orb:CreateTexture("$parentBG","BACKGROUND",nil,-8)
    bg:SetAllPoints()
    bg:SetTexture("Interface\\AddOns\\DiscoKugel2\\media\\orb_back")
    orb.bg = bg
    
    local health = CF("StatusBar","$parentHealth",orb)
    health:SetAllPoints()
    health:SetMinMaxValues(0, 100)
    health:SetStatusBarTexture("Interface\\AddOns\\DiscoKugel2\\media\\orb_filling1")
    health:SetStatusBarColor(1,0,0)
    health:SetOrientation("VERTICAL")
    orb.health = health
    
    local scrollFrame = CF("ScrollFrame",nil,orb)
    scrollFrame:SetSize(orb:GetSize())
    scrollFrame:SetPoint("TOP")
    
    local scrollChild = CF("Frame")
    scrollChild:SetSize(orb:GetSize())
    scrollFrame:SetScrollChild(scrollChild)
    orb.scrollFrameHealth = scrollFrame
       
    local model = CF("PlayerModel",nil,scrollChild)
    model:SetSize(orb:GetSize())
    model:SetPoint("TOP")
    model:ClearFog()
    model:ClearModel()
    --model:SetModel("interface\\buttons\\talktomequestionmark.m2") --in case setdisplayinfo fails
    model:SetDisplayInfo(38699)
    model:SetPortraitZoom(0)
    model:SetCamDistanceScale(0.28)
    model:SetPosition(0,0,0)
    model:SetRotation(0)
    --model:SetBackdrop(backdrop)
    
    local overlay = CF("Frame",nil,scrollFrame)
    overlay:SetAllPoints(orb)
    
    local gloss = overlay:CreateTexture(nil,"BACKGROUND",nil,-8)
    gloss:SetAllPoints()
    gloss:SetTexture("Interface\\AddOns\\DiscoKugel2\\media\\orb_gloss")
    
    return orb
    
  end
  
  local createHealthOrbWithGalaxies = function()

    local orb = CF("FRAME","OrbBase",UIP)
    orb:SetSize(150,150)
    orb.size = orb:GetHeight()
    orb.type = "health"
    orb:SetScale(0.82)
    orb:SetPoint("CENTER",300,0)

    local bg = orb:CreateTexture("$parentBG","BACKGROUND",nil,-8)
    bg:SetAllPoints()
    bg:SetTexture("Interface\\AddOns\\DiscoKugel2\\media\\orb_back")
    orb.bg = bg
    
    local health = CF("StatusBar","$parentHealth",orb)
    health:SetAllPoints()
    health:SetMinMaxValues(0, 100)
    health:SetStatusBarTexture("Interface\\AddOns\\DiscoKugel2\\media\\orb_filling1")
    health:SetStatusBarColor(1,0.6,0)
    health:SetOrientation("VERTICAL")
    orb.health = health
    
    local scrollFrame = CF("ScrollFrame",nil,orb)
    scrollFrame:SetSize(orb:GetSize())
    scrollFrame:SetPoint("TOP")
    
    local scrollChild = CF("Frame")
    scrollChild:SetSize(orb:GetSize())
    scrollFrame:SetScrollChild(scrollChild)
    orb.scrollFrameHealth = scrollFrame
       
    for i=1,3 do
      local galaxy = scrollChild:CreateTexture(nil, "BACKGROUND", nil, sublevel)
      galaxy:SetSize(orb:GetSize())
      galaxy:SetPoint("CENTER")
      galaxy:SetTexture("Interface\\AddOns\\DiscoKugel2\\\media\\galaxy"..i)
      galaxy:SetVertexColor(1,0.6,0)
      galaxy:SetBlendMode("ADD")
      local ag = galaxy:CreateAnimationGroup()
      local anim = ag:CreateAnimation("Rotation")
      anim:SetDegrees(360)
      anim:SetDuration(i*30)
      ag:Play()
      ag:SetLooping("REPEAT")
    end
       
       
    local model = CF("PlayerModel",nil,scrollChild)
    model:SetSize(orb:GetSize())
    model:SetPoint("TOP")
    model:ClearFog()
    model:ClearModel()
    --model:SetModel("interface\\buttons\\talktomequestionmark.m2") --in case setdisplayinfo fails
    model:SetDisplayInfo(32368)
    model:SetPortraitZoom(0)
    model:SetCamDistanceScale(0.8)
    model:SetPosition(0,0,0.2)
    model:SetRotation(0)
    --model:SetBackdrop(backdrop)
    model:SetAlpha(1)


    
    local overlay = CF("Frame",nil,scrollFrame)
    overlay:SetAllPoints(orb)
    
    local gloss = overlay:CreateTexture(nil,"BACKGROUND",nil,-8)
    gloss:SetAllPoints()
    gloss:SetTexture("Interface\\AddOns\\DiscoKugel2\\media\\orb_gloss")
    
    return orb
    
  end
  
  local createHealthPowerOrb = function()

    local orb = CF("FRAME","OrbBase",UIP)
    orb:SetSize(150,150)
    orb.size = orb:GetHeight()
    orb.type = "healthpower"
    orb:SetScale(0.82)
    orb:SetPoint("CENTER",-300,0)

    local bg = orb:CreateTexture("$parentBG","BACKGROUND",nil,-8)
    bg:SetAllPoints()
    bg:SetTexture("Interface\\AddOns\\DiscoKugel2\\media\\orb_back")
    orb.bg = bg
    
    local health = CF("StatusBar","$parentHealth",orb)
    health:SetAllPoints()
    health:SetMinMaxValues(0, 100)
    health:SetStatusBarTexture("Interface\\AddOns\\DiscoKugel2\\media\\orb_filling_left")
    health:SetStatusBarColor(1,0,0)
    health:SetOrientation("VERTICAL")
    orb.health = health

    local power = CF("StatusBar","$parentHealth",orb)
    power:SetAllPoints()
    power:SetMinMaxValues(0, 100)
    power:SetStatusBarTexture("Interface\\AddOns\\DiscoKugel2\\media\\orb_filling_right")
    power:SetStatusBarColor(0,0.2,1)
    power:SetOrientation("VERTICAL")
    orb.power = power
    
    local scrollFrame = CF("ScrollFrame",nil,orb)
    scrollFrame:SetSize(orb.size/2,orb.size)
    scrollFrame:SetPoint("TOPLEFT")
    
    local scrollChild = CF("Frame")
    scrollChild:SetSize(orb:GetSize())
    scrollFrame:SetScrollChild(scrollChild)
    orb.scrollFrameHealth = scrollFrame

    local model = CF("PlayerModel",nil,scrollChild)
    model:SetSize(orb:GetSize())
    model:SetPoint("TOPLEFT")
    model:ClearFog()
    model:ClearModel()
    --model:SetModel("interface\\buttons\\talktomequestionmark.m2") --in case setdisplayinfo fails
    model:SetDisplayInfo(23422)
    model:SetPortraitZoom(0)
    model:SetCamDistanceScale(1.55)
    model:SetPosition(0,0,1)
    model:SetRotation(0)
    --model:SetBackdrop(backdrop)
    
    local scrollFrame = CF("ScrollFrame",nil,orb)
    scrollFrame:SetSize(orb.size/2,orb.size)
    scrollFrame:SetPoint("TOPRIGHT")
    
    local scrollChild = CF("Frame")
    scrollChild:SetSize(orb:GetSize())
    scrollFrame:SetScrollChild(scrollChild)
    orb.scrollFramePower = scrollFrame
       
    local model = CF("PlayerModel",nil,scrollChild)
    model:SetSize(orb:GetSize())
    model:SetPoint("TOPRIGHT",-orb.size/2,0)
    model:ClearFog()
    model:ClearModel()
    --model:SetModel("interface\\buttons\\talktomequestionmark.m2") --in case setdisplayinfo fails
    model:SetDisplayInfo(34319)
    model:SetPortraitZoom(0)
    model:SetCamDistanceScale(1.55)
    model:SetPosition(0,0,1)
    model:SetRotation(0)
    --model:SetBackdrop(backdrop)
   
    local anchor
    if orb.scrollFramePower:GetFrameLevel() > orb.scrollFrameHealth:GetFrameLevel() then
      anchor = orb.scrollFramePower
    else
      anchor = orb.scrollFrameHealth
    end
    
    local overlay = CF("Frame",nil,anchor)
    overlay:SetAllPoints(orb)
    
    local gloss = overlay:CreateTexture(nil,"BACKGROUND",nil,-8)
    gloss:SetAllPoints()
    gloss:SetTexture("Interface\\AddOns\\DiscoKugel2\\media\\orb_gloss2")
    gloss:SetAlpha(1)
    
    return orb
    
  end

  local createSliderWithEditbox = function(name)
    local slider = CF("Slider", name, UIP, "OptionsSliderTemplate")
    local editbox = CF("EditBox", "$parentEditBox", slider, "InputBoxTemplate")

    slider:SetMinMaxValues(0, 100)
    slider:SetValue(100)
    slider:SetValueStep(1)
    
    slider.text = _G[name.."Text"]
    
    editbox:SetSize(30,30)
    editbox:ClearAllPoints()
    editbox:SetPoint("LEFT", slider, "RIGHT", 15, 0)
    editbox:SetText(slider:GetValue())
    editbox:SetAutoFocus(false)

    editbox.slider = slider
    slider.editbox = editbox
    
    return slider    
  
  end  

  -----------------------------
  -- CALL
  -----------------------------

  --HEALTH ORB
  
  local healthOrb = createHealthOrb()
  local slider1Health = createSliderWithEditbox(addon.."Slider1Health")
  
  slider1Health:ClearAllPoints()
  slider1Health:SetPoint("TOP", healthOrb, "BOTTOM", 0, -30)
  slider1Health.text:SetText("Health")
  
  slider1Health:SetScript("OnValueChanged", function(self,value)
    self.editbox:SetText(value)
    updateHealth(healthOrb, self:GetValue())
  end)

  slider1Health.editbox:SetScript("OnEnterPressed", function(self)
    self:GetParent():SetValue(self:GetText())
    updateHealth(healthOrb, self:GetParent():GetValue())
    self:ClearFocus()
  end)   

  
  --HEALTH POWER ORB (SPLIT ORB!)
  
  local healthPowerOrb = createHealthPowerOrb()
  local slider2Health = createSliderWithEditbox(addon.."Slider2Health")
  
  slider2Health:ClearAllPoints()
  slider2Health:SetPoint("TOP", healthPowerOrb, "BOTTOM", 0, -30)
  slider2Health.text:SetText("Health")
  
  slider2Health:SetScript("OnValueChanged", function(self,value)
    self.editbox:SetText(value)
    updateHealth(healthPowerOrb, self:GetValue())
  end)

  slider2Health.editbox:SetScript("OnEnterPressed", function(self)
    self.slider:SetValue(self:GetText())
    updateHealth(healthPowerOrb, self.slider:GetValue())
    self:ClearFocus()
  end)   

  local slider2Power = createSliderWithEditbox(addon.."Slider2Power")
  
  slider2Power:ClearAllPoints()
  slider2Power:SetPoint("TOP", healthPowerOrb, "BOTTOM", 0, -70)
  slider2Power.text:SetText("Power")
  
  slider2Power:SetScript("OnValueChanged", function(self,value)
    self.editbox:SetText(value)
    updatePower(healthPowerOrb, self:GetValue())
  end)

  slider2Power.editbox:SetScript("OnEnterPressed", function(self)
    self.slider:SetValue(self:GetText())
    updatePower(healthPowerOrb, self.slider:GetValue())
    self:ClearFocus()
  end)   


  -- HEALTH ORB WITH GALAXIES
  
  local orbWithGalaxies = createHealthOrbWithGalaxies()
  local slider3Health = createSliderWithEditbox(addon.."Slider3Health")
  
  slider3Health:ClearAllPoints()
  slider3Health:SetPoint("TOP", orbWithGalaxies, "BOTTOM", 0, -30)
  slider3Health.text:SetText("Health")
  
  slider3Health:SetScript("OnValueChanged", function(self,value)
    self.editbox:SetText(value)
    updateHealth(orbWithGalaxies, self:GetValue())
  end)

  slider3Health.editbox:SetScript("OnEnterPressed", function(self)
    self:GetParent():SetValue(self:GetText())
    updateHealth(orbWithGalaxies, self:GetParent():GetValue())
    self:ClearFocus()
  end)   