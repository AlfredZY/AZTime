
Pod::Spec.new do |s|

  s.name         = "AZTime"
  s.version      = "0.0.1"
  s.summary      = "Global countdown manager (support reuse view) + Get local and server time offset"
  s.homepage     = "https://github.com/AlfredZY/AZTime"
  s.license      = "MIT"
  s.license      = { :type => "MIT", :file => "LICENSE" }
  s.author             = { "Alfred Zhang" => "AlfredZhang@foxmail.com" }
  # Or just: s.author    = "Alfred Zhang"
  # s.authors            = { "Alfred Zhang" => "AlfredZhang@foxmail.com" }
  # s.social_media_url   = "http://twitter.com/Alfred"

  # s.platform     = :ios
   s.platform     = :ios, "8.0"

  #  When using multiple platforms
  # s.ios.deployment_target = "5.0"
  # s.osx.deployment_target = "10.7"
  # s.watchos.deployment_target = "2.0"
  # s.tvos.deployment_target = "9.0"

  s.source       = { :git => "https://github.com/AlfredZY/AZTime.git", :tag => s.version }

  s.source_files  =  "AZTime/*.{h,m}"


  # s.resource  = "icon.png"
  # s.resources = "Resources/*.png"



  # ――― Project Linking ―――――――――――――――――――――――――――――――――――――――――――――――――――――――――― #
  #
  #  Link your library with frameworks, or libraries. Libraries do not include
  #  the lib prefix of their name.
  #

  # s.framework  = "SomeFramework"
  # s.frameworks = "SomeFramework", "AnotherFramework"

  # s.library   = "iconv"
  # s.libraries = "iconv", "xml2"


  # ――― Project Settings ――――――――――――――――――――――――――――――――――――――――――――――――――――――――― #
  #
  #  If your library depends on compiler flags you can set them in the xcconfig hash
  #  where they will only apply to your library. If you depend on other Podspecs
  #  you can include multiple dependencies to ensure it works.

   s.requires_arc = true

  # s.xcconfig = { "HEADER_SEARCH_PATHS" => "$(SDKROOT)/usr/include/libxml2" }
  # s.dependency "JSONKit", "~> 1.4"

end
