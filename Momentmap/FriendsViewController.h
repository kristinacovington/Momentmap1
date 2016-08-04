//
//  FriendsViewController.h
//  Momentmap
//
//  Created by Kristina Covington on 6/30/16.
//  Copyright © 2016 Kristina Covington. All rights reserved.
//


#import <UIKit/UIKit.h>

@class FriendsViewController;

@interface FriendsViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, UIAlertViewDelegate>


@property (nonatomic, strong) IBOutlet UITableView *tableView;

@property (strong, nonatomic) IBOutlet UISearchBar *searchBar;

@property (strong, nonatomic) IBOutlet UISearchDisplayController *searchDisplayController;


@end
