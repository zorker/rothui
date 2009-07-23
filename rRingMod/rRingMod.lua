  --[[-------------------------------------------------------------------------
    Copyright (c) 2009, zork
    All rights reserved.
  
    Redistribution and use in source and binary forms, with or without
    modification, are permitted provided that the following conditions are
    met:
  
        * Redistributions of source code must retain the above copyright
          notice, this list of conditions and the following disclaimer.
        * Redistributions in binary form must reproduce the above
          copyright notice, this list of conditions and the following
          disclaimer in the documentation and/or other materials provided
          with the distribution.
        * Neither the name of rRingMod nor the names of its contributors may
          be used to endorse or promote products derived from this
          software without specific prior written permission.
  
    THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
    "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
    LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR
    A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT
    OWNER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL,
    SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT
    LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES LOSS OF USE,
    DATA, OR PROFITS OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY
    THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
    (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
    OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
  ---------------------------------------------------------------------------]]
  
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

  local ring_table = {
    [1] = { 
      global = {
        unit = "player",
        size = 256,
        anchorframe = UIParent,
        anchorpoint = "CENTER",
        anchorposx = 0,
        anchorposy = 0,
        scale = 1,
        alpha = 1,
        framelevel = 1,
        gfx_folder = "256_1",
        segments_used = 4,
        start_segment = 4,
        fill_direction = 0,
        ringtype = "health",
      },
      background = {
        color = {r = 255/255, g = 255/255, b = 255/255, a = 1},
        alpha = 0.7,
        framelevel = 1,
        blendmode = "blend",
        use_texture = 1,
        do_rotation = 1,
        rotation = {
          update_timer = 1/30,
          step_size = 0.3,
          direction = 1,
        },
      },
      foreground = {
        color = {r = 255/255, g = 255/255, b = 255/255, a = 1},
        alpha = 1,
        blendmode = "blend",
        framelevel = 3,
        use_texture = 1,
      },
      segment = {
        color = {r = 180/255, g = 10/255, b = 10/255, a = 1},
        alpha = 1,
        blendmode = "add",
        framelevel = 2,
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
  
  local function cre_ring_holder(ring_config)
    --am(ring_config.global.anchorframe)
    local f = CreateFrame("Frame",nil,ring_config.global.anchorframe)
    f:SetWidth(ring_config.global.size)
    f:SetHeight(ring_config.global.size)
    f:SetPoint(ring_config.global.anchorpoint,ring_config.global.anchorposx,ring_config.global.anchorposy)
    f:SetFrameLevel(ring_config.global.framelevel)
    f:SetScale(ring_config.global.scale)
    f:SetAlpha(ring_config.global.alpha)
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
      t:SetTexture("Interface\\AddOns\\rRingMod\\ring_gfx\\"..ring_config.global.gfx_folder.."\\ring_background")
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
      t:SetTexture("Interface\\AddOns\\rRingMod\\ring_gfx\\"..ring_config.global.gfx_folder.."\\ring_foreground")
      t:SetAllPoints(f)
      t:SetVertexColor(ring_config.foreground.color.r,ring_config.foreground.color.g,ring_config.foreground.color.b,ring_config.foreground.color.a)
      t:SetBlendMode(ring_config.foreground.blendmode)
      f.texture = t
    end
    return f
  end
  
  --calculates the one specific ring segment
  local function calc_ring_segment(self, value)
  
    local t0 = self.square1
    local t1 = self.square2
    local t2 = self.slicer
    local t3 = self.fullsegment
    
    --calculate statusbar value
    --remember to invert the value when direction = counter clockwise
    local statusbarvalue = value
    if (self.direction == 0) then
      statusbarvalue = 100-statusbarvalue
    end
    
    --angle
    local angle = statusbarvalue * 90 / 100
    local Arad = math.rad(angle)

    local Nx = 0
    local Ny = 0
    local Mx = segmentsize
    local My = segmentsize
    
    local Ix,Iy,Ox,Oy
    local IxCoord, IyCoord, OxCoord, OyCoord, NxCoord, NyCoord
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
    t0:SetTexture("Interface\\AddOns\\rRingMod\\ring_gfx\\"..ring_config.global.gfx_folder.."\\ring_segment")
    t0:SetVertexColor(ring_config.segment.color.r,ring_config.segment.color.g,ring_config.segment.color.b,ring_config.segment.color.a)
    t0:SetBlendMode(ring_config.segment.blendmode)
    t0:Hide()
    
    local t1 = self:CreateTexture(nil, "LOW")
    t1:SetTexture("Interface\\AddOns\\rRingMod\\ring_gfx\\"..ring_config.global.gfx_folder.."\\ring_segment")
    t1:SetVertexColor(ring_config.segment.color.r,ring_config.segment.color.g,ring_config.segment.color.b,ring_config.segment.color.a)
    t1:SetBlendMode(ring_config.segment.blendmode)
    t1:Hide()

    local t2 = self:CreateTexture(nil, "BACKGROUND")
    t2:SetVertexColor(ring_config.segment.color.r,ring_config.segment.color.g,ring_config.segment.color.b,ring_config.segment.color.a)
    t2:SetBlendMode(ring_config.segment.blendmode)
    if direction == 1 then
      t2:SetTexture("Interface\\AddOns\\rRingMod\\ring_gfx\\slicer1")
    else
      t2:SetTexture("Interface\\AddOns\\rRingMod\\ring_gfx\\slicer0")
    end
    t2:Hide()

    local t3 = self:CreateTexture(nil, "BACKGROUND")
    t3:SetTexture("Interface\\AddOns\\rRingMod\\ring_gfx\\"..ring_config.global.gfx_folder.."\\ring_segment")
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

  
  local function calc_ring_health(self,ring_config,unit)
    local act, max, perc, perc_per_seg = UnitHealth(unit), UnitHealthMax(unit), (UnitHealth(unit)/UnitHealthMax(unit))*100, 100/ring_config.global.segments_used
    local anz_seg, sum_radius = ring_config.global.segments_used, ring_config.global.segments_used*90
    
    -- need to run through ring segments
    -- anz_segments defines how much of 100 is taken by each segment
    -- 1 segment = 100, 2 = 50, 3 = 33, 4 = 25
    -- segments have 3 states, totally active, totally not active, partially active
    
    -- example, lets assume we use 4 segments, thuse 25% each segment
    -- we use player health as our ring and player has 64% health
    -- segment 1 is active, segment 2 is active, segment 3 is partial active, segment 4 is not active
    
    -- Special 
    -- if unit is dead or ghost too
    if perc == 0 then
      -- hide every element
      -- because every segment is saved in an array we can use a loop from 1-anz_seg here.
    elseif perc == 100 then
      -- make every element visible
      -- because every segment is saved in an array we can use a loop from 1-anz_seg here.
    else
      -- neeed to run through segments
      for i=1, anz_seg do
        if(perc > (i*perc_per_seg)) then
          -- player has more hp than this segment can handle
          -- show fullsegement texture, hide the rest
          am(i.." fully visible baby!")
        elseif (perc >= ((i-1)*perc_per_seg)) && (perc <= (i*perc_per_seg)) then
          -- player hp is exactly in this segment
          am(i.." look at me more closely")
          -- need to calc how much of this segment is filled.
          -- thuse I need to subtract ((i-1)*perc_per_seg) from my perc value
          -- example 64%, thus I am in segment 3. => 2*25 = 50
          -- 64-50=14, so 14 is the value I get, now need the "Dreisatz"
          -- 14/perc_per_seg = 0.56, so the segment we look at is filled to 56%
          -- so now we can paste this value to our function
          -- calc_ring_segment(self,value)
          -- remember to invert the value, depending on fill_direction!
          local value = ((perc-((i-1)*perc_per_seg))/perc_per_seg)*100
          if value = 0 then
            --textures bug out if value = 0
            value = 0.01
          end
          calc_ring_segment(self,value)
        else
          -- crap my health is not high enough to fill this
          -- hide everything
          am(i.." i'm out :/")
        end
      end
    end

    --am(act.."/"..max.." ~ "..perc)
    --am(ring_config.global.segments_used)
    
  end  
  
  local function setup_rings(id)
  
    local ring_config = ring_table[id]
    am("RingMod loaded.")
    --am(ring_config.global.unit)
    ring_object = cre_ring_holder(ring_config)
    ring_object.background = cre_ring_background(ring_config, ring_object)
    ring_object.segments = cre_ring_segments(ring_config, ring_object)
    ring_object.foreground = cre_ring_foreground(ring_config, ring_object)
    --am(ring_object.background.texture:GetTexture())
    --am(ring_object.segments[1].field)
    
    if ring_config.global.ringtype == "health" then
      ring_object:SetScript("OnEvent", function(self, event, unit)
        if (event == "UNIT_HEALTH" and unit == ring_config.global.unit) or event == "PLAYER_ENTERING_WORLD" then
          calc_ring_health(ring_object,ring_config,ring_config.global.unit)
        end    
      end)
      ring_object:RegisterEvent("UNIT_HEALTH")
      ring_object:RegisterEvent("PLAYER_ENTERING_WORLD")
    end

  end
  
  
  
  
  ---------------------  
  -- CALL
  ---------------------
  
  local a = CreateFrame("Frame", nil, UIParent)
  
  a:RegisterEvent("PLAYER_LOGIN")
  
  a:SetScript("OnEvent", function (self,event,arg1)
    if(event=="PLAYER_LOGIN") then
      for i in ipairs(ring_table) do 
        setup_rings(i)
      end
    end
  end)  