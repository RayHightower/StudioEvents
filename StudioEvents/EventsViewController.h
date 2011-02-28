#import <UIKit/UIKit.h>

@interface EventsViewController : UITableViewController {
}

@property (nonatomic, retain) NSArray *events;

- (IBAction)refresh;

@end
