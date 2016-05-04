//
//  UserModel.m
//  bThere
//
//  Created by Le Huy Cu on 4/30/16.
//  Copyright © 2016 Le Huy Cu. All rights reserved.
//

#import "UserModel.h"

static NSString *const kBTherePList = @"User.plist";

@interface UserModel ()
//@property (strong, nonatomic) NSString *name;
//@property (strong, nonatomic) NSDictionary *events;
@property (strong, nonatomic) NSString *filepath;
@property (strong, nonatomic) NSMutableDictionary *user;
@end

@implementation UserModel
+ (instancetype) sharedModel {
    static UserModel *_sharedModel = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        // code to be executed once - thread safe version
        _sharedModel = [[self alloc] init];
    });
    return _sharedModel;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *documentsDirectory = [paths lastObject];
        _filepath = [documentsDirectory stringByAppendingPathComponent:kBTherePList];
        
        // If the file doesn't exist in the Documents Folder, copy it from bundle
        NSFileManager *fileManager = [NSFileManager defaultManager];
        
        if (![fileManager fileExistsAtPath:_filepath]) {
            NSString *sourcePath = [[NSBundle mainBundle] pathForResource:@"User" ofType:@"plist"];
            [fileManager copyItemAtPath:sourcePath toPath:_filepath error:nil];
        }

        _user = [[NSMutableDictionary alloc] initWithContentsOfFile:_filepath];
        
    }
    return self;
}

- (void) save {
    [self.user writeToFile:self.filepath atomically:YES];
}

- (void) setUName: (NSString *) name {
    [self.user setObject:name forKey:@"Name"];
    [self save];
}

- (NSString *) getUName {
    return [self.user valueForKey:@"Name"];
}

- (void) setUID: (NSString *) id {
    [self.user setObject:id forKey:@"ID"];
    [self save];
}

- (NSString *) getUID {
    return [self.user objectForKey:@"ID"];
}

- (void) setUEvents: (NSArray *) events {
    [self.user setObject:events forKey:@"Events"];
    [self save];
}

- (NSArray *) getUEvents {
    return [self.user objectForKey:@"Events"];
}

- (NSDictionary *) eventAtIndex: (NSUInteger) index {
    return [[self.user objectForKey:@"Events"] objectAtIndex:index];
}

- (void) setUImg: (NSString *) img {
    [self.user setObject:img forKey:@"Picture"];
    [self save];
}

- (NSString *) getUImg {
    return [self.user objectForKey:@"Picture"];
}

- (NSMutableArray *) getEventPics {
    return [self.user objectForKey:@"EventPics"];
}

- (void) setEventPics:(NSMutableArray *) eventPics {
    [self.user setObject:eventPics forKey:@"EventPics"];
    [self save];
}

- (void) addEventPics: (NSString *) img atIndex:(NSUInteger)index {
    NSMutableArray * arr = [self.user objectForKey:@"EventPics"];
    [arr insertObject:img atIndex:index];
    [self.user setObject:arr forKey:@"EventPics"];
    [self save];
}

- (NSString *) eventPicAtIndex:(NSUInteger)index {
    return [[self.user objectForKey:@"EventPics"] objectAtIndex:index];
}

- (void) clearData {
    //[[self.user objectForKey:@"EventPics"] removeAllObjects];
    NSMutableArray *empty = [[NSMutableArray alloc] init];
    [self.user setObject:empty forKey:@"Events"];
    [self.user setObject:@"" forKey:@"ID"];
    [self.user setObject:@"" forKey:@"Name"];
    [self.user setObject:@"" forKey:@"Picture"];
    [self save];
}

@end
















