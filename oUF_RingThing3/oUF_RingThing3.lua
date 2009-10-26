
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

  local myfont = "Interface\\AddOns\\oUF_RingThing\\fonts\\Prototype.ttf"
  
  ---------------------  
  -- FUNCTIONS
  ---------------------

  local function am(text)
    DEFAULT_CHAT_FRAME:AddMessage(text)
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
      t2:SetTexture("Interface\\AddOns\\oUF_RingThing\\ring_gfx\\slicer1")
    else
      t2:SetTexture("Interface\\AddOns\\oUF_RingThing\\ring_gfx\\slicer0")
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
    self:SetAttribute("initial-height", self.config.size)
    self:SetAttribute("initial-width", self.config.size)
    self:SetAttribute("initial-scale", self.config.scale)
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
    local f = CreateFrame("Frame",nil,self)
    f:SetAllPoints(self)
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
    local f = CreateFrame("Frame",nil,self)
    f:SetAllPoints(self)
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
    local f = CreateFrame("Frame",nil,self)
    f:SetAllPoints(self)
    f:SetFrameLevel(segment_config.framelevel)
    f:SetAlpha(segment_config.alpha)
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
  
  --create the health segments
  local function create_power_segments(self)
    local f = CreateFrame("Frame",nil,self)
    f.segments = create_segments(self,self.config.power)
    return f
  end    
  
  --the default config
  local function default_config(self)  
    --define config variables for your ring
    local c = CreateFrame("Frame", nil, self)
    c.anchorframe = UIParent
    c.anchorpoint = "CENTER"
    c.anchorposx = -400
    c.anchorposy = -100
    c.scale = 1
    c.size = 256
    c.alpha = 1
    
    --define config variables for your health segments
    local hs = CreateFrame("Frame", nil, self)
    hs.alpha = 1
    hs.framelevel = 1
    hs.segments_used = 2
    hs.start_segment = 3
    hs.fill_direction = 1
    hs.texture = "Interface\\AddOns\\oUF_RingThing\\ring_gfx\\ring1_segment"
    hs.color = {r = 180/255, g = 10/255, b = 10/255, a = 1}
    hs.blendmode = "BLEND"
    hs.segmentsize = 128
    hs.outer_radius = 110
    hs.inner_radius = 90
    
    --define config variables for your power segments
    local ps = CreateFrame("Frame", nil, self)
    ps.alpha = 1
    ps.framelevel = 1
    ps.segments_used = 2
    ps.start_segment = 2
    ps.fill_direction = 0
    ps.texture = "Interface\\AddOns\\oUF_RingThing\\ring_gfx\\ring1_segment"
    ps.color = {r = 10/255, g = 100/255, b = 150/255, a = 1}
    ps.blendmode = "BLEND"
    ps.segmentsize = 128
    ps.outer_radius = 110
    ps.inner_radius = 90
    
    --ring background
    local rb = CreateFrame("Frame", nil, self)
    rb.active = 1
    rb.color = {r = 255/255, g = 255/255, b = 255/255, a = 1}
    rb.alpha = 0.7
    rb.framelevel = 0
    rb.blendmode = "BLEND"
    rb.texture = "Interface\\AddOns\\oUF_RingThing\\ring_gfx\\ring1_background"
    
    --ring foreground
    local rf = CreateFrame("Frame", nil, self)    
    rf.active = 1
    rf.color = {r = 255/255, g = 255/255, b = 255/255, a = 1}
    rf.alpha = 0.7
    rf.framelevel = 2
    rf.blendmode = "BLEND"
    rf.texture = "Interface\\AddOns\\oUF_RingThing\\ring_gfx\\ring1_foreground"

    self.config = c
    self.config.health = hs
    self.config.power = ps
    self.config.background = rb
    self.config.foreground = rf
  
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
    --init the frames
    init(self)
  end
  
  --TARGET STYLE
  local function CreateTargetRingStyle(self, unit)    
    default_config(self)
    --rewrite specific config values that should be different from the default setup
    self.config.anchorposx = self.config.anchorposx*(-1)    
    init(self)
  
  end
  
  -----------------------------
  -- REGISTER STYLES
  -----------------------------
  oUF:RegisterStyle("player_ring", CreatePlayerRingStyle)
  oUF:RegisterStyle("target_ring", CreateTargetRingStyle)
  
  -----------------------------
  -- SPAWN UNITS
  -----------------------------
  oUF:SetActiveStyle("player_ring")
  oUF:Spawn("player", "oUF_RingThing_Player")
  oUF:SetActiveStyle("target_ring")
  oUF:Spawn("target", "oUF_RingThing_Target")
