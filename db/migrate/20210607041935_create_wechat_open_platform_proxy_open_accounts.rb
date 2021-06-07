class CreateWechatOpenPlatformProxyOpenAccounts < ActiveRecord::Migration[6.0]
  def change
    create_table :owx_open_accounts do |t|
      t.belongs_to :third_party_platform, index: true, foreign_key: {to_table: :owx_third_party_platforms}
      t.string :app_id, index: {unique: true}
      t.string :principal_name, index: {unique: true}

      t.timestamps
    end
  end
end
