class CreateChampionshipParticipations < ActiveRecord::Migration[5.0]
  def change
    create_table :championship_participations do |t|
      t.belongs_to :competitor
      t.belongs_to :championship, foreign_key: true

      t.timestamps
    end
  end
end
