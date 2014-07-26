
  -------------------------------------
  -- VARIABLES
  -------------------------------------

  -- addon data
  local an, at = ... -- addon name, addon table

  -- local variables
  local G, L, C = at.G, at.L, at.C

  local print = print

  -------------------------------------
  -- FUNCTIONS
  -------------------------------------

  -- log func
  function G:Log(...)
    print(...)
  end

  -- local log func
  function L:Log(...)
    print(L.name..":",...)
  end

  -- get mouse focus func
  function G:GetMouseFocus()
    local f = GetMouseFocus()
    local fn = f:GetName()
    if not fn then
      G:Log("Frame: nil")
      return
    end
    local p = _G[fn]:GetParent()
    if IsModifierKeyDown() then
      if p then
        G:Log("Parent frame: "..p:GetName())
      else
        G:Log("Parent frame: nil")
      end
    else
      G:Log("Frame: "..fn)
    end
  end

  -------------------------------------
  -- CALLS
  -------------------------------------

  local point = {ActionButton1:GetPoint(1)}
  if point[2] and point[2]:GetName() then point[2] = point[2]:GetName() end
  L:Log("|cffff00ffPoint of ActionButton1:|r",point[1],point[2],point[3],point[4],point[5])