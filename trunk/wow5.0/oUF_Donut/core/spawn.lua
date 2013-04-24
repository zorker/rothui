
  --get the addon namespace
  local addon, ns = ...

  --object container
  local cfg = ns.cfg
  local lib = ns.lib
  local tmp = ns.tmp

  ---------------------------------------------
  -- variables
  ---------------------------------------------

  local tinsert = tinsert

  ---------------------------------------------
  -- functions
  ---------------------------------------------

  local function CreateUnitTemplate(self)
    self.template = tmp:GetTemplateByName(self.cfg.template)
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
    self:SetPoint("CENTER",-356,0)
  end

  --target frame
  local function CreateTarget(self)
    self.cfg = cfg.units.target
    self.cfg.style = "target"
    CreateUnitTemplate(self)
    self:SetPoint("CENTER",356,0)
  end

  --targettarget frame
  local function CreateTargetTarget(self)
    self.cfg = cfg.units.targettarget
    self.cfg.style = "targettarget"
    CreateUnitTemplate(self)
    self:SetPoint("CENTER",356,-50)
  end

  --pet frame
  local function CreatePet(self)
    self.cfg = cfg.units.pet
    self.cfg.style = "pet"
    CreateUnitTemplate(self)
    self:SetPoint("CENTER",-356,-50)
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

  --spawn targettarget
  if cfg.units.targettarget.enable then
    oUF:RegisterStyle("donut:targettarget", CreateTargetTarget)
    oUF:SetActiveStyle("donut:targettarget")
    oUF:Spawn("targettarget", addon.."TargetTargetFrame")
  end

  --spawn pet
  if cfg.units.pet.enable then
    oUF:RegisterStyle("donut:pet", CreatePet)
    oUF:SetActiveStyle("donut:pet")
    oUF:Spawn("pet", addon.."PetFrame")
  end