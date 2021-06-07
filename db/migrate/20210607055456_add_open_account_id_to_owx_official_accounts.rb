class AddOpenAccountIdToOwxOfficialAccounts < ActiveRecord::Migration[6.0]
  def change
    add_belongs_to :owx_official_accounts, :open_account
  end
end
