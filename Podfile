# platform :ios, ‘8.0’

target 'HDXSwift' do
  use_frameworks!

  # Pods for HDXSwift
  pod 'SwiftFilePath', :git => 'https://github.com/huangdaxiaEX/SwiftFilePath.git', :branch => 'swift_23'
  pod 'SwiftGen'
  pod 'DynamicColor', '~> 2.0'

end

post_install do |installer|
    installer.pods_project.targets.each do |target|
        target.build_configurations.each do |config|
            config.build_settings['SWIFT_VERSION'] = '2.3'
        end
    end
end
