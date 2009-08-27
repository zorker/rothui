--[[-------------------------------------------------------------------------
  Copyright (c) 2008, p3lim
  Copyright (c) 2008, rothar
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
      * Neither the name of rBuff nor the names of its contributors may
        be used to endorse or promote products derived from this
        software without specific prior written permission.

  THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
  "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
  LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR
  A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT
  OWNER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL,
  SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT
  LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE,
  DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY
  THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
  (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
  OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
---------------------------------------------------------------------------]]

  --rdy up for wotlk

  BUFF_FLASH_TIME_ON = 0.8;
  BUFF_FLASH_TIME_OFF = 0.8;
  BUFF_MIN_ALPHA = 0.70;
  
  local myscale = 0.82
  local d3font = "Interface\\AddOns\\oUF_D3Orbs\\avqest.ttf"
  --local glosstex1 = "Interface\\AddOns\\rTextures\\d3bufficon"
  --local glosstex2 = "Interface\\AddOns\\rTextures\\d3bufficon_white"

  local glosstex1 = "Interface\\AddOns\\rActionButtonStyler\\media\\gloss"
  local glosstex2 = "Interface\\AddOns\\rActionButtonStyler\\media\\gloss_grey"

  local addon = CreateFrame("Frame")
  local _G = getfenv(0)
  
  addon:SetScript("OnEvent", function(self, event, ...)
    local unit = ...;
    if(event=="PLAYER_ENTERING_WORLD") 
    then
      TemporaryEnchantFrame:ClearAllPoints()
      TemporaryEnchantFrame:SetPoint("TOPRIGHT", Minimap, "TOPLEFT", -40, 3)
      TemporaryEnchantFrame:SetScale(myscale)
      BuffFrame:SetScale(myscale)
      addon:runthroughicons()
      
    end
    if ( event == "UNIT_AURA" ) then
      if ( unit == PlayerFrame.unit ) then
        addon:runthroughicons()
      end
    end
  end)
  
  function addon:runthroughicons()
    local i = 1
    while _G["BuffButton"..i] 
    do 
      addon:checkgloss("BuffButton"..i,1) 
      i = i + 1 
    end
    i = 1
    while _G["DebuffButton"..i] 
    do 
      addon:checkgloss("DebuffButton"..i,2) 
      i = i + 1 
    end
    i = 1
    while _G["TempEnchant"..i] 
    do 
      addon:checkgloss("TempEnchant"..i,3) 
      i = i + 1 
    end
  end

  function addon:checkgloss(name,icontype)
    local b = _G[name.."Border"]
    local i = _G[name.."Icon"]
    local f = _G[name]
    local c = _G[name.."Gloss"]
    local ff = _G[name.."Duration"]
    
    ff:SetFont(NAMEPLATE_FONT, 13, "THINOUTLINE")
    ff:ClearAllPoints()
    ff:SetPoint("TOP",f,"BOTTOM",0,0)

    if not c then

      local fg = CreateFrame("Frame", name.."Gloss", f)
      fg:SetAllPoints(f)

      local t = f:CreateTexture(name.."GlossTexture","ARTWORK")
      t:SetTexture(glosstex1)
      t:SetPoint("TOPLEFT", fg, "TOPLEFT", -0, 0)
      t:SetPoint("BOTTOMRIGHT", fg, "BOTTOMRIGHT", 0, -0)
      
      i:SetTexCoord(0.1,0.9,0.1,0.9)
      i:SetPoint("TOPLEFT", fg, "TOPLEFT", 2, -2)
      i:SetPoint("BOTTOMRIGHT", fg, "BOTTOMRIGHT", -2, 2)
      
      local back = f:CreateTexture(nil, "BACKGROUND")
      back:SetPoint("TOPLEFT",i,"TOPLEFT",-5,5)
      back:SetPoint("BOTTOMRIGHT",i,"BOTTOMRIGHT",5,-5)
      back:SetTexture("Interface\\AddOns\\rTextures\\simplesquare_glow")
      back:SetVertexColor(0, 0, 0, 1)
        
    end

    local tex = _G[name.."GlossTexture"]    
    
    if icontype == 2 and b then
      local red,green,blue = b:GetVertexColor();    
      tex:SetTexture(glosstex2)
      tex:SetVertexColor(red*0.5,green*0.5,blue*0.5)
    elseif icontype == 3 and b then
      tex:SetTexture(glosstex2)
      tex:SetVertexColor(0.5,0,0.5)
    else
      tex:SetTexture(glosstex1)
      tex:SetVertexColor(0.47,0.4,0.4)      
    end  
    
    if b then b:SetAlpha(0) end
  
  end

  SecondsToTimeAbbrev = function(time)
    local hr, m, s, text
    if time <= 0 then text = ""
    elseif(time < 3600 and time > 60) then
      hr = floor(time / 3600)
      m = floor(mod(time, 3600) / 60 + 1)
      text = format("%dm", m)
    elseif time < 60 then
      m = floor(time / 60)
      s = mod(time, 60)
      text = (m == 0 and format("%ds", s))
    else
      hr = floor(time / 3600 + 1)
      text = format("%dh", hr)
    end
    return text
  end
  
  addon:RegisterEvent("UNIT_AURA");
  addon:RegisterEvent("PLAYER_ENTERING_WORLD");