local select = select
local UnitIsPlayer = UnitIsPlayer
local UnitIsDead = UnitIsDead
local UnitIsGhost = UnitIsGhost
local UnitIsConnected = UnitIsConnected
local RAID_CLASS_COLORS = RAID_CLASS_COLORS
local UnitClass = UnitClass
local UnitReactionColor = UnitReactionColor
local UnitReaction = UnitReaction
local UnitLevel = UnitLevel
local GetPetHappiness = GetPetHappiness
local UnitClassification = UnitClassification
local SetRaidTargetIconTexture = SetRaidTargetIconTexture

local tex = "Interface\\AddOns\\rTextures\\statusbar"

local menu = function(self)
	local unit = self.unit:sub(1, -2)
	local cunit = self.unit:gsub("(.)", string.upper, 1)

	if(unit == "party" or unit == "partypet") then
		ToggleDropDownMenu(1, nil, _G["PartyMemberFrame"..self.id.."DropDown"], "cursor", 0, 0)	
	elseif(_G[cunit.."FrameDropDown"]) then
		ToggleDropDownMenu(1, nil, _G[cunit.."FrameDropDown"], "cursor", 0, 0)
	end
end

local updateName = function(self, unit)
	if(self.unit ~= unit) then return end
	local name = UnitName(unit)
    local lvl = UnitLevel(unit)

	if(UnitIsTapped(unit) and not UnitIsTappedByPlayer(unit) or not UnitIsConnected(unit)) then
		self.Name:SetTextColor(.5, .5, .5)	
	else
		--local color = UnitIsPlayer(unit) and RAID_CLASS_COLORS[select(2, UnitClass(unit))] or UnitReactionColor[UnitReaction(unit, "player")]
		local color = UnitIsPlayer(unit) and RAID_CLASS_COLORS[select(2, UnitClass(unit))]
		--if(color) then self:SetStatusBarColor(color.r, color.g, color.b) end
		if(color) then 
		  self.Name:SetTextColor(color.r, color.g, color.b) 
		else
		  self.Name:SetTextColor(1, 1, 1)
		end
	end
    
    if(unit == "target") then
		if(UnitClassification(unit)=="worldboss") then
            self.Name:SetText(name.." |cffffffffBoss|r")
        elseif(UnitClassification(unit)=="rareelite") then
            self.Name:SetText(name.." |cffffffff"..lvl.."+ Rare|r")
        elseif(UnitClassification(unit)=="elite") then
            self.Name:SetText(name.." |cffffffff"..lvl.."+|r")
        elseif(UnitClassification(unit)=="rare") then
            self.Name:SetText(name.." |cffffffff"..lvl.." Rare|r")
        else
            self.Name:SetText(name.." |cffffffff"..lvl.."|r")
        end
	else
        self.Name:SetText(name)
    end
end

