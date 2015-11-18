Pod::Spec.new do |s|

  s.name         = "LinkedinSwift"
  s.version      = "0.8"
  s.summary      = "Linkedin iOS SDK, using for Swift with iOS 7"

  s.homepage     = "https://github.com/tonyli508/LinkedinSwift.git"
  s.social_media_url = 'https://twitter.com/tonyli508'
  s.license      = { :type => "MIT", :file => "LICENSE" }
  s.author       = { "Li Jiantang" => "tonyli508@gmail.com" }

  s.platform     = :ios, '7.0'

  s.source = { :git => "https://github.com/tonyli508/LinkedinSwift.git", :tag => "#{s.version}" }
  s.preserve_paths      = 'linkedin-sdk.framework'
  s.public_header_files = 'linkedin-sdk.framework/Versions/A/Headers/LISDK.h'
  s.vendored_frameworks = 'linkedin-sdk.framework'
  s.requires_arc = true

end
