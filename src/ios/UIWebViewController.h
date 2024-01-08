#import <WebKit/WebKit.h>
@interface UIWebViewController : UIViewController

@property (strong, nonatomic) WKWebView *webView;

@property (nonatomic, copy) NSString* callbackId;
@property (nonatomic, copy) NSString* URLString;
@property (weak, nonatomic) IBOutlet UIView *barView;
@property (weak, nonatomic) IBOutlet UITextField *urlField;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *backButton;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *forwardButton;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *reloadButton;
@property (weak, nonatomic) IBOutlet UIProgressView *progressView;
@property (strong, nonatomic) WKWebView *webView;
@end