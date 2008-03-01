local addon = CreateFrame("Frame", nil, UIParent)
local tex = "Interface\\AddOns\\rTextures\\statusbar"
local time = 0

local function IsNamePlateFrame(frame)
	if frame:GetName() then
		return false
	end

	local overlayRegion = frame:GetRegions()
	if not overlayRegion or overlayRegion:GetObjectType() ~= "Texture" or overlayRegion:GetTexture() ~= "Interface\\Tooltips\\Nameplate-Border" then
		return false
	end
	return true
end

local frame
function addon:onUpdate(elapsed)
	time = time + elapsed

	if time > 1 then
		time = 0
		for i = 1, select("#", WorldFrame:GetChildren()) do
			frame = select(i, WorldFrame:GetChildren())

			if not frame.background and IsNamePlateFrame(frame) then 
				addon:setupNamePlate(frame)
			end
		end  
	end
end

local healthBar, castBar
local overlayRegion, highlightRegion, nameTextRegion, bossIconRegion, levelTextRegion, raidIconRegion
function addon:setupNamePlate(frame)
	healthBar, castBar = frame:GetChildren()
	overlayRegion, _, _, highlightRegion, nameTextRegion, levelTextRegion, bossIconRegion, raidIconRegion = frame:GetRegions()

	overlayRegion:Hide()
	bossIconRegion:Hide()
    highlightRegion:Hide()
	highlightRegion.Show = function() end

	nameTextRegion:ClearAllPoints()
	nameTextRegion:SetPoint("BOTTOM", healthBar, "TOP", 0, 5)
	nameTextRegion:SetFont(NAMEPLATE_FONT, 12, "THINOUTLINE")

	levelTextRegion:ClearAllPoints()
	levelTextRegion:SetPoint("RIGHT", healthBar, "LEFT", -2, 1)
	levelTextRegion:SetFont(NAMEPLATE_FONT, 12, "THINOUTLINE")

	raidIconRegion:ClearAllPoints()
	raidIconRegion:SetPoint("BOTTOM", healthBar, "TOP", 0, 20)

	healthBar:SetStatusBarTexture(tex)
	healthBar:SetHeight(12)

	background = healthBar:CreateTexture(nil, "BORDER")
	background:SetPoint("TOP", healthBar, 0, 1)
	background:SetPoint("BOTTOM", healthBar, 0, -1)
	background:SetPoint("LEFT", healthBar, -1, 0)
	background:SetPoint("RIGHT", healthBar, 1, 0)
	background:SetTexture(tex)
	background:SetVertexColor(.1, .1, .1, .6)
  
	frame.background = background
end

addon:SetScript("OnUpdate", addon.onUpdate)