
--VARIABLES/CONSTANTS

--init the addon frame
local addon = CreateFrame("Frame")
local db_glob, db_char
local _G = _G

--FUNCTIONS

--default values
local function loadDefaultsGlobal()
  local t = {
    name = 'green',
  }
  return t
end
local function loadDefaultsChar()
  local t = {
    width = 100,
  }
  return t
end

local function loadDatabase()
  db_glob = _G["RCONFIG_DB_GLOB"] or loadDefaultsGlobal()
  _G["RCONFIG_DB_GLOB"] = db_glob
  --saved variables per character
  db_char = _G["RCONFIG_DB_CHAR"] or loadDefaultsChar()
  _G["RCONFIG_DB_CHAR"] = db_char
end

local function resetAllValues()
  db_glob = loadDefaultsGlobal()
  _G["RCONFIG_DB_GLOB"] = db_glob
  db_char = loadDefaultsChar()
  _G["RCONFIG_DB_CHAR"] = db_char
end

--do you really want to reset all values?
StaticPopupDialogs["RESET"] = {
  text = "Reset all values for rConfig?",
  button1 = ACCEPT,
  button2 = CANCEL,
  OnAccept = function() resetAllValues() print('reset done') end,
  OnCancel = function() print('reset canceled') end,
  timeout = 0,
  whileDead = 1,
}

local function createSubPanel(parent, name)
  local panel = CreateFrame("FRAME", name)
  panel.name = name
  panel.parent = parent.name
  panel.okay = function (self)
    print(name..' okay')
  end
  panel.cancel = function (self)
    print(name..' cancel')
  end
  panel.default = function (self)
    --resetAllValues()
    StaticPopup_Show("RESET")
    print(name..' default')
  end
  panel.refresh = function (self)
    print(name..' refresh')
  end
  InterfaceOptions_AddCategory(panel)
end

local function initPanel()
  local mainpanel = CreateFrame("FRAME")
  mainpanel.name = "rConfig"
  InterfaceOptions_AddCategory(mainpanel)
  createSubPanel(mainpanel,"rConfigSubPanel1")
  createSubPanel(mainpanel,"rConfigSubPanel2")
  return mainpanel
end

local function initSlashCmd(panel)
  SLASH_RCONFIG1, SLASH_RCONFIG2 = '/rc', '/rconfig'
  function SlashCmdList.RCONFIG(msg, editbox)
    InterfaceOptionsFrame_OpenToCategory(panel)
  end
end

--INIT

function addon:VARIABLES_LOADED(...)
  local self = self
  --load the database
  loadDatabase()
  self:UnregisterEvent("VARIABLES_LOADED")
end

function addon:PLAYER_LOGIN(...)
  local self = self
  print(db_glob.name)
  local mainpanel = initPanel()
  initSlashCmd(mainpanel)
  self:UnregisterEvent("PLAYER_LOGIN")
end

--CALL

--by doing this the addon will call functions based on registered events by itself
addon:SetScript("OnEvent", function(self, event)
  self[event](self)
  --return self[event](self)
end)
--register events
addon:RegisterEvent("VARIABLES_LOADED")
addon:RegisterEvent("PLAYER_LOGIN")