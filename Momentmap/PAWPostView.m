//
//  PAWPostView.m
//  Momentmap
//
//  Created by Kristina Covington on 7/6/16.
//  Copyright © 2016 Kristina Covington. All rights reserved.
//

#import <Foundation/Foundation.h>
//
//  PAWWallPostCreateViewController.m
//  Momentmap
//
//  Created by Kristina Covington on 6/25/16.
//  Copyright © 2016 Kristina Covington. All rights reserved.
//

//
//  PAWWallPostCreateViewController.m
//  Anywall
//
//  Copyright (c) 2014 Parse Inc. All rights reserved.
//

#import "PAWPostView.h"

#import <Parse/Parse.h>

#import "PAWConstants.h"
#import "PAWConfigManager.h"

@interface PAWPostView ()


@end

@implementation PAWPostView

#pragma mark -
#pragma mark Init

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {

    }
    return self;
}

#pragma mark -
#pragma mark UIViewController

- (void)viewDidLoad {
    [super viewDidLoad];


}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations {
    return UIInterfaceOrientationMaskPortrait;
}

- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation {
    return UIInterfaceOrientationPortrait;
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleDefault;
}

#pragma mark -
#pragma mark UINavigationBar-based actions

- (IBAction)cancelPost:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
