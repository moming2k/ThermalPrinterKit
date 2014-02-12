#
# Be sure to run `pod spec lint ThermalPrintKit.podspec' to ensure this is a
# valid spec.
#
# Remove all comments before submitting the spec. Optional attributes are commented.
#
# For details see: https://github.com/CocoaPods/CocoaPods/wiki/The-podspec-format
#
Pod::Spec.new do |s|
  s.name         = "ThermalPrinterKit"
  s.version      = "1.1.5"
  s.summary      = "A helper of to prepare data for connect to Thermal Printer TM88 series."
  s.description  = <<-DESC
                     A helper of to prepare data for connect to Thermal Printer TM88 series.
  
                     * initial check in 
                    DESC
  s.homepage     = "http://www.igpsd.com/ThermalPrintKit"

  s.license  = { :type => 'BSD / Apache License, Version 2.0', :file => 'LICENSE' }
  s.author       = { "Chris Chan" => "chrischan@igpsd.com" }
  s.source       = { :git => "https://github.com/moming2k/ThermalPrinterKit.git", :tag => "1.1.5" }
  s.platform     = :ios, '4.3'
  s.source_files = 'IGThermalSupport.*','SupportLibrary/**/*.{h,m,mm,c,cc}'
end
