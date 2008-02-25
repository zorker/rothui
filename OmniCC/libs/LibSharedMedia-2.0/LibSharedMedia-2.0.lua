--[[
Name: LibSharedMedia-2.0
Revision: $Revision: 53142 $
Author: Elkano (elkano@gmx.de)
Inspired By: SurfaceLib by Haste/Otravi (troeks@gmail.com)
Website: http://
Documentation: http://www.wowace.com/wiki/LibSharedMedia-2.0
SVN: http://svn.wowace.com/wowace/trunk/LibSharedMedia-2.0/
Description: Shared handling of media data (fonts, sounds, textures, ...) between addons.
Dependencies: None
License: LGPL v2.1
]]

local vmajor, vminor = "LibSharedMedia-2.0", "$Revision: 53142 $"

local lib, oldMinor = LibStub:NewLibrary(vmajor, vminor)
if not lib then
	return
end
local oldLib
if oldMinor then
	oldLib = {}
	for k, v in pairs(lib) do
		oldLib[k] = v
		lib[k] = nil
	end
end

lib.frame = oldLib and oldLib.frame or CreateFrame("Frame")
local frame = lib.frame

frame:RegisterEvent("ADDON_LOADED")
local AceEvent, Surface, SML
frame:SetScript("OnEvent", function(this, event, ...)
	if not AceEvent and AceLibrary and AceLibrary:HasInstance("AceEvent-2.0") then
		AceEvent = AceLibrary("AceEvent-2.0")
		AceEvent:embed(lib)
		lib:UnregisterAllEvents()
		lib:RegisterEvent("Surface_Registered")
		lib:RegisterEvent("SharedMedia_Registered")
	end
	if not Surface and AceLibrary and AceLibrary:HasInstance("Surface-1.0", false) then
		Surface = AceLibrary("Surface-1.0")
		for k,v in pairs(Surface:Iterate()) do
			lib:Register('statusbar', k, v)
		end
	end
	if not SML and AceLibrary and AceLibrary:HasInstance("SharedMedia-1.0", false) then
		SML = AceLibrary("SharedMedia-1.0")
		for _,u in pairs(lib.MediaType) do
			for k,v in pairs(SML:HashTable(u)) do
				lib:Register(u, k, v)
			end
		end
	end
end)

local _G = _G

lib.MediaType = {
	BACKGROUND  = "background",			-- background textures
	BORDER      = "border",				-- border textures
	FONT		= "font",				-- fonts
	STATUSBAR	= "statusbar",			-- statusbar textures
	SOUND		= "sound",				-- sound files
}

lib.mediaTable = oldLib and oldLib.mediaTable or {
	background = {
		["Blizzard Low Health"] = "Interface\\FullScreenTextures\\LowHealth",
		["Blizzard Out of Control"] = "Interface\\FullScreenTextures\\OutOfControl",
		["Blizzard Tabard Background"] = "Interface\\TabardFrame\\TabardFrameBackground",
		["Solid"] = "Interface\\Buttons\\WHITE8X8",
		["Blizzard Tooltip"] = "Interface\\Tooltips\\UI-Tooltip-Background",
	},

	border = {
		["None"] = "Interface\\None",
		["Blizzard Dialog"]  = "Interface\\DialogFrame\\UI-DialogBox-Border",
		["Blizzard Tooltip"] = "Interface\\Tooltips\\UI-Tooltip-Border",
	},

	font = {
		["Arial Narrow"] = "Fonts\\ARIALN.TTF",
		["Friz Quadrata TT"] = "Fonts\\FRIZQT__.TTF",
		["Morpheus"] = "Fonts\\MORPHEUS.TTF",
		["Skurri"] = "Fonts\\SKURRI.TTF",
	},

	sound = {
		-- Relies on the fact that PlaySound[File] doesn't error on non-existing input.
		["None"] = "Interface\\Quiet.mp3",
	},

	statusbar = {
		["Blizzard"] = "Interface\\TargetingFrame\\UI-StatusBar",
	},
}
local mediaTable = lib.mediaTable

