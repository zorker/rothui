--[[-------------------------------------------------------
-- TinyTip Localization : Chinese
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
-- Contributors: Yzerman
--]]

if GetLocale() ~= "zhCN" then return end

TinyTipLocale = setmetatable({
	["Tapped"]	= "已被攻击",
	["Rare Elite"]	= "稀有精英",
}, {__index=TinyTipLocale})
