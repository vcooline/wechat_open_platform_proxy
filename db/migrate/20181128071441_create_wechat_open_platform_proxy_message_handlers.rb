class CreateWechatOpenPlatformProxyMessageHandlers < ActiveRecord::Migration[5.2]
  def change
    create_table :owx_message_handlers do |t|
      t.references :official_account, index: { unique: true }, foreign_key: { to_table: :owx_official_accounts }
      t.string :name, null: false

      t.timestamps null: false
    end
  end
end
