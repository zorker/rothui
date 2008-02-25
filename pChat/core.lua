--[[-------------------------------------------------------------------------
  Copyright (c) 2008, p3lim
  Copyright (c) 2007-2008, Trond A Ekseth
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
      * Neither the name of oChat nor the names of its contributors may
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

local _G = getfenv(0)
local type = type
local _AddMessage = ChatFrame1.AddMessage
local buttons = {"UpButton", "DownButton", "BottomButton"}
local dummy = function() end

_G.CHAT_GUILD_GET = "(G) %s:\32"
_G.CHAT_RAID_GET = "(R) %s:\32"
_G.CHAT_PARTY_GET = "(P) %s:\32"
_G.CHAT_RAID_WARNING_GET = "(W) %s:\32"
_G.CHAT_RAID_LEADER_GET = "(L) %s:\32"
_G.CHAT_OFFICER_GET = "(O) %s:\32"
_G.CHAT_BATTLEGROUND_GET = "(B) %s:\32"
_G.CHAT_BATTLEGROUND_LEADER_GET = "(L) %s:\32"
_G.CHAT_SAY_GET = "%s:\32"
_G.CHAT_YELL_GET = "%s:\32"
_G.CHAT_WHISPER_GET = "%s:\32"
_G.CHAT_WHISPER_INFORM_GET = "(T) %s:\32"
_G.CHAT_FLAG_AFK = "[AFK] "
_G.CHAT_FLAG_DND = "[DND] "
_G.CHAT_FLAG_GM = "[GM] "

local str = "(%d) %3$s"
local channel = function(...)
	return str:format(...)
end

local AddMessage = function(self, text,...)
	if(type(text) == "string") then
		text = text:gsub("|Hplayer:([^:]+):(%d+)|h%[(.-)%]|h", "|Hplayer:%1:%2|h%3|h")
		text = text:gsub("%[(%d+)%. (.+)%].+(|Hplayer.+)", channel)
	end

	return _AddMessage(self, text, ...)
end

local scroll = function(self, dir)
	if(dir > 0) then
		if(IsShiftKeyDown()) then
			self:ScrollToTop()
		elseif(IsControlKeyDown()) then
			self:ScrollUp(); self:ScrollUp(); self:ScrollUp()
		else
			self:ScrollUp()
		end
	elseif(dir < 0) then
		if(IsShiftKeyDown()) then
			self:ScrollToBottom()
		elseif(IsControlKeyDown()) then
			self:ScrollDown(); self:ScrollDown(); self:ScrollDown()
		else
			self:ScrollDown()
		end
	end
end

for i=1, NUM_CHAT_WINDOWS do
	local cf = _G["ChatFrame"..i]
	cf:SetScript("OnMouseWheel", scroll)

	cf:SetFading(false)
	cf:EnableMouseWheel(true)

	for k, button in pairs(buttons) do
		button = _G["ChatFrame"..i..button]
		button:Hide()
		button.Show = dummy
	end

	cf.AddMessage = AddMessage
end

ChatFrameMenuButton:Hide()
ChatFrameMenuButton.Show = dummy

local editbox = ChatFrameEditBox
editbox:ClearAllPoints()
editbox:SetPoint("BOTTOMLEFT",  ChatFrame1, "TOPLEFT", -10, 10)
editbox:SetPoint("BOTTOMRIGHT", ChatFrame1, "TOPRIGHT", 5, 10)
editbox:SetAltArrowKeyMode(false)

local a, b, c = select(6, editbox:GetRegions())
a:Hide(); b:Hide(); c:Hide()

local function tellTarget(s)
	if not UnitExists('target') and UnitName('target') and UnitIsPlayer('target') and GetDefaultLanguage('player') == GetDefaultLanguage('target') or not (s and s:len()>0) then
		return
	end

	local name, realm = UnitName('target')
	if realm and realm ~= GetRealmName() then
		name = ('%s-%s'):format(name, realm)
	end
	SendChatMessage(s, 'WHISPER', nil, name)
end

SlashCmdList['TELLTARGET'] = tellTarget
SLASH_TELLTARGET1 = '/tt'