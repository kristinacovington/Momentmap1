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

    NSLog(@"QUERY IT");

    [self queryIt];
    NSLog(@"QUERYED IT");

    
    self.sendButton.enabled = NO;
    self.sendButton.hidden = YES;
    //[self.sendButton setTitle:<#(nullable NSString *)#> forState:UIControlStateDisabled];
    

}

/*
-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:NO];
    [self queryIt];
}
*/
-(void)queryIt{
    
    NSLog(@"QUERYING IT");

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
    /*
    PFQuery *queryUserSent = [PFUser query];
    [queryUserSent whereKey:receivedKey equalTo: [PFUser currentUser]];
    
    [queryUserSent setLimit:1000];
    [queryUserSent findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error)
     {
         [self.sentRequestsArray addObjectsFromArray:objects];
     }];

    */
    
    //Finding who I sent requests to
    
    
   
    /*
    
    PFRelation *relationReceived = [[PFUser currentUser] objectForKey:receivedKey];
    PFQuery *queryReceived = [relationReceived query];
    [queryReceived setLimit:1000];
    [queryReceived findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error)
     {
         [self.sentRequestsArray addObjectsFromArray:objects];
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
/*
    for(PFUser *user in _receivedRequestsArray){
        if([user[receivedKey] containsObject: [PFUser currentUser]]){
            [_friendsArray addObject:user];
        }
    }
    */
    
    PFObject *friendships = [PFUser currentUser][@"Friendships"];
    //[friendships fetchIfNeeded];
    
    PFRelation *received = [friendships relationForKey:@"received"];
    PFRelation *sent = [friendships relationForKey:@"sent"];
    PFRelation *friends = [friendships relationForKey:@"friends"];
    
    NSLog(@"RECEIVE IT");

    PFQuery *queryReceived = [received query];
    [queryReceived setLimit:1000];
    NSArray *receivedObjects = [queryReceived findObjects];

    
         NSLog(@"RECEIVING IT");

         for(PFUser *object in receivedObjects){
             NSLog(@"RECEIVING OBJECT IT");
             NSLog(object[@"username"]);
             [self.receivedRequestsArray addObject:object];
             
         }
         
    
    
    NSLog(@"SENT IT");

    
    PFQuery *querySent = [sent query];
    [querySent setLimit:1000];
    NSArray *sentObjects = [querySent findObjects];

         NSLog(@"SENTING IT");

         
         for(PFUser *object in sentObjects){
             NSLog(@"SENTING OBJECT IT");
             NSLog(object[@"username"]);
             [self.sentRequestsArray addObject:object];
             
         }
         
         
    
    NSLog(@"FRIENDS IT");

    PFQuery *queryFriends = [friends query];
    [queryFriends setLimit:1000];
    NSArray *friendsObjects = [queryFriends findObjects];
   
         
         NSLog(@"FRIENDSING IT");

         for(PFUser *object in friendsObjects){
             NSLog(@"FRIENDSING OBJECT IT");
             NSLog(object[@"username"]);
             [self.friendsArray addObject:object];
             
         }
         
   
    
 

    for(PFUser *user in self.receivedRequestsArray){
        NSLog(@"RECEIVED ARRAY IT");
        NSLog(user[@"username"]);
        [self.tableArray addObject: user];
    }
    
    for(PFUser *user in self.friendsArray){
        NSLog(@"TABLE ARRAY IT");
        NSLog(user[@"username"]);

        [self.tableArray addObject: user];
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
    
    
   // [self.postObject saveInBackground];
    

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
    
    //UIViewController *vc = [self parentViewController];
    //[vc dismissModalViewControllerAnimated:YES];
    UIAlertView * sentAlert = [[UIAlertView alloc] initWithTitle:@"Sent!"
                                                         message:nil
                                                        delegate:self
                                               cancelButtonTitle:nil
                                               otherButtonTitles:nil];
    [sentAlert show];
    
    [self performSelector:@selector(dismissSentAlertView:) withObject:sentAlert afterDelay:1];
    

    
    [self dismissViewControllerAnimated:NO completion:nil];
    


    

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
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellID];
    }
    
   // cell.textLabel.text = @"TEST";
   // cell.textLabel.textAlignment = NSTextAlignmentLeft;


    if(tableView == self.searchDisplayController.searchResultsTableView){
        PFUser *userAtIndex = [self.searchResults objectAtIndex:indexPath.row];
        
        
        cell.textLabel.text = userAtIndex[@"username"];
        
        if([_friendsArray containsObject: userAtIndex] ){
            
            cell.detailTextLabel.text = @"friends";
            
        } else if ([_receivedRequestsArray containsObject: userAtIndex]  ){
            
            cell.detailTextLabel.text = @"received request";
            
        } else if ([_sentRequestsArray containsObject: userAtIndex] ) {
            
            cell.detailTextLabel.text = @"sent request";

        } else {
            
            cell.detailTextLabel.text = @"";

        }
        
    }
    else {

        PFUser *userAtIndex = [self.tableArray objectAtIndex:indexPath.row];
        NSLog(@"SHOWING TABLE ARRAY");
        for(PFUser *test in self.tableArray ){
            NSLog(test[@"username"]);
        }
        
        cell.textLabel.text = userAtIndex[@"username"];
        
        if([_friendsArray containsObject: userAtIndex] ){
            
            cell.detailTextLabel.text = @"friends";
            
        } else if ([_receivedRequestsArray containsObject: userAtIndex]  ){
            
            cell.detailTextLabel.text = @"received request";
            
        }
        
        
    }
 
       return cell;
}


- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    
    return nil;
}

#pragma mark -
#pragma mark UITableViewDelegate
-(void)dismissAlertView:(UIAlertView *)alertView{
    [alertView dismissWithClickedButtonIndex:0 animated:YES];
}

-(void)dismissSentAlertView:(UIAlertView *)alertView{
    [alertView dismissWithClickedButtonIndex:0 animated:YES];
    [self.navigationController popToRootViewControllerAnimated:YES];
}



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
        
        PFObject *currentUserFriendship = [PFUser currentUser][@"Friendships"];

        PFObject *userFriendship = user[@"Friendships"];
        //[currentUserFriendship fetchIfNeeded];

        //[userFriendship fetchIfNeeded];

        
        PFRelation *currentUserReceived = [currentUserFriendship relationForKey:@"received"];
        PFRelation *currentUserFriends = [currentUserFriendship relationForKey:@"friends"];
        PFRelation *currentUserSent = [currentUserFriendship relationForKey:@"sent"];

        PFRelation *userReceived = [userFriendship relationForKey:@"received"];
        PFRelation *userFriends = [userFriendship relationForKey:@"friends"];
        PFRelation *userSent = [userFriendship relationForKey:@"sent"];
        
     
        
    
        if([cell.detailTextLabel.text isEqualToString:@"received request"]){
            
           

            [currentUserReceived removeObject:user];

            
            [currentUserFriends addObject:user];
            
            [userSent removeObject: [PFUser currentUser]];
            [userFriends addObject: [PFUser currentUser]];
            
            if([_receivedRequestsArray containsObject:user] ){
                [_receivedRequestsArray removeObject: user];
            }
            
            [_friendsArray addObject:user];
            
            UIAlertView * friendAcceptedAlert = [[UIAlertView alloc] initWithTitle:@"Friend Request Accepted"
                                                             message:user[@"username"]
                                                            delegate:self
                                                   cancelButtonTitle:nil
                                                   otherButtonTitles:nil];
            [friendAcceptedAlert show];

            [self performSelector:@selector(dismissAlertView:) withObject:friendAcceptedAlert afterDelay:1];

            
        } else if ([cell.detailTextLabel.text isEqualToString:@"friends"]){
            
            if(self.postObject){
                PFRelation *viewers = [self.postObject relationForKey:@"Viewers"];

                [viewers addObject: user];
            }
            
        } else if ([cell.detailTextLabel.text isEqualToString:@"sent request"]){
            
            
        } else {
            [_sentRequestsArray addObject: user];
           

            [currentUserSent addObject:user];
            
            [userReceived addObject: [PFUser currentUser]];
            
            UIAlertView * sentRequestAlert = [[UIAlertView alloc] initWithTitle:@"Friend Request Sent"
                                                                           message:user[@"username"]
                                                                          delegate:self
                                                                 cancelButtonTitle:nil
                                                                 otherButtonTitles:nil];
            [sentRequestAlert show];
            
            [self performSelector:@selector(dismissAlertView:) withObject:sentRequestAlert afterDelay:1];
            
            
        }
        
        [userFriendship saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
            if (error) {
                NSLog(@"Couldn't save user friendship");
               
                return;
            }

        }];
        
       

        [currentUserFriendship saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
            if (error) {
                
                NSLog(@"Couldn't save current user friendship");
            
                return;
            }
            
        }];
        
        [aTableView deselectRowAtIndexPath:indexPath animated:YES];

        
    } else {
        
        PFUser *user = [_tableArray objectAtIndex:indexPath.row];
        
        PFObject *currentUserFriendship = [PFUser currentUser][@"Friendships"];
        
            PFObject *userFriendship = user[@"Friendships"];
        //[currentUserFriendship fetchIfNeeded];


        //[userFriendship fetchIfNeeded];

        
        
        PFRelation *currentUserReceived = [currentUserFriendship relationForKey:@"received"];
        PFRelation *currentUserFriends = [currentUserFriendship relationForKey:@"friends"];
        PFRelation *currentUserSent = [currentUserFriendship relationForKey:@"sent"];
        
        PFRelation *userReceived = [userFriendship relationForKey:@"received"];
        PFRelation *userFriends = [userFriendship relationForKey:@"friends"];
        PFRelation *userSent = [userFriendship relationForKey:@"sent"];
        
        if([cell.detailTextLabel.text isEqualToString:@"received request"]){
            
            
            
            [currentUserReceived removeObject:user];
            [currentUserFriends addObject:user];
            
            [userSent removeObject: [PFUser currentUser]];
            [userFriends addObject: [PFUser currentUser]];
            
            if([_receivedRequestsArray containsObject:user] ){
                [_receivedRequestsArray removeObject: user];
            }
            
            [_friendsArray addObject:user];
            
            UIAlertView * friendAcceptedAlert = [[UIAlertView alloc] initWithTitle:@"Friend Request Accepted"
                                                                           message:user[@"username"]
                                                                          delegate:self
                                                                 cancelButtonTitle:nil
                                                                 otherButtonTitles:nil];
            [friendAcceptedAlert show];
            
            [self performSelector:@selector(dismissAlertView:) withObject:friendAcceptedAlert afterDelay:1];
            
        } else if ([cell.detailTextLabel.text isEqualToString:@"friends"]){
            
            
            
            if(cell.accessoryType == UITableViewCellAccessoryCheckmark && self.postObject){
                cell.accessoryType = UITableViewCellAccessoryNone;

                PFRelation *viewers = [self.postObject relationForKey:@"Viewers"];
                
                [viewers addObject: user];
            
            }
            else if (cell.accessoryType == UITableViewCellAccessoryNone && self.postObject) {
                cell.accessoryType = UITableViewCellAccessoryCheckmark;
                
                PFRelation *viewers = [self.postObject relationForKey:@"Viewers"];
      
                [viewers removeObject: user];
                
                self.sendButton.enabled = YES;
                self.sendButton.hidden = NO;
                
                
            }


            
        }
        
        [userFriendship saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
            if (error) {
                NSLog(@"Couldn't save user friendship");
                
                return;
            }
            
        }];

        [currentUserFriendship saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
            if (error) {
                NSLog(@"Couldn't save current user friendship");
                
                return;
            }
            
        }];
        
        [aTableView deselectRowAtIndexPath:indexPath animated:YES];


        
    }
    
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
/*
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
        */
    

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
