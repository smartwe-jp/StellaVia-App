Pod::Spec.new do |s|
  s.name             = 'flutter_bdface_collect'
  s.version          = '1.1.9'
  s.summary          = 'A Baidu finance face collect plugin that keeps the legacy Flutter API.'
  s.description      = <<-DESC
A Baidu finance face collect plugin that keeps the legacy Flutter API.
                       DESC
  s.homepage         = 'http://example.com'
  s.license          = { :type => 'MIT' }
  s.author           = { 'OpenAI' => 'support@openai.com' }
  s.source           = { :path => '.' }
  s.static_framework = true
  s.source_files = 'Classes/**/*'
  s.public_header_files = 'Classes/**/*.h'
  s.resources = ['BDFaceSDK/*.bundle', 'BDFaceSDK/*.json']
  s.vendored_frameworks = 'BDFaceSDK/*.framework'
  s.frameworks = ['CoreTelephony', 'AVFoundation', 'AudioToolbox', 'CoreMedia', 'CoreVideo', 'QuartzCore']
  s.libraries = ['c++', 'z']
  s.xcconfig = { 'OTHER_LDFLAGS' => '-ObjC' }
  s.dependency 'Flutter'
  s.platform = :ios, '11.0'
  s.pod_target_xcconfig = {
    'DEFINES_MODULE' => 'YES',
    'EXCLUDED_ARCHS[sdk=iphonesimulator*]' => 'i386'
  }
end
