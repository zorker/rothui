
-- rChat: core
-- zork, 2016

-----------------------------
-- Variables
-----------------------------

local A, L = ...

-----------------------------
-- Functions
-----------------------------

--found this nice function, may need it sometime
--ChatEdit_FocusActiveWindow

local function SkinChat(self)
  if not self then return end
  local name = self:GetName()
  --chat frame resizing
  self:SetClampRectInsets(0, 0, 0, 0)
  self:SetMaxResize(UIParent:GetWidth()/2, UIParent:GetHeight()/2)
  self:SetMinResize(100, 50)
  --chat fading
  --self:SetFading(false)
  --hide button frame
  local bf = _G[name.."ButtonFrame"]
  bf:HookScript("OnShow", bf.Hide)
  bf:Hide()
  --editbox
  local eb = _G[name.."EditBox"]
  eb:SetAltArrowKeyMode(false)
  --textures
  _G[name.."EditBoxLeft"]:Hide()
  _G[name.."EditBoxMid"]:Hide()
  _G[name.."EditBoxRight"]:Hide()
  --reposition
  eb:ClearAllPoints()
  eb:SetPoint("BOTTOM",self,"TOP",0,22)
  eb:SetPoint("LEFT",self,-5,0)
  eb:SetPoint("RIGHT",self,10,0)
end

local function OnMOuseScroll(self,dir)
  if(dir > 0) then
    if(IsShiftKeyDown()) then self:ScrollToTop() else self:ScrollUp() end
  else
    if(IsShiftKeyDown()) then self:ScrollToBottom() else self:ScrollDown() end
  end
end

-----------------------------
-- Stuff
-----------------------------

--editbox font
ChatFontNormal:SetFont(STANDARD_TEXT_FONT, 13)

--font size
CHAT_FONT_HEIGHTS = {10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20}

--tabs
CHAT_TAB_HIDE_DELAY = 1
CHAT_FRAME_TAB_NORMAL_MOUSEOVER_ALPHA = 1
CHAT_FRAME_TAB_NORMAL_NOMOUSE_ALPHA = 0
CHAT_FRAME_TAB_SELECTED_MOUSEOVER_ALPHA = 1
CHAT_FRAME_TAB_SELECTED_NOMOUSE_ALPHA = 0
CHAT_FRAME_TAB_ALERTING_MOUSEOVER_ALPHA = 1
CHAT_FRAME_TAB_ALERTING_NOMOUSE_ALPHA = 1

--channels
CHAT_WHISPER_GET 				      = "Von %s "
CHAT_WHISPER_INFORM_GET 		  = "An %s "
CHAT_YELL_GET 					      = "%s "
CHAT_SAY_GET 					        = "%s "
CHAT_BATTLEGROUND_GET			    = "|Hchannel:Battleground|hBG.|h %s: "
CHAT_BATTLEGROUND_LEADER_GET 	= "|Hchannel:Battleground|hBGL.|h %s: "
CHAT_GUILD_GET   				      = "|Hchannel:Guild|hG.|h %s: "
CHAT_OFFICER_GET 				      = "|Hchannel:Officer|hGO.|h %s: "
CHAT_PARTY_GET        			  = "|Hchannel:Party|hP.|h %s: "
CHAT_PARTY_LEADER_GET 			  = "|Hchannel:Party|hPL.|h %s: "
CHAT_PARTY_GUIDE_GET  			  = "|Hchannel:Party|hPG.|h %s: "
CHAT_RAID_GET         			  = "|Hchannel:Raid|hR.|h %s: "
CHAT_RAID_LEADER_GET  			  = "|Hchannel:Raid|hRL.|h %s: "
CHAT_RAID_WARNING_GET 			  = "|Hchannel:RaidWarning|hRW.|h %s: "
CHAT_INSTANCE_CHAT_GET        = "|Hchannel:Battleground|hI.|h %s: "
CHAT_INSTANCE_CHAT_LEADER_GET = "|Hchannel:Battleground|hIL.|h %s: "
--CHAT_MONSTER_PARTY_GET   		= CHAT_PARTY_GET
--CHAT_MONSTER_SAY_GET     		= CHAT_SAY_GET
--CHAT_MONSTER_WHISPER_GET 		= CHAT_WHISPER_GET
--CHAT_MONSTER_YELL_GET    		= CHAT_YELL_GET
CHAT_FLAG_AFK = "<AFK> "
CHAT_FLAG_DND = "<DND> "
CHAT_FLAG_GM = "<[GM]> "

--remove the annoying guild loot messages by replacing them with the original ones
YOU_LOOT_MONEY_GUILD = YOU_LOOT_MONEY
LOOT_MONEY_SPLIT_GUILD = LOOT_MONEY_SPLIT

--don't cut the toastframe
BNToastFrame:SetClampedToScreen(true)
BNToastFrame:SetClampRectInsets(-15,15,15,-15)

--hide the menu button
ChatFrameMenuButton:HookScript("OnShow", ChatFrameMenuButton.Hide)
ChatFrameMenuButton:Hide()

--hide the friend micro button
local button = QuickJoinToastButton or FriendsMicroButton
button:HookScript("OnShow", button.Hide)
button:Hide()

--skin chat
for i = 1, NUM_CHAT_WINDOWS do
  SkinChat(_G["ChatFrame"..i])
end

--scroll
FloatingChatFrame_OnMouseScroll = OnMOuseScroll
