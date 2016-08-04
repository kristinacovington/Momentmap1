//
//  PAWPostView.h
//  Momentmap
//
//  Created by Kristina Covington on 7/6/16.
//  Copyright © 2016 Kristina Covington. All rights reserved.
//


#import <UIKit/UIKit.h>
#import "PAWPost.h"

@class PAWPostView;

@protocol PAWPostViewDelegate <NSObject>


@end

@interface PAWPostView : UIViewController

@property PAWPost *post;
@property (nonatomic, weak) id<PAWPostViewDelegate> delegate;

@property (nonatomic, strong) IBOutlet UILabel *commentLabel;
@property (nonatomic, strong) IBOutlet UILabel *usernameLabel;
@property (nonatomic, strong) IBOutlet UIImageView *profileView;

@property (nonatomic, strong) IBOutlet UIImageView *imageView;

- (IBAction)cancelPost:(id)sender;

-(void) setImage: (UIImage *) imageViewImage setComment: (NSString *) commentLabelText setUsername: (NSString *) usernameLabelText setProfile: (UIImage *) profileViewImage;

@end

