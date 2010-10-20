  
  --get the addon namespace
  local addon, ns = ...  

  --get oUF namespace (just in case needed)
  local oUF = ns.oUF or oUF  
  
  --get the config
  local cfg = ns.cfg  
  
  --object container
  local func = CreateFrame("Frame")
    
  ---------------------------------------------
  -- FUNCTIONS
  ---------------------------------------------
  
  --number format func
  func.numFormat = function(v)
    local string = ""
    if v > 1E6 then
      string = (floor((v/1E6)*10)/10).."m"
    elseif v > 1E3 then
      string = (floor((v/1E3)*10)/10).."k"
    else
      string = v
    end  
    return string
  end
  
  ---------------------------------------------
  -- HANDOVER
  ---------------------------------------------
  
  --object container to addon namespace
  ns.func = func