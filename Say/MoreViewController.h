//
//  MoreViewController.h
//  Say
//
//  Created by Aleksander Skjølsvik on 01.11.14.
//  Copyright (c) 2014 alekApps. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MoreViewController : UIViewController

@property (strong, nonatomic) IBOutlet UIButton *editProfileButton;
@property (strong, nonatomic) IBOutlet UIButton *feedbackButton;
@property (strong, nonatomic) IBOutlet UIButton *logOutButton;

- (IBAction)editProfileAction:(id)sender;
- (IBAction)feedbackAction:(id)sender;
- (IBAction)logOutAction:(id)sender;

@end
