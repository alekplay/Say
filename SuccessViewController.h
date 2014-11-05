//
//  SuccessViewController.h
//  Say
//
//  Created by Aleksander Skjølsvik on 02.11.14.
//  Copyright (c) 2014 alekApps. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SuccessViewController : UIViewController

@property (strong, nonatomic) NSString *friendName;

@property (strong, nonatomic) IBOutlet UIButton *successButton;

- (IBAction)successAction:(id)sender;

@end
