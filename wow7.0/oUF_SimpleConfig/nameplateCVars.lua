
-- oUF_SimpleConfig: nameplateCVars
-- zork, 2016

-----------------------------
-- Variables
-----------------------------

local A, L = ...

-----------------------------
-- Nameplate CVars
-----------------------------

--[[
name;value;default
nameplateClassResourceTopInset;0.03;
nameplateGlobalScale;1;
NamePlateHorizontalScale;1;
nameplateLargeBottomInset;0.15;
nameplateLargerScale;1.2;
nameplateLargeTopInset;0.1;
nameplateMaxAlpha;0.9;
nameplateMaxAlphaDistance;10;
nameplateMaxDistance;60;
nameplateMaxScale;1;
nameplateMaxScaleDistance;10;
nameplateMinAlpha;0.5;
nameplateMinAlphaDistance;10;
nameplateMinScale;0.8;
nameplateMinScaleDistance;10;
nameplateMotion;0;
nameplateMotionSpeed;0.025;
nameplateOtherBottomInset;0.1;
nameplateOtherTopInset;0.08;
nameplateOverlapH;0.8;
nameplateOverlapV;1.1;
NameplatePersonalHideDelayAlpha;0.45;
NameplatePersonalHideDelaySeconds;3;
NameplatePersonalShowAlways;0;
NameplatePersonalShowInCombat;1;
NameplatePersonalShowWithTarget;0;
nameplateSelectedAlpha;1;
nameplateSelectedScale;1;
nameplateSelfAlpha;0.75;
nameplateSelfBottomInset;0.2;
nameplateSelfScale;1;
nameplateSelfTopInset;0.5;
nameplateShowAll;0;
nameplateShowEnemies;1;
nameplateShowEnemyGuardians;0;
nameplateShowEnemyMinions;0;
nameplateShowEnemyMinus;1;
nameplateShowEnemyPets;0;
nameplateShowEnemyTotems;0;
nameplateShowFriendlyGuardians;0;
nameplateShowFriendlyMinions;0;
nameplateShowFriendlyNPCs;0;
nameplateShowFriendlyPets;0;
nameplateShowFriendlyTotems;0;
nameplateShowFriends;0;
nameplateShowSelf;1;
nameplateTargetBehindMaxDistance;15;
NamePlateVerticalScale;1;
ShowClassColorInNameplate;1;
ShowNamePlateLoseAggroFlash;1;
]]

local function SetNamePlateCVARS()
  SetCVar("nameplateShowAll", 1)
  SetCVar("nameplateMaxAlpha", 0.5)
  SetCVar("nameplateShowEnemies", 1)
  SetCVar("ShowClassColorInNameplate", 1)
  SetCVar("nameplateOtherTopInset", 0.08)
  SetCVar("nameplateOtherBottomInset", -1)
  SetCVar("nameplateMinScale", 1)
  SetCVar("namePlateMaxScale", 1)
  SetCVar("nameplateMinScaleDistance", 10)
  SetCVar("nameplateMaxDistance", 40)
  SetCVar("NamePlateHorizontalScale", 1)
  SetCVar("NamePlateVerticalScale", 1)
  --[[
  print('--------------------------------------')
  print(A..' nameplate CVAR settings')
  print('--------------------------------------')
  print('nameplateShowAll', 'default', GetCVarDefault("nameplateShowAll"), 'saved', GetCVar("nameplateShowAll"))
  print("nameplateMaxAlpha", 'default', GetCVarDefault("nameplateMaxAlpha"), 'saved', GetCVar("nameplateMaxAlpha"))
  print("nameplateShowEnemies", 'default', GetCVarDefault("nameplateShowEnemies"), 'saved', GetCVar("nameplateShowEnemies"))
  print("ShowClassColorInNameplate", 'default', GetCVarDefault("ShowClassColorInNameplate"), 'saved', GetCVar("ShowClassColorInNameplate"))
  print("nameplateOtherTopInset", 'default', GetCVarDefault("nameplateOtherTopInset"), 'saved', GetCVar("nameplateOtherTopInset"))
  print("nameplateOtherBottomInset", 'default', GetCVarDefault("nameplateOtherBottomInset"), 'saved', GetCVar("nameplateOtherBottomInset"))
  print("nameplateMinScale", 'default', GetCVarDefault("nameplateMinScale"), 'saved', GetCVar("nameplateMinScale"))
  print("namePlateMaxScale", 'default', GetCVarDefault("namePlateMaxScale"), 'saved', GetCVar("namePlateMaxScale"))
  print("nameplateMinScaleDistance", 'default', GetCVarDefault("nameplateMinScaleDistance"), 'saved', GetCVar("nameplateMinScaleDistance"))
  print("nameplateMaxDistance", 'default', GetCVarDefault("nameplateMaxDistance"), 'saved', GetCVar("nameplateMaxDistance"))
  print("NamePlateHorizontalScale", 'default', GetCVarDefault("NamePlateHorizontalScale"), 'saved', GetCVar("NamePlateHorizontalScale"))
  print("NamePlateVerticalScale", 'default', GetCVarDefault("NamePlateVerticalScale"), 'saved', GetCVar("NamePlateVerticalScale"))
  ]]
end
rLib:RegisterCallback("PLAYER_LOGIN",SetNamePlateCVARS)
