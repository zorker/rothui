
    --if 1 == 1 then return end

    -----------------------------------------
    -- CONFIG
    -----------------------------------------

    local cfg = {}

    cfg.width = 100
    cfg.height = 26

    cfg.colors = {
      castbar = {
        default   = { r = 1, g = 0.6, b = 0 },
        shield    = { r = 0.8, g = 0.8, b = 0.8 },
      },
    }


    -----------------------------------------
    -- VARIABLES
    -----------------------------------------

    --add a new global frame
    local RDP = CreateFrame("Frame", "PlateCollector", WorldFrame)
    RDP:SetAllPoints()
    RDP.nameplates = {}

    local RAID_CLASS_COLORS = RAID_CLASS_COLORS
    local FACTION_BAR_COLORS = FACTION_BAR_COLORS
    local unpack = unpack

    -----------------------------------------
    -- FUNCTIONS
    -----------------------------------------

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
      elseif color.r+color.g > 1.95 then -- neutral
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
      return RGBPercToHex(unpack(color))
    end

    --NameplateNameUpdate func
    local function NameplateNameUpdate(self)
      local hexColor = GetHexColor(GetLevelColor(self))
      local name = self._name or "Unknown"
      local level = self.level:GetText()
      if self.boss:IsShown() then
        level = "??"
        hexColor = "ff6600"
      elseif self.dragon:IsShown() then
        level = level.."+"
      end
      local color = GetHealthbarColor(self)
      CalculateClassFactionColor(color)
      self.name:SetTextColor(unpack(color))
      self.name:SetText("|cff"..hexColor..""..level.."|r "..name)
      --hide level
      self.level:Hide()
    end

    --NameplateOnShow func
    local function NameplateOnShow(self)
      --healthbar
      self.healthbar:ClearAllPoints()
      self.healthbar:SetPoint("TOP", self.newPlate)
      self.healthbar:SetPoint("LEFT", self.newPlate)
      self.healthbar:SetPoint("RIGHT", self.newPlate)
      self.healthbar:SetHeight(self.newPlate.height/2)
      --name
      self.name:ClearAllPoints()
      self.name:SetPoint("BOTTOM", self.newPlate, "TOP")
      self.name:SetPoint("LEFT", self.newPlate,-10,0)
      self.name:SetPoint("RIGHT", self.newPlate,10,0)
      self.name:SetFont(STANDARD_TEXT_FONT,11,"THINOUTLINE")
      self._name = self.name:GetText()
      --update the name and level strings
      NameplateNameUpdate(self)
    end

    --NameplateCastbarOnShow func
    local function NameplateCastbarOnShow(self)
      local newPlate = self:GetParent()
      --castbar
      self:ClearAllPoints()
      self:SetPoint("BOTTOM", newPlate)
      self:SetPoint("LEFT", newPlate)
      self:SetPoint("RIGHT", newPlate)
      self:SetHeight(newPlate.height/2)
      --castbar icon
      self.icon:ClearAllPoints()
      self.icon:SetPoint("RIGHT", newPlate, "LEFT")
      --shielded cast
      if self.shield:IsShown() then
        self:SetStatusBarColor(0.8,0.8,0.8)
      else
        --self:SetStatusBarColor(1,0.6,0)
      end
    end

    --NameplateCastbarOnValueChanged func
    local function NameplateCastbarOnValueChanged(self)
      local newPlate = self:GetParent()
      print(newPlate:GetName().." Castbar OnValueChanged")
      print(self:GetMinMaxValues())
    end

    --NameplateInit func
    local function NameplateInit(plate)
      --add some references
      plate.barFrame, plate.nameFrame = plate:GetChildren()
      plate.healthbar, plate.castbar = plate.barFrame:GetChildren()
      plate.threat, plate.border, plate.highlight, plate.level, plate.boss, plate.raid, plate.dragon = plate.barFrame:GetRegions()
      plate.name = plate.nameFrame:GetRegions()
      plate.healthbar.texture = plate.healthbar:GetRegions()
      plate.castbar.texture, plate.castbar.border, plate.castbar.shield, plate.castbar.icon, plate.castbar.name, plate.castbar.nameShadow = plate.castbar:GetRegions()
      plate.rdp_checked = true
      --create new plate and parent it to RDP
      RDP.nameplates[plate] = CreateFrame("Frame", "New"..plate:GetName(), RDP)
      RDP.nameplates[plate]:SetSize(cfg.width,cfg.height)
      RDP.nameplates[plate].width, RDP.nameplates[plate].height = RDP.nameplates[plate]:GetSize()
      --keep the frame reference for later
      RDP.nameplates[plate].blizzPlate = plate
      plate.newPlate = RDP.nameplates[plate]
      --reparent
      plate.raid:SetParent(RDP.nameplates[plate])
      plate.nameFrame:SetParent(RDP.nameplates[plate])
      plate.castbar:SetParent(RDP.nameplates[plate])
      plate.healthbar:SetParent(RDP.nameplates[plate])
      --reparent raid mark
      plate.raid:ClearAllPoints()
      plate.raid:SetPoint("BOTTOM",RDP.nameplates[plate],"TOP")
      --hide level
      plate.level:Hide()
      --hide textures
      plate.dragon:SetTexture(nil)
      plate.border:SetTexture(nil)
      plate.boss:SetTexture(nil)
      plate.highlight:SetTexture(nil)
      plate.castbar.border:SetTexture(nil)
      plate.castbar.shield:SetTexture(nil)
      plate.threat:SetTexture(nil)
      --plate.castbar.nameShadow:SetTexture(nil)
      --healthbar bg
      plate.healthbar.bg = plate.healthbar:CreateTexture(nil,"BACKGROUND",nil,-8)
      plate.healthbar.bg:SetTexture(0,0,0,1)
      plate.healthbar.bg:SetAllPoints()
      --name
      plate.name:SetFont(STANDARD_TEXT_FONT,11,"THINOUTLINE")
      plate.name:SetShadowColor(0,0,0,0)
      --castbar icon
      plate.castbar.icon:SetTexCoord(0.1,0.9,0.1,0.9)
      plate.castbar.icon:SetSize(RDP.nameplates[plate].height,RDP.nameplates[plate].height)
      --castbar bg
      plate.castbar.bg = plate.castbar:CreateTexture(nil,"BACKGROUND",nil,-8)
      plate.castbar.bg:SetTexture(0,0,0,1)
      plate.castbar.bg:SetAllPoints()
      --castbar spellname
      plate.castbar.name:ClearAllPoints()
      plate.castbar.name:SetPoint("BOTTOM",plate.castbar,0,-5)
      plate.castbar.name:SetPoint("LEFT",plate.castbar,5,0)
      plate.castbar.name:SetPoint("RIGHT",plate.castbar,-5,0)
      plate.castbar.name:SetFont(STANDARD_TEXT_FONT,10,"THINOUTLINE")
      plate.castbar.name:SetShadowColor(0,0,0,0)
      --nameplate on show hook
      plate:HookScript("OnShow", NameplateOnShow)
      --nameplate castbar on show hook
      plate.castbar:HookScript("OnShow", NameplateCastbarOnShow)
      --plate.castbar:HookScript("OnValueChanged", NameplateCastbarOnValueChanged)
      --i fix
      NameplateOnShow(plate)
      --debug
      for i = 1, 100 do
        local fs = plate:CreateFontString(nil, nil, "GameFontNormalHuge")
        fs:SetText("BLIZZPLATE")
        fs:SetPoint("CENTER", math.random(-50,50), math.random(-12,12))
      end
      for i = 1, 100 do
        local fs = RDP.nameplates[plate]:CreateFontString(nil, nil, "GameFontNormalHuge")
        fs:SetText("NEWPLATE")
        fs:SetPoint("CENTER", math.random(-50,50), math.random(-12,12))
      end
    end

    --IsNameplateFrame func
    local function IsNameplateFrame(obj)
      local name = obj:GetName()
      if name and name:find("Nameplate") then
        return true
      end
      obj.rdp_checked = true
      return false
    end

    --SearchForNameplates func
    local function SearchForNameplates(self)
      for _, child in pairs({self:GetChildren()}) do
        if child.rdp_checked then return end
        if IsNameplateFrame(child) then
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
          local scale, x, y = blizzPlate:GetScale(), blizzPlate:GetCenter()
          newPlate:SetPoint("CENTER", WorldFrame, "BOTTOMLEFT", x*scale, y*scale)
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