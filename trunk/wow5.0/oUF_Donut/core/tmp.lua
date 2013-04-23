
  --get the addon namespace
  local addon, ns = ...

  --object container
  local tmp = CreateFrame("Frame")
  ns.tmp = tmp

  ---------------------------------------------
  -- variables
  ---------------------------------------------

  tmp.styles = {}

  ---------------------------------------------
  -- template functions
  ---------------------------------------------

  --template RegisterTemplateByName
  function tmp:RegisterTemplateByName(name,data)
    tmp.styles[name] = data
  end

  --template UnregisterTemplateByName
  function tmp:UnregisterTemplateByName(name)
    tmp.styles[name] = nil
  end

  --template GetTemplateByName
  function tmp:GetTemplateByName(name)
    return tmp.styles[name]
  end