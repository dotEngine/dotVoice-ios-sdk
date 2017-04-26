Pod::Spec.new do |s|
    s.name             = 'libdotVoice'
    s.version          = '1.0.0'
    s.summary          = 'dotVoice  realtime audio  as a service'


    s.description      = <<-DESC
                        dotVoice realtime audio/video as a service
                       DESC

    s.homepage         = 'https://dot.cc'
    s.license          = { :type => 'MIT', :file => 'LICENSE' }
    s.author           = { 'notedit' => 'notedit@gmail.com' }
    s.source           = { :git => 'https://github.com/dotEngine/dotVoice-ios-sdk.git', :tag => s.version.to_s }

    s.source_files =  'include/DotVoice/*.h'
    s.public_header_files = "include/DotVoice/*.h"
    s.preserve_paths = 'libDotVoice.a'
    s.vendored_libraries = 'libDotVoice.a'


    s.ios.framework = 'AVFoundation', 'AudioToolbox', 'CoreGraphics', 'CoreMedia', 'GLKit', 'UIKit', 'VideoToolbox'
    s.libraries = 'c', 'sqlite3', 'stdc++'
    s.requires_arc = true
    s.dependency  'SocketRocket'
    s.dependency  'AFNetworking/Reachability'
    s.ios.deployment_target = '8.0'
end
