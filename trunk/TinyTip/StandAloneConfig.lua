--[[
-- You need edit this file for configuration ONLY if
-- TinyTipModuleCore is NOT loaded. Otherwise, the options
-- in this file do nothing.
--]]

if not TinyTipModuleCore then
    TinyTip_StandAloneDB = {
                --[[
                -- To select the TinyTip default, set the value to nil.
                --]]
                ["FormatDisabled"] = nil,    -- This will disable all formating is set to true.
                ["BGColor"] = nil,           -- 1 will disable colouring the background. 3 will make it black,
                                             -- except for Tapped/Dead. 2 will colour NPCs as well as PCs.
                ["Border"] = nil,            -- 1 will disable colouring the border. 2 will make it always black.
                                             -- 3 will make it a similiar colour to the background for NPCs.
                ["FAnchor"] = "CURSOR",           -- "BOTTOMRIGHT", "BOTTOMLEFT", "TOPRIGHT", "TOPLEFT", "CURSOR"
                                             -- If "HIDDEN" is given, then the tooltip will NOT be shown.
                                             -- Used only in Frames. TinyTip default (when nil) is BOTTOMRIGHT.
                ["FCursorAnchor"] = "BOTTOMLEFT",     -- Which side of the cursor to anchor for frame units.
                                             -- TinyTip's default (when nil) is "BOTTOM".
                ["MAnchor"] = nil,           -- Used only for Mouseover units. Options same as above, with the
                                             -- addition of "GAMEDEFAULT". TinyTip Default is CURSOR.
                ["MCursorAnchor"] = "BOTTOMLEFT",     -- Which side of the cursor to anchor for mouseover (world).
                ["FOffX"] = 10,             -- X offset for Frame units (horizontal).
                ["FOffY"] = 10,             -- Y offset for Frame units (vertical).
                ["MOffX"] = 10,             -- Offset for Mouseover units (World Frame).
                ["MOffY"] = 10              -- "     "       "       "       "
    }
end

