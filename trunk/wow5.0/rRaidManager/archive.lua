
  local addon, ns = ...

  --stuff
  local tinsert = tinsert

  local icons = {}

  --tank
  tinsert(icons, "|TInterface\\LFGFrame\\LFGRole:14:14:0:0:64:16:32:48:0:16|t")
  tinsert(icons, "|TInterface\\LFGFrame\\UI-LFG-ICON-PORTRAITROLES:16:16:0:0:64:64:0:19:22:41|t")
  --healer
  tinsert(icons, "|TInterface\\LFGFrame\\LFGRole:14:14:0:0:64:16:48:64:0:16|t")
  tinsert(icons, "|TInterface\\LFGFrame\\UI-LFG-ICON-PORTRAITROLES:16:16:0:0:64:64:20:39:1:20|t")
  --dps
  tinsert(icons, "|TInterface\\LFGFrame\\LFGRole:14:14:0:0:64:16:16:32:0:16|t")
  tinsert(icons, "|TInterface\\LFGFrame\\UI-LFG-ICON-PORTRAITROLES:16:16:0:0:64:64:20:39:22:41|t")

  --raid target
  tinsert(icons, "|TInterface\\TargetingFrame\\UI-RaidTargetingIcon_1:0|t")
  tinsert(icons, "|TInterface\\TargetingFrame\\UI-RaidTargetingIcon_2:0|t")
  tinsert(icons, "|TInterface\\TargetingFrame\\UI-RaidTargetingIcon_3:0|t")
  tinsert(icons, "|TInterface\\TargetingFrame\\UI-RaidTargetingIcon_4:0|t")
  tinsert(icons, "|TInterface\\TargetingFrame\\UI-RaidTargetingIcon_5:0|t")
  tinsert(icons, "|TInterface\\TargetingFrame\\UI-RaidTargetingIcon_6:0|t")
  tinsert(icons, "|TInterface\\TargetingFrame\\UI-RaidTargetingIcon_7:0|t")
  tinsert(icons, "|TInterface\\TargetingFrame\\UI-RaidTargetingIcon_8:0|t")

  --world marker
  tinsert(icons, "|TInterface\\TargetingFrame\\UI-RaidTargetingIcon_6:14:14|t")
  tinsert(icons, "|TInterface\\TargetingFrame\\UI-RaidTargetingIcon_4:14:14|t")
  tinsert(icons, "|TInterface\\TargetingFrame\\UI-RaidTargetingIcon_3:14:14|t")
  tinsert(icons, "|TInterface\\TargetingFrame\\UI-RaidTargetingIcon_7:14:14|t")
  tinsert(icons, "|TInterface\\TargetingFrame\\UI-RaidTargetingIcon_1:14:14|t")

  --blizzard icon
  tinsert(icons, "|TInterface\\ChatFrame\\UI-ChatIcon-Blizz:12:20:0:0:32:16:4:28:0:16|t")
  tinsert(icons, "|TInterface\\ChatFrame\\UI-ChatIcon-Blizz:0:2:0:0|t")

  --guild reward
  tinsert(icons, "|TInterface\\AchievementFrame\\UI-Achievement-Guild:18:16:0:1:512:512:324:344:67:85|t")

  --mobile busy
  tinsert(icons, "|TInterface\\ChatFrame\\UI-ChatIcon-ArmoryChat-BusyMobile:14:14:0:0:16:16:0:16:0:16|t")
  --mobile away
  tinsert(icons, "|TInterface\\ChatFrame\\UI-ChatIcon-ArmoryChat-AwayMobile:14:14:0:0:16:16:0:16:0:16|t")

  --assist
  tinsert(icons, "|TInterface\\GroupFrame\\UI-Group-AssistantIcon:20:20:0:1|t")

  --noloot
  tinsert(icons, "|TInterface\\Common\\Icon-NoLoot:13:13:0:0|t")

  --status
  tinsert(icons, "|TInterface\\OptionsFrame\\UI-OptionsFrame-NewFeatureIcon:0:0:0:-1|t")

  --article updated
  tinsert(icons, "|TInterface\\GossipFrame\\AvailableQuestIcon:0:0:0:0|t")
  --article hot
  tinsert(icons, "|TInterface\\HelpFrame\\HotIssueIcon:0:0:0:0|t")

  --lock
  tinsert(icons, "|TInterface\\LFGFrame\\UI-LFG-ICON-LOCK:14:14:0:0:32:32:0:28:0:28|t")

  --heroic
  tinsert(icons, "|TInterface\\LFGFrame\\UI-LFG-ICON-HEROIC:16:13:-5:-3:32:32:0:16:0:20|t")

  --alliance
  tinsert(icons, "|TInterface\\TargetingFrame\\UI-PVP-ALLIANCE:19:16:0:0:64:64:0:32:0:38|t")
  --horde
  tinsert(icons, "|TInterface\\TargetingFrame\\UI-PVP-HORDE:18:19:0:0:64:64:0:38:0:36|t")

  --skull
  tinsert(icons, "|TInterface\\TargetingFrame\\UI-TargetingFrame-Skull:0|t")

  --petbattle strong
  tinsert(icons, "|TInterface\\petbattles\\battlebar-abilitybadge-strong-small:0|t")
  --petbattle weak
  tinsert(icons, "|TInterface\\petbattles\\battlebar-abilitybadge-weak-small:0|t")

  --classes
  --warrior
  tinsert(icons, "|TInterface\\WorldStateFrame\\ICONS-CLASSES:14:14:0:0:256:256:0:64:0:64|t")
  --mage
  tinsert(icons, "|TInterface\\WorldStateFrame\\ICONS-CLASSES:14:14:0:0:256:256:64:128:0:64|t")
  --rogue
  tinsert(icons, "|TInterface\\WorldStateFrame\\ICONS-CLASSES:14:14:0:0:256:256:128:196:0:64|t")
  --druid
  tinsert(icons, "|TInterface\\WorldStateFrame\\ICONS-CLASSES:14:14:0:0:256:256:196:256:0:64|t")
  --hunter
  tinsert(icons, "|TInterface\\WorldStateFrame\\ICONS-CLASSES:14:14:0:0:256:256:0:64:64:128|t")
  --shaman
  tinsert(icons, "|TInterface\\WorldStateFrame\\ICONS-CLASSES:14:14:0:0:256:256:64:128:64:128|t")
  --priest
  tinsert(icons, "|TInterface\\WorldStateFrame\\ICONS-CLASSES:14:14:0:0:256:256:128:196:64:128|t")
  --warlock
  tinsert(icons, "|TInterface\\WorldStateFrame\\ICONS-CLASSES:14:14:0:0:256:256:196:256:64:128|t")
  --paladin
  tinsert(icons, "|TInterface\\WorldStateFrame\\ICONS-CLASSES:14:14:0:0:256:256:0:64:128:196|t")
  --deathknight
  tinsert(icons, "|TInterface\\WorldStateFrame\\ICONS-CLASSES:14:14:0:0:256:256:64:128:128:196|t")
  --monk
  tinsert(icons, "|TInterface\\WorldStateFrame\\ICONS-CLASSES:14:14:0:0:256:256:128:196:128:196|t")

  --ready check wait
  tinsert(icons, "|TInterface\\RaidFrame\\ReadyCheck-Waiting:14:14:0:0|t")
  --ready check ready
  tinsert(icons, "|TInterface\\RaidFrame\\ReadyCheck-Ready:14:14:0:0|t")
  --ready check not ready
  tinsert(icons, "|TInterface\\RaidFrame\\ReadyCheck-NotReady:14:14:0:0|t")

  --info
  tinsert(icons, "|TInterface\\FriendsFrame\\InformationIcon:14:14:0:0|t")

  --raidleader
  tinsert(icons, "|TInterface\\GroupFrame\\UI-Group-LeaderIcon:14:14:0:0|t")
  --maintank
  tinsert(icons, "|TInterface\\GROUPFRAME\\UI-GROUP-MAINTANKICON:14:14:0:0|t")
  --mainassist
  tinsert(icons, "|TInterface\\GROUPFRAME\\UI-GROUP-MAINASSISTICON:14:14:0:0|t")
  --masterlooter
  tinsert(icons, "|TInterface\\GroupFrame\\UI-Group-MasterLooter:14:14:0:0|t")

  --roll dice
  tinsert(icons, "|TInterface\\Buttons\\UI-GroupLoot-Dice-Up:14:14:0:0|t")
  --roll coin
  tinsert(icons, "|TInterface\\Buttons\\UI-GroupLoot-Coin-Up:14:14:0:0|t")
  --roll disenchant
  tinsert(icons, "|TInterface\\Buttons\\UI-GroupLoot-DE-Up:14:14:0:0|t")
  --roll cancel
  tinsert(icons, "|TInterface\\Buttons\\UI-GroupLoot-Pass-Up:14:14:0:0|t")

  --alert
  tinsert(icons, "|TInterface\\DialogFrame\\UI-Dialog-Icon-AlertNew:14:14:0:0|t")

  local string = ""

  for key, value in pairs(icons) do
    string = string..value
  end

  print(string)