//
//  MainTableViewController.m
//  Say
//
//  Created by Aleksander Skjølsvik on 01.11.14.
//  Copyright (c) 2014 alekApps. All rights reserved.
//

#import "MainTableViewController.h"
#import <Parse/Parse.h>
#import "SuccessViewController.h"

typedef NS_OPTIONS(uint32_t, MenuState) {
    MenuStateLoadingUsers   = 0x1 << 0,
    MenuStatePickingUser    = 0x1 << 1,
    MenuStatePickingNotif   = 0x1 << 2,
    MenuStateSending        = 0x1 << 3,
};

@implementation MainTableViewController {
    NSMutableArray *_friends;
    NSMutableArray *_notifs;
    MenuState _currentState;
    
    PFUser *_pickedFriend;
}

#pragma mark STARTUP

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView.backgroundColor = [UIColor colorWithRed:223.0f/255.0f green:221.0f/255.0f blue:172.0f/255.0f alpha:1.0];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    if (![PFUser currentUser]) {
        UITableViewController *loginView = [self.storyboard instantiateViewControllerWithIdentifier:@"LoginController"];
        [self.navigationController presentViewController:loginView animated:NO completion:nil];
    } else {
        _currentState = MenuStateLoadingUsers;
        [self loadDataFromServer];
    }
}

#pragma mark SERVER

- (void)loadDataFromServer {
    PFQuery *query = [PFUser query];
    [query includeKey:@"friends"];
    [query whereKey:@"username" equalTo:[[PFUser currentUser] username]];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error) {
            _currentState = MenuStatePickingUser;
            
            PFUser *currentUser = [objects firstObject];
            _friends = [[NSMutableArray alloc] initWithArray:[currentUser objectForKey:@"friends"]];
            [self.tableView reloadData];
        } else {
            NSLog(@"Error: %@", error);
        }
    }];
}

#pragma mark TABLE VIEW

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    if (_currentState == MenuStatePickingNotif) {
        return 2;
    } else {
        return 1;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    if (_currentState == MenuStatePickingNotif) {
        if (section == 0) {
            return 1;
        } else {
            return [_notifs count];
        }
    } else {
        return [_friends count];
    }
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"reusableCell" forIndexPath:indexPath];
    cell.backgroundColor = [UIColor clearColor];
    
    UIImageView *av = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 275, 52)];
    av.backgroundColor = [UIColor clearColor];
    av.opaque = NO;
    av.image = [UIImage imageNamed:@"Button.png"];
    cell.backgroundView = av;
    
    if (_currentState == MenuStatePickingNotif) {
        if (indexPath.section == 0) {
            cell.textLabel.text = @"";
            
            UITextField *textField = [[UITextField alloc] initWithFrame:CGRectMake(20, 7, 280, 30)];
            textField.borderStyle = UITextBorderStyleRoundedRect;
            textField.tag = 10;
            [cell addSubview:textField];
        } else {
            cell.textLabel.text = [_notifs objectAtIndex:indexPath.row];
        }
    } else {
        [[cell viewWithTag:10] removeFromSuperview];
        PFUser *friend = [_friends objectAtIndex:indexPath.row];
        cell.textLabel.text = friend.username;
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (_currentState == MenuStatePickingNotif) {
        
        PFQuery *pushQuery = [PFInstallation query];
        [pushQuery whereKey:@"deviceType" equalTo:@"ios"];
        [pushQuery whereKey:@"user" equalTo:_pickedFriend];
        
        NSString *path = [[NSBundle mainBundle] pathForResource:@"notifsounds" ofType:@"plist"];
        NSDictionary *notifSounds = [[NSDictionary alloc] initWithContentsOfFile:path];
        NSDictionary *pickedThing = [notifSounds objectForKey:[[_notifs objectAtIndex:indexPath.row] lowercaseString]];
        
        NSString *message = [NSString stringWithFormat:@"%@: %@", [PFUser currentUser].username, [pickedThing objectForKey:@"text"]];
        NSString *sound = [pickedThing objectForKey:@"sound"];
        NSDictionary *data = [NSDictionary dictionaryWithObjectsAndKeys:
                              message, @"alert",
                              sound, @"sound",
                              @"Increment", @"badge",
                              nil];
        
        PFPush *push = [[PFPush alloc] init];
        [push setQuery:pushQuery];
        [push setData:data];
        [push sendPushInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
            if (!error) {
                SuccessViewController *svc = [self.storyboard instantiateViewControllerWithIdentifier:@"SuccessViewController"];
                svc.friendName = _pickedFriend.username;
                [self.navigationController presentViewController:svc animated:NO completion:nil];
                
                _currentState = MenuStatePickingUser;
                [self.tableView reloadData];
            } else {
                NSLog(@"Error: %@", error);
            }
        }];
    } else {
        PFUser *friend = [_friends objectAtIndex:indexPath.row];
        self.navigationItem.title = friend.username;
        _pickedFriend = friend;
    
        _currentState = MenuStatePickingNotif;
        _notifs = [[NSMutableArray alloc] initWithArray:@[@"COFFEE", @"LUNCH", @"DINNER", @"BEER", @"MOVIE"]];
        [self.tableView reloadData];
    }
}


/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

#pragma mark OTHER

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL)prefersStatusBarHidden {
    return YES;
}

@end
