class CreateGages < ActiveRecord::Migration
  def change
    create_table :gages do |t|
      t.string :title
      t.text :content
    end
  end
end
