#import "EventsViewController.h"

#import "Event.h"
#import "EventWebViewController.h"

@interface EventsViewController ()
- (void)fetchEvents;
- (void)configureCell:(UITableViewCell *)cell forIndexPath:(NSIndexPath *)indexPath;
- (void)showEvent:(Event *)event;
- (UIBarButtonItem *)newRefreshButton;
@end

@implementation EventsViewController

@synthesize events;

#pragma mark -
#pragma mark Memory management

- (void)dealloc {
    [events release];
    [super dealloc];
}

#pragma mark -
#pragma mark View lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"Courses";
    self.tableView.rowHeight = 90;

    UIBarButtonItem *refreshButton = [self newRefreshButton];
    self.navigationItem.rightBarButtonItem = refreshButton;
    [refreshButton release];
    
    [self refresh];
}

#pragma mark -
#pragma mark Actions

- (IBAction)refresh {
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    NSInvocationOperation *operation = 
        [[NSInvocationOperation alloc] initWithTarget:self 
                                             selector:@selector(fetchEvents) 
                                               object:nil];
    
    NSOperationQueue *queue = [[NSOperationQueue alloc] init];
    [queue addOperation:operation];
    [operation release];
    [queue release];
}

#pragma mark -
#pragma mark UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView 
 numberOfRowsInSection:(NSInteger)section {
    return [events count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView 
         cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellId = @"EventCellId";
    
    UITableViewCell *cell = 
        [tableView dequeueReusableCellWithIdentifier:CellId];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle
                                       reuseIdentifier:CellId] autorelease];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    
    [self configureCell:cell forIndexPath:indexPath];
    
    return cell;
}

#pragma -
#pragma UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    Event *event = [events objectAtIndex:indexPath.row];
    [self showEvent:event];
}

#pragma -
#pragma Private methods

- (void)fetchEvents {
    self.events = [Event fetchEvents];
    
    [self.tableView performSelectorOnMainThread:@selector(reloadData) 
                                     withObject:nil 
                                  waitUntilDone:NO]; 

    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
}


- (void)configureCell:(UITableViewCell *)cell 
         forIndexPath:(NSIndexPath *)indexPath {
    Event *event = [events objectAtIndex:indexPath.row];
    cell.textLabel.text = event.name;
    cell.detailTextLabel.text = [NSString stringWithFormat:@"%@ - %@", event.location, event.date];
    cell.imageView.image = event.image;
}

- (void)showEvent:(Event *)event {
    EventWebViewController *controller = 
        [[EventWebViewController alloc] initWithEvent:event];
    [self.navigationController pushViewController:controller animated:YES];
    [controller release];    
}

- (UIBarButtonItem *)newRefreshButton {
    return [[UIBarButtonItem alloc] 
            initWithBarButtonSystemItem:UIBarButtonSystemItemRefresh
                                 target:self 
                                 action:@selector(refresh)];
}

@end
