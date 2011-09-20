class CreateParticipantHighIntensityStateTransitions < ActiveRecord::Migration
  def change
    create_table :participant_high_intensity_state_transitions do |t|
      t.references :participant
      t.string :event
      t.string :from
      t.string :to
      t.timestamp :created_at
    end
    add_index :participant_high_intensity_state_transitions, :participant_id, :name => 'participant_high_intensity_state_idx'
  end
end
