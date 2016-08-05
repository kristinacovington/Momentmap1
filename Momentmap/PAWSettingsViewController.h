//
//  PAWSettingsViewController.h
//  Momentmap
//
//  Created by Kristina Covington on 3/10/15.
//  Copyright (c) 2015 Kristina Covington. All rights reserved.
//

//
//  PAWSettingsViewController.m
//  Anywall
//
//  Copyright (c) 2014 Parse Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

@class PAWSettingsViewController;

@protocol PAWSettingsViewControllerDelegate <NSObject>

- (void)settingsViewControllerDidLogout:(PAWSettingsViewController *)controller;

@end

@interface PAWSettingsViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, UIAlertViewDelegate>

@property (nonatomic, weak) id<PAWSettingsViewControllerDelegate> delegate;

@property (strong, nonatomic) IBOutlet UIButton *saveButton;

@property (strong, nonatomic) IBOutlet UIButton *change;

@property (strong, nonatomic) IBOutlet UIButton *friends;



//@property (nonatomic, strong) IBOutlet UITableView *tableView;


- (IBAction)logout:(id)sender;

@property (weak, nonatomic) IBOutlet UILabel *name;

//- (IBAction)deleteAccount:(id)sender;

- (IBAction)friends:(id)sender;


@property(nonatomic, strong) UIImageView *imageView;

@end
