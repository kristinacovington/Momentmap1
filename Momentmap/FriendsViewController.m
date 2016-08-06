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


#import "PAWConstants.h"
#import "PAWConfigManager.h"

typedef NS_ENUM(uint8_t, PAWSettingsTableViewSection)
{
    PAWSettingsTableViewSectionDistance = 0,
    PAWSettingsTableViewSectionLogout,
    
    PAWSettingsTableViewNumberOfSections
};


@interface FriendsViewController ()

@property(strong, nonatomic) NSMutableArray *friendsArray;
@property(strong, nonatomic) NSMutableArray *receivedRequestsArray;
@property(strong, nonatomic) NSMutableArray *tableArray;

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
    
    self.tableArray = [[NSMutableArray alloc] init];


    self.searchResults = [[NSMutableArray alloc] init];


    [self queryIt];
    
    self.sendButton.enabled = NO;
    

}

/*
-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:NO];
    [self queryIt];
}
*/
-(void)queryIt{
   // [_friendsArray addObject:[PFUser currentUser]];
  /*  PFRelation *relation = [[PFUser currentUser] objectForKey:friendsKey];
    PFQuery *query = [relation query];
    [query setLimit:1000];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error)
     {
         [self.friendsArray addObjectsFromArray:objects];
    }];
  */
    //query.cachePolicy = kPFCachePolicyCacheElseNetwork;

    
    //Finding who sent requests to me
    
    PFQuery *queryUserSent = [PFUser query];
    [queryUserSent whereKey:receivedKey equalTo: [PFUser currentUser]];
    
    [queryUserSent setLimit:1000];
    [queryUserSent findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error)
     {
         [self.sentRequestsArray addObjectsFromArray:objects];
     }];

    
    
    //Finding who I sent requests to
    
    PFRelation *relationReceived = [[PFUser currentUser] objectForKey:receivedKey];
    PFQuery *queryReceived = [relationReceived query];
    [queryReceived setLimit:1000];
    [queryReceived findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error)
     {
         [self.receivedRequestsArray addObjectsFromArray:objects];
     }];
    
    //queryReceived.cachePolicy = kPFCachePolicyCacheElseNetwork;
/*
    
    PFRelation *relationSent = [[PFUser currentUser] objectForKey:sentKey];
    PFQuery *querySent = [relationSent query];
    [querySent setLimit:1000];
    [querySent findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error)
     {
         [self.sentRequestsArray addObjectsFromArray:objects];
     }];
  */
    //querySent.cachePolicy = kPFCachePolicyCacheElseNetwork;

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
    [self dismissViewControllerAnimated:NO completion:nil];
}

