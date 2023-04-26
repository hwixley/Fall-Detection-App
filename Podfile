# Uncomment the next line to define a global platform for your project
 platform :ios, '12.0'

target 'fall-detector' do
  # Comment the next line if you don't want to use dynamic frameworks
  use_frameworks!

  # Pods for fall-detector
  pod 'Firebase/Auth' #, '7.2-M1'
  pod 'Firebase/Firestore' #, '7.2-M1'
  pod 'Firebase/MLModelDownloader'
  pod 'TensorFlowLiteSwift'
  #pod 'TensorFlowLiteSelectTfOps', '~> 0.0.1-nightly'
  pod 'PolarBleSdk', '~> 3.2'
  pod 'Alamofire'

end

post_install do |installer|
  installer.pods_project.targets.each do |target|
    target.build_configurations.each do |config|
      config.build_settings['BUILD_LIBRARY_FOR_DISTRIBUTION'] = 'YES'
    end
  end
end
