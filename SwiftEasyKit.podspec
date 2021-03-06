#
#  Be sure to run `pod spec lint SwiftEasyKit.podspec' to ensure this is a
#  valid spec and to remove all comments including this before submitting the spec.
#
#  To learn more about Podspec attributes see http://docs.cocoapods.org/specification.html
#  To see working Podspecs in the CocoaPods repo see https://github.com/CocoaPods/Specs/
#

Pod::Spec.new do |s|

# ―――  Spec Metadata  ―――――――――――――――――――――――――――――――――――――――――――――――――――――――――― #
#
#  These will help people to find your library, and whilst it
#  can feel like a chore to fill in it's definitely to your advantage. The
#  summary should be tweet-length, and the description more in depth.
#

s.name         = "SwiftEasyKit"
s.version      = "0.0.1"
s.summary      = "SwiftEasyKit: A Swift libraries for easy develop apps."

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!
s.description  = <<-DESC
A Swift libraries for easy develop apps. Try to build an workflow in iOS app development.
DESC

s.homepage     = "https://github.com/cactis/SwiftEasyKit"
# s.screenshots  = "www.example.com/screenshots_1.gif", "www.example.com/screenshots_2.gif"


# ―――  Spec License  ――――――――――――――――――――――――――――――――――――――――――――――――――――――――――― #
#
#  Licensing your code is important. See http://choosealicense.com for more info.
#  CocoaPods will detect a license file if there is a named LICENSE*
#  Popular ones are 'MIT', 'BSD' and 'Apache License, Version 2.0'.
#

s.license      = "MIT"
# s.license      = { :type => "MIT", :file => "FILE_LICENSE" }


# ――― Author Metadata  ――――――――――――――――――――――――――――――――――――――――――――――――――――――――― #
#
#  Specify the authors of the library, with email addresses. Email addresses
#  of the authors are extracted from the SCM log. E.g. $ git log. CocoaPods also
#  accepts just a name if you'd rather not provide an email address.
#
#  Specify a social_media_url where others can refer to, for example a twitter
#  profile URL.
#

s.author             = { "cactis" => "cactis.lin@gmail.com" }
# Or just: s.author    = "cactis"
# s.authors            = { "cactis" => "cactis.lin@gmail.com" }
# s.social_media_url   = "http://twitter.com/cactis"

# ――― Platform Specifics ――――――――――――――――――――――――――――――――――――――――――――――――――――――― #
#
#  If this Pod runs only on iOS or OS X, then specify the platform and
#  the deployment target. You can optionally include the target after the platform.
#

# s.platform     = :ios
s.platform     = :ios, "9.0"

#  When using multiple platforms
# s.ios.deployment_target = "9.0"
# s.osx.deployment_target = "10.7"
# s.watchos.deployment_target = "2.0"
# s.tvos.deployment_target = "9.0"


# ――― Source Location ―――――――――――――――――――――――――――――――――――――――――――――――――――――――――― #
#
#  Specify the location from where the source should be retrieved.
#  Supports git, hg, bzr, svn and HTTP.
#

s.source       = { :git => "https://github.com/cactis/SwiftEasyKit.git", :tag => "#{s.version}" }


# ――― Source Code ―――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――― #
#
#  CocoaPods is smart about how it includes source code. For source files
#  giving a folder will include any swift, h, m, mm, c & cpp files.
#  For header files it will include any header in the folder.
#  Not including the public_header_files will make all headers public.
#

s.source_files  = "Source/**/*.swift"
# s.exclude_files = "Sources/Exclude"

s.public_header_files = "Classes/**/*.h"


# ――― Resources ―――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――― #
#
#  A list of resources included with the Pod. These are copied into the
#  target bundle with a build phase script. Anything else will be cleaned.
#  You can preserve files from being cleaned, please don't preserve
#  non-essential files like tests, examples and documentation.
#

# s.resource  = "icon.png"
# s.resources = "Resources/*.png"

# s.preserve_paths = "FilesToSave", "MoreFilesToSave"


# ――― Project Linking ―――――――――――――――――――――――――――――――――――――――――――――――――――――――――― #
#
#  Link your library with frameworks, or libraries. Libraries do not include
#  the lib prefix of their name.
#

# s.framework  = "SgwiftEasyKitFramework"
# s.frameworks = "SomeFramework", "AnotherFramework"

# s.library   = "iconv"
# s.libraries = "iconv", "xml2"


# ――― Project Settings ――――――――――――――――――――――――――tab――――――――――――――――――――――――――――――― #
#
#  If your library depends on compiler flags you can set them in the xcconfig hash
#  where they will only apply to your library. If you depend on other Podspecs
#  you can include multiple dependencies to ensure it works.

# s.requires_arc = true

# s.xcconfig = { "HEADER_SEARCH_PATHS" => "$(SDKROOT)/usr/include/libxml2" }
s.dependency 'Alamofire'#, '3.4.1'
s.dependency 'Bond'#, '4.3.1'
s.dependency 'Facade'
s.dependency 'Fakery'#, '1.2.0'
s.dependency 'FontAwesome.swift', '1.3.2'#, '0.7.3'
s.dependency 'JSQMessagesViewController'
s.dependency 'KeychainSwift'#, '~> 3.0'
s.dependency 'Kingfisher'#, '3.10.4'#, '2.4.1' 3.10.4
s.dependency 'LoremIpsum'
s.dependency 'Masonry'
s.dependency 'Neon'#, '0.2.0'
s.dependency 'ObjectMapper'#, '1.3.0'
s.dependency 'PhotoSlider', '0.18.0'
s.dependency 'RSKImageCropper'#, '1.5.1'
s.dependency 'SwiftRandom'#, '0.1.7'
s.dependency 'SwiftyJSON'#, '2.3.2'
s.dependency 'SwifterSwift'
# s.dependency 'Eureka'
# s.dependency 'ImageRow'
s.dependency 'IQKeyboardManagerSwift'
s.dependency 'SwiftyUserDefaults'
# s.dependency 'DateToolsSwift'
s.dependency 'AssistantKit'

# s.dependency 'RandomKit'#, '1.6.0'
# s.dependency 'SwiftSpinner'
# s.dependency 'SwitchLoader'#, '~> 0.0.1'
# s.dependency 'EZLoadingActivity'#, '0.8' #For Swift 2.2
# s.dependency 'GradientLoadingBar'#, '~> 1.0'
# s.dependency 'mailgun'#, '~> 1.0.3'
# s.dependency 'FontAwesomeKit'
# s.dependency 'KDCircularProgress'#, '1.4.0'
# s.dependency 'EZSwiftExtensions'
# s.dependency 'ExSwift'
# s.dependency 'Stripe'
# s.dependency 'AlamofireObjectMapper', '~> 3.0'

end
