  
  FloatingChatFrame_OnMouseScroll = function(self, dir)
  	if(dir > 0) then
  		if(IsShiftKeyDown()) then
  			self:ScrollToTop()
  		else
  		  self:ScrollUp()
  		end
  	else
  		if(IsShiftKeyDown()) then
  			self:ScrollToBottom()
  	  else
  	    self:ScrollDown()
  	  end
  	end
  end