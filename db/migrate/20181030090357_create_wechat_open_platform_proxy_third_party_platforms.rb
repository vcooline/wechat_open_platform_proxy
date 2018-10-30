class CreateWechatOpenPlatformProxyThirdPartyPlatforms < ActiveRecord::Migration[5.2]
  def change
    create_table :owx_third_party_platforms do |t|
      t.string :app_id, index: {unique: true}
      t.string :app_secret

      t.string :messages_checking_token
      t.string :message_encryption_key

      t.timestamps null: false
    end
  end
end
