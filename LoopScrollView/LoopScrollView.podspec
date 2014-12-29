Pod::Spec.new do |s|
  s.name         = 'LoopScrollView'
  s.version      = '0.1.0'
  s.license      =  :type => 'MIT'
  s.homepage     = 'https://github.com/qixin1106/LoopScrollView.git'
  s.authors      =  'qixin1106' => ''
  s.summary      = 'Infinite loop scroll view for iOS'

# Source Info
  s.platform     =  :ios, '7.0'
  s.source       =  :git => 'https://github.com/qixin1106/LoopScrollView.git', :tag => 'v0.1.0'
  s.source_files = 'QXLoopScrollView.h,m,QXScrollViewPageControl.h,m'
  s.framework    =  'UIKit'

  s.requires_arc = true
  
# Pod Dependencies

end