//
//  UserModel.h
//  bThere
//
//  Created by Le Huy Cu on 4/30/16.
//  Copyright © 2016 Le Huy Cu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UserModel : NSObject
+ (instancetype) sharedModel;
- (void) save;
- (void) setUName: (NSString *) name;
- (NSString *) getUName;
- (void) setUID: (NSString *) id;
- (NSString *) getUID;
- (void) setUImg: (NSString *) img;
- (NSString *) getUImg;
- (void) setUEvents: (NSArray *) events;
- (NSArray *) getUEvents;
- (NSDictionary *) eventAtIndex: (NSUInteger) index;
- (NSMutableArray *) getEventPics;
- (void) setEventPics: (NSMutableArray *) eventPics;
- (void) clearData;
@end
