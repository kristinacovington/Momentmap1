//
//  PAWSettingsViewController.m
//  Momentmap
//
//  Created by Kristina Covington on 3/10/15.
//  Copyright (c) 2015 Kristina Covington. All rights reserved.
//

//
//  PAWSettingsViewController.m
//  Anywall
//
//  Copyright (c) 2014 Parse Inc. All rights reserved.
//

#import "PAWSettingsViewController.h"

#import <Parse/Parse.h>
#import "FriendsViewController.h"
#import "PAWConstants.h"
#import "PAWConfigManager.h"
#import "UIImage+ResizeAdditions.h"

typedef NS_ENUM(uint8_t, PAWSettingsTableViewSection)
{
    PAWSettingsTableViewSectionDistance = 0,
    PAWSettingsTableViewSectionLogout,
    
    PAWSettingsTableViewNumberOfSections
};

static uint16_t const PAWSettingsTableViewLogoutNumberOfRows = 2;

@interface PAWSettingsViewController ()

@property (strong, nonatomic) IBOutlet UIButton *button;
@property (nonatomic, strong) NSArray *distanceOptions;
@property (nonatomic, assign) CLLocationAccuracy filterDistance;




@property (nonatomic, assign) UIBackgroundTaskIdentifier fileUploadBackgroundTaskId;
@property (nonatomic, assign) UIBackgroundTaskIdentifier photoPostBackgroundTaskId;


@property (nonatomic, strong) PFFile *photoFile;
@property NSArray *tableData;

@end

@implementation PAWSettingsViewController

#pragma mark -
#pragma mark Init

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        _filterDistance = [[NSUserDefaults standardUserDefaults] doubleForKey:PAWUserDefaultsFilterDistanceKey];
        [self loadAvailableDistanceOptions];
    }
    return self;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.imageView.layer.cornerRadius = 25;
    self.imageView.clipsToBounds = YES;
    [self.imageView.layer setBorderColor: [[UIColor whiteColor] CGColor]];
    [self.imageView.layer setBorderWidth: 2.0];
    
    self.tableData = [NSArray arrayWithObjects: @"Change profile photo", @"Save profile photo", @"Log out", @"Delete account", nil];
    self.name.text = [PFUser currentUser][@"publicUsername"];
    
    [self setProfile];
    
}

#pragma mark -
#pragma mark UIViewController

- (NSUInteger)supportedInterfaceOrientations {
    return UIInterfaceOrientationMaskPortrait;
}

- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation {
    return UIInterfaceOrientationPortrait;
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleDefault;
}

#pragma mark -
#pragma mark Accessors

- (void)setFilterDistance:(CLLocationAccuracy)filterDistance {
    if (self.filterDistance != filterDistance) {
        _filterDistance = filterDistance;
        
        [[NSUserDefaults standardUserDefaults] setDouble:filterDistance forKey:PAWUserDefaultsFilterDistanceKey];
        dispatch_async(dispatch_get_main_queue(), ^{
            [[NSNotificationCenter defaultCenter] postNotificationName:PAWFilterDistanceDidChangeNotification
                                                                object:nil
                                                              userInfo:@{ kPAWFilterDistanceKey : @(filterDistance) }];
        });
    }
}

#pragma mark -
#pragma mark UINavigationBar-based actions

-(void) setProfile {
    
    PFUser *user = [PFUser currentUser];
    
    PFFile *file = [user objectForKey:kPAPProfilePictureKey];
    
    if (!self.imageView.image){
        [file getDataInBackgroundWithBlock:^(NSData *data, NSError *error) {
            if (!error) {
                UIImage *fetchedImage = [UIImage imageWithData:data];
                // image can now be set on a UIImageView
                self.imageView.image = fetchedImage;
            }
        }];
    }
    else{
        
    }
}



- (IBAction)done:(id)sender {
    [self dismissViewControllerAnimated:NO completion:nil];
}



- (IBAction)save:(id)sender {
    
    PFUser *user = [PFUser currentUser];
    
    
    
    
    PFFile *file = self.photoFile;
    
    
    if (!self.photoFile) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Couldn't post your photo" message:nil delegate:nil cancelButtonTitle:nil otherButtonTitles:@"Dismiss", nil];
        [alert show];
        return;
    }
    
    [file saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if (error) {
            NSLog(@"Couldn't save!");
            NSLog(@"%@", error);
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:[error userInfo][@"error"]
                                                                message:nil
                                                               delegate:self
                                                      cancelButtonTitle:nil
                                                      otherButtonTitles:@"Ok", nil];
            [alertView show];
            return;
        }
        if (succeeded) {
            NSLog(@"Successfully saved!");
            NSLog(@"%@", file);
            
        } else {
            NSLog(@"Failed to save.");
        }
    }];
    
    
    
    
    [user setObject:file forKey:kPAPProfilePictureKey];
    [[PFUser currentUser] saveInBackground];
    NSLog(@"%@", user);
    
    
    
    
}


