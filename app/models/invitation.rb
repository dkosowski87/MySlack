class Invitation < Msg
	#State
	state_machine :state, :initial => :pending do
		event :accept! do
			transition :pending => :accepted
		end
		event :reject! do
			transition :pending => :rejected
		end
	end
end