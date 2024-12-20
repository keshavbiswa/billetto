class CreateEvents < ActiveRecord::Migration[8.0]
  def change
    # there should be more non nullable fields but for now keeping it simple
    create_table :events do |t|
      t.string :object
      t.string :kind
      t.string :state
      t.string :title, null: false
      t.text :description
      t.string :url
      t.string :image_link
      t.boolean :availablity
      t.string :billetto_id, null: false
      t.datetime :start_date
      t.datetime :end_date

      t.timestamps
    end
  end
end
