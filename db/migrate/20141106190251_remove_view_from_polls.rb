class RemoveViewFromPolls < ActiveRecord::Migration
	def change
		remove_column :opinion_polls, :view
	end
end
