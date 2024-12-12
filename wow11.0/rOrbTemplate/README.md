## rOrbTemplate

rOrbTemplate provides the orb XML-template and functions/mixins to work with orb-models.

rOrbTemplate provides a bunch of preset orb templates. Here is the list of the current template names.

 - art-azeroth
 - art-chtun-eye
 - art-dwarf-machina
 - art-el-machina
 - art-elvish-object
 - art-wierd-eye
 - blue-aqua-sink
 - blue-aqua-spark
 - blue-aqua-swirly
 - blue-buzz
 - blue-electric
 - blue-magic-swirly
 - blue-magic-tornado
 - blue-portal
 - blue-ring-disco
 - blue-splash
 - blue-swirly
 - deep-purple-magic
 - deep-purple-starly
 - fire-dot
 - golden-earth
 - golden-marble
 - golden-tornado
 - green-beam
 - green-buzz
 - green-earth
 - green-portal
 - magenta-matrix
 - magenta-swirly
 - pink-earth
 - pink-portal
 - pink-portal-swirl
 - purple-buzz
 - purple-discoball
 - purple-earth
 - purple-growup
 - purple-hole
 - purple-portal
 - purple-storm
 - purple-warlock-portal
 - red-blue-knot
 - red-heal
 - red-portal
 - red-slob
 - sand-storm
 - sandy-blitz
 - white-boulder
 - white-cloud
 - white-heal
 - white-pearl
 - white-snowglobe
 - white-snowstorm
 - white-spark
 - white-swirly
 - white-tornado
 - white-zebra

## Orb template preview (check the template names above the orbs)

![Imgur](https://i.imgur.com/35EQN9O.jpeg)

![Imgur](https://i.imgur.com/0sJ1wbp.jpeg)

![Imgur](https://i.imgur.com/VyMTRSD.jpeg)

## rOrbTemplateViewer

To check all templates in detail and to experiment with some settings you can download the viewer addon I provided.

https://github.com/zorker/rothui/tree/master/wow11.0/rOrbTemplateViewer

## TOC-file

Make sure that your addon lists rOrbTemplate as a required dependency in the toc-file.

```
## RequiredDeps: rOrbTemplate
```

## API and CreateFrame using OrbTemplate

To create a frame using "OrbTemplate" create a frame like this.
This will automatically setup all textures/layers and load all mixins.

```lua
local orb = CreateFrame("Frame", "YourOrbName", UIParent, "OrbTemplate")
```

After the frame is created you can load any model template config into the orb.
That can be done by picking any of the given preset template names above or by providing a template config of your own.

You can set a new template at any given time. This is no one time action. (For example if the unit power changes)

## Loading an orb model by preset template name

```lua
orb:SetOrbTemplate("art-azeroth")
```

## Loading an orb model with your own template config

```lua
--showing how to manually set up a config to spawn any model in the orb
--Z = Y-axis in UI
--Y = X-axis in UI
--X = 3D-axis
local myOrbTemplateConfig = {
  statusBarTexture = "Interface\\AddOns\\rOrbTemplate\\media\\orb_filling16",
  statusBarColor = {1, 1, 1, 1},
  sparkColor = {0.8, 1, 0.9, 1},
  --glowColor = {0, 1, 0, 1},
  --lowHealthColor = {1, 0, 0, 1},
  modelOpacity = 1,
  displayInfoID = 44652,
  camScale = 1,
  --posAdjustX = 0,
  posAdjustY = -0.03,
  --posAdjustZ = 0,
  --panAdjustX = 0,
  --panAdjustY = 0,
  --panAdjustZ = 0,
}

orb:SetOrbTemplate("myOwnTemplateName", myOrbTemplateConfig)
```

## Template name and template config

Both can be access after being initialized like so:

```lua
orb.templateName
orb.templateConfig
```

## Important frames on the templates

```lua
--the filling statusbar
orb.FillingStatusBar
--the model frame
orb.ModelFrame
--overlay frame is holding textures above the model
orb.OverlayFrame
--the split texture
orb.OverlayFrame.SparkTexture
--glow texture for example debuff highlight
orb.OverlayFrame.GlowTexture
--low health glow or whatever you need
orb.OverlayFrame.LowHealthTexture
--gloss texture
orb.OverlayFrame.GlossTexture
```

## Reseting the model

If you initialize your orb frames before PLAYER_LOGIN it is highly advised to reset the orb model after login.

This can be easily done by calling "orb.ModelFrame:ResetOrbModel()"

```lua
local function ResetOrbModel()
  orb.ModelFrame:ResetOrbModel()
end
--any PLAYER_LOGIN callback works
rLib:RegisterCallback("PLAYER_LOGIN", ResetOrbModel)
```

## Adjusting colors, textures and values

You can adjust statusbar or textures like so. If your config has all the data already you probably only ever need the "SetValue" call.

```lua
--Important! The orb.FillingStatusBar has min/max values of 0-1. Adjst your value calls accordingly
orb.FillingStatusBar:SetValue(1)
orb.FillingStatusBar:SetStatusBarTexture(textureFile)
orb.FillingStatusBar:SetStatusBarColor(r,g,b,a)
orb.OverlayFrame.SparkTexture:SetVertexColor(r,g,b,a)
orb.OverlayFrame.GlowTexture:SetVertexColor(r,g,b,a)
orb.OverlayFrame.LowHealthTexture:SetVertexColor(r,g,b,a)
```