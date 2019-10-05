Pod::Spec.new do |s|

s.name = 'AETransition'
s.version = '0.3.0'
s.license = { :type => 'MIT', :file => 'LICENSE' }
s.summary = 'Custom transitions for iOS - simple yet powerful'

s.source = { :git => 'https://github.com/tadija/AETransition.git', :tag => s.version }
s.source_files = 'Sources/AETransition/*.swift'

s.swift_versions = ['4.0', '4.2', '5.0', '5.1']

s.ios.deployment_target = '9.0'

s.homepage = 'https://github.com/tadija/AETransition'
s.author = { 'tadija' => 'tadija@me.com' }
s.social_media_url = 'http://twitter.com/tadija'

end
