
  -------------------------------------
  -- ADDON TABLES
  -------------------------------------

  local an, at = ...

  -------------------------------------
  -- VARIABLES
  -------------------------------------

  -- local variables
  local G, L, C, DB = at.G, at.L, at.C, at.DB

  -------------------------------------
  -- DATABASE
  -------------------------------------

  local function LoadGlobDefaults()
    return {
      ["COLOR"] = {1,1,1},
      ["MODELSIZE"] = 200,
      ["PAGE"] = 1,
    }
  end

  local function LoadCharDefaults()
    return {}
  end

  --load db
  local loadDB = CreateFrame("Frame")
  loadDB:SetScript("OnEvent", function(self, event)
    rIMV_DBGLOB = rIMV_DBGLOB or LoadGlobDefaults()
    rIMV_DBCHAR = rIMV_DBCHAR or LoadCharDefaults()
    DB.GLOB = rIMV_DBGLOB
    DB.CHAR = rIMV_DBCHAR
    self:UnregisterEvent(event)
  end)
  loadDB:RegisterEvent("VARIABLES_LOADED")