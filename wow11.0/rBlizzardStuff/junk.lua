-- rBlizzardStuff/junk: auto sell junk on vendor visit
-- zork, 2024

-----------------------------
-- Variables
-----------------------------

local A, L = ...

-----------------------------
-- Functions
-----------------------------

local function SellJunk()
  if C_MerchantFrame.GetNumJunkItems() > 0 then
    C_MerchantFrame.SellAllJunkItems()
  end
end

rLib:RegisterCallback("MERCHANT_SHOW", SellJunk)
