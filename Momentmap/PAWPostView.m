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



-(void) setImage: (UIImage *) imageViewImage setComment: (NSString *) commentLabelText setUsername: (NSString *) usernameLabelText setProfile: (UIImage *) profileViewImage {
    
    self.imageView.image = imageViewImage;
    self.commentLabel.text = commentLabelText;
    self.usernameLabel.text = usernameLabelText;
    self.profileView.image = profileViewImage;
    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    
    PFUser *user = self.post.object[PAWParsePostUserKey];
    
    PFFile *photoFile = self.post.object[kPAPPostPictureKey];
    PFFile *profileFile = user[kPAPProfilePictureKey];
    
    
    
    [profileFile getDataInBackgroundWithBlock:^(NSData *data, NSError *error) {
        if (!error) {
            self.profileView.image = [UIImage imageWithData:data];
            // image can now be set on a UIImageView
        }
    }];
    
    [photoFile getDataInBackgroundWithBlock:^(NSData *data, NSError *error) {
        if (!error) {
            self.imageView.image = [UIImage imageWithData:data];
            // image can now be set on a UIImageView
        }
    }];

    
    //self.imageView.image = [(PAWPost *) self.post photo];
    self.commentLabel.text = [(PAWPost *) self.post subtitle];
    self.usernameLabel.text = [(PAWPost *) self.post title];
    //self.profileView.image = [(PAWPost *) self.post profile];
    
    [self.post.object deleteInBackground];
    
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

    self.post = nil;
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [[NSNotificationCenter defaultCenter] postNotificationName:PAWPostCreatedNotification object:nil];
    });
    
    [self dismissViewControllerAnimated:NO completion:nil];
}

@end
