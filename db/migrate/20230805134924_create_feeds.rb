class CreateFeeds < ActiveRecord::Migration[7.1]
  def change
    create_table :feeds do |t|
      t.string :url
      t.string :title
      t.string :site_url
      t.string :etag

      t.timestamps
    end
    add_index :feeds, :url
  end
end
