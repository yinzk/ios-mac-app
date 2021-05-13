workspace 'ProtonVPN'

# ignore all warnings from all pods
inhibit_all_warnings!

def openvpn
  pod 'TunnelKit', :git => 'git@gitlab.protontech.ch:apple/vpn/tunnelkit.git', :branch => 'protonvpn2/keychain'
end

def vpn_core
    use_frameworks!    
    pod 'Alamofire', '5.3.0'
    pod 'KeychainAccess', '3.2.1'
    pod 'Sentry', '5.2.2'
    pod 'ReachabilitySwift', '5.0.0'
    
    # Checks code style and bad practices
    pod 'SwiftLint'

    # Certificates pinning
    pod 'TrustKit', :git => 'https://github.com/ProtonMail/TrustKit', :commit => '838fba789e01c9cabff77acea3fb7135f71a220f'
    
    openvpn

    # Core
    pod 'PMNetworking', :git => 'git@gitlab.protontech.ch:apple/shared/pmnetworking.git', :commit => '35b8e110bb15082073be8cf6d95440da954c9365'
end    

abstract_target 'Core' do
    project 'libraries/vpncore/Core.xcodeproj'
    vpn_core

    target 'vpncore-ios' do       
        platform :ios, '12.1'
    end
    target 'vpncore-macos' do        
        platform :osx, '10.15'
    end
    target 'vpncore-iosTests' do
        platform :ios, '12.1'
    end
    target 'vpncore-macosTests' do
        platform :osx, '10.15'
    end
end

# iOS

target 'ProtonVPN' do
  project 'apps/iOS/iOS.xcodeproj'
  platform :ios, '12.1'
  use_frameworks!

  vpn_core

  pod 'GSMessages', '~> 1.0'
  pod 'AlamofireImage', '~> 4.1'
  
  pod 'ReachabilitySwift', '5.0.0'
  pod 'PMChallenge', :git => 'git@gitlab.protontech.ch:apple/shared/pmchallenge.git', :tag => '0.0.4'
  
  target 'OpenVPN Extension' do
    openvpn
    inherit! :search_paths
  end

  target 'Quick Connect Widget' do
    inherit! :search_paths
  end

  target 'Siri Shortcut Handler' do
    inherit! :search_paths
  end

  target 'ProtonVPNTests' do
    inherit! :search_paths
  end
end


# macOS

target 'ProtonVPN-mac' do
  project 'apps/macOS/macOS.xcodeproj'

  vpn_core

  # Third party pods
  pod 'Sparkle', '1.24.0'
  pod 'SDWebImage', '5.10.0'

end

target 'ProtonVPN OpenVPN' do
  project 'apps/macOS/macOS.xcodeproj'
  vpn_core
end

target 'ProtonVPNmacOSTests' do
  project 'apps/macOS/macOS.xcodeproj'
  inherit! :search_paths
  vpn_core
end