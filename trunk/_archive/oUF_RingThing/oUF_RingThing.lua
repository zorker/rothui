
  -- oUF_RingThing layout by roth - 2009
  
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
  -- CONFIG
  -----------------------

  local myfont = "FONTS\\FRIZQT__.ttf"
  
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
  local testmode = 0
  
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
    c.width = 512
    c.height = 256
    c.alpha = 1
    
    --define config variables for your health segments
    local hs = CreateFrame("Frame", nil, self)
    hs.anchorframe = self
    hs.anchorpoint = "LEFT"
    hs.anchorposx = 0
    hs.anchorposy = 0
    hs.size = 256
    hs.alpha = 1
    hs.framelevel = 5
    hs.scale = 0.995
    hs.segments_used = 4
    hs.start_segment = 3
    hs.fill_direction = 1
    hs.texture = "Interface\\AddOns\\oUF_RingThing\\media\\style1_ring"
    hs.color = {r = 255/255, g = 255/255, b = 255/255, a = 1}
    hs.blendmode = "BLEND"
    hs.segmentsize = 128
    hs.outer_radius = 109
    hs.inner_radius = 70
    
    --define config variables for your power segments
    local ps = CreateFrame("Frame", nil, self)
    ps.anchorframe = self
    ps.anchorpoint = "LEFT"
    ps.anchorposx = 78
    ps.anchorposy = 0
    ps.size = 256
    ps.alpha = 1
    ps.framelevel = 4
    ps.scale = 0.62
    ps.segments_used = 4
    ps.start_segment = 3
    ps.fill_direction = 1
    ps.texture = "Interface\\AddOns\\oUF_RingThing\\media\\style1_ring"
    ps.color = {r = 255/255, g = 255/255, b = 255/255, a = 1}
    ps.blendmode = "BLEND"
    ps.segmentsize = 128
    ps.outer_radius = 109
    ps.inner_radius = 70
    
    --ring background
    local rb = CreateFrame("Frame", nil, self)
    rb.active = 1
    rb.color = {r = 255/255, g = 255/255, b = 255/255, a = 1}
    rb.alpha = 1
    rb.framelevel = 4
    rb.blendmode = "BLEND"
    rb.texture = "Interface\\AddOns\\oUF_RingThing\\media\\style1_background"
    rb.anchorframe = self
    rb.anchorpoint = "LEFT"
    rb.anchorposx = 0
    rb.anchorposy = 0
    rb.width = 512
    rb.height = 256
    
    --ring foreground
    local rf = CreateFrame("Frame", nil, self)    
    rf.active = 1
    rf.color = {r = 255/255, g = 255/255, b = 255/255, a = 1}
    rf.alpha = 1
    rf.framelevel = 7
    rf.blendmode = "BLEND"
    rf.texture = "Interface\\AddOns\\oUF_RingThing\\media\\style1_foreground"
    rf.anchorframe = self
    rf.anchorpoint = "LEFT"
    rf.anchorposx = 0
    rf.anchorposy = 0
    rf.width = 512
    rf.height = 256
    
    
    --portrait config
    local po = CreateFrame("Frame", nil, self)
    po.anchorframe = self
    po.anchorpoint = "LEFT"
    po.anchorposx = 64
    po.anchorposy = 0
    po.width = 128
    po.height = 128
    po.alpha = 1
    po.framelevel = 0
    po.scale = 1
    po.use_background = 1
    po.background_texture = "Interface\\AddOns\\oUF_RingThing\\media\\style1_portrait_bg"
    
    --castbar config
    local ca = CreateFrame("Frame", nil, self)
    ca.anchorframe = self
    ca.anchorpoint = "RIGHT"
    ca.anchorposx = -10
    ca.anchorposy = 0
    ca.width = 272
    ca.height = 72
    ca.alpha = 1
    ca.framelevel = 5
    ca.scale = 1
    ca.texture = "Interface\\AddOns\\oUF_RingThing\\media\\style1_castbar"
    ca.color = {r = 255/255, g = 120/255, b = 0/255, a = 1}
    ca.use_gloss = 1
    ca.gloss_texture = "Interface\\AddOns\\oUF_RingThing\\media\\style1_castbar_gloss"
    ca.gloss_framelevel = 8
    ca.use_background = 1
    ca.background_texture = "Interface\\AddOns\\oUF_RingThing\\media\\style1_castbar"
    ca.background_color = {r = 100/255, g = 80/255, b = 60/255, a = 0.5}
    ca.use_icon = 1
    ca.icon_framelevel = 1
    ca.icon_anchorframe = self
    ca.icon_anchorpoint = "LEFT"
    ca.icon_anchorposx = 80
    ca.icon_anchorposy = 0
    ca.icon_width = 90
    ca.icon_height = 90

    self.config = c
    self.config.health = hs
    self.config.power = ps
    self.config.background = rb
    self.config.foreground = rf
    self.config.portrait = po
    self.config.castbar = ca
  
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
      t2:SetTexture("Interface\\AddOns\\oUF_RingThing\\media\\slicer1")
    else
      t2:SetTexture("Interface\\AddOns\\oUF_RingThing\\media\\slicer0")
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
  local function calc_ring_health(self, event, unit, bar, min, max)
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
      for i=1, anz_seg do
        local multiplier = 0.7
        f.segments[i].square1:SetVertexColor(color.r*multiplier, color.g*multiplier, color.b*multiplier,1)
        f.segments[i].square2:SetVertexColor(color.r*multiplier, color.g*multiplier, color.b*multiplier,1)
        f.segments[i].slicer:SetVertexColor(color.r*multiplier, color.g*multiplier, color.b*multiplier,1)
        f.segments[i].fullsegment:SetVertexColor(color.r*multiplier, color.g*multiplier, color.b*multiplier,1)
        self.name:SetTextColor(color.r, color.g, color.b,1)
      end
    end
    
    if perc == 0 or UnitIsDeadOrGhost(unit) == 1 then
      for i=1, anz_seg do
        f.segments[i].square1:Hide()
        f.segments[i].square2:Hide()
        f.segments[i].slicer:Hide()
        f.segments[i].fullsegment:Hide()
      end
    elseif perc == 100 then
      for i=1, anz_seg do
        f.segments[i].square1:Hide()
        f.segments[i].square2:Hide()
        f.segments[i].slicer:Hide()
        f.segments[i].fullsegment:Show()
      end
    else
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
  local function calc_ring_mana(self, event, unit, bar, min, max)
    local f = self.power_ring
    local anz_seg = self.config.power.segments_used
    local act, max, perc, perc_per_seg, sum_radius = UnitMana(unit), UnitManaMax(unit), floor((UnitMana(unit)/UnitManaMax(unit))*100), 100/anz_seg, anz_seg*90
    
    local color = tabvalues.power[UnitPowerType(unit)]
    if color then
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
      end
    elseif perc == 100 then
      for i=1, anz_seg do
        f.segments[i].square1:Hide()
        f.segments[i].square2:Hide()
        f.segments[i].slicer:Hide()
        f.segments[i].fullsegment:Show()
      end
    else
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
  
  --menu  
  local function menu(self)
    local unit = self.unit:sub(1, -2)
    local cunit = self.unit:gsub("(.)", string.upper, 1)
    if(unit == "party" or unit == "partypet") then
      ToggleDropDownMenu(1, nil, _G["PartyMemberFrame"..self.id.."DropDown"], "cursor", 0, 0)
    elseif(_G[cunit.."FrameDropDown"]) then
      ToggleDropDownMenu(1, nil, _G[cunit.."FrameDropDown"], "cursor", 0, 0)
    end
  end

  --init self
  local function init_self(self)
    self.menu = menu
    self:RegisterForClicks("AnyUp")
    self:SetAttribute("*type2", "menu")
    self:SetScript("OnEnter", UnitFrame_OnEnter)
    self:SetScript("OnLeave", UnitFrame_OnLeave)
    self:SetAttribute("initial-height", self.config.height)
    self:SetAttribute("initial-width", self.config.width)
    self:SetAttribute("initial-scale", self.config.scale)
    self:SetPoint(self.config.anchorpoint,self.config.anchorposx,self.config.anchorposy)
    if testmode == 1 then
      local t = self:CreateTexture(nil,"BACKGROUND")
      t:SetTexture(1,0,0,0.5)
      t:SetAllPoints(self)
    end
  end
  
  --set fontstring
  local function SetFontString(parent, fontName, fontHeight, fontStyle)
    local fs = parent:CreateFontString(nil, "OVERLAY")
    fs:SetFont(fontName, fontHeight, fontStyle)
    fs:SetShadowColor(0,0,0,1)
    return fs
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
  
  local function create_portraits(self)
    local po = self.config.portrait
    self.Portrait = CreateFrame("PlayerModel", nil, po.anchorframe)
    self.Portrait:SetPoint(po.anchorpoint,po.anchorposx,po.anchorposy)
    self.Portrait:SetWidth(po.width)
    self.Portrait:SetHeight(po.height)
    self.Portrait:SetAlpha(po.alpha)
    self.Portrait:SetFrameLevel(po.framelevel)
    self.Portrait:SetScale(po.scale)
    if po.use_background == 1 then
      local t = self.Portrait:CreateTexture(nil,"BACKGROUND")
      t:SetTexture(po.background_texture)
      t:SetAllPoints(self.Portrait)
    end
  end
  
  local function create_castbar(self)
    ca = self.config.castbar
    self.Castbar = CreateFrame("StatusBar", nil, ca.anchorframe)
    self.Castbar:SetPoint(ca.anchorpoint,ca.anchorposx,ca.anchorposy)
    self.Castbar:SetWidth(ca.width)
    self.Castbar:SetHeight(ca.height)
    self.Castbar:SetAlpha(ca.alpha)
    self.Castbar:SetFrameLevel(ca.framelevel)
    self.Castbar:SetScale(ca.scale)
    self.Castbar:SetStatusBarTexture(ca.texture)
    self.Castbar:SetStatusBarColor(ca.color.r,ca.color.g,ca.color.b,ca.color.a)

    if ca.use_gloss == 1 then
      local f = CreateFrame("Frame",nil,self.Castbar)
      f:SetAllPoints(self.Castbar)
      f:SetFrameLevel(ca.gloss_framelevel)
      local t = f:CreateTexture(nil,"BACKGROUND")
      t:SetTexture(ca.gloss_texture)
      t:SetAllPoints(f)
    end
    
    if ca.use_background == 1 then
      self.Castbar.bg = self.Castbar:CreateTexture(nil, "BACKGROUND")
      self.Castbar.bg:SetTexture(ca.background_texture)
      self.Castbar.bg:SetAllPoints(self.Castbar)
      self.Castbar.bg:SetVertexColor(ca.background_color.r,ca.background_color.g,ca.background_color.b,ca.background_color.a)
    end
    
    if ca.use_icon == 1 then
      local f = CreateFrame("Frame",nil,self)
      f:SetPoint(ca.icon_anchorpoint,ca.icon_anchorposx,ca.icon_anchorposy)
      f:SetWidth(ca.icon_width)
      f:SetHeight(ca.icon_height)
      f:SetFrameLevel(ca.icon_framelevel)
      self.Castbar.Icon = f:CreateTexture(nil, "BACKGROUND")
      self.Castbar.Icon:SetAllPoints(f)
      self.Castbar.Icon:SetTexCoord(0.1, 0.9, 0.1, 0.9)
      self.Castbar:SetScript("OnShow", function(_) self.Castbar.Icon:Show() end)
      self.Castbar:SetScript("OnHide", function(_) self.Castbar.Icon:Hide() end)
    end
    
    self.Castbar.Text = SetFontString(self.Castbar, myfont, 28, "THINOUTLINE")
    self.Castbar.Text:SetPoint("LEFT", 15, 0)
    self.Castbar.Text:SetJustifyH("LEFT")
    
    self.Castbar.Time = SetFontString(self.Castbar, myfont, 28, "THINOUTLINE")
    self.Castbar.Time:SetPoint("RIGHT", -5, 0)
    self.Castbar.Text:SetPoint("RIGHT", self.Castbar.Time, "LEFT", 5, 0)
  
  end
  
  --TAGS
  oUF.Tags["[kiss_classtext]"] = function(unit) 
    local string, tmpstring, sp = "", "", " "
    if UnitLevel(unit) ~= -1 then
      string = UnitLevel(unit)
    else
      string = "??"
    end    
    string = string..sp
    local unitrace = UnitRace(unit)
    local creatureType = UnitCreatureType(unit)    
    if unitrace and UnitIsPlayer(unit) then
      string = string..unitrace..sp
    end   
    if creatureType and not UnitIsPlayer(unit) then
      string = string..creatureType..sp
    end    
    local unit_classification = UnitClassification(unit)    
    if unit_classification == "worldboss" then
      tmpstring = "Boss"
    elseif unit_classification == "rare" or unit_classification == "rareelite" then
      tmpstring = "Rare"
      if unit_classification == "rareelite" then
        tmpstring = tmpstring.." Elite"
      end
    elseif unit_classification == "elite" then
      tmpstring = "Elite"
    end    
    if tmpstring ~= "" then
      tmpstring = tmpstring..sp  
    end    
    string = string..tmpstring
    tmpstring = ""    
    local localizedClass, englishClass = UnitClass(unit)
    
    if localizedClass and UnitIsPlayer(unit) then
      string = string..localizedClass..sp
    end
    return string
  end
  
  local function create_text_strings(self)
    --hpval
    local hpval1 = SetFontString(self.ring_foreground, myfont, 30, "OUTLINE")
    hpval1:SetWidth(64)
    hpval1:SetJustifyH("CENTER")
    hpval1:SetPoint("BOTTOM", self.ring_foreground, "BOTTOM", -128, 24)
    self:Tag(hpval1, "[perhp]")
    self.hpval = hpval1
    
    --mana value
    local mpval1 = SetFontString(self.ring_foreground, myfont, 20, "OUTLINE")
    mpval1:SetWidth(64)
    mpval1:SetJustifyH("CENTER")
    mpval1:SetPoint("BOTTOM", self.ring_foreground, "BOTTOM", -128, 64)
    self.ppval = mpval1
    self:Tag(mpval1, "[perpp]")
    
    local classtext = SetFontString(self.ring_foreground, myfont, 20, "THINOUTLINE")
    classtext:SetPoint("LEFT",235,-54)
    classtext:SetPoint("RIGHT", -45, -54)
    classtext:SetJustifyH("LEFT")
    self:Tag(classtext, "[kiss_classtext]")
    self.classtext = classtext
    
    local name = SetFontString(self.ring_foreground, myfont, 26, "THINOUTLINE")
    name:SetPoint("LEFT",235,56)
    name:SetPoint("RIGHT", -45, 56)
    name:SetJustifyH("LEFT")
    self:Tag(name, "[name]")
    self.name = name
    
  end
  
  local function init(self)
    --init self
    init_self(self)    
    --create the background ring
    if self.config.background.active == 1 then
      self.ring_background = create_ring_background(self)
    end    
    --create the foreground ring
    if self.config.foreground.active == 1 then
      self.ring_foreground = create_ring_foreground(self)
    end
    --create the health ring
    self.health_ring = create_health_segments(self)
    --create the power ring
    self.power_ring = create_power_segments(self)    
    --create fake health and power statusbars to make the health/mana functions available
    self.Health = CreateFrame("StatusBar", nil, self)
    self.Power = CreateFrame("StatusBar", nil, self)    
    self.Power.frequentUpdates = true
    
    create_portraits(self)
    create_castbar(self)
    create_text_strings(self)
    make_me_movable(self)
    
    self.PostUpdateHealth = calc_ring_health
    self.PostUpdatePower = calc_ring_mana  
  end
  
  -----------------------------
  -- CREATE STYLES
  -----------------------------

  --this style will consist of two half-rings, left for health and right for mana
  --PLAYER STYLE
  local function CreatePlayerRingStyle(self, unit)
    --load default setup
    default_config(self)   
    --rewrite specific config values that should be different from the default setup
    self.config.scale = 0.5
    --init the frames
    init(self)
  end
  
  --TARGET STYLE
  local function CreateTargetRingStyle(self, unit)    
    default_config(self)
    --rewrite specific config values that should be different from the default setup
    self.config.scale = 0.5
    init(self)  
  end
  
  --ToT STYLE
  local function CreateToTRingStyle(self, unit)    
    default_config(self)
    --rewrite specific config values that should be different from the default setup
    self.config.scale = 0.35
    init(self)
  
  end
  
  -----------------------------
  -- REGISTER STYLES
  -----------------------------
  oUF:RegisterStyle("player_ring", CreatePlayerRingStyle)
  oUF:RegisterStyle("target_ring", CreateTargetRingStyle)
  oUF:RegisterStyle("tot_ring", CreateToTRingStyle)
  
  -----------------------------
  -- SPAWN UNITS
  -----------------------------
  oUF:SetActiveStyle("player_ring")
  oUF:Spawn("player", "oUF_RingThing_Player")
  oUF:SetActiveStyle("target_ring")
  oUF:Spawn("target", "oUF_RingThing_Target")
  oUF:SetActiveStyle("tot_ring")
  oUF:Spawn("targettarget", "oUF_RingThing_ToT")