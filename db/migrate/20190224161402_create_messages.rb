class CreateMessages < ActiveRecord::Migration[5.2]
  def change
    create_table(:messages) do |t|
      t.string   :type, null: false
      t.string   :target, null: false
      t.text     :body, null: false
      t.datetime :deliver_at, null: false
      t.string   :status, null: false
      t.datetime :delivered_at
      t.integer  :retries_count, null: false, default: 0

      t.timestamps
    end
  end
end
