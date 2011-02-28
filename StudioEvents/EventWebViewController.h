@class Event;

@interface EventWebViewController : UIViewController {
}

@property (nonatomic, retain) Event *event;
@property (nonatomic, retain) IBOutlet UIWebView *webView;

- (id)initWithEvent:(Event *)event;

@end
