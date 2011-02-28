#import "EventWebViewController.h"
#import "Event.h"

@implementation EventWebViewController

@synthesize webView, event;

#pragma mark -
#pragma mark Memory management

- (void) dealloc {
    [webView release];
    [super dealloc];
}

#pragma mark -
#pragma mark Initialization

- (id)initWithEvent:(Event *)anEvent {
    self = [super initWithNibName:@"EventWebView" bundle:nil];
    if (self) {
        self.event = anEvent;
        self.title = self.event.name;
    }
    return self;
}

#pragma mark -
#pragma mark View lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    NSURLRequest *request = [NSURLRequest requestWithURL:self.event.url];
    [self.webView loadRequest:request];    
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    if (webView.loading == YES) {
        [webView stopLoading];
    }
}

@end
