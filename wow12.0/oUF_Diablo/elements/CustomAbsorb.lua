local _, ns = ...
local oUF = ns.oUF or oUF

-- The core update function for your standalone statusbar
local function UpdateAbsorbs(self, event, unit)
    if not unit or self.unit ~= unit then return end

    -- Fetch our target element
    local element = self.CustomAbsorb
    if not element then return end

    -- Custom pre-update callback if your layout needs it
    if element.PreUpdate then
        element:PreUpdate(unit)
    end

    -- Fetch tracking values using modern API
    local currentAbsorb = UnitGetTotalAbsorbs(unit) or 0
    local maxHealth = UnitHealthMax(unit) or 1

    -- Set the min/max and value
    element:SetMinMaxValues(0, maxHealth)
    element:SetValue(currentAbsorb, Enum.StatusBarInterpolation.ExponentialEaseOut)

    -- Custom post-update callback (useful for color changes, text overlays, etc.)
    if element.PostUpdate then
        element:PostUpdate(unit, currentAbsorb, maxHealth)
    end
end

-- Pathing function oUF uses to initialize/force updates
local function Path(self, ...)
    return (self.CustomAbsorb.Override or UpdateAbsorbs)(self, ...)
end

-- Registration function hook for oUF's internal lifecycle management
local function Enable(self, unit)
    local element = self.CustomAbsorb
    if element then

        element.__owner = self

        self:RegisterEvent("UNIT_ABSORB_AMOUNT_CHANGED", Path)
        self:RegisterEvent("UNIT_MAXHEALTH", Path)

        -- Fallback to ensure it updates when your targets/players swap
        self:RegisterEvent("UNIT_HEALTH", Path)

        -- Handles initialization when the frame is created or target is acquired
        if not element:GetStatusBarTexture() then
            element:SetStatusBarTexture([[Interface\TargetingFrame\UI-StatusBar]])
        end

        element:Show()

        return true
    end
end

local function Disable(self)
    local element = self.CustomAbsorb
    if element then
        self:UnregisterEvent("UNIT_ABSORB_AMOUNT_CHANGED", Path)
        self:UnregisterEvent("UNIT_MAXHEALTH", Path)
        self:UnregisterEvent("UNIT_HEALTH", Path)
        element:Hide()
    end
end

-- Tell oUF about your brand new element tracking engine
oUF:AddElement("CustomAbsorb", Path, Enable, Disable)