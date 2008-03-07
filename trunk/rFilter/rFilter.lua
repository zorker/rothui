--[[-------------------------------------------------------------------------
  Copyright (c) 2008, zork
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
      * Neither the name of rFilter nor the names of its contributors may
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
  
  local addon = CreateFrame"Frame"
  local _G = getfenv(0)
  
  local rf_settings = {
    td_list = {
      ["Rüstung zerreißen"] = {},
      ["Demoralisierender Ruf"] = {},
      ["Donnerknall"] = {},
      ["Feenfeuer"] = {},
      ["Fluch der Schwäche"] = {},
    },
    tb_list = {
      ["Renew"] = {},
      ["Rejuvenation"] = {},
    },
    pd_list = {
      ["Bloodboil"] = {},
      ["Carrion Swarm"] = {},
    },
    pb_list = {
      ["Schlachtruf"] = {},
      ["Befehlsruf"] = {},
    },
  }
  



  
  addon:SetScript("OnEvent", function()
  
    if(event=="PLAYER_LOGIN") then
      addon:rf_createbufframe()
    end  

    if(event=="PLAYER_REGEN_ENABLED") then
      addon:rf_hidebufframe()
    end  
    
    if(event=="PLAYER_REGEN_DISABLED") then
      addon:rf_showbufframe()
    end  
  
    if(event=="PLAYER_AURAS_CHANGED") then
      addon:rf_checkplayerbuffs()
    end
  end)
  
  
  function addon:rf_createbufframe()
    local f = CreateFrame("Frame","rf_bf",UIParent)
    f:SetFrameStrata("BACKGROUND")
    f:SetWidth(64)
    f:SetHeight(37)
    f:SetBackdrop({
      bgFile = "Interface/Tooltips/UI-Tooltip-Background", 
      edgeFile = "", 
      tile = true, tileSize = 16, edgeSize = 16, 
      insets = { left = 0, right = 0, top = 0, bottom = 0 }
    })
    f:SetBackdropColor(0,0,0,0.8)
    f:SetPoint("CENTER",-167,-280)
    f:Hide()
    
    local rf_bft0 = f:CreateFontString("rf_bft0", "OVERLAY")
    rf_bft0:SetPoint("TOPLEFT", 5, -5)
    rf_bft0:SetFontObject(GameFontHighlight)
    rf_bft0:SetTextColor(1, 1, 1)
    rf_bft0:SetText("Buffs:")
    rf_bft0:Show()
  
    local rf_bft1 = f:CreateFontString("rf_bft1", "OVERLAY")
    rf_bft1:SetPoint("TOPLEFT", "rf_bft0", "BOTTOMLEFT", 0, -2)
    rf_bft1:SetFontObject(GameFontHighlight)
    rf_bft1:SetTextColor(1, 0, 0)
    rf_bft1:SetText("CS")
    rf_bft1:Show()
    
    local rf_bft2 = f:CreateFontString("rf_bft2", "OVERLAY")
    rf_bft2:SetPoint("TOPLEFT", "rf_bft1", "TOPRIGHT", 5, 0)
    rf_bft2:SetFontObject(GameFontHighlight)
    rf_bft2:SetTextColor(1, 0, 0)
    rf_bft2:SetText("BS")
    rf_bft2:Show()
    
  end
  
  function addon:rf_showbufframe()
    local f = _G["rf_bf"]
    f:Show()
  end
  
  
  function addon:rf_hidebufframe()
    local f = _G["rf_bf"]
    f:Hide()  
  end
  
  
  function addon:rf_checkplayerbuffs()
  
    local name, index, untilcancelled, timeleft
    local found_bft1 = 0
    local found_bft2 = 0
  
    for i = 1, 40 do
      index, untilcancelled = GetPlayerBuff(i, "HELPFUL")

      if (index < 1) then
        break
      end
      
      name = GetPlayerBuffName(index)
      --DEFAULT_CHAT_FRAME:AddMessage(name)
      timeleft = GetPlayerBuffTimeLeft(index)
      if (rf_settings.pb_list[name]) then
        if name == "Befehlsruf" then
          found_bft1 = 1
        end
        if name == "Schlachtruf" then
          found_bft2 = 1
        end
      end
      
    end
    
    if found_bft1 == 1 then
      rf_bft1:SetTextColor(0, 1, 0)
    else
      rf_bft1:SetTextColor(1, 0, 0)
    end

    if found_bft2 == 1 then
      rf_bft2:SetTextColor(0, 1, 0)
    else
      rf_bft2:SetTextColor(1, 0, 0)
    end
      
  end
  
  addon:RegisterEvent"PLAYER_AURAS_CHANGED"
  addon:RegisterEvent"PLAYER_LOGIN"
  addon:RegisterEvent"PLAYER_REGEN_DISABLED";
  addon:RegisterEvent"PLAYER_REGEN_ENABLED";