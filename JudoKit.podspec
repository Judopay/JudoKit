#
# Be sure to run `pod lib lint Judo-swift.podspec' to ensure this is a
# valid spec and remove all comments before submitting the spec.
#
# Any lines starting with a # are optional, but encouraged
#
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'JudoKit'
  s.version          = '5.0.0'
  s.summary          = 'Judo Pay iOS Client SDK'
  s.homepage         = 'http://judopay.com/'
  s.license          = 'MIT'
  s.author           = { "Hamon Ben Riazy" => 'hamon.riazy@judopayments.com' }
  s.source           = { :git => 'https://github.com/JudoPay/Judo-Swift.git', :tag => s.version.to_s, :submodules => true}

  s.ios.deployment_target = '8.0'
  s.ios.platform          = '9.0'

  s.requires_arc     = true

  s.source_files     = 'Source/**/*.swift'
  s.frameworks       = 'CoreLocation', 'Security', 'CoreTelephony', 'JudoSecure', 'Judo'

  s.xcconfig         = { 'FRAMEWORK_SEARCH_PATHS'   => '"${PODS_ROOT}/Judo-Security/Framework"' }
  s.xcconfig         = { 'LIBRARY_SEARCH_PATHS'     => '"${PODS_ROOT}/Judo-Security/Framework"' }
  s.xcconfig         = { 'LD_RUNPATH_SEARCH_PATHS'  => '"$(inherited) @executable_path/Frameworks"' }

end
