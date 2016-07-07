//
//  PAWPostView.h
//  Momentmap
//
//  Created by Kristina Covington on 7/6/16.
//  Copyright © 2016 Kristina Covington. All rights reserved.
//


#import <UIKit/UIKit.h>

@class PAWPostView;

@protocol PAWWallPostCreateViewControllerDataSource <NSObject>

@end

@interface PAWPostView : UIViewController

@property (nonatomic, weak) id<PAWWallPostCreateViewControllerDataSource> dataSource;

@property (nonatomic, strong) IBOutlet UILabel *commentLabel;
@property (nonatomic, strong) IBOutlet UILabel *usernameLabel;
@property (nonatomic, strong) IBOutlet UIImageView *profileView;

@property (nonatomic, strong) IBOutlet UIImageView *imageView;

- (IBAction)cancelPost:(id)sender;

@end

