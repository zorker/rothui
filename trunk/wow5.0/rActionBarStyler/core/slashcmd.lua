
  -----------------------------
  -- INIT
  -----------------------------

  --addon namespace
  local addon, ns = ...

  --create a list of dragable frames for the addon
  local dragFrameList = {}
  --make the list (object reference) available in the namespace for later usage
  ns.dragFrameList = dragFrameList

  -----------------------------
  -- FUNCTIONS
  -----------------------------

  local function SlashCmd(cmd)
    if (cmd:match"unlock") then
      rUnlockAllFrames(dragFrameList, "rABS: frames unlocked")
    elseif (cmd:match"lock") then
      rLockAllFrames(dragFrameList, "rABS: frames locked")
    elseif (cmd:match"reset") then
      rResetAllFramesToDefault(dragFrameList, "rABS: frames reseted")
    else
      print("|c0000FF00rActionBarStyler command list:|r")
      print("|c0000FF00\/rabs lock|r, to lock all bars")
      print("|c0000FF00\/rabs unlock|r, to unlock all bars")
      print("|c0000FF00\/rabs reset|r, to reset all bars")
    end
  end

  SlashCmdList["rabs"] = SlashCmd;
  SLASH_rabs1 = "/rabs";

  print("|c0000FF00rActionBarStyler loaded.|r")
  print("|c0000FF00\/rabs|r to display the command list")