local locale = GetLocale()
if locale == "koKR" then
	mediaTable["font"]["굵은 글꼴"] = "Fonts\\2002B.TTF"
	mediaTable["font"]["기본 글꼴"] = "Fonts\\2002.TTF"
	mediaTable["font"]["데미지 글꼴"] = "Fonts\\K_Damage.TTF"
	mediaTable["font"]["퀘스트 글꼴"] = "Fonts\\K_Pagetext.TTF"
elseif locale == "zhTW" then
	-- Add 5 more system fonts which can display chinese to mediaTable.
	mediaTable["font"]["任務"] = "Fonts\\FZBWJW.TTF"
	mediaTable["font"]["傷害數字"] = "Fonts\\FZJZJW.TTF"
	mediaTable["font"]["預設"] = "Fonts\\FZLBJW.TTF"
	mediaTable["font"]["提示訊息"] = "Fonts\\FZXHJW.TTF"
	mediaTable["font"]["聊天"] = "Fonts\\FZXHLJW.TTF"
elseif locale == "zhCN" then
	-- Keep the original Founder fonts to give more choices to whoever want to customize fonts
	mediaTable["font"]["伤害数字"] = "Fonts\\ZYKai_C.ttf"
	mediaTable["font"]["默认"] = "Fonts\\ZYKai_T.ttf"
	mediaTable["font"]["聊天"] = "Fonts\\ZYHei.ttf"
	mediaTable["font"]["FZBWJW"] = "Fonts\\FZBWJW.TTF"
	mediaTable["font"]["FZJZJW"] = "Fonts\\FZJZJW.TTF"
	mediaTable["font"]["FZLBJW"] = "Fonts\\FZLBJW.TTF"
	mediaTable["font"]["FZXHJW"] = "Fonts\\FZXHJW.TTF"
	mediaTable["font"]["FZXHLJW"] = "Fonts\\FZXHLJW.TTF"
end

lib.mediaList = oldLib and oldLib.mediaList or {}
local mediaList = lib.mediaList
lib.overrideMedia = oldLib and oldLib.overrideMedia or {}
local overrideMedia = lib.overrideMedia
local defaultMedia = oldLib and oldLib.defaultMedia
if not defaultMedia then
	defaultMedia = {
		font = "Friz Quadrata TT",
		statusbar = "Blizzard",
	}
	if locale == "zhTW" then
		defaultMedia["font"] = "預設"
	elseif locale == "koKR" then
		defaultMedia["font"] = "기본 글꼴"
	elseif locale == "zhCN" then
		defaultMedia["font"] = "默认"
	end
end
lib.defaultMedia = defaultMedia

