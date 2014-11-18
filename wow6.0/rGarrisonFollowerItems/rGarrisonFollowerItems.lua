local function AfterGarrisonFollowerPage_ShowFollower(self,followerID)
  local followerInfo = C_Garrison.GetFollowerInfo(followerID)
  if not followerInfo then return end
  if not followerInfo.isCollected then return end
  local weaponItemID, weaponItemLevel, armorItemID, armorItemLevel = C_Garrison.GetFollowerItems(followerInfo.followerID)
  GarrisonFollowerPage_SetItem(self.ItemWeapon, weaponItemID, weaponItemLevel)
  GarrisonFollowerPage_SetItem(self.ItemArmor, armorItemID, armorItemLevel)
  if self.isLandingPage and not self.pointAdjusted then
    self.ItemWeapon:SetScale(0.9)
    self.ItemArmor:SetScale(0.9)
    self.ItemArmor:ClearAllPoints()
    self.ItemArmor:SetPoint("LEFT",self.ItemWeapon,"RIGHT",10,0)
    self.pointAdjusted = true
  end
end

hooksecurefunc("GarrisonFollowerPage_ShowFollower",AfterGarrisonFollowerPage_ShowFollower)