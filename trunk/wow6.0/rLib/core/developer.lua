
  -- addon data
  local an, at = ... --addon name, addon table

  --local variables
  local G, L, C = at.G, at.L, at.C

  --log func
  function G:Log(s)
    print(s)
  end

  --local log func
  function L:Log(s)
    print(L.name..": "..s)
  end

  L:Log("hello world")
  L:Log(L.name)
  L:Log(L.version)
  L:Log(L.versionNumber)
  L:Log(L.locale)

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