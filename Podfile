# Uncomment the next line to define a global platform for your project
# platform :ios, '9.0'

target 'Expense Tracker' do
  # Comment the next line if you don't want to use dynamic frameworks
  use_frameworks!

  pod 'Charts'
  pod 'RxSwift', '6.5.0'
  pod 'RxCocoa', '6.5.0'
  pod 'RxDataSources', '~> 5.0'
  pod 'RealmSwift', '~>10'
  
  post_install do |installer|
  installer.pods_project.targets.each do |target|
        target.build_configurations.each do |config|
          config.build_settings['EXCLUDED_ARCHS[sdk=iphonesimulator*]'] = 'arm64'
        end
      end
  end

end


