require 'json'
pkg = JSON.parse(File.read("package.json"))

Pod::Spec.new do |s|
  s.name         = pkg["name"]
  s.version      = pkg["version"]
  s.summary      = pkg["description"]
  s.requires_arc = true
  s.license      = pkg["license"]
  s.homepage     = pkg["homepage"]
  s.author       = pkg["author"]
  s.source       = { :git => pkg["repository"]["url"] }
  s.source_files = 'ios/**/*.swift'
  s.platform     = :ios, '16.0'

  s.dependency 'ExpoModulesCore'
  s.dependency 'ForterSDK', '~> 3.1.5'

  s.swift_version = '5.0'
end
