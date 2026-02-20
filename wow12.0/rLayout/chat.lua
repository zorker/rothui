local addonName, ns = ...

local editBoxFocusAlpha = 1
local editBoxAlpha = 0

local function ApplyClamp(cf)
  ns.eventFrame.SetClampRectInsets(cf,0,0,0,0)
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
  ChatFrame1:ClearAllPoints()
  ChatFrame1:SetPoint("BOTTOMLEFT", 10, 10)
  QuickJoinToastButton:SetClampedToScreen(true)
  QuickJoinToastButton:SetClampRectInsets(-10,-10,-10,-10)
end

local function MoveChat()
  ChatFrame1:ClearAllPoints()
  ChatFrame1:SetPoint("BOTTOMLEFT", 10, 10)
end

ns.SkinChat = SkinChat
ns.MoveChat = MoveChat