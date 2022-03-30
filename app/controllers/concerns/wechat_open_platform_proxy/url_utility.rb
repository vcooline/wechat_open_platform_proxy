module WechatOpenPlatformProxy
  module UrlUtility
    extend ActiveSupport::Concern

    included do
      helper_method :url_with_additional_params
    end

    private

      def url_with_additional_params(url, params = {})
        # Addressable::URI.parse(url).tap{ |uri| uri.query_values = params.with_indifferent_access.reverse_merge(Hash(uri.query_values)) }.normalize.to_s
        URI(url).tap { |uri| uri.query = Rack::Utils.parse_nested_query(uri.query).deep_merge(params).to_query.presence }.to_s
      end
  end
end
