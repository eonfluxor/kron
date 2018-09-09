Pod::Spec.new do |s|
s.name         = "Delay"
s.version      = "1.0.0"
s.summary      = "MyFramework with a Car to track miles."
s.homepage     = "https://github.com/eonfluxor/delay"
s.license      = "MIT"
s.author       = { "Eonflux - Hassan Uriostegui" => "eonfluxor@gmail.com" }

s.ios.deployment_target = "8.0"
s.osx.deployment_target = "10.9"
s.tvos.deployment_target = "9.0"

s.source       = { :git => "https://github.com/eonfluxor/delay.git", :tag => s.version }
s.source_files = "Sources/*.swift"
end
