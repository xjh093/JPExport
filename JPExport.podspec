Pod::Spec.new do |s|
  s.name         = 'JPExport'
  s.summary      = 'A tool for convert JOSN object to model file.'
  s.version      = '0.0.1'
  s.license      = { :type => 'MIT'}
  s.authors      = { 'Haocold' => 'xjh093@126.com' }
  s.homepage     = 'https://github.com/xjh093/JPExport'

  s.ios.deployment_target = '8.0'

  s.source       = { :git => 'https://github.com/xjh093/JPExport.git', :tag => s.version}
  
  s.source_files = 'Source/*.{h,m}'
  s.requires_arc = true
  s.framework    = 'UIKit'

end