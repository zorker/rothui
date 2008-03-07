  
  local bf = CreateFrame"rf_bf"
  bf:SetParent("UIParent")
  bf:SetPoint("CENTER", -230, -150)

  local bft0 = bf:CreateFontString(nil, "OVERLAY")
  bft0:SetPoint("TOPLEFT", 0, 0)
  bft0:SetFontObject(GameFontHighlight)
  bft0:SetTextColor(1, 1, 1)
  bft0:SetText("Buffs:")
  
  local num_trackbuffs = 2
  
  local buff1_string "BS"
  local buff1_searchstring "Schlachtruf"
  
  local buff2_string "CS"
  local buff2_searchstring "Befehlsruf"
  
  
  for i=1,num_trackbuffs do
    local bft = "bft"..i
    
    bft = CreateFontString(bft, "OVERLAY")
    bft:SetPoint("TOPLEFT", "bft"..i-1, "BOTTOMLEFT", 0, 0)
    bft:SetFontObject(GameFontHighlight)
    bft:SetTextColor(1, 0, 0)
    bft:SetText("buff"..i.."_string")
    
  end
  
  
  function CheckPlayerBuffs() {
  
  }
  
  function CheckTargetDebuffs() {
  
  }