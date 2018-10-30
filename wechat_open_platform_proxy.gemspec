$:.push File.expand_path("lib", __dir__)

# Maintain your gem's version:
require "wechat_open_platform_proxy/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "wechat_open_platform_proxy"
  s.version     = WechatOpenPlatformProxy::VERSION
  s.authors     = ["Andersen Fan"]
  s.email       = ["as181920@gmail.com"]
  s.homepage    = "TODO"
  s.summary     = "TODO: Summary of WechatOpenPlatformProxy."
  s.description = "TODO: Description of WechatOpenPlatformProxy."
  s.license     = "MIT"

  s.files = Dir["{app,config,db,lib}/**/*", "MIT-LICENSE", "Rakefile", "README.md"]

  s.add_dependency "rails", "~> 5.2.1"

  s.add_development_dependency "sqlite3"
end