- (IBAction)send:(id)sender {
    
    
    [self.postObject saveInBackground];
    

    [self.postObject saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
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
            NSLog(@"%@", self.postObject);
            dispatch_async(dispatch_get_main_queue(), ^{
                [[NSNotificationCenter defaultCenter] postNotificationName:PAWPostCreatedNotification object:nil];
            });
        } else {
            NSLog(@"Failed to save.");
        }
    }];
    
    UIViewController *vc = [self parentViewController];

    [self dismissViewControllerAnimated:NO completion:nil];
    [vc dismissModalViewControllerAnimated:NO];

    

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
//add received too
        
        return [_tableArray count];
    
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


    if(tableView == self.searchDisplayController.searchResultsTableView){
        
        cell.textLabel.text = [self.searchResults objectAtIndex:indexPath.row][@"username"];
        
        if([[self.searchResults objectAtIndex:indexPath.row][receivedKey] containsObject: [PFUser currentUser]] &&  [[PFUser currentUser][receivedKey] containsObject: [self.searchResults objectAtIndex:indexPath.row]]){
            
            cell.detailTextLabel.text = @"friends";
            
        } else if ([[self.searchResults objectAtIndex:indexPath.row][receivedKey] containsObject: [PFUser currentUser]] ){
            
            cell.detailTextLabel.text = @"received request";
        } else if ([[PFUser currentUser][receivedKey] containsObject: [self.searchResults objectAtIndex:indexPath.row]]) {
            
            cell.detailTextLabel.text = @"sent request";

        } else {
            
            cell.detailTextLabel.text = @"";

        }
    }
    else {
        int count = 0;

        if([_friendsArray count] >= indexPath.row){
            for(PFUser *user in _receivedRequestsArray) {
                
                if(![_friendsArray containsObject:user]) {
                    cell.textLabel.text = user.username;
                    cell.detailTextLabel.text = @"received";
                    count++;
                    
                    [_tableArray addObject:user];
                }
                
            }
   
        } else{
        
        PFUser *user = [_friendsArray objectAtIndex:indexPath.row - count][@"username"];
        cell.textLabel.text = user.username;
        cell.detailTextLabel.text = @"friends";
        
        [_tableArray addObject: _friendsArray];
        }
        
        
        
        
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
   
    //how about check icon instead
    
    UITableViewCell *cell = [aTableView cellForRowAtIndexPath:indexPath];

    //if(cell.imageView)
    //etc
    //learn how to add user to relation or submit post from here
    //instead of below

    if(aTableView == self.searchDisplayController.searchResultsTableView){
        PFUser *user = [_searchResults objectAtIndex:indexPath.row];
        
      /*
        if([_friendsArray containsObject:user]) {
            
        }
        else if ( [_receivedRequestsArray containsObject:user] ) {
            PFRelation *relation = [[PFUser currentUser] relationForKey:friendsKey];
            [relation addObject: user];
            
            PFRelation *relation2 = [user relationForKey:friendsKey];
            [relation2 addObject: [PFUser currentUser]];
            
            [user saveInBackground];

            [[PFUser currentUser] saveInBackground];

        }
        else if ( [_sentRequestsArray containsObject:user] ) {
            
        }
        else {
            PFRelation *relation = [[PFUser currentUser] relationForKey:sentKey];
            [relation addObject: user];
            
            PFRelation *relation2 = [user relationForKey:receivedKey];
            [relation2 addObject: [PFUser currentUser] ];
            
            [user saveInBackground];
            
            [[PFUser currentUser] saveInBackground];
        }
    }
    else {
       
       */
        //PFUser *user = [_tableArray objectAtIndex:indexPath.row];

        if([cell.detailTextLabel.text isEqualToString:@"received request"]){
            
            [[PFUser currentUser][receivedKey] addObject:user];
        
            PFRelation *relation = [self.postObject relationForKey:@"Viewers"];
            [relation addObject: user];

            
        }
        
        if([cell.detailTextLabel.text isEqualToString:@"friends"]){
            
            
            PFRelation *relation = [self.postObject relationForKey:@"Viewers"];
            [relation addObject: user];
        }
        
    }
    
    else {
        
        PFUser *user = [_tableArray objectAtIndex:indexPath.row];

        if([cell.detailTextLabel.text isEqualToString:@"received request"]){
            
            [[PFUser currentUser][receivedKey] addObject:user];
            
            PFRelation *relation = [self.postObject relationForKey:@"Viewers"];
            [relation addObject: user];
            
            
        }
        
        if([cell.detailTextLabel.text isEqualToString:@"friends"]){
            
            
            PFRelation *relation = [self.postObject relationForKey:@"Viewers"];
            [relation addObject: user];
        }
        
        
                       
    }
        
    

    //}
 /*
    if(_friendsArray != Nil){
        //This is the user(s) to set the post to
        //TODO send post ref to this viewcontroller
        //PFUser *user = [_friendsArray objectAtIndex:indexPath.row];
    }
  */
}

-(void)filterResults:(NSString *)searchTerm  {
    [self.searchResults removeAllObjects];
    
    NSMutableArray *newSearchArray = [[NSMutableArray alloc] init];
    //PFQuery *query = [PFUser query];
    
    PFQuery *queryCapitalizedString = [PFUser query];
    [queryCapitalizedString whereKey:@"username" containsString:[searchTerm capitalizedString]];
    
    //query converted user text to lowercase
    PFQuery *queryLowerCaseString = [PFUser query];
    [queryLowerCaseString whereKey:@"username" containsString:[searchTerm lowercaseString]];
    
    //query real user text
    PFQuery *querySearchBarString = [PFUser query];
    [querySearchBarString whereKey:@"username" containsString:searchTerm];
    
    PFQuery *query = [PFQuery orQueryWithSubqueries:[NSArray arrayWithObjects:queryCapitalizedString,queryLowerCaseString, querySearchBarString,nil]];
    
   
    //query.cachePolicy = kPFCachePolicyCacheElseNetwork;

    //[query whereKey:@"username" containsString:[searchTerm lowercaseString]];
   // [query whereKey:@"username" containsString:searchTerm];
   // [query whereKey:@"username" containsString:[searchTerm uppercaseString]];


    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        
        for(PFUser *user in objects){
           // NSLog(@"USERNAME");
           // NSLog(user[@"username"]);
            if(![newSearchArray containsObject:user])
                 [newSearchArray addObject:user];
        }
        
        //[self.searchResults addObjectsFromArray:objects];
        self.searchResults = newSearchArray;
        [self.searchDisplayController.searchResultsTableView reloadData];

        
    }];
    
    
}


-(BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchString:(NSString *)searchString
{
    [self filterResults:searchString];

    return YES;
}
@end
