
  --get the addon namespace
  local addon, ns = ...

  --object container
  local unit = CreateFrame("Frame")
  unit:Hide()

  ---------------------------------------------
  -- UNITS
  ---------------------------------------------

  --just in case needed

  ---------------------------------------------
  -- HANDOVER
  ---------------------------------------------

  --object container to addon namespace
  ns.unit = unit

  