class CreateOpinionOptions < ActiveRecord::Migration
  def change
    create_table :opinion_options do |t|
      t.string :description
      t.integer :poll_id

      t.timestamps
    end
  end
end
