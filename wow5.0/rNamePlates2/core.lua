
  ---------------------------------------------
  --  rNamePlates 2
  ---------------------------------------------

  --  Simple nameplates
  --  zork - 2013

  -----------------------------------------
  -- CONFIG
  -----------------------------------------

  local cfg = {}

  --width/height
  cfg.nameplateWidth    = 100
  cfg.healthbarHeight   = 7
  cfg.castbarHeight     = 7

  --gap between bars and castbar icon
  cfg.gap               = 5

  --icon sizes
  cfg.iconSize          = 30
  cfg.shieldSize        = 16
  cfg.raidiconSize      = 25

  --statusbars
  --available textures: statusbar, statusbar_smooth, statusbar_rothui
  cfg.healthbarTexture  = "Interface\\AddOns\\rNamePlates2\\media\\statusbar_rothui"
  cfg.castbarTexture    = "Interface\\AddOns\\rNamePlates2\\media\\statusbar"

  --backdrop settings
  cfg.backdrop = {
    bgFile = "Interface\\AddOns\\rNamePlates2\\media\\backdrop",
    edgeFile = "Interface\\AddOns\\rNamePlates2\\media\\backdrop_edge",
    tile = false,
    tileSize = 0,
    edgeSize = 3,
    insets = {
      left = 3,
      right = 3,
      top = 3,
      bottom = 3,
    },
  }

  -----------------------------------------
  -- VARIABLES
  -----------------------------------------

  --plate collector
  local RNP = CreateFrame("Frame", "PlateCollector", WorldFrame)
  RNP:SetAllPoints()
  RNP.nameplates = {}

  --trash can
  RNP.pastebin = CreateFrame("Frame")
  RNP.pastebin:Hide()

  local RAID_CLASS_COLORS = RAID_CLASS_COLORS
  local FACTION_BAR_COLORS = FACTION_BAR_COLORS

  -----------------------------------------
  -- FUNCTIONS
  -----------------------------------------

  --backdrop func
  local function CreateBackdrop(obj)
    local frame = CreateFrame("Frame",nil,obj)
    frame:SetFrameLevel(obj:GetFrameLevel()-1)
    frame:SetPoint("TOPLEFT",-cfg.backdrop.edgeSize,cfg.backdrop.edgeSize)
    frame:SetPoint("BOTTOMRIGHT",cfg.backdrop.edgeSize,-cfg.backdrop.edgeSize)
    frame:SetBackdrop(cfg.backdrop);
    frame:SetBackdropColor(0,0,0,1)
    frame:SetBackdropBorderColor(0,0,0,1)
  end

  --convert RGB to Hexadecimal color value
  local function RGBPercToHex(r, g, b)
    r = r <= 1 and r >= 0 and r or 0
    g = g <= 1 and g >= 0 and g or 0
    b = b <= 1 and b >= 0 and b or 0
    return string.format("%02x%02x%02x", r*255, g*255, b*255)
  end

  --round color values to fix them
  local function FixColor(color)
    color.r,color.g,color.b = floor(color.r*100+.5)/100, floor(color.g*100+.5)/100, floor(color.b*100+.5)/100
  end

  --get difficulty color func
  local function GetLevelColor(self)
    local color = {}
    color.r, color.g, color.b = self.level:GetTextColor()
    FixColor(color)
    return color
  end

  --get threat color func
  local function GetThreatColor(self)
    local color = {}
    color.r, color.g, color.b = self.threat:GetVertexColor()
    FixColor(color)
    return color
  end

  --get healthbar color func
  local function GetHealthbarColor(self)
    local color = {}
    color.r, color.g, color.b = self.healthbar:GetStatusBarColor()
    FixColor(color)
    return color
  end

  --get castbar color func
  local function GetCastbarColor(self)
    local color = {}
    color.r, color.g, color.b = self.castbar:GetStatusBarColor()
    FixColor(color)
    return color
  end

  --based on a given color, guess the cass/faction color
  local function CalculateClassFactionColor(color)
    for class, _ in pairs(RAID_CLASS_COLORS) do
      if RAID_CLASS_COLORS[class].r == color.r and RAID_CLASS_COLORS[class].g == color.g and RAID_CLASS_COLORS[class].b == color.b then
        return --no color change needed, class color found
      end
    end
    if color.g+color.b == 0 then -- hostile
      color.r,color.g,color.b = FACTION_BAR_COLORS[2].r, FACTION_BAR_COLORS[2].g, FACTION_BAR_COLORS[2].b
      return
    elseif color.r+color.b == 0 then -- friendly npc
      color.r,color.g,color.b = FACTION_BAR_COLORS[6].r, FACTION_BAR_COLORS[6].g, FACTION_BAR_COLORS[6].b
      return
    elseif color.r+color.g == 2 then -- neutral
      color.r,color.g,color.b = FACTION_BAR_COLORS[4].r, FACTION_BAR_COLORS[4].g, FACTION_BAR_COLORS[4].b
      return
    elseif color.r+color.g == 0 then -- friendly player, we don't like 0,0,1 so we change it to a more likable color
      color.r,color.g,color.b = 0/255, 100/255, 255/255
      return
    else
      --whatever is left
      return
    end
  end

  --get hexadecimal color string from color table
  local function GetHexColor(color)
    return RGBPercToHex(color.r,color.g,color.b)
  end
  
  --NamePlateOnShow func
  local function NamePlateOnShow(self)
    --healthbar
    self.healthbar:ClearAllPoints()
    self.healthbar:SetPoint("TOP", self.newPlate)
    self.healthbar:SetPoint("LEFT", self.newPlate)
    self.healthbar:SetPoint("RIGHT", self.newPlate)
    self.healthbar:SetHeight(cfg.healthbarHeight)
    --threat glow
    self.threat:ClearAllPoints()
    self.threat:SetPoint("TOPLEFT",self.healthbar,-2,2)
    self.threat:SetPoint("BOTTOMRIGHT",self.healthbar,2,-2)
    --set name and level
    local hexColor = GetHexColor(GetLevelColor(self)) or "ffffff"
    local name = self.name:GetText() or "Unknown"
    local level = self.level:GetText() or "-1"
    if self.boss:IsShown() then
      level = "??"
      hexColor = "ff6600"
    elseif self.dragon:IsShown() then
      level = level.."+"
    end
    local color = GetHealthbarColor(self)
    CalculateClassFactionColor(color)
    self._name:SetTextColor(color.r,color.g,color.b)
    self._name:SetText("|cff"..hexColor..""..level.."|r "..name)
  end

  --NamePlateCastbarOnShow func
  local function NamePlateCastbarOnShow(self)
    local newPlate = self:GetParent()
    --castbar
    self:ClearAllPoints()
    self:SetPoint("BOTTOM", newPlate)
    self:SetPoint("LEFT", newPlate)
    self:SetPoint("RIGHT", newPlate)
    self:SetHeight(cfg.castbarHeight)
    --castbar icon
    self.icon:ClearAllPoints()
    self.icon:SetPoint("RIGHT", newPlate, "LEFT", -cfg.gap, 0)
    if self.shield:IsShown() then
      --castbar shield
      self.shield:ClearAllPoints()
      self.shield:SetPoint("BOTTOM",self.icon,0,-cfg.shieldSize/2+2)
      self.shield:SetSize(cfg.shieldSize,cfg.shieldSize)
      self.iconBorder:SetDesaturated(1)
      self:SetStatusBarColor(0.8,0.8,0.8)
    else
      self.iconBorder:SetDesaturated(0)
    end
  end

  --NamePlateInit func
  local function NamePlateInit(plate)
    --the gathering
    plate.barFrame, plate.nameFrame = plate:GetChildren()
    plate.healthbar, plate.castbar = plate.barFrame:GetChildren()
    plate.threat, plate.border, plate.highlight, plate.level, plate.boss, plate.raid, plate.dragon = plate.barFrame:GetRegions()
    plate.name = plate.nameFrame:GetRegions()
    plate.healthbar.texture = plate.healthbar:GetRegions()
    plate.castbar.texture, plate.castbar.border, plate.castbar.shield, plate.castbar.icon, plate.castbar.name, plate.castbar.nameShadow = plate.castbar:GetRegions()
    plate.castbar.icon.layer, plate.castbar.icon.sublevel = plate.castbar.icon:GetDrawLayer()
    plate.rnp_checked = true
    --create a new plate
    RNP.nameplates[plate] = CreateFrame("Frame", "New"..plate:GetName(), RNP)
    local newPlate = RNP.nameplates[plate]
    newPlate:SetSize(cfg.nameplateWidth,cfg.healthbarHeight+cfg.castbarHeight+cfg.gap)
    --keep the frame reference for later
    newPlate.blizzPlate = plate
    plate.newPlate = newPlate
    --barFrame
    --do not touch it
    --nameFrame
    plate.nameFrame:SetParent(RNP.pastebin)
    plate.nameFrame:Hide()
    --healthbar
    plate.healthbar:SetParent(newPlate)
    plate.healthbar:SetStatusBarTexture(cfg.healthbarTexture)
    CreateBackdrop(plate.healthbar)
    --threat
    plate.threat:SetParent(plate.healthbar)
    plate.threat:SetTexture("Interface\\AddOns\\rNamePlates2\\media\\threat_glow")
    plate.threat:SetTexCoord(0,1,0,1)
    --level
    plate.level:SetParent(RNP.pastebin) --trash the level string, it will come back OnShow and OnDrunk otherwise ;)
    plate.level:Hide()
    --hide textures
    plate.border:SetTexture(nil)
    plate.highlight:SetTexture(nil)
    plate.boss:SetTexture(nil)
    plate.dragon:SetTexture(nil)
    --castbar
    plate.castbar:SetParent(newPlate)
    plate.castbar:SetStatusBarTexture(cfg.castbarTexture)
    CreateBackdrop(plate.castbar)
    --castbar border
    plate.castbar.border:SetTexture(nil)
    --castbar icon
    plate.castbar.icon:SetTexCoord(0.1,0.9,0.1,0.9)
    plate.castbar.icon:SetSize(cfg.iconSize,cfg.iconSize)
    --castbar spellname
    plate.castbar.name:ClearAllPoints()
    plate.castbar.name:SetPoint("BOTTOM",plate.castbar,0,-5)
    plate.castbar.name:SetPoint("LEFT",plate.castbar,5,0)
    plate.castbar.name:SetPoint("RIGHT",plate.castbar,-5,0)
    plate.castbar.name:SetFont(STANDARD_TEXT_FONT,10,"THINOUTLINE")
    plate.castbar.name:SetShadowColor(0,0,0,0)
    --castbar shield
    plate.castbar.shield:SetTexture("Interface\\AddOns\\rNamePlates2\\media\\castbar_shield")
    plate.castbar.shield:SetTexCoord(0,1,0,1)
    plate.castbar.shield:SetDrawLayer(plate.castbar.icon.layer, plate.castbar.icon.sublevel+2)
    --new castbar icon border
    plate.castbar.iconBorder = plate.castbar:CreateTexture(nil, plate.castbar.icon.layer, nil, plate.castbar.icon.sublevel+1)
    plate.castbar.iconBorder:SetTexture("Interface\\AddOns\\rNamePlates2\\media\\castbar_icon_border")
    plate.castbar.iconBorder:SetPoint("TOPLEFT",plate.castbar.icon,"TOPLEFT",-2,2)
    plate.castbar.iconBorder:SetPoint("BOTTOMRIGHT",plate.castbar.icon,"BOTTOMRIGHT",2,-2)
    --new name
    newPlate.name = newPlate:CreateFontString(nil,"BORDER")
    newPlate.name:SetPoint("BOTTOM", newPlate, "TOP",0,2)
    newPlate.name:SetPoint("LEFT", newPlate,-2,0)
    newPlate.name:SetPoint("RIGHT", newPlate,2,0)
    newPlate.name:SetFont(STANDARD_TEXT_FONT,11,"THINOUTLINE")
    plate._name = newPlate.name
    --raid icon
    plate.raid:SetParent(newPlate)
    plate.raid:ClearAllPoints()
    plate.raid:SetSize(cfg.raidiconSize,cfg.raidiconSize)
    plate.raid:SetPoint("BOTTOM",newPlate.name,"TOP",0,0)
    --hooks
    plate:HookScript("OnShow", NamePlateOnShow)
    plate.castbar:HookScript("OnShow", NamePlateCastbarOnShow)
    NamePlateOnShow(plate)
  end

  --IsNamePlateFrame func
  local function IsNamePlateFrame(obj)
    local name = obj:GetName()
    if name and name:find("NamePlate") then
      return true
    end
    obj.rnp_checked = true
    return false
  end

  --SearchForNamePlates func
  local function SearchForNamePlates(self)
    for _, obj in pairs({self:GetChildren()}) do
      if not obj.rnp_checked and IsNamePlateFrame(obj) then
        NamePlateInit(obj)
      end
    end
  end

  --RepositionAllNamePlates func
  local function RepositionAllNamePlates()
    RNP:Hide()
    for blizzPlate, newPlate in pairs(RNP.nameplates) do
      newPlate:Hide()
      if blizzPlate:IsShown() then
        newPlate:SetPoint("CENTER", WorldFrame, "BOTTOMLEFT", blizzPlate:GetCenter())
        newPlate:SetAlpha(blizzPlate:GetAlpha())
        newPlate:Show()
      end
    end
    RNP:Show()
  end

  --OnUpdate func
  RNP.lastUpdate = 0
  RNP.updateInterval = 1.0
  local function OnUpdate(self,elapsed)
    RNP.lastUpdate = RNP.lastUpdate + elapsed
    RepositionAllNamePlates()
    if RNP.lastUpdate > RNP.updateInterval then
      SearchForNamePlates(self)
      RNP.lastUpdate = 0
    end
  end

  -----------------------------------------
  -- INIT
  -----------------------------------------

  WorldFrame:HookScript("OnUpdate", OnUpdate)