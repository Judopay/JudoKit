Pod::Spec.new do |s|
  s.name                  = 'JudoKit'
  s.version               = '8.1.0'
  s.summary               = 'Judopay iOS Client'
  s.homepage              = 'https://judopay.com/'
  s.license               = 'MIT'
  s.author                = { "Judopay" => 'developersupport@judopayments.com' }
  s.source                = { :git => 'https://github.com/JudoPay/JudoKit.git', :tag => s.version.to_s }

  s.documentation_url = 'https://judopay.github.io/JudoKit/'

  s.ios.deployment_target = '10.0'
  s.swift_version         = '5.0'
  s.requires_arc          = true
  s.source_files          = 'Source/**/*.swift'

  s.dependency 'DeviceDNA', '~> 0.1'
  s.dependency 'TrustKit', '~> 1.6.2'

  s.frameworks            = 'CoreLocation', 'Security', 'CoreTelephony'
  s.pod_target_xcconfig   = { 'FRAMEWORK_SEARCH_PATHS'   => '$(inherited) ${PODS_ROOT}/DeviceDNA/Source' }

end
