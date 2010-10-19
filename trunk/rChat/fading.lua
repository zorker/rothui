
  local _G = _G
  
  CHAT_TAB_SHOW_DELAY = 0
  CHAT_TAB_HIDE_DELAY = 0
  CHAT_FRAME_FADE_TIME = 0
  CHAT_FRAME_FADE_OUT_TIME = 0
  CHAT_FRAME_BUTTON_FRAME_MIN_ALPHA = 0
  
  CHAT_FRAME_TAB_SELECTED_MOUSEOVER_ALPHA = 1.0
  CHAT_FRAME_TAB_SELECTED_NOMOUSE_ALPHA = 0.4
  CHAT_FRAME_TAB_ALERTING_MOUSEOVER_ALPHA = 1.0
  CHAT_FRAME_TAB_ALERTING_NOMOUSE_ALPHA = 0.4
  CHAT_FRAME_TAB_NORMAL_MOUSEOVER_ALPHA = 0.6
  CHAT_FRAME_TAB_NORMAL_NOMOUSE_ALPHA = 0
  
  DEFAULT_CHATFRAME_ALPHA = 0

  local CHAT_TEXTURES = {
    "Background",
    "TopLeftTexture",
    "BottomLeftTexture",
    "TopRightTexture",
    "BottomRightTexture",
    "LeftTexture",
    "RightTexture",
    "BottomTexture",
    "TopTexture",
  }
  
  local TAB_TEXTURES = {
    "Left",
    "Middle",
    "Right",
    "SelectedLeft",
    "SelectedMiddle",
    "SelectedRight",
    "Glow",
    "HighlightLeft",
    "HighlightMiddle",
    "HighlightRight",
  }
  
  --disable all tab textures
  for i = 1, NUM_CHAT_WINDOWS do
    for index, value in pairs(TAB_TEXTURES) do
      local texture = _G['ChatFrame'..i..'Tab'..value]
      texture:SetTexture(nil)
    end
  end

  --[[
    --tab textures
    --either way disable textures in lua or replace the textures in folder with transparent ones
    <Layers>
      <Layer level="BACKGROUND">
        <Texture name="$parent" file="Interface\ChatFrame\ChatFrameTab-BGLeft" parentKey="leftTexture">
        <Texture name="$parent" file="Interface\ChatFrame\ChatFrameTab-BGMid" horizTile="true" parentKey="middleTexture">
        <Texture name="$parent" file="Interface\ChatFrame\ChatFrameTab-BGRight" parentKey="rightTexture">
      </Layer>
      <Layer level="BORDER">
        <Texture name="$parent" file="Interface\ChatFrame\ChatFrameTab-SelectedLeft" alphaMode="ADD" parentKey="leftSelectedTexture">
        <Texture name="$parent" file="Interface\ChatFrame\ChatFrameTab-SelectedMid" horizTile="true" alphaMode="ADD" parentKey="middleSelectedTexture">
        <Texture name="$parent" file="Interface\ChatFrame\ChatFrameTab-SelectedRight" alphaMode="ADD" parentKey="rightSelectedTexture">
        <Texture name="$parent" file="Interface\ChatFrame\ChatFrameTab-NewMessage" parentKey="glow" alphaMode="ADD" hidden="true">
      </Layer>
      <Layer level="HIGHLIGHT">
        <Texture name="$parent" file="Interface\ChatFrame\ChatFrameTab-HighlightLeft" alphaMode="ADD" parentKey="leftHighlightTexture">
        <Texture name="$parent" file="Interface\ChatFrame\ChatFrameTab-HighlightMid" horizTile="true" alphaMode="ADD" parentKey="middleHighlightTexture">
        <Texture name="$parent" file="Interface\ChatFrame\ChatFrameTab-HighlightRight" alphaMode="ADD" parentKey="rightHighlightTexture">
      </Layer>
    </Layers>
  ]]--


  local function init()

    --disable tab flashing
    FCF_FlashTab = function() end    

    --new fadein func
    FCF_FadeInChatFrame = function(chatFrame)
    
      local frameName = chatFrame:GetName()
      chatFrame.hasBeenFaded = true  
      
      for index, value in pairs(CHAT_TEXTURES) do
        local object = _G[frameName..value]
        if ( object:IsShown() ) then
          object:SetAlpha(chatFrame.oldAlpha or 1)
        end
      end
      
      local chatTab = _G[frameName.."Tab"]
      if chatTab then
        chatTab:SetAlpha(chatTab.mouseOverAlpha or 1)
      end
    end

    --new fadeout func
    FCF_FadeOutChatFrame = function(chatFrame)
      local frameName = chatFrame:GetName()
      chatFrame.hasBeenFaded = false
      
      for index, value in pairs(CHAT_TEXTURES) do
        local object = _G[frameName..value]
        if ( object:IsShown() ) then
          object:SetAlpha(0)
        end
      end
      
      local chatTab = _G[frameName.."Tab"]
      if chatTab then
        chatTab:SetAlpha(chatTab.noMouseAlpha)
      end
    end    

  end  
  
  local a = CreateFrame("Frame")

  a:SetScript("OnEvent", function(self, event)
    if(event=="PLAYER_LOGIN") then
      init()
    end
  end)
  
  a:RegisterEvent("PLAYER_LOGIN")