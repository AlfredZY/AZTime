
Pod::Spec.new do |s|

  s.name         = "AZTime"
  s.version      = "0.0.2"
  s.summary      = "Global countdown manager (support reuse view) + Get local and server time offset"
  s.homepage     = "https://github.com/AlfredZY/AZTime"
  s.license      = { :type => "MIT", :file => "LICENSE" }
  s.author       = { "Alfred Zhang" => "AlfredZhang@foxmail.com" }
  
  s.platform     = :ios, "8.0"
  
  s.source       = { :git => "https://github.com/AlfredZY/AZTime.git", :tag => s.version }
  s.source_files  =  "AZTime/*.{h,m}"

  s.requires_arc = true

end
