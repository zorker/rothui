# oUF_SimpleConfig documentation

oUF_SimpleConfig is the configuration for oUF_Simple. oUF_Simple is now an mediator between oUF_SimpleConfig and oUF.
oUF_Simple provides a set of functions that can by used to spawn any defined unit with a set of defined elements.

## Init

By checking the [init.lua](https://github.com/zorker/rothui/blob/master/wow7.0/oUF_SimpleConfig/init.lua) you will find
that oUF_SimpleConfig defines the following config container and makes it globally available for oUF_Simple to access.

```lua
--config container
L.C = {}
--make the config global
oUF_SimpleConfig = L.C
```

# Global config

The global.lua has global config settings used among units and elements.

* **L.C.mediapath**: path to the media files
* **L.C.uiscale**: scale of UIParent. Used to offset the uiscale and make the elements on screen become exactly the described size. Can be set to 1 or any other static value if not desired.
* **L.C.backdrop**: backdrop setup
* **L.C.textures**: textures for statusbars and backgrounds
* **L.C.colors**: Houses colors for castbar and threat that are not handled by oUF attributes. Defines the bgMultiplier.

## Units

Each unit has its own config file, like player.lua.

* **L.C.player**: player frame settings
* **L.C.target**: target frame settings
* **L.C.targettarget**: targettarget frame settings
* **L.C.pet**: pet frame settings
* **L.C.focus**: focus frame settings
* **L.C.party**: party frame settings
* **L.C.boss**: boss frame settings
* **L.C.nameplate**: nameplate frame settings
* **L.C.raid**: raid frame settings

## Unit attributes

Attributes on unit level.

* **enabled**: type:BOOLEAN, enable or disable this unit frame
* **size**: type:TABLE, unit frame size http://wowprogramming.com/docs/widgets/Region/SetSize
* **point**: type:TABLE, unit frame position http://wowprogramming.com/docs/widgets/Region/SetPoint
* **scale**: type:NUMBER, defines the scale of the unit frame http://wowprogramming.com/docs/widgets/Frame/SetScale

## Unit elements

Any unit can create any of the following elements on unit level.

* **healthbar**: type:TABLE, healthbar config
* **powerbar**: type:TABLE, powerbar config
* **castbar**: type:TABLE, castbar config
* **classbar**: type:TABLE, classbar config
* **altpowerbar**: type:TABLE, alternative powerbar config
* **raidmark**: type:TABLE, raidmark icon config
* **buffs**: type:TABLE, buff frame config
* **debuffs**: type:TABLE, debuff frame config

### Healthbar attributes

Healthbar and absorbbar cannot be disabled. Size and position matches the unit frame.

* **colorTapping**: type: BOOLEAN, Enables/disables coloring by tapping color.
* **colorDisconnected**: type: BOOLEAN, Enables/disables coloring by disconnected color.
* **colorReaction**: type: BOOLEAN, Enables/disables coloring by reaction color.
* **colorClass**: type: BOOLEAN, Enables/disables coloring by class color.
* **colorHealth**: type: BOOLEAN, Enables/disables coloring by health color.
* **colorThreat**: type: BOOLEAN, Enables/disables coloring by threat color. Checks if the unit has aggro from any other unit.
* **colorThreatInvers**: type: BOOLEAN, Enables/disables coloring by invers threat color. Checks if unit has aggro against "player".
* **frequentUpdates**: type: BOOLEAN, Enables/disables frequent updates
* **name**: type: TABLE, configuration for the name text
  * enabled: type:BOOLEAN, enable/disable element
  * points: type:TABLE, contains multiple points
  * point: type:TABLE, contains a single point
  * font: type:STRING, font family
  * size: type:NUMBER, font size
  * outline: type:STRING, font outline
  * align: type:STRING, text align
  * noshadow: type:BOOLEAN, Disable/enable text drop shadow
  * tag: type:STRING, oUF tag
* **healthtext**: type: TABLE, configuration for the health text
  * enabled: type:BOOLEAN, enable/disable element
  * points: type:TABLE, contains multiple points
  * point: type:TABLE, contains a single point
  * font: type:STRING, font family
  * size: type:NUMBER, font size
  * outline: type:STRING, font outline
  * align: type:STRING, text align
  * noshadow: type:BOOLEAN, Disable/enable text drop shadow
  * tag: type:STRING, oUF tag

### Powerbar attributes

* **enabled**: type:BOOLEAN, enable/disable element
* **size**: type:TABLE, element size http://wowprogramming.com/docs/widgets/Region/SetSize
* **point**: type:TABLE, element position http://wowprogramming.com/docs/widgets/Region/SetPoint
* **colorPower**: type: BOOLEAN, Enables/disables coloring by power color.

### Castbar attributes

* **enabled**: type:BOOLEAN, enable/disable element
* **size**: type:TABLE, element size http://wowprogramming.com/docs/widgets/Region/SetSize
* **point**: type:TABLE, element position http://wowprogramming.com/docs/widgets/Region/SetPoint
* **name**: type: TABLE, configuration for the name text
  * enabled: type:BOOLEAN, enable/disable element
  * points: type:TABLE, contains multiple points
  * point: type:TABLE, contains a single point
  * font: type:STRING, font family
  * size: type:NUMBER, font size
  * outline: type:STRING, font outline
  * align: type:STRING, text align
  * noshadow: type:BOOLEAN, Disable/enable text drop shadow
* **icon**: type: TABLE, configuration for the castbar icon
  * enabled: type:BOOLEAN, enable/disable element
  * point: type:TABLE, icon point
  * size: type:TABLE, icon size

### Classbar attributes

Classbar element for combo points, chi, holy power, etc. Makes sense for the player unit only.

* **enabled**: type:BOOLEAN, enable/disable element
* **size**: type:TABLE, element size http://wowprogramming.com/docs/widgets/Region/SetSize
* **point**: type:TABLE, element position http://wowprogramming.com/docs/widgets/Region/SetPoint

### Altpowerbar attributes

* **enabled**: type:BOOLEAN, enable/disable element
* **size**: type:TABLE, element size http://wowprogramming.com/docs/widgets/Region/SetSize
* **point**: type:TABLE, element position http://wowprogramming.com/docs/widgets/Region/SetPoint

### Raidmark attributes

* **enabled**: type:BOOLEAN, enable/disable element
* **size**: type:TABLE, element size http://wowprogramming.com/docs/widgets/Region/SetSize
* **point**: type:TABLE, element position http://wowprogramming.com/docs/widgets/Region/SetPoint

### Buffs attributes

* **enabled**: type:BOOLEAN, enable/disable element
* **point**: type:TABLE, element position http://wowprogramming.com/docs/widgets/Region/SetPoint
* **size**: type:NUMBER, aura icon size, value is applied to both width and height
* **num**: type:NUMBER, max number of aura icons
* **cols**: type:NUMBER, how many aura icons per column
* **spacing**: type:NUMBER, space between aura icons
* **initialAnchor**: type:STRING, initial anchor point (example: "BOTTOMLEFT"). Has to be a corner.
* **growthX**: type:STRING, grown direction x-axis. "LEFT" or "RIGHT"
* **growthY**: type:STRING, grown direction y-axis. "UP" or "DOWN"
* **disableCooldown**: type:BOOLEAN, disable/enable cooldown spiral

### Debuffs attributes

* **enabled**: type:BOOLEAN, enable/disable element
* **point**: type:TABLE, element position http://wowprogramming.com/docs/widgets/Region/SetPoint
* **size**: type:NUMBER, aura icon size, value is applied to both width and height
* **num**: type:NUMBER, max number of aura icons
* **cols**: type:NUMBER, how many aura icons per column
* **spacing**: type:NUMBER, space between aura icons
* **initialAnchor**: type:STRING, initial anchor point (example: "BOTTOMLEFT"). Has to be a corner.
* **growthX**: type:STRING, grown direction x-axis. "LEFT" or "RIGHT"
* **growthY**: type:STRING, grown direction y-axis. "UP" or "DOWN"
* **disableCooldown**: type:BOOLEAN, disable/enable cooldown spiral

## Special cases

Raid, party and boss units require special setup tables.

## NamePlate callback

You can define the following function if you manually want to react on nameplate events.

```
local function NamePlateCallback(...)
  print(...)
end
L.C.NamePlateCallback = NamePlateCallback
```

You get notified on the following events:

* UpdateNamePlateOptions
* NAME_PLATE_UNIT_ADDED
* NAME_PLATE_UNIT_REMOVED
* PLAYER_TARGET_CHANGED

## NamePlate CVars

Blizzard is using hidden cvars that can affect the look of your nameplates. You can use those cvars to manipulate the behaviour of your nameplates.
If you want to set them you need to wait until PLAYER_LOGIN (hence the callback in my example).

#### Chat command to print the default settings for a specific cvar
```lua
/run local cv = "nameplateShowAll"; print(cv, "default", GetCVarDefault(cv), "saved", GetCVar(cv))
```

*Build 22731, WoW patch 7.1, PTR*

```
nameplateClassResourceTopInset
nameplateGlobalScale
NamePlateHorizontalScale
nameplateLargeBottomInset
nameplateLargerScale
nameplateLargeTopInset
nameplateMaxAlpha
nameplateMaxAlphaDistance
nameplateMaxDistance
nameplateMaxScale
nameplateMaxScaleDistance
nameplateMinAlpha
nameplateMinAlphaDistance
nameplateMinScale
nameplateMinScaleDistance
nameplateMotion
nameplateMotionSpeed
nameplateOtherBottomInset
nameplateOtherTopInset
nameplateOverlapH
nameplateOverlapV
NameplatePersonalHideDelayAlpha
NameplatePersonalHideDelaySeconds
NameplatePersonalShowAlways
NameplatePersonalShowInCombat
NameplatePersonalShowWithTarget
nameplateSelectedAlpha
nameplateSelectedScale
nameplateSelfAlpha
nameplateSelfBottomInset
nameplateSelfScale
nameplateSelfTopInset
nameplateShowAll
nameplateShowEnemies
nameplateShowEnemyGuardians
nameplateShowEnemyMinions
nameplateShowEnemyMinus
nameplateShowEnemyPets
nameplateShowEnemyTotems
nameplateShowFriendlyGuardians
nameplateShowFriendlyMinions
nameplateShowFriendlyNPCs
nameplateShowFriendlyPets
nameplateShowFriendlyTotems
nameplateShowFriends
nameplateShowSelf
nameplateTargetBehindMaxDistance
NamePlateVerticalScale
ShowClassColorInNameplate
ShowNamePlateLoseAggroFlash
```