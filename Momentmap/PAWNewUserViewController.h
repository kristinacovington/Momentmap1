//
//  PAWNewUserViewController.h
//  Momentmap
//
//  Created by Kristina Covington on 6/25/16.
//  Copyright © 2016 Kristina Covington. All rights reserved.
//


#import <UIKit/UIKit.h>

@class PAWNewUserViewController;

@protocol PAWNewUserViewControllerDelegate <NSObject>

- (void)newUserViewControllerDidSignup:(PAWNewUserViewController *)controller;

@end

@interface PAWNewUserViewController : UIViewController

@property (nonatomic, weak) id<PAWNewUserViewControllerDelegate> delegate;

@property (nonatomic, strong) IBOutlet UITextField *usernameField;
@property (nonatomic, strong) IBOutlet UITextField *passwordField;
@property (nonatomic, strong) IBOutlet UITextField *passwordAgainField;

@end