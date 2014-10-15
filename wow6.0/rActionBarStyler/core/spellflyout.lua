
  --spell flyout fader

  --this one is tricky...when hovering a bar with mouveover fading you want the bar to stay when leaving the bar but hovering the flyoutframe
  --thus on loadup of the flyout frame the fader has to adept to the current flyout button

  local function addFlyoutFramesToFader(self)
    --print(self:GetParent():GetParent():GetParent():GetName())
    local frame = self:GetParent():GetParent():GetParent()
    if frame and frame.mouseover and frame.mouseover.enable then
      local NUM_FLYOUT_BUTTONS = 10
      local buttonList = {}
      for i = 1, NUM_FLYOUT_BUTTONS do
        local button = _G["SpellFlyoutButton"..i]
        if button then
          table.insert(buttonList, button) --add the button object to the list
        end
      end
      rSpellFlyoutFader(frame,buttonList,frame.mouseover.fadeIn,frame.mouseover.fadeOut)
    end
  end
  SpellFlyout:HookScript("OnShow",addFlyoutFramesToFader)