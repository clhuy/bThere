//
//  DetailViewController.m
//  bThere
//
//  Created by Le Huy Cu on 5/1/16.
//  Copyright © 2016 Le Huy Cu. All rights reserved.
//

#import "DetailViewController.h"
#import "DateParser.h"
#import "QuartzCore/QuartzCore.h"

@interface DetailViewController ()
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet UILabel *locationLabel;
@property (weak, nonatomic) IBOutlet UILabel *addressLabel;
@property (weak, nonatomic) IBOutlet UITextView *descriptionLabel;
@property (weak, nonatomic) IBOutlet UIImageView *coverImg;
@end

@implementation DetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // navbar title
    self.navigationItem.title = [self.event objectForKey:@"name"];
    
    // cover photo
    NSURL *url = [NSURL URLWithString:[[self.event objectForKey:@"cover"] objectForKey:@"source"]];
    NSData *data = [NSData dataWithContentsOfURL:url];
    UIImage *image = [UIImage imageWithData:data];
    self.coverImg.image = image;
    
    // event title
    self.nameLabel.text = [self.event objectForKey:@"name"];

    // date label
    NSString* date = [DateParser parseDate:[self.event objectForKey:@"start_time"]];
    self.dateLabel.text = date;
    
    // location name label
    self.locationLabel.text = [[self.event objectForKey:@"place"] objectForKey:@"name"];
    
    // address label
    NSString *street = [[[self.event objectForKey:@"place"] objectForKey:@"location"] objectForKey:@"street"];
    if(street==nil){
        street = @"";
    }
    NSString *countrystate = [[NSString alloc] init];
    if([[[self.event objectForKey:@"place"] objectForKey:@"location"] objectForKey:@"state"] != nil){
     countrystate = [[[self.event objectForKey:@"place"] objectForKey:@"location"] objectForKey:@"state"];
    } else {
        countrystate = [[[self.event objectForKey:@"place"] objectForKey:@"location"] objectForKey:@"country"];
    }
    if(countrystate==nil){
        countrystate = @"";
    }
    NSString *city = [[[self.event objectForKey:@"place"] objectForKey:@"location"] objectForKey:@"city"];
    if(city==nil){
        city = @"";
    }
    NSString *zip = [[[self.event objectForKey:@"place"] objectForKey:@"location"] objectForKey:@"zip"];
    if(zip==nil){
        zip = @"";
    }
    NSString *address = [[NSString alloc] initWithFormat:@"%@, %@, %@ %@",street,city,countrystate,zip];
    self.addressLabel.text = address;
    
    // description label
    self.descriptionLabel.text = [self.event objectForKey:@"description"];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
