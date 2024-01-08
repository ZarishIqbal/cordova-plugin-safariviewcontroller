#import "SafariViewController.h"

@implementation SafariViewController
{
    WKWebView *webView;
}

- (void)isAvailable:(CDVInvokedUrlCommand*)command {
    BOOL available = NSClassFromString(@"SFSafariViewController") != nil;
    CDVPluginResult* pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsBool:available];
    [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
}

- (void)show:(CDVInvokedUrlCommand*)command {
    NSDictionary* options = [command.arguments objectAtIndex:0];
    NSString* urlString = options[@"url"];
    if (urlString == nil) {
        [self.commandDelegate sendPluginResult:[CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsString:@"url can't be empty"] callbackId:command.callbackId];
        return;
    }
    if (![[urlString lowercaseString] hasPrefix:@"http"]) {
        [self.commandDelegate sendPluginResult:[CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsString:@"url must start with http or https"] callbackId:command.callbackId];
        return;
    }
    NSURL *url = [NSURL URLWithString:urlString];
    if (url == nil) {
        [self.commandDelegate sendPluginResult:[CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsString:@"bad url"] callbackId:command.callbackId];
        return;
    }

    WKWebViewConfiguration *configuration = [[WKWebViewConfiguration alloc] init];
    WKWebView *webView = [[WKWebView alloc] initWithFrame:self.viewController.view.frame configuration:configuration];
    webView.navigationDelegate = self;
    [self.viewController.view addSubview:webView];
    self.callbackId = command.callbackId;

    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    [webView loadRequest:request];


    // Add a check to see if the request is loading
    if (webView.isLoading) {
        NSLog(@"The request is loading");
    } else {
        NSLog(@"The request is not loading");
    }
    
    CDVPluginResult * pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsDictionary:@{@"event":@"opened"}];
    [pluginResult setKeepCallback:[NSNumber numberWithBool:YES]];
    [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
}
- (void)hide:(CDVInvokedUrlCommand*)command {
    [self.webView removeFromSuperview];
    // self.webView = nil;

    CDVPluginResult* pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsDictionary:@{@"event":@"closed"}];
    [pluginResult setKeepCallback:[NSNumber numberWithBool:YES]];
    [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
}
#pragma mark - WKNavigationDelegate

- (void)webView:(WKWebView *)webView didStartProvisionalNavigation:(WKNavigation *)navigation {
    // This method is called when the web view starts loading a new frame.
     CDVPluginResult * pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsDictionary:@{@"event":@"started"}];
    [pluginResult setKeepCallback:[NSNumber numberWithBool:YES]];
    [self.commandDelegate sendPluginResult:pluginResult callbackId:self.callbackId];

}

- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation {
    // This method is called when the web view finishes loading a frame.
     CDVPluginResult * pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsDictionary:@{@"event":@"finished"}];
    [pluginResult setKeepCallback:[NSNumber numberWithBool:YES]];
    [self.commandDelegate sendPluginResult:pluginResult callbackId:self.callbackId];
}

- (void)webView:(WKWebView *)webView didFailNavigation:(WKNavigation *)navigation withError:(NSError *)error {
    // This method is called when the web view’s navigation fails.
      CDVPluginResult * pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsDictionary:@{@"event":@"failed"}];
    [pluginResult setKeepCallback:[NSNumber numberWithBool:YES]];
    [self.commandDelegate sendPluginResult:pluginResult callbackId:self.callbackId];
}


@end