local function rebuildMediaList(type)
	if type then
		local mtable = mediaTable[type]
		if not mtable then return end
		if _G.type(mediaList[type]) ~= "table" then mediaList[type] = {} end
		local mlist = mediaList[type]
		for k in pairs(mlist) do mlist[k] = nil end
		for k in pairs(mtable) do
			rawset(mlist, #mlist + 1, k)
		end
		table.sort(mlist)
	else
		for k in pairs(mediaTable) do
			rebuildMediaList(k)
		end
	end
end

local function filename(file)
	local filename = file:match("^.+\\(.+)$")
	if not filename then error("Provided path does not contain a valid filename.") end
	local ext = filename:sub(-4)
	if ext == ".tga" or ext == ".blp" then filename = filename:sub(1, -5) end
	return filename:lower()
end

lib.callbacks = oldLib and oldLib.callbacks or {}
function lib:RegisterCallback(func)
	assert(type(func) == "function")
	self.callbacks[func] = true
end
function lib:UnregisterCallback(func)
	self.callbacks[func] = nil
end

function lib:Register(m, n, t)
	assert(type(m) == "string")
	assert(type(n) == "string")
	assert(type(t) == "string")
	m = m:lower()
	n = n:trim()
	if not mediaTable[m] then
		mediaTable[m] = {}
	end
	local mtable = mediaTable[m]
	if not mtable or mtable[n] or mtable[n:lower()] or mtable[n:upper()] then return end

	for _, v in pairs(mtable) do
		if filename(t) == filename(v) then return end
	end

	mtable[n] = t
	rebuildMediaList(m)
	
	for func in pairs(self.callbacks) do
		local success, ret = pcall(func, m, n)
		if not success then
			geterrorhandler()(ret)
		end
	end
end

function lib:Fetch(m, n, noDefault)
	assert(type(m) == "string")
	assert(type(n) == "string")
	local result = mediaTable[m] and ((not overrideMedia[m] and mediaTable[m][n]) or (overrideMedia[m] and mediaTable[m][overrideMedia[m]]) or (not noDefault and mediaTable[m][defaultMedia[m]])) or nil

	-- Because all the 4 default fonts and almost ALL custom fonts don't display chinese, we just map them to FZLBJW.TTF.
	local locale = GetLocale()
	if locale == "zhTW" then
		if m == "font" and result and result ~= "Fonts\\FZBWJW.TTF" and result ~= "Fonts\\FZJZJW.TTF" and result ~= "Fonts\\FZLBJW.TTF" and result ~= "Fonts\\FZXHJW.TTF" and result ~= "Fonts\\FZXHLJW.TTF" then
			result = "Fonts\\FZLBJW.TTF"
		end
	elseif locale == "zhCN" then
		if m == "font" and result and result ~= "Fonts\\ZYKai_C.ttf" and result ~= "Fonts\\ZYKai_T.ttf" and result ~= "Fonts\\ZYHei.ttf" and result ~= "Fonts\\FZBWJW.TTF" and result ~= "Fonts\\FZJZJW.TTF" and result ~= "Fonts\\FZLBJW.TTF" and result ~= "Fonts\\FZXHJW.TTF" and result ~= "Fonts\\FZXHLJW.TTF" then
			result = "Fonts\\ZYKai_T.ttf"
		end
	elseif locale == "koKR" then
		if m == "font" and result and result ~= "Fonts\\2002B.TTF" and result ~= "Fonts\\2002.TTF" and result ~= "Fonts\\K_Damage.TTF" and result ~= "Fonts\\K_Pagetext.TTF" then
			result = "Fonts\\2002.TTF"
		end
	end

	return result
end

function lib:HashTable(m)
	assert(type(m) == "string")
	if not mediaTable[m] then
		mediaTable[m] = {}
	end
	return mediaTable[m]
end

function lib:List(m)
	assert(type(m) == "string")
	if not mediaTable[m] then
		mediaTable[m] = {}
	end
	if not(mediaList[m]) then
		rebuildMediaList(m)
	end
	return mediaList[m]
end

function lib:GetGlobal(m)
	assert(type(m) == "string")
	return overrideMedia[m]
end

function lib:SetGlobal(m, n)
	assert(type(m) == "string")
	assert(not n or type(n) == "string")
	overrideMedia[m] = mediaTable[m] and mediaTable[m][n] and n or nil
--	if JokerEvent then
--		self:DispatchEvent("SetGlobal", m, overrideMedia[m])
--	end
end

function lib:Usage(m)
	assert(type(m) == "string")
	if not(mediaList[m]) then
		rebuildMediaList(m)
	end
	return "{" .. table.concat(mediaList[m], " || ") .. "}"
end

function lib:IsValid(m, n)
	assert(type(m) == "string")
	assert(not n or type(n) == "string")
	return mediaTable[m] and (not n or mediaTable[m][n]) and true or false
end

function lib:SetDefault(m, n)
	assert(type(m) == "string")
	assert(type(n) == "string")
	if mediaTable[m] and mediaTable[m][n] and not defaultMedia[m] then
		defaultMedia[m] = n
	end
end

function lib:Surface_Registered(name)
	local Surface = AceLibrary and AceLibrary:HasInstance("Surface-1.0", false) and AceLibrary("Surface-1.0")
	if Surface and name then
		self:Register('statusbar', name, Surface:Iterate()[name])
	end
end

function lib:SharedMedia_Registered(m, n)
	local SML = AceLibrary and AceLibrary:HasInstance("SharedMedia-1.0", false) and AceLibrary("SharedMedia-1.0")
	self:Register(m, n, SML:Fetch(m, n))
end
