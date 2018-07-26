# rFilter API

rFilter provides a set of functions that can by used to spawn buttons to track buffs, debuffs on any unit and cooldowns of the player.

## rFilter:CreateBuff

Creates a button of type "buff" and returns it.

* spellid: type:NUMBER, spellid of the buff you want to track
* unit: type:STRING, unit on which the buff should be tracked
* size: type:NUMBER, default size of the button
* point: type:TABLE, default point http://wowprogramming.com/docs/widgets/Region/SetPoint
* visibility: type:STRING, custom visibility state driver. example: "[combat] show; hide"
* alpha: type:TABLE, table containing two numbers defining the alpha of the button when off and on. example: {0.2, 1} --off,on
* desaturate: type:BOOLEAN, desaturate the button texture when the buff is not found
* caster: type:STRING, additional unit check to test if a buff is casted by a specific unit. example: "player"

```lua
local button = rFilter:CreateBuff(spellid,unit,size,point,visibility,alpha,desaturate,caster)
```

## rFilter:CreateDebuff

Creates a button of type "debuff" and returns it.

* spellid: type:NUMBER, spellid of the debuffs you want to track
* unit: type:STRING, unit on which the debuffs should be tracked
* size: type:NUMBER, default size of the button
* point: type:TABLE, default point http://wowprogramming.com/docs/widgets/Region/SetPoint
* visibility: type:STRING, custom visibility state driver. example: "[combat] show; hide"
* alpha: type:TABLE, table containing two numbers defining the alpha of the button when off and on. example: {0.2, 1} --off,on
* desaturate: type:BOOLEAN, desaturate the button texture when the debuff is not found
* caster: type:STRING, additional unit check to test if a debuff is casted by a specific unit. example: "player"

```lua
local button = rFilter:CreateDebuff(spellid,unit,size,point,visibility,alpha,desaturate,caster)
```

## rFilter:CreateCooldown

Creates a button of type "cooldown" and returns it.

* spellid: type:NUMBER, spellid of the cooldown you want to track
* size: type:NUMBER, default size of the button
* point: type:TABLE, default point http://wowprogramming.com/docs/widgets/Region/SetPoint
* visibility: type:STRING, custom visibility state driver. example: "[combat] show; hide"
* alpha: type:TABLE, table containing two numbers defining the alpha of the button when off and on. example: {0.2, 1} --off,on
* desaturate: type:BOOLEAN, desaturate the button texture when the debuff is not found

```lua
local button = rFilter:CreateCooldown(spellid,size,point,visibility,alpha,desaturate)
```

## rFilter:SetTick

Default rFilter tick rate is 0.1 seconds. If you want to change that you can provide a different value.

* tick: type:NUMBER, tick rate in seconds.

```lua
rFilter:SetTick(0.5)
```