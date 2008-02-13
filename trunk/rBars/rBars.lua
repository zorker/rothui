local addon = CreateFrame"Frame"
addon:RegisterEvent"PLAYER_LOGIN"
addon:SetScript("OnEvent", function()
	local dummy = function() end
	
	ExhaustionTick:Hide()
	ExhaustionTick.Show = dummy

	MainMenuBarLeftEndCap:Hide()
	MainMenuBarLeftEndCap.Show = dummy

	MainMenuBarPerformanceBarFrame:Hide()
	MainMenuBarPerformanceBarFrame.Show = dummy

  MainMenuExpBar:Hide()
  MainMenuExpBar.Show = dummy
	
	MainMenuBarArtFrame:Hide()
	MainMenuBarArtFrame.Show = dummy

	MainMenuBarRightEndCap:Hide()
	MainMenuBarRightEndCap.Show = dummy

	MainMenuBarArtFrame:Hide()
	MainMenuBarArtFrame.Show = dummy	
	
	ShapeshiftBarLeft:Hide()
	ShapeshiftBarLeft.Show = dummy	
	
	ShapeshiftBarMiddle:Hide()
	ShapeshiftBarMiddle.Show = dummy	
	
	ShapeshiftBarRight:Hide()
  ShapeshiftBarRight.Show = dummy	

	ShapeshiftBarFrame:Hide()
	ShapeshiftBarFrame.Show = dummy	
	
	PossessBarLeft:Hide()
	PossessBarLeft.Show = dummy	
	
	PossessBarRight:Hide()
	PossessBarRight.Show = dummy		

  BonusActionBarTexture0:SetTexture()
	BonusActionBarTexture1:SetTexture()
	
	UIPARENT_MANAGED_FRAME_POSITIONS["PetActionBarFrame"] = nil
	UIPARENT_MANAGED_FRAME_POSITIONS["ShapeshiftBarFrame"] = nil
	UIPARENT_MANAGED_FRAME_POSITIONS["PossessBarFrame"] = nil
	UIPARENT_MANAGED_FRAME_POSITIONS["CastingBarFrame"] = nil
	UIPARENT_MANAGED_FRAME_POSITIONS["MultiBarBottomLeft"] = nil
	UIPARENT_MANAGED_FRAME_POSITIONS["MultiBarBottomRight"] = nil
	UIPARENT_MANAGED_FRAME_POSITIONS["MainMenuBar"] = nil
	UIPARENT_MANAGED_FRAME_POSITIONS["BonusActionBarFrame"] = nil
	UIPARENT_MANAGED_FRAME_POSITIONS["UIParent"] = nil
	
	MainMenuBar:SetScale(0.8)
	MultiBarBottomLeft:SetScale(0.8)
	MultiBarBottomRight:SetScale(0.8)
	
	BonusActionButton1:SetPoint("BOTTOMLEFT", UIParent, 460, 10)
	
	MultiBarBottomLeft:ClearAllPoints()
	MultiBarBottomLeft:SetPoint("BOTTOMLEFT", BonusActionButton1, "TOPLEFT", 0, 7)

	MultiBarBottomRight:ClearAllPoints()
	MultiBarBottomRight:SetPoint("BOTTOMLEFT", MultiBarBottomLeftButton1, "TOPLEFT", 0, 15)

	ShapeshiftBarFrame:ClearAllPoints()
	ShapeshiftBarFrame:SetPoint("BOTTOMLEFT", MultiBarBottomRightButton1, "TOPLEFT", -10, 7)
	
	MultiActionBar_HideAllGrids()
	
end)