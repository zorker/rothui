local ADDON, engine  = ...

--NoTroll = engine

local db = {
	[2825]   = true, -- Bloodlust
	[32182]  = true, -- Heroism
	[80353]  = true, -- Time Warp
	[13159]  = true, -- Aspect of Fail
	[41450]  = true, -- Blessing of Piss me off
	[73325]  = true, -- Leap of Fail
	[34477]  = true, -- MD
	[20736]  = true, -- Distracting Shot
	[62124]  = true, -- Reckoning * paladin
	[56222]  = true, -- Dark Command
	[49576]  = true, -- Death Grip
	[2649]   = true, -- Generic hunter growl
	[39270]  = true, -- main target growl
	[103128] = true, -- suffering
}

local f = CreateFrame("Frame", nil, InterfaceOptionsFramePanelContainer)

-- Main addon logic

f:RegisterEvent("PLAYER_LOGIN")
f:SetScript("OnEvent", function(self, event)
	NoTrollDB = NoTrollDB or db
	db = NoTrollDB
	self:UnregisterEvent("PLAYER_LOGIN")

	self:RegisterEvent("UNIT_SPELLCAST_SUCCEEDED")
	self:SetScript("OnEvent", function(self, event, unit, spellName, _, _, spellID)
    if db[spellID] then
			local name = GetUnitName(unit, false) or "Unknown" -- Use true to show the realm name
			print("|cffffff9a[NoTroll]|r", name, "used", spellName)
		end
	end)
end)

-- Options panel

f:Hide()
f:SetScript("OnShow", function(self)
	local title = self:CreateFontString(nil, "ARTWORK", "GameFontNormalLarge")
	title:SetPoint("TOPLEFT", 16, -16)
	title:SetText(self.name)

	local notes = self:CreateFontString(nil, "ARTWORK", "GameFontHighlightSmall")
	notes:SetPoint("TOPLEFT", title, "BOTTOMLEFT", 0, -8)
	notes:SetPoint("RIGHT", -32, 0)
	notes:SetHeight(32)
	notes:SetJustifyH("LEFT")
	notes:SetJustifyV("TOP")
	notes:SetText(GetAddOnMetadata(ADDON, "Notes"))

	local spellNameToID, sortedSpells = {}, {}
	for id in pairs(db) do
		local name = GetSpellInfo(id)
		if name then
			spellNameToID[name] = id
			tinsert(sortedSpells, name)
		end
	end
	sort(sortedSpells)
	
	local boxes = {}
	local breakpoint = 1 + floor(#sortedSpells / 2)
	local function ClickBox(self)
		local checked = not not self:GetChecked()
		PlaySound(checked and "igMainMenuOptionCheckBoxOn" or "igMainmenuOptionCheckBoxOff")
		db[self.id] = checked
	end

	for i = 1, #sortedSpells do
		local spell = sortedSpells[i]
		
		local box = CreateFrame("CheckButton", "$parentCheckbox"..i, self, "InterfaceOptionsCheckButtonTemplate")
		box:SetScript("OnClick", ClickBox)
		box.Text:SetText(spell)
		box:SetHitRectInsets(0, -1 * max(box.Text:GetStringWidth(), 100), 0, 0) -- Make whole label clickable instead only the first 100px
		box.id = spellNameToID[spell]
		
		if i == 1 then
			box:SetPoint("TOPLEFT", notes, "BOTTOMLEFT", 0, -16)
		elseif i == breakpoint then
			box:SetPoint("TOPLEFT", notes, "BOTTOM", 0, -16)
		else
			box:SetPoint("TOPLEFT", boxes[i - 1], "BOTTOMLEFT", 0, -8)
		end
		
		boxes[i] = box
	end
	
	function self:refresh()
		for i = 1, #boxes do
			local box = boxes[i]
			box:SetChecked(db[box.id])
		end
	end
	
	self:SetScript("OnShow", nil)
	self:refresh()
end)

-- Register the options panel:

f.name = GetAddOnMetadata(ADDON, "Title")
InterfaceOptions_AddCategory(f)

-- Create a slash command to open the options panel:

_G["SLASH_"..ADDON.."1"] = "/notroll"
SlashCmdList[ADDON] = function()
	InterfaceOptionsFrame_OpenToCategory(f)
	InterfaceOptionsFrame_OpenToCategory(f)
	-- It's called twice on purpose, to work around the long-standing
	-- Blizzard bug that opens the options window to the wrong panel
	-- under certain conditions.
end