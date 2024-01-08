#import <WebKit/WebKit.h>
#import <Cordova/CDVPlugin.h>

@interface UIWebViewController : UIViewController

@property (nonatomic, copy) NSString* callbackId;
@property (nonatomic, weak) id<CDVCommandDelegate> commandDelegate;
@property (nonatomic, copy) NSString* URLString;
@property (weak, nonatomic) IBOutlet UIView *barView;
@property (weak, nonatomic) IBOutlet UITextField *urlField;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *backButton;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *forwardButton;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *reloadButton;
@property (weak, nonatomic) IBOutlet UIProgressView *progressView;
@property (strong, nonatomic) WKWebView *webView;

- (instancetype)initWithCallbackId:(NSString *)callbackId withDelegate:(id<CDVCommandDelegate>)delegate;
- (BOOL) isAvailable;
- (NSDictionary*) show:(CDVInvokedUrlCommand*)command;
- (NSDictionary*) hide:(CDVInvokedUrlCommand*)command;

@end