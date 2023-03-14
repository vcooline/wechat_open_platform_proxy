class CreateWechatOpenPlatformProxyWebsiteApps < ActiveRecord::Migration[7.0]
  def change
    create_table :owx_website_apps do |t|
      t.string :name
      t.string :app_id, index: { unique: true }
      t.string :app_secret

      t.timestamps
    end
  end
end
