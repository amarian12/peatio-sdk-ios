Pod::Spec.new do |spec|

  spec.name         = "Peatio"
  spec.version      = "0.0.7"
  spec.summary      = "PeatioSDK iOS version."
  spec.homepage     = "https://github.com/peatio/peatio-sdk-ios"
  spec.license      = "LICENSE"
  spec.author       = { "wsof401" => "oct.song.wu@gmail.com" }
  spec.platform     = :ios, "10.0"
  spec.source       = { :git => "https://github.com/peatio/peatio-sdk-ios.git", :tag => spec.version }
  spec.source_files  = "PeatioSDK", "PeatioSDK/**/*.swift", "PeatioSDK/**/**/*.swift"
  spec.swift_versions = ['5.0']
 
  spec.dependency "Starscream"
  spec.dependency "SwiftProtobuf"

end
