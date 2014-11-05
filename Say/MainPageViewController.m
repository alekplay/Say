//
//  MainPageViewController.m
//  Say
//
//  Created by Aleksander Skjølsvik on 01.11.14.
//  Copyright (c) 2014 alekApps. All rights reserved.
//

#import "MainPageViewController.h"
#import "AddFriendViewController.h"
#import "MainTableViewController.h"
#import "MoreViewController.h"

@interface MainPageViewController ()

@end

@implementation MainPageViewController {
    NSArray *_viewControllers;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.delegate = self;
    self.dataSource = self;
    [self didMoveToParentViewController:self];
    UIStoryboard *sb = [self storyboard];
    MoreViewController *mvc = [sb instantiateViewControllerWithIdentifier:@"MoreViewController"];
    UINavigationController *mtvc = [sb instantiateViewControllerWithIdentifier:@"MainTableViewController"];
    AddFriendViewController *advc = [sb instantiateViewControllerWithIdentifier:@"AddFriendViewController"];
    
    _viewControllers = @[mvc, mtvc, advc];
    
    [self setViewControllers:@[mtvc] direction:UIPageViewControllerNavigationDirectionForward animated:NO completion:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(pauseGestures) name:@"pauseGestures" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(resumeGestures) name:@"resumeGestures" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(goToMainScreen) name:@"goToMainScreen" object:nil];
    
}

- (void)goToMainScreen {
    [self setViewControllers:@[[_viewControllers objectAtIndex:1]] direction:UIPageViewControllerNavigationDirectionForward animated:YES completion:nil];
}

- (void)pauseGestures {
    for (UIScrollView *view in self.view.subviews) {
        if ([view isKindOfClass:[UIScrollView class]]) {
            view.scrollEnabled = NO;
        }
    }
}

- (void)resumeGestures {
    for (UIScrollView *view in self.view.subviews) {
        if ([view isKindOfClass:[UIScrollView class]]) {
            view.scrollEnabled = YES;
        }
    }
}

#pragma mark PAGEVIEWCONTROLLER DELEGATE

- (UIViewController *)viewcontrollerAtIndex:(NSUInteger)index {
    return _viewControllers[index];
}

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(UIViewController *)viewController {
    NSUInteger currentIndex = [_viewControllers indexOfObject:viewController];
    
    if (currentIndex < [_viewControllers count] - 1) {
        return [_viewControllers objectAtIndex:currentIndex+1];
    } else {
        return nil;
    }
}

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(UIViewController *)viewController {
    NSUInteger currentIndex = [_viewControllers indexOfObject:viewController];
    
    if (currentIndex > 0) {
        return [_viewControllers objectAtIndex:currentIndex-1];
    } else {
        return nil;
    }
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
