
local addon, ns = ...
local UIP = UIParent
local CF = CreateFrame
local _G = _G
local unpack = unpack
local wipe = wipe

print(addon.." loaded")

local width = 600
local height = 300

-- content data func

local function generateScrollChildData(scrollChild,maxx)
local genv = getfenv(0)
 
-- Collect the names of all possible globally defined fonts
local fonts = {}
for k, v in pairs(genv) do
   if type(v) == "table" and type(v.GetObjectType) == "function" then
      local otype = v:GetObjectType()
      if otype == "Font" then
         table.insert(fonts, k)
      end
   end
end
 
-- Sort the list alphabetically
table.sort(fonts)
 
-- Create a table that will contain the font strings themselves
scrollChild.fstrings = scrollChild.fstrings or {}
 
-- This changes the padding between font strings vertically
local PADDING = 5
 
-- Store the max width and overall height of the scroll child
local height = 0
local width = 0
 
-- Iterate the list of fonts collected
for idx, fname in ipairs(fonts) do
   -- If the font string is not created, do so
   if not scrollChild.fstrings[idx] then
      print(idx, fname)
      scrollChild.fstrings[idx] = scrollChild:CreateFontString("FPreviewFS" .. idx, "OVERLAY")
   end
    
   -- Set the font string to the correct font object, set the text to be the
   -- name of the font and set the height/width of the font string based on
   -- the size of the resulting 'string'.
   local fs = scrollChild.fstrings[idx]
   fs:SetFontObject(genv[fname])
   fs:SetText(fname)
   local fwidth = fs:GetStringWidth()
   local fheight = fs:GetStringHeight()
   --fs:SetSize(fwidth, fheight)
   fs:SetHeight(fheight)
    
   -- Place the font strings in rows starting at the top-left
   if idx == 1 then
      fs:SetPoint("TOPLEFT", 0, 0)
      height = height + fheight
   else
      fs:SetPoint("TOPLEFT", scrollChild.fstrings[idx - 1], "BOTTOMLEFT", 0, - PADDING)
      height = height + fheight + PADDING
   end
    
   -- Update the 'max' width of the frame
   width = (fwidth > width) and fwidth or width
end
  scrollChild:SetSize(width, height)
  scrollChild:SetHeight(height)
end

local function genData(scrollChild,maxx)
  if not maxx then maxx = 99 end
  scrollChild.data = scrollChild.data or {}
  local padding = 10
  local height = 0
  local width = 0
  for i=1, maxx  do
     scrollChild.data[i] = scrollChild.data[i] or scrollChild:CreateFontString(nil, nil, "GameFontBlackMedium")
     local fs = scrollChild.data[i]
     fs:SetText("String"..i)
     local fheight = fs:GetStringHeight()
     if i == 1 then
        fs:SetPoint("TOPLEFT", 0, 0)
     else
        fs:SetPoint("TOPLEFT", scrollChild.data[i - 1], "BOTTOMLEFT", 0, -padding)
     end
     height = height + fheight + padding
  end
  scrollChild:SetHeight(height)
end


-- // SCROLLFRAME TEMPLATES

--template = "UIPanelScrollFrameTemplate"
--template = "UIPanelScrollFrameTemplate2"
--template = "MinimalScrollFrameTemplate"
--template = "FauxScrollFrameTemplate"
--template = "FauxScrollFrameTemplateLight"
--template = "ListScrollFrameTemplate"

-- // SCROLLBAR TEMPLATES

--template = "UIPanelScrollBarTemplate"
--template = "UIPanelScrollBarTrimTemplate"
--template = "UIPanelScrollBarTemplateLightBorder"
--template = "MinimalScrollBarTemplate"

--scroll frame
local scrollFrame = CreateFrame("ScrollFrame", addon, UIP, "UIPanelScrollFrameTemplate")

scrollFrame:SetSize(width, height)
scrollFrame:SetPoint("CENTER", UIParent, 0, 0)

local scrollBar = _G[addon.."ScrollBar"]
print(scrollBar:GetWidth())

--debug texture
local tex = scrollFrame:CreateTexture(nil, "BACKGROUND")
tex:SetTexture(1,1,1)
tex:SetVertexColor(1,1,0,0.3)
tex:SetAllPoints()

--hack for the UIPanelScrollBarTemplate template that UIPanelScrollFrameTemplate is using
--I want the cosmetic border, so we add it manually
local tex = scrollFrame:CreateTexture(nil,"BACKGROUND",nil,-6)
tex:SetPoint("TOP",scrollFrame)
tex:SetPoint("RIGHT",scrollBar,3.7,0)
tex:SetPoint("BOTTOM",scrollFrame)
tex:SetWidth(scrollBar:GetWidth()+10)
tex:SetTexture("Interface\\PaperDollInfoFrame\\UI-Character-ScrollBar")
tex:SetTexCoord(0,0.45,0.1640625,1)
--debug texture
local tex2 = scrollFrame:CreateTexture(nil,"BACKGROUND",nil,-8)
tex2:SetTexture(1,1,1)
tex2:SetVertexColor(1,0,1,0.3)
tex2:SetAllPoints(tex)

--scroll child
local scrollChild = CreateFrame("Frame", "$parentScrollChild1")
scrollChild:SetWidth(scrollFrame:GetWidth())

local tex = scrollChild:CreateTexture(nil, "BACKGROUND")
tex:SetTexture(1,1,1)
tex:SetVertexColor(0,1,1,0.3)
tex:SetAllPoints()

--LOAD SOME DATA and set the framesize
generateScrollChildData(scrollChild,20)
--genData(scrollChild,20)

scrollFrame:SetScrollChild(scrollChild)

scrollFrame:EnableMouse(true)

--make sure you cannot move the panel out of the screen
scrollFrame:SetClampedToScreen(true)


scrollFrame:SetMovable(true)

scrollFrame:SetResizable(true)

scrollFrame:SetUserPlaced(true)

scrollFrame:SetScript("OnSizeChanged", function(self) scrollChild:SetWidth(self:GetWidth()) end)

local frame = CF("Frame", "$parentResize", scrollFrame)
frame:SetSize(26,26)
frame:SetPoint("BOTTOMRIGHT",30,-30)

local texture = frame:CreateTexture(nil, "BACKGROUND", nil, -8)
texture:SetAllPoints()
texture:SetTexture(1,1,1)
texture:SetVertexColor(0,1,1,0.6) --bugfix

frame:EnableMouse(true)
frame:RegisterForDrag("LeftButton")
frame:SetScript("OnDragStart", function(self)
  if InCombatLockdown() then return end
  self:GetParent():StartSizing()
end)
frame:SetScript("OnDragStop", function(self)
  if InCombatLockdown() then return end
  self:GetParent():StopMovingOrSizing()
end)
frame:SetScript("OnEnter", function(self)
  GameTooltip:SetOwner(self, "ANCHOR_TOP")
  GameTooltip:AddLine(addon, 0, 1, 0.5, 1, 1, 1)
  GameTooltip:AddLine("Resize me!", 1, 1, 1, 1, 1, 1)
  GameTooltip:Show()
end)
frame:SetScript("OnLeave", function(self) GameTooltip:Hide() end)