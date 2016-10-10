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
* **scale**: type:INTEGER, defines the scale of the unit frame http://wowprogramming.com/docs/widgets/Frame/SetScale

## Unit elements

Any unit can create any of the following elements.

* **healthbar**: type:TABLE, healthbar config
* **powerbar**: type:TABLE, powerbar config
* **castbar**: type:TABLE, castbar config
* **classbar**: type:TABLE, classbar config
* **altpowerbar**: type:TABLE, alternative powerbar config
* **raidmark**: type:TABLE, raidmark icon config
* **buffs**: type:TABLE, buff frame config
* **debuffs**: type:TABLE, debuff frame config

### Healthbar attributes

...

### Powerbar attributes

...

### Castbar attributes

...

### Classbar attributes

...

### Altpowerbar attributes

...

### Raidmark attributes

...

### Buffs attributes

...

### Debuffs attributes

...

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

*Build 22731, WoW path 7.1, PTR*

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