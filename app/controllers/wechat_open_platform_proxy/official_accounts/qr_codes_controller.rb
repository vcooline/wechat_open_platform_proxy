module WechatOpenPlatformProxy
  class OfficialAccounts::QrCodesController < OfficialAccounts::BaseController
    before_action :check_remote_ip_whitelisted, only: [:create]

    def create
      resp = OfficialAccountQrCodeService.new(@official_account).create_qrcode(qr_code_params)
      render json: JSON.parse(resp.body), status: resp.status
    end

    private

      def qr_code_params
        params.fetch(:qr_code, {}).permit!
      end
  end
end
