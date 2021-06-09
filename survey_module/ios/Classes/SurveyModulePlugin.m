#import "SurveyModulePlugin.h"
#if __has_include(<survey_module/survey_module-Swift.h>)
#import <survey_module/survey_module-Swift.h>
#else
// Support project import fallback if the generated compatibility header
// is not copied when this plugin is created as a library.
// https://forums.swift.org/t/swift-static-libraries-dont-copy-generated-objective-c-header/19816
#import "survey_module-Swift.h"
#endif

@implementation SurveyModulePlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  [SwiftSurveyModulePlugin registerWithRegistrar:registrar];
}
@end
