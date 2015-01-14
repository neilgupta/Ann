class AddLastEmailSent < ActiveRecord::Migration
  def change
    add_column :brains, :last_error_email_sent, :timestamp
  end
end
