# Uncomment the next line to define a global platform for your project
platform :ios, '12.0'
deployment_target = '12.0'
source 'https://github.com/CocoaPods/Specs.git'
target 'NoIce' do
  # Comment the next line if you're not using Swift and don't want to use dynamic frameworks
  use_frameworks!
   pod 'Canvas'
   pod 'MessageKit'
   pod 'R.swift'
   pod 'RealmSwift'
   pod 'KeychainSwift'
   
   post_install do |installer|
       installer.generated_projects.each do |project|
           project.targets.each do |target|
               target.build_configurations.each do |config|
                   config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'] = deployment_target
               end
           end
           project.build_configurations.each do |config|
               config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'] = deployment_target
           end
       end
   end
end
