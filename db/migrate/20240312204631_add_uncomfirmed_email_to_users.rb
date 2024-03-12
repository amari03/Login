class AddUncomfirmedEmailToUsers < ActiveRecord::Migration[7.1]
  def change
    add_column :users, :uncomfirmed_email, :string
  end
end
