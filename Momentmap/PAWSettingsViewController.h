//
//  PAWSettingsViewController.h
//  Momentmap
//
//  Created by Kristina Covington on 6/25/16.
//  Copyright © 2016 Kristina Covington. All rights reserved.
//

#import <UIKit/UIKit.h>

@class PAWSettingsViewController;

@protocol PAWSettingsViewControllerDelegate <NSObject>

- (void)settingsViewControllerDidLogout:(PAWSettingsViewController *)controller;

@end

@interface PAWSettingsViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, UIAlertViewDelegate>

@property (nonatomic, weak) id<PAWSettingsViewControllerDelegate> delegate;

@property (nonatomic, strong) IBOutlet UITableView *tableView;

@end
