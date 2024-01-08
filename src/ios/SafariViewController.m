#import "SafariViewController.h"
#import "UIWebViewController.h"
@implementation SafariViewController
{
   UIWebViewController *wc;
}

//initialize UIWebViewController
- (void)pluginInitialize {
    wc = [[UIWebViewController alloc] init];
}

//check if UIWebViewController is available
- (void)isAvailable:(CDVInvokedUrlCommand*)command {
    BOOL available = [wc isAvailable:command];
    CDVPluginResult* pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsBool:available];
    [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
}

//open SafariViewController
- (void)show:(CDVInvokedUrlCommand*)command {
    [wc show:command];
}

//close SafariViewController
- (void)hide:(CDVInvokedUrlCommand*)command {
    [wc hide:command];
}






@end