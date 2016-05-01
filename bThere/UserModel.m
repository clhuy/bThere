//
//  UserModel.m
//  bThere
//
//  Created by Le Huy Cu on 4/30/16.
//  Copyright © 2016 Le Huy Cu. All rights reserved.
//

#import "UserModel.h"

@interface UserModel ()
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

/*- (void) setName: (NSString *) name {
    if(self.name == nil){
        self.name = [NSString alloc];
    }
    self.name = name;
}

- (NSString *) getName {
    return self.name;
}*/
@end
