//
//  PAWAppDelegate.m
//  Momentmap
//
//  Created by Kristina Covington on 6/25/16.
//  Copyright © 2016 Kristina Covington. All rights reserved.
//

#import "PAWAppDelegate.h"
#import <Parse/Parse.h>
#import <ParseFacebookUtilsV4/PFFacebookUtils.h>
#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import "PAWConstants.h"
#import "PAWConfigManager.h"
#import "PAWLoginViewController.h"
#import "PAWSettingsViewController.h"
#import "PAWWallViewController.h"

@interface PAWAppDelegate ()
<PAWLoginViewControllerDelegate,
PAWWallViewControllerDelegate,
PAWSettingsViewControllerDelegate>

@end

@implementation PAWAppDelegate

#pragma mark -
#pragma mark UIApplicationDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    // ****************************************************************************
    // Parse initialization
    [Parse setApplicationId:@"q5pHAN13XctkfVgn7ys6NmwJZhN6mKAgUxQUN2ve" clientKey:@"5cf97LADTGabos3OPsaa9k53HO8Wzcqpy5pzRj0B"];
   
    // PFFacebookUtils initialization
    [PFFacebookUtils initializeFacebookWithApplicationLaunchOptions:launchOptions];
    // ****************************************************************************
    
    // Set the global tint on the navigation bar
    [[UINavigationBar appearance] setTintColor:[UIColor colorWithRed:0.0 green:0.0f blue:0.0f alpha:1.0f]];
    [[UINavigationBar appearance] setTranslucent:NO];

    
    // Setup default NSUserDefaults
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    if ([userDefaults objectForKey:PAWUserDefaultsFilterDistanceKey] == nil) {
        // If we have no accuracy in defaults, set it to 1000 feet.
        [userDefaults setDouble:PAWFeetToMeters(PAWDefaultFilterDistance) forKey:PAWUserDefaultsFilterDistanceKey];
    }
    
    self.navigationController = [[UINavigationController alloc] initWithRootViewController:[[UIViewController alloc] init]];
    
    if ([PFUser currentUser]) {
        // Present wall straight-away
        [self presentWallViewControllerAnimated:YES];
    } else {
        // Go to the welcome screen and have them log in or create an account.
        [self presentLoginViewController];
    }
    
    [PFAnalytics trackAppOpenedWithLaunchOptions:launchOptions];
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.rootViewController = self.navigationController;
    [self.window makeKeyAndVisible];
    
    [[PAWConfigManager sharedManager] fetchConfigIfNeeded];
    
    return YES;
}

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation {
    return [[FBSDKApplicationDelegate sharedInstance] application:application
                                                          openURL:url
                                                sourceApplication:sourceApplication
                                                       annotation:annotation
            ];
}

- (void)applicationWillTerminate:(UIApplication *)application {
    [[NSUserDefaults standardUserDefaults] synchronize];
}

#pragma mark -
#pragma mark LoginViewController

- (void)presentLoginViewController {
    // Go to the welcome screen and have them log in or create an account.
    PAWLoginViewController *viewController = [[PAWLoginViewController alloc] initWithNibName:nil bundle:nil];
    viewController.delegate = self;
    [self.navigationController setViewControllers:@[ viewController ] animated:NO];
}

#pragma mark Delegate

- (void)loginViewControllerDidLogin:(PAWLoginViewController *)controller {
    [self presentWallViewControllerAnimated:YES];
}

#pragma mark -
#pragma mark WallViewController

- (void)presentWallViewControllerAnimated:(BOOL)animated {
    PAWWallViewController *wallViewController = [[PAWWallViewController alloc] initWithNibName:nil bundle:nil];
    wallViewController.delegate = self;
    [self.navigationController setViewControllers:@[ wallViewController ] animated:animated];
}

#pragma mark Delegate

- (void)wallViewControllerWantsToPresentSettings:(PAWWallViewController *)controller {
    [self presentSettingsViewController];
}

#pragma mark -
#pragma mark SettingsViewController

- (void)presentSettingsViewController {
    PAWSettingsViewController *settingsViewController = [[PAWSettingsViewController alloc] initWithNibName:nil bundle:nil];
    settingsViewController.delegate = self;
    settingsViewController.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
    [self.navigationController presentViewController:settingsViewController animated:NO completion:nil];
}

#pragma mark Delegate

- (void)settingsViewControllerDidLogout:(PAWSettingsViewController *)controller {
    [controller dismissViewControllerAnimated:NO completion:nil];
    [self presentLoginViewController];
}

@end
