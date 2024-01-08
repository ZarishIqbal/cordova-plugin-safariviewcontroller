#import "UIWebViewController.h"

@implementation UIWebViewController

- (BOOL)isAvailable {
    BOOL available = NSClassFromString(@"UIWebViewController") != nil;
    return available;
}

- (instancetype)initWithCallbackId:(NSString *)callbackId withDelegate:(id<CDVCommandDelegate>)delegate {
    self = [super init];
    if (self) {
        // Initialize your properties here...
        self.callbackId = callbackId;
        self.commandDelegate = delegate;
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

- (void)viewDidLoad {
    [super viewDidLoad];
    
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
    
    NSURL *url = [NSURL URLWithString:self.URLString];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    [self.webView loadRequest:request];
}


- (NSDictionary*)show:(CDVInvokedUrlCommand*)command {
    NSDictionary* options = [command.arguments objectAtIndex:0];
    NSString* urlString = options[@"url"];
    self.URLString = urlString;
    if (urlString == nil) {
        // [self.commandDelegate sendPluginResult:[CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsString:@"url can't be empty"] callbackId:command.callbackId];
        return @{@"error":@"url can't be empty"};
    }
    if (![[urlString lowercaseString] hasPrefix:@"http"]) {
        // [self.commandDelegate sendPluginResult:[CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsString:@"url must start with http or https"] callbackId:command.callbackId];
         return @{@"error":@"url must start with http or https"};
    }
    NSURL *url = [NSURL URLWithString:urlString];
    if (url == nil) {
        // [self.commandDelegate sendPluginResult:[CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsString:@"bad url"] callbackId:command.callbackId];
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

    webView = [[WKWebView alloc] initWithFrame:self.viewController.view.frame configuration:configuration];
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

// Add a check to see if the web view's frame is correct
if (CGRectEqualToRect(webView.frame, self.viewController.view.frame)) {
    NSLog(@"The web view's frame is correct");
} else {
    NSLog(@"The web view's frame is not correct");
}


// Add a check to see if the web view is in the view hierarchy
if (webView.superview != nil) {
    NSLog(@"The web view is in the view hierarchy");
} else {
    NSLog(@"The web view is not in the view hierarchy");
}
    // CDVPluginResult * pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsDictionary:@{@"event":@"opened"}];
    // [pluginResult setKeepCallback:[NSNumber numberWithBool:YES]];
    // [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
    return @{@"event":@"opened"};
}
- (NSDictionary*)hide:(CDVInvokedUrlCommand*)command {
    [self.webView removeFromSuperview];
    // self.webView = nil;
    return @{@"event":@"closed"};

    // CDVPluginResult* pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsDictionary:@{@"event":@"closed"}];
    // [pluginResult setKeepCallback:[NSNumber numberWithBool:YES]];
    // [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
}


#pragma mark - WKNavigationDelegate

- (void)webView:(WKWebView *)webView didStartProvisionalNavigation:(WKNavigation *)navigation {
    // This method is called when the web view starts loading a new frame.
     CDVPluginResult * pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsDictionary:@{@"event":@"started",@"url": webView.URL.absoluteString}];
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