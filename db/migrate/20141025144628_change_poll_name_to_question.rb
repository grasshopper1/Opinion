class ChangePollNameToQuestion < ActiveRecord::Migration
	def change
		rename_column :opinion_polls, :description, :question
	end
end
