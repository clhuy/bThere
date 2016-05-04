//
//  CustomAnnotation.h
//  bThere
//
//  Created by Le Huy Cu on 5/2/16.
//  Copyright © 2016 Le Huy Cu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

@interface CustomAnnotation : MKPointAnnotation
@property (strong,nonatomic) UIImage *image;
@property (strong, nonatomic)   NSDictionary *event;
@end
