local function AfterGarrisonFollowerPage_ShowFollower(self,followerID)
  print("ShowFollower",followerID)
  local followerInfo = C_Garrison.GetFollowerInfo(followerID)
  if not followerInfo then return end
  local weaponItemID, weaponItemLevel, armorItemID, armorItemLevel = C_Garrison.GetFollowerItems(followerInfo.followerID)
  print("GetFollowerItems",weaponItemID, weaponItemLevel, armorItemID, armorItemLevel)
  GarrisonFollowerPage_SetItem(self.ItemWeapon, weaponItemID, weaponItemLevel)
  GarrisonFollowerPage_SetItem(self.ItemArmor, armorItemID, armorItemLevel)
  self.ItemAverageLevel.Level:SetText(ITEM_LEVEL_ABBR.." ".. followerInfo.iLevel)
  self.ItemAverageLevel.Level:Show()
end

hooksecurefunc("GarrisonFollowerPage_ShowFollower",AfterGarrisonFollowerPage_ShowFollower)