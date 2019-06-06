Pod::Spec.new do |s|
  s.name         = "CVPageView"    #存储库名称
  s.version      = "1.1.0"      #版本号，与tag值一致
  s.summary      = "分页的pageView，横向滑动"  #简介
  s.description  = "支持横向滑动分页，可独立设计每一页的控制器，隔离文件"  #描述
  s.homepage     = "https://github.com/weixhe/CVPageView"      #项目主页，不是git地址
  s.license      = { :type => "MIT", :file => "LICENSE" }   #开源协议
  s.author       = { "weixhe" => "workerwei@163.com" }  #作者
  s.platform     = :ios, "8.0"                  #支持的平台和版本号
  s.source       = { :git => "https://github.com/weixhe/CVPageView.git", :tag => "1.1.0" }         #存储库的git地址，以及tag值
  s.source_files = "CVPageView/Classes/**/*.{h, m}" #需要托管的源代码路径
  s.requires_arc = true #是否支持ARC

end
