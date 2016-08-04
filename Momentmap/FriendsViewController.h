//
//  FriendsViewController.h
//  Momentmap
//
//  Created by Kristina Covington on 6/30/16.
//  Copyright © 2016 Kristina Covington. All rights reserved.
//


#import <UIKit/UIKit.h>

#import <Parse/Parse.h>


@class FriendsViewController;

@protocol FriendsViewControllerDelegate <NSObject>


@end

@interface FriendsViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, UIAlertViewDelegate>


@property (nonatomic, weak) id<FriendsViewControllerDelegate> delegate;


@property (nonatomic, strong) IBOutlet UIButton *sendButton;

@property (nonatomic, strong) IBOutlet UITableView *tableView;

@property (strong, nonatomic) IBOutlet UISearchBar *searchBar;

@property (strong, nonatomic) IBOutlet UISearchDisplayController *searchDisplayController;

@property PFObject *postObject;


@end
