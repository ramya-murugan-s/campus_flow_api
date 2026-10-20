class CreateStudents < ActiveRecord::Migration[7.2]
  def change
    create_table :students do |t|
      t.references :campus, null: false, foreign_key: true
      t.string :name
      t.string :email
      t.date :date_of_birth

      t.timestamps
    end
  end
end
