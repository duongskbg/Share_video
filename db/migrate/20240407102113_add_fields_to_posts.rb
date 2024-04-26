class AddFieldsToPosts < ActiveRecord::Migration[7.1]
  def change
    add_column :posts, :url_id, :string
    add_column :posts, :string, :string
    add_column :posts, :title, :string
    add_column :posts, :content, :text
  end
end