local updateHealth = function(self, object, unit, min, max)
	local c = max - min
	local d = floor(min/max*100)

	if(UnitIsDead(unit)) then
		self:SetValue(0)
		self.value:SetText"Dead"
	elseif(UnitIsGhost(unit)) then
		self:SetValue(0)
		self.value:SetText"Ghost"
	elseif(not UnitIsConnected(unit)) then
		self.value:SetText"Offline"
	elseif(UnitIsEnemy("player",unit)) then
		if(c > 0) then
			self.value:SetText(max-c.."|cffffffff%|r")
		else
			self.value:SetText(max.."|cffffffff%|r")
		end
	elseif(unit == "pet")then
		if(c > 0) then
			self.value:SetText(max-c.." |cffffffff/ |r"..max)
		else
			self.value:SetText(max)
		end
	elseif(UnitIsPlayer(unit)) then
	  self.value:SetText(min.." - "..d.."%")
	else
        self.value:SetText(d.."%")
        --[[
        if(c > 0) then
            self.value:SetText("-"..c)
        else
            self.value:SetText(max)
        end    
        --]]
	end

  --[[
	if(UnitIsTapped(unit) and not UnitIsTappedByPlayer(unit) or not UnitIsConnected(unit)) then
		object.Name:SetTextColor(.5, .5, .5)
		object.Power:SetStatusBarColor(.5, .5, .5)
	else
		object:UpdateName(unit)
	end
	
	if(UnitIsTapped(unit) and not UnitIsTappedByPlayer(unit) or not UnitIsConnected(unit)) then
		self:SetStatusBarColor(.6, .6, .6)
	elseif(unit == "pet") then
        local happiness = pUF.colors.happiness
		local color = happiness[GetPetHappiness()]
        if(color) then self:SetStatusBarColor(color.r, color.g, color.b) end
	else
		local color = UnitIsPlayer(unit) and RAID_CLASS_COLORS[select(2, UnitClass(unit))] or UnitReactionColor[UnitReaction(unit, "player")]
		if(color) then self:SetStatusBarColor(color.r, color.g, color.b) end
	end
	
	]]--

	object.Name:SetTextColor(1, 1, 1)
	self:SetStatusBarColor(0.14, .14, 0.14)
	
	if(UnitIsTapped(unit) and not UnitIsTappedByPlayer(unit) or not UnitIsConnected(unit)) then
		--object.Name:SetTextColor(.5, .5, .5)
		--object.Power:SetStatusBarColor(.5, .5, .5)
		self:SetStatusBarColor(.6, .6, .6)
	elseif(unit == "pet") then
    local happiness = pUF.colors.happiness
		local color = happiness[GetPetHappiness()]
    --if(color) then self:SetStatusBarColor(color.r, color.g, color.b) end
    if(color) then object.Name:SetTextColor(color.r, color.g, color.b) end
	else
		local color = UnitIsPlayer(unit) and RAID_CLASS_COLORS[select(2, UnitClass(unit))] or UnitReactionColor[UnitReaction(unit, "player")]
		--if(color) then self:SetStatusBarColor(color.r, color.g, color.b) end
		if(color) then object.Name:SetTextColor(color.r, color.g, color.b) end
	end

	object:UpdateName(unit)
	
end

local updatePower = function(self, object, unit, min, max)
	if(min < 0) then
		self.value:SetText()
	elseif(UnitIsDead(unit)) then
		self:SetValue(0)
	elseif(UnitIsGhost(unit)) then
		self:SetValue(0)
	elseif(not UnitIsConnected(unit)) then
		self:SetValue(0)
	elseif(unit == "player") then
        local c = max - min
        self.value:SetText(min.." - ")
        --[[
        if(c > 0) then
            self.value:SetText(max-c)
        else
            self.value:SetText(max)
        end
        ]]--
    else
		local c = max - min
		if(c > 0) then
			self.value:SetText(max-c.." |cffffffff- ")
		else
			self.value:SetText(max.." |cffffffff- ")
		end
	end
    
	--[[if(UnitIsTapped(unit) and not UnitIsTappedByPlayer(unit) or not UnitIsConnected(unit)) then
		self:SetStatusBarColor(.6, .6, .6)
	elseif(unit == "pet") then
        local happiness = pUF.colors.happiness
		local color = happiness[GetPetHappiness()]
        if(color) then self:SetStatusBarColor(color.r, color.g, color.b) end
	else
		local color = UnitIsPlayer(unit) and RAID_CLASS_COLORS[select(2, UnitClass(unit))] or UnitReactionColor[UnitReaction(unit, "player")]
		if(color) then self:SetStatusBarColor(color.r, color.g, color.b) end
	end
	]]--
end

