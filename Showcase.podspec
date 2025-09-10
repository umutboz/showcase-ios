Pod::Spec.new do |s|
  s.name         = 'Showcase'
  s.version      = '1.3.0'
  s.summary      = 'KocSistem network framework'
  s.description  = 'A description of KSNetwork'
  s.homepage     = 'https://gitlab.kocsistem.com.tr/oneframe-mobile/ios/showcase'
  s.author             = { 'KoçSistem' => 'StarForce@kocsistem.com.tr' }
  s.platform     = :ios
  s.ios.deployment_target = '9.0'
  s.source       = { :git => "https://gitlab.kocsistem.com.tr/oneframe-mobile/ios/showcase", :tag => s.version }
  s.source_files  = 'Source/*.swift'
  s.pod_target_xcconfig = { 'SWIFT_VERSION' => '5' }
  s.swift_version    = '5.0'
  end
  
