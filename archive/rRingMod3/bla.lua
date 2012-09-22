
  -- rRingMod3 layout by roth - 2009
  
  --    ring layout
  --     ____ ____
  --    /    |    \
  --    |  4 | 1  |
  --     ----+---- 
  --    |  3 | 2  |
  --    \____|____/
  --

  -- direction 1 = right (clockwise), 0 = left (counter-clockwise)

  -----------------------
  -----------------------
  
    myFactionColors = {
    [1] = {r = 0.8, g = 0.3, b = 0.22},
    [2] = {r = 0.8, g = 0.3, b = 0.22},
    [3] = {r = 0.75, g = 0.27, b = 0},
    [4] = {r = 0.9, g = 0.7, b = 0},
    [5] = {r = 0, g = 0.6, b = 0.1},
    [6] = {r = 0, g = 0.6, b = 0.1},
    [7] = {r = 0, g = 0.6, b = 0.1},
    [8] = {r = 0, g = 0.6, b = 0.1},
  };
  
  local myClassColors = {
    ["HUNTER"] = { r = 0.67, g = 0.83, b = 0.45 },
    ["WARLOCK"] = { r = 0.58, g = 0.51, b = 0.79 },
    ["PRIEST"] = { r = 1.0, g = 1.0, b = 1.0 },
    ["PALADIN"] = { r = 0.96, g = 0.55, b = 0.73 },
    ["MAGE"] = { r = 0.41, g = 0.8, b = 0.94 },
    ["ROGUE"] = { r = 1.0, g = 0.96, b = 0.41 },
    ["DRUID"] = { r = 1.0, g = 0.49, b = 0.04 },
    ["SHAMAN"] = { r = 0.14, g = 0.35, b = 1.0 },
    ["WARRIOR"] = { r = 0.78, g = 0.61, b = 0.43 },
    ["DEATHKNIGHT"] = { r = 0.77, g = 0.12 , b = 0.23 },
  };
  
  local myPowerColors = {}  
  myPowerColors["MANA"] = { r = 0, g = 0.6, b = 1 };
  myPowerColors["RAGE"] = { r = 1.00, g = 0.00, b = 0.00 };
  myPowerColors["FOCUS"] = { r = 1.00, g = 0.50, b = 0.25 };
  myPowerColors["ENERGY"] = { r = 1.00, g = 1.00, b = 0.00 };
  myPowerColors["HAPPINESS"] = { r = 0.00, g = 1.00, b = 1.00 };
  myPowerColors["RUNES"] = { r = 0.50, g = 0.50, b = 0.50 };
  myPowerColors["RUNIC_POWER"] = { r = 0.00, g = 0.82, b = 1.00 };
  myPowerColors["AMMOSLOT"] = { r = 0.80, g = 0.60, b = 0.00 };
  myPowerColors["FUEL"] = { r = 0.0, g = 0.55, b = 0.5 };
  
  local tabvalues = {
    power = {
      [-2] = myPowerColors["AMMOSLOT"], -- fuel
      [-1] = myPowerColors["FUEL"], -- fuel
      [0] = myPowerColors["MANA"], -- Mana
      [1] = myPowerColors["RAGE"], -- Rage
      [2] = myPowerColors["FOCUS"], -- Focus
      [3] = myPowerColors["ENERGY"], -- Energy
      [4] = myPowerColors["HAPPINESS"], -- Happiness
      [5] = myPowerColors["RUNES"], -- dont know
      [6] = myPowerColors["RUNIC_POWER"], -- deathknight
    },
    happiness = {
      [0] = {r = 1, g = 1, b = 1}, -- doh
      [1] = {r = 1, g = 0, b = 0}, -- need.... | unhappy
      [2] = {r = 1, g = 1, b = 0}, -- new..... | content
      [3] = {r = 0, g = 1, b = 0}, -- colors.. | happy
    },
    runes = {
      [1] = { 1, 0, 0  },
      [2] = { 1, 0, 0  },
      [3] = { 0, 0.5, 0 },
      [4] = { 0, 0.5, 0 },
      [5] = { 0, 1, 1 },
      [6] = { 0, 1, 1 },
    },
  }

  --for testing
  local allow_frame_movement = 1
  local lock_all_frames = 0
  local testmode = 1
  
  ---------------------  
  -- FUNCTIONS
  ---------------------

  local function am(text)
    DEFAULT_CHAT_FRAME:AddMessage(text)
  end
  
  --the default config
  local function default_config(self)  
    --define config variables for your ring
    local c = CreateFrame("Frame", nil, self)
    c.anchorframe = UIParent
    c.anchorpoint = "CENTER"
    c.anchorposx = 0
    c.anchorposy = 0
    c.scale = 1
    c.width = 256
    c.height = 256
    c.alpha = 1
    
    --define config variables for your health segments
    local hs = CreateFrame("Frame", nil, self)
    hs.anchorframe = self
    hs.anchorpoint = "CENTER"
    hs.anchorposx = 0
    hs.anchorposy = 0
    hs.size = 256
    hs.alpha = 1
    hs.framelevel = 1
    hs.scale = 1
    hs.segments_used = 2
    hs.start_segment = 3
    hs.fill_direction = 1
    hs.texture = "Interface\\AddOns\\rRingMod3\\ring1"
    hs.color = {r = 255/255, g = 255/255, b = 255/255, a = 1}
    hs.blendmode = "BLEND"
    hs.segmentsize = 128
    hs.outer_radius = 110
    hs.inner_radius = 70
    
    --define config variables for your power segments
    local ps = CreateFrame("Frame", nil, self)
    ps.anchorframe = self
    ps.anchorpoint = "CENTER"
    ps.anchorposx = 0
    ps.anchorposy = 0
    ps.size = 256
    ps.alpha = 1
    ps.framelevel = 1
    ps.scale = 1
    ps.segments_used = 2
    ps.start_segment = 2
    ps.fill_direction = 0
    ps.texture = "Interface\\AddOns\\rRingMod3\\ring1"
    ps.color = {r = 255/255, g = 255/255, b = 255/255, a = 1}
    ps.blendmode = "BLEND"
    ps.segmentsize = 128
    ps.outer_radius = 110
    ps.inner_radius = 70
    
    --ring spark
    local sp = CreateFrame("Frame", nil, self)
    sp.anchorframe = self
    sp.active = 1
    sp.color = {r = 255/255, g = 255/255, b = 255/255, a = 1}
    sp.alpha = 0.8
    sp.framelevel = 4
    sp.scale = 1.9
    sp.size = (110-70)
    sp.radius = ((110+70)/2)
    sp.shiftradian = math.rad(90)
    sp.blendmode = "ADD"
    --sp.texture = "Interface\\CastingBar\\UI-CastingBar-Spark"
    sp.texture = "Interface\\AddOns\\rRingMod3\\spark1"
    
    --ring background
    local rb = CreateFrame("Frame", nil, self)
    rb.active = 1
    rb.color = {r = 255/255, g = 255/255, b = 255/255, a = 1}
    rb.alpha = 0.8
    rb.framelevel = 0
    rb.blendmode = "BLEND"
    rb.texture = "Interface\\AddOns\\rRingMod3\\background"
    rb.anchorframe = self
    rb.anchorpoint = "CENTER"
    rb.anchorposx = 0
    rb.anchorposy = 0
    rb.width = 256
    rb.height = 256
    
    --ring foreground
    local rf = CreateFrame("Frame", nil, self)    
    rf.active = 1
    rf.color = {r = 255/255, g = 255/255, b = 255/255, a = 1}
    rf.alpha = 0.5
    rf.framelevel = 5
    rf.blendmode = "BLEND"
    rf.texture = "Interface\\AddOns\\rRingMod3\\foreground"
    rf.anchorframe = self
    rf.anchorpoint = "CENTER"
    rf.anchorposx = 0
    rf.anchorposy = 0
    rf.width = 256
    rf.height = 256    
    

    self.config = c
    self.config.health = hs
    self.config.power = ps
    self.config.background = rb
    self.config.foreground = rf
    self.config.spark = sp
  
  end

  local r2 = math.sqrt(0.5^2+0.5^2);
  
  -- calculates the one specific ring segment 
  local function calc_ring_segment(self, value)
  
    local t0 = self.square1
    local t1 = self.square2
    local t2 = self.slicer
    local t3 = self.fullsegment


    local direction = self.direction
    local segmentsize = self.segmentsize
    local outer_radius = self.outer_radius
    local difference = self.difference
    local inner_radius = self.inner_radius
    local ring_factor = self.ring_factor
    local ring_width = self.ring_width
    
    
    --remember to invert the value when direction is counter-clockwise
    local statusbarvalue = floor(value)
    if direction == 0 then
      statusbarvalue = 100 - statusbarvalue
    end

    --am(statusbarvalue)

    --angle
    local angle = statusbarvalue * 90 / 100
    local Arad = math.rad(angle)

    local Nx = 0
    local Ny = 0
    local Mx = segmentsize
    local My = segmentsize
    
    local Ix,Iy,Ox,Oy
    local IxCoord, IyCoord, OxCoord, OyCoord, NxCoord, NyCoord, MxCoord, MyCoord
    local sq1_c1_x, sq1_c1_y, sq1_c2_x, sq1_c2_y, sq1_c3_x, sq1_c3_y, sq1_c4_x, sq1_c4_y
    local sq2_c1_x, sq2_c1_y, sq2_c2_x, sq2_c2_y, sq2_c3_x, sq2_c3_y, sq2_c4_x, sq2_c4_y
    
    if direction == 1 then
      
      Ix = inner_radius * math.sin(Arad)
      Iy = (outer_radius - (inner_radius * math.cos(Arad))) + difference
      Ox = outer_radius * math.sin(Arad)
      Oy = (outer_radius - (outer_radius * math.cos(Arad))) + difference
      IxCoord = Ix / segmentsize 
      IyCoord = Iy / segmentsize
      OxCoord = Ox / segmentsize
      OyCoord = Oy / segmentsize   
      NxCoord = Nx / segmentsize
      NyCoord = Ny / segmentsize
      MxCoord = Nx / segmentsize
      MyCoord = Ny / segmentsize
      
      sq1_c1_x = NxCoord
      sq1_c1_y = NyCoord
      sq1_c2_x = NxCoord
      sq1_c2_y = IyCoord
      sq1_c3_x = IxCoord
      sq1_c3_y = NyCoord
      sq1_c4_x = IxCoord
      sq1_c4_y = IyCoord
            
      sq2_c1_x = IxCoord
      sq2_c1_y = NyCoord
      sq2_c2_x = IxCoord
      sq2_c2_y = OyCoord
      sq2_c3_x = OxCoord
      sq2_c3_y = NyCoord
      sq2_c4_x = OxCoord
      sq2_c4_y = OyCoord

      if self.field == 1 then
        t0:SetPoint("TOPLEFT",Nx,-Ny)
        t0:SetWidth(Ix)
        t0:SetHeight(Iy)
        t1:SetPoint("TOPLEFT",Ix,-Ny)
        t1:SetWidth(Ox-Ix)
        t1:SetHeight(Oy)
        t2:SetPoint("TOPLEFT",Ix,-Oy)
        t2:SetWidth(Ox-Ix)
        t2:SetHeight(Iy-Oy)
      elseif self.field == 2 then
        t0:SetPoint("TOPRIGHT",Nx,Ny)
        t0:SetWidth(Iy)
        t0:SetHeight(Ix)
        t1:SetPoint("TOPRIGHT",Ny,-Ix)
        t1:SetWidth(Oy)
        t1:SetHeight(Ox-Ix)
        t2:SetPoint("TOPRIGHT",-Oy,-Ix)
        t2:SetWidth(Iy-Oy)
        t2:SetHeight(Ox-Ix)
        t2:SetTexCoord(0,1, 1,1, 0,0, 1,0)
      elseif self.field == 3 then
        t0:SetPoint("BOTTOMRIGHT",Nx,Ny)
        t0:SetWidth(Ix)
        t0:SetHeight(Iy)
        t1:SetPoint("BOTTOMRIGHT",-Ix,Ny)
        t1:SetWidth(Ox-Ix)
        t1:SetHeight(Oy)
        t2:SetPoint("BOTTOMRIGHT",-Ix,Oy)
        t2:SetWidth(Ox-Ix)
        t2:SetHeight(Iy-Oy)
        t2:SetTexCoord(1,1, 1,0, 0,1, 0,0)
      elseif self.field == 4 then
        t0:SetPoint("BOTTOMLEFT",Nx,Ny)
        t0:SetWidth(Iy)
        t0:SetHeight(Ix)
        t1:SetPoint("BOTTOMLEFT",Ny,Ix)
        t1:SetWidth(Oy)
        t1:SetHeight(Ox-Ix)
        t2:SetPoint("BOTTOMLEFT",Oy,Ix)
        t2:SetWidth(Iy-Oy)
        t2:SetHeight(Ox-Ix)
        t2:SetTexCoord(1,0, 0,0, 1,1, 0,1)
      end
      
    else
      
      Ix = inner_radius * math.sin(Arad)
      Iy = (outer_radius - (inner_radius * math.cos(Arad))) + difference
      Ox = outer_radius * math.sin(Arad)
      Oy = (outer_radius - (outer_radius * math.cos(Arad))) + difference
      IxCoord = Ix / segmentsize 
      IyCoord = Iy / segmentsize
      OxCoord = Ox / segmentsize
      OyCoord = Oy / segmentsize   
      NxCoord = Nx / segmentsize
      NyCoord = Ny / segmentsize
      MxCoord = Mx / segmentsize
      MyCoord = My / segmentsize
      
      sq1_c1_x = IxCoord
      sq1_c1_y = IyCoord
      sq1_c2_x = IxCoord
      sq1_c2_y = MyCoord
      sq1_c3_x = MxCoord
      sq1_c3_y = IyCoord
      sq1_c4_x = MxCoord
      sq1_c4_y = MyCoord
            
      sq2_c1_x = OxCoord
      sq2_c1_y = OyCoord
      sq2_c2_x = OxCoord
      sq2_c2_y = IyCoord
      sq2_c3_x = MxCoord
      sq2_c3_y = OyCoord
      sq2_c4_x = MxCoord
      sq2_c4_y = IyCoord
      
      if self.field == 1 then
        t0:SetPoint("TOPLEFT",Ix,-Iy)
        t0:SetWidth(segmentsize-Ix)
        t0:SetHeight(segmentsize-Iy)
        t1:SetPoint("TOPLEFT",Ox,-Oy)
        t1:SetWidth(segmentsize-Ox)
        t1:SetHeight(Iy-Oy)
        t2:SetPoint("TOPLEFT",Ix,-Oy)
        t2:SetWidth(Ox-Ix)
        t2:SetHeight(Iy-Oy)
      elseif self.field == 2 then
        t0:SetPoint("TOPRIGHT",-Iy,-Ix)
        t0:SetWidth(segmentsize-Iy)
        t0:SetHeight(segmentsize-Ix)
        t1:SetPoint("TOPRIGHT",-Oy,-Ox)
        t1:SetWidth(Iy-Oy)
        t1:SetHeight(segmentsize-Ox)
        t2:SetPoint("TOPRIGHT",-Oy,-Ix)
        t2:SetWidth(Iy-Oy)
        t2:SetHeight(Ox-Ix)
        t2:SetTexCoord(0,1, 1,1, 0,0, 1,0)
      elseif self.field == 3 then
        t0:SetPoint("BOTTOMRIGHT",-Ix,Iy)
        t0:SetWidth(segmentsize-Ix)
        t0:SetHeight(segmentsize-Iy)
        t1:SetPoint("BOTTOMRIGHT",-Ox,Oy)
        t1:SetWidth(segmentsize-Ox)
        t1:SetHeight(Iy-Oy)
        t2:SetPoint("BOTTOMRIGHT",-Ix,Oy)
        t2:SetWidth(Ox-Ix)
        t2:SetHeight(Iy-Oy)
        t2:SetTexCoord(1,1, 1,0, 0,1, 0,0)
      elseif self.field == 4 then
        t0:SetPoint("BOTTOMLEFT",Iy,Ix)
        t0:SetWidth(segmentsize-Iy)
        t0:SetHeight(segmentsize-Ix)
        t1:SetPoint("BOTTOMLEFT",Oy,Ox)
        t1:SetWidth(Iy-Oy)
        t1:SetHeight(segmentsize-Ox)
        t2:SetPoint("BOTTOMLEFT",Oy,Ix)
        t2:SetWidth(Iy-Oy)
        t2:SetHeight(Ox-Ix)
        t2:SetTexCoord(1,0, 0,0, 1,1, 0,1)
      end
    end
    
    if self.field == 1 then
      --1,2,3,4
      t0:SetTexCoord(sq1_c1_x,sq1_c1_y, sq1_c2_x,sq1_c2_y, sq1_c3_x,sq1_c3_y, sq1_c4_x, sq1_c4_y)
      t1:SetTexCoord(sq2_c1_x,sq2_c1_y, sq2_c2_x,sq2_c2_y, sq2_c3_x,sq2_c3_y, sq2_c4_x, sq2_c4_y)
    elseif self.field == 2 then
      --2,4,1,3
      t0:SetTexCoord(sq1_c2_x,sq1_c2_y, sq1_c4_x, sq1_c4_y, sq1_c1_x,sq1_c1_y, sq1_c3_x,sq1_c3_y)
      t1:SetTexCoord(sq2_c2_x,sq2_c2_y, sq2_c4_x, sq2_c4_y, sq2_c1_x,sq2_c1_y, sq2_c3_x,sq2_c3_y)
    elseif self.field == 3 then
      --4,3,2,1
      t0:SetTexCoord(sq1_c4_x, sq1_c4_y, sq1_c3_x,sq1_c3_y, sq1_c2_x,sq1_c2_y, sq1_c1_x,sq1_c1_y)
      t1:SetTexCoord(sq2_c4_x, sq2_c4_y, sq2_c3_x,sq2_c3_y, sq2_c2_x,sq2_c2_y, sq2_c1_x,sq2_c1_y)
    elseif self.field == 4 then
      --3,1,4,2
      t0:SetTexCoord(sq1_c3_x,sq1_c3_y, sq1_c1_x,sq1_c1_y, sq1_c4_x, sq1_c4_y, sq1_c2_x,sq1_c2_y)
      t1:SetTexCoord(sq2_c3_x,sq2_c3_y, sq2_c1_x,sq2_c1_y, sq2_c4_x, sq2_c4_y, sq2_c2_x,sq2_c2_y)
    end

  
  end
  
  local function calc_health_spark(self,value)
    local spark = self.health_spark.texture  
    local adjust = 0.009
    value = 1-value+adjust
    local mult = 1
    local radian = math.rad(90) + math.rad(value * (mult*90*self.config.health.segments_used))
    spark:SetPoint("CENTER", spark.radius * math.cos(radian), spark.radius * math.sin(radian))
    spark:SetRotation(radian - spark.shiftradian)  
  end
  
  local function calc_power_spark(self,value)
    local spark = self.power_spark.texture  
    local adjust = 0.009
    value = 1-value+adjust
    local mult = -1
    local radian = math.rad(90) + math.rad(value * (mult*90*self.config.health.segments_used))
    spark:SetPoint("CENTER", spark.radius * math.cos(radian), spark.radius * math.sin(radian))
    spark:SetRotation(radian - spark.shiftradian)  
  end
  
  --create background texture
  local function create_spark(self)
    local f = CreateFrame("Frame",nil,self.config.spark.anchorframe)
    f:SetAllPoints(self.config.spark.anchorframe)
    f:SetFrameLevel(self.config.spark.framelevel)
    f:SetAlpha(self.config.spark.alpha)

    local t = f:CreateTexture(nil,"OVERLAY")
    t:SetTexture(self.config.spark.texture)
    t:SetVertexColor(self.config.spark.color.r,self.config.spark.color.g,self.config.spark.color.b,self.config.spark.color.a)
    t:SetBlendMode(self.config.spark.blendmode) 
    t:SetHeight(self.config.spark.size*self.config.spark.scale)
    t:SetWidth(self.config.spark.size*self.config.spark.scale)
    t.radius = self.config.spark.radius
    t.shiftradian = self.config.spark.shiftradian
    t.radian = math.rad(90) + math.rad(0.1 * 180); --perc*totaldegree + startdegree
    t:SetPoint("CENTER", t.radius * math.cos(t.radian), t.radius * math.sin(t.radian));
    t:SetRotation(t.radian - t.shiftradian);
 
    f.texture = t
    
    f:Hide()
    
    return f
    
  end
  
  --create background texture
  local function create_ring_background(self)
    local f = CreateFrame("Frame",nil,self.config.background.anchorframe)
    f:SetPoint(self.config.background.anchorpoint,self.config.background.anchorposx,self.config.background.anchorposy)
    f:SetWidth(self.config.background.width)
    f:SetHeight(self.config.background.height)
    f:SetFrameLevel(self.config.background.framelevel)
    f:SetAlpha(self.config.background.alpha)
    local t = f:CreateTexture(nil,"BACKGROUND")
    t:SetTexture(self.config.background.texture)
    t:SetAllPoints(f)
    t:SetVertexColor(self.config.background.color.r,self.config.background.color.g,self.config.background.color.b,self.config.background.color.a)
    t:SetBlendMode(self.config.background.blendmode)
    f.texture = t
    return f
  end
  
  --create foreground texture
  local function create_ring_foreground(self)
    local f = CreateFrame("Frame",nil,self.config.foreground.anchorframe)
    f:SetPoint(self.config.foreground.anchorpoint,self.config.foreground.anchorposx,self.config.foreground.anchorposy)
    f:SetWidth(self.config.foreground.width)
    f:SetHeight(self.config.foreground.height)
    f:SetFrameLevel(self.config.foreground.framelevel)
    f:SetAlpha(self.config.foreground.alpha)
    local t = f:CreateTexture(nil,"BACKGROUND")
    t:SetTexture(self.config.foreground.texture)
    t:SetAllPoints(f)
    t:SetVertexColor(self.config.foreground.color.r,self.config.foreground.color.g,self.config.foreground.color.b,self.config.foreground.color.a)
    t:SetBlendMode(self.config.foreground.blendmode)
    f.texture = t
    return f
  end
  
  --function that creates the textures for each segment
  local function create_segment_textures(segment_config,f)
    
    local direction = segment_config.fill_direction
    local segmentsize = segment_config.segmentsize
    local outer_radius = segment_config.outer_radius
    local difference = segmentsize-outer_radius
    local inner_radius = segment_config.inner_radius
    local ring_factor = outer_radius/inner_radius
    local ring_width = outer_radius-inner_radius
    
    f.direction =  direction
    f.segmentsize = segmentsize
    f.outer_radius = outer_radius
    f.difference = difference
    f.inner_radius = inner_radius
    f.ring_factor = ring_factor
    f.ring_width = ring_width
    
    local t0 = f:CreateTexture(nil, "BACKGROUND")
    t0:SetTexture(segment_config.texture)
    t0:SetVertexColor(segment_config.color.r,segment_config.color.g,segment_config.color.b,segment_config.color.a)
    t0:SetBlendMode(segment_config.blendmode)
    t0:Hide()
    
    local t1 = f:CreateTexture(nil, "BACKGROUND")
    t1:SetTexture(segment_config.texture)
    t1:SetVertexColor(segment_config.color.r,segment_config.color.g,segment_config.color.b,segment_config.color.a)
    t1:SetBlendMode(segment_config.blendmode)
    t1:Hide()

    local t2 = f:CreateTexture(nil, "BACKGROUND")
    t2:SetVertexColor(segment_config.color.r,segment_config.color.g,segment_config.color.b,segment_config.color.a)
    t2:SetBlendMode(segment_config.blendmode)
    if direction == 1 then
      t2:SetTexture("Interface\\AddOns\\rRingMod3\\slicer1")
    else
      t2:SetTexture("Interface\\AddOns\\rRingMod3\\slicer0")
    end
    t2:Hide()

    local t3 = f:CreateTexture(nil, "BACKGROUND")
    t3:SetTexture(segment_config.texture)
    t3:SetVertexColor(segment_config.color.r,segment_config.color.g,segment_config.color.b,segment_config.color.a)
    t3:SetBlendMode(segment_config.blendmode)
    t3:SetPoint("CENTER",0,0)
    t3:SetWidth(segmentsize)
    t3:SetHeight(segmentsize)
    if f.field == 1 then
      --no coord needed
    elseif f.field == 2 then
      t3:SetTexCoord(0,1, 1,1, 0,0, 1,0)
    elseif f.field == 3 then
      t3:SetTexCoord(1,1, 1,0, 0,1, 0,0)
    elseif f.field == 4 then
      t3:SetTexCoord(1,0, 0,0, 1,1, 0,1)
    end
    t3:Hide()
    
    f.square1 = t0
    f.square2 = t1
    f.slicer = t2
    f.fullsegment = t3
    
  end
  
  --calculate the segment number based on starting segment and direction
  local function calc_segment_num(segment_config,current)
    local start = segment_config.start_segment
    local dir = segment_config.fill_direction
    local id
    if dir == 0 then
      if start-current < 1 then
        id = start-current+4
      else
        id = start-current
      end
    else
      if start+current > 4 then
        id = start+current-4
      else
        id = start+current
      end          
    end
    return id
  end

  --update health func
  local function calc_ring_health(self, unit)
    local f = self.health_ring
    local anz_seg = self.config.health.segments_used
    local act, max, perc, perc_per_seg, sum_radius = UnitHealth(unit), UnitHealthMax(unit), floor((UnitHealth(unit)/UnitHealthMax(unit))*100), 100/anz_seg, anz_seg*90
    
    if UnitIsDeadOrGhost(unit) == 1 or UnitIsConnected(unit) == nil then
      self:SetAlpha(self.config.alpha*0.7)
    else
      self:SetAlpha(self.config.alpha)
    end
    
    local color
    local dead
    if UnitIsDeadOrGhost(unit) == 1 or UnitIsConnected(unit) == nil then
      color = {r = 0.4, g = 0.4, b = 0.4}
      dead = 1
    elseif UnitIsPlayer(unit) then
      if myClassColors[select(2, UnitClass(unit))] then
        color = myClassColors[select(2, UnitClass(unit))]
      end
    elseif unit == "pet" and UnitExists("pet") and GetPetHappiness() then
      local happiness = GetPetHappiness()
      color = tabvalues.happiness[happiness]
    else
      color = myFactionColors[UnitReaction(unit, "player")]
    end
    
    if color then
      local multiplier = 1
      self.health_spark.texture:SetVertexColor(color.r*multiplier, color.g*multiplier, color.b*multiplier,1)
      for i=1, anz_seg do
        multiplier = 0.7
        f.segments[i].square1:SetVertexColor(color.r*multiplier, color.g*multiplier, color.b*multiplier,1)
        f.segments[i].square2:SetVertexColor(color.r*multiplier, color.g*multiplier, color.b*multiplier,1)
        f.segments[i].slicer:SetVertexColor(color.r*multiplier, color.g*multiplier, color.b*multiplier,1)
        f.segments[i].fullsegment:SetVertexColor(color.r*multiplier, color.g*multiplier, color.b*multiplier,1)
      end
    end
    
    if perc == 0 or UnitIsDeadOrGhost(unit) == 1 then
      for i=1, anz_seg do
        f.segments[i].square1:Hide()
        f.segments[i].square2:Hide()
        f.segments[i].slicer:Hide()
        f.segments[i].fullsegment:Hide()
        self.health_spark:Hide()
      end
    elseif perc == 100 then
      for i=1, anz_seg do
        f.segments[i].square1:Hide()
        f.segments[i].square2:Hide()
        f.segments[i].slicer:Hide()
        f.segments[i].fullsegment:Show()
        self.health_spark:Hide()
      end
    else
      calc_health_spark(self,(act/max))
      self.health_spark:Show()
      for i=1, anz_seg do
        if(perc >= (i*perc_per_seg)) then
          f.segments[i].square1:Hide()
          f.segments[i].square2:Hide()
          f.segments[i].slicer:Hide()
          f.segments[i].fullsegment:Show()
        elseif ((perc > ((i-1)*perc_per_seg)) and (perc < (i*perc_per_seg))) then
          local value = ((perc-((i-1)*perc_per_seg))/perc_per_seg)*100
          calc_ring_segment(f.segments[i],value)
          f.segments[i].square1:Show()
          f.segments[i].square2:Show()
          f.segments[i].slicer:Show()
          f.segments[i].fullsegment:Hide()
        else
          f.segments[i].square1:Hide()
          f.segments[i].square2:Hide()
          f.segments[i].slicer:Hide()
          f.segments[i].fullsegment:Hide()
        end
      end
    end
  end  
  
  --update mana func
  local function calc_ring_power(self, unit)
    local f = self.power_ring
    local anz_seg = self.config.power.segments_used
    local act, max, perc, perc_per_seg, sum_radius = UnitMana(unit), UnitManaMax(unit), floor((UnitMana(unit)/UnitManaMax(unit))*100), 100/anz_seg, anz_seg*90
    
    local color = tabvalues.power[UnitPowerType(unit)]
    if color then
      local multiplier = 1
      self.power_spark.texture:SetVertexColor(color.r*multiplier, color.g*multiplier, color.b*multiplier,1)
      for i=1, anz_seg do
        local multiplier = 0.7
        f.segments[i].square1:SetVertexColor(color.r*multiplier, color.g*multiplier, color.b*multiplier,1)
        f.segments[i].square2:SetVertexColor(color.r*multiplier, color.g*multiplier, color.b*multiplier,1)
        f.segments[i].slicer:SetVertexColor(color.r*multiplier, color.g*multiplier, color.b*multiplier,1)
        f.segments[i].fullsegment:SetVertexColor(color.r*multiplier, color.g*multiplier, color.b*multiplier,1)
      end
    end
    
    if perc == 0 or UnitIsDeadOrGhost(unit) == 1 then
      for i=1, anz_seg do
        f.segments[i].square1:Hide()
        f.segments[i].square2:Hide()
        f.segments[i].slicer:Hide()
        f.segments[i].fullsegment:Hide()
        self.power_spark:Hide()
      end
    elseif perc == 100 then
      for i=1, anz_seg do
        f.segments[i].square1:Hide()
        f.segments[i].square2:Hide()
        f.segments[i].slicer:Hide()
        f.segments[i].fullsegment:Show()
        self.power_spark:Hide()
      end
    else
      calc_power_spark(self,(act/max))
      self.power_spark:Show()
      for i=1, anz_seg do
        if(perc >= (i*perc_per_seg)) then
          f.segments[i].square1:Hide()
          f.segments[i].square2:Hide()
          f.segments[i].slicer:Hide()
          f.segments[i].fullsegment:Show()
        elseif ((perc > ((i-1)*perc_per_seg)) and (perc < (i*perc_per_seg))) then
          local value = ((perc-((i-1)*perc_per_seg))/perc_per_seg)*100
          calc_ring_segment(f.segments[i],value)
          f.segments[i].square1:Show()
          f.segments[i].square2:Show()
          f.segments[i].slicer:Show()
          f.segments[i].fullsegment:Hide()
        else
          f.segments[i].square1:Hide()
          f.segments[i].square2:Hide()
          f.segments[i].slicer:Hide()
          f.segments[i].fullsegment:Hide()
        end
      end
    end
  end
  
  --create the ring segments
  local function create_segments(self,segment_config)
    local f = CreateFrame("Frame",nil,segment_config.anchorframe)
    f:SetPoint(segment_config.anchorpoint,segment_config.anchorposx,segment_config.anchorposy)
    f:SetWidth(segment_config.size)
    f:SetHeight(segment_config.size)
    f:SetFrameLevel(segment_config.framelevel)
    f:SetAlpha(segment_config.alpha)
    f:SetScale(segment_config.scale)
    for i=1,(segment_config.segments_used) do
      f[i] = CreateFrame("Frame",nil,f)
      f[i]:SetWidth(segment_config.segmentsize)
      f[i]:SetHeight(segment_config.segmentsize)
      f[i].id = i
      f[i].field = calc_segment_num(segment_config,i-1)
      --am(f[i].id.." ~ "..f[i].field)
      if f[i].field == 1 then
        f[i]:SetPoint("TOPRIGHT",0,0)
      elseif f[i].field == 2 then
        f[i]:SetPoint("BOTTOMRIGHT",0,0)
      elseif f[i].field == 3 then
        f[i]:SetPoint("BOTTOMLEFT",0,0)
      elseif f[i].field == 4 then
        f[i]:SetPoint("TOPLEFT",0,0)
      end
      create_segment_textures(segment_config,f[i])
    end
    return f
  end
  
  --create the health segments
  local function create_health_segments(self)
    local f = CreateFrame("Frame",nil,self)
    f.segments = create_segments(self,self.config.health)
    return f
  end
  
  --create the power segments
  local function create_power_segments(self)
    local f = CreateFrame("Frame",nil,self)
    f.segments = create_segments(self,self.config.power)
    return f
  end
  
  --move me in place
  local function make_me_movable(f)
    if allow_frame_movement == 0 then
      f:IsUserPlaced(false)
    else
      f:SetMovable(true)
      f:SetUserPlaced(true)
      if lock_all_frames == 0 then
        f:EnableMouse(true)
        f:RegisterForDrag("LeftButton","RightButton")
        f:SetScript("OnDragStart", function(self) if IsAltKeyDown() and IsShiftKeyDown() then self:StartMoving() end end)
        f:SetScript("OnDragStop", function(self) self:StopMovingOrSizing() end)
      end
    end  
  end

  
  -----------------------------
  -----------------------------

  local function createRing(unit)   
    
    --SELF
    local self = CreateFrame("Frame", nil, UIParent)    
    default_config(self)
    self:SetHeight(self.config.height)
    self:SetWidth(self.config.width)
    
    self.config.scale = 0.5
    
    self:SetScale(self.config.scale)
    self:SetPoint(self.config.anchorpoint,self.config.anchorposx,self.config.anchorposy)
    
    --BG and FOREGROUND
    self.ring_background = create_ring_background(self)
    self.ring_foreground = create_ring_foreground(self)
    self.health_spark = create_spark(self)
    self.power_spark = create_spark(self)
    
    --local t = self:CreateTexture(nil,"BACKGROUND")
    --t:SetTexture(1,0,0,0.5)
    --t:SetAllPoints(self)

    -- HP RING
    self.health_ring = create_health_segments(self)
    
    self.health_ring:SetScript("OnEvent", function(s, event, arg1, ...)
      --if arg1 == unit or event == "PLAYER_ENTERING_WORLD" then
      if(UnitExists(unit)) then
        calc_ring_health(self, unit)
      end
    end)
    self.health_ring:RegisterEvent("UNIT_HEALTH")
    self.health_ring:RegisterEvent("PLAYER_ENTERING_WORLD")
    self.health_ring:RegisterEvent("PLAYER_TARGET_CHANGED")  
    
    --POWER
    self.power_ring = create_power_segments(self)    
    
    self.power_ring:SetScript("OnEvent", function(s, event, arg1, ...)
      --if arg1 == unit or event == "PLAYER_ENTERING_WORLD" then
      if(UnitExists(unit)) then
        calc_ring_power(self, unit)
      end
    end)
    
    self.power_ring:RegisterEvent("UNIT_POWER")
    self.power_ring:RegisterEvent("UNIT_MAXPOWER")
    self.power_ring:RegisterEvent("PLAYER_ENTERING_WORLD")
    self.power_ring:RegisterEvent("PLAYER_TARGET_CHANGED")  
    
    make_me_movable(self)
    
    return self
  end


  local addon = CreateFrame("Frame", nil, UIParent)
 
  local units = CreateFrame("Frame", nil, UIParent)

  
  addon:SetScript("OnEvent", function (self,event,...)
    if(event=="PLAYER_LOGIN") then
      units.player = createRing("player")
      units.target = createRing("target")
      units.target:Hide()
    end 
    if event == "PLAYER_TARGET_CHANGED" then
      if(UnitExists("target")) then
        units.target:Show()
      else 
        units.target:Hide()
      end
    end
  end)
  
  addon:RegisterEvent("PLAYER_LOGIN")
  addon:RegisterEvent("PLAYER_TARGET_CHANGED")