
Pod::Spec.new do |s|
  s.name              = 'Judo'
  s.version           = '2.0.1'
  s.summary           = 'Judo Pay iOS Client SDK'
  s.homepage          = 'http://judopay.com/'
  s.license           = 'MIT'
  s.author            = { "Hamon Ben Riazy" => 'hamon.riazy@judopayments.com' }
  s.source            = { :git => 'https://github.com/JudoPay/Judo-Swift.git', :tag => s.version.to_s }
  s.documentation_url = 'https://judopay.github.io/Judo-Swift/'

  s.ios.deployment_target = '8.0'
  s.ios.platform          = '9.0'

  s.requires_arc     = true

  s.source_files     = 'Source/**/*.swift'

end
