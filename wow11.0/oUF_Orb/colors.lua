local A, L = ...

local classNames = {"HUNTER", "WARLOCK", "PRIEST", "PALADIN", "MAGE", "ROGUE", "DRUID", "SHAMAN", "WARRIOR",
                    "DEATHKNIGHT", "MONK", "DEMONHUNTER", "EVOKER"}

local classColors = {}

for i, className in ipairs(classNames) do
  local origColor = C_ClassColor.GetClassColor(className)
  local color = CreateColor(origColor.r, origColor.g, origColor.b, 1)
  color.typeName = className
  table.insert(classColors, color)
end

local powerColors = {}

local powerNames = {"MANA", "RAGE", "FOCUS", "ENERGY", "COMBO_POINTS", "CHI", "RUNES", "RUNIC_POWER", "SOUL_SHARDS",
                    "LUNAR_POWER", "HOLY_POWER", "MAELSTROM", "INSANITY", "FURY", "PAIN", "ARCANE_CHARGES"}

for i, powerName in ipairs(powerNames) do
  local origColor = GetPowerBarColor(powerName)
  local color = CreateColor(origColor.r, origColor.g, origColor.b, 1)
  color.typeName = powerName
  table.insert(powerColors, color)
end

local function LoopColors(colorTable, colorPickerName, point)
  for i, color in ipairs(colorTable) do
    local button = L.F:CreateColorPickerButton(UIParent, A .. colorPickerName .. i, {color.r, color.g, color.b, 1},
      "Class color for: " .. color.typeName .. " - #" .. string.upper(color:GenerateHexColorNoAlpha()) .. "")
    button:SetSize(40, 40)
    if i == 1 then
      button:SetPoint(unpack(point))
    else
      button:SetPoint("LEFT", A .. colorPickerName .. (i - 1), "RIGHT", 10, 0)
    end
    function button:UpdateColor(r, g, b, a)
    end
  end
end

LoopColors(classColors, 'ClassColorPicker', {'LEFT', 20, 0})
LoopColors(powerColors, 'PowerColorPicker', {'LEFT', 20, 50})
