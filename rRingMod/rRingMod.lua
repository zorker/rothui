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
        color = {r = 255/255, g = 55/255, b = 55/255, a = 1},
        alpha = 1,
        blendmode = "add",
        framelevel = 2,
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
    am(ring_config.global.anchorframe)
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
  
  local function cre_ring_segments(ring_config, ring_object)
    local f = CreateFrame("Frame",nil,ring_object)
    
    return f
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