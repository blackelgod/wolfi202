class CreateUsers < ActiveRecord::Migration[7.0]
  def change
    create_table :users do |t|
      t.string :uid
      t.string :email
      t.string :username
      t.string :avatar
      t.string :discriminator
      t.boolean :valided
      t.boolean :admin

      t.timestamps
    end
  end
end
