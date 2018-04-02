class CreateCourseworks < ActiveRecord::Migration[5.1]
  def change
    create_table :courseworks do |t|
      t.string :name
      t.belongs_to :course_module, foreign_key: true

      t.timestamps
    end
  end
end
