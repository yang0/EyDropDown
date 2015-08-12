Pod::Spec.new do |s|
  s.name        = 'EyDropdown'
  s.version     = '1.0.0'
  s.author       = { "yang0" => "137962@qq.com" }
  s.summary      = "一个单选的下拉列表"
  s.homepage     = "https://github.com/yang0/EyDropDown"
  s.license     = { :type => "MIT", :file => "LICENSE" }
  s.source      = { :git => 'https://github.com/yang0/EyDropDown.git'}

  s.platform = :ios, '7.0'
  s.ios.deployment_target = '7.0'
  s.requires_arc = true
  s.source_files = 'EyDropDown/lib/*'
end