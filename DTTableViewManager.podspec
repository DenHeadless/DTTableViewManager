Pod::Spec.new do |s|
  s.name     = 'DTTableViewManager'
  s.version      = "7.2.0"
  s.license  = 'MIT'
  s.summary  = 'Protocol-oriented UITableView management, powered by generics and associated types.'
  s.homepage = 'https://github.com/DenTelezhkin/DTTableViewManager'
  s.authors  = { 'Denys Telezhkin' => 'denys.telezhkin.oss@gmail.com' }
  s.social_media_url = 'https://twitter.com/DenTelezhkin'
  s.source   = { :git => 'https://github.com/DenTelezhkin/DTTableViewManager.git', :tag => s.version.to_s }
  s.source_files = 'Sources/DTTableViewManager/*.swift'
  s.swift_versions = ['5.0']
  s.ios.deployment_target = '11.0'
  s.tvos.deployment_target = '11.0'
  s.frameworks = 'UIKit', 'Foundation'
  s.dependency 'DTModelStorage' , '~> 8.1.0'
end
