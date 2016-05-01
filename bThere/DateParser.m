//
//  DateParser.m
//  bThere
//
//  Created by Le Huy Cu on 5/1/16.
//  Copyright © 2016 Le Huy Cu. All rights reserved.
//

#import "DateParser.h"

@implementation DateParser

+ (NSString *)parseDate:(NSString *)rfc3339DateTimeString {
    /*
     Returns a user-visible date time string that corresponds to the specified
     RFC 3339 date time string. Note that this does not handle all possible
     RFC 3339 date time strings, just one of the most common styles.
     */
    //NSLog(@"%@",rfc3339DateTimeString);
    
    NSDateFormatter *rfc3339DateFormatter = [[NSDateFormatter alloc] init];
    NSLocale *enUSPOSIXLocale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US_POSIX"];
    
    [rfc3339DateFormatter setLocale:enUSPOSIXLocale];
    [rfc3339DateFormatter setDateFormat:@"yyyy'-'MM'-'dd'T'HH':'mm':'ssZ"];
    [rfc3339DateFormatter setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:0]];
    
    // Convert the RFC 3339 date time string to an NSDate.
    NSDate *date = [rfc3339DateFormatter dateFromString:rfc3339DateTimeString];
          
    NSString *userVisibleDateTimeString;
    if (date != nil) {
        // Convert the date object to a user-visible date string.
        NSDateFormatter *userVisibleDateFormatter = [[NSDateFormatter alloc] init];
        assert(userVisibleDateFormatter != nil);
        
        [userVisibleDateFormatter setDateStyle:NSDateFormatterMediumStyle];
        [userVisibleDateFormatter setTimeStyle:NSDateFormatterShortStyle];
        
        userVisibleDateTimeString = [userVisibleDateFormatter stringFromDate:date];
    }
    return userVisibleDateTimeString;
}
@end
