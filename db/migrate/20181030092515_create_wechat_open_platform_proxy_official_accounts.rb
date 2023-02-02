class CreateWechatOpenPlatformProxyOfficialAccounts < ActiveRecord::Migration[5.2]
  def change
    create_table :owx_official_accounts do |t|
      t.references :third_party_platform, index: true, foreign_key: { to_table: :owx_third_party_platforms }
      t.string :refresh_token

      t.string :app_id
      t.string :original_id

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

      t.index [:third_party_platform_id, :app_id], unique: true, name: "index_owx_official_accounts_on_platform_and_app_id"
      t.index [:third_party_platform_id, :original_id], unique: true, name: "index_owx_official_accounts_on_platform_and_original_id"
    end
  end
end
