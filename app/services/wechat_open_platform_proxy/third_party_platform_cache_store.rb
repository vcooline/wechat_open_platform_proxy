module WechatOpenPlatformProxy
  class ThirdPartyPlatformCacheStore
    attr_reader :third_party_platform

    def initialize(third_party_platform)
      @third_party_platform = third_party_platform
    end

    def write_component_verify_ticket(content)
      Rails.cache.write("component_verify_ticket_#{third_party_platform.app_id}", content) if content.present?
    end
  end
end
