
-- rChat: core
-- zork, 2016

-----------------------------
-- Variables
-----------------------------

local A, L = ...

local DefaultSetItemRef, DefaultChatFrame_OnHyperlinkShow = SetItemRef, ChatFrame_OnHyperlinkShow

-----------------------------
-- Functions
-----------------------------

--SkinChat
local function SkinChat(self)
  if not self then return end
  local name = self:GetName()
  --chat frame resizing
  self:SetClampRectInsets(0, 0, 0, 0)
  self:SetMaxResize(UIParent:GetWidth()/2, UIParent:GetHeight()/2)
  self:SetMinResize(100, 50)
  self:SetShadowOffset(1,-2)
  self:SetShadowColor(0,0,0,0.9)
  --chat fading
  self:SetFading(false)
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
  if name == "ChatFrame2" then
    eb:SetPoint("BOTTOM",self,"TOP",0,22+24) --CombatLogQuickButtonFrame_Custom:GetHeight()
  else
    eb:SetPoint("BOTTOM",self,"TOP",0,22)
  end
  eb:SetPoint("LEFT",self,-5,0)
  eb:SetPoint("RIGHT",self,10,0)
end

--OnMOuseScroll
local function OnMOuseScroll(self,dir)
  if(dir > 0) then
    if(IsShiftKeyDown()) then self:ScrollToTop() else self:ScrollUp() end
  else
    if(IsShiftKeyDown()) then self:ScrollToBottom() else self:ScrollDown() end
  end
end

--AltInvite
local function AltInvite(link, text, button)
  local linkType = string.sub(link, 1, 6)
  if IsAltKeyDown() and linkType == "player" then
    local name = string.match(link, "player:([^:]+)")
    InviteUnit(name)
    return nil
  end
  return DefaultSetItemRef(link,text,button)
end

--ChannelReplace
local function ChannelReplace(self, text, ...)
  return self.DefaultAddMessage(self, text:gsub('|h%[(%d+)%. .-%]|h', '|h%1|h'), ...)
end

--URL copy
local function UrlCopy(frame, link, text, button)
  local type, value = link:match("(%a+):(.+)")
  print(type,value)
  if (type == "url") then
    local eb = LAST_ACTIVE_CHAT_EDIT_BOX or _G[frame:GetName().."EditBox"]
    if eb then
      eb:SetText(value)
      eb:SetFocus()
      eb:HighlightText()
    end
  else
    DefaultChatFrame_OnHyperlinkShow(self, link, text, button)
  end
end

-----------------------------
-- Stuff
-----------------------------

--editbox font
ChatFontNormal:SetFont(STANDARD_TEXT_FONT, 12.5)
ChatFontNormal:SetShadowOffset(1,-2)
ChatFontNormal:SetShadowColor(0,0,0,0.9)

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
CHAT_WHISPER_GET              = "<< %s "
CHAT_WHISPER_INFORM_GET       = ">> %s "
CHAT_BN_WHISPER_GET           = "<< %s "
CHAT_BN_WHISPER_INFORM_GET    = ">> %s "
CHAT_YELL_GET                 = "%s "
CHAT_SAY_GET                  = "%s "
CHAT_BATTLEGROUND_GET         = "|Hchannel:Battleground|hBG.|h %s: "
CHAT_BATTLEGROUND_LEADER_GET  = "|Hchannel:Battleground|hBGL.|h %s: "
CHAT_GUILD_GET                = "|Hchannel:Guild|hG.|h %s: "
CHAT_OFFICER_GET              = "|Hchannel:Officer|hGO.|h %s: "
CHAT_PARTY_GET                = "|Hchannel:Party|hP.|h %s: "
CHAT_PARTY_LEADER_GET         = "|Hchannel:Party|hPL.|h %s: "
CHAT_PARTY_GUIDE_GET          = "|Hchannel:Party|hPG.|h %s: "
CHAT_RAID_GET                 = "|Hchannel:Raid|hR.|h %s: "
CHAT_RAID_LEADER_GET          = "|Hchannel:Raid|hRL.|h %s: "
CHAT_RAID_WARNING_GET         = "|Hchannel:RaidWarning|hRW.|h %s: "
CHAT_INSTANCE_CHAT_GET        = "|Hchannel:Battleground|hI.|h %s: "
CHAT_INSTANCE_CHAT_LEADER_GET = "|Hchannel:Battleground|hIL.|h %s: "
--CHAT_MONSTER_PARTY_GET       = CHAT_PARTY_GET
--CHAT_MONSTER_SAY_GET         = CHAT_SAY_GET
--CHAT_MONSTER_WHISPER_GET     = CHAT_WHISPER_GET
--CHAT_MONSTER_YELL_GET        = CHAT_YELL_GET
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
  local chatframe = _G["ChatFrame"..i]
  SkinChat(chatframe)
  --adjust channel display
  if (i ~= 2) then
    chatframe.DefaultAddMessage = chatframe.AddMessage
    chatframe.AddMessage = ChannelReplace
  end
end

--scroll
FloatingChatFrame_OnMouseScroll = OnMOuseScroll

--altinvite
SetItemRef = AltInvite

--url copy
ChatFrame_OnHyperlinkShow = UrlCopy