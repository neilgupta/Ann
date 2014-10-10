class InitialMigration < ActiveRecord::Migration
  def change
    create_table :brains do |t|
      t.string :name
      t.string :address
      t.float :extroversion_score
      t.boolean :active, default: false
      t.timestamp :activated_at

      t.timestamps
    end

    create_table :cleverbots do |t|
      t.string :username
      t.text :serialized_bot
      t.belongs_to :brain

      t.timestamps
    end

    create_table :inputs do |t|
      t.text :data
      t.belongs_to :sensor

      t.timestamps
    end

    create_table :instructions do |t|
      t.string :content
      t.timestamp :sent_at
      t.belongs_to :motor

      t.timestamps
    end

    create_table :motors do |t|
      t.string :name
      t.string :address
      t.string :type
      t.string :personality
      t.belongs_to :brain

      t.timestamps
    end

    create_table :sensors do |t|
      t.string :name
      t.string :address
      t.string :type
      t.belongs_to :brain

      t.timestamps
    end
  end
end
