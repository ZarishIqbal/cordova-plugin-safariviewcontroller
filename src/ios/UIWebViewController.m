#import "UIWebViewController.h"

@implementation UIWebViewController

- (BOOL)isAvailable {
    BOOL available = NSClassFromString(@"UIWebViewController") != nil;
    return available;
}

- (instancetype)initWithCallbackId:(NSString *)callbackId withDelegate:(id)delegate {
    self = [super init];
    if (self) {
        // Initialize your properties here...
        self.callbackId = callbackId;
        self.delegate= delegate;
    }
    return self;
}

- (IBAction)back:(UIBarButtonItem *)sender {
    if ([self.webView canGoBack]) {
        [self.webView goBack];
    }
}

- (IBAction)forward:(UIBarButtonItem *)sender {
    if ([self.webView canGoForward]) {
        [self.webView goForward];
    }
}

- (void)viewWillTransitionToSize:(CGSize)size withTransitionCoordinator:(id<UIViewControllerTransitionCoordinator>)coordinator {
    self.barView.frame = CGRectMake(0, 0, size.width, 30);
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [self.urlField resignFirstResponder];
    NSURL *url = [NSURL URLWithString:self.urlField.text];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    [self.webView loadRequest:request];
    WKBackForwardList *list = [self.webView backForwardList];
    NSLog(@"BACK LIST");
    NSLog(@"%@", list.backList);
    return NO;
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    if ([keyPath isEqualToString:@"loading"]) {
        self.backButton.enabled = self.webView.canGoBack;
        self.forwardButton.enabled = self.webView.canGoForward;
    }
    if ([keyPath isEqualToString:@"estimatedProgress"]) {
        self.progressView.hidden = self.webView.estimatedProgress == 1;
        [self.progressView setProgress:self.webView.estimatedProgress animated:YES];
    }
}

// - (void)viewDidLoad {
//     [super viewDidLoad];
    
//     self.barView.frame = CGRectMake(0, 0, self.view.frame.size.width, 30);
    
//     [self.view insertSubview:self.webView belowSubview:self.progressView];
    
//     self.webView.translatesAutoresizingMaskIntoConstraints = NO;
//     NSLayoutConstraint *height = [NSLayoutConstraint constraintWithItem:self.webView attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeHeight multiplier:1 constant:-44];
//     NSLayoutConstraint *width = [NSLayoutConstraint constraintWithItem:self.webView attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeWidth multiplier:1 constant:0];
//     [self.view addConstraints:@[height, width]];
    
//     self.backButton.enabled = NO;
//     self.forwardButton.enabled = NO;
    
//     [self.webView addObserver:self forKeyPath:@"loading" options:NSKeyValueObservingOptionNew context:NULL];
//     [self.webView addObserver:self forKeyPath:@"estimatedProgress" options:NSKeyValueObservingOptionNew context:NULL];
    
//     NSURL *url = [NSURL URLWithString:self.URLString];
//     NSURLRequest *request = [NSURLRequest requestWithURL:url];
//     [self.webView loadRequest:request];
// }


