
  --get the addon namespace
  local addon, ns = ...

  --object container
  local cfg = ns.cfg
  local lib = CreateFrame("Frame")
  ns.lib = lib

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
    --background
    local castringBg = lib:CreateRingTexture(self, scrollChild, "bg", -8, self.cfg.castring.textures.bg, self.cfg.castring.radius, self.cfg.castring.colors.bg, scrollFrame.defaultRotation)
    --filling
    local castringFill = lib:CreateRingTexture(self, scrollChild, "fill", -7, self.cfg.castring.textures.fill, self.cfg.castring.radius, self.cfg.castring.colors.fill, scrollFrame.defaultRotation)
    --spark
    local castringSpark = = lib:CreateRingTexture(self, scrollChild, "spark", -6, self.cfg.castring.textures.spark, self.cfg.castring.radius, self.cfg.castring.colors.fill, scrollFrame.defaultRotation)
    --latency
    if self.cfg.style == "player" then
      --create latency
      local castringLatency = lib:CreateRingTexture(self, scrollChild, "latency", -5, self.cfg.castring.textures.fill, self.cfg.castring.radius, self.cfg.castring.colors.latency, scrollFrame.defaultRotation)
      scrollFrame.castringLatency = castringLatency
      scrollFrame.castringLatency:Hide()
    end

    --POWERRING
    --background
    local powerringBg = lib:CreateRingTexture(self, scrollChild, "bg", -3, self.cfg.powerring.textures.bg, self.cfg.powerring.radius, self.cfg.powerring.colors.bg, scrollFrame.defaultRotation)
    --filling
    local powerringFill = lib:CreateRingTexture(self, scrollChild, "fill", -2, self.cfg.powerring.textures.fill, self.cfg.powerring.radius, self.cfg.powerring.colors.fill, scrollFrame.defaultRotation)
    --spark
    local powerringSpark = = lib:CreateRingTexture(self, scrollChild, "spark", -1, self.cfg.powerring.textures.spark, self.cfg.powerring.radius, self.cfg.powerring.colors.fill, scrollFrame.defaultRotation)

    --HEALTHRING
    --healthring background
    local healthringBg = lib:CreateRingTexture(self, scrollChild, "bg", 1, self.cfg.healthring.textures.bg, self.cfg.healthring.radius, self.cfg.healthring.colors.bg, scrollFrame.defaultRotation)
    --healthring filling
    local healthringFill = lib:CreateRingTexture(self, scrollChild, "fill", 2, self.cfg.healthring.textures.fill, self.cfg.healthring.radius, self.cfg.healthring.colors.fill, scrollFrame.defaultRotation)
    --healthring spark
    local healthringSpark = = lib:CreateRingTexture(self, scrollChild, "spark", 3, self.cfg.healthring.textures.spark, self.cfg.healthring.radius, self.cfg.healthring.colors.fill, scrollFrame.defaultRotation)

    --references
    scrollFrame.castringBg       = castringBg
    scrollFrame.castringFill     = castringFill
    scrollFrame.castringSpark    = castringSpark
    scrollFrame.powerringBg      = powerringBg
    scrollFrame.powerringFill    = powerringFill
    scrollFrame.powerringSpark   = powerringSpark
    scrollFrame.healthringBg     = healthringBg
    scrollFrame.healthringFill   = healthringFill
    scrollFrame.healthringSpark  = healthringSpark

    --hide all frames for now
    scrollFrame.castringBg:Hide()
    scrollFrame.castringFill:Hide()
    scrollFrame.castringSpark:Hide()
    scrollFrame.powerringBg:Hide()
    scrollFrame.powerringFill:Hide()
    scrollFrame.powerringSpark:Hide()
    scrollFrame.healthringBg:Hide()
    scrollFrame.healthringFill:Hide()
    scrollFrame.healthringSpark:Hide()

    return scrollFrame

  end

  --create all the frames and make sure they stack correctly
  function lib:CreateFrameStack(self)

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

    --first we set up all the rings
    --but later on we need each ring segment in a specific order making it easier to update all the ring elements

    --castring table
    self.castring = {}
    self.castringModulo = 1
    for i=1, self.cfg.castring.numSegmentsUsed do
      local id = lib:GetSegmentId(self.cfg.castring.startSegment,self.cfg.castring.fillDirection,i)
      self.castring[i] = self.ringSegments[id]
      self.castringModulo = self.castringModulo * self.ringSegments[id].primeNum
    end

    --powerring table
    self.powerring = {}
    self.powerringModulo = 1
    for i=1, self.cfg.powerring.numSegmentsUsed do
      local id = lib:GetSegmentId(self.cfg.powerring.startSegment,self.cfg.powerring.fillDirection,i)
      self.powerring[i] = self.ringSegments[id]
      self.powerringModulo = self.powerringModulo * self.ringSegments[id].primeNum
    end

    --healthring table
    self.healthring = {}
    self.healthringModulo = 1
    for i=1, self.cfg.healthring.numSegmentsUsed do
      local id = lib:GetSegmentId(self.cfg.healthring.startSegment,self.cfg.healthring.fillDirection,i)
      self.healthring[i] = self.ringSegments[id]
      self.healthringModulo = self.healthringModulo * self.ringSegments[id].primeNum
    end

    --fake health
    local health = CreateFrame("StatusBar", nil, self)
    health:SetScript("OnValueChanged", function(self, ...)
      local parent = self:GetParent()
      print(parent.cfg.style.. " Health OnValueChanged")
      print(self:GetMinMaxValues())
      print(...)
    end)
    self.Health = health

    --fake power
    local power = CreateFrame("StatusBar", nil, self)
    power:SetScript("OnValueChanged", function(self, ...)
      local parent = self:GetParent()
      print(parent.cfg.style.. " Power OnValueChanged")
      print(self:GetMinMaxValues())
      print(...)
    end)
    self.Power = power

    --fake castbar
    local castbar = CreateFrame("StatusBar", nil, self)
    castbar:SetScript("OnValueChanged", function(self, ...)
      local parent = self:GetParent()
      print(parent.cfg.style.. " Castbar OnValueChanged")
      print(self:GetMinMaxValues())
      print(...)
    end)
    castbar:HookScript("OnShow", function(self, ...)
      local parent = self:GetParent()
      print(parent.cfg.style.. " Castbar OnShow")
      print(self:GetMinMaxValues())
      print(...)
    end)
    castbar:HookScript("OnHide", function(self, ...)
      local parent = self:GetParent()
      print(parent.cfg.style.. " Castbar OnHide")
      print(...)
    end)
    self.Castbar = castbar

  end