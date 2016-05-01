//
//  ViewController.h
//  bThere
//
//  Created by Le Huy Cu on 4/27/16.
//  Copyright © 2016 Le Huy Cu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <FBSDKLoginKit/FBSDKLoginKit.h>

@interface LoginViewController : UIViewController
@property (weak, nonatomic) IBOutlet FBSDKLoginButton *loginButton;
@end

