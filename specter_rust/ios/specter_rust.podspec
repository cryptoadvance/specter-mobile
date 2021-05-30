#
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html.
# Run `pod lib lint specter_rust.podspec` to validate before publishing.
#
Pod::Spec.new do |s|
  s.name             = 'specter_rust'
  s.version          = '0.1.0'
  s.summary          = 'Rust implementation of Specter Bitcoin wallet.'
  s.description      = <<-DESC
A new flutter plugin project.
                       DESC
  s.homepage         = 'http://specter.solutions'
  s.license          = { :file => '../LICENSE' }
  s.author           = { 'Specter Solutions (Crypto Advance GmbH)' => 'contact@cryptoadvance.io' }
  s.source           = { :path => '.' }
  s.public_header_files = 'Classes**/*.h'
  s.source_files = 'Classes/**/*'
  s.static_framework = true
  s.vendored_libraries = "**/*.a"
  s.dependency 'Flutter'
  s.platform = :ios, '8.0'

  # Flutter.framework does not contain a i386 slice.
  s.pod_target_xcconfig = { 'DEFINES_MODULE' => 'YES', 'EXCLUDED_ARCHS[sdk=iphonesimulator*]' => 'i386' }
  s.swift_version = '5.0'
end
