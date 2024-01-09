#import <Cordova/CDVPlugin.h>
#import <WebKit/WebKit.h>



@interface SafariViewController : CDVPlugin 



- (void) isAvailable:(CDVInvokedUrlCommand*)command;
- (void) show:(CDVInvokedUrlCommand*)command;
- (void) hide:(CDVInvokedUrlCommand*)command;

@end
