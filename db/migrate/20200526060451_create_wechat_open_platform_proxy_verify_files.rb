class CreateWechatOpenPlatformProxyVerifyFiles < ActiveRecord::Migration[6.0]
  def change
    create_table :owx_verify_files do |t|
      t.string :name, index: { unique: true }
      t.text :content

      t.timestamps
    end
  end
end
