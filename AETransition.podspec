Pod::Spec.new do |s|

s.name = 'AETransition'
s.version = '0.2.2'
s.license = { :type => 'MIT', :file => 'LICENSE' }
s.summary = 'Custom transitions for iOS - simple yet powerful'

s.source = { :git => 'https://github.com/tadija/AETransition.git', :tag => s.version }
s.source_files = 'Sources/AETransition/*.swift'

s.swift_version = '4.2'

s.ios.deployment_target = '9.0'

s.homepage = 'https://github.com/tadija/AETransition'
s.author = { 'tadija' => 'tadija@me.com' }
s.social_media_url = 'http://twitter.com/tadija'

end
