# oUF_SimpleConfig documentation

oUF_SimpleConfig is the configuration for oUF_Simple. oUF_Simple is now an mediator between oUF_SimpleConfig and oUF.
oUF_Simple provides a set of functions that can by used to spawn any defined united and on that unit any defined element.

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

* L.C.mediapath: path to the media files
* L.C.uiscale: scale of UIParent. Used to offset the uiscale and make the elements on screen become exactly the described size. Can be set to 1 or any other static value if not desired.
* L.C.backdrop: backdrop setup
* L.C.textures: textures for statusbars and backgrounds
* L.C.colors: Houses colors for castbar and threat that are not handled by oUF attributes. Defines the bgMultiplier.

## Units

Each unit has its own config file, like player.lua.

* L.C.player: player frame settings
* L.C.target: target frame settings
* L.C.targettarget: targettarget frame settings
* L.C.pet: pet frame settings
* L.C.focus: focus frame settings
* L.C.party: party frame settings
* L.C.boss: boss frame settings
* L.C.nameplate: nameplate frame settings
* L.C.raid: raid frame settings

### Unit Attributes

* enabled: type:BOOLEAN, enable or disable this unit frame
* size: type:TABLE, unit frame size http://wowprogramming.com/docs/widgets/Region/SetSize
* point: type:TABLE, unit frame position http://wowprogramming.com/docs/widgets/Region/SetPoint
* scale: type:INTEGER, defines the scale of the unit frame http://wowprogramming.com/docs/widgets/Frame/SetScale

## Elements

Any unit can create any of the following elements.

* healthbar
* powerbar
* raidmark
* castbar
* classbar
* altpowerbar
* buffs
* debuffs

## Special cases

Raid, party and boss units require special setup tables.