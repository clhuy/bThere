//
//  ProfileViewController.m
//  bThere
//
//  Created by Le Huy Cu on 4/30/16.
//  Copyright © 2016 Le Huy Cu. All rights reserved.
//

#import "ProfileViewController.h"
#import <FBSDKLoginKit/FBSDKLoginKit.h>
#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import "AppDelegate.h"
#import "UserModel.h"

@interface ProfileViewController ()
@property (weak, nonatomic) IBOutlet UILabel *nLabel;
@property (weak, nonatomic) IBOutlet UIImageView *profilePic;
@property (weak, nonatomic) IBOutlet UILabel *numEventLabel;
@property (strong,nonatomic) UserModel *model;
@end

@implementation ProfileViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.model = [UserModel sharedModel];
    
    // set name
    self.nLabel.text = [self.model getUName];
    
    // set profile pic
    NSURL *url = [NSURL URLWithString:[self.model getUImg]];
    NSData *data = [NSData dataWithContentsOfURL:url];
    UIImage *image = [UIImage imageWithData:data];
    [self.profilePic setImage:image];
    
    // set number of events
    NSUInteger n = [[self.model getUEvents] count];
    NSString *text = [[NSString alloc] initWithFormat:@"%lu events", (unsigned long)n];
    self.numEventLabel.text = text;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)logOut:(id)sender {
    [[FBSDKLoginManager new] logOut];
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    [appDelegate logOut];
}

@end
