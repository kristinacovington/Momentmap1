//
//  PAWWallPostsTableViewController.h
//  Momentmap
//
//  Created by Kristina Covington on 6/25/16.
//  Copyright © 2016 Kristina Covington. All rights reserved.
//

#import <UIKit/UIKit.h>

#import <Parse/Parse.h>
#import <ParseUI/ParseUI.h>

#import "PAWWallViewController.h"

@class PAWWallPostsTableViewController;

@protocol PAWWallPostsTableViewControllerDataSource <NSObject>

- (CLLocation *)currentLocationForWallPostsTableViewController:(PAWWallPostsTableViewController *)controller;

@end

@interface PAWWallPostsTableViewController : PFQueryTableViewController <PAWWallViewControllerHighlight>

@property (nonatomic, weak) id<PAWWallPostsTableViewControllerDataSource> dataSource;

@property (nonatomic, strong) IBOutlet MKMapView *mapView;

@end
