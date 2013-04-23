
  --get the addon namespace
  local addon, ns = ...

  --object container
  local lib = CreateFrame("Frame")
  ns.lib = lib

  local cfg = ns.cfg

  ---------------------------------------------
  -- variables
  ---------------------------------------------

  local rad = rad
  local sqrt = sqrt
  local tinsert = tinsert

  --    ring segment layout
  --     ____ ____
  --    /    |    \
  --    |  4 | 1  |
  --     ----+----
  --    |  3 | 2  |
  --    \____|____/
  --


  local ringSegmentSettings = {
    { defaultRotation = 0,    primeNum = 2,   point = "TOPRIGHT",     }, --segment 1
    { defaultRotation = 270,  primeNum = 3,   point = "BOTTOMRIGHT",  }, --segment 2
    { defaultRotation = 180,  primeNum = 5,   point = "BOTTOMLEFT",   }, --segment 3
    { defaultRotation = 90,   primeNum = 7,   point = "TOPLEFT",      }, --segment 4
  }

  ---------------------------------------------
  -- lib functions
  ---------------------------------------------

  --castbar OnValueChanged
  function lib:CastbarOnValueChanged(self,...)
    --stuff
    local parent = self:GetParent()
    print(parent.cfg.style.. " "..parent.unit.." Castbar OnValueChanged")
    print(self:GetMinMaxValues())
    print(...)
  end

  --castbar OnShow
  function lib:CastbarOnShow(self,...)
    local parent = self:GetParent()
    print(parent.cfg.style.. " "..parent.unit.." Castbar OnShow")
    print(self:GetMinMaxValues())
    print(...)
  end

  --castbar OnHide
  function lib:CastbarOnHide(self, ...)
    local parent = self:GetParent()
    print(parent.cfg.style.. " "..parent.unit.." Castbar OnHide")
    print(...)
  end

  --powerbar OnValueChanged
  function lib:PowerbarOnValueChanged(self, ...)
    local parent = self:GetParent()
    print(parent.cfg.style.. " "..parent.unit.." Power OnValueChanged")
    print(self:GetMinMaxValues())
    print(...)
  end

  --healthbar OnValueChanged
  function lib:HealthbarOnValueChanged(self, ...)
    local parent = self:GetParent()
    print(parent.cfg.style.. " "..parent.unit.." Health OnValueChanged")
    print(self:GetMinMaxValues())
    print(...)
  end

  --calculate the segment id based on direction, index and starting point
  function lib:GetSegmentId(start,direction,i)
    if direction == 0 then
      if start-i < 1 then
        return start-i+4
      else
        return start-i
      end
    else
      if start+i > 4 then
        return start+i-4
      else
        return start+i
      end
    end
  end

  --function to create ring textures on the scrollchild
  function lib:CreateRingTexture(self,parent,type,textureLevel,texture,radius,color,rotation)
    local tex = parent:CreateTexture(nil,"BACKGROUND",nil,textureLevel)
    tex:SetTexture(texture)
    tex:SetSize(sqrt(2)*256*radius,sqrt(2)*256*radius)
    tex:SetPoint("CENTER",self,"CENTER",0,0)
    tex:SetVertexColor(color.r,color.g,color.b
    if type == "spark" or type == "latency" then
      tex:SetAlpha(color.a or 1)
      tex:SetBlendMode("ADD")
    end
    tex:SetRotation(rad(rotation))
    return tex
  end

  --create the scrollframe and all elements for a ring segment
  function lib:CreateRingSegment(self, parent, i)

    local template = self.template

    --each ring segment consists of 2 frames and 9 textures
    --one scrollframe
    --one scrollchild (any data overflowing the scrollChild will be cropped)
    --3 rings (cast, power, health) consisting of 3 textures each (background, filling and spark)

    --scrollframe
    local scrollFrame = CreateFrame("ScrollFrame", "$parentScrollFrame", parent)
    scrollFrame:SetSize(128,128)
    scrollFrame:SetPoint(ringSegmentSettings[i].point,self)
    scrollFrame.defaultRotation = ringSegmentSettings[i].defaultRotation
    scrollFrame.primeNum = ringSegmentSettings[i].primeNum
    scrollFrame.segmentId = i

    --scrollchild
    local scrollChild = CreateFrame("Frame", "$parentScrollChild", scrollFrame)
    scrollChild:SetSize(128,128)
    scrollChild:SetBackdrop(cfg.backdrop)
    scrollFrame:SetScrollChild(scrollChild)
    scrollFrame.scrollChild = scrollChild

    --CASTRING
    if template.castring.enable then
      --background
      local castringBg = lib:CreateRingTexture(self, scrollChild, "bg", -8, template.castring.textures.bg, template.castring.radius, template.castring.colors.bg, scrollFrame.defaultRotation)
      --filling
      local castringFill = lib:CreateRingTexture(self, scrollChild, "fill", -7, template.castring.textures.fill, template.castring.radius, template.castring.colors.fill, scrollFrame.defaultRotation)
      --spark
      local castringSpark = = lib:CreateRingTexture(self, scrollChild, "spark", -6, template.castring.textures.spark, template.castring.radius, template.castring.colors.fill, scrollFrame.defaultRotation)
      --latency
      if self.cfg.style == "player" then
        --create latency
        local castringLatency = lib:CreateRingTexture(self, scrollChild, "latency", -5, template.castring.textures.fill, template.castring.radius, template.castring.colors.latency, scrollFrame.defaultRotation)
        scrollFrame.castringLatency = castringLatency
        scrollFrame.castringLatency:Hide()
      end
      scrollFrame.castringBg       = castringBg
      scrollFrame.castringFill     = castringFill
      scrollFrame.castringSpark    = castringSpark
      scrollFrame.castringBg:Hide()
      scrollFrame.castringFill:Hide()
      scrollFrame.castringSpark:Hide()
    end

    --POWERRING
    if template.powerring.enable then
      --background
      local powerringBg = lib:CreateRingTexture(self, scrollChild, "bg", -3, template.powerring.textures.bg, template.powerring.radius, template.powerring.colors.bg, scrollFrame.defaultRotation)
      --filling
      local powerringFill = lib:CreateRingTexture(self, scrollChild, "fill", -2, template.powerring.textures.fill, template.powerring.radius, template.powerring.colors.fill, scrollFrame.defaultRotation)
      --spark
      local powerringSpark = = lib:CreateRingTexture(self, scrollChild, "spark", -1, template.powerring.textures.spark, template.powerring.radius, template.powerring.colors.fill, scrollFrame.defaultRotation)
      scrollFrame.powerringBg      = powerringBg
      scrollFrame.powerringFill    = powerringFill
      scrollFrame.powerringSpark   = powerringSpark
      scrollFrame.powerringBg:Hide()
      scrollFrame.powerringFill:Hide()
      scrollFrame.powerringSpark:Hide()
    end

    --HEALTHRING
    if template.healthring.enable then
      --healthring background
      local healthringBg = lib:CreateRingTexture(self, scrollChild, "bg", 1, template.healthring.textures.bg, template.healthring.radius, template.healthring.colors.bg, scrollFrame.defaultRotation)
      --healthring filling
      local healthringFill = lib:CreateRingTexture(self, scrollChild, "fill", 2, template.healthring.textures.fill, template.healthring.radius, template.healthring.colors.fill, scrollFrame.defaultRotation)
      --healthring spark
      local healthringSpark = = lib:CreateRingTexture(self, scrollChild, "spark", 3, template.healthring.textures.spark, template.healthring.radius, template.healthring.colors.fill, scrollFrame.defaultRotation)
      scrollFrame.healthringBg     = healthringBg
      scrollFrame.healthringFill   = healthringFill
      scrollFrame.healthringSpark  = healthringSpark
      scrollFrame.healthringBg:Hide()
      scrollFrame.healthringFill:Hide()
      scrollFrame.healthringSpark:Hide()
    end

    return scrollFrame

  end

  --create all the frames and make sure they stack correctly
  function lib:CreateFrameStack(self)

    local template = self.template

    --create the framestack
    local back = CreateFrame("Frame", "$parentBackground", self)
    back:SetAllPoints(self)
    self.back = back
    local lastParent = back

    local t = back:CreateTexture(nil, "BACKGROUND", nil, -8)
    t:SetTexture(1,1,1)
    t:SetVertexColor(0.1,0.1,0.1)
    t:SetAllPoints(self)

    --create the 4 ring segments
    self.ringSegments = {}
    for i=1, 4 do
      local ringSegment = lib:CreateRingSegment(self,lastParent, i)
      tinsert(self.ringSegments, ringSegment)
      lastParent = ringSegment
    end

    --highlight
    local highlight = CreateFrame("Frame", nil, lastParent)
    highlight:SetAllPoints(self)
    self.highlight = highlight
    lastParent = highlight

    --local t = highlight:CreateTexture(nil, "BACKGROUND", nil, -8)
    --t:SetTexture(1,1,1)
    --t:SetVertexColor(0,1,1)
    --t:SetAllPoints()

    --border
    local border = CreateFrame("Frame", nil, lastParent)
    border:SetAllPoints(self)
    self.border = border
    lastParent = border

    --local t = border:CreateTexture(nil, "BACKGROUND", nil, -8)
    --t:SetTexture(1,1,1)
    --t:SetVertexColor(1,0,1)
    --t:SetAllPoints()

    --first we set up the ring segments
    --but later on we need each ring in a specific order based on starting point an direction

    --CASTRING
    if template.castring.enable then
      --castring table
      self.castring = {}
      self.castringModulo = 1
      for i=1, template.castring.numSegmentsUsed do
        local id = lib:GetSegmentId(template.castring.startSegment,template.castring.fillDirection,i)
        self.castring[i] = self.ringSegments[id]
        self.castringModulo = self.castringModulo * self.ringSegments[id].primeNum
      end
      --fake castbar
      local castbar = CreateFrame("StatusBar", nil, self)
      castbar:SetScript("OnValueChanged", lib:CastbarOnValueChanged)
      castbar:HookScript("OnShow", lib:CastbarOnShow)
      castbar:HookScript("OnHide", lib:CastbarOnHide)
      self.Castbar = castbar
    end

    --POWERRING
    if template.powerring.enable then
      --powerring table
      self.powerring = {}
      self.powerringModulo = 1
      for i=1, template.powerring.numSegmentsUsed do
        local id = lib:GetSegmentId(template.powerring.startSegment,template.powerring.fillDirection,i)
        self.powerring[i] = self.ringSegments[id]
        self.powerringModulo = self.powerringModulo * self.ringSegments[id].primeNum
      end
      --fake power
      local power = CreateFrame("StatusBar", nil, self)
      power:SetScript("OnValueChanged", lib:PowerbarOnValueChanged)
      self.Power = power
    end

    --HEALTHRING
    if template.healthring.enable then
      --healthring table
      self.healthring = {}
      self.healthringModulo = 1
      for i=1, template.healthring.numSegmentsUsed do
        local id = lib:GetSegmentId(template.healthring.startSegment,template.healthring.fillDirection,i)
        self.healthring[i] = self.ringSegments[id]
        self.healthringModulo = self.healthringModulo * self.ringSegments[id].primeNum
      end
      --fake health
      local health = CreateFrame("StatusBar", nil, self)
      health:SetScript("OnValueChanged", lib:HealthbarOnValueChanged)
      self.Health = health
    end

  end