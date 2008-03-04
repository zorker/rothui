  
  ------------------------------------------------------
  -- rFilter is based on Debuff Filter from porkbone
  ------------------------------------------------------
  
  ------------------------------------------------------
  -- variables, settings & tables
  ------------------------------------------------------
  
  local rf_DefaultSettings = {
    tdebuffs        = true,
    tbuffs          = false,
    pdebuffs        = false,
    pbuffs          = true,
    scale           = 1,
    tdebuff_layout  = {grow="rightdown", per_row=8, time_tb="bottom", time_lr="right"},
    tbuff_layout    = {grow="rightdown", per_row=8, time_tb="bottom", time_lr="right"},
    pdebuff_layout  = {grow="rightdown", per_row=8, time_tb="bottom", time_lr="right"},
    pbuff_layout    = {grow="rightdown", per_row=8, time_tb="bottom", time_lr="right"},
    count           = false,
    cooldowncount   = true,
    combat          = true,
    tooltips        = true,
    lock =          true,
    tdebuff_list = {
      ["Rüstung zerreißen"] = {},
      ["Demoralisierender Ruf"] = {},
      ["Donnerknall"] = {},
      ["Feenfeuer"] = {},
      ["Fluch der Schwäche"] = {},
    },
    tbuff_list = {
      ["Renew"] = {},
      ["Rejuvenation"] = {},
    },
    pdebuff_list = {
      ["Bloodboil"] = {},
      ["Carrion Swarm"] = {},
    },
    pbuff_list = {
      ["Schlachtruf"] = {},
      ["Befehlsruf"] = {},
    },
  }
  
  local _G = getfenv(0);
  local rf = {};
  local rf_PlayerConfig;
  
  rf.Orientation = {
    rightdown = { point="LEFT", relpoint="RIGHT", x=4, y=0 },
    rightup = { point="LEFT", relpoint="RIGHT", x=4, y=0 },
    leftdown = { point="RIGHT", relpoint="LEFT", x=-4, y=0 },
    leftup = { point="RIGHT", relpoint="LEFT", x=-4, y=0 },
    bottom = { point="TOP", relpoint="BOTTOM", x=0, y=-2, next_time="top" },
    top = { point="BOTTOM", relpoint="TOP", x=0, y=2, next_time="bottom" },
    left = { point="RIGHT", relpoint="LEFT", x=-4, y=0, next_time="right" },
    right = { point="LEFT", relpoint="RIGHT", x=4, y=0, next_time="left" },
  }
  
  rf.Frames = {
    rf_TDebuffFrame = { option_key="tdebuffs",  list_key="tdebuff_list",  layout_key="tdebuff_layout",  name="tdebuff",   button="rf_TDebuffButton" },
    rf_TBuffFrame   = { option_key="tbuffs",    list_key="tbuff_list",    layout_key="tbuff_layout",    name="tbuff",     button="rf_TBuffButton" },
    rf_PDebuffFrame = { option_key="pdebuffs",  list_key="pdebuff_list",  layout_key="pdebuff_layout",  name="pdebuff" ,  button="rf_PDebuffButton" },
    rf_PBuffFrame   = { option_key="pbuffs",    list_key="pbuff_list",    layout_key="pbuff_layout",    name="pbuff",     button="rf_PBuffButton" },
  }
  
  rf.Stacks = {
    debuffs = {},
    buffs = {},
    pdebuffs = {},
    pbuffs = {},
    fdebuffs = {},
    fbuffs = {},
  }
  
  
  ---------------------------
  -- rf_Initialize
  ---------------------------
  
  local function rf_Initialize()
    if (not rf_Config) then
      rf_Config = {};
    end
  
    if (not rf_Config[rf_Player]) then
      rf_Config[rf_Player] = {};
    end
  
    rf_PlayerConfig = rf_Config[rf_Player];
  
    for k, v in pairs(rf_PlayerConfig) do
      if (rf_DefaultSettings[k] == nil) then
        rf_PlayerConfig[k] = nil;
      end
    end
  
    for k, v in pairs(rf_DefaultSettings) do
      if (rf_PlayerConfig[k] == nil) then
        rf_PlayerConfig[k] = v;
      elseif (rf_PlayerConfig[k] == "yes") then
        rf_PlayerConfig[k] = true;
      elseif (rf_PlayerConfig[k] == "no") then
        rf_PlayerConfig[k] = false;
      end
    end
  
    local list_key, layout;
  
    for k, v in pairs(rf.Frames) do
      list_key = v.list_key;
      layout = rf_PlayerConfig[v.layout_key];
  
      for listk, listv in pairs(rf_PlayerConfig[list_key]) do
        if (listv == 1) then
          rf_PlayerConfig[list_key][listk] = {};
        end
      end
  
      if (not rf_PlayerConfig[v.option_key]) then
        _G[k]:Hide();
      end
  
      if (rf_PlayerConfig.count) then
        _G[k .. "Count"]:Show();
      end
  
      rf_SetCountOrientation(layout, k);
    end
  
    if (rf_PlayerConfig.lock) then
      rf_LockFrames(true);
    end
  
    if (rf_PlayerConfig.combat) then
      this:RegisterEvent("PLAYER_REGEN_DISABLED");
      this:RegisterEvent("PLAYER_REGEN_ENABLED");
  
      if (not UnitAffectingCombat("player")) then
        this:Hide();
      end
    end
  
  end
  
  
  ---------------------------
  -- rf_OnMouseDown
  ---------------------------
  
  function rf_OnMouseDown(arg1)
    if (arg1 == "LeftButton" and IsShiftKeyDown()) then
      this:GetParent():StartMoving();
    elseif (arg1 == "RightButton" and IsControlKeyDown()) then
      local next_time;
      local frame = this:GetParent():GetName();
      local layout_key = rf.Frames[frame].layout_key;
      local layout = rf_PlayerConfig[layout_key];
  
      if (layout.per_row == 1) then
        next_time = rf.Orientation[layout.time_lr].next_time;
        layout.time_lr = next_time;
      else
        next_time = rf.Orientation[layout.time_tb].next_time;
        layout.time_tb = next_time;
      end
  
      rf_SetTimeOrientation(next_time, rf.Frames[frame].button);
      rf_Print(rf.Frames[frame].name .. " time orientation: " .. next_time);
    end
  end
  
  
  ---------------------------
  -- rf_OnMouseUp
  ---------------------------
  
  function rf_OnMouseUp(arg1)
    if (arg1 == "LeftButton") then
      this:GetParent():StopMovingOrSizing();
    end
  end
  
  
  ---------------------------
  -- rf_OnLoad
  ---------------------------
  
  function rf_OnLoad()
    rf_Player = (UnitName("player").." - "..GetRealmName());
    this:RegisterEvent("VARIABLES_LOADED");
    this:RegisterEvent("PLAYER_LOGIN");
    this:RegisterEvent("PLAYER_TARGET_CHANGED");
    this:RegisterEvent("PLAYER_AURAS_CHANGED");
    this:RegisterEvent("UNIT_AURA");
  end
  
  
  ---------------------------
  -- rf_Button_OnLoad
  ---------------------------
  
  function rf_Button_OnLoad()
    local name = this:GetName();
  
    this.icon = _G[name .. "Icon"];
    this.time = _G[name .. "Duration"];
    this.cooldown = _G[name .. "Cooldown"];
    this.count = _G[name .. "Count"];
    this.count2 = _G[name .. "Count2"];
    this.border = _G[name .. "Border"];
    this.update = 0;
  end
  
  
  ---------------------------
  -- rf_ShowButton
  ---------------------------
  
  function rf_ShowButton(button, index, texture, applications, duration, timeleft, target)
    button.index = index;
    button.duration = duration;
    button.target = target;
    button.icon:SetTexture(texture);
  
    if (applications > 1) then
      button.count:SetText(applications);
      button.count:Show();
    else
      button.count:Hide();
    end
  
    if (duration and duration > 0) then
      if (not rf_PlayerConfig.cooldowncount) then
        rf_SetTime(button, timeleft);
        button.time:Show();
      else
        CooldownFrame_SetTimer(button.cooldown, GetTime()-(duration-timeleft), duration, 1);
      end
    else
      button.time:Hide();
      button.cooldown:Hide();
  
      if (button.timer) then
        button.timer:Hide();
      end
    end
  
    button:Show();
  end
  
  
  ---------------------------
  -- rf_HideButton
  ---------------------------
  
  function rf_HideButton(button)
    if (button) then
      button:Hide();
    end
  end
  
  
  ---------------------------
  -- rf_TDebuffFrame_Update
  ---------------------------
  
  function rf_TDebuffFrame_Update()
    if (not rf_PlayerConfig.tdebuffs) then
      return;
    end
  
    local button;
    local name, texture, applications, debufftype, duration, timeleft;
    local selfapplied, dontcombine, texturefilter;
    local nametexture, color;
    local width = 0;
  
    for i = 1, 40 do
      name, _, texture, applications, debufftype, duration, timeleft = UnitDebuff("target", i);
  
      if (not texture) then
        break;
      end
  
      rf_TDebuffFrameCount:SetText(i);
  
      if (rf_PlayerConfig.tdebuff_list[name]) then
        selfapplied = rf_PlayerConfig.tdebuff_list[name].selfapplied;
        dontcombine = rf_PlayerConfig.tdebuff_list[name].dontcombine;
        texturefilter = rf_PlayerConfig.tdebuff_list[name].texture;
  
        if (not selfapplied or duration) and (not texturefilter or string.match(texture, texturefilter)) then
          nametexture = name .. texture;
  
          if (not dontcombine and rf.Stacks.tdebuffs[nametexture]) then
            button = _G["rf_TDebuffButton" .. rf.Stacks.tdebuffs[nametexture]];
  
            rf_CombineStacks(button);
  
            if (duration and duration > 0) then
              rf_ShowButton(button, i, texture, applications, duration, timeleft, "target");
            end
          elseif (width < 8) then
            if (debufftype) then
              color = DebuffTypeColor[debufftype];
            else
              color = DebuffTypeColor["none"];
            end
  
            width = width + 1;
  
            button = _G["rf_TDebuffButton" .. width];
  
            if (not button) then
              button = CreateFrame("Button", "rf_TDebuffButton" .. width, rf_TDebuffFrame, "rf_TDebuffButtonTemplate");
              button:EnableMouse(not rf_PlayerConfig.lock);
              rf_SetButtonLayout(rf_PlayerConfig.tdebuff_layout, "rf_TDebuffFrame", button, width);
            end
  
            --button.border:SetVertexColor(color.r, color.g, color.b);
            button.border:Hide();
            button.count2:SetText("");
            rf_ShowButton(button, i, texture, applications, duration, timeleft, "target");
  
            rf.Stacks.tdebuffs[nametexture] = width;
          end
        end
      end
    end
  
    for i = width+1, 8 do
      rf_HideButton(_G["rf_TDebuffButton" .. i]);
    end
  
    if (width == 0) then
      rf_TDebuffFrameCount:SetText("");
    end
  
    for k in pairs(rf.Stacks.tdebuffs) do
      rf.Stacks.tdebuffs[k] = nil;
    end
  end
  
  
  ---------------------------
  -- rf_TBuffFrame_Update
  ---------------------------
  
  function rf_TBuffFrame_Update()
    if (not rf_PlayerConfig.tbuffs) then
      return;
    end
  
    local button;
    local name, texture, applications, duration, timeleft;
    local selfapplied, dontcombine, texturefilter;
    local nametexture;
    local width = 0;
  
    for i = 1, 24 do
      name, _, texture, applications, duration, timeleft = UnitBuff("target", i);
  
      if (not texture) then
        break;
      end
  
      rf_TBuffFrameCount:SetText(i);
  
      if (rf_PlayerConfig.tbuff_list[name]) then
        selfapplied = rf_PlayerConfig.tbuff_list[name].selfapplied;
        dontcombine = rf_PlayerConfig.tbuff_list[name].dontcombine;
        texturefilter = rf_PlayerConfig.tbuff_list[name].texture;
  
        if (not selfapplied or duration) and (not texturefilter or string.match(texture, texturefilter)) then
          nametexture = name .. texture;
  
          if (not dontcombine and rf.Stacks.tbuffs[nametexture]) then
            button = _G["rf_TBuffButton" .. rf.Stacks.tbuffs[nametexture]];
  
            rf_CombineStacks(button);
  
            if (duration and duration > 0) then
              rf_ShowButton(button, i, texture, applications, duration, timeleft, "target");
            end
          elseif (width < 8) then
            width = width + 1;
  
            button = _G["rf_TBuffButton" .. width];
  
            if (not button) then
              button = CreateFrame("Button", "rf_TBuffButton" .. width, rf_TBuffFrame, "rf_TBuffButtonTemplate");
              button:EnableMouse(not rf_PlayerConfig.lock);
              rf_SetButtonLayout(rf_PlayerConfig.tbuff_layout, "rf_TBuffFrame", button, width);
            end
  
            button.count2:SetText("");
            rf_ShowButton(button, i, texture, applications, duration, timeleft, "target");
  
            rf.Stacks.tbuffs[nametexture] = width;
          end
        end
      end
    end
  
    for i = width+1, 8 do
      rf_HideButton(_G["rf_TBuffButton" .. i]);
    end
  
    if (width == 0) then
      rf_TBuffFrameCount:SetText("");
    end
  
    for k in pairs(rf.Stacks.tbuffs) do
      rf.Stacks.tbuffs[k] = nil;
    end
  end
  
  
  ---------------------------
  -- rf_PDebuffFrame_Update
  ---------------------------
  
  function rf_PDebuffFrame_Update()
    if (not rf_PlayerConfig.pdebuffs) then
      return;
    end
  
    local button;
    local name, texture, applications, debufftype, duration, timeleft;
    local selfapplied, dontcombine, texturefilter;
    local nametexture, color;
    local width = 0;
  
    for i = 1, 40 do
      name, _, texture, applications, debufftype, duration, timeleft = UnitDebuff("player", i);
  
      if (not texture) then
        break;
      end
  
      rf_PDebuffFrameCount:SetText(i);
  
      if (rf_PlayerConfig.pdebuff_list[name]) then
        selfapplied = rf_PlayerConfig.pdebuff_list[name].selfapplied;
        dontcombine = rf_PlayerConfig.pdebuff_list[name].dontcombine;
        texturefilter = rf_PlayerConfig.pdebuff_list[name].texture;
  
        if (not selfapplied or duration) and (not texturefilter or string.match(texture, texturefilter)) then
          nametexture = name .. texture;
  
          if (not dontcombine and rf.Stacks.pdebuffs[nametexture]) then
            button = _G["rf_PDebuffButton" .. rf.Stacks.pdebuffs[nametexture]];
  
            rf_CombineStacks(button);
  
            if (duration and duration > 0) then
              rf_ShowButton(button, i, texture, applications, duration, timeleft, "player");
            end
          elseif (width < 8) then
            if (debufftype) then
              color = DebuffTypeColor[debufftype];
            else
              color = DebuffTypeColor["none"];
            end
  
            width = width + 1;
  
            button = _G["rf_PDebuffButton" .. width];
  
            if (not button) then
              button = CreateFrame("Button", "rf_PDebuffButton" .. width, rf_PDebuffFrame, "rf_PDebuffButtonTemplate");
              button:EnableMouse(not rf_PlayerConfig.lock);
              rf_SetButtonLayout(rf_PlayerConfig.pdebuff_layout, "rf_PDebuffFrame", button, width);
            end
  
            --button.border:SetVertexColor(color.r, color.g, color.b);
            button.border:Hide();
            button.count2:SetText("");
            rf_ShowButton(button, i, texture, applications, duration, timeleft, "player");
  
            rf.Stacks.pdebuffs[nametexture] = width;
          end
        end
      end
    end
  
    for i = width+1, 8 do
      rf_HideButton(_G["rf_PDebuffButton" .. i]);
    end
  
    if (width == 0) then
      rf_PDebuffFrameCount:SetText("");
    end
  
    for k in pairs(rf.Stacks.pdebuffs) do
      rf.Stacks.pdebuffs[k] = nil;
    end
  end
  
  
  ---------------------------
  -- rf_PBuffFrame_Update
  ---------------------------
  
  function rf_PBuffFrame_Update()
    if (not rf_PlayerConfig.pbuffs) then
      return;
    end
  
    local button;
    local name, texture, applications, duration, timeleft;
    local selfapplied, dontcombine, texturefilter;
    local nametexture;
    local width = 0;
  
    for i = 1, 24 do
      name, _, texture, applications, duration, timeleft = UnitBuff("player", i);
  
      if (not texture) then
        break;
      end
  
      rf_PBuffFrameCount:SetText(i);
  
      if (rf_PlayerConfig.pbuff_list[name]) then
        selfapplied = rf_PlayerConfig.pbuff_list[name].selfapplied;
        dontcombine = rf_PlayerConfig.pbuff_list[name].dontcombine;
        texturefilter = rf_PlayerConfig.pbuff_list[name].texture;
  
        if (not selfapplied or duration) and (not texturefilter or string.match(texture, texturefilter)) then
          nametexture = name .. texture;
  
          if (not dontcombine and rf.Stacks.pbuffs[nametexture]) then
            button = _G["rf_PBuffButton" .. rf.Stacks.pbuffs[nametexture]];
  
            rf_CombineStacks(button);
  
            if (duration and duration > 0) then
              rf_ShowButton(button, i, texture, applications, duration, timeleft, "player");
            end
          elseif (width < 8) then
            width = width + 1;
  
            button = _G["rf_PBuffButton" .. width];
  
            if (not button) then
              button = CreateFrame("Button", "rf_PBuffButton" .. width, rf_PBuffFrame, "rf_PBuffButtonTemplate");
              button:EnableMouse(not rf_PlayerConfig.lock);
              rf_SetButtonLayout(rf_PlayerConfig.pbuff_layout, "rf_PBuffFrame", button, width);
            end
  
            button.count2:SetText("");
            rf_ShowButton(button, i, texture, applications, duration, timeleft, "player");
  
            rf.Stacks.pbuffs[nametexture] = width;
          end
        end
      end
    end
  
    for i = width+1, 8 do
      rf_HideButton(_G["rf_PBuffButton" .. i]);
    end
  
    if (width == 0) then
      rf_PBuffFrameCount:SetText("");
    end
  
    for k in pairs(rf.Stacks.pbuffs) do
      rf.Stacks.pbuffs[k] = nil;
    end
  end
  
  
  ---------------------------
  -- rf_OnEvent
  ---------------------------
  
  function rf_OnEvent(event)
    if (event == "UNIT_AURA" and arg1 == "target") then
      rf_TDebuffFrame_Update();
      rf_TBuffFrame_Update();
    elseif (event == "PLAYER_TARGET_CHANGED") then
      rf_TDebuffFrame_Update();
      rf_TBuffFrame_Update();
    elseif (event == "PLAYER_AURAS_CHANGED") then
      rf_PDebuffFrame_Update();
      rf_PBuffFrame_Update();
    elseif (event == "PLAYER_REGEN_DISABLED") then
      this:Show();
    elseif (event == "PLAYER_REGEN_ENABLED") then
      this:Hide();
    elseif (event == "VARIABLES_LOADED") then
      this:UnregisterEvent(event);
      rf_Initialize();
    elseif (event == "PLAYER_LOGIN") then
      this:UnregisterEvent(event);
      this:SetScale(rf_PlayerConfig.scale);
    end
  end
  
  
  ---------------------------
  -- rf_TDebuffButton_OnUpdate
  ---------------------------
  
  function rf_TDebuffButton_OnUpdate(elapsed)
    if (not this.duration or this.duration == 0 or rf_PlayerConfig.cooldowncount) then
      return;
    end
  
    this.update = this.update + elapsed;
    if (this.update >= 1) then
      this.update = this.update - 1;
  
      local _, _, _, _, _, _, timeleft = UnitDebuff(this.target, this.index);
  
      rf_SetTime(this, timeleft);
    end
  end
  
  
  ---------------------------
  -- rf_TBuffButton_OnUpdate
  ---------------------------
  
  function rf_TBuffButton_OnUpdate(elapsed)
    if (not this.duration or this.duration == 0 or rf_PlayerConfig.cooldowncount) then
      return;
    end
  
    this.update = this.update + elapsed;
    if (this.update >= 1) then
      this.update = this.update - 1;
  
      local _, _, _, _, _, timeleft = UnitBuff(this.target, this.index);
  
      rf_SetTime(this, timeleft);
    end
  end
  
  
  ---------------------------
  -- rf_PDebuffButton_OnUpdate
  ---------------------------
  
  function rf_PDebuffButton_OnUpdate(elapsed)
    if (not this.duration or this.duration == 0 or rf_PlayerConfig.cooldowncount) then
      return;
    end
  
    this.update = this.update + elapsed;
    if (this.update >= 1) then
      this.update = this.update - 1;
  
      local _, _, _, _, _, _, timeleft = UnitDebuff("player", this.index);
  
      rf_SetTime(this, timeleft);
    end
  end
  
  
  ---------------------------
  -- rf_PBuffButton_OnUpdate
  ---------------------------
  
  function rf_PBuffButton_OnUpdate(elapsed)
    if (not this.duration or this.duration == 0 or rf_PlayerConfig.cooldowncount) then
      return;
    end
  
    this.update = this.update + elapsed;
    if (this.update >= 1) then
      this.update = this.update - 1;
  
      local _, _, _, _, _, timeleft = UnitBuff("player", this.index);
  
      rf_SetTime(this, timeleft);
    end
  end
  
  
  ---------------------------
  -- rf_CombineStacks
  ---------------------------
  
  function rf_CombineStacks(button)
    local total = (tonumber(button.count2:GetText()) or 1) + 1;
    button.count2:SetText(total);
  end
  
  
  ---------------------------
  -- rf_SetTime
  ---------------------------
  
  function rf_SetTime(button, time)
    time = floor(time or 0);
  
    local min, sec;
  
    if ( time >= 60 ) then
      min = floor(time/60);
      sec = time - min*60;
    else
      sec = time;
      min = 0;
    end
  
    if ( sec <= 9 ) then sec = "0" .. sec; end
    if ( min <= 9 ) then min = "0" .. min; end
  
    if (10 >= time) then
      button.time:SetTextColor(1, 0, 0);
    else
      button.time:SetTextColor(1, 0.82, 0);
    end
  
    button.time:SetText(min .. ":" .. sec);
  end
  
  
  ---------------------------
  -- rf_UpdateLayout
  ---------------------------
  
  function rf_UpdateLayout(frame)
    local button;
    local name = rf.Frames[frame].button;
    local layout_key = rf.Frames[frame].layout_key;
    local layout = rf_PlayerConfig[layout_key];
  
    for i = 1, 16 do
      button = _G[name .. i];
  
      if (not button) then
        break;
      end
  
      button:ClearAllPoints();
      rf_SetButtonLayout(layout, frame, button, i);
    end
  
    rf_SetCountOrientation(layout, frame);
  end
  
  
  ---------------------------
  -- rf_SetButtonLayout
  ---------------------------
  
  function rf_SetButtonLayout(layout, frame, button, index)
    local point, relpoint, x, y;
    local grow = layout.grow;
    local per_row = layout.per_row;
    local offset = 14;
  
    point, relpoint = rf.Orientation[grow].point, rf.Orientation[grow].relpoint;
    x, y = rf.Orientation[grow].x, rf.Orientation[grow].y;
  
    if (per_row == 1 or rf_PlayerConfig.cooldowncount) then
      offset = 4;
      rf_SetTimeOrientation(layout.time_lr, button);
    else
      rf_SetTimeOrientation(layout.time_tb, button);
    end
  
    if (index > 1) then
      if (mod(index, per_row) == 1 or per_row == 1) then
        if (layout.grow == "rightdown" or layout.grow == "leftdown") then
          button:SetPoint("TOP", rf.Frames[frame].button .. (index-per_row), "BOTTOM", 0, -offset);
        else
          button:SetPoint("BOTTOM", rf.Frames[frame].button .. (index-per_row), "TOP", 0, offset);
        end
      else
        rf_SetTimeOrientation(layout.time_tb, button);
        button:SetPoint(point, rf.Frames[frame].button .. (index-1), relpoint, x, y)
      end
    else
      button:SetPoint(point, frame, point, 0, 0);
    end
  end
  
  
  ---------------------------
  -- rf_SetTimeOrientation
  ---------------------------
  
  function rf_SetTimeOrientation(orientation, button)
    local point, relpoint, x, y;
  
    point, relpoint = rf.Orientation[orientation].point, rf.Orientation[orientation].relpoint;
    x, y = rf.Orientation[orientation].x, rf.Orientation[orientation].y;
  
    if (button.time) then
      button.time:ClearAllPoints();
      button.time:SetPoint(point, button, relpoint, x, y);
    else
      local time;
      local name = button;
  
      for i = 1, 16 do
        button = name .. i;
        time = _G[button .. "Duration"];
  
        if (not time) then
          break;
        end
  
        time:ClearAllPoints();
        time:SetPoint(point, button, relpoint, x, y);
      end
    end
  end
  
  
  ---------------------------
  -- rf_SetCountOrientation
  ---------------------------
  
  function rf_SetCountOrientation(layout, frame)
    local grow = layout.grow;
    local per_row = layout.per_row;
  
    count = _G[frame .. "Count"];
    count:ClearAllPoints();
  
    if (per_row > 1) then
      if (grow == "rightdown" or grow == "rightup") then
        count:SetPoint("RIGHT", frame, "LEFT", 0, 0);
      else
        count:SetPoint("LEFT", frame, "RIGHT", 0, 0);
      end
    else
      if (grow == "rightdown" or grow == "leftdown") then
        count:SetPoint("BOTTOM", frame, "TOP", 0, 8);
      else
        count:SetPoint("TOP", frame, "BOTTOM", 0, -8);
      end
    end
  end
  
  
  ---------------------------
  -- rf_LockFrames
  ---------------------------
  
  function rf_LockFrames(lock)
    local button;
  
    for k, v in pairs(rf.Frames) do
      _G[k]:EnableMouse(not lock);
  
      for i = 1, 16 do
        button = _G[v.button .. i];
        
        if (not button) then
          break;
        end
  
        button:EnableMouse(not lock);
      end
    end
  end
  
