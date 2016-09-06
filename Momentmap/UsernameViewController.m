//
//  UsernameViewController.m
//  Momentmap
//
//  Created by Kristina Covington on 8/6/16.
//  Copyright © 2016 Kristina Covington. All rights reserved.
//

#import <Foundation/Foundation.h>


#import "UsernameViewController.h"


#import "PAWConstants.h"
#import "PAWConfigManager.h"




@interface UsernameViewController ()



@end

@implementation UsernameViewController

#pragma mark -
#pragma mark Init

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
        
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.input.delegate = self;
    
}

- (IBAction)submit:(id)sender {
    
    NSString *publicUsername = self.input.text;
    PFQuery *query = [PFUser query];
    [query whereKey:@"publicUsername" equalTo:publicUsername];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        
        if (objects.count) {
            self.name.text = @"That username is taken. Try again.";
        } else {
            
            [PFUser currentUser][@"publicUsername"] = self.input.text;
            
            [[PFUser currentUser] saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                
                [self dismissViewControllerAnimated:YES completion:nil];
                
            
                
            }];
            

        }
    }];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder]; // Dismiss the keyboard.
    // Execute any additional code
    
    return YES;
}



@end