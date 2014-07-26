
  -- addon data
  local an, at = ... --addon name, addon table

  --local variables
  local G, L, C = at.G, at.L, at.C

  local math = math

  L:Log("number.lua")

  --number abbrev func
  function G:NumAbbrev(n)
    if n > 1E10 then
      return (math.floor(n/1E9)).."b"
    elseif n > 1E9 then
      return (math.floor((n/1E9)*10)/10).."b"
    elseif n > 1E7 then
      return (math.floor(n/1E6)).."m"
    elseif n > 1E6 then
      return (math.floor((n/1E6)*10)/10).."m"
    elseif n > 1E4 then
      return (math.floor(n/1E3)).."k"
    elseif n > 1E3 then
      return (math.floor((n/1E3)*10)/10).."k"
    else
      return n
    end
  end

  L:Log(G:NumAbbrev(3))
  L:Log(G:NumAbbrev(33))
  L:Log(G:NumAbbrev(333))
  L:Log(G:NumAbbrev(3333))
  L:Log(G:NumAbbrev(33333))
  L:Log(G:NumAbbrev(333333))
  L:Log(G:NumAbbrev(3333333))
  L:Log(G:NumAbbrev(33333333))
  L:Log(G:NumAbbrev(333333333))
  L:Log(G:NumAbbrev(3333333333))
  L:Log(G:NumAbbrev(33333333333))
  L:Log(G:NumAbbrev(333333333333))
  L:Log(G:NumAbbrev(3333333333333))

  --check blizzard large number split
  --BreakUpLargeNumbers(n)

  L:Log("~~~~~~~~~~~~~")

  --LARGE_NUMBER_SEPERATOR = ","

  L:Log(BreakUpLargeNumbers(3))
  L:Log(BreakUpLargeNumbers(33))
  L:Log(BreakUpLargeNumbers(333))
  L:Log(BreakUpLargeNumbers(3333))
  L:Log(BreakUpLargeNumbers(33333))
  L:Log(BreakUpLargeNumbers(333333))
  L:Log(BreakUpLargeNumbers(3333333))
  L:Log(BreakUpLargeNumbers(33333333))
  L:Log(BreakUpLargeNumbers(333333333))
  L:Log(BreakUpLargeNumbers(3333333333))
  L:Log(BreakUpLargeNumbers(33333333333))
  L:Log(BreakUpLargeNumbers(333333333333))
  L:Log(BreakUpLargeNumbers(3333333333333))
