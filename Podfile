platform :ios, '9.0'
use_frameworks!
 
target 'MiniASOS' do
    pod 'SwiftyJSON',  :git => 'https://github.com/SwiftyJSON/SwiftyJSON.git'
end

target 'MiniASOSTests' do
    pod 'SwiftyJSON',  :git => 'https://github.com/SwiftyJSON/SwiftyJSON.git'
end

post_install do |installer|
    installer.pods_project.targets.each do |target|
        target.build_configurations.each do |config|
            config.build_settings['SWIFT_VERSION'] = '3.0'
        end
    end
end
