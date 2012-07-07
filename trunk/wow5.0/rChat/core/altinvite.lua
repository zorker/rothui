local origSetItemRef = SetItemRef
SetItemRef = function(link, text, button)
  local linkType = string.sub(link, 1, 6)
  if IsAltKeyDown() and linkType == "player" then
    local name = string.match(link, "player:([^:]+)")
    InviteUnit(name)
    return nil
  end
  return origSetItemRef(link,text,button)
end