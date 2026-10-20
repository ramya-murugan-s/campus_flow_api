class CreateCampuses < ActiveRecord::Migration[7.2]
  def change
    create_table :campuses do |t|
      t.string :name

      t.timestamps
    end
  end
end
