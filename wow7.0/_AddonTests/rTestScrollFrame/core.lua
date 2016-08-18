

--frame
local frame = CreateFrame("Frame", "rTestFrame", UIParent)
frame:SetPoint("CENTER")
frame:SetSize(32,32)

--scrollFrame
local scrollFrame = CreateFrame("ScrollFrame", "$parentScrollFrame", frame, "UIPanelScrollFrameTemplate")
scrollFrame:SetPoint("CENTER")
scrollFrame:SetSize(300,300)

--scrollChild
local scrollChild = CreateFrame("Frame",nil,scrollFrame)
scrollChild:SetSize(300,1500)

--scrollFrame:SetScrollChild
scrollFrame:SetScrollChild(scrollChild)

--add test objects to scrollchild

--text
local text = scrollChild:CreateFontString(nil, "BACKGROUND")
text:SetFont(STANDARD_TEXT_FONT, 32, "OUTLINE")
text:SetPoint("TOPLEFT")
text:SetText("Hello World!")

--murloc model
local m = CreateFrame("PlayerModel",nil,scrollChild)
m:SetSize(200,200)
m:SetPoint("TOPLEFT",text,"BOTTOMLEFT",0,-10)
m:SetCamDistanceScale(0.8)
m:SetRotation(-0.4)
m:SetDisplayInfo(21723) --murcloc costume

--dwarf artifact model
local m2 = CreateFrame("PlayerModel",nil,scrollChild)
m2:SetSize(200,200)
m2:SetPoint("TOPLEFT",m,"BOTTOMLEFT",0,-10)
m2:SetCamDistanceScale(0.5)
m2:SetDisplayInfo(38699)

--change the scrollframe position
scrollFrame:SetVerticalScroll(150)