Pod::Spec.new do |s|
  s.name         = 'Objection'
  s.version      = '1.6.1'
  s.summary      = 'A lightweight dependency injection framework for Objective-C.'
  s.author       = { 'Justin DeWind' => 'dewind@atomicobject.com' }
  s.source       = { :git => 'https://github.com/atomicobject/objection.git', :tag => "#{s.version}" }
  s.homepage     = 'http://www.objection-framework.org'
  s.source_files = 'Source'
  s.license      = { :type => "MIT" }
  s.requires_arc = true

  s.ios.deployment_target = '7.0'
  s.osx.deployment_target = '10.8'
  s.tvos.deployment_target = '9.0'
end
