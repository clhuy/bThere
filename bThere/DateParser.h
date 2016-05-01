//
//  DateParser.h
//  bThere
//
//  Created by Le Huy Cu on 5/1/16.
//  Copyright © 2016 Le Huy Cu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DateParser : NSObject
+ (NSString *)parseDate:(NSString *)rfc3339DateTimeString;
@end