local func = function(settings, self, unit)
	self.numBuffs = 36
	self.menu = menu

	self:EnableMouse(true)

	self:SetHeight(30)
	self:SetWidth(230)

	self:SetScript("OnEnter", UnitFrame_OnEnter)
	self:SetScript("OnLeave", UnitFrame_OnLeave)

	self:RegisterForClicks"anyup"
	self:SetAttribute("*type2", "menu")

	self:SetBackdrop{
		bgFile = "Interface\\Tooltips\\UI-Tooltip-Background", tile = true, tileSize = 16,
		insets = {left = -2, right = -2, top = -2, bottom = -2},
	}
	self:SetBackdropColor(0, 0, 0, 1)

	local hp = CreateFrame"StatusBar"
	hp:SetHeight(22)
	hp:SetStatusBarTexture(tex)
--	hp:SetStatusBarColor(1, 1, .95)
	hp:SetStatusBarColor(0, 1, 0)

	hp:SetParent(self)
	hp:SetPoint"TOP"
	hp:SetPoint"LEFT"
	hp:SetPoint"RIGHT"

	local hpbg = hp:CreateTexture(nil, "BORDER")
	hpbg:SetAllPoints(hp)
	hpbg:SetTexture(tex)
	hpbg:SetBlendMode("BLEND")
	hpbg:SetAlpha(0.3)
	--hpbg:SetTexture(.25, .25, .25, 1)

	local hpp = hp:CreateFontString(nil, "OVERLAY")
	hpp:SetPoint("RIGHT", -3, 0)
	hpp:SetFontObject(GameFontNormal)
	hpp:SetTextColor(1, 1, 1)

	hp.func = updateHealth
	hp.bg = hpbg
	hp.value = hpp
	self.Health = hp

	local pp = CreateFrame"StatusBar"
	pp:SetHeight(7)
	pp:SetStatusBarTexture(tex)
	pp:SetStatusBarColor(0.5, 0.5, 0.5)

	pp:SetParent(self)
	pp:SetPoint"LEFT"
	pp:SetPoint"RIGHT"
	pp:SetPoint("TOP", hp, "BOTTOM", 0, -1.35)

	local ppbg = pp:CreateTexture(nil, "BORDER")
	ppbg:SetAllPoints(pp)
	ppbg:SetTexture(tex)
	ppbg:SetBlendMode("BLEND")
	ppbg:SetAlpha(0.3)
	--ppbg:SetTexture(.25, .25, .25, 1)

	local ppp = pp:CreateFontString(nil, "OVERLAY")
	ppp:SetPoint("RIGHT", hpp, "LEFT")
	ppp:SetFontObject(GameFontNormal)
    ppp:SetTextColor(1, 1, 1)
    
	pp.func = updatePower
	pp.value = ppp
	pp.bg = ppbg
	self.Power = pp

	local name = hp:CreateFontString(nil, "OVERLAY")
	name:SetPoint("LEFT", hp, 3, 0)
	name:SetPoint("RIGHT", ppp, "LEFT")
	name:SetJustifyH"LEFT"
	name:SetFontObject(GameFontNormal)
	name:SetTextColor(1, 1, 1)
	self.Name = name
	self.UpdateName = updateName

	local leader = hp:CreateTexture(nil, "OVERLAY")
	leader:SetTexture"Interface\\GROUPFRAME\\UI-Group-LeaderIcon"
	leader:SetWidth(16)
	leader:SetHeight(16)
	leader:SetPoint("TOPLEFT", hp, 0, 8)
	self.Leader = leader

	local icon = hp:CreateTexture(nil, "OVERLAY")
	icon:SetTexture"Interface\\TargetingFrame\\UI-RaidTargetingIcons"
	icon:SetWidth(18)
	icon:SetHeight(18)
	icon:SetPoint("TOP", hp, 0, 8)
	self.RaidIcon = icon

	if(self:GetParent():GetName()=="pUF_Party") then
		self.numDebuffs = 3
		
		local debuffs = CreateFrame("Frame", nil, self)
		debuffs:SetHeight(self:GetHeight())
		debuffs:SetWidth(30)
		debuffs:SetPoint("TOPLEFT", self, "TOPRIGHT", 4, -2)
    debuffs.size = 20
		self.Debuffs = debuffs
        
		self:SetWidth(100)
		self:SetHeight(23)
		hp:SetHeight(18)
		pp:SetHeight(4)
		ppp:Hide()
		--hpp:Hide()
		
	end

	if(self:GetParent():GetName()=="pUF_Raid") then
		self.numDebuffs = 3
		
		local debuffs = CreateFrame("Frame", nil, self)
		debuffs:SetHeight(self:GetHeight())
		debuffs:SetWidth(30)
		debuffs:SetPoint("TOPLEFT", self, "TOPRIGHT", 4, 0)
		debuffs.size = 20
		self.Debuffs = debuffs

		self:SetWidth(100)
		self:SetHeight(23)
		hp:SetHeight(18)
		pp:SetHeight(4)
		pp:Hide()
		ppp:Hide()
		ppp:Hide()
		hpp:Hide()
		name:SetPoint("RIGHT", hp, "RIGHT")

	end

	if(unit and unit == "targettarget") then
		self.numDebuffs = 0
		
		self:SetWidth(100)
		self:SetHeight(23)
		hp:SetHeight(18)
		pp:SetHeight(4)
		ppp:Hide()
		hpp:Hide()
		name:SetPoint("RIGHT", hp, "RIGHT")

		--[[
		local debuffs = CreateFrame("Frame", nil, self)
		debuffs:SetHeight(self:GetHeight())
		debuffs:SetWidth(30)
		debuffs:SetPoint("TOPLEFT", self, "TOPRIGHT", 1, 1)
		debuffs.size = 24
		self.Debuffs = debuffs
		]]--
		
	end

	if(unit and unit == "player") then
		
		--name:Show()
		
		self:SetWidth(223)
		self:SetHeight(23)
		hp:SetHeight(18)
		pp:SetHeight(4)
		
		--ppp:Show()
		
		--ppp:SetPoint("LEFT", hp, "LEFT", 3, 0)
		--ppp:SetJustifyH"LEFT"
		
		self.numDebuffs = 40
		
		local debuffs = CreateFrame("Frame", nil, self)
		debuffs:SetHeight(self:GetHeight())
		debuffs:SetWidth(30)
		debuffs:SetPoint("TOPLEFT", self, "BOTTOMLEFT", -5, -5)
		debuffs.size = 20
		self.Debuffs = debuffs
		
		local buffs = CreateFrame("Frame", nil, self)
		buffs:SetHeight(self:GetHeight())
		buffs:SetWidth(30)
		buffs:SetPoint("BOTTOMLEFT", self, "TOPLEFT", -5, 5)
		buffs.size = 20
		self.Buffs = buffs
		
		
	end

	if(unit and unit == "pet") then
		self.numDebuffs = 0
		
		self:SetWidth(100)
		self:SetHeight(23)
		hp:SetHeight(18)
		pp:SetHeight(4)
		--name:Hide()
		hpp:Hide()
		ppp:Hide()
    name:SetPoint("RIGHT", hp, "RIGHT")

		local debuffs = CreateFrame("Frame", nil, self)
		debuffs:SetHeight(self:GetHeight())
		debuffs:SetWidth(30)
		debuffs:SetPoint("TOPLEFT", self, "BOTTOMLEFT", 0, -4)
		debuffs.size = 20
		self.Debuffs = debuffs
	end
	
	if(unit and unit == "target") then
		self.numDebuffs = 40
		
		self:SetWidth(223)
		self:SetHeight(23)
		hp:SetHeight(18)
		pp:SetHeight(4)
		ppp:Hide()
	
		local debuffs = CreateFrame("Frame", nil, self)
		debuffs:SetHeight(self:GetHeight())
		debuffs:SetWidth(30)
		debuffs:SetPoint("TOPLEFT", self, "BOTTOMLEFT", -5, -5)
		debuffs.size = 20
		self.Debuffs = debuffs
		
		local buffs = CreateFrame("Frame", nil, self)
		buffs:SetHeight(self:GetHeight())
		buffs:SetWidth(30)
		buffs:SetPoint("BOTTOMLEFT", self, "TOPLEFT", -5, 5)
		buffs.size = 20
		self.Buffs = buffs

		--[[
		local cpoints = self:CreateFontString(nil, "OVERLAY")
		cpoints:SetPoint("RIGHT", self, "LEFT", -9, 1)
		cpoints:SetFont(DAMAGE_TEXT_FONT, 38)
		cpoints:SetTextColor(1, 1, 1)
		cpoints:SetJustifyH"RIGHT"
		self.CPoints = cpoints
		]]--
	end
    
    if(unit and unit == "focus") then
		
		self:SetWidth(100)
		self:SetHeight(23)
		hp:SetHeight(18)
		pp:SetHeight(4)
		--name:Hide()
		hpp:Hide()
		ppp:Hide()
		name:SetPoint("RIGHT", hp, "RIGHT")

		self.numDebuffs = 0

		local debuffs = CreateFrame("Frame", nil, self)
		debuffs:SetHeight(self:GetHeight())
		debuffs:SetWidth(30)
		debuffs:SetPoint("TOPLEFT", self, "TOPRIGHT", 4, .5)
		debuffs.size = 22
		self.Debuffs = debuffs
    end
    
	return self
