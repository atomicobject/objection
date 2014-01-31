Pod::Spec.new do |s|
  s.name         = 'Objection-SethLab'
  s.version      = '1.3.2'
  s.summary      = 'A lightweight dependency injection framework for Objective-C.'
  s.author       = { 'Justin DeWind' => 'dewind@atomicobject.com' }
  s.source       = { :git => 'https://github.com/sethew/objection.git', :tag => "#{s.version}" }
  s.homepage     = 'http://www.objection-framework.org'
  s.source_files = 'Source'
  s.license      = "https://github.com/atomicobject/objection/blob/master/LICENSE"
  s.requires_arc = true

  s.ios.deployment_target = '5.0'
  s.osx.deployment_target = '10.7'
end
