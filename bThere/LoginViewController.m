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
             NSLog(@"Logged in");
             // dismiss the login window
             [self dismissViewControllerAnimated:YES completion:nil];
             // fetch user info
             if ([FBSDKAccessToken currentAccessToken]) {
                 // fetch user name
                 [[[FBSDKGraphRequest alloc] initWithGraphPath:@"me" parameters:nil]
                  startWithCompletionHandler:^(FBSDKGraphRequestConnection *connection, id result, NSError *error) {
                      if (!error) {
                          NSLog(@"fetched user:%@", result[@"name"]);
                          self.model.name = result[@"name"];
                      }
                  }];
                 // fetch events
                 FBSDKGraphRequest *request = [[FBSDKGraphRequest alloc]
                                               initWithGraphPath:@"/me/events"
                                               parameters:nil
                                               HTTPMethod:@"GET"];
                 [request startWithCompletionHandler:^(FBSDKGraphRequestConnection *connection,
                                                       id result,
                                                       NSError *error) {
                     // Handle the result
                     NSLog(@"result: %@", result);
                     self.model.events = [result objectForKey:@"data"];
                 }];
             }
         }
     }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
