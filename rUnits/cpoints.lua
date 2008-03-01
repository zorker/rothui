  
  local GetComboPoints = GetComboPoints
  
  function pUF:UpdateCPoints()
  	local cp = GetComboPoints()
  	local cpoints = self.CPoints
  	if(cp > 0) then
  		cpoints:SetText(cp)
  	else
  		cpoints:SetText()
  	end
  end