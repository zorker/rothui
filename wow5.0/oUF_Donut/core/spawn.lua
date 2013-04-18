
  --get the addon namespace
  local addon, ns = ...

  --object container
  local cfg = ns.cfg
  local lib = ns.lib

  local tinsert = tinsert

  ---------------------------------------------
  -- functions
  ---------------------------------------------

  local function CreateUnitTemplate(self)
    self:SetSize(256,256)
    self:SetScale(self.cfg.scale or 1)
    --self:SetBackdrop(cfg.backdrop)
    self:RegisterForClicks("AnyDown")
    self:SetScript("OnEnter", UnitFrame_OnEnter)
    self:SetScript("OnLeave", UnitFrame_OnLeave)

    lib:CreateFrameStack(self)

  end

  --player frame
  local function CreatePlayer(self)
    self.cfg = cfg.units.player
    self.cfg.style = "player"
    CreateUnitTemplate(self)
    self:SetPoint("CENTER",-256,0)
  end

  --target frame
  local function CreateTarget(self)
    self.cfg = cfg.units.target
    self.cfg.style = "target"
    CreateUnitTemplate(self)
    self:SetPoint("CENTER",256,0)
  end

  ---------------------------------------------
  -- spawn
  ---------------------------------------------

  --spawn player
  if cfg.units.player.enable then
    oUF:RegisterStyle("donut:player", CreatePlayer)
    oUF:SetActiveStyle("donut:player")
    oUF:Spawn("player", addon.."PlayerFrame")
  end

  --spawn target
  if cfg.units.target.enable then
    oUF:RegisterStyle("donut:target", CreateTarget)
    oUF:SetActiveStyle("donut:target")
    oUF:Spawn("target", addon.."TargetFrame")
  end