--[[-------------------------------------------------------
-- TinyTip Localization : Default
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
--]]

local t = {
        ["Tapped"] = "Tapped",
        ["Level"] = LEVEL,
        ["Unknown"] = UNKNOWN,
        ["UnknownEntity"] = UKNOWNBEING,
        ["Corpse"] = CORPSE,
        ["Elite"] = ELITE,
        ["Boss"] = BOSS,
        ["Rare"] = ITEM_QUALITY3_DESC,
        ["Rare Elite"] = string.format("%s %s", ITEM_QUALITY3_DESC, ELITE ),
        ["strformat_ranknumber"] = "[R %d]",
        ["slash2"] = "ttip",
        ["nooptions"] = "TinyTipModules not found. StandAlone Configuration is only available. To edit StandAlone configuration, go to the TinyTip folder in your Addons folder and edit StandAloneConfig.lua."
}

-- support for TinyTipModuleCore
TinyTipLocale = (TinyTipLocale and setmetatable(t, {__index=TinyTipLocale})) or t
t = nil