- (IBAction)change:(id)sender {
   // if (![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        /*
        UIAlertView *myAlertView = [[UIAlertView alloc] initWithTitle:@"Error"
                                                              message:@"Device has no camera"
                                                             delegate:nil
                                                    cancelButtonTitle:@"OK"
                                                    otherButtonTitles: nil];
        
        [myAlertView show];
        */
        
        UIImagePickerController *pickerController = [[UIImagePickerController alloc]
                                                     init];
        pickerController.delegate = self;
        [self presentModalViewController:pickerController animated:NO];
 /*
        
    } else {
        
        UIImagePickerController *picker = [[UIImagePickerController alloc] init];
        picker.delegate = self;
        //picker.allowsEditing = YES;
        picker.sourceType = UIImagePickerControllerSourceTypeCamera;
        
        [self presentViewController:picker animated:NO completion:NULL];
        
    }

   */
}

#pragma mark -
#pragma mark Data

- (void)loadAvailableDistanceOptions {
    NSMutableArray *distanceOptions = [[[PAWConfigManager sharedManager] filterDistanceOptions] mutableCopy];
    
    NSNumber *defaultFilterDistance = @(PAWDefaultFilterDistance);
    if (![distanceOptions containsObject:defaultFilterDistance]) {
        [distanceOptions addObject:defaultFilterDistance];
    }
    
    [distanceOptions sortUsingSelector:@selector(compare:)];
    
    self.distanceOptions = [distanceOptions copy];
}



#pragma mark -
#pragma mark UITableViewDelegate

#pragma mark -
#pragma mark UITableViewDataSource
/*
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return [self.tableData count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellID = @"cellID";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
    }
    
    
    if(indexPath.row == 0){
        cell.textLabel.text = @"Change profile photo";
    } else if (indexPath.row == 1){
        cell.textLabel.text = @"Save profile photo";

    } else if (indexPath.row == 2){
        cell.textLabel.text = @"Log out";

    } else {
        cell.textLabel.text = @"Delete account";

    }
    //cell.textLabel.text = [self.tableData objectAtIndex:indexPath.row];
    return cell;

 
}


- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    
    return nil;
}
*/
#pragma mark -
#pragma mark UITableViewDelegate

// Called after the user changes the selection.
- (void)tableView:(UITableView *)aTableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    //how about check icon instead
    
    //UITableViewCell *cell = [aTableView cellForRowAtIndexPath:indexPath];
    
    if(indexPath.row == 0){
        if (![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
            
            UIAlertView *myAlertView = [[UIAlertView alloc] initWithTitle:@"Error"
                                                                  message:@"Device has no camera"
                                                                 delegate:nil
                                                        cancelButtonTitle:@"OK"
                                                        otherButtonTitles: nil];
            
            [myAlertView show];
            
            
            UIImagePickerController *pickerController = [[UIImagePickerController alloc]
                                                         init];
            pickerController.delegate = self;
            [self presentModalViewController:pickerController animated:NO];
            
            
        } else {
            
            UIImagePickerController *picker = [[UIImagePickerController alloc] init];
            picker.delegate = self;
            //picker.allowsEditing = YES;
            picker.sourceType = UIImagePickerControllerSourceTypeCamera;
            
            [self presentViewController:picker animated:NO completion:NULL];
            
        }

    }
    else if (indexPath.row == 1) {
        
        PFUser *user = [PFUser currentUser];
        
        
        
        
        PFFile *file = self.photoFile;
        
        
        if (!self.photoFile) {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Couldn't post your photo" message:nil delegate:nil cancelButtonTitle:nil otherButtonTitles:@"Dismiss", nil];
            [alert show];
            return;
        }
        
        [file saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
            if (error) {
                NSLog(@"Couldn't save!");
                NSLog(@"%@", error);
                UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:[error userInfo][@"error"]
                                                                    message:nil
                                                                   delegate:self
                                                          cancelButtonTitle:nil
                                                          otherButtonTitles:@"Ok", nil];
                [alertView show];
                return;
            }
            if (succeeded) {
                NSLog(@"Successfully saved!");
                NSLog(@"%@", file);
                
            } else {
                NSLog(@"Failed to save.");
            }
        }];
        
        
        
        
        [user setObject:file forKey:kPAPProfilePictureKey];
        [[PFUser currentUser] saveInBackground];
        NSLog(@"%@", user);
        
        

        
    }
    else if (indexPath.row == 2) {
        
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Log out of Momentmap?"
                                                            message:nil
                                                           delegate:self
                                                  cancelButtonTitle:@"Log out"
                                                  otherButtonTitles:@"Cancel", nil];
        [alertView show];
    }
    
    else {
        
        
        UIAlertView *deleteAlertView = [[UIAlertView alloc] initWithTitle:@"Delete Account?"
                                                                  message:nil
                                                                 delegate:self
                                                        cancelButtonTitle:@"Delete"
                                                        otherButtonTitles:@"Cancel", nil];
        [deleteAlertView show];

    }
 
}



