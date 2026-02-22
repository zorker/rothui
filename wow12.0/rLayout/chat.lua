local addonName, ns = ...

--config

local chatPosition = { "BOTTOMLEFT", 10, 10 }
local editBoxFocusAlpha = 1
local editBoxAlpha = 0

--functions

local function ApplyClamp(cf)
  ns.eventFrame.SetClampRectInsets(cf,0,0,0,0)
end

local function ApplyPoint(cf)
  ns.eventFrame.ClearAllPoints(cf)
  ns.eventFrame.SetPoint(cf, unpack(chatPosition))
end

--SkinChat
local function SkinChat()
  for i = 1, NUM_CHAT_WINDOWS do
    local cf = _G["ChatFrame"..i]
    if not cf then return end
    local cbg   = _G["ChatFrame"..i.."Background"]
    local cbf   = _G["ChatFrame"..i.."ButtonFrame"]
    local ceb   = _G["ChatFrame"..i.."EditBox"]
    local cebfl = _G["ChatFrame"..i.."EditBoxFocusLeft"]
    local cebfm = _G["ChatFrame"..i.."EditBoxFocusMid"]
    local cebfr = _G["ChatFrame"..i.."EditBoxFocusRight"]
    local cebl  = _G["ChatFrame"..i.."EditBoxLeft"]
    local cebm  = _G["ChatFrame"..i.."EditBoxMid"]
    local cebr  = _G["ChatFrame"..i.."EditBoxRight"]
    cbf:Hide()
    ceb:SetAltArrowKeyMode(false)
    ceb:ClearAllPoints()
    ceb:SetPoint("BOTTOMLEFT",cbg,"TOPLEFT",QuickJoinToastButton:GetWidth(),20)
    ceb:SetPoint("BOTTOMRIGHT",cbg,"TOPRIGHT",0,20)
    cebfl:SetAlpha(editBoxFocusAlpha)
    cebfm:SetAlpha(editBoxFocusAlpha)
    cebfr:SetAlpha(editBoxFocusAlpha)
    cebl:SetAlpha(editBoxAlpha)
    cebm:SetAlpha(editBoxAlpha)
    cebr:SetAlpha(editBoxAlpha)
    cf:SetClampRectInsets(0,0,0,0)
    hooksecurefunc(cf, "SetClampRectInsets", ApplyClamp)
  end
  TextToSpeechButtonFrame:Hide()
  QuickJoinToastButton:SetClampedToScreen(true)
  QuickJoinToastButton:SetClampRectInsets(-10,-10,-10,-10)
  ChatFrame1:ClearAllPoints()
  ChatFrame1:SetPoint(unpack(chatPosition))
  hooksecurefunc(ChatFrame1, "SetPoint", ApplyPoint)
end

ns.SkinChat = SkinChat
