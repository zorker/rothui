
  -------------------------------------
  -- VARIABLES
  -------------------------------------

  -- addon data
  local an, at = ... --addon name, addon table

  -- local variables
  local G, L, C = at.G, at.L, at.C

  local math, type, tonumber = math, type, tonumber

  -------------------------------------
  -- FUNCTIONS
  -------------------------------------

  -- number abbrev func
  function G:NumAbbrev(n)
    if not G:IsNumber(n) then return n end
    if type(n) ~= "number" then n = tonumber(n) end
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
  
  -- is number func
  function G:IsNumber(n)
    if tonumber(n) then
      return true
    else
      return false
    end
  end

  -------------------------------------
  -- CALLS
  -------------------------------------

  --LARGE_NUMBER_SEPERATOR = ","
  --G:Log(BreakUpLargeNumbers(3))

