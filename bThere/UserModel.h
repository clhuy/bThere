//
//  UserModel.h
//  bThere
//
//  Created by Le Huy Cu on 4/30/16.
//  Copyright © 2016 Le Huy Cu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UserModel : NSObject
@property (strong, nonatomic) NSString *name;
@property (strong, nonatomic) NSDictionary *events;
+ (instancetype) sharedModel;
@end
