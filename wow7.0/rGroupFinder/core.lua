
-- rGroupFinder: core
-- zork, 2018

-----------------------------
-- Local Variables
-----------------------------

local A, L = ...
L.addonName = A

-----------------------------
-- Config
-----------------------------

local wordQuestsOnly = false

-----------------------------
-- Functions
-----------------------------

local function AddGroupFinderButton(block, questID)
  if IsQuestComplete(questID) then return end
  if wordQuestsOnly and not QuestUtils_IsQuestWorldQuest(questID) then return end
  if block.groupFinderButton and block.hasGroupFinderButton then return end
  if not block.hasGroupFinderButton then
    block.hasGroupFinderButton = true
  end
  if not block.groupFinderButton then
    block.groupFinderButton = QuestObjectiveFindGroup_AcquireButton(block, questID);
    QuestObjectiveSetupBlockButton_AddRightButton(block, block.groupFinderButton, block.module.buttonOffsets.groupFinder);
  end
end

-----------------------------
-- Hook
-----------------------------

hooksecurefunc("QuestObjectiveSetupBlockButton_FindGroup", AddGroupFinderButton)