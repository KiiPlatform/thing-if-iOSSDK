Pod::Spec.new do |s|
  s.name             = "ThingIFSDK"
  s.version          = "0.13.0"
  s.summary          = "Thing Interaction Framework"

  s.description      = <<-DESC
                        Thing Interaction Framework for iOS
                       DESC

  s.homepage         = "http://www.kii.com"
  s.license          = 'MIT'
  s.author           = { "Kii Cocoapod Admin" => "cocoapod-kii-admin-public@kii.com" }
  s.source           = { :git => "https://github.com/KiiPlatform/thing-if-iOSSDK.git", :tag => "v"+s.version.to_s }

  s.platform     = :ios, '8.0'
  s.requires_arc = true

  s.source_files = 'ThingIFSDK/ThingIFSDK/**/*.swift'

end
