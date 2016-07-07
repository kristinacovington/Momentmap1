//
//  PAWPost.m
//  Momentmap
//
//  Created by Kristina Covington on 6/25/16.
//  Copyright © 2016 Kristina Covington. All rights reserved.
//

#import "PAWPost.h"

#import "PAWConstants.h"

@interface PAWPost ()

@property (nonatomic, assign) CLLocationCoordinate2D coordinate;

@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *subtitle;

@property (nonatomic, strong) PFObject *object;
@property (nonatomic, strong) PFUser *user;
@property (nonatomic, assign) MKPinAnnotationColor pinColor;



@end

@implementation PAWPost

#pragma mark -
#pragma mark Init

- (instancetype)initWithCoordinate:(CLLocationCoordinate2D)coordinate
                          andTitle:(NSString *)title
                       andSubtitle:(NSString *)subtitle {
    self = [super init];
    if (self) {
        self.coordinate = coordinate;
        self.subtitle = title;
        self.title = subtitle;
    }
    return self;
}

- (instancetype)initWithPFObject:(PFObject *)object {
    PFGeoPoint *geoPoint = object[PAWParsePostLocationKey];
    CLLocationCoordinate2D coordinate = CLLocationCoordinate2DMake(geoPoint.latitude, geoPoint.longitude);
    NSString *title = object[PAWParsePostTextKey];
    NSString *subtitle = object[PAWParsePostUserKey][PAWParsePostNameKey] ?: object[PAWParsePostUserKey][PAWParsePostUsernameKey];

    self = [self initWithCoordinate:coordinate andTitle:title andSubtitle:subtitle];
    if (self) {
        self.object = object;
        self.user = object[PAWParsePostUserKey];
        
        //PFFile *photoFile = self.object[kPAPPostPictureKey];
        PFFile *profileFile = self.user[kPAPProfilePictureKey];
        
        //self.photo = [UIImage imageWithData:photoFile];
        [profileFile getDataInBackgroundWithBlock:^(NSData *data, NSError *error) {
            if (!error) {
                self.profile = [UIImage imageWithData:data];
                // image can now be set on a UIImageView
            }
        }];
    }
    /*
    PFFile *photoFile = object[kPAPPostPictureKey];
    PFFile *profileFile = self.user[kPAPProfilePictureKey];
    
    self.photo = [UIImage imageWithData:photoFile];
    self.profile = [UIImage imageWithData:profileFile];
    */
    
    return self;
}

#pragma mark -
#pragma mark Equal

- (BOOL)isEqual:(id)other {
    if (![other isKindOfClass:[PAWPost class]]) {
        return NO;
    }
    
    PAWPost *post = (PAWPost *)other;
    
    if (post.object && self.object) {
        // We have a PFObject inside the PAWPost, use that instead.
        return [post.object.objectId isEqualToString:self.object.objectId];
    }
    
    // Fallback to properties
    return ([post.title isEqualToString:self.title] &&
            [post.subtitle isEqualToString:self.subtitle] &&
            post.coordinate.latitude == self.coordinate.latitude &&
            post.coordinate.longitude == self.coordinate.longitude);
}

#pragma mark -
#pragma mark Accessors

- (void)setTitleAndSubtitleOutsideDistance:(BOOL)outside {
    if (outside) {
        self.title = kPAWWallCantViewPost;
        self.subtitle = nil;
        self.pinColor = MKPinAnnotationColorRed;
    } else {
        self.title = self.object[PAWParsePostTextKey];
        self.subtitle = self.object[PAWParsePostUserKey][PAWParsePostNameKey] ?:
        self.object[PAWParsePostUserKey][PAWParsePostUsernameKey];
        self.pinColor = MKPinAnnotationColorGreen;
    }
}

@end
