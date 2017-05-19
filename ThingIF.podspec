Pod::Spec.new do |s|
  s.name             = "ThingIF"
  s.version          = "1.0.0"
  s.summary          = "Thing Interaction Framework"

  s.description      = <<-DESC
                        Thing Interaction Framework for iOS uses trait
                       DESC

  s.homepage         = "http://www.kii.com"
  s.license          = 'Apache 2.0'
  s.author           = { "Kii Cocoapod Admin" => "cocoapod-kii-admin-public@kii.com" }
  s.source           = { :git => "https://github.com/KiiPlatform/thing-if-iOSSDK.git", :tag => "v"+s.version.to_s }

  s.platform     = :ios, '8.0'
  s.requires_arc = true

  s.source_files = 'ThingIFSDK/ThingIFSDK/**/*.swift'

end
