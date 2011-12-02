    --get the addon namespace
      local addon, ns = ...

      --get the config values
      local cfg = ns.cfg
      local barcfg = cfg.bars.extrabar

      if not barcfg.disable then

        local num = 1

        local bar = CreateFrame("Frame","rABS_ExtraActionBar",UIParent,"SecureHandlerStateTemplate")
        bar:SetWidth(barcfg.buttonsize*num+barcfg.buttonspacing*(num-1))
        bar:SetHeight(barcfg.buttonsize)
        bar:SetPoint(barcfg.pos.a1,barcfg.pos.af,barcfg.pos.a2,barcfg.pos.x,barcfg.pos.y)
        bar:SetHitRectInsets(-cfg.barinset, -cfg.barinset, -cfg.barinset, -cfg.barinset)
        bar:SetScale(barcfg.barscale)

        cfg.applyDragFunctionality(bar,barcfg.userplaced,barcfg.locked)

        ExtraActionBarFrame:SetParent(bar)
        ExtraActionBarFrame:EnableMouse(false)

        --local txt = "Interface\Addons" --debug
        --print(string.sub(txt,1,9)) --debug

        local disableTexture = function(style, texture)
          if string.sub(texture,1,9) == "Interface" then
            style:SetTexture("")--disable button style texture
          end
        end

        for i=1, num do
          local button = _G["ExtraActionButton"..i]
          if not button then return end
          if button.style then
            print(button.style:GetTexture()) --debug
            button.style:SetTexture("")
            hooksecurefunc(button.style, "SetTexture", disableTexture)
          end
          button:SetSize(barcfg.buttonsize, barcfg.buttonsize)
          button:ClearAllPoints()
          if i == 1 then
            button:SetPoint("BOTTOMLEFT", bar, 0,0)
          else
            local previous = _G["ExtraActionButton"..i-1]
            button:SetPoint("LEFT", previous, "RIGHT", barcfg.buttonspacing, 0)
          end
        end

      end --disable