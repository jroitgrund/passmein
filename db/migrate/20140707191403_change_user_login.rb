class ChangeUserLogin < ActiveRecord::Migration
  reversible do |dir|
    dir.up do
      change_table :users do |t|
        t.remove :password_digest
        t.text :challenge
        t.string :response
      end
    end
    dir.down do
      change_table :users do |t|
        t.remove :challenge
        t.remove :response
        t.string :password_digest
      end
    end
  end
end
