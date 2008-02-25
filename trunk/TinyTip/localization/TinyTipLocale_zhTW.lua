--[[-------------------------------------------------------
-- TinyTip Localization : Traditional Chinese
-----------------------------------------------------------
-- Any wrong translations, change them here.
-- This file must be saved as UTF-8 compatible.
--
-- To get your client's locale, type in:
--
-- /script DEFAULT_CHAT_FRAME:AddMessage( GetLocale() )
--
-- Do not repost without permission from the author. If you 
-- want to add a translation, contact the author.
-- 
-- Contributors: 舞葉@語風
--]]

if GetLocale() ~= "zhTW" then return end

TinyTipLocale = setmetatable({
	["Tapped"]	= "戰鬥中",
	["Unknown"]	= "未知",
}, {__index=TinyTipLocale})
