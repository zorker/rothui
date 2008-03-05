  
  function rUnits:UpdateLeader()
  	if(UnitIsPartyLeader(self.unit)) then
  		self.Leader:Show()
  	else
  		self.Leader:Hide()
  	end
  end
