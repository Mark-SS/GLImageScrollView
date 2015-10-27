Pod::Spec.new do |s|

  s.name         = "GLImageScrollView"
  s.version      = "0.0.2"
  s.summary      = "Show images in GLImageScrolView"
  s.homepage     = "https://github.com/Mark-SS/GLImageScrollView"
  s.license      = "MIT"
  s.author             = { "markss" => "glqdcs@163.com" }
  s.platform     = :ios, "7.0"

  s.source       = { :git => "https://github.com/Mark-SS/GLImageScrollView.git", :tag => s.version }
  s.source_files  = "Classes/**/*.{h,m}"

  s.requires_arc = true
  s.dependency "Masonry", '~>0.6.3'

end
