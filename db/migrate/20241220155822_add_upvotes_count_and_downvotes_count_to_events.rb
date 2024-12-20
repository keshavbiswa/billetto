class AddUpvotesCountAndDownvotesCountToEvents < ActiveRecord::Migration[8.0]
  def change
    add_column :events, :upvotes_count, :integer, default: 0, null: false
    add_column :events, :downvotes_count, :integer, default: 0, null: false
  end
end
