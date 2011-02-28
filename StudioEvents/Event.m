#import "Event.h"
#import "JSON.h"

@interface Event ()
+ (NSString *)studioURL;
@end

@implementation Event

@synthesize name, code, date, location, imageURL, image;

#pragma mark -
#pragma mark Memory management

- (void)dealloc {
    [name release];
    [code release];
    [date release];
    [location release];
    [imageURL release];
    [image release];
	[super dealloc];
}

#pragma mark -
#pragma mark Initialization

- (id)initWithDictionary:(NSDictionary *)dictionary {
    self = [super init];
    if (self) {
        NSString *fullName = [dictionary valueForKey:@"name"];
        self.name      = [[fullName componentsSeparatedByString:@":"] objectAtIndex:0];
        self.code      = [dictionary valueForKey:@"category"];
        self.date      = [dictionary valueForKey:@"start_date"];
        self.location  = [dictionary valueForKey:@"location"];
        self.imageURL  = [NSURL URLWithString:[dictionary valueForKey:@"image_url"]];
    }
    return self;
}

- (NSURL *)url {
    NSString *urlString = [NSString stringWithFormat:@"%@/%@", [self.class studioURL], self.code];    
    return [NSURL URLWithString:urlString];
}

- (UIImage *)image {
    if (image == nil) {
        NSData *data = [NSData dataWithContentsOfURL:self.imageURL];
        self.image = [UIImage imageWithData:data];
    }
    return image;
}

+ (NSArray *)fetchEvents {
    NSString *urlString = [NSString stringWithFormat:@"%@/upcoming-events.json", [self studioURL]];    
    NSURL *url = [NSURL URLWithString:urlString];
    
    NSError *error;
    
    NSString *response = 
        [NSString stringWithContentsOfURL:url 
                                 encoding:NSUTF8StringEncoding 
                                    error:&error];
    
    NSMutableArray *events = [NSMutableArray array];
    if (response) {
        SBJsonParser *json = [[SBJsonParser alloc] init];    
        NSArray *results = [json objectWithString:response error:&error];
        [json release];
        
        for (NSDictionary *dictionary in results) {
            Event *event = [[Event alloc] initWithDictionary:dictionary];
            [event image]; // force an image fetch
            [events addObject:event];
            [event release];
        }
    }
    
    return events;    
}

#pragma -
#pragma Private methods

+ (NSString *)studioURL {
    return [[[NSBundle mainBundle] infoDictionary] objectForKey:@"StudioURL"];
}

@end
