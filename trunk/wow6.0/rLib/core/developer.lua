
  -- addon data
  local an, at = ... --addon name, addon table

  --local variables
  local G, L, C = at.G, at.L, at.C
  
  --log func
  function G:Log(s)
    print(s)
  end
  
  G:Log("hello world")
  G:Log(L.name)
  G:Log(L.version)
  G:Log(L.versionNumber)
  
  --get mouse focus func
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