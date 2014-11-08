module Opinion
	class ApplicationController < ActionController::Base
		include Opinion::ControllerHelper
		helper Opinion::ControllerHelper
	end
end
