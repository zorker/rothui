
--roth's quake-like viewport mod
--based on code-idea from Dawn

--config values
local mytop = 50
local mybottom = 50
local myleft = 0
local myright = 0
local myscale = 0.82

--functions
local function create_worldframe_background()
  local t = WorldFrame:CreateTexture(nil, "BACKGROUND")
  t:SetTexture(0, 0, 0, 1)
  t:SetPoint("TOPLEFT", UIParent, "TOPLEFT", -5, 5)
  t:SetPoint("BOTTOMRIGHT", UIParent, "BOTTOMRIGHT", 5, -5)
  WorldFrame.bg = t
end

--GLOBAL or LOCAL, you choose. If its global you can access it in the chat window.
--/run change_worldframe_setpoints(20,20,0,0,1)

--local function change_worldframe_setpoints(t,b,l,r,s)
function change_worldframe_setpoints(t,b,l,r,s)
  WorldFrame:ClearAllPoints()
  WorldFrame:SetPoint("LEFT", (l/s), 0)
  WorldFrame:SetPoint("RIGHT", -(r/s), 0)
  WorldFrame:SetPoint("TOP", 0, -(t/s))
  WorldFrame:SetPoint("BOTTOM", 0, (b/s))
end

--register event
local a = CreateFrame("Frame",nil,UIParent)  
a:RegisterEvent("PLAYER_LOGIN")

--setscript
a:SetScript("OnEvent", function(self,event,unit)
  --calls
  create_worldframe_background()
  change_worldframe_setpoints(mytop,mybottom,myleft,myright,myscale)
end)