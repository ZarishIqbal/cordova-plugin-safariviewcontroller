#import "SafariViewController.h"
#import "UIWebViewController.h"
@implementation SafariViewController
{
   UIWebViewController *wc;
}

//initialize UIWebViewController
- (void)pluginInitialize(CDVInvokedUrlCommand*)command {
   wc = [[UIWebViewController alloc] initWithCallbackId:command.callbackId withDelegate:self.commandDelegate];
}

//check if UIWebViewController is available
- (void)isAvailable:(CDVInvokedUrlCommand*)command {
    BOOL available = [wc isAvailable];
        // if available, return true
        // if not available, return false
        if (available) {
    // Code to execute if available is true
    CDVPluginResult* pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsBool:available];
    [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
} else {
    // Code to execute if available is false
     wc = [[UIWebViewController alloc] initWithCallbackId:command.callbackId withDelegate:self.commandDelegate];
      BOOL available_now = [wc isAvailable];
       CDVPluginResult* pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsBool:available_wc];
    [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
}
   
}

//open SafariViewController
- (void)show:(CDVInvokedUrlCommand*)command {
    NSDictionary *result = [wc show:command];
    CDVPluginResult* pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsDictionary:result];
    [pluginResult setKeepCallback:[NSNumber numberWithBool:YES]];
    [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
}

//close SafariViewController
- (void)hide:(CDVInvokedUrlCommand*)command {
    [wc hide:command];
}






@end