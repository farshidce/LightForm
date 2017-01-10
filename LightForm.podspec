#
# Be sure to run `pod lib lint LightForm.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'LightForm'
  s.version          = '0.0.1'
  s.summary          = 'Simple interactive and customizable library to handle form input and validations'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = <<-DESC
A simple library which let the user create beautiful and interactive forms for
handling user inputs and validating the data as the user inputs. The library
notifies the caller if and when the user changes the input and let the caller
decide what is validated and what validation messages needs to be displayed.

The caller can customize the font, color, border and placement of the contents if needed
                       DESC

  s.homepage         = 'https://github.com/farshidce/LightForm'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'Farshid Ghods' => 'farshid.ghods@gmail.com' }
  s.source           = { :git => 'https://github.com/farshidce/LightForm.git', :tag => s.version.to_s }

  s.ios.deployment_target = '8.0'

  s.source_files = 'LightForm/Classes/**/*'
  
  # s.resource_bundles = {
  #   'LightForm' => ['LightForm/Assets/*.png']
  # }

  s.public_header_files = 'Pod/Classes/LightForm.h'
  s.frameworks = 'UIKit'
end
