//
//  FriendsViewController.m
//  Momentmap
//
//  Created by Kristina Covington on 6/30/16.
//  Copyright © 2016 Kristina Covington. All rights reserved.
//

//
//  PAWSettingsViewController.m
//  Momentmap
//
//  Created by Kristina Covington on 6/25/16.
//  Copyright © 2016 Kristina Covington. All rights reserved.
//

#import "FriendsViewController.h"

#import <Parse/Parse.h>

#import "PAWConstants.h"
#import "PAWConfigManager.h"

typedef NS_ENUM(uint8_t, PAWSettingsTableViewSection)
{
    PAWSettingsTableViewSectionDistance = 0,
    PAWSettingsTableViewSectionLogout,
    
    PAWSettingsTableViewNumberOfSections
};

static uint16_t const PAWSettingsTableViewLogoutNumberOfRows = 1;

@interface FriendsViewController ()

@property(strong, nonatomic) NSMutableArray *friendsArray;
@property(strong, nonatomic) NSMutableArray *receivedRequestsArray;
@property(strong, nonatomic) NSMutableArray *sentRequestsArray;
@property(strong, nonatomic) NSMutableArray *searchResults;


@end

@implementation FriendsViewController

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
    
    self.friendsArray = [[NSMutableArray alloc] init];
    self.receivedRequestsArray = [[NSMutableArray alloc] init];
    self.sentRequestsArray = [[NSMutableArray alloc] init];

    self.searchResults = [[NSMutableArray alloc] init];


    [self queryIt];


}

/*
-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:NO];
    [self queryIt];
}
*/
-(void)queryIt{
   // [_friendsArray addObject:[PFUser currentUser]];
    PFRelation *relation = [[PFUser currentUser] objectForKey:friendsKey];
    PFQuery *query = [relation query];
    [query setLimit:1000];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error)
     {
         [self.friendsArray addObjectsFromArray:objects];
    }];
    
    query.cachePolicy = kPFCachePolicyCacheElseNetwork;

    
    PFRelation *relationReceived = [[PFUser currentUser] objectForKey:receivedKey];
    PFQuery *queryReceived = [relationReceived query];
    [queryReceived setLimit:1000];
    [queryReceived findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error)
     {
         [self.receivedRequestsArray addObjectsFromArray:objects];
     }];
    
    queryReceived.cachePolicy = kPFCachePolicyCacheElseNetwork;

    
    PFRelation *relationSent = [[PFUser currentUser] objectForKey:sentKey];
    PFQuery *querySent = [relationSent query];
    [querySent setLimit:1000];
    [querySent findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error)
     {
         [self.sentRequestsArray addObjectsFromArray:objects];
     }];
    
    querySent.cachePolicy = kPFCachePolicyCacheElseNetwork;

    for(PFUser *user in _receivedRequestsArray){
        if([_sentRequestsArray containsObject: user]){
            [_friendsArray addObject:user];
        }
    }
    
    
}


#pragma mark -
#pragma mark UIViewController

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

- (IBAction)done:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}


#pragma mark -
#pragma mark UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if(tableView == self.searchDisplayController.searchResultsTableView){
        
        return [self.searchResults count];
    }
    else {

        return [_friendsArray count];
    
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellID = @"cellID";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
    }
    
    cell.textLabel.text = @"TEST";
    cell.textLabel.textAlignment = NSTextAlignmentLeft;
    cell.accessoryType = UITableViewCellAccessoryCheckmark;


    if(tableView == self.searchDisplayController.searchResultsTableView){
        cell.textLabel.text = [self.searchResults objectAtIndex:indexPath.row];
    }
    else {
        PFUser *user = [_friendsArray objectAtIndex:indexPath.row];
        cell.textLabel.text = user.username;
    }
 
       return cell;
}


- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    
    return nil;
}

#pragma mark -
#pragma mark UITableViewDelegate

// Called after the user changes the selection.
- (void)tableView:(UITableView *)aTableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if(_friendsArray != Nil){
        //This is the user(s) to set the post to
        //TODO send post ref to this viewcontroller
        //PFUser *user = [_friendsArray objectAtIndex:indexPath.row];
    }
}

-(void)filterResults:(NSString *)searchTerm  {
    [self.searchResults removeAllObjects];
    PFQuery *query = [PFUser query];
   
    //query.cachePolicy = kPFCachePolicyCacheElseNetwork;

    [query whereKey:@"username" containsString:[searchTerm lowercaseString]];
    
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        
        for(PFUser *user in objects){
            NSLog(@"USERNAME");
            NSLog(user[@"username"]);
            if(![self.searchResults containsObject:user[@"username"]])
                 [self.searchResults addObject:user[@"username"]];
        }
        
        //[self.searchResults addObjectsFromArray:objects];
        [self.searchDisplayController.searchResultsTableView reloadData];

        
    }];
    
    
}


-(BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchString:(NSString *)searchString
{
    [self filterResults:searchString];

    return YES;
}
@end
