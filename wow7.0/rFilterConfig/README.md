# rFilterConfig documentation

rFilterConfig is the configuration for rFilter.
rFilter provides a set of functions that can by used to spawn buttons to track buffs, debuffs on any unit and cooldowns of the player.

## Init

By checking the [init.lua](https://github.com/zorker/rothui/blob/master/wow7.0/rFilterConfig/init.lua) you will find
that rFilterConfig defines the following config container and makes it globally available for rFilter to access.

```lua
--config container
L.C = {}
--make the config global
rFilterConfig = L.C
```

## Global config

Following are the root elements of rFilterConfig.

* **L.C.playerName**: type:STRING, player name
* **L.C.playerClass**: type:STRING, player class (example: WARRIOR)
* **L.C.buffs**: type:TABLE, buff list
* **L.C.debuffs**: type:TABLE, debuff list
* **L.C.cooldowns**: type:TABLE, cooldown list
* **L.C.actionButtonConfig**: type:TABLE, actionbutton config table used in rButtonTemplate to style the created buttons. For more read the [readme](https://github.com/zorker/rothui/blob/master/wow7.0/rButtonTemplate/README.me) of rButtonTemplate.
* **L.C.tick**: type:NUMBER, optional, update timer that defines how often updates will be triggered. default: 0.1.

## Functions

The [functions.lua](https://github.com/zorker/rothui/blob/master/wow7.0/rFilterConfig/functions.lua) defines functions that will make life easier to add buffs, debuffs and cooldowns.

* **L.F.AddBuff**: type:FUNCTION, function to add buffs to L.C.buffs buff list
  * spellid: type:NUMBER, spellid of the buff you want to track
  * unit: type:STRING, unit on which the buff should be tracked
  * size: type:NUMBER, default size of the button
  * point: type:TABLE, default point http://wowprogramming.com/docs/widgets/Region/SetPoint
  * visibility: type:STRING, custom visibility state driver. example: "[combat] show; hide"
  * alpha: type:TABLE, table containing two numbers defining the alpha of the button when off and on. example: {0.2, 1} --off,on
  * desaturate: type:BOOLEAN, desaturate the button texture when the buff is not found
  * caster: type:STRING, additional unit check to test if a buff is casted by a specific unit. example: "player"
* **L.F.AddDebuff**: type:FUNCTION, function to add debuffs to L.C.debuffs debuff list
  * spellid: type:NUMBER, spellid of the debuffs you want to track
  * unit: type:STRING, unit on which the debuffs should be tracked
  * size: type:NUMBER, default size of the button
  * point: type:TABLE, default point http://wowprogramming.com/docs/widgets/Region/SetPoint
  * visibility: type:STRING, custom visibility state driver. example: "[combat] show; hide"
  * alpha: type:TABLE, table containing two numbers defining the alpha of the button when off and on. example: {0.2, 1} --off,on
  * desaturate: type:BOOLEAN, desaturate the button texture when the debuff is not found
  * caster: type:STRING, additional unit check to test if a debuff is casted by a specific unit. example: "player"
* **L.F.AddCooldown**: type:FUNCTION, function to add cooldowns to L.C.cooldowns cooldown list
  * spellid: type:NUMBER, spellid of the cooldown you want to track
  * size: type:NUMBER, default size of the button
  * point: type:TABLE, default point http://wowprogramming.com/docs/widgets/Region/SetPoint
  * visibility: type:STRING, custom visibility state driver. example: "[combat] show; hide"
  * alpha: type:TABLE, table containing two numbers defining the alpha of the button when off and on. example: {0.2, 1} --off,on
  * desaturate: type:BOOLEAN, desaturate the button texture when the debuff is not found

## Actionbutton

The [actionbutton.lua](https://github.com/zorker/rothui/blob/master/wow7.0/rFilterConfig/actionbutton.lua) defines the actionbutton config elements. For more read the [readme](https://github.com/zorker/rothui/blob/master/wow7.0/rButtonTemplate/README.me) of rButtonTemplate.

## Buff

The [buff.lua](https://github.com/zorker/rothui/blob/master/wow7.0/rFilterConfig/buff.lua) defines the buffs you want to spawn. Optionally you can limit these by L.C.playerName or L.C.playerClass.

    L.C.AddBuff(spellid,unit,size,point,visibility,alpha,desaturate,caster)

## Debuff

The [debuff.lua](https://github.com/zorker/rothui/blob/master/wow7.0/rFilterConfig/debuff.lua) defines the debuffs you want to spawn. Optionally you can limit these by L.C.playerName or L.C.playerClass.

    L.C.AddDebuff(spellid,unit,size,point,visibility,alpha,desaturate,caster)

## Cooldown

The [cooldown.lua](https://github.com/zorker/rothui/blob/master/wow7.0/rFilterConfig/cooldown.lua) defines the cooldowns you want to spawn. Optionally you can limit these by L.C.playerName or L.C.playerClass.

    L.C.AddCooldown(spellid,size,point,visibility,alpha,desaturate)