
  -- ////////////////////////////////
  -- //     TIME TO DIE - MINI     //
  -- ////////////////////////////////
  
  -- by roth 2009
  
  -- First...this mod is only viable for raid bosses.
  -- No one wants to know if something is gonna die in 5 or 10 seconds. Doesn't matter.
  
  -- we need to be in combat
  -- the unit needs to be hostile
  -- the mob needs to be a raidboss
  -- we need a variable that saves the first time the boss is below 100%
  -- then we have an onupdate script that will lookup the boss hp every second to detect 
  -- how long it will take to bring it down to zero

  ---------------------------------------------
  -- CONFIG
  ---------------------------------------------

  --set your mobtype
  --1 = raidboss only
  --2 = raidboss and playerlevel + 3 mobs (hc instance bosses, 83 mobs etc.)
  --3 = show add for every mob available
  local show_time_mobtype = 2
  
  --show dps?
  local show_dps = 1
  
  --position
  local anchor = "TOP"
  local posx = 0
  local posy = -50

  ---------------------------------------------
  -- VARIABLES
  ---------------------------------------------
  
  --variable that saves is unit is in combat
  local player_in_combat = 0 
  --hostile ?!
  local target_is_hostile 
  --variable that saves if the unit is a raidboss
  local target_is_raidboss
  --target must be npc
  local target_is_npc
  --has the player a target?
  local player_has_target = 0  
  --first lookup percentage
  local first_life  
  local first_life_max
  --first time target seen
  local first_time
  --current
  local current_life
  local current_time
  --update timer in seconds
  local update_timer = 2
  --time to die
  local time_to_die
  --script running
  local script_running = 0
  --helper frame
  local a = CreateFrame("Frame",nil,UIParent)  
  local updateCombatStatus, updateTargetStatus
  
  ---------------------------------------------
  -- FUNCTIONS
  ---------------------------------------------
  
  
  --set fontstring
  local function SetFontString(f, fontName, fontHeight, fontStyle)
    local fs = f:CreateFontString(nil, "OVERLAY")
    fs:SetFont(fontName, fontHeight, fontStyle)
    fs:SetShadowColor(0,0,0,1)
    return fs
  end
  
  --backdrop
  local function SetBackdrop(f)
    f:SetBackdrop({ 
      bgFile = "Interface\\Tooltips\\UI-Tooltip-Background", 
      edgeFile = "", tile = false, tileSize = 0, edgeSize = 32, 
      insets = { left = -2, right = -2, top = -2, bottom = -2 }
    })
    f:SetBackdropColor(0,0,0,1)
  end
  
  --init
  local function initFrames()
    a:SetWidth(600)
    a:SetHeight(40)
    a:SetPoint(anchor,posx,posy)
    --SetBackdrop(a)
    local text = SetFontString(a, "FONTS\\FRIZQT__.ttf", 14, "THINOUTLINE")
    text:SetPoint("LEFT", 2, 0)
    text:SetPoint("RIGHT", -2, 0)
    --text:SetJustifyH("LEFT")
    text:SetTextColor(1,1,1)
    a.text = text
  end
  
  local function am(meintext)
    --DEFAULT_CHAT_FRAME:AddMessage(text)
    a.text:SetText(meintext)
  end  
  
  local function amd(meintext)
    DEFAULT_CHAT_FRAME:AddMessage(meintext)
  end  
  
  local function updateFunc(self,elapsed)
    local t = self.timer
    if (not t) then
      self.timer = 0
      return
    end
    t = t + elapsed
    if (t<update_timer) then
      self.timer = t
      return
    else
      self.timer = 0
      updateTargetStatus()
    end
  end
  
  local function activate_this()
    a:SetScript("OnUpdate", updateFunc)
    --amd("TTD: Script started.")
    am("")
    script_running = 1
  end
  
  local function stop_this(reason)
    first_life = nil
    first_time = nil
    a:SetScript("OnUpdate", nil)
    if reason then
      --amd("TTD: Script ended because of: "..reason..".")
    else
      --amd("TTD: Script ended.")
    end
    am("")
    script_running = 0
  end
  
  updateCombatStatus = function (self, event, unit)
    if event == "PLAYER_REGEN_DISABLED" then
      player_in_combat = 1
      if script_running == 0 then
        activate_this()
      end 
    else
      player_in_combat = 0
      if script_running == 1 then
        stop_this("out of combat")
      end
    end
  end
  
  local function calculate_time_to_death()
    if current_life == 0 then
      am("TTD: "..UnitName("target").." is dead!")
      if script_running == 1 then
        stop_this("target is dead")
      end
    else
      local time_diff = current_time-first_time
      local hp_diff = first_life-current_life
      if hp_diff > 0 then
        local calc_time = time_diff*first_life_max/hp_diff
        calc_time = first_time+calc_time-current_time
        if calc_time < 1 then
          calc_time = 1
        end
        time_to_die = SecondsToTime(calc_time)
        if show_dps == 1 then
          local dps = floor(hp_diff/time_diff)
          am("TTD: "..UnitName("target").." dies in "..time_to_die.." (DPS "..dps..")")
        else
          am("TTD: "..UnitName("target").." dies in "..time_to_die)
        end
      elseif hp_diff < 0 then
        --unit has healed, reseting the initial values
        first_life = current_life
        first_time = current_time
        am("TTD: "..UnitName("target").." has healed. :/")
      else
        if current_life == first_life_max then
          first_life = current_life
          first_time = current_time
          am("TTD: Unit is still at 100%. ZZzzzzzZZZZzzz.")
        end
      end
    end
  end
  
  updateTargetStatus = function (self,event,unit)
    --on target change the script needs to reset values
    if event == "PLAYER_TARGET_CHANGED" then
      if script_running == 1 then
        stop_this("target changed")
      end
    end
    if UnitExists("target") then
      player_has_target = 1
      if not UnitIsFriend("player", "target") then
        target_is_hostile = 1
      else
        target_is_hostile = 0
      end
      
      if show_time_mobtype == 1 then
        if UnitLevel("target") == -1 then
          target_is_raidboss = 1
        else
          target_is_raidboss = 0
        end
      elseif show_time_mobtype == 2 then
        if (UnitLevel("target") >= (UnitLevel("player")+3)) or (UnitLevel("target") == -1) then
          target_is_raidboss = 1
        else
          target_is_raidboss = 0
        end
      else
        target_is_raidboss = 1
      end      
      
      if (UnitIsPlayer("target")) then
         target_is_npc = 0
      else
         target_is_npc = 1
      end
      if player_in_combat == 1 and target_is_hostile == 1 and target_is_raidboss == 1 and target_is_npc == 1 and not first_life and UnitHealth("target") > 0 then
        first_life = UnitHealth("target")
        first_life_max = UnitHealthMax("target")
        first_time = GetTime()
        if script_running == 0 then
          activate_this()
        end 
      elseif player_in_combat == 1 and target_is_hostile == 1 and target_is_raidboss == 1 and target_is_npc == 1 and first_life and script_running == 1 then 
        current_life = UnitHealth("target")
        current_time = GetTime()
        calculate_time_to_death()
      else
        if script_running == 1 then
          stop_this("mob level is to low")
        end
      end
    else
      player_has_target = 0
      if script_running == 1 then
        stop_this("no target")
      end
    end
  end  

  
  a:RegisterEvent("PLAYER_REGEN_ENABLED")
  a:RegisterEvent("PLAYER_REGEN_DISABLED")
  a:RegisterEvent("PLAYER_TARGET_CHANGED")
  a:RegisterEvent("PLAYER_LOGIN")
  
  a:SetScript("OnEvent", function(self,event,unit)
    if event == "PLAYER_TARGET_CHANGED" then
      updateTargetStatus(self,event,unit)
    elseif event == "PLAYER_LOGIN" then
      initFrames()
    else
      updateCombatStatus(self,event,unit)
    end
  end)
