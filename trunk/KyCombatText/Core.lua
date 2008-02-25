--[[-------------------------------------------------------------------------
  Copyright (c) 2007, Kyahx
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
      * Neither the name of this AddOn nor the names of its contributors
        may be used to endorse or promote products derived from this
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
    SlashCmdList['RELOADUI'] = function() ReloadUI() end
    SLASH_RELOADUI1 = '/rl'
---------------------------------------------------------------------------]]

assert(IsAddOnLoaded("Blizzard_CombatText"), "Blizzard CombatText did not load first!")
KCT = DongleStub("Dongle-1.0"):New("KCT")

local _G = getfenv(0)
local orig = {}
local msgType

function KCT:Enable()
    KCT:ApplyOverrides()
  
    orig.CombatText_AddMessage = CombatText_AddMessage
    orig.CombatText_OnEvent = CombatText_OnEvent

    function CombatText_OnEvent(event)
    	if event == "UNIT_HEALTH" then
    		msgType = "HEALTH_LOW"
    	elseif event == "UNIT_MANA" then
    		msgType = "MANA_LOW"
    	elseif event == "PLAYER_REGEN_DISABLED" then
    		msgType = "ENTERING_COMBAT"
    	elseif event == "PLAYER_REGEN_ENABLED" then
    		msgType = "LEAVING_COMBAT"
    	elseif event == "PLAYER_COMBO_POINTS" then
    		msgType = "COMBO_POINTS"
    	elseif event == "COMBAT_TEXT_UPDATE" then
    		msgType = arg1
    	else
    		msgType = event
    	end
    	
    	orig.CombatText_OnEvent(event)
    end

    function CombatText_AddMessage(msg, ...)
        KCT:Debug(1, msg, msgType)
        
        local msg = KCT:Cutcut(msg, msgType)
        
    	orig.CombatText_AddMessage(msg, ...)
    end
end
