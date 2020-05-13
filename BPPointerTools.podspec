Pod::Spec.new do |spec|
  spec.name = 'BPPointerTools'
  spec.version = '1.0'
  spec.homepage = 'https://github.com/brunophilipe/BPPointerTools'
  spec.source = {:git => 'https://github.com/brunophilipe/BPPointerTools.git', :tag => 'v1.0'}
  spec.authors = {'Bruno Philipe' => 'git@bruno.ph'}
  spec.summary = 'Helpers to work around issues with the UIPointerInteractions API in iOS 13.4.'
  spec.license = { :type => 'MIT' }

  spec.ios.deployment_target = '11.0'
  spec.ios.frameworks = 'Foundation', 'UIKit'

  spec.source_files = 'BPPointerTools/*.{h,m,swift}'
  spec.module_name = 'BPPointerTools'
end
