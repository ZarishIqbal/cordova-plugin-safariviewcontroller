#import <Cordova/CDVPlugin.h>
#import <WebKit/WebKit.h>



@interface SafariViewController : CDVPlugin <WKNavigationDelegate>
@property (strong, nonatomic) WKWebView *webView;

- (void) isAvailable:(CDVInvokedUrlCommand*)command;
- (void) show:(CDVInvokedUrlCommand*)command;
- (void) hide:(CDVInvokedUrlCommand*)command;

@end
