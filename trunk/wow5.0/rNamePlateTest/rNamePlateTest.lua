
    --if 1 == 1 then return end

    -----------------------------------------
    -- CONFIG
    -----------------------------------------

    local cfg = {}

    cfg.width = 100
    cfg.height = 26

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

    local function RGBPercToHex(r, g, b)
      r = r <= 1 and r >= 0 and r or 0
      g = g <= 1 and g >= 0 and g or 0
      b = b <= 1 and b >= 0 and b or 0
      return string.format("%02x%02x%02x", r*255, g*255, b*255)
    end

    local function FixColor(color)
      color.r,color.g,color.b = floor(color.r*100+.5)/100, floor(color.g*100+.5)/100, floor(color.b*100+.5)/100
    end

    --NamePlateOnShow func
    local function NamePlateOnShow(self)
      --new plate
      local newPlate = self.healthbar:GetParent()
      --hide level
      self.level:Hide()
      --healthbar
      self.healthbar:ClearAllPoints()
      self.healthbar:SetPoint("TOP", newPlate)
      self.healthbar:SetPoint("LEFT", newPlate)
      self.healthbar:SetPoint("RIGHT", newPlate)
      self.healthbar:SetHeight(newPlate.height/2)
      --name
      self.name:ClearAllPoints()
      self.name:SetPoint("BOTTOM", newPlate, "TOP")
      self.name:SetPoint("LEFT", newPlate,-10,0)
      self.name:SetPoint("RIGHT", newPlate,10,0)
      self.name:SetFont(STANDARD_TEXT_FONT,11,"THINOUTLINE")
      self.realName = self.name:GetText()
    end

    --NamePlateCastbarOnShow func
    local function NamePlateCastbarOnShow(self)
        --new plate
        local newPlate = self:GetParent()
        --castbar
        self:ClearAllPoints()
        self:SetPoint("BOTTOM",newPlate)
        self:SetPoint("LEFT",newPlate)
        self:SetPoint("RIGHT",newPlate)
        self:SetHeight(newPlate.height/2)
        --castbar icon
        self.icon:ClearAllPoints()
        self.icon:SetPoint("RIGHT",newPlate, "LEFT")
    end

    --NamePlateNameUpdate func
    local function NamePlateNameUpdate(self)
      if not self.realName then return end
      local cs = RGBPercToHex(self.level:GetTextColor())
      --name string
      local name = self.realName
      local level = self.level:GetText()
      if self.boss:IsShown() == 1 then
        level = "??"
        cs = "ff6600"
      elseif self.dragon:IsShown() == 1 then
        level = level.."+"
      end
      self.name:SetText("|cff"..cs..""..level.."|r "..name)
      self.level:Hide()
    end

    --NamePlateHealthBarUpdate func
    local function NamePlateHealthBarUpdate(self)
      local color = {}
      if self.threat:IsShown() then
        color.r, color.g, color.b = self.threat:GetVertexColor()
        FixColor(color)
        if color.r+color.g+color.b < 3 then
          self.healthbar:SetStatusBarColor(color.r,color.g,color.b)
          return
        end
      end
      color.r, color.g, color.b = self.healthbar:GetStatusBarColor()
      FixColor(color)
      for class, _ in pairs(RAID_CLASS_COLORS) do
        if RAID_CLASS_COLORS[class].r == color.r and RAID_CLASS_COLORS[class].g == color.g and RAID_CLASS_COLORS[class].b == color.b then
          self.healthbar:SetStatusBarColor(RAID_CLASS_COLORS[class].r,RAID_CLASS_COLORS[class].g,RAID_CLASS_COLORS[class].b)
          return --no color change needed, bar is in class color
        end
      end
      if color.g+color.b == 0 then -- hostile
        self.healthbar:SetStatusBarColor(FACTION_BAR_COLORS[2].r,FACTION_BAR_COLORS[2].g,FACTION_BAR_COLORS[2].b)
        return
      elseif color.r+color.b == 0 then -- friendly npc
        self.healthbar:SetStatusBarColor(FACTION_BAR_COLORS[6].r,FACTION_BAR_COLORS[6].g,FACTION_BAR_COLORS[6].b)
        return
      elseif color.r+color.g == 2 then -- neutral
        self.healthbar:SetStatusBarColor(FACTION_BAR_COLORS[4].r,FACTION_BAR_COLORS[4].g,FACTION_BAR_COLORS[4].b)
        return
      elseif color.r+color.g == 0 then -- friendly player, we don't like 0,0,1 so we change it to a more likable color
        self.healthbar:SetStatusBarColor(0/255, 100/255, 255/255)
        return
      else -- enemy player
        --whatever is left
        return
      end
    end

    --NamePlateInit func
    local function NamePlateInit(plate)
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
      plate:HookScript("OnShow", NamePlateOnShow)
      --nameplate castbar on show hook
      plate.castbar:HookScript("OnShow", NamePlateCastbarOnShow)
      --i fix
      NamePlateOnShow(plate)
      --debug
      --local t = plate:CreateTexture()
      --t:SetTexture(1,0,0,0.3)
      --t:SetAllPoints()
    end

    --IsNamePlateFrame func
    local function IsNamePlateFrame(obj)
      local name = obj:GetName()
      if name and name:find("NamePlate") then
        return true
      end
      obj.rdp_checked = true
      return false
    end

    --SearchForNamePlates func
    local function SearchForNamePlates(self)
      local currentChildren = self:GetNumChildren()
      if not currentChildren or currentChildren == 0 then return end
      for _, obj in pairs({self:GetChildren()}) do
        if not obj.rdp_checked and IsNamePlateFrame(obj) then
          NamePlateInit(obj)
        end
      end
    end

    --NamePlateOnUpdate func
    local function NamePlateOnUpdate()
      RDP:Hide()
      for blizzPlate, newPlate in pairs(RDP.nameplates) do
          newPlate:Hide()
          if blizzPlate:IsShown() then
            newPlate:SetPoint("CENTER", WorldFrame, "BOTTOMLEFT", blizzPlate:GetCenter())
            newPlate:SetAlpha(blizzPlate:GetAlpha())
            NamePlateNameUpdate(blizzPlate)
            NamePlateHealthBarUpdate(blizzPlate)
            newPlate:Show()
          end
      end
      RDP:Show()
    end

    --OnUpdate func
    local function OnUpdate(self)
      SearchForNamePlates(self)
      NamePlateOnUpdate()
    end

    -----------------------------------------
    -- INIT
    -----------------------------------------

    WorldFrame:HookScript("OnUpdate", OnUpdate)