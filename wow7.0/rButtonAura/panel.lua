
-- rButtonAura: panel
-- zork, 2018

-----------------------------
-- Variables
-----------------------------

local A, L = ...

--panel container
L.P = {}

-----------------------------
-- Functions
-----------------------------

local function Okay(self,...)
  --xpcall(function(...) print(...) end, geterrorhandler())
  print(self:GetName(),"okay")
end

local function Default(self,...)
  print(self:GetName(),"default")
end

local function Refresh(self,...)
  print(self:GetName(),"refresh")
end

local function Cancel(self,...)
  print(self:GetName(),"cancel")
end

local function InitPanelButtons(panel)
  panel.okay = Okay
  panel.cancel = Cancel
  panel.refresh = Refresh
  panel.default = Default
end

--mainPanel
L.P.mainPanel = CreateFrame("Frame", A.."MainPanel", UIParent)
L.P.mainPanel.name = A
InitPanelButtons(L.P.mainPanel)
InterfaceOptions_AddCategory(L.P.mainPanel)

--childPanel1
L.P.childPanel1 = CreateFrame("Frame", A.."ChildPanel1", L.P.mainPanel)
L.P.childPanel1.name = L.P.childPanel1:GetName()
L.P.childPanel1.parent = L.P.mainPanel.name
InitPanelButtons(L.P.childPanel1)
InterfaceOptions_AddCategory(L.P.childPanel1)

