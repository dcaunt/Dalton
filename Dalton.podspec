Pod::Spec.new do |s|
  s.name             = "Dalton"
  s.version          = "0.0.2"
  s.summary          = "A simple RSS & Atom feed parser"
  s.homepage         = "https://github.com/dcaunt/Dalton"
  s.license          = 'MIT'
  s.author           = { "David Caunt" => "dcaunt@gmail.com" }
  s.source           = { :git => "https://github.com/dcaunt/Dalton.git", :tag => s.version.to_s }
  s.social_media_url = 'https://twitter.com/dcaunt'

  s.source_files = 'Dalton'
  s.public_header_files = 'Dalton/{Dalton,DLTFeed,DLTFeedEntry}.h'
  s.requires_arc = true

  s.ios.deployment_target = '5.0'
  s.osx.deployment_target = '10.7'

  s.dependency 'Ono', '~> 1.0'
end