#pragma mark -
#pragma mark UIAlertViewDelegate

// Called when a button is clicked. The view will be automatically dismissed after this call returns
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    
   
        if (buttonIndex == alertView.cancelButtonIndex) {
            // Log out.
            [PFUser logOut];
        
            [self.delegate settingsViewControllerDidLogout:self];
        }
    

    
    
}

- (void)deleteAlertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    
    if (buttonIndex == alertView.cancelButtonIndex) {
        // Log out.
        [[PFUser currentUser] deleteInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
            // back to login view controller
        }];
        
        [self.delegate settingsViewControllerDidLogout:self];
    }
    
    
    
    
}



// Nil implementation to avoid the default UIAlertViewDelegate method, which says:
// "Called when we cancel a view (eg. the user clicks the Home button). This is not called when the user clicks the cancel button.
// If not defined in the delegate, we simulate a click in the cancel button"
// Since we have "Log out" at the cancel index (to get it out from the normal "Ok whatever get this dialog outta my face"
// position, we need to deal with the consequences of that.
- (void)alertViewCancel:(UIAlertView *)alertView {
    return;
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    
    UIImage *chosenImage = [info objectForKey:UIImagePickerControllerOriginalImage];
    
    chosenImage= [chosenImage thumbnailImage:172.0f
                           transparentBorder:0.0f
                                cornerRadius:2.0f
                        interpolationQuality:kCGInterpolationDefault];
    
    
    
    //image view that receives image
    self.imageView.image = chosenImage;
    
    [picker dismissViewControllerAnimated:NO completion:NULL];
    
    [self shouldUploadImage:chosenImage];
    
}

- (BOOL)shouldUploadImage:(UIImage *)anImage {
    
    
    
    // Get an NSData representation of our images. We use JPEG for the larger image
    // for better compression and PNG for the thumbnail to keep the corner radius transparency
    NSData *imageData = UIImageJPEGRepresentation(anImage, 1.6f);
    
    
    if (!imageData) {
        return NO;
    }
    
    
    self.photoFile = [PFFile fileWithData:imageData];
    
    
    // Request a background execution task to allow us to finish uploading the photo even if the app is backgrounded
    self.fileUploadBackgroundTaskId = [[UIApplication sharedApplication] beginBackgroundTaskWithExpirationHandler:^{
        [[UIApplication sharedApplication] endBackgroundTask:self.fileUploadBackgroundTaskId];
    }];
    
    NSLog(@"Requested background expiration task with id %lu for photo upload", (unsigned long)self.fileUploadBackgroundTaskId);
    [self.photoFile saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if (succeeded) {
            NSLog(@"Photo uploaded successfully");
            
        } else {
            [[UIApplication sharedApplication] endBackgroundTask:self.fileUploadBackgroundTaskId];
        }
    }];
    
    return YES;
}


- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    
    [picker dismissViewControllerAnimated:NO completion:NULL];
    
}

- (void)selectImage:(UIImage *)img
{
    NSLog(@"Image passed  %@", img); // This is the UIImage being passed.
    self.imageView.image = [img thumbnailImage:86.0f
                             transparentBorder:0.0f
                                  cornerRadius:0.0f
                          interpolationQuality:kCGInterpolationDefault];
    
    
    
    NSLog(@"Image in view  %@", self.imageView.image);
}

- (void)textViewDidBeginEditing:(UITextView *)textView
{
    if ([textView.text isEqualToString:@"Where are you?"]) {
        textView.text = nil;
        textView.textColor = [UIColor blackColor]; //optional
    }
    [textView becomeFirstResponder];
}

- (void)textViewDidEndEditing:(UITextView *)textView
{
    if ([textView.text isEqualToString:nil]) {
        textView.text = @"Where are you?";
        textView.textColor = [UIColor lightGrayColor]; //optional
    }
    [textView resignFirstResponder];
}



- (IBAction)logout:(id)sender {
    
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Log out of Momentmap?"
                                                        message:nil
                                                       delegate:self
                                              cancelButtonTitle:@"Log out"
                                              otherButtonTitles:@"Cancel", nil];
    [alertView show];

}
/*

- (IBAction)deleteAccount:(id)sender {
    
    UIAlertView *deleteAlertView = [[UIAlertView alloc] initWithTitle:@"Delete Account?"
                                                        message:nil
                                                       delegate:self
                                              cancelButtonTitle:@"Delete"
                                              otherButtonTitles:@"Cancel", nil];
    [deleteAlertView show];
}
 */

- (IBAction)friends:(id)sender {
    
    FriendsViewController *viewController = [[FriendsViewController alloc] initWithNibName:nil bundle:nil];
    //viewController.delegate = self;

   // viewController.delegate = self;
    
    
    [self presentViewController:viewController animated:NO completion:nil];
    
    //[self dismissViewControllerAnimated:NO completion:nil];

    
}

@end
