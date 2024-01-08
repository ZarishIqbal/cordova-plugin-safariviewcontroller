#import <Cordova/CDVPlugin.h>
#import <WebKit/WebKit.h>



@interface SafariViewController : CDVPlugin <WKNavigationDelegate>

@property (nonatomic, copy) NSString* callbackId;

- (void) isAvailable:(CDVInvokedUrlCommand*)command;
- (void) show:(CDVInvokedUrlCommand*)command;
- (void) hide:(CDVInvokedUrlCommand*)command;

@end
