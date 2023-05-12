module WechatOpenPlatformProxy
  class OfficialAccounts::PrivateTemplatesController < OfficialAccounts::BaseController
    before_action :set_private_template, only: [:show]

    def index
      resp = OfficialAccountTemplatedMessageService.new(@official_account).template_list
      render json: JSON.parse(resp.body)["template_list"], status: resp.status
    end

    def show
      if @template.present?
        render json: @template, status: :ok
      else
        render json: {}, status: :not_found
      end
    end

    private

      def set_private_template
        @template = OfficialAccountTemplatedMessageService.new(@official_account).template_list
          .then { |resp| JSON.parse(resp.body)["template_list"] }
          &.then do |list|
            list.detect { |item| item["template_id"] == params[:id] }
          end
      end
  end
end
