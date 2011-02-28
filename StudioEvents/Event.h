#import <Foundation/Foundation.h>

@interface Event : NSObject {
}

@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *code;
@property (nonatomic, copy) NSString *date;
@property (nonatomic, copy) NSString *location;
@property (nonatomic, retain) UIImage *image;
@property (nonatomic, retain) NSURL  *imageURL;
@property (nonatomic, readonly) NSURL *url;

- (id)initWithDictionary:(NSDictionary *)dictionary;

+ (NSArray *)fetchEvents;

@end
