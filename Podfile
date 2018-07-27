platform :ios, '9.0'

inhibit_all_warnings!
use_frameworks!

def pod__Texture
    pod 'Texture', '~> 2.6.0'
end

target 'Planes' do
    pod__Common
    pod__CommonExtended
    pod__Texture
end

post_install do |installer|
    installer.pods_project.targets.each do |target|
        target.build_configurations.each do |config|
            config.build_settings['ENABLE_BITCODE'] = 'YES'
            config.build_settings['SWIFT_VERSION'] = '4.1'
            if config.name == 'Release'
                config.build_settings['SWIFT_OPTIMIZATION_LEVEL'] = '-Owholemodule'
            else
                config.build_settings['SWIFT_OPTIMIZATION_LEVEL'] = '-Onone'
            end
        end
    end
end
