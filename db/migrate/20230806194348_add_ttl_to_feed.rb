class AddTtlToFeed < ActiveRecord::Migration[7.1]
  def change
    add_column :feeds, :ttl, :integer, default: 60
  end
end
