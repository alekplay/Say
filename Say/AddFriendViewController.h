//
//  AddFriendViewController.h
//  Say
//
//  Created by Aleksander Skjølsvik on 01.11.14.
//  Copyright (c) 2014 alekApps. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AddFriendViewController : UIViewController <UITextFieldDelegate>

@property (strong, nonatomic) IBOutlet UIButton *searchButton;
@property (strong, nonatomic) IBOutlet UIButton *shareButton;
@property (strong, nonatomic) IBOutlet UIButton *inviteButton;
@property (strong, nonatomic) IBOutlet UITextField *searchField;

- (IBAction)searchAction:(id)sender;
- (IBAction)shareAction:(id)sender;
- (IBAction)inviteAction:(id)sender;

@end
