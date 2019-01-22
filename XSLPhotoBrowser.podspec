
Pod::Spec.new do |s|

  # ―――  Spec Metadata  ―――――――――――――――――――――――――――――――――――――――――――――――――――――――――― #

  s.name         = "XSLPhotoBrowser"
  s.version      = "0.1.0"
  s.swift_version = "4.0"
  s.summary      = " swift版本的图片浏览器"

  # This description is used to generate tags and improve search results.
  
  s.description  = <<-DESC
  			图片浏览器——打开本地和网络图片，依赖Kingfisher，包含fade和Zoom动画。
                   DESC
  s.homepage     = "https://github.com/PEIcode/XSLPhotoBrowser"
  # s.screenshots  = "www.example.com/screenshots_1.gif", "www.example.com/screenshots_2.gif"


  # ―――  Spec License  ――――――――――――――――――――――――――――――――――――――――――――――――――――――――――― #
  
  s.license      = "MIT"
  # s.license      = { :type => "MIT", :file => "FILE_LICENSE" }


  # ――― Author Metadata  ――――――――――――――――――――――――――――――――――――――――――――――――――――――――― #
 
  s.author             = { "Pei丶Code" => "aishiklpz@163.com" }

  # ――― Platform Specifics ――――――――――――――――――――――――――――――――――――――――――――――――――――――― #

  # s.platform     = :ios
  s.platform     = :ios, "8.0"

  # ――― Source Location ―――――――――――――――――――――――――――――――――――――――――――――――――――――――――― #
  
  s.source       = { :git => "https://github.com/PEIcode/XSLPhotoBrowser.git", :tag => "#{s.version}" }


  # ――― Source Code ―――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――― #

  s.source_files  = "XSLPhotoBrowser/Classes/**/*.swift"
  s.static_framework = true
  s.dependency "Kingfisher"
  s.dependency "SDWebImage"

end