end

pUF:RegisterStyle("Pelim", setmetatable({
	rpoint = "BOTTOM",
	rsortDir = "DESC",
	ryOffset = 5,
  --rgroupFilter = "WARRIOR,ROGUE,DRUID,PALADIN,SHAMAN,PRIEST,MAGE,WARLOCK,HUNTER",
  --rgroupBy = "CLASS",
  --rgroupingOrder = "WARRIOR,ROGUE,DRUID,PALADIN,SHAMAN,PRIEST,MAGE,WARLOCK,HUNTER", 
	["raid-width"] = 100,
	["raid-height"] = 18,
    
    -- new party
    point = "BOTTOM",
	sortDir = "DESC",
	yOffset = 10,
	["initial-width"] = 140,
	["initial-height"] = 23,
}, {__call = func}))

local player 	= pUF:Spawn("player", "pUF_Player")
local target 	= pUF:Spawn("target", "pUF_Target")
local tot 		= pUF:Spawn"targettarget"
local pet 		= pUF:Spawn"pet"
local focus   = pUF:Spawn"focus"
local party 	= pUF:Spawn"party"
local raid 		= pUF:Spawn"raid"

player:SetPoint("CENTER", -230, -150)
--target:SetPoint("CENTER", 220, -250)
target:SetPoint("LEFT", player, "RIGHT", 240, 0)
tot:SetPoint("RIGHT", target, "LEFT", -10, 0)
pet:SetPoint("LEFT", player, "RIGHT", 10, 0)
--focus:SetPoint("RIGHT", player, "LEFT", -10, 0)
focus:SetPoint("LEFT", player, "RIGHT", 10, 0)
party:SetPoint("TOPLEFT", 15, -15)
raid:SetPoint("TOPLEFT", 15, -15)

local temptoggle = CreateFrame"Frame"
temptoggle:SetScript("OnEvent", function(self, event, ...)
    if GetNumRaidMembers() > 1 then
        if GetNumRaidMembers() > 30 then
            raid:Hide()
			party:Hide()
        elseif GetNumRaidMembers() < 31 then
            party:Hide()
            raid:Show()
        end
    elseif GetNumPartyMembers() > 1  then
        party:Show()
    end
end)
temptoggle:RegisterEvent"PARTY_MEMBERS_CHANGED"
temptoggle:RegisterEvent"PARTY_LEADER_CHANGED"
temptoggle:RegisterEvent"RAID_ROSTER_UPDATE"
temptoggle:RegisterEvent"PLAYER_LOGIN"