//
//  SuccessViewController.m
//  Say
//
//  Created by Aleksander Skjølsvik on 02.11.14.
//  Copyright (c) 2014 alekApps. All rights reserved.
//

#import "SuccessViewController.h"

@interface SuccessViewController ()

@end

@implementation SuccessViewController

#pragma mark STARTUP

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [_successButton setTitle:[NSString stringWithFormat:@"YOUR SOMETHING WAS SENT TO %@", _friendName] forState:UIControlStateNormal];
}

#pragma mark ACTIONS

- (IBAction)successAction:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark OTHER

- (BOOL)prefersStatusBarHidden {
    return YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