- (NSDictionary*)show:(CDVInvokedUrlCommand*)command {
    NSDictionary* options = [command.arguments objectAtIndex:0];
    NSString* urlString = options[@"url"];
    self.URLString = urlString;
    if (urlString == nil) {
        // [self.delegatesendPluginResult:[CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsString:@"url can't be empty"] callbackId:command.callbackId];
        return @{@"error":@"url can't be empty"};
    }
    if (![[urlString lowercaseString] hasPrefix:@"http"]) {
        // [self.delegate sendPluginResult:[CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsString:@"url must start with http or https"] callbackId:command.callbackId];
         return @{@"error":@"url must start with http or https"};
    }
    NSURL *url = [NSURL URLWithString:urlString];
    if (url == nil) {
        // [self.delegate sendPluginResult:[CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsString:@"bad url"] callbackId:command.callbackId];
                return @{@"error":@"bad url"};
    }


WKWebViewConfiguration *configuration = [[WKWebViewConfiguration alloc] init];
    configuration.preferences.minimumFontSize = 10;
configuration.preferences.javaScriptEnabled = YES;
configuration.preferences.javaScriptCanOpenWindowsAutomatically = NO;
configuration.processPool = [[WKProcessPool alloc] init];
configuration.userContentController = [[WKUserContentController alloc] init];
configuration.websiteDataStore = [WKWebsiteDataStore defaultDataStore];
configuration.suppressesIncrementalRendering = NO;
configuration.applicationNameForUserAgent = @"MyApp";
configuration.allowsAirPlayForMediaPlayback = YES;
// configuration.allowsPictureInPictureMediaPlayback = YES;

  

    // WKWebViewConfiguration *configuration = [[WKWebViewConfiguration alloc] init];
   

    self.webView = [[WKWebView alloc] initWithFrame:self.view.frame configuration:configuration];
    self.webView.navigationDelegate = self;
    [self.view addSubview:self.webView];
    self.callbackId = command.callbackId;

    self.barView.frame = CGRectMake(0, 0, self.view.frame.size.width, 30);
    
    [self.view insertSubview:self.webView belowSubview:self.progressView];
    
    self.webView.translatesAutoresizingMaskIntoConstraints = NO;
    NSLayoutConstraint *height = [NSLayoutConstraint constraintWithItem:self.webView attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeHeight multiplier:1 constant:-44];
    NSLayoutConstraint *width = [NSLayoutConstraint constraintWithItem:self.webView attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeWidth multiplier:1 constant:0];
    [self.view addConstraints:@[height, width]];
    
    self.backButton.enabled = NO;
    self.forwardButton.enabled = NO;
    
    [self.webView addObserver:self forKeyPath:@"loading" options:NSKeyValueObservingOptionNew context:NULL];
    [self.webView addObserver:self forKeyPath:@"estimatedProgress" options:NSKeyValueObservingOptionNew context:NULL];
    
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
   
    [self.webView loadRequest:request];



    // CDVPluginResult * pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsDictionary:@{@"event":@"opened"}];
    // [pluginResult setKeepCallback:[NSNumber numberWithBool:YES]];
    // [self.delegate sendPluginResult:pluginResult callbackId:command.callbackId];
    return @{@"event":@"opened"};
}
- (NSDictionary*)hide:(CDVInvokedUrlCommand*)command {
    [self.webView removeFromSuperview];
    // self.webView = nil;
    return @{@"event":@"closed"};

    // CDVPluginResult* pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsDictionary:@{@"event":@"closed"}];
    // [pluginResult setKeepCallback:[NSNumber numberWithBool:YES]];
    // [self.delegate sendPluginResult:pluginResult callbackId:command.callbackId];
}


#pragma mark - WKNavigationDelegate

- (void)webView:(WKWebView *)webView didStartProvisionalNavigation:(WKNavigation *)navigation {
    // This method is called when the web view starts loading a new frame.
     CDVPluginResult * pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsDictionary:@{@"event":@"started",@"url": webView.URL.absoluteString}];
    [pluginResult setKeepCallback:[NSNumber numberWithBool:YES]];
    [self.delegate sendPluginResult:pluginResult callbackId:self.callbackId];

}

- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation {
    // This method is called when the web view finishes loading a frame.
     CDVPluginResult * pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsDictionary:@{@"event":@"finished"}];
    [pluginResult setKeepCallback:[NSNumber numberWithBool:YES]];
    [self.delegate sendPluginResult:pluginResult callbackId:self.callbackId];
}

- (void)webView:(WKWebView *)webView didFailNavigation:(WKNavigation *)navigation withError:(NSError *)error {
    // This method is called when the web view’s navigation fails.
      CDVPluginResult * pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsDictionary:@{@"event":@"failed"}];
    [pluginResult setKeepCallback:[NSNumber numberWithBool:YES]];
    [self.delegate sendPluginResult:pluginResult callbackId:self.callbackId];
}
- (void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler {
    // if (navigationAction.navigationType == WKNavigationTypeLinkActivated) {
    //     NSURL *url = navigationAction.request.URL;
    //     NSString *host = url.host;
    //     if (host && ![host hasPrefix:@"www.google.com"] && [[UIApplication sharedApplication] canOpenURL:url]) {
    //         [[UIApplication sharedApplication] openURL:url options:@{} completionHandler:nil];
    //         NSLog(@"%@", url);
    //         NSLog(@"Redirected to browser. No need to open it locally");
    //         decisionHandler(WKNavigationActionPolicyCancel);
    //         return;
    //     } else {
            NSLog(@"Open it locally");
            decisionHandler(WKNavigationActionPolicyAllow);
            return;
    //     }
    // } else {
    //     NSLog(@"not a user click");
    //     decisionHandler(WKNavigationActionPolicyAllow);
    //     return;
    // }
}

@end