
-- rButtonAura: core
-- zork, 2018

-----------------------------
-- Variables
-----------------------------

local A, L = ...

-----------------------------
-- CONFIG
-----------------------------

L.C = {}

--mediapath
L.C.mediapath = "interface\\addons\\"..A.."\\media\\"
local size = 200

local function AddTexture(self,file,index)
  local t = self:CreateTexture(nil,"BACKGROUND",index)
  t:SetTexture(L.C.mediapath..file)
  t:SetAllPoints()
  return t
end

local frame = CreateFrame("Frame",nil,UIParent)
frame:SetSize(size,size)
frame:SetPoint("CENTER")

local orbBg = AddTexture(frame,"orb_bg",-8)
local orbFill = AddTexture(frame,"orb_fill",-7)
orbFill:SetVertexColor(0,.8,0)
local orbHl = AddTexture(frame,"orb_hl",-6)
