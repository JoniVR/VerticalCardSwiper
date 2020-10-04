#
# Be sure to run `pod lib lint VerticalCardSwiper.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'VerticalCardSwiper'
  s.version          = '2.3.0'
  s.summary          = 'A marriage between the Shazam Discover UI and Tinder, built with UICollectionView in Swift.'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = <<-DESC
  The goal of this project is to recreate the Discover UI in Shazam (which I think is a great, fun way to display content) in combination with a Tinder style of swiping cards to the left/right. The idea behind this is that in some cases, you don't want to swipe away cards, but keep them available for later on. This implementation allows for that. And it's a fun way to interact with content.
  It's built with a UICollectionView and a custom flowLayout.
                       DESC

  s.homepage         = 'https://github.com/JoniVR/VerticalCardSwiper'
  s.screenshots      = 'https://raw.githubusercontent.com/JoniVR/VerticalCardSwiper/master/example.gif'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'JoniVR' => 'joni.VR@hotmail.com' }
  s.source           = { :git => 'https://github.com/JoniVR/VerticalCardSwiper.git', :tag => s.version.to_s }
    
  s.swift_version = '5.0'
  s.ios.deployment_target = '9.0'
  s.source_files = 'Sources/*.swift'
  
  # s.resource_bundles = {
  #   'VerticalCardSwiper' => ['VerticalCardSwiper/Assets/*.png']
  # }

  # s.public_header_files = 'Pod/Classes/**/*.h'
  # s.frameworks = 'UIKit', 'MapKit'
  # s.dependency 'AFNetworking', '~> 2.3'
end
