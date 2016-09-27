class CreateChampionshipParticipationPerformances < ActiveRecord::Migration[5.0]
  def change
    create_table :championship_participation_performances do |t|
      t.belongs_to :participation, index: { name: :index_participation_performaces }
      t.text :performance
      t.string :type

      t.timestamps
    end
  end
end
