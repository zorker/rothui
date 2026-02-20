local addonName, ns = ...

local editBoxFocusAlpha = 1
local editBoxAlpha = 0

--SkinChat
local function SkinChat()
  for i = 1, NUM_CHAT_WINDOWS do
    local chatframe = _G["ChatFrame"..i]
    if not chatframe then return end
    local name = chatframe:GetName()
    _G[name.."ButtonFrame"]:Hide()
    _G[name.."EditBox"]:SetAltArrowKeyMode(false)
    _G[name.."EditBox"]:ClearAllPoints()
    _G[name.."EditBox"]:SetPoint("BOTTOMLEFT",_G[name.."Background"],"TOPLEFT",QuickJoinToastButton:GetWidth(),20)
    _G[name.."EditBox"]:SetPoint("BOTTOMRIGHT",_G[name.."Background"],"TOPRIGHT",0,20)
    _G[name.."EditBoxFocusLeft"]:SetAlpha(editBoxFocusAlpha)
    _G[name.."EditBoxFocusMid"]:SetAlpha(editBoxFocusAlpha)
    _G[name.."EditBoxFocusRight"]:SetAlpha(editBoxFocusAlpha)
    _G[name.."EditBoxLeft"]:SetAlpha(editBoxAlpha)
    _G[name.."EditBoxMid"]:SetAlpha(editBoxAlpha)
    _G[name.."EditBoxRight"]:SetAlpha(editBoxAlpha)
    chatframe:SetClampRectInsets(0,0,0,0)
    hooksecurefunc(chatframe, "SetClampRectInsets", function(self) self:SetClampRectInsets(0,0,0,0) end)
  end
  TextToSpeechButtonFrame:Hide()
  ChatFrame1:ClearAllPoints()
  ChatFrame1:SetPoint("BOTTOMLEFT", 10, 10)
  QuickJoinToastButton:SetClampedToScreen(true)
  QuickJoinToastButton:SetClampRectInsets(-10,-10,-10,-10)
end

ns.SkinChat = SkinChat