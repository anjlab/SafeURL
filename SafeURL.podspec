#
# Be sure to run `pod lib lint SafeURL.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = "SafeURL"
  s.version          = "3.4.0"
  s.summary          = "Swift safe NSURL Builder"

  s.description      = <<-DESC
  Provide convinient methods on NSURL to craft urls in safe fashion.

  - Escapes path segements
  - Escapes query parameters
  - Fast
  DESC

  s.homepage         = "https://github.com/anjlab/SafeURL"
  s.license          = 'MIT'
  s.author           = { "Yury Korolev" => "yury.korolev@gmail.com" }
  s.source           = { :git => "https://github.com/anjlab/SafeURL.git", :tag => s.version.to_s }
  s.social_media_url = 'https://twitter.com/anjlab'

  s.requires_arc = true

  s.ios.deployment_target = '8.0'
  s.osx.deployment_target = '10.10'
  s.watchos.deployment_target = '2.0'
  s.tvos.deployment_target = '9.0'

  s.source_files = 'Pod/Classes/**/*'
end
