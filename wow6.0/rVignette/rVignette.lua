
  -- // rVignette
  -- // zork - 2014

  -----------------------------
  -- VARIABLES
  -----------------------------

  local an, at = ...

  local addon = CreateFrame("Frame")
  addon.vignettes = {}

  -----------------------------
  -- FUNCTIONS
  -----------------------------

  local function OnEvent(self,event,id)
    if id and not self.vignettes[id] then
      local x, y, name, icon = C_Vignettes.GetVignetteInfoFromInstanceID(id)
      local left, right, top, bottom = GetObjectIconTextureCoords(icon)
      PlaySoundFile("Sound\\Interface\\RaidWarning.wav")
      local str = "|TInterface\\MINIMAP\\ObjectIconsAtlas:0:0:0:0:256:256:"..(left*256)..":"..(right*256)..":"..(top*256)..":"..(bottom*256).."|t"
      RaidNotice_AddMessage(RaidWarningFrame, str..(name or "Unknown").." spotted!", ChatTypeInfo["RAID_WARNING"])
      print(str..name,"spotted!")
      self.vignettes[id] = true
    end
  end

  -----------------------------
  -- REGISTER/CALL
  -----------------------------

  addon:RegisterEvent("VIGNETTE_ADDED")
  addon:SetScript("OnEvent", OnEvent)
