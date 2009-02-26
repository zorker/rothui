
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
     
  -- scaling
  local myscale = 0.82

  --info:
  --texture: name of the texture inside the "media" folder
  --direction: 1 = right, 0 = left
  --blendmode: 1 = blendmode("add"), 0 = no blend mode
  --steps in degree: how much the texture should rotate per step 0.1 = 0.1 degrees
  --update timer: how often the script should check for updates 1/60 = 60fps

  frames_to_rotate = {
    [1] = { 
      texture = "pentagram", 
      width = 210, 
      height = 210,
      anchorframe = "Minimap",
      framestrata = "BACKGROUND",
      color_red = 0/255,
      color_green = 0/255,
      color_blue = 0/255,
      alpha = 0.6,
      update_timer = 1/60,
      steps_in_degree = 0.1,
      direction = 1,
      blendmode = 0,
    },
    [2] = { 
      texture = "mapart2", 
      width = 240, 
      height = 240,
      anchorframe = "Minimap",
      framestrata = "BACKGROUND",
      color_red = 40/255,
      color_green = 30/255,
      color_blue = 30/255,
      alpha = 0.2,
      update_timer = 1/60,
      steps_in_degree = 0.4,
      direction = 0,
      blendmode = 0,
    },
  }
    
  
  ---------------------  
  -- CONFIG AREA END --
  ---------------------

  
  local a = CreateFrame("Frame", nil, UIParent)
  
  a:RegisterEvent("PLAYER_ENTERING_WORLD")
  
  a:SetScript("OnEvent", function (self,event,arg1)
    if(event=="PLAYER_ENTERING_WORLD") then
      for index,value in ipairs(frames_to_rotate) do 
        local ftr = frames_to_rotate[index]
        a:rotateme(ftr.texture, ftr.width, ftr.height, ftr.anchorframe, ftr.framestrata, ftr.color_red, ftr.color_green, ftr.color_blue, ftr.alpha, ftr.update_timer, ftr.steps_in_degree,ftr.direction, ftr.blendmode)
      end
    end
  end)    
  
  function a:rotateme(tex,texw,texh,texanchor,texstrata,texr,texg,texb,texalpha,timer,steps,side,bmode)

    --DEFAULT_CHAT_FRAME:AddMessage("ping")

    local r2 = math.sqrt(0.5^2+0.5^2);

    local f = CreateFrame("Frame",nil,UIParent)
    f:SetWidth(texw)
    f:SetHeight(texh)
    f:SetPoint("CENTER",texanchor,"CENTER",0,0)
    f:SetFrameStrata(texstrata)
    f:SetScale(myscale)
    f:Show()
    
    local t = f:CreateTexture(nil,"BACKGROUND")
    t:SetTexture("Interface\\AddOns\\rFrameRotater\\media\\"..tex)
    t:SetAllPoints(f)
    t:SetVertexColor(texr,texg,texb,texalpha)
    if bmode == 1 then
      t:SetBlendMode("add")
    end
    
    local totalElapsed = 0
    local degrees
    if side == 1 then
      degrees = 0
    else 
      degrees = 360
    end
      
    local update_timer = timer
    local delaymultiplicator = 1
    local starttime = GetTime()
    
    local function OnUpdateFunc(self, elapsed)
      totalElapsed = totalElapsed + elapsed
      if (totalElapsed < update_timer) then 
        return 
      else
        local timenow = GetTime()
        totalElapsed = 0
        if (timenow > (starttime+update_timer*delaymultiplicator)) then
          starttime = timenow
          if side == 1 then
            t:SetTexCoord(
            0.5+r2*cos(degrees+135), 0.5+r2*sin(degrees+135),
            0.5+r2*cos(degrees-135), 0.5+r2*sin(degrees-135),
            0.5+r2*cos(degrees+45), 0.5+r2*sin(degrees+45),
            0.5+r2*cos(degrees-45), 0.5+r2*sin(degrees-45)
            ) 
            degrees = degrees+steps
            if degrees > 360 then
              degrees = 0
            end
          else
            t:SetTexCoord(
            0.5+r2*cos(degrees+45), 0.5+r2*sin(degrees+45),
            0.5+r2*cos(degrees+135), 0.5+r2*sin(degrees+135),
            0.5+r2*cos(degrees-45), 0.5+r2*sin(degrees-45),            
            0.5+r2*cos(degrees-135), 0.5+r2*sin(degrees-135)
            )
            degrees = degrees-steps
            if degrees < 0 then
              degrees = 360
            end
          end
        end
      end
    end    
    f:SetScript("OnUpdate", OnUpdateFunc)
  end