//
//  MapViewController.m
//  bThere
//
//  Created by Le Huy Cu on 5/2/16.
//  Copyright © 2016 Le Huy Cu. All rights reserved.
//

#import "MapViewController.h"
@import CoreLocation;
#import  <MapKit/MapKit.h>
#import "UserModel.h"
#import "DateParser.h"
#import "DetailViewController.h"
#import "CustomAnnotation.h"
#import "CustomCallOutButton.h"

@interface MapViewController () <CLLocationManagerDelegate, MKMapViewDelegate>
@property (weak, nonatomic) IBOutlet MKMapView *mapView;
@property (strong,nonatomic) CLLocationManager *locationManager;
@property (strong, nonatomic) UserModel *model;
@end

@implementation MapViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self startLocationManager];
    self.mapView.delegate = self;
    self.model = [UserModel sharedModel];
    
    // add annotations
    for(id object in [self.model getUEvents]){
        NSDictionary *event = object;
        double latitude = [[[[event objectForKey:@"place"] objectForKey:@"location"] objectForKey:@"latitude"] doubleValue];
        double longitude = [[[[event objectForKey:@"place"] objectForKey:@"location"] objectForKey:@"longitude"] doubleValue];
        CLLocationCoordinate2D *coor = &((CLLocationCoordinate2D){.latitude = latitude, .longitude = longitude});
        NSString *title = [event objectForKey:@"name"];
        NSString *subtitle = [DateParser parseDate:[event objectForKey:@"start_time"]];
        NSURL *url = [NSURL URLWithString:[[event objectForKey:@"cover"] objectForKey:@"source"]];
        NSData *data = [NSData dataWithContentsOfURL:url];
        UIImage *image = [UIImage imageWithData:data];
        CustomAnnotation *annotation = [[CustomAnnotation alloc] init];
        annotation.coordinate = *(coor);
        annotation.title = title;
        annotation.subtitle = subtitle;
        annotation.image = image;
        annotation.event = event;
        [self.mapView addAnnotation:annotation];
    }
    
    self.navigationController.navigationBar.barTintColor = [UIColor colorWithRed:2.0/255.0 green:141.0/255.0 blue:215.0/255.0 alpha:1.0];
    self.navigationController.navigationBar.translucent = NO;
    self.navigationController.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName:[UIColor whiteColor]};
    
    // zoom into user's location
    CLLocationCoordinate2D coord = self.mapView.userLocation.location.coordinate;
    MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance(coord, 1000.0, 1000.0);
    [self.mapView setRegion:region animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) startLocationManager {
    self.locationManager = [[CLLocationManager alloc] init];
    self.locationManager.delegate = self;
    self.locationManager.distanceFilter = kCLDistanceFilterNone; //whenever we move
    self.locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    
    [self.locationManager startUpdatingLocation];
    [self.locationManager requestWhenInUseAuthorization]; // Add This Line
}

/*
- (void) mapView:(MKMapView *)mapView didUpdateUserLocation:(MKUserLocation *)userLocation {
    CLLocationCoordinate2D coord = self.mapView.userLocation.location.coordinate;
    MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance(coord, 1000.0, 1000.0);
    [self.mapView setRegion:region animated:YES];
}
*/

- (MKAnnotationView*) mapView:(MKMapView *)mapView viewForAnnotation:(CustomAnnotation*)annotation {
    if([annotation isKindOfClass:[MKUserLocation class]]) return nil;
    MKPinAnnotationView *pin = [[MKPinAnnotationView alloc]initWithAnnotation:annotation reuseIdentifier:nil];
    pin.animatesDrop = YES;
    pin.canShowCallout = YES;
    CustomCallOutButton *rightButton = [CustomCallOutButton buttonWithType:UIButtonTypeDetailDisclosure];
    NSDictionary* event = annotation.event;
    rightButton.event = event;
    [rightButton addTarget:self action:@selector(showDetailView:) forControlEvents:UIControlEventTouchUpInside];
    pin.rightCalloutAccessoryView = rightButton;
    UIImage *image = [self imageWithImage:annotation.image scaledToSize:CGSizeMake(60.0,40.0)];
    UIImageView *imgView = [[UIImageView alloc] initWithImage:image];
    pin.leftCalloutAccessoryView = imgView;
    return pin;
}

- (void) showDetailView: (CustomCallOutButton*) sender {
    DetailViewController *detailVC = [self.storyboard instantiateViewControllerWithIdentifier:@"detailView"];
    detailVC.event = sender.event;
    [self.navigationController pushViewController:detailVC animated:YES];
}

// resize image
-(UIImage*)imageWithImage:(UIImage*)image scaledToSize:(CGSize)newSize {
    UIGraphicsBeginImageContext(newSize);
    [image drawInRect:CGRectMake(0, 0, newSize.width, newSize.height)];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
