 local addon = CreateFrame("Frame", nil, UIParent)
 
  addon:RegisterEvent("PLAYER_LOGIN")
  
  addon:SetScript("OnEvent", function ()
    if(event=="PLAYER_LOGIN") then
      addon:initme()
    end 
  end)

  function addon:initme()
  


    local m2 = CreateFrame("PlayerModel", "TestaniModel2",UIParent)

    m2:SetFrameStrata("BACKGROUND")
    m2:SetWidth(256)
    m2:SetHeight(256)
    m2:SetPoint("CENTER",256,0)
    m2:Show()

    m2:SetModel("SPELLS\\RedRadiationFog.m2")
    m2:SetModelScale(-2)
    m2:SetPosition(-10, 0, 0) 



    local f = CreateFrame("Frame", nil,m2)
    
    f:SetAllPoints(m2)
    f:SetBackdrop({
      bgFile = "", 
      edgeFile = "Interface\\Tooltips\\UI-Tooltip-Border", 
      tile = true, tileSize = 16, edgeSize = 16, 
      insets = { left = 4, right = 4, top = 4, bottom = 4 }
    })


  end