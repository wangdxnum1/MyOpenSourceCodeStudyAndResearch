Pod::Spec.new do |s|

  s.name         = "LazyScroll"
  s.version      = "0.0.2"
  s.summary      = "A ScrollView to resolve the problem of reusability of views."
  s.description  = <<-DESC
  It reply an another way to control reuse in a ScrollView, it depends on give a special reuse identifier to every view controlled in LazyScrollView.
                 DESC
  s.homepage     = "https://github.com/alibaba/LazyScrollView"
  s.license      = {:type => 'MIT'}
  s.author       = { "fydx" => "lbgg918@gmail.com" }
  s.ios.deployment_target = "5.0"
  s.source       = { :git => "https://github.com/alibaba/LazyScrollView.git", :tag => "0.0.2" }
  s.source_files = "LazyScrollView/TMMuiLazyScrollView.{h,m}"
  s.requires_arc = true

end
