class AddStateToPolls < ActiveRecord::Migration
	def change
		add_column :opinion_polls, :state, :string
	end
end
