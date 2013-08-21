
    -----------------------------------------
    -- CONFIG
    -----------------------------------------

    local cfg = {}

    cfg.width = 110
    
    cfg.healthbarHeight = 7
    cfg.castbarHeight = 7
    cfg.gap = 5
    
    cfg.iconsize = 30
    cfg.shieldsize = 16
    cfg.threatglowsize = 25
    cfg.raidiconsize = 25
    
    cfg.castbartexture = "Interface\\AddOns\\rNamePlates2\\media\\statusbar"
    cfg.healthbartexture = "Interface\\AddOns\\rNamePlates2\\media\\statusbar"
    
    cfg.backdrop = {
      bgFile = "Interface\\AddOns\\rNamePlates2\\media\\backdrop",
      edgeFile = "Interface\\AddOns\\rNamePlates2\\media\\backdrop_edge",
      tile = false,
      tileSize = 0,
      edgeSize = 4,
      insets = {
        left = 4,
        right = 4,
        top = 4,
        bottom = 4,
      },
    }

    -----------------------------------------
    -- VARIABLES
    -----------------------------------------
    
    --add a new global frame
    local RDP = CreateFrame("Frame", "PlateCollector", WorldFrame)
    RDP:SetAllPoints()
    RDP.nameplates = {}
    
    --trash can
    RDP.pastebin = CreateFrame("Frame")
    RDP.pastebin:Hide()

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

    --NameplateOnShow func
    local function NameplateOnShow(self)
      --healthbar
      self.healthbar:ClearAllPoints()
      self.healthbar:SetPoint("TOP", self.newPlate)
      self.healthbar:SetPoint("LEFT", self.newPlate)
      self.healthbar:SetPoint("RIGHT", self.newPlate)
      self.healthbar:SetHeight(cfg.healthbarHeight)
      --threat glow
      self.threat:ClearAllPoints()
      self.threat:SetPoint("BOTTOM",self.healthbar,"TOP")
      self.threat:SetPoint("LEFT", self.healthbar)
      self.threat:SetPoint("RIGHT", self.healthbar)
      self.threat:SetHeight(cfg.threatglowsize)
      --unit name
      self.unitName = self.name:GetText()
      --update the name and level strings
      local hexColor = GetHexColor(GetLevelColor(self)) or "ffffff"
      local name = self.unitName or "Unknown"
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

    --NameplateCastbarOnShow func
    local function NameplateCastbarOnShow(self)
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
        self.shield:SetPoint("BOTTOM",self.icon,0,-cfg.shieldsize/2+2)
        self.shield:SetSize(cfg.shieldsize,cfg.shieldsize)   
        self.iconBorder:SetDesaturated(1)
        self:SetStatusBarColor(0.8,0.8,0.8)
      else
        self.iconBorder:SetDesaturated(0)
      end
    end

    --NameplateInit func
    local function NameplateInit(plate)
      --add some references
      --print(plate:GetName().." init")
      plate.barFrame, plate.nameFrame = plate:GetChildren()
      plate.healthbar, plate.castbar = plate.barFrame:GetChildren()
      plate.threat, plate.border, plate.highlight, plate.level, plate.boss, plate.raid, plate.dragon = plate.barFrame:GetRegions()
      plate.name = plate.nameFrame:GetRegions()
      plate.healthbar.texture = plate.healthbar:GetRegions()
      plate.castbar.texture, plate.castbar.border, plate.castbar.shield, plate.castbar.icon, plate.castbar.name, plate.castbar.nameShadow = plate.castbar:GetRegions()
      plate.rdp_checked = true
      local icon_layer, icon_sublevel = plate.castbar.icon:GetDrawLayer()
      --create new plate and parent it to RDP
      RDP.nameplates[plate] = CreateFrame("Frame", "New"..plate:GetName(), RDP)
      local newPlate = RDP.nameplates[plate]
      newPlate:SetSize(cfg.width,cfg.healthbarHeight+cfg.castbarHeight+cfg.gap)
      --keep the frame reference for later
      newPlate.blizzPlate = plate
      plate.newPlate = newPlate
      --reparent
      plate.raid:SetParent(newPlate)
      plate.castbar:SetParent(newPlate)
      plate.healthbar:SetParent(newPlate)
      --change statusbar textures
      plate.castbar:SetStatusBarTexture(cfg.castbartexture)
      plate.healthbar:SetStatusBarTexture(cfg.healthbartexture)
      CreateBackdrop(plate.castbar)
      CreateBackdrop(plate.healthbar)
      --trash
      plate.nameFrame:Hide()
      plate.level:Hide()
      plate.level:SetParent(RDP.pastebin) --trash the level string, it will come back OnShow and OnDrunk otherwise ;)
      --reparent raid mark
      plate.raid:ClearAllPoints()
      plate.raid:SetSize(cfg.raidiconsize,cfg.raidiconsize)
      --hide textures
      plate.dragon:SetTexture(nil)
      plate.border:SetTexture(nil)
      plate.boss:SetTexture(nil)
      plate.highlight:SetTexture(nil)
      plate.castbar.border:SetTexture(nil)
      --castbar icon
      plate.castbar.icon:SetTexCoord(0.1,0.9,0.1,0.9)
      plate.castbar.icon:SetSize(cfg.iconsize,cfg.iconsize)
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
      plate.castbar.shield:SetDrawLayer(icon_layer, icon_sublevel+2)
      --castbar icon border
      plate.castbar.iconBorder = plate.castbar:CreateTexture(nil, icon_layer, nil, icon_sublevel+1)
      plate.castbar.iconBorder:SetTexture("Interface\\AddOns\\rNamePlates2\\media\\castbar_icon_border")
      plate.castbar.iconBorder:SetPoint("TOPLEFT",plate.castbar.icon,"TOPLEFT",-2,2)
      plate.castbar.iconBorder:SetPoint("BOTTOMRIGHT",plate.castbar.icon,"BOTTOMRIGHT",2,-2)
      --threat glow
      plate.threat:SetTexture("Interface\\AddOns\\rNamePlates2\\media\\threat_glow")
      plate.threat:SetTexCoord(0,1,0,1)
      --new name string
      newPlate.name = newPlate:CreateFontString(nil,"BORDER")
      newPlate.name:SetPoint("BOTTOM", newPlate, "TOP",0,2)
      newPlate.name:SetPoint("LEFT", newPlate,-2,0)
      newPlate.name:SetPoint("RIGHT", newPlate,2,0)
      newPlate.name:SetFont(STANDARD_TEXT_FONT,11,"THINOUTLINE")
      plate._name = newPlate.name
      plate.raid:SetPoint("BOTTOM",plate._name,"TOP",0,0)
      --hooks
      plate:HookScript("OnShow", NameplateOnShow)
      plate.castbar:HookScript("OnShow", NameplateCastbarOnShow)
      NameplateOnShow(plate)
    end

    --IsNameplateFrame func
    local function IsNameplateFrame(obj)
      local name = obj:GetName()
      if name and name:find("NamePlate") then
        return true
      end
      obj.rdp_checked = true
      return false
    end

    --SearchForNameplates func
    local function SearchForNameplates(self)
      for _, obj in pairs({self:GetChildren()}) do
        if not obj.rdp_checked and IsNameplateFrame(obj) then
          NameplateInit(obj)
        end
      end
    end

    --RepositionAllNameplates func
    local function RepositionAllNameplates()
      RDP:Hide()
      for blizzPlate, newPlate in pairs(RDP.nameplates) do
        newPlate:Hide()
        if blizzPlate:IsShown() then
          newPlate:SetPoint("CENTER", WorldFrame, "BOTTOMLEFT", blizzPlate:GetCenter())
          newPlate:SetAlpha(blizzPlate:GetAlpha())
          newPlate:Show()
        end
      end
      RDP:Show()
    end

    --OnUpdate func
    RDP.lastUpdate = 0
    RDP.updateInterval = 1.0
    local function OnUpdate(self,elapsed)
      RDP.lastUpdate = RDP.lastUpdate + elapsed
      RepositionAllNameplates()
      if RDP.lastUpdate > RDP.updateInterval then
        SearchForNameplates(self)
        RDP.lastUpdate = 0
      end
    end

    -----------------------------------------
    -- INIT
    -----------------------------------------

    WorldFrame:HookScript("OnUpdate", OnUpdate)