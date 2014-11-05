//
//  MoreViewController.m
//  Say
//
//  Created by Aleksander Skjølsvik on 01.11.14.
//  Copyright (c) 2014 alekApps. All rights reserved.
//

#import "MoreViewController.h"
#import <Parse/Parse.h>

@interface MoreViewController ()

@end

@implementation MoreViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)editProfileAction:(id)sender {
}

- (IBAction)feedbackAction:(id)sender {
}

- (IBAction)logOutAction:(id)sender {
    [[NSNotificationCenter defaultCenter] postNotificationName:@"goToMainScreen" object:nil];
    
    [PFUser logOut];
        
    UITableViewController *loginView = [self.storyboard instantiateViewControllerWithIdentifier:@"LoginController"];
    [self.navigationController presentViewController:loginView animated:YES completion:nil];
}
@end
