class AddActivationDigestToUsers < ActiveRecord::Migration
  def change
    add_column :users, :activation_digest, :string
    add_column :users, :string, :string
  end
end
