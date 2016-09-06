//
//  UsernameViewController.h
//  Momentmap
//
//  Created by Kristina Covington on 8/6/16.
//  Copyright © 2016 Kristina Covington. All rights reserved.
//

#ifndef UsernameViewController_h
#define UsernameViewController_h


#endif /* UsernameViewController_h */

//
//  FriendsViewController.h
//  Momentmap
//
//  Created by Kristina Covington on 6/30/16.
//  Copyright © 2016 Kristina Covington. All rights reserved.
//


#import <UIKit/UIKit.h>

#import <Parse/Parse.h>


@class UsernameViewController;

@protocol UsernameViewControllerDelegate <NSObject>


@end

@interface UsernameViewController : UIViewController <UITextFieldDelegate>

@property (nonatomic, weak) id<UsernameViewControllerDelegate> delegate;

@property (weak, nonatomic) IBOutlet UILabel *name;

@property (weak, nonatomic) IBOutlet UITextField *input;

- (IBAction)submit:(id)sender;


@end
