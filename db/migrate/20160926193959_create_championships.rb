class CreateChampionships < ActiveRecord::Migration[5.0]
  def change
    create_table :championships do |t|
      t.string :name
      t.string :type
      t.boolean :open, default: true

      t.timestamps
    end
  end
end
