//
//  PAWWallPostCreateViewController.h
//  Momentmap
//
//  Created by Kristina Covington on 6/25/16.
//  Copyright © 2016 Kristina Covington. All rights reserved.
//


#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>


@class PAWWallPostCreateViewController;

@protocol PAWWallPostCreateViewControllerDataSource <NSObject>

- (CLLocation *)currentLocationForWallPostCrateViewController:(PAWWallPostCreateViewController *)controller;

@end

@interface PAWWallPostCreateViewController : UIViewController

@property (nonatomic, weak) id<PAWWallPostCreateViewControllerDataSource> dataSource;

@property (nonatomic, strong) IBOutlet UITextView *textView;
@property (nonatomic, strong) IBOutlet UILabel *characterCountLabel;
@property (nonatomic, strong) IBOutlet UIBarButtonItem *postButton;

@property (nonatomic, strong) IBOutlet UIImageView *imageView;
@property (nonatomic, strong) UIImage *image;



- (IBAction)cancelPost:(id)sender;
- (IBAction)postPost:(id)sender;
- (IBAction)takePhotoPost:(id)sender;

@end