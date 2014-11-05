//
//  LoginViewController.m
//  Say
//
//  Created by Aleksander Skjølsvik on 01.11.14.
//  Copyright (c) 2014 alekApps. All rights reserved.
//

#import "LoginViewController.h"
#import <Parse/Parse.h>

@interface LoginViewController ()

@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _usernameTextField.delegate = self;
    _passwordTextField.delegate = self;
}

- (IBAction)login:(id)sender {
    if (![self.usernameTextField.text isEqualToString:@""] && self.usernameTextField.text != nil && ![self.passwordTextField.text isEqualToString:@""] && self.passwordTextField.text != nil) {
        
        self.loginButton.enabled = NO;
        
        NSString *userName = [self.usernameTextField.text lowercaseString];
        NSString *password = self.passwordTextField.text;
        
        [PFUser logInWithUsernameInBackground:userName password:password block:^(PFUser *user, NSError *error) {
            if (!error) {
                    NSLog(@"Successfully logged in!");
                    
                    PFInstallation *installation = [PFInstallation currentInstallation];
                    installation[@"user"] = [PFUser currentUser];
                    [installation saveInBackground];
                    
                    [self dismissViewControllerAnimated:YES completion:nil];
            } else {
                if (error.code == 101) {
                    NSLog(@"User with combination not found");
                    
                    PFQuery *query = [PFUser query];
                    [query whereKey:@"username" equalTo:userName];
                    [query countObjectsInBackgroundWithBlock:^(int number, NSError *error) {
                        if (!error) {
                            if (number == 0) {
                                PFUser *newUser = [PFUser user];
                                newUser.username = userName;
                                newUser.password = password;
                                [self signUpUser:newUser];
                            } else {
                                NSLog(@"Username and password combination is incorrect!");
                                self.loginButton.enabled = YES;
                            }
                        } else {
                            NSLog(@"Error: %@", error);
                            self.loginButton.enabled = YES;
                        }
                    }];
                } else {
                    NSLog(@"Error: %@", error);
                    self.loginButton.enabled = YES;
                }
            }
        }];
    } else {
        NSLog(@"Fill in both fields");
    }
}

- (void)signUpUser:(PFUser *)user {
    [user signUpInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if (!error) {
            NSLog(@"You signed up successfully!");
            
            PFInstallation *installation = [PFInstallation currentInstallation];
            installation[@"user"] = [PFUser currentUser];
            [installation saveInBackground];
            
            [self dismissViewControllerAnimated:YES completion:nil];
        } else {
            NSLog(@"Error: %@", error);
            self.loginButton.enabled = YES;
        }
    }];
}

#pragma mark TEXTFIELD DELEGATE

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    NSInteger nextTag = textField.tag + 1;
    
    UIResponder *nextResponder = [textField.superview viewWithTag:nextTag];
    if (nextResponder) {
        [nextResponder becomeFirstResponder];
    } else {
        [textField resignFirstResponder];
    }
    
    return NO;
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
