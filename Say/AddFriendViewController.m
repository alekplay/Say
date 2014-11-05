//
//  AddFriendViewController.m
//  Say
//
//  Created by Aleksander Skjølsvik on 01.11.14.
//  Copyright (c) 2014 alekApps. All rights reserved.
//

#import "AddFriendViewController.h"
#import <Parse/Parse.h>

typedef NS_OPTIONS(uint32_t, MenuState) {
    MenuStateIdle       = 0x1 << 0,
    MenuStateSearching  = 0x1 << 1,
    MenuStateQuerying   = 0x1 << 3,
    MenuStateInviting   = 0x1 << 4,
    MenuStateSharing    = 0x1 << 5,
};

@implementation AddFriendViewController {
    MenuState _currentState;
    UIActivityIndicatorView *_spinner;
    UILabel *_errorMessage;
}

#pragma mark STARTUP

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _currentState = MenuStateIdle;
    
    self.searchField.delegate = self;
}

- (void)resetView {
    _currentState = MenuStateIdle;
    
    [UIView animateWithDuration:0.5 animations:^{
        self.shareButton.alpha = 1.0;
        self.inviteButton.alpha = 1.0;
    }];
    
    self.searchButton.enabled = YES;
    self.searchField.hidden = YES;
    _errorMessage.hidden = YES;
}

#pragma mark ACTIONS

- (IBAction)searchAction:(id)sender {
    if (_currentState != MenuStateIdle) return;
    _currentState = MenuStateSearching;
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"pauseGestures" object:nil];
    
    [UIView animateWithDuration:0.2 animations:^{
        self.shareButton.alpha = 0.0;
        self.inviteButton.alpha = 0.0;
    }];
    self.inviteButton.enabled = NO;
    self.searchButton.enabled = NO;
    self.searchField.hidden = NO;
    [self.searchField becomeFirstResponder];
    
    _errorMessage = [[UILabel alloc] initWithFrame:CGRectMake(0, _searchButton.frame.origin.y + _searchButton.frame.size.height, self.view.frame.size.width, 50)];
    _errorMessage.font = [UIFont systemFontOfSize:20.0f];
    _errorMessage.textAlignment = NSTextAlignmentCenter;
    _errorMessage.hidden = YES;
    [self.view addSubview:_errorMessage];
}

- (IBAction)shareAction:(id)sender {
    
}

- (IBAction)inviteAction:(id)sender {
    
}

#pragma mark SEARCH

- (BOOL)existsUserWithName:(NSString *)username {
    PFQuery *searchQuery = [PFUser query];
    [searchQuery whereKey:@"username" equalTo:username];
    [searchQuery findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error) {
            if ([objects count] != 0) {
                NSLog(@"We found one!");
                
                if (![username isEqualToString:[[PFUser currentUser] username]]) {
                    _currentState = MenuStateIdle;
                    [self.searchField resignFirstResponder];
                    _errorMessage.text = [NSString stringWithFormat:@"You added %@!", username];
                
                    PFUser *friend = [objects firstObject];
                    [[PFUser currentUser] addObject:friend forKey:@"friends"];
                    [[PFUser currentUser] saveEventually];
                    
                    [UIView animateWithDuration:1.0 animations:^{
                        _errorMessage.alpha = 0.0;
                    } completion:^(BOOL finished) {
                        self.searchField.text = @"";
                        [self touchesBegan:nil withEvent:nil];
                    }];
                } else {
                    NSLog(@"Noooo, you can't add yourself!");
                    _currentState = MenuStateSearching;
                    
                    _errorMessage.text = [NSString stringWithFormat:@"You can't add yourself silly!"];
                    self.searchField.text = @"";
                }
            } else {
                NSLog(@"Naahhhh, not that one");
                _currentState = MenuStateSearching;
                
                _errorMessage.text = [NSString stringWithFormat:@"We couldn't find %@!", username];
                self.searchField.text = @"";
            }
            [_spinner stopAnimating];
            _errorMessage.hidden = NO;
        } else {
            NSLog(@"Error: %@", error);
            _currentState = MenuStateSearching;
            
            [_spinner stopAnimating];
            
            _errorMessage.text = [NSString stringWithFormat:@"An error occurred..."];
            _errorMessage.hidden = NO;
        }
    }];
    
    return YES;
}

#pragma mark TEXTFIELD DELEGATE

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    if (_currentState != MenuStateQuerying) {
        return YES;
    }
    
    return NO;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    if (_currentState != MenuStateSearching) return NO;
    _currentState = MenuStateQuerying;
    _errorMessage.hidden = YES;
    
    if (_spinner == nil) {
        _spinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        _spinner.center = CGPointMake(self.view.frame.size.width / 2, _searchButton.center.y + _searchButton.frame.size.height);
        _spinner.hidesWhenStopped = YES;
        [self.view addSubview:_spinner];
    }
    [_spinner startAnimating];
    
    NSString *username = textField.text;
    [self existsUserWithName:[username lowercaseString]];
    
    /*if (shouldReturn) {
        [textField resignFirstResponder];
        return YES;
    }*/
    
    return NO;
}

#pragma mark OTHER

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    _currentState = MenuStateIdle;
    
    [self.view endEditing:YES];
    [self resetView];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"resumeGestures" object:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
