class CreateWechatOpenPlatformProxyOfficialAccounts < ActiveRecord::Migration[5.2]
  def change
    create_table :owx_official_accounts do |t|
      t.references :third_party_platform, index: true, foreign_key: {to_table: :owx_third_party_platforms}

      t.string :app_id, index: {unique: true}
      t.string :origin_id, index: {unique: true}

      t.string :nick_name
      t.string :head_img
      t.string :qrcode_url
      t.string :principal_name
      t.jsonb :service_type_info
      t.jsonb :verify_type_info
      t.jsonb :business_info
      t.string :alias
      t.string :signature
      t.jsonb :mini_program_info
      t.jsonb :func_info

      t.timestamps null: false
    end
  end
end
