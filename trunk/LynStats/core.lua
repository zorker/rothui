-- thanks to evl and his awesome evl_clock to get lynstats "ace-less"
local addon = CreateFrame("Frame", nil, UIParent)

-- the x-files aka. configuration
local frame_anchor = "BOTTOMRIGHT" -- LEFT, TOPLEFT, TOP, TOPRIGHT, RIGHT, BOTTOMRIGHT, BOTTOM, BOTTOMLEFT, CENTER
local pos_x = -10
local pos_y = 10
local text_anchor = "BOTTOMRIGHT"
local font = "Fonts\\skurri.ttf"
local size = 12
local shadow = true -- true = fo sho! / false = nowaii!!

-- YAY!
local text

-- the allmighty
function addon:new()
	self:SetPoint(frame_anchor, UIParent, frame_anchor, pos_x, pos_y)
	self:SetWidth(120)
	self:SetHeight(20)
	
	text = self:CreateFontString(nil, "OVERLAY")
	text:SetFont(font, size, nil)
	if shadow == true then
		text:SetShadowOffset(1,-1)
	end
	text:SetPoint(text_anchor, self)
	
	self:SetScript("OnUpdate", self.update)
end

-- update
local last = 0
function addon:update(elapsed)
	last = last + elapsed

	-- mail stuff
	local mail
	local hasmail
	hasmail = (HasNewMail() or 0);
	if hasmail > 0 then
		mail = "|c00FA58F4new!|r  "
	else
		mail = ""
	end
	
	-- date thingy
	local ticktack = date("%H:%M")
	ticktack = "|c00ffffff"..ticktack.."|r"
	
	-- fps crap
	local fps = GetFramerate()
	fps = "|c00ffffff"..floor(fps).."|r|c00D1B815fps|r  "
	
	-- right down downright + punch
	local down, up, lag = GetNetStats()
	lag = "|c00ffffff"..lag.."|r|c00D1B815ms|r  "
	
	-- garbage!
	local mem = collectgarbage("count")
	mem = "|c00ffffff"..floor(mem / 1024).."|r|c00D1B815mb|r  "
	
	-- xp stuff
	local ep
	local xp_cur = UnitXP("player")
	local xp_max = UnitXPMax("player")
	if UnitLevel("player") < 70 then
		ep = "|c00ffffff"..floor(xp_max - xp_cur).."|r|c00D1B815xp|r  "
	else
		ep = ""
	end
	
	-- moep.
	if last > 1 then
		last = 0
		text:SetText(fps..lag..mem..ep..mail..ticktack)
	end
end

-- and... go!
addon:new()