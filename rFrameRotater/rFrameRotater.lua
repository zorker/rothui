
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
        * Neither the name of rFrameRotater nor the names of its contributors may
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
  
  -----------------------
  -- CONFIG AREA START --
  -----------------------

  frames_to_rotate = {
    [1] = { 
      texture = "ring", --texturename under media folder
      width = 190, 
      height = 190,
      scale = 0.82,
      anchorframe = Minimap,
      framelevel = "3", --defines the framelevel to overlay or underlay other stuff
      color_red = 0/255,
      color_green = 0/255,
      color_blue = 0/255,
      alpha = 0.4,
      duration = 60, --how long should the rotation need to finish 360°
      direction = 1, --0 = counter-clockwise, 1 = clockwise
      blendmode = "BLEND", --ADD or BLEND
      setpoint = "CENTER",
      setpointx = 0,
      setpointy = 0,
    },
    
    [2] = { 
      texture = "zahnrad", --texturename under media folder
      width = 210, 
      height = 210,
      scale = 0.82,
      anchorframe = Minimap,
      framelevel = "0",
      color_red = 48/255,
      color_green = 44/255,
      color_blue = 35/255,
      alpha = 1,
      duration = 60, --how long should the rotation need to finish 360°
      direction = 1, --0 = counter-clockwise, 1 = clockwise
      blendmode = "BLEND", --ADD or BLEND
      setpoint = "CENTER",
      setpointx = 0,
      setpointy = 0,
    },

  }
    
  
  ---------------------  
  -- CONFIG AREA END --
  ---------------------

  
  local a = CreateFrame("Frame", nil, UIParent)
  
  a:RegisterEvent("PLAYER_LOGIN")
  
  a:SetScript("OnEvent", function (self,event,arg1)
    if(event=="PLAYER_LOGIN") then
      for index,value in ipairs(frames_to_rotate) do 
        local ftr = frames_to_rotate[index]
        a:rotateme(ftr.texture, ftr.width, ftr.height, ftr.scale, ftr.anchorframe, ftr.framelevel, ftr.color_red, ftr.color_green, ftr.color_blue, ftr.alpha, ftr.duration, ftr.direction, ftr.blendmode, ftr.setpoint, ftr.setpointx, ftr.setpointy)
      end
    end
  end)    
  
  function a:rotateme(texture,width,height,scale,anchorframe,framelevel,texr,texg,texb,alpha,duration,side,blendmode,point,pointx,pointy)

    local h = CreateFrame("Frame",nil,anchorframe)
    h:SetHeight(height)
    h:SetWidth(width)		  
    h:SetPoint(point,pointx,pointy)
    h:SetScale(scale)
    h:SetFrameLevel(framelevel)
  
    local t = h:CreateTexture()
    t:SetAllPoints(h)
    t:SetTexture("Interface\\AddOns\\rFramerotater\\media\\"..texture)
    t:SetBlendMode(blendmode)
    t:SetVertexColor(texr,texg,texb,alpha)
    h.t = t
    
    local ag = h:CreateAnimationGroup()
    h.ag = ag
    
    local a1 = h.ag:CreateAnimation("Rotation")
    if side == 0 then
      a1:SetDegrees(360)
    else
      a1:SetDegrees(-360)
    end
    a1:SetDuration(duration)
    h.ag.a1 = a1
    
    h.ag:Play()
    h.ag:SetLooping("REPEAT")  

  end