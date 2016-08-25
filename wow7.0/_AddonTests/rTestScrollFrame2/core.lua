
local cfg = {}
cfg.size = 200

--frame
local frame = CreateFrame("Frame", "rTestFrame", UIParent)
frame:SetPoint("CENTER")
frame:SetSize(cfg.size,cfg.size)
frame:SetBackdrop({bgFile = "Interface\\Tooltips\\UI-Tooltip-Background",
edgeFile = "Interface\\Tooltips\\UI-Tooltip-Border",
tile = true, tileSize = 16, edgeSize = 16,
insets = { left = 4, right = 4, top = 4, bottom = 4 }})

--scrollFrame
local scrollFrame = CreateFrame("ScrollFrame", "$parentScrollFrame", frame)
scrollFrame:SetPoint("BOTTOM")
scrollFrame:SetSize(cfg.size,cfg.size)

--scrollChild
local scrollChild = CreateFrame("Frame")
scrollChild:SetSize(cfg.size,cfg.size)

--scrollFrame:SetScrollChild
scrollFrame:SetScrollChild(scrollChild)

--add test objects to scrollchild

--dwarf artifact model
local m2 = CreateFrame("PlayerModel",nil,scrollChild)
m2:SetSize(cfg.size,cfg.size)
m2:SetPoint("CENTER")
m2:SetCamDistanceScale(0.5)
m2:SetDisplayInfo(38699)

local t = m2:CreateTexture(nil,"BACKGROUND",nil,-8)
t:SetAllPoints(m2)
t:SetColorTexture(1,1,1)
t:SetVertexColor(0,1,0)
t:SetAlpha(0.3)

frame.scrollFrame = scrollFrame

function frame:Update(perc)
  --perc range 0..1
  local h = cfg.size*perc
  local vs = cfg.size-h
  self.scrollFrame:SetVerticalScroll(vs)
  self.scrollFrame:SetHeight(h)
end

--change the scrollframe position
frame:Update(0.25)

--chat commands
--/run rTestFrame:Update(1)
--/run rTestFrame:Update(0.75)
--/run rTestFrame:Update(0.5)
--/run rTestFrame:Update(0.25)