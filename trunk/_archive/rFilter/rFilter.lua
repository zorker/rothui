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
      ["Fluch der Tollkühnheit"] = {},
      ["Skorpidstich"] = {},
      ["Fluch der Sprachen"] = {},
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
      ["Berserkerwut"] = {},
      ["Zauberreflexion"] = {},
    },
  }
  
  addon:SetScript("OnEvent", function()
  
    if(event=="PLAYER_LOGIN") then
      addon:rf_create_tc_bar()
      addon:rf_create_rz_bar()
      addon:rf_create_ds_bar()
      addon:rf_create_bs_bar()
      addon:rf_create_cs_bar()
      addon:rf_createbufframe()
      addon:rf_createdebufframe()
    end  

    if(event=="PLAYER_REGEN_ENABLED") then
      addon:rf_hidebufframe()
      addon:rf_hidedebufframe()
    end  
    
    if(event=="PLAYER_REGEN_DISABLED") then
      addon:rf_showbufframe()
      addon:rf_showdebufframe()
    end  
  
    if (event=="UNIT_AURA" and arg1=="target") then
      addon:rf_checktargetdebuffs()
      addon:rf_checkplayerbuffs()
    end
    
    if (event=="PLAYER_TARGET_CHANGED") then
      addon:rf_checktargetdebuffs()
      addon:rf_checkplayerbuffs()
    end
  
    if(event=="PLAYER_AURAS_CHANGED") then
      addon:rf_checktargetdebuffs()
      addon:rf_checkplayerbuffs()
    end
  end)
  
  
  function addon:rf_createbufframe()
    local f = CreateFrame("Frame","rf_bf",UIParent)
    f:SetFrameStrata("BACKGROUND")
    f:SetWidth(40)
    f:SetHeight(60)
    
    --[[
    f:SetBackdrop({
      bgFile = "Interface/Tooltips/UI-Tooltip-Background", 
      edgeFile = "", 
      tile = true, tileSize = 16, edgeSize = 16, 
      insets = { left = 0, right = 0, top = 0, bottom = 0 }
    })
    
    f:SetBackdropColor(0,0,0,0.5)
    ]]--
    f:ClearAllPoints()  
    f:SetPoint("TOPLEFT",rUnits_Player,"BOTTOMLEFT",5,-8)
    f:Hide()
    
    --[[
    local rf_bft0 = f:CreateFontString("rf_bft0", "OVERLAY")
    rf_bft0:SetPoint("TOPLEFT", 5, -5)
    rf_bft0:SetFontObject(GameFontHighlight)
    rf_bft0:SetTextColor(1, 1, 1)
    rf_bft0:SetText("Buffs:")
    rf_bft0:Show()
    ]]--
  
    local rf_bft1 = f:CreateFontString("rf_bft1", "OVERLAY")
    rf_bft1:SetPoint("LEFT", "rf_cs_bar", "RIGHT", 5, 0)
    rf_bft1:SetFontObject(GameFontHighlight)
    rf_bft1:SetTextColor(0.5, 0.5, 0.5)
    rf_bft1:SetText("CS")
    rf_bft1:Show()
    
    local rf_bft2 = f:CreateFontString("rf_bft2", "OVERLAY")
    --rf_bft2:SetPoint("LEFT", "rf_bft1", "RIGHT", 10, 0)
    rf_bft2:SetPoint("LEFT", "rf_bs_bar", "RIGHT", 5, 0)
    rf_bft2:SetFontObject(GameFontHighlight)
    rf_bft2:SetTextColor(0.5, 0.5, 0.5)
    rf_bft2:SetText("BS")
    rf_bft2:Show()
    
  end
  
  function addon:rf_createdebufframe()
    local f = CreateFrame("Frame","rf_df",UIParent)
    f:SetFrameStrata("BACKGROUND")
    f:SetWidth(60)
    f:SetHeight(20)
    --[[
    f:SetBackdrop({
      bgFile = "Interface/Tooltips/UI-Tooltip-Background", 
      edgeFile = "", 
      tile = true, tileSize = 16, edgeSize = 16, 
      insets = { left = 0, right = 0, top = 0, bottom = 0 }
    })
    f:SetBackdropColor(0,0,0,0.5)
    ]]--
    f:ClearAllPoints()  
    f:SetPoint("BOTTOMLEFT","rf_rz_bar","TOPLEFT",0,5)
    f:Hide()
    
    --[[
    local rf_dft0 = f:CreateFontString("rf_dft0", "OVERLAY")
    rf_dft0:SetPoint("TOPRIGHT", -5, -5)
    rf_dft0:SetFontObject(GameFontHighlight)
    rf_dft0:SetTextColor(1, 1, 1)
    rf_dft0:SetText("Debuffs:")
    rf_dft0:Show()
    ]]--
  
    local rf_dft1 = f:CreateFontString("rf_dft1", "OVERLAY")
    --rf_dft1:SetPoint("TOPRIGHT", "rf_dft0", "BOTTOMRIGHT", 0, -2)
    --rf_dft1:SetPoint("TOPRIGHT", 0, -0)
    rf_dft1:SetPoint("LEFT", "rf_rz_bar", "RIGHT", 5, 0)
    rf_dft1:SetFontObject(GameFontHighlight)
    rf_dft1:SetTextColor(0.5, 0.5, 0.5)
    rf_dft1:SetText("RZ")
    rf_dft1:Show()
    
    local rf_dft2 = f:CreateFontString("rf_dft2", "OVERLAY")
    --rf_dft2:SetPoint("TOP", "rf_dft1", "BOTTOM", 0, 0)
    rf_dft2:SetPoint("LEFT", "rf_ds_bar", "RIGHT", 5, 0)
    rf_dft2:SetFontObject(GameFontHighlight)
    rf_dft2:SetTextColor(0.5, 0.5, 0.5)
    rf_dft2:SetText("DS")
    rf_dft2:Show()
    
    local rf_dft3 = f:CreateFontString("rf_dft3", "OVERLAY")
    rf_dft3:SetPoint("LEFT", "rf_tc_bar", "RIGHT", 5, 0)
    rf_dft3:SetFontObject(GameFontHighlight)
    rf_dft3:SetTextColor(0.5, 0.5, 0.5)
    rf_dft3:SetText("TC")
    rf_dft3:Show()
    
    
    local rf_dft4 = f:CreateFontString("rf_dft4", "OVERLAY")
    rf_dft4:SetPoint("BOTTOMLEFT")
    rf_dft4:SetFontObject(GameFontHighlight)
    rf_dft4:SetTextColor(0.5, 0.5, 0.5)
    rf_dft4:SetText("SK")
    rf_dft4:Show()
    
    local rf_dft5 = f:CreateFontString("rf_dft5", "OVERLAY")
    rf_dft5:SetPoint("LEFT", "rf_dft4", "RIGHT", 10, 0)
    rf_dft5:SetFontObject(GameFontHighlight)
    rf_dft5:SetTextColor(0.5, 0.5, 0.5)
    rf_dft5:SetText("FdS")
    rf_dft5:Show()
    
    local rf_dft6 = f:CreateFontString("rf_dft6", "OVERLAY")
    rf_dft6:SetPoint("LEFT", "rf_dft5", "RIGHT", 10, 0)
    rf_dft6:SetFontObject(GameFontHighlight)
    rf_dft6:SetTextColor(0.5, 0.5, 0.5)
    rf_dft6:SetText("FdT")
    rf_dft6:Show()
    
  end
  
  function addon:rf_create_tc_bar()
  
    local tex = "Interface\\AddOns\\rTextures\\statusbar"
  
  	local f = CreateFrame("Frame","rf_tc_bar",UIParent);
  	f:SetWidth(100);
  	f:SetHeight(8);
  	f:SetBackdrop({ bgFile = "Interface\\Tooltips\\UI-Tooltip-Background", insets = { left = -1, right = -1, top = -1, bottom = -1 } });
  	f:EnableMouse(0);
  	f:SetToplevel(1);
    f:ClearAllPoints()  
    f:SetPoint("BOTTOMLEFT",ActionButton7,"TOPLEFT",0,20)
  	f:Hide();
  	
  	f.status = CreateFrame("StatusBar","rf_tc_status",f);
  	f.status:SetPoint("TOPLEFT");
  	f.status:SetPoint("BOTTOMRIGHT");
  	--f.status:SetWidth(100)
	  --f.status:SetHeight(10)
  	--f.status:SetPoint("LEFT", f, "LEFT")
  	f.status:SetStatusBarColor(0.5,0.75,1,1);
  
  	f.texture = f.status:CreateTexture("rf_tc_texture");
  	--f.texture:SetPoint("TOPLEFT");
  	--f.texture:SetPoint("BOTTOMRIGHT");
  	f.texture:SetWidth(0)
	  f.texture:SetHeight(8)
  	f.texture:SetPoint("LEFT", f, "LEFT")
  	
  	f.texture:SetTexture(tex);
  	f.texture:SetVertexColor(0.5,0.75,1,1);
  
  	f.status:SetStatusBarTexture(f.texture);
  
  	f.background = f.status:CreateTexture(nil,"BACKGROUND");
  	f.background:SetTexture(tex);
  	f.background:SetBlendMode("BLEND");
  	f.background:SetVertexColor(1,1,1,0.3);
  	f.background:SetPoint("TOPLEFT");
  	f.background:SetPoint("BOTTOMRIGHT");
  	
  end

  
  function addon:rf_create_ds_bar()
  
    local tex = "Interface\\AddOns\\rTextures\\statusbar"
  
  	local f = CreateFrame("Frame","rf_ds_bar",UIParent);
  	f:SetWidth(100);
  	f:SetHeight(8);
  	f:SetBackdrop({ bgFile = "Interface\\Tooltips\\UI-Tooltip-Background", insets = { left = -1, right = -1, top = -1, bottom = -1 } });
  	f:EnableMouse(0);
  	f:SetToplevel(1);
    f:ClearAllPoints()  
    f:SetPoint("BOTTOMLEFT",rf_tc_bar,"TOPLEFT",0,5)
  	f:Hide();
  	
  	f.status = CreateFrame("StatusBar","rf_ds_status",f);
  	f.status:SetPoint("TOPLEFT");
  	f.status:SetPoint("BOTTOMRIGHT");
  	--f.status:SetWidth(100)
	  --f.status:SetHeight(10)
  	--f.status:SetPoint("LEFT", f, "LEFT")
  	f.status:SetStatusBarColor(0.5,0.75,1,1);
  
  	f.texture = f.status:CreateTexture("rf_ds_texture");
  	--f.texture:SetPoint("TOPLEFT");
  	--f.texture:SetPoint("BOTTOMRIGHT");
  	f.texture:SetWidth(0)
	  f.texture:SetHeight(8)
  	f.texture:SetPoint("LEFT", f, "LEFT")
  	
  	f.texture:SetTexture(tex);
  	f.texture:SetVertexColor(0.5,0.75,1,1);
  
  	f.status:SetStatusBarTexture(f.texture);
  
  	f.background = f.status:CreateTexture(nil,"BACKGROUND");
  	f.background:SetTexture(tex);
  	f.background:SetBlendMode("BLEND");
  	f.background:SetVertexColor(1,1,1,0.3);
  	f.background:SetPoint("TOPLEFT");
  	f.background:SetPoint("BOTTOMRIGHT");
  
  end
  
  function addon:rf_create_rz_bar()
  
    local tex = "Interface\\AddOns\\rTextures\\statusbar"
  
  	local f = CreateFrame("Frame","rf_rz_bar",UIParent);
  	f:SetWidth(100);
  	f:SetHeight(8);
  	f:SetBackdrop({ bgFile = "Interface\\Tooltips\\UI-Tooltip-Background", insets = { left = -1, right = -1, top = -1, bottom = -1 } });
  	f:EnableMouse(0);
  	f:SetToplevel(1);
    f:ClearAllPoints()  
    f:SetPoint("BOTTOMLEFT",rf_tc_bar,"TOPLEFT",0,18)
  	f:Hide();
  	
  	f.status = CreateFrame("StatusBar","rf_rz_status",f);
  	f.status:SetPoint("TOPLEFT");
  	f.status:SetPoint("BOTTOMRIGHT");
  	--f.status:SetWidth(100)
	  --f.status:SetHeight(10)
  	--f.status:SetPoint("LEFT", f, "LEFT")
  	f.status:SetStatusBarColor(0.5,0.75,1,1);
  
  	f.texture = f.status:CreateTexture("rf_rz_texture");
  	--f.texture:SetPoint("TOPLEFT");
  	--f.texture:SetPoint("BOTTOMRIGHT");
  	f.texture:SetWidth(0)
	  f.texture:SetHeight(8)
  	f.texture:SetPoint("LEFT", f, "LEFT")
  	
  	f.texture:SetTexture(tex);
  	f.texture:SetVertexColor(0.5,0.75,1,1);
  
  	f.status:SetStatusBarTexture(f.texture);
  
  	f.background = f.status:CreateTexture(nil,"BACKGROUND");
  	f.background:SetTexture(tex);
  	f.background:SetBlendMode("BLEND");
  	f.background:SetVertexColor(1,1,1,0.3);
  	f.background:SetPoint("TOPLEFT");
  	f.background:SetPoint("BOTTOMRIGHT");
  
  end
  
  function addon:rf_create_bs_bar()
  
    local tex = "Interface\\AddOns\\rTextures\\statusbar"
  
  	local f = CreateFrame("Frame","rf_bs_bar",UIParent);
  	f:SetWidth(100);
  	f:SetHeight(8);
  	f:SetBackdrop({ bgFile = "Interface\\Tooltips\\UI-Tooltip-Background", insets = { left = -1, right = -1, top = -1, bottom = -1 } });
  	f:EnableMouse(0);
  	f:SetToplevel(1);
    f:ClearAllPoints()  
    f:SetPoint("BOTTOMLEFT",MultiBarBottomLeftButton7,"TOPLEFT",0,20)
  	f:Hide();
  	
  	f.status = CreateFrame("StatusBar","rf_bs_status",f);
  	f.status:SetPoint("TOPLEFT");
  	f.status:SetPoint("BOTTOMRIGHT");
  	--f.status:SetWidth(100)
	  --f.status:SetHeight(10)
  	--f.status:SetPoint("LEFT", f, "LEFT")
  	f.status:SetStatusBarColor(0.5,0.75,1,1);
  
  	f.texture = f.status:CreateTexture("rf_bs_texture");
  	--f.texture:SetPoint("TOPLEFT");
  	--f.texture:SetPoint("BOTTOMRIGHT");
  	f.texture:SetWidth(0)
	  f.texture:SetHeight(8)
  	f.texture:SetPoint("LEFT", f, "LEFT")
  	
  	f.texture:SetTexture(tex);
  	f.texture:SetVertexColor(0.8,0.8,0.3,1);
  
  	f.status:SetStatusBarTexture(f.texture);
  
  	f.background = f.status:CreateTexture(nil,"BACKGROUND");
  	f.background:SetTexture(tex);
  	f.background:SetBlendMode("BLEND");
  	f.background:SetVertexColor(1,1,1,0.3);
  	f.background:SetPoint("TOPLEFT");
  	f.background:SetPoint("BOTTOMRIGHT");
  	
  end
  
  
  function addon:rf_create_cs_bar()
  
    local tex = "Interface\\AddOns\\rTextures\\statusbar"
  
  	local f = CreateFrame("Frame","rf_cs_bar",UIParent);
  	f:SetWidth(100);
  	f:SetHeight(8);
  	f:SetBackdrop({ bgFile = "Interface\\Tooltips\\UI-Tooltip-Background", insets = { left = -1, right = -1, top = -1, bottom = -1 } });
  	f:EnableMouse(0);
  	f:SetToplevel(1);
    f:ClearAllPoints()  
    f:SetPoint("BOTTOMLEFT",rf_bs_bar,"TOPLEFT",0,5)
  	f:Hide();
  	
  	f.status = CreateFrame("StatusBar","rf_cs_status",f);
  	f.status:SetPoint("TOPLEFT");
  	f.status:SetPoint("BOTTOMRIGHT");
  	--f.status:SetWidth(100)
	  --f.status:SetHeight(10)
  	--f.status:SetPoint("LEFT", f, "LEFT")
  	f.status:SetStatusBarColor(0.5,0.75,1,1);
  
  	f.texture = f.status:CreateTexture("rf_cs_texture");
  	--f.texture:SetPoint("TOPLEFT");
  	--f.texture:SetPoint("BOTTOMRIGHT");
  	f.texture:SetWidth(0)
	  f.texture:SetHeight(8)
  	f.texture:SetPoint("LEFT", f, "LEFT")
  	
  	f.texture:SetTexture(tex);
  	f.texture:SetVertexColor(0.8,0.8,0.3,1);
  
  	f.status:SetStatusBarTexture(f.texture);
  
  	f.background = f.status:CreateTexture(nil,"BACKGROUND");
  	f.background:SetTexture(tex);
  	f.background:SetBlendMode("BLEND");
  	f.background:SetVertexColor(1,1,1,0.3);
  	f.background:SetPoint("TOPLEFT");
  	f.background:SetPoint("BOTTOMRIGHT");
  
  end
  
  
  function addon:rf_showbufframe()
    local f = _G["rf_bf"]
    f:Show()
    
    rf_bs_bar:Show()
    rf_cs_bar:Show()
    
  end
  
  
  function addon:rf_hidebufframe()
    local f = _G["rf_bf"]
    f:Hide()  
    
    rf_bs_bar:Hide()
    rf_cs_bar:Hide()
    
  end
  
  function addon:rf_showdebufframe()
    local f = _G["rf_df"]
    f:Show()
    
    rf_rz_bar:Show()
    rf_tc_bar:Show()
    rf_ds_bar:Show()
    
  end
  
  
  function addon:rf_hidedebufframe()
    local f = _G["rf_df"]
    f:Hide()  
    
    rf_rz_bar:Hide()
    rf_tc_bar:Hide()
    rf_ds_bar:Hide()
    
  end
  
  function addon:rf_checkplayerbuffs()
  
    local name, index, untilcancelled, timeleft
    local found_bft1 = 0
    local found_bft2 = 0
    local time_bft1 = 0
    local time_bft2 = 0
    local timebar_bft1 = 0
    local timebar_bft2 = 0
  
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
          time_bft1 = floor(timeleft)
          timebar_bft1 = floor(timeleft*100/120)
        end
        if name == "Schlachtruf" then
          found_bft2 = 1
          time_bft2 = floor(timeleft)
          timebar_bft2 = floor(timeleft*100/120)
        end
      end
      
    end
    
    rf_cs_texture:SetWidth(0.001)
    rf_bs_texture:SetWidth(0.001)
    
    if found_bft1 == 1 then
      rf_bft1:SetText("CS |cffffff55"..time_bft1)
      rf_bft1:SetTextColor(0, 1, 0)
      rf_cs_texture:SetWidth(timebar_bft1)
    else
      rf_bft1:SetText("CS")
      rf_bft1:SetTextColor(0.5, 0.5, 0.5)
    end

    if found_bft2 == 1 then
      rf_bft2:SetText("BS |cffffff55"..time_bft2)
      rf_bft2:SetTextColor(0, 1, 0)
      rf_bs_texture:SetWidth(timebar_bft2)
    else
      rf_bft2:SetText("BS")
      rf_bft2:SetTextColor(0.5, 0.5, 0.5)
    end

  end
  
  function addon:rf_checktargetdebuffs()
  
    local name, texture, applications, debufftype, duration, timeleft
    local found_dft1 = 0
    local found_dft2 = 0
    local found_dft3 = 0
    local found_dft4 = 0
    local found_dft5 = 0
    local found_dft6 = 0
    local rz_apps = 0
    local time_dft1 = 0
    local time_dft2 = 0
    local time_dft3 = 0
    local timebar_dft1 = 0
    local timebar_dft2 = 0
    local timebar_dft3 = 0

  
    for i = 1, 40 do
      name, _, texture, applications, debufftype, duration, timeleft = UnitDebuff("target", i)
      
      --[[
      if applications then
        DEFAULT_CHAT_FRAME:AddMessage(name.." "..applications)
      else
        DEFAULT_CHAT_FRAME:AddMessage(name)
      end
      ]]--
      
      if (not texture) then
        break
      end
      if (rf_settings.td_list[name]) then
      
        if name == "Rüstung zerreißen" then
          found_dft1 = 1
          rz_apps = applications
          if timeleft ~= nil then
            time_dft1 = floor(timeleft)
            timebar_dft1 = floor(timeleft*100/duration)
          end
        end
        if name == "Demoralisierender Ruf" then
          found_dft2 = 1
          if timeleft ~= nil then
            time_dft2 = floor(timeleft)
            timebar_dft2 = floor(timeleft*100/duration)
          end
        end
        if name == "Donnerknall" then
          found_dft3 = 1
          if timeleft ~= nil then
            time_dft3 = floor(timeleft)
            timebar_dft3 = floor(timeleft*100/duration)
          end
        end
        if name == "Skorpidstich" then
          found_dft4 = 1
        end
        if name == "Fluch der Schwäche" then
          found_dft5 = 1
        end
        if name == "Fluch der Tollkühnheit" then
          found_dft6 = 1
        end
      end
    end
    
    rf_rz_texture:SetWidth(0.001)
    rf_ds_texture:SetWidth(0.001)
    rf_tc_texture:SetWidth(0.001)
    
    if found_dft1 == 1 then
      if time_dft1 >= 1 then
        rf_dft1:SetText("RZ |cffffffff("..rz_apps..") |cffffff55"..time_dft1)
        rf_rz_texture:SetWidth(timebar_dft1)
      else
        rf_dft1:SetText("RZ |cffffffff("..rz_apps..")")
      end
      rf_dft1:SetTextColor(0, 1, 0)
    else
      rf_dft1:SetText("RZ")
      rf_dft1:SetTextColor(0.5, 0.5, 0.5)
    end

    if found_dft2 == 1 then
      if time_dft2 >= 1 then
        rf_dft2:SetText("DS |cffffff55"..time_dft2)
        rf_ds_texture:SetWidth(timebar_dft2)
      else
        rf_dft2:SetText("DS")
      end
      rf_dft2:SetTextColor(0, 1, 0)
    else
      rf_dft2:SetText("DS")
      rf_dft2:SetTextColor(0.5, 0.5, 0.5)
    end
  
    if found_dft3 == 1 then
      if time_dft3 >= 1 then
        rf_dft3:SetText("TC |cffffff55"..time_dft3)
        rf_tc_texture:SetWidth(timebar_dft3)
      else
        rf_dft3:SetText("TC")
      end
      rf_dft3:SetTextColor(0, 1, 0)
    else
      rf_dft3:SetText("TC")
      rf_dft3:SetTextColor(0.5, 0.5, 0.5)
    end

    if found_dft4 == 1 then
      rf_dft4:SetTextColor(0, 1, 0)
    else
      rf_dft4:SetTextColor(0.5, 0.5, 0.5)
    end
    
    if found_dft5 == 1 then
      rf_dft5:SetTextColor(0, 1, 0)
    else
      rf_dft5:SetTextColor(0.5, 0.5, 0.5)
    end
    
    if found_dft6 == 1 then
      rf_dft6:SetTextColor(0, 1, 0)
    else
      rf_dft6:SetTextColor(0.5, 0.5, 0.5)
    end  
  end
  
  
  addon:RegisterEvent"PLAYER_AURAS_CHANGED"
  addon:RegisterEvent"PLAYER_LOGIN"
  addon:RegisterEvent"PLAYER_REGEN_DISABLED"
  addon:RegisterEvent"PLAYER_REGEN_ENABLED"
  addon:RegisterEvent"PLAYER_TARGET_CHANGED"
  addon:RegisterEvent"UNIT_AURA"