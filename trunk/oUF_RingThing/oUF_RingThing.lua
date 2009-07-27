
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

  local ringfont = "Interface\\AddOns\\oUF_RingThing\\fonts\\Prototype.ttf"

  local ring_table = {
    [1] = { 
      global = {
        active = 1,
        unit = "player",
        ringname = "rM_PlayerHealth",
        size = 256,
        anchorframe = UIParent,
        anchorpoint = "CENTER",
        anchorposx = -400,
        anchorposy = -100,
        scale = 0.7,
        alpha = 1,
        framelevel = 1,
        gfx_folder = "Interface\\AddOns\\oUF_RingThing\\ring_gfx\\",
        segments_used = 2,
        start_segment = 3,
        fill_direction = 1,
        ringtype = "health",
      },
      background = {
        color = {r = 255/255, g = 255/255, b = 255/255, a = 1},
        alpha = 0.7,
        framelevel = 1,
        blendmode = "blend",
        use_texture = 1,
        do_rotation = 1,
        file = "256_1\\ring_background",
        rotation = {
          update_timer = 1/30,
          step_size = 0.3,
          direction = 0,
        },
      },
      foreground = {
        color = {r = 255/255, g = 255/255, b = 255/255, a = 1},
        alpha = 1,
        blendmode = "blend",
        framelevel = 3,
        file = "256_1\\ring_foreground2",
        use_texture = 1,
      },
      segment = {
        color = {r = 180/255, g = 10/255, b = 10/255, a = 1},
        alpha = 1,
        blendmode = "add",
        framelevel = 2,
        file = "256_1\\ring_segment",
        segmentsize = 128,
        outer_radius = 110,
        inner_radius = 90,
      },
    },

    [2] = { 
      global = {
        active = 1,
        unit = "player",
        ringname = "rM_PlayerMana",
        size = 256,
        anchorframe = UIParent,
        anchorpoint = "CENTER",
        anchorposx = -400,
        anchorposy = -100,
        scale = 0.7,
        alpha = 1,
        framelevel = 1,
        gfx_folder = "Interface\\AddOns\\oUF_RingThing\\ring_gfx\\",
        segments_used = 2,
        start_segment = 2,
        fill_direction = 0,
        ringtype = "mana",
      },
      background = {
        color = {r = 255/255, g = 255/255, b = 255/255, a = 1},
        alpha = 0.7,
        framelevel = 1,
        blendmode = "blend",
        use_texture = 0,
        file = "256_1\\ring_foreground2",
        do_rotation = 0,
        rotation = {
          update_timer = 1/30,
          step_size = 0.2,
          direction = 1,
        },
      },
      foreground = {
        color = {r = 255/255, g = 255/255, b = 255/255, a = 1},
        alpha = 1,
        blendmode = "blend",
        framelevel = 3,
        use_texture = 0,
        file = "256_1\\ring_background",
      },
      segment = {
        color = {r = 10/255, g = 100/255, b = 150/255, a = 1},
        alpha = 1,
        blendmode = "add",
        framelevel = 2,
        file = "256_1\\ring_segment",
        segmentsize = 128,
        outer_radius = 110,
        inner_radius = 90,
      },
    },

    [3] = { 
      global = {
        active = 1,
        unit = "player",
        ringname = "rM_TargetHealth",
        size = 256,
        anchorframe = UIParent,
        anchorpoint = "CENTER",
        anchorposx = 400,
        anchorposy = -100,
        scale = 0.7,
        alpha = 1,
        framelevel = 1,
        gfx_folder = "Interface\\AddOns\\oUF_RingThing\\ring_gfx\\",
        segments_used = 2,
        start_segment = 3,
        fill_direction = 1,
        ringtype = "health",
      },
      background = {
        color = {r = 255/255, g = 255/255, b = 255/255, a = 1},
        alpha = 0.7,
        framelevel = 1,
        blendmode = "blend",
        use_texture = 1,
        do_rotation = 1,
        file = "256_1\\ring_background",
        rotation = {
          update_timer = 1/30,
          step_size = 0.3,
          direction = 0,
        },
      },
      foreground = {
        color = {r = 255/255, g = 255/255, b = 255/255, a = 1},
        alpha = 1,
        blendmode = "blend",
        framelevel = 3,
        file = "256_1\\ring_foreground2",
        use_texture = 1,
      },
      segment = {
        color = {r = 180/255, g = 10/255, b = 10/255, a = 1},
        alpha = 1,
        blendmode = "add",
        framelevel = 2,
        file = "256_1\\ring_segment",
        segmentsize = 128,
        outer_radius = 110,
        inner_radius = 90,
      },
    },

    [4] = { 
      global = {
        active = 1,
        unit = "player",
        ringname = "rM_TargetMana",
        size = 256,
        anchorframe = UIParent,
        anchorpoint = "CENTER",
        anchorposx = 400,
        anchorposy = -100,
        scale = 0.7,
        alpha = 1,
        framelevel = 1,
        gfx_folder = "Interface\\AddOns\\oUF_RingThing\\ring_gfx\\",
        segments_used = 2,
        start_segment = 2,
        fill_direction = 0,
        ringtype = "mana",
      },
      background = {
        color = {r = 255/255, g = 255/255, b = 255/255, a = 1},
        alpha = 0.7,
        framelevel = 1,
        blendmode = "blend",
        use_texture = 0,
        file = "256_1\\ring_foreground2",
        do_rotation = 0,
        rotation = {
          update_timer = 1/30,
          step_size = 0.2,
          direction = 1,
        },
      },
      foreground = {
        color = {r = 255/255, g = 255/255, b = 255/255, a = 1},
        alpha = 1,
        blendmode = "blend",
        framelevel = 3,
        use_texture = 0,
        file = "256_1\\ring_background",
      },
      segment = {
        color = {r = 10/255, g = 100/255, b = 150/255, a = 1},
        alpha = 1,
        blendmode = "add",
        framelevel = 2,
        file = "256_1\\ring_segment",
        segmentsize = 128,
        outer_radius = 110,
        inner_radius = 90,
      },
    },

    [5] = { 
      global = {
        active = 1,
        unit = "player",
        ringname = "rM_ToTHealth",
        size = 256,
        anchorframe = UIParent,
        anchorpoint = "CENTER",
        anchorposx = 350,
        anchorposy = -290,
        scale = 0.4,
        alpha = 1,
        framelevel = 1,
        gfx_folder = "Interface\\AddOns\\oUF_RingThing\\ring_gfx\\",
        segments_used = 2,
        start_segment = 3,
        fill_direction = 1,
        ringtype = "health",
      },
      background = {
        color = {r = 255/255, g = 255/255, b = 255/255, a = 1},
        alpha = 0.7,
        framelevel = 1,
        blendmode = "blend",
        use_texture = 1,
        do_rotation = 1,
        file = "256_1\\ring_background",
        rotation = {
          update_timer = 1/30,
          step_size = 0.3,
          direction = 0,
        },
      },
      foreground = {
        color = {r = 255/255, g = 255/255, b = 255/255, a = 1},
        alpha = 1,
        blendmode = "blend",
        framelevel = 3,
        file = "256_1\\ring_foreground2",
        use_texture = 1,
      },
      segment = {
        color = {r = 180/255, g = 10/255, b = 10/255, a = 1},
        alpha = 1,
        blendmode = "add",
        framelevel = 2,
        file = "256_1\\ring_segment",
        segmentsize = 128,
        outer_radius = 110,
        inner_radius = 90,
      },
    },

    [6] = { 
      global = {
        active = 1,
        unit = "player",
        ringname = "rM_ToTMana",
        size = 256,
        anchorframe = UIParent,
        anchorpoint = "CENTER",
        anchorposx = 400,
        anchorposy = -100,
        scale = 0.4,
        alpha = 1,
        framelevel = 1,
        gfx_folder = "Interface\\AddOns\\oUF_RingThing\\ring_gfx\\",
        segments_used = 2,
        start_segment = 2,
        fill_direction = 0,
        ringtype = "mana",
      },
      background = {
        color = {r = 255/255, g = 255/255, b = 255/255, a = 1},
        alpha = 0.7,
        framelevel = 1,
        blendmode = "blend",
        use_texture = 0,
        file = "256_1\\ring_foreground2",
        do_rotation = 0,
        rotation = {
          update_timer = 1/30,
          step_size = 0.2,
          direction = 1,
        },
      },
      foreground = {
        color = {r = 255/255, g = 255/255, b = 255/255, a = 1},
        alpha = 1,
        blendmode = "blend",
        framelevel = 3,
        use_texture = 0,
        file = "256_1\\ring_background",
      },
      segment = {
        color = {r = 10/255, g = 100/255, b = 150/255, a = 1},
        alpha = 1,
        blendmode = "add",
        framelevel = 2,
        file = "256_1\\ring_segment",
        segmentsize = 128,
        outer_radius = 110,
        inner_radius = 90,
      },
    },

  }
    
  
  ---------------------  
  -- FUNCTIONS
  ---------------------

  local function am(text)
    DEFAULT_CHAT_FRAME:AddMessage(text)
  end
  
  local function cre_ring_holder(ring_config,self)
    --am(ring_config.global.anchorframe)
    local f = CreateFrame("Frame",ring_config.global.ringname,self)
    f:SetAllPoints(self)
    return f
  end
  
  local r2 = math.sqrt(0.5^2+0.5^2);
  
  --background rotation
  local function do_background_rotation(self, elapsed)
    self.rotation.totalElapsed = self.rotation.totalElapsed + elapsed
    if (self.rotation.totalElapsed < self.rotation.update_timer) then 
      return 
    else
      self.rotation.totalElapsed = 0
      if self.rotation.direction == 1 then
        self.texture:SetTexCoord(
        0.5+r2*cos(self.rotation.degrees+135), 0.5+r2*sin(self.rotation.degrees+135),
        0.5+r2*cos(self.rotation.degrees-135), 0.5+r2*sin(self.rotation.degrees-135),
        0.5+r2*cos(self.rotation.degrees+45), 0.5+r2*sin(self.rotation.degrees+45),
        0.5+r2*cos(self.rotation.degrees-45), 0.5+r2*sin(self.rotation.degrees-45)
        ) 
        self.rotation.degrees = self.rotation.degrees+self.rotation.step_size
        if self.rotation.degrees > 360 then
          self.rotation.degrees = 0
        end
      else
        self.texture:SetTexCoord(
        0.5+r2*cos(self.rotation.degrees+45), 0.5+r2*sin(self.rotation.degrees+45),
        0.5+r2*cos(self.rotation.degrees+135), 0.5+r2*sin(self.rotation.degrees+135),
        0.5+r2*cos(self.rotation.degrees-45), 0.5+r2*sin(self.rotation.degrees-45),            
        0.5+r2*cos(self.rotation.degrees-135), 0.5+r2*sin(self.rotation.degrees-135)
        )
        self.rotation.degrees = self.rotation.degrees-self.rotation.step_size
        if self.rotation.degrees < 0 then
          self.rotation.degrees = 360
        end
      end
    end
  end
  
  local function cre_ring_background(ring_config, ring_object)
    local f = CreateFrame("Frame",nil,ring_object)
    f:SetAllPoints(ring_object)
    f:SetFrameLevel(ring_config.background.framelevel)
    f:SetAlpha(ring_config.background.alpha)
    if (ring_config.background.use_texture == 1) then
      local t = f:CreateTexture(nil,"BACKGROUND")
      t:SetTexture(ring_config.global.gfx_folder..ring_config.background.file)
      t:SetAllPoints(f)
      t:SetVertexColor(ring_config.background.color.r,ring_config.background.color.g,ring_config.background.color.b,ring_config.background.color.a)
      t:SetBlendMode(ring_config.background.blendmode)
      f.texture = t
      --rotation
      if (ring_config.background.do_rotation == 1) then
        f.rotation = CreateFrame("Frame",nil,f)
        f.rotation.totalElapsed = 0
        f.rotation.direction = ring_config.background.rotation.direction
        if ring_config.background.rotation.direction == 1 then
          f.rotation.degrees = 0
        else 
          f.rotation.degrees = 360
        end
        f.rotation.step_size = ring_config.background.rotation.step_size
        f.rotation.update_timer = ring_config.background.rotation.update_timer
        f.rotation.starttime = GetTime()
        f:SetScript("OnUpdate", function (self,elapsed)
          do_background_rotation(f,elapsed)
        end)
      end
    end
    return f
  end
  
  local function cre_ring_foreground(ring_config, ring_object)
    local f = CreateFrame("Frame",nil,ring_object)
    f:SetAllPoints(ring_object)
    f:SetFrameLevel(ring_config.foreground.framelevel)
    f:SetAlpha(ring_config.foreground.alpha)
    if (ring_config.foreground.use_texture == 1) then
      local t = f:CreateTexture(nil,"foreground")
      t:SetTexture(ring_config.global.gfx_folder..ring_config.foreground.file)
      t:SetAllPoints(f)
      t:SetVertexColor(ring_config.foreground.color.r,ring_config.foreground.color.g,ring_config.foreground.color.b,ring_config.foreground.color.a)
      t:SetBlendMode(ring_config.foreground.blendmode)
      f.texture = t
    end
    return f
  end
  
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
  local function cre_segment_textures(ring_config,self)
    --am(self.field)
    
    local direction = ring_config.global.fill_direction
    local segmentsize = ring_config.segment.segmentsize
    local outer_radius = ring_config.segment.outer_radius
    local difference = segmentsize-outer_radius
    local inner_radius = ring_config.segment.inner_radius
    local ring_factor = outer_radius/inner_radius
    local ring_width = outer_radius-inner_radius
    
    self.direction =  ring_config.global.fill_direction
    self.segmentsize = ring_config.segment.segmentsize
    self.outer_radius = ring_config.segment.outer_radius
    self.difference = segmentsize-outer_radius
    self.inner_radius = ring_config.segment.inner_radius
    self.ring_factor = outer_radius/inner_radius
    self.ring_width = outer_radius-inner_radius
    
    local t0 = self:CreateTexture(nil, "BACKGROUND")
    t0:SetTexture(ring_config.global.gfx_folder..ring_config.segment.file)
    t0:SetVertexColor(ring_config.segment.color.r,ring_config.segment.color.g,ring_config.segment.color.b,ring_config.segment.color.a)
    t0:SetBlendMode(ring_config.segment.blendmode)
    t0:Hide()
    
    local t1 = self:CreateTexture(nil, "BACKGROUND")
    t1:SetTexture(ring_config.global.gfx_folder..ring_config.segment.file)
    t1:SetVertexColor(ring_config.segment.color.r,ring_config.segment.color.g,ring_config.segment.color.b,ring_config.segment.color.a)
    t1:SetBlendMode(ring_config.segment.blendmode)
    t1:Hide()

    local t2 = self:CreateTexture(nil, "BACKGROUND")
    t2:SetVertexColor(ring_config.segment.color.r,ring_config.segment.color.g,ring_config.segment.color.b,ring_config.segment.color.a)
    t2:SetBlendMode(ring_config.segment.blendmode)
    if direction == 1 then
      t2:SetTexture(ring_config.global.gfx_folder.."slicer1")
    else
      t2:SetTexture(ring_config.global.gfx_folder.."slicer0")
    end
    t2:Hide()

    local t3 = self:CreateTexture(nil, "BACKGROUND")
    t3:SetTexture(ring_config.global.gfx_folder..ring_config.segment.file)
    t3:SetVertexColor(ring_config.segment.color.r,ring_config.segment.color.g,ring_config.segment.color.b,ring_config.segment.color.a)
    t3:SetBlendMode(ring_config.segment.blendmode)
    t3:SetPoint("CENTER",0,0)
    t3:SetWidth(segmentsize)
    t3:SetHeight(segmentsize)
    if self.field == 1 then
      --no coord needed
    elseif self.field == 2 then
      t3:SetTexCoord(0,1, 1,1, 0,0, 1,0)
    elseif self.field == 3 then
      t3:SetTexCoord(1,1, 1,0, 0,1, 0,0)
    elseif self.field == 4 then
      t3:SetTexCoord(1,0, 0,0, 1,1, 0,1)
    end
    t3:Hide()
    
    self.square1 = t0
    self.square2 = t1
    self.slicer = t2
    self.fullsegment = t3
    
  end
  
  --calculate the segment number based on starting segment and direction
  local function calc_segment_num(ring_config,current)
    local start = ring_config.global.start_segment
    local dir = ring_config.global.fill_direction
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
  
  --create the ring segments
  local function cre_ring_segments(ring_config, ring_object)
    local f = CreateFrame("Frame",nil,ring_object)
    f:SetAllPoints(ring_object)
    f:SetFrameLevel(ring_config.segment.framelevel)
    f:SetAlpha(ring_config.segment.alpha)
    for i=1,(ring_config.global.segments_used) do
      f[i] = CreateFrame("Frame",nil,f)
      f[i]:SetWidth(ring_config.global.size/2)
      f[i]:SetHeight(ring_config.global.size/2)
      f[i].id = i
      f[i].field = calc_segment_num(ring_config,i-1)
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
      cre_segment_textures(ring_config,f[i])
    end
    return f
  end

  
  local function calc_ring_health(self, event, unit, bar, min, max)
    local self = self.hp_ring
    local ring_config = self.config
    local act, max, perc, perc_per_seg = UnitHealth(unit), UnitHealthMax(unit), floor((UnitHealth(unit)/UnitHealthMax(unit))*100), 100/ring_config.global.segments_used
    local anz_seg, sum_radius = ring_config.global.segments_used, ring_config.global.segments_used*90
    
    if perc == 0 or UnitIsDeadOrGhost(unit) == 1 then
      for i=1, anz_seg do
        self.segments[i].square1:Hide()
        self.segments[i].square2:Hide()
        self.segments[i].slicer:Hide()
        self.segments[i].fullsegment:Hide()
      end
    elseif perc == 100 then
      for i=1, anz_seg do
        self.segments[i].square1:Hide()
        self.segments[i].square2:Hide()
        self.segments[i].slicer:Hide()
        self.segments[i].fullsegment:Show()
      end
    else
      for i=1, anz_seg do
        if(perc >= (i*perc_per_seg)) then
          self.segments[i].square1:Hide()
          self.segments[i].square2:Hide()
          self.segments[i].slicer:Hide()
          self.segments[i].fullsegment:Show()
        elseif ((perc > ((i-1)*perc_per_seg)) and (perc < (i*perc_per_seg))) then
          local value = ((perc-((i-1)*perc_per_seg))/perc_per_seg)*100
          calc_ring_segment(self.segments[i],value)
          self.segments[i].square1:Show()
          self.segments[i].square2:Show()
          self.segments[i].slicer:Show()
          self.segments[i].fullsegment:Hide()
        else
          self.segments[i].square1:Hide()
          self.segments[i].square2:Hide()
          self.segments[i].slicer:Hide()
          self.segments[i].fullsegment:Hide()
        end
      end
    end
  end  
  
  local function calc_ring_mana(self, event, unit, bar, min, max)
    local self = self.mp_ring
    local ring_config = self.config
    local act, max, perc, perc_per_seg = UnitMana(unit), UnitManaMax(unit), floor((UnitMana(unit)/UnitManaMax(unit))*100), 100/ring_config.global.segments_used
    local anz_seg, sum_radius = ring_config.global.segments_used, ring_config.global.segments_used*90
    
    if perc == 0 or UnitIsDeadOrGhost(unit) == 1 then
      for i=1, anz_seg do
        self.segments[i].square1:Hide()
        self.segments[i].square2:Hide()
        self.segments[i].slicer:Hide()
        self.segments[i].fullsegment:Hide()
      end
    elseif perc == 100 then
      for i=1, anz_seg do
        self.segments[i].square1:Hide()
        self.segments[i].square2:Hide()
        self.segments[i].slicer:Hide()
        self.segments[i].fullsegment:Show()
      end
    else
      for i=1, anz_seg do
        if(perc >= (i*perc_per_seg)) then
          self.segments[i].square1:Hide()
          self.segments[i].square2:Hide()
          self.segments[i].slicer:Hide()
          self.segments[i].fullsegment:Show()
        elseif ((perc > ((i-1)*perc_per_seg)) and (perc < (i*perc_per_seg))) then
          local value = ((perc-((i-1)*perc_per_seg))/perc_per_seg)*100
          calc_ring_segment(self.segments[i],value)
          self.segments[i].square1:Show()
          self.segments[i].square2:Show()
          self.segments[i].slicer:Show()
          self.segments[i].fullsegment:Hide()
        else
          self.segments[i].square1:Hide()
          self.segments[i].square2:Hide()
          self.segments[i].slicer:Hide()
          self.segments[i].fullsegment:Hide()
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
  
  local function setup_self(id,f)
    f.menu = menu
    f:RegisterForClicks("AnyUp")
    f:SetAttribute("*type2", "menu")
    f:SetScript("OnEnter", UnitFrame_OnEnter)
    f:SetScript("OnLeave", UnitFrame_OnLeave)
    local ring_config = ring_table[id]
    f:SetWidth(ring_config.global.size)
    f:SetHeight(ring_config.global.size)
    f:ClearAllPoints()
    f:SetPoint(ring_config.global.anchorpoint,ring_config.global.anchorposx,ring_config.global.anchorposy)
    f:SetFrameLevel(ring_config.global.framelevel)
    f:SetScale(ring_config.global.scale)
    f:SetAlpha(ring_config.global.alpha)
  end
  
  local function setup_ring(id,self)
  
    local ring_config = ring_table[id]
    local ring_object = cre_ring_holder(ring_config,self)
    ring_object.config = ring_config
    ring_object.background = cre_ring_background(ring_object.config, ring_object)
    ring_object.segments = cre_ring_segments(ring_object.config, ring_object)
    ring_object.foreground = cre_ring_foreground(ring_object.config, ring_object)
    
    return ring_object

  end
  
  --set fontstring
  local function SetFontString(parent, fontName, fontHeight, fontStyle)
    local fs = parent:CreateFontString(nil, "OVERLAY")
    fs:SetFont(fontName, fontHeight, fontStyle)
    fs:SetShadowColor(0,0,0,1)
    return fs
  end
    
  -----------------------------
  -- CREATE STYLES
  -----------------------------
    
  --create the player style
  local function CreatePlayerStyle(self, unit)
    --self will always have the values of the health ring, important for clickability
    --ringid = 1
    setup_self(1,self)
    --health ring, id = 1
    self.hp_ring = setup_ring(1,self)
    --health value
    local hpval1 = SetFontString(self, ringfont, 32, "OUTLINE")
    hpval1:SetPoint("CENTER", 0, 12)
    hpval1:SetTextHeight(self.hp_ring.config.global.size/5)
    self:Tag(hpval1, "[perhp]")

    --mana ring, id = 2
    self.mp_ring = setup_ring(2,self)
    --mana value
    local mpval1 = SetFontString(self, ringfont, 32, "OUTLINE")
    mpval1:SetPoint("CENTER", 0, -35)
    mpval1:SetTextHeight(self.hp_ring.config.global.size/6.5)
    mpval1:SetTextColor(0.6,0.6,0.6)
    self:Tag(mpval1, "[perpp]")
    
    --create fake health and power statusbars to make the health/mana functions available
    self.Health = CreateFrame("StatusBar", nil, self)
    self.Power = CreateFrame("StatusBar", nil, self)
    
    self.Power.frequentUpdates = true
    
    self.PostUpdateHealth = calc_ring_health
    self.PostUpdatePower = calc_ring_mana  
  
  end
  
  --create the target style
  local function CreateTargetStyle(self, unit)
    --ringid = 3
    setup_self(3,self)
    --health ring, id = 3
    self.hp_ring = setup_ring(3,self)
    --health value
    local hpval1 = SetFontString(self, ringfont, 32, "OUTLINE")
    hpval1:SetPoint("CENTER", 0, 12)
    hpval1:SetTextHeight(self.hp_ring.config.global.size/5)
    self:Tag(hpval1, "[perhp]")

    --mana ring, id = 4
    self.mp_ring = setup_ring(4,self)
    --mana value
    local mpval1 = SetFontString(self, ringfont, 32, "OUTLINE")
    mpval1:SetPoint("CENTER", 0, -35)
    mpval1:SetTextHeight(self.hp_ring.config.global.size/6.5)
    mpval1:SetTextColor(0.6,0.6,0.6)
    self:Tag(mpval1, "[perpp]")    
    
    --create fake health and power statusbars to make the health/mana functions available
    self.Health = CreateFrame("StatusBar", nil, self)
    self.Power = CreateFrame("StatusBar", nil, self)
    
    self.PostUpdateHealth = calc_ring_health
    self.PostUpdatePower = calc_ring_mana  
  
  end
  
  --create the tot style
  local function CreateToTStyle(self, unit)
    --ring id = 5
    setup_self(5,self)
    --health ring, id = 5
    self.hp_ring = setup_ring(5,self)
    --health value
    local hpval1 = SetFontString(self, ringfont, 32, "OUTLINE")
    hpval1:SetPoint("CENTER", 0, 12)
    hpval1:SetTextHeight(self.hp_ring.config.global.size/5)
    self:Tag(hpval1, "[perhp]")

    --mana ring, id = 6
    self.mp_ring = setup_ring(6,self)
    --mana value
    local mpval1 = SetFontString(self, ringfont, 32, "OUTLINE")
    mpval1:SetPoint("CENTER", 0, -35)
    mpval1:SetTextHeight(self.hp_ring.config.global.size/6.5)
    mpval1:SetTextColor(0.6,0.6,0.6)
    self:Tag(mpval1, "[perpp]")    
    
    --create fake health and power statusbars to make the health/mana functions available
    self.Health = CreateFrame("StatusBar", nil, self)
    self.Power = CreateFrame("StatusBar", nil, self)
    
    self.PostUpdateHealth = calc_ring_health
    self.PostUpdatePower = calc_ring_mana  
  
  end
  
  -----------------------------
  -- REGISTER STYLES
  -----------------------------

  oUF:RegisterStyle("rt_player", CreatePlayerStyle)
  oUF:RegisterStyle("rt_target", CreateTargetStyle)
  oUF:RegisterStyle("rt_tot", CreateToTStyle)
  
  -----------------------------
  -- SPAWN UNITS
  -----------------------------

  oUF:SetActiveStyle("rt_player")
  oUF:Spawn("player", "oUF_RingThingPlayer")
  oUF:SetActiveStyle("rt_target")
  oUF:Spawn("target", "oUF_RingThingTarget")
  oUF:SetActiveStyle("rt_tot")
  oUF:Spawn("targettarget", "oUF_RingThingToT")
  
