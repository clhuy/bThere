//
//  ViewController.m
//  bThere
//
//  Created by Le Huy Cu on 4/27/16.
//  Copyright © 2016 Le Huy Cu. All rights reserved.
//

#import "LoginViewController.h"
#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import <FBSDKLoginKit/FBSDKLoginKit.h>
#import "UserModel.h"
//#import "ProfileViewController.h"

@interface LoginViewController ()
@property (strong,nonatomic) UserModel *model;
@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Add a custom login button to your app
    UIButton *myLoginButton=[UIButton buttonWithType:UIButtonTypeCustom];
    myLoginButton.backgroundColor=[UIColor darkGrayColor];
    myLoginButton.frame=CGRectMake(0,0,180,40);
    myLoginButton.center = self.view.center;
    [myLoginButton setTitle: @"My Login Button" forState: UIControlStateNormal];
    
    // Handle clicks on the button
    [myLoginButton
     addTarget:self
     action:@selector(loginButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    
    // Add the button to the view
    [self.view addSubview:myLoginButton];
    
    self.model = [UserModel sharedModel];
}

// Once the button is clicked, show the login dialog
-(void)loginButtonClicked
{
    //ProfileViewController *profileVC = [[ProfileViewController alloc] initWithNibName:@"ProfileViewController" bundle:nil];
    FBSDKLoginManager *login = [[FBSDKLoginManager alloc] init];
    [login
     logInWithReadPermissions: @[@"public_profile", @"email", @"user_friends", @"user_events"]
     fromViewController:self
     handler:^(FBSDKLoginManagerLoginResult *result, NSError *error) {
         if (error) {
             NSLog(@"Process error");
         } else if (result.isCancelled) {
             NSLog(@"Cancelled");
         } else { // login was successful
             // fetch user info
             if ([FBSDKAccessToken currentAccessToken]) {
                 // fetch user name and id
                 [[[FBSDKGraphRequest alloc] initWithGraphPath:@"me" parameters:@{@"fields":@"id, name"}]
                  startWithCompletionHandler:^(FBSDKGraphRequestConnection *connection, id result, NSError *error) {
                      //if (!error) {
                          NSLog(@"fetched user:%@", result);
                          [self.model setUName:result[@"name"]];
                          [self.model setUID:result[@"id"]];
                      //}
                  }];
                 // fetch user profile picture
                 NSString *gPath = [[NSString alloc] initWithFormat:@"/%@/picture", [self.model getUID]];
                 NSLog(@"%@",gPath);
                 FBSDKGraphRequest *requestPic = [[FBSDKGraphRequest alloc]
                                               initWithGraphPath:gPath
                                                  parameters:@{@"fields":@"url", @"type": @"large", @"redirect" : @"false"}
                                               HTTPMethod:@"GET"];
                 [requestPic startWithCompletionHandler:^(FBSDKGraphRequestConnection *connection,
                                                       id result,
                                                       NSError *error) {
                     // Handle the result
                     NSString *imgString = [[result valueForKey:@"data"] valueForKey:@"url"];
                     NSLog(@"%@",result);
                     if(imgString!=nil){
                     [self.model setUImg:imgString];
                     }
                 }];
                 
                 // fetch events
                 FBSDKGraphRequest *requestEvents = [[FBSDKGraphRequest alloc]
                                                     initWithGraphPath:@"/me/events"
                                                     parameters:@{@"fields":@"description, name, start_time, cover, place"}
                                                     HTTPMethod:@"GET"];
                 [requestEvents startWithCompletionHandler:^(FBSDKGraphRequestConnection *connection,
                                                             id result,
                                                             NSError *error) {
                     // Handle the result
                     [self.model setUEvents:[result objectForKey:@"data"]];
                     //NSLog(@"events:%@", result);
                 }];
                 
                 // dismiss the login window
                 [self dismissViewControllerAnimated:YES completion:nil];
             }
         }
     }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
