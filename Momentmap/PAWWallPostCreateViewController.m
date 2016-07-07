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

#import "PAWWallPostCreateViewController.h"

#import <Parse/Parse.h>

#import "PAWConstants.h"
#import "PAWConfigManager.h"

@interface PAWWallPostCreateViewController ()

@property (nonatomic, assign) NSUInteger maximumCharacterCount;

@property (nonatomic, assign) UIBackgroundTaskIdentifier fileUploadBackgroundTaskId;
@property (nonatomic, assign) UIBackgroundTaskIdentifier photoPostBackgroundTaskId;

@property (nonatomic, strong) PFFile *photoFile;


@end

@implementation PAWWallPostCreateViewController

#pragma mark -
#pragma mark Init

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        _maximumCharacterCount = [[PAWConfigManager sharedManager] postMaxCharacterCount];
    }
    return self;
}

#pragma mark -
#pragma mark UIViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //EDITED: putting image in imageview
    self.imageView.image = self.image;
    
    [self shouldUploadImage:self.image];

    
    UIView *accessoryView = [[UIView alloc] initWithFrame:CGRectMake(0.0f, 10.0f, 144.0f, 26.0f)];
    self.characterCountLabel = [[UILabel alloc] initWithFrame:CGRectMake(10.0f, 0.0f, 144.0f, 21.0f)];
    self.characterCountLabel.backgroundColor = [UIColor clearColor];
    self.characterCountLabel.textColor = [UIColor darkGrayColor];
    [accessoryView addSubview:self.characterCountLabel];
    
    self.textView.inputAccessoryView = accessoryView;
    
    [self updateCharacterCountLabel];
    [self checkCharacterCount];
     
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self.textView becomeFirstResponder];
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
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)postPost:(id)sender {
    // Resign first responder to dismiss the keyboard and capture in-flight autocorrect suggestions
    [self.textView resignFirstResponder];
    
    // Capture current text field contents:
    [self updateCharacterCountLabel];
    BOOL isAcceptableAfterAutocorrect = [self checkCharacterCount];
    
    if (!isAcceptableAfterAutocorrect) {
        [self.textView becomeFirstResponder];
        return;
    }
    
    // Data prep:
    CLLocation *currentLocation = [self.dataSource currentLocationForWallPostCrateViewController:self];
    CLLocationCoordinate2D currentCoordinate = currentLocation.coordinate;
    PFGeoPoint *currentPoint = [PFGeoPoint geoPointWithLatitude:currentCoordinate.latitude
                                                      longitude:currentCoordinate.longitude];
    PFUser *user = [PFUser currentUser];
    
    // Stitch together a postObject and send this async to Parse
    PFObject *postObject = [PFObject objectWithClassName:PAWParsePostsClassName];
    postObject[PAWParsePostTextKey] = self.textView.text;
    postObject[PAWParsePostUserKey] = user;
    postObject[PAWParsePostLocationKey] = currentPoint;
    
    // Use PFACL to restrict future modifications to this object.
    PFACL *readOnlyACL = [PFACL ACL];
    [readOnlyACL setPublicReadAccess:YES];
    [readOnlyACL setPublicWriteAccess:NO];
    postObject.ACL = readOnlyACL;
    
    
    
    PFFile *file = self.photoFile;
    
    
    
    if (!self.photoFile) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Couldn't post your photo" message:nil delegate:nil cancelButtonTitle:nil otherButtonTitles:@"Dismiss", nil];
        [alert show];
        return;
    }
    
    
    [postObject setObject:file forKey:kPAPPostPictureKey];
    [postObject saveInBackground];
    NSLog(@"%@", user);
    
    
    
    
    [postObject saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
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
            NSLog(@"%@", postObject);
            dispatch_async(dispatch_get_main_queue(), ^{
                [[NSNotificationCenter defaultCenter] postNotificationName:PAWPostCreatedNotification object:nil];
            });
        } else {
            NSLog(@"Failed to save.");
        }
    }];
    
    [self dismissViewControllerAnimated:YES completion:nil];
}


- (BOOL)shouldUploadImage:(UIImage *)anImage {
    
    
    
    // Get an NSData representation of our images. We use JPEG for the larger image
    // for better compression and PNG for the thumbnail to keep the corner radius transparency
    NSData *imageData = UIImageJPEGRepresentation(anImage, 0.8f);
    
    
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



//EDITED buttons

- (IBAction)takePhotoPost:(id)sender {

    
    if (![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        
        UIAlertView *myAlertView = [[UIAlertView alloc] initWithTitle:@"Error"
                                                              message:@"Device has no camera"
                                                             delegate:nil
                                                    cancelButtonTitle:@"OK"
                                                    otherButtonTitles: nil];
        
        [myAlertView show];
        
        
        
    } else {
        
        UIImagePickerController *picker = [[UIImagePickerController alloc] init];
        picker.delegate = self;
        //picker.allowsEditing = YES;
        picker.sourceType = UIImagePickerControllerSourceTypeCamera;
        
        [self presentViewController:picker animated:YES completion:NULL];
        
    }


}

//EDITED: Camera methods
#pragma mark - Image Picker Controller delegate methods

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    
    UIImage *chosenImage = info[UIImagePickerControllerEditedImage];
    
    //EDITED: set image
    if(chosenImage != NULL)
        self.image = chosenImage;

    
    [picker dismissViewControllerAnimated:YES completion:NULL];
    
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    
    [picker dismissViewControllerAnimated:YES completion:NULL];
    
}


#pragma mark -
#pragma mark UITextViewDelegate

- (void)textViewDidChange:(UITextView *)textView {
    [self updateCharacterCountLabel];
    [self checkCharacterCount];
}

#pragma mark -
#pragma mark Accessors

- (void)setMaximumCharacterCount:(NSUInteger)maximumCharacterCount {
    if (self.maximumCharacterCount != maximumCharacterCount) {
        _maximumCharacterCount = maximumCharacterCount;
        
        [self updateCharacterCountLabel];
        [self checkCharacterCount];
    }
}

#pragma mark -
#pragma mark Private

- (void)updateCharacterCountLabel {
    NSUInteger count = [self.textView.text length];
    self.characterCountLabel.text = [NSString stringWithFormat:@"%lu/%lu",
                                     (unsigned long)count,
                                     (unsigned long)self.maximumCharacterCount];
    if (count > self.maximumCharacterCount || count == 0) {
        self.characterCountLabel.font = [UIFont boldSystemFontOfSize:self.characterCountLabel.font.pointSize];
    } else {
        self.characterCountLabel.font = [UIFont systemFontOfSize:self.characterCountLabel.font.pointSize];
    }
}

- (BOOL)checkCharacterCount {
    BOOL enabled = NO;
    
    NSUInteger count = [self.textView.text length];
    if (count < self.maximumCharacterCount) {
        enabled = YES;
    }
    
    self.postButton.enabled = enabled;
    
    return enabled;
}

@